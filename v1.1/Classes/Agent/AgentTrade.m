//
//  AgentTrade.m
//  Ciptadana
//
//  Created by Reyhan on 6/17/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AgentTrade.h"
#import "GCDAsyncSocket.h"
#import "UIBAlertView.h"
#import "Connectivity.h"
#import "AbstractViewController.h"
#import "TabViewController.h"
#import "ConstractOrder.h"
#import "UIViewController+Controller.h"
#import "ViewController.h"
#import "LoginMiViewController.h"


static AgentTrade *agentTrade;

@interface AgentTrade () <GCDAsyncSocketDelegate>


@property GCDAsyncSocket *asyncSocket;
@property (assign, nonatomic) id objectSelector;
@property (assign, nonatomic) SEL selector;
@property (nonatomic, copy) AgentTradeCallback agentTradeCallback;
@property (nonatomic) LoginData *loginFeed;
@property (nonatomic) LoginData *loginTrade;
@property (nonatomic) NSArray *arrayClientlist;
@property (nonatomic) NSMutableDictionary *orderDictionary;
@property (nonatomic) NSMutableDictionary *tradeDictionary;
@property (nonatomic) NSTimer *pulseTimer;


- (void)runAgent;

@end

@implementation AgentTrade

+ (AgentTrade *)sharedInstance
{
    if (nil == agentTrade) {
        NSLog(@"%s %@:%i", __PRETTY_FUNCTION__, AGENTTRADE_HOST, AGENTTRADE_PORT);
        agentTrade = [[AgentTrade alloc] init];
    }
    
    return agentTrade;
}

#pragma mark -
#pragma private method

- (void)pulseGetSession
{
    if (nil != agentTrade.loginFeed) {
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetStatusSession;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        
        if (nil != agentTrade.loginTrade) {
            builder.sessionOl = agentTrade.loginTrade.sessionOl;
        }
        
        [agentTrade subscribeBuidler:builder];
    }

//    [agentTrade subscribe:RecordTypeGetStatusSession requestType:RequestGet];
}

- (void)forcelogout
{
    UIViewController *v = [self topViewController];
    
    if (nil != v && [v isMemberOfClass:[ViewController class]]) {
        [v dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        [self performSelector:@selector(forcelogout) withObject:nil];
    }
}

- (UIViewController *)topViewController
{
    UIViewController *v = [UIApplication sharedApplication].keyWindow.rootViewController;
    return v;
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}


- (void)logoutAlert:(NSString *)title message:(NSString *)msg idle:(BOOL)idle
{
    NSLog(@"Nyoman Unik1 %@",msg);
    NSLog(@"%s title: %@, message: %@", __PRETTY_FUNCTION__, title, msg);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [agentTrade clearAgentTrade];
        [self forcelogout];
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@" OK " otherButtonTitles:nil] show];
    });
}

- (void)logoutAlert:(NSString *)title message:(NSString *)msg
{
    NSLog(@"Nyoman Unik2 %@",msg);
    NSLog(@"%s title: %@, message: %@", __PRETTY_FUNCTION__, title, msg);
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [agentTrade clearAgentTrade];
        [self forcelogout];
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@" OK " otherButtonTitles:nil] show];
    });
}

- (void)runAgent
{
    @try {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        if (nil != self.asyncSocket)
            [self.asyncSocket disconnect];
        
        self.asyncSocket = nil;
        self.asyncSocket = nil;
        self.asyncSocket = nil;
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        NSError *error = nil;
        
        NSString *host = TRADE_HOST_IP;
        NSInteger port = TRADE_HOST_PORT;
        
        NSLog(@"runAgent HOST : %@", TRADE_HOST_IP);
        NSLog(@"runAgent PORT : %ld", (long)TRADE_HOST_PORT);
        
        if (nil == host) {
            host = AGENTTRADE_HOST;
            port = AGENTTRADE_PORT;
        }
        
        NSLog(@"DEBUG HOST:%@, PORT:%li", host, (long)port);
        
        if (![self.asyncSocket connectToHost:host onPort:port withTimeout:30 error:&error]) {
            NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception: %@", __PRETTY_FUNCTION__, exception);
    }
}

- (void)parseReadData:(NSData*)data
{
    @try {
        TradingMessage *message = [TradingMessage parseFromData:data];
        
        if (StatusReturnResult == message.recStatusReturn) {
            
            if (RecordTypeLoginMi == message.recType) {
                NSLog(@"LOGIN MI- General Msg: %@", message.recLoginData.generalMsg);
                agentTrade.loginFeed = message.recLoginData;
                
                if (nil != message.recLoginData.sessionMi && ![@"" isEqualToString:message.recLoginData.sessionMi]) {
                    agentTrade.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:agentTrade selector:@selector(pulseGetSession) userInfo:nil repeats:YES];
                }
                else {
                    
                    NSArray *parse = [message.recLoginData.ipTrade componentsSeparatedByString: @":"];
                    if (nil != parse && parse.count == 2) {
                        TRADE_HOST_IP = [parse objectAtIndex:0];
                        TRADE_HOST_PORT = [[parse objectAtIndex:1] integerValue];
                    }
                    
                    parse = [message.recLoginData.ipMarket componentsSeparatedByString: @":"];
                    if (nil != parse && parse.count == 2) {
                        FEED_HOST_IP = [parse objectAtIndex:0];
                        FEED_HOST_PORT = [[parse objectAtIndex:1] integerValue];
                        [AgentFeed updateHost:[parse objectAtIndex:0]];
                        [AgentFeed updatePORT:[[parse objectAtIndex:1] integerValue]];
                    }
                }
            }
            else if (RecordTypeLoginOl == message.recType) {
                agentTrade.loginTrade = message.recLoginData;
            }
            else if (RecordTypeClientList == message.recType) {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                agentTrade.arrayClientlist = [message.recClientList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
            else if (RecordTypeGetOrders == message.recType) {
                //NSLog(@"RecordTypeGetOrders\n%@", message);
                //NSLog(@"CALLBACK RECORD %u, STATUS %u\n%@", message.recType, message.recStatusReturn, message);
                //NSString *log = [NSString stringWithFormat:@"", message];
                [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET ORDERS %u, STATUS %u ", message.recType, message.recStatusReturn]];
                
                if (nil == agentTrade.orderDictionary)
                    agentTrade.orderDictionary = [NSMutableDictionary dictionary];
                
                for (TxOrder *tx in message.recOrderlist) {
                    [agentTrade.orderDictionary setObject:tx forKey:tx.orderId];
                    
                    NSString *log = [NSString stringWithFormat:@"%@/%@/%d/%@/%0.f/%d/%@/%d/%@",
                                     tx.clientId, tx.orderStatus, tx.side, tx.securityCode, tx.orderQty, tx.price, tx.orderId, tx.sequenceNo, tx.reasonText];
                    [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET ORDER %u, STATUS %u %@ ", message.recType, message.recStatusReturn, log]];
                }
            }
            else if (RecordTypeGetTrades == message.recType) {
                [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET TRADES %u, STATUS %u ", message.recType, message.recStatusReturn]];
                
                if (nil == agentTrade.tradeDictionary)
                    agentTrade.tradeDictionary = [NSMutableDictionary dictionary];
                
                for (TxOrder *tx in message.recOrderlist) {
                    [agentTrade.tradeDictionary setObject:tx forKey:[NSString stringWithFormat:@"tradeId:%@,tradeSide:%i", tx.tradeId, tx.side]];
                    
                    NSString *log = [NSString stringWithFormat:@"%@/%@/%d/%@/%0.f/%d/%@/%d/%@/%0.f",
                                     tx.clientId, tx.orderStatus, tx.side, tx.securityCode, tx.orderQty, tx.price, tx.orderId, tx.sequenceNo, tx.reasonText, tx.cumQty];
                    [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET TRADES %u, STATUS %u %@ ", message.recType, message.recStatusReturn, log]];
                }
            }
            else if (RecordTypeGetOrderPower == message.recType) {
                [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK ORDER POWER %u, STATUS %u Order %.0f", message.recType, message.recStatusReturn, message.recOrderPower]];
            }
            else if (RecordTypeSendSubmitOrder == message.recType) {
                //NSLog(@"%s TRADE CALLBACK\n%@", __PRETTY_FUNCTION__, message);
                NSString *log = [NSString stringWithFormat:@"%@", message.recStatusMessage];
                [[DBLite sharedInstance] log:[NSString stringWithFormat:@"CALLBACK SUBMIT ORDER %u, STATUS %u %@", message.recType, message.recStatusReturn, log]];
            }
            else if (RecordTypeLogoutMi == message.recType || RecordTypeLogoutOl == message.recType) {
                agentTrade.loginFeed = nil;
                agentTrade.loginTrade = nil;
            }
            else if (RecordTypeGetStatusSession == message.recType) {
                /**
                 0 = true
                 1 = logout
                 2 = already login in another device
                 3 = session expired
                 4 = Force Logout application
                 5 = Force logout session
                 **/
                NSArray *loginStatus = [message.recLoginData.loginStatus componentsSeparatedByString:@"|"];
                if (loginStatus.count == 4) {
                    if (![@"0" isEqualToString:[loginStatus objectAtIndex:1]]) {
                        [agentTrade logoutAlert:@"Warning" message:[loginStatus objectAtIndex:3]];
                    }
                }
            }
            else {
                NSLog(@"%s TRADE CALLBACK RECORD %u, STATUS %u\n%@", __PRETTY_FUNCTION__, message.recType, message.recStatusReturn, message);
            }
        }
        else if (StatusReturnDoublelogin == message.recStatusReturn || StatusReturnSessionexp == message.recStatusReturn) {
            [agentTrade logoutAlert:@"Warning" message:message.recStatusMessage];
        }
        else if (StatusReturnForcelogout == message.recStatusReturn) {
            [agentTrade logoutAlert:@"Alert Info" message:message.recStatusMessage];
        }
        else {
            NSLog(@"%s !StatusReturnResult %@", __PRETTY_FUNCTION__, message);
        }
        
        if (nil != agentTrade.objectSelector && nil != agentTrade.selector) {
            if([agentTrade.objectSelector isKindOfClass:[AbstractViewController class]]) {
                AbstractViewController *v = (AbstractViewController *)agentTrade.objectSelector;
                [v performSelector:agentTrade.selector withObject:message afterDelay:0];
            }
            else if([agentTrade.objectSelector isKindOfClass:[UIViewController class]]) {
                UIViewController *v = (UIViewController *)agentTrade.objectSelector;
                [v performSelector:agentTrade.selector withObject:message afterDelay:0];
            }
            else if([agentTrade.objectSelector isMemberOfClass:[PopupLoginTrade class]]) {
                PopupLoginTrade *object = (PopupLoginTrade *)agentTrade.objectSelector;
                [object performSelector:agentTrade.selector withObject:message afterDelay:0];
            }
        }
        
        if (nil != agentTrade.agentTradeCallback) {
            agentTrade.agentTradeCallback(message);
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%s [***] exception %@", __PRETTY_FUNCTION__, exception);
    }
}

- (void)subscribeBuidler:(RequestData_Builder *)builder
{
    TradingMessage *message = [[[TradingMessage builder] setRecReqDataBuilder:builder] build];
    
    uint32_t fileLength = CFSwapInt32((uint32_t)message.data.length);
    NSData *lengthData = [NSData dataWithBytes:&fileLength length:sizeof(4)];
    
    NSMutableData *mutable = [NSMutableData dataWithData:lengthData];
    [mutable appendData:message.data];
    
    [self.asyncSocket writeData:mutable withTimeout:-1 tag:0];

}

#pragma mark -
#pragma public method

//- (void)startAgent
//{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
////    [self startAgent:[AgentTrade sharedInstance].userid passwd:[AgentTrade sharedInstance].passwd];
//}


//- (void)startAgent:(NSString *)userid passwd:(NSString *)passwd
- (void)startAgent:(NSString *)host port:(int32_t)port
{
    TRADE_HOST_IP = host;
    TRADE_HOST_PORT = port;
    if (isConnectivityAvailable()) {
//        [AgentTrade sharedInstance].userid = userid;
//        [AgentTrade sharedInstance].passwd = passwd;
        
        NSLog(@"%s Connectivity is Available", __PRETTY_FUNCTION__);
        [NSTimer scheduledTimerWithTimeInterval:.15 target:agentTrade selector:@selector(runAgent) userInfo:nil repeats:NO];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *title = @"No Network Connection";
            NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
            NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
            
            
            [[[UIBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
        });
    }
}

- (LoginData *)loginDataFeed
{
    return agentTrade.loginFeed;
}

- (LoginData *)loginDataTrade
{
    return agentTrade.loginTrade;
}

- (NSArray *)getClients
{
    return agentTrade.arrayClientlist;
}

- (NSArray *)getOrders
{
    if (nil != agentTrade.orderDictionary)
        return agentTrade.orderDictionary.allValues;
        
    return nil;
}

- (NSMutableDictionary *)getOrderDictionary
{
    return agentTrade.orderDictionary;
}

- (NSArray *)getTrades
{
    if (nil != agentTrade.tradeDictionary)
        return agentTrade.tradeDictionary.allValues;

    return nil;
}

- (NSMutableDictionary *)getTradeDictionary
{
    return agentTrade.tradeDictionary;
}

- (void)clearAgentTrade
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (nil != agentTrade.pulseTimer) {
        [agentTrade.pulseTimer invalidate];
        agentTrade.pulseTimer = nil;
    }
    
    agentTrade.arrayClientlist = nil;
    agentTrade.tradeDictionary = nil;
    agentTrade.tradeDictionary = nil;
    agentTrade = nil;
    TRADE_HOST_IP = nil;
    TRADE_HOST_PORT = 0;
    
//    if (nil != self.asyncSocket) {
//        [self.asyncSocket disconnect];
//    }
    self.asyncSocket = nil;
    
//    [[AgentFeed sharedInstance] clearAgentFeed];
}


// subscribe

- (void)loginFeed:(NSString *)userid passwd:(NSString *)passwd
{
//    NSLog(@"%s userid = %@, passwd = %@", __PRETTY_FUNCTION__, userid, passwd);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *udid = [defaults objectForKey:@"userIdentifier"];
    
    RequestData_Builder *builder = [RequestData builder];
    builder.username = userid;
    builder.password = passwd;
    builder.loginType = LOGINTYPE;
    builder.version = VERSION;
    builder.recordType = RecordTypeLoginMi;
    builder.requestType = RequestGet;
    builder.applicationType = APPLICATIONTYPE;
    builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDMARKETSESSION];
//    builder.ipAddress = AGENTTRADE_HOST;
    builder.ipAddress = udid;
    
    [self subscribeBuidler:builder];
}

- (void)LoginTrade:(NSString *)pin
{   
    if (nil != agentTrade.loginFeed) {
        NSLog(@"%s pin = %@", __PRETTY_FUNCTION__, pin);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *udid = [defaults objectForKey:@"userIdentifier"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeLoginOl;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        builder.pin = pin;
        builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDTRADINGSESSION];
        builder.version = VERSION;
        builder.ipAddress = AGENTTRADE_HOST;
        builder.ipAddress = udid;
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribe:(RecordType)recType requestType:(Request)reqType
{
    if (nil != agentTrade.loginFeed) {
        NSLog(@"%s RecordType = %u, Request = %u", __PRETTY_FUNCTION__, recType, reqType);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = recType;
        builder.requestType = reqType;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        
        if(nil != agentTrade.loginTrade) {
            builder.sessionOl = agentTrade.loginTrade.sessionOl;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribe:(RecordType)recType requestType:(Request)reqType clientcode:(NSString *)code
{
    if (nil != agentTrade.loginFeed) {
        NSLog(@"%s RecordType = %u, Request = %u, Clientcode = %@", __PRETTY_FUNCTION__, recType, reqType, code);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = recType;
        builder.requestType = reqType;
        builder.username = agentTrade.loginFeed.username;
        builder.clientcode = code;
        
        if(nil != agentTrade.loginTrade) {
            builder.sessionOl = agentTrade.loginTrade.sessionOl;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeOrderList
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [[DBLite sharedInstance] log:@"SUBSCRIBE ORDER LIST"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetOrders;
        builder.requestType = RequestSubscribe;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionOl = agentTrade.loginTrade.sessionOl;
        builder.deviceType = DeviceTypeIphone;
        if([AgentTrade sharedInstance].loginDataFeed != nil) {
            builder.userType = [AgentTrade sharedInstance].loginDataFeed.usertype;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeAvaiable:(NSString *)stock clientcode:(NSString *)code
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        NSLog(@"%s stock = %@, clientcode = %@", __PRETTY_FUNCTION__, stock, code);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetAvaiableStock;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionOl = agentTrade.loginTrade.sessionOl;
        builder.clientcode = code;
        builder.stockcode = stock;
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeTrade
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [[DBLite sharedInstance] log:@"SUBSCRIBE TRADE"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetOrders;
        builder.requestType = RequestSubscribe;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionOl = agentTrade.loginTrade.sessionOl;
        builder.deviceType = DeviceTypeIphone;
        if([AgentTrade sharedInstance].loginDataFeed != nil) {
            builder.userType = [AgentTrade sharedInstance].loginDataFeed.usertype;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)changePassword:(NSString *)oldPasswd newPasswd:(NSString *)newPasswd
{
    if (nil != agentTrade.loginFeed) {
        NSLog(@"%s old passwd = %@, new passwd = %@", __PRETTY_FUNCTION__, oldPasswd, newPasswd);
        [[DBLite sharedInstance] log:@"CHANGE PASSWORD"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePassword;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        builder.password = oldPasswd;
        builder.general = newPasswd;
        
        [self subscribeBuidler:builder];
    }
}

- (void)changePin:(NSString *)oldPin newPin:(NSString *)newPin
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        NSLog(@"%s old pin = %@, new pin = %@", __PRETTY_FUNCTION__, oldPin, newPin);
        [[DBLite sharedInstance] log:@"CHANGE PIN"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePin;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        builder.sessionOl = agentTrade.loginTrade.sessionOl;
        builder.pin = oldPin;
        builder.general = newPin;
        
        [self subscribeBuidler:builder];
    }
}

- (void)forceChange:(NSString *)pin passwd:(NSString *)password;
{
    if (nil != agentTrade.loginFeed) {
        NSLog(@"%s force change new password = %@, new pin = %@", __PRETTY_FUNCTION__, pin, password);
        [[DBLite sharedInstance] log:@"FORCE CHANGE PASSWORD & PIN"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *udid = [defaults objectForKey:@"userIdentifier"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePinPassword;
        builder.requestType = RequestGet;
        builder.username = agentTrade.loginFeed.username;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        builder.pin = pin;
        builder.password = password;
        builder.ipAddress = udid;//agentTrade.loginFeed.ipMarket;
        
        [self subscribeBuidler:builder];

    }
}

- (void)composeMsg:(NSDictionary*)op composeMsg:(BOOL)b
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeSendSubmitOrder;
        builder.requestType = RequestGet;
        builder.sessionOl = agentTrade.loginTrade.sessionOl;
        builder.username = agentTrade.loginFeed.username;
        
        NSString *submitOrder = [ConstractOrder composeMsgNew:op];
        long long skey = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        
        NSLog(@"TRX sKey %lld", skey);
//        NSLog(@"param %@", submitOrder);
        
        [[DBLite sharedInstance] log:[NSString stringWithFormat:@"COMPOSE TRX MSG:: %@", submitOrder]];
        
        builder.messageOrder = submitOrder;
        builder.general = [NSString stringWithFormat:@"%lld", skey];
        builder.version = VERSION;
        
//        if (b) {
//            TxOrder_Builder *builder = [TxOrder builder];
//            builder.price = [[op objectForKey:O_PRICE] intValue];
//            builder.orderQty = [[op objectForKey:O_ORDERQTY] floatValue];
//            builder.side = [[op objectForKey:O_SIDE] intValue];
//            builder.securityCode = [op objectForKey:O_SYMBOL];
//            builder.orderStatus = @"9";
//            builder.clientCode = [op objectForKey:O_CLIENTCODE];
//
//            
//            [agentOrder orderPacket:[builder build]];
//        }
        
        [self subscribeBuidler:builder];
    }
}

//- (void)subscribeCashWitdraw:(NSString *)clientCode
//{
//    if (nil != agentTrade.loginFeed) {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//        
//        RequestData_Builder *builder = [RequestData builder];
//        builder.recordType = RecordTypeGetCashWithdraw;
//        builder.requestType = RequestGet;
//        builder.username = agentTrade.loginFeed.username;
//        builder.sessionMi = agentTrade.loginFeed.sessionMi;
//        
//        if(nil != agentTrade.loginTrade) {
//            builder.sessionOl = agentTrade.loginTrade.sessionOl;
//        }
//        
//        [self subscribeBuidler:builder];
//    }
//}

- (void)entryCashWitdraw:(float)amount pin:(NSString*)tradePin clientcode:(NSString *)code
{
    if (nil != agentTrade.loginFeed && nil != agentTrade.loginTrade) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [[DBLite sharedInstance] log:[NSString stringWithFormat:@"ENTRY CASH WITHDRAW:: %.0f", amount]];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeSubmitCashWithdraw;
        builder.requestType = RequestGet;
        builder.deviceType = DeviceTypeIphone;
        builder.sessionMi = agentTrade.loginFeed.sessionMi;
        builder.username = agentTrade.loginFeed.username;
        builder.clientcode = code;
        builder.pin = tradePin;
        
        if(nil != agentTrade.loginTrade) {
            builder.sessionOl = agentTrade.loginTrade.sessionOl;
        }
        
        CashWithdraw_Builder *cash_builder = [CashWithdraw builder];
        cash_builder.amount = amount;
        cash_builder.tradingPin = tradePin;
        cash_builder.statusAgrement = @"1";
        
        builder.cashWithdraw = [cash_builder build];
        
        [self subscribeBuidler:builder];
    }
}

//block-callback
- (void)agentSelector:(SEL)selector withObject:(id)object
{
    agentTrade.selector = selector;
    agentTrade.objectSelector = object;
    
    [AgentTrade sharedInstance].selector = selector;
    [AgentTrade sharedInstance].objectSelector = object;
}

- (void)agentTradeCallback:(AgentTradeCallback)callback
{
    agentTrade.agentTradeCallback = callback;
    
    [AgentTrade sharedInstance].agentTradeCallback = callback;
}


#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];

    
    //ready login (set callback)
    TradingMessage_Builder *builder = [TradingMessage builder];
    LoginData_Builder *login_builder = [LoginData builder];
    login_builder.sessionMi = @"-1";
    builder.recStatusReturn = StatusReturnResult;
    builder.recType = RecordTypeLoginMi;
    builder.recLoginData = [login_builder build];
    
    if (nil != agentTrade.objectSelector && nil != agentTrade.selector) {
        if([agentTrade.objectSelector isKindOfClass:[UIViewController class]]) {
            UIViewController *v = (UIViewController *)agentTrade.objectSelector;
            [v performSelector:agentTrade.selector withObject:[builder build] afterDelay:0];
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (0 == tag) {
        NSInteger bodyLength = [self parseHeader:data];
        [sock readDataToLength:bodyLength withTimeout:-1.0 tag:1];
    }
    else if(1 == tag) {
        
        [self parseReadData:data];
        [sock readDataToLength:4 withTimeout:-1.0 tag:0];
        
    }
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s error: %@ %@", __PRETTY_FUNCTION__, err, sock.connectedHost);
    
    TRADE_HOST_IP = nil;
    
    if (nil != err && [err.description rangeOfString:@"host timed out"].location != NSNotFound) {
        NSLog(@"HOST TIMED OUT");
        //set callback
        TradingMessage_Builder *builder = [TradingMessage builder];
        LoginData_Builder *login_builder = [LoginData builder];
        login_builder.sessionMi = @"-3";
        builder.recStatusReturn = StatusReturnResult;
        builder.recType = RecordTypeLoginMi;
        builder.recLoginData = [login_builder build];
        
        UIViewController *v = (UIViewController *)agentTrade.objectSelector;
        [v performSelector:agentTrade.selector withObject:[builder build] afterDelay:0.1];
        
        agentTrade.loginFeed = nil;
        agentTrade.loginTrade = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (nil != agentTrade) {
                NSString *title = @"Network Connection Error";
                NSString *message = @"Attempt to connect to host timed out";
                
                [[[UIBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
            }
        });
    }
    else if (nil != agentTrade.objectSelector && [agentTrade.objectSelector isMemberOfClass:[LoginMiViewController class]]) {
        NSLog(@"AGENT CALLBACK");
        //set callback
        TradingMessage_Builder *builder = [TradingMessage builder];
        LoginData_Builder *login_builder = [LoginData builder];
        login_builder.sessionMi = @"-2";
        builder.recStatusReturn = StatusReturnResult;
        builder.recType = RecordTypeLoginMi;
        builder.recLoginData = [login_builder build];
        
        UIViewController *v = (UIViewController *)agentTrade.objectSelector;
        [v performSelector:agentTrade.selector withObject:[builder build] afterDelay:0.1];
        
        agentTrade.loginFeed = nil;
        agentTrade.loginTrade = nil;
        
    }
    else {
        NSLog(@"NETWORK CONNECTION");
        [agentTrade clearAgentTrade];
        
        agentTrade.loginFeed = nil;
        agentTrade.loginTrade = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (nil != agentTrade) {
                [agentTrade logoutAlert:@"NETWORK CONNECTION" message:@"Network Connection Error"];
                
//                NSString *title = @"Network Connection Error";
//                NSLog(@"%s %@", __PRETTY_FUNCTION__, err.description);
//            
//                [[[UIBAlertView alloc] initWithTitle:title message:err.description cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
            }
        });
        
    }
}

- (NSInteger)parseHeader:(NSData *)data
{
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}

@end
