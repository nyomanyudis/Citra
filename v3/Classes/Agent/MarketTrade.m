//
//  MarketTrade.m
//  Ciptadana
//
//  Created by Reyhan on 11/7/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//


#import "RearMenu.h"
//#import "SubMenu.h"
#import "RearMenuCell.h"

#import "Home.h"
#import "GrandController.h"
#import "UIView+Toast.h"
#import "SystemAlert.h"

#import "MarketTrade.h"

#import "SysAdmin.h"

#import <QuartzCore/QuartzCore.h>

#import "MarketTrade.h"

#import "GCDAsyncSocket.h"
#import "SysAdmin.h"
#import "Connectivity.h"
#import "ConstractOrder.h"

#import "SystemAlert.h"
#import "RearMenu.h"



static MarketTrade *marketTrade;

@interface MarketTrade () <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *asyncSocket;
@property (nonatomic) NSArray *arrayClientlist;
@property (nonatomic) NSMutableDictionary *orderDictionary;
@property (nonatomic) NSMutableDictionary *tradeDictionary;
@property (nonatomic) NSTimer *pulseTimer;
@property (nonatomic) NSInteger passwordStatus;
@property (nonatomic) BOOL reconnect;
@property (nonatomic) Boolean *forceLogout;

@end

@implementation MarketTrade

+ (MarketTrade *)sharedInstance
{
//    NSLog(@"MarketTrade Step 1");
    if (nil == marketTrade) {
        
        NSString *ipTrade = [SysAdmin sharedInstance].sysAdminData.ipTrade;
        //NSString *ipMarket = @"192.168.150.10:7000";
        if(!ipTrade)
            ipTrade = @"192.168.150.10:7000";
        NSArray *splitIp = [ipTrade componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        int port = [[splitIp objectAtIndex:1] intValue];
        
        NSLog(@"%s %@:%i", __PRETTY_FUNCTION__, ip, port);
        marketTrade = [[MarketTrade alloc] init];
        
//        [marketTrade getOrdersSpecificType:<#(NSString *)#>]
    }
    
    return marketTrade;
}

#pragma mark - private

- (void)pulseGetSession
{
    NSLog(@"MarketTrade Step 2");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetStatusSession;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        
        if (nil != [SysAdmin sharedInstance].loginTrade) {
            builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        }
        
        [marketTrade subscribeBuidler:builder];
    }
    
    //    [marketTrade subscribe:RecordTypeGetStatusSession requestType:RequestGet];
}

#pragma - private

- (void)forcelogout
{
    NSLog(@"force logout");
//    [[MarketFeed sharedInstance] dologout];
//    [[MarketTrade sharedInstance] doLogout];
//    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
//    if(vc) {
//        // Pass any objects to the view controller here, like...
//        [revealController pushFrontViewController:vc animated:YES];
//        
//        [[MarketFeed sharedInstance] doLogout];
//        
//        [vc.view makeToast:@"              Logout               "
//                  duration:3.5f
//                  position:CSToastPositionTop
//                     title:nil
//                     image:nil//[UIImage imageNamed:@"arrowgreen"]
//                     style:nil
//                completion:^(BOOL didTap) {
//                    if (didTap) {
//                        NSLog(@"completion from tap");
//                    } else {
//                        NSLog(@"completion without tap");
//                    }
//                }];
//        
//        [SysAdmin sharedInstance].loginTrade = nil;
//
//    }

    

}

//- (void)forcelogout
//{
//    UIViewController *v = [self topViewController];
//    
//    if (nil != v && [v isMemberOfClass:[ViewController class]]) {
//        [v dismissViewControllerAnimated:NO completion:nil];
//    }
//    else {
//        [self performSelector:@selector(forcelogout) withObject:nil];
//    }
//}
//
//- (UIViewController *)topViewController
//{
//    UIViewController *v = [UIApplication sharedApplication].keyWindow.rootViewController;
//    return v;
//}
//
//- (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//    if (rootViewController.presentedViewController == nil) {
//        return rootViewController;
//    }
//    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
//        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
//        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
//        return [self topViewController:lastViewController];
//    }
//    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
//    return [self topViewController:presentedViewController];
//}


- (void)logoutAlert:(NSString *)title message:(NSString *)msg idle:(BOOL)idle
{
//    NSLog(@"MarketTrade Step 3");
    NSLog(@"%s title: %@, message: %@", __PRETTY_FUNCTION__, title, msg);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [marketTrade clearMarketTrade];
        [self forcelogout];
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@" OK " otherButtonTitles:nil] show];
    });
}

- (void)logoutAlert:(NSString *)title message:(NSString *)msg
{
//    NSLog(@"MarketTrade Step 4");
    NSLog(@"%s title: %@, message: %@", __PRETTY_FUNCTION__, title, msg);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [marketTrade clearMarketTrade];
        [self forcelogout];
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@" OK " otherButtonTitles:nil] show];
    });
}

- (void)ErrorAlert:(NSString *)title message:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@" OK " otherButtonTitles:nil] show];
    });
    
}

- (void)runAgent
{
    NSLog(@"MarketTrade Step 5");
    @try {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        if (nil != self.asyncSocket)
            [self.asyncSocket disconnect];
        
        self.asyncSocket = nil;
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        NSError *error = nil;
        
        NSString *ipTrade = [SysAdmin sharedInstance].sysAdminData.ipTrade;
        //NSString *ipMarket = @"192.168.150.10:7000";
        if(!ipTrade)
            ipTrade = @"192.168.150.10:7000";
        NSArray *splitIp = [ipTrade componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        int port = [[splitIp objectAtIndex:1] intValue];

        
//        NSString *host = TRADE_HOST_IP;
//        NSInteger port = TRADE_HOST_PORT;
//        
//        NSLog(@"runAgent HOST : %@", TRADE_HOST_IP);
//        NSLog(@"runAgent PORT : %ld", (long)TRADE_HOST_PORT);
//        
//        if (nil == host) {
//            host = marketTrade_HOST;
//            port = marketTrade_PORT;
//        }
        
        NSLog(@"DEBUG HOST:%@, PORT:%i", ip, port);
        
        if (![self.asyncSocket connectToHost:ip onPort:port withTimeout:30 error:&error]) {
            NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception: %@", __PRETTY_FUNCTION__, exception);
    }
}



- (void)parseReadData:(NSData*)data
{
    NSLog(@"MarketTrade Step 6");
    @try {
        TradingMessage *message = [TradingMessage parseFromData:data];
        
        if (StatusReturnResult == message.recStatusReturn) {
            
            if(RecordTypeGetStatusSession != message.recType)
                NSLog(@"%s: ENGINE %@", __PRETTY_FUNCTION__, message);
            
            if (RecordTypeLoginMi == message.recType) {
                    NSLog(@"RecordTypeLoginMi = %@",message);
                    if([message.recLoginData.generalMsg length] > 2){
                        NSArray *generalMessage = [message.recLoginData.generalMsg componentsSeparatedByString:@"|"];
                        marketTrade.passwordStatus = [generalMessage[2] intValue];
                    }
                
                    //NSLog(@"LOGIN MI- General Msg: %@", message.recLoginData.generalMsg);
                    [SysAdmin sharedInstance].loginFeed = message.recLoginData;
                        
                    //NSLog(@"Login Feed: %@", [SysAdmin sharedInstance].loginFeed);
                        
                    if (message.recLoginData.sessionMi && ![@"" isEqualToString:message.recLoginData.sessionMi]) {
                        marketTrade.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:marketTrade selector:@selector(pulseGetSession) userInfo:nil repeats:YES];
                    }
                
                
                    
                
            }
            else if (RecordTypeLoginOl == message.recType) {
                [SysAdmin sharedInstance].loginTrade = message.recLoginData;
                //NSLog(@"Login Trade: %@", [SysAdmin sharedInstance].loginTrade);
            }
            else if (RecordTypeClientList == message.recType) {
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                marketTrade.arrayClientlist = [message.recClientList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
            else if (RecordTypeGetOrders == message.recType) {
                //NSLog(@"==RecordTypeGetOrders\n%@", message);
                //NSLog(@"==CALLBACK RECORD %u, STATUS %u\n%@", message.recType, message.recStatusReturn, message);
                //NSString *log = [NSString stringWithFormat:@"", message];
//                [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET ORDERS %u, STATUS %u ", message.recType, message.recStatusReturn]];
                
                if (nil == marketTrade.orderDictionary)
                    marketTrade.orderDictionary = [NSMutableDictionary dictionary];
                
                for (TxOrder *tx in message.recOrderlist) {
                    [marketTrade.orderDictionary setObject:tx forKey:tx.orderId];
                    
//                    NSString *log = [NSString stringWithFormat:@"%@/%@/%d/%@/%0.f/%d/%@/%d/%@",
//                                     tx.clientId, tx.orderStatus, tx.side, tx.securityCode, tx.orderQty, tx.price, tx.orderId, tx.sequenceNo, tx.reasonText];
//                    [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET ORDER %u, STATUS %u %@ ", message.recType, message.recStatusReturn, log]];
                }
            }
            else if (RecordTypeGetTrades == message.recType) {
//                [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET TRADES %u, STATUS %u ", message.recType, message.recStatusReturn]];
                
                if (nil == marketTrade.tradeDictionary)
                    marketTrade.tradeDictionary = [NSMutableDictionary dictionary];
                
                for (TxOrder *tx in message.recOrderlist) {
                    [marketTrade.tradeDictionary setObject:tx forKey:[NSString stringWithFormat:@"tradeId:%@,tradeSide:%i", tx.tradeId, tx.side]];
                    
//                    NSString *log = [NSString stringWithFormat:@"%@/%@/%d/%@/%0.f/%d/%@/%d/%@/%0.f",
//                                     tx.clientId, tx.orderStatus, tx.side, tx.securityCode, tx.orderQty, tx.price, tx.orderId, tx.sequenceNo, tx.reasonText, tx.cumQty];
//                    [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK GET TRADES %u, STATUS %u %@ ", message.recType, message.recStatusReturn, log]];
                }
            }
            else if (RecordTypeGetOrderPower == message.recType) {
//                [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK ORDER POWER %u, STATUS %u Order %.0f", message.recType, message.recStatusReturn, message.recOrderPower]];
            }
            else if (RecordTypeSendSubmitOrder == message.recType) {
                //NSLog(@"%s TRADE CALLBACK\n%@", __PRETTY_FUNCTION__, message);
//                NSString *log = [NSString stringWithFormat:@"%@", message.recStatusMessage];
//                [[MasterData sharedInstance] log:[NSString stringWithFormat:@"CALLBACK SUBMIT ORDER %u, STATUS %u %@", message.recType, message.recStatusReturn, log]];
            }
            else if (RecordTypeLogoutMi == message.recType || RecordTypeLogoutOl == message.recType) {
                [SysAdmin sharedInstance].loginFeed = nil;
                [SysAdmin sharedInstance].loginTrade = nil;
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
                        [marketTrade logoutAlert:@"Warning" message:[loginStatus objectAtIndex:3]];
                    }
                }
            }
            else if(RecordTypeChangePassword == message.recType ){
                [marketTrade ErrorAlert:@"Alert " message:@"Success change password"];
            }
            else if(RecordTypeChangePinPassword == message.recType){
                marketTrade.passwordStatus = 0;
                [marketTrade ErrorAlert:@"Success " message:@"Success change Password and Pin"];
            }
            else {
                NSLog(@"%s TRADE CALLBACK RECORD %u, STATUS %u\n%@", __PRETTY_FUNCTION__, message.recType, message.recStatusReturn, message);
            }
        }
        else if (StatusReturnDoublelogin == message.recStatusReturn || StatusReturnSessionexp == message.recStatusReturn) {
            [marketTrade logoutAlert:@"Warning" message:message.recStatusMessage];
        }
        else if (StatusReturnForcelogout == message.recStatusReturn) {
            [marketTrade logoutAlert:@"Alert Info" message:message.recStatusMessage];
        }
        else if(StatusReturnError == message.recStatusReturn && [message.recStatusMessage isEqualToString:@"Invalid Pin. Please try again using your PIN"]){
            [marketTrade ErrorAlert:@"Error " message:message.recStatusMessage];
        }
        else if(StatusReturnError == message.recStatusReturn && [message.recStatusMessage isEqualToString:@"Invalid Pin. Please try again using your PIN"]){
            [MarketTrade sharedInstance].forceLogout = YES;
        }
        else if(RecordTypeChangePassword == message.recType && message.recStatusReturn == StatusReturnError && [message.recStatusMessage isEqualToString:@"Invalid Old Password"]) {
            [marketTrade ErrorAlert:@"Error " message:message.recStatusMessage];
        }
        else {
            NSLog(@"%s !StatusReturnResult %@", __PRETTY_FUNCTION__, message);
        }
        
//        if (nil != marketTrade.objectSelector && nil != marketTrade.selector) {
//            if([marketTrade.objectSelector isKindOfClass:[AbstractViewController class]]) {
//                AbstractViewController *v = (AbstractViewController *)marketTrade.objectSelector;
//                [v performSelector:marketTrade.selector withObject:message afterDelay:0];
//            }
//            else if([marketTrade.objectSelector isKindOfClass:[UIViewController class]]) {
//                UIViewController *v = (UIViewController *)marketTrade.objectSelector;
//                [v performSelector:marketTrade.selector withObject:message afterDelay:0];
//            }
//            else if([marketTrade.objectSelector isMemberOfClass:[PopupLoginTrade class]]) {
//                PopupLoginTrade *object = (PopupLoginTrade *)marketTrade.objectSelector;
//                [object performSelector:marketTrade.selector withObject:message afterDelay:0];
//            }
//        }
//        
//        if (nil != marketTrade.marketTradeCallback) {
//            marketTrade.marketTradeCallback(message);
//        }
        
        // Callback
        @try {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.callback) {
                    self.callback(message, nil, YES);
                }
            });
        }
        @catch (NSException *exception) {
            NSLog(@"NSException %@", exception);
            if(self.callback) {
                self.callback(nil, [NSString stringWithFormat:@"NSException %@", exception], NO);
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s [***] exception %@", __PRETTY_FUNCTION__, exception);
    }
}

- (void)subscribeBuidler:(RequestData_Builder *)builder
{
    NSLog(@"MarketTrade Step 7");
    TradingMessage *message = [[[TradingMessage builder] setRecReqDataBuilder:builder] build];
    NSLog(@"Tradding message loginTrade = %@",message);
    if(message.recReqData && message.recReqData.recordType != RecordTypeGetStatusSession)
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, message);
    
    uint32_t fileLength = CFSwapInt32((uint32_t)message.data.length);
    NSData *lengthData = [NSData dataWithBytes:&fileLength length:sizeof(4)];
    
    NSMutableData *mutable = [NSMutableData dataWithData:lengthData];
    [mutable appendData:message.data];
    
    NSLog(@"NSMutableData = %@",mutable);
    NSLog(@"self.asyncSocket = %@",self.asyncSocket);
    
    
    NSLog(@"SysAdminData = %@",[[SysAdmin sharedInstance] sysAdminData]);
    NSLog(@"loginFeed = %@",[[SysAdmin sharedInstance] loginFeed]);
    NSLog(@"loginTrade = %@",[[SysAdmin sharedInstance] loginTrade]);
    
//    if(self.asyncSocket == nil)
//        [self runAgent];
    
    [self.asyncSocket writeData:mutable withTimeout:-1 tag:0];
    
}

#pragma mark -
#pragma public method

- (void)startAgent:(NSString *)host port:(int32_t)port reconnect:(BOOL)reconnect
{
    NSLog(@"MarketTrade Step 8");
    marketTrade.reconnect = reconnect;
    if (isConnectivityAvailable()) {
        [NSTimer scheduledTimerWithTimeInterval:.15 target:marketTrade selector:@selector(runAgent) userInfo:nil repeats:NO];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *title = @"No Network Connection";
            NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
            NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
            
            id handler = ^(SIAlertView *alert) {
                
            };
            SIAlertView *alert = [SystemAlert alert:title message:message handler:handler button:@"OK"];
            [alert show];
        });
    }
}

- (NSArray *)getClients
{
    NSLog(@"MarketTrade Step 9");
    return marketTrade.arrayClientlist;
}

- (NSInteger )getPasswordStatus
{
    return marketTrade.passwordStatus;
}

- (Boolean )getForceLogout
{
    return marketTrade.forceLogout;
}

- (NSMutableArray *)getOrders
{
    NSLog(@"MarketTrade Step 10");
    if (nil != marketTrade.orderDictionary){
        NSMutableArray *result = [[NSMutableArray alloc] init];
        [result addObjectsFromArray:marketTrade.orderDictionary.allValues];
        return result;
    }
//        return marketTrade.orderDictionary.allValues;
    
    return nil;
}

- (NSMutableArray *)getOrdersSpecificType:(NSString *)OrderType
{
    NSLog(@"MarketTrade Step 11");
    if (nil != marketTrade.orderDictionary){
        NSArray *temp = marketTrade.orderDictionary.allValues;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for(int i=0;i<[temp count];i++){
            TxOrder *order = [temp objectAtIndex:i];
            NSString *type;
            type = order.side == 1 ? @"Buy" : @"Sell";
            if([type caseInsensitiveCompare:OrderType] == NSOrderedSame){
                [result addObject:order];
            }
        }
        return result;
    }
    
    return nil;
}



- (NSMutableArray *)getOrdersSpecificStatus:(NSString *)OrderStatus
{
    NSLog(@"MarketTrade Step 12");
    if (nil != marketTrade.orderDictionary){
        NSArray *temp = marketTrade.orderDictionary.allValues;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for(int i=0;i<[temp count];i++){
            TxOrder *order = [temp objectAtIndex:i];
            if([[self statusDescription:order.orderStatus] caseInsensitiveCompare:OrderStatus] == NSOrderedSame){
                [result addObject:order];
            }
        }
        return result;
    }
    
    return nil;
}

- (NSMutableArray *)getOrdersSpecificTypeAndSpecificStatus:(NSString *)OrderType OrderStatus:(NSString *)OrderStatus
{
    NSLog(@"MarketTrade Step 13");
    if (nil != marketTrade.orderDictionary){
        NSArray *temp = marketTrade.orderDictionary.allValues;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for(int i=0;i<[temp count];i++){
            TxOrder *order = [temp objectAtIndex:i];
            NSString *type;
            type = order.side == 1 ? @"Buy" : @"Sell";
            if([type caseInsensitiveCompare:OrderType] == NSOrderedSame && [[self statusDescription:order.orderStatus] caseInsensitiveCompare:OrderStatus] == NSOrderedSame){
                [result addObject:order];
            }
        }
        return result;
    }
    
    return nil;
}

- (NSString*) statusDescription:(NSString*)status
{
    NSLog(@"MarketTrade Step 14");
    if(nil != status) {
        if([@"0" isEqualToString:status]) {
            return @"Open";
        }
        else if([@"1" isEqualToString:status]) {
            return @"Partially Match";
        }
        else if([@"2" isEqualToString:status]) {
            return @"Fully Match";
        }
        else if([@"3" isEqualToString:status]) {
            return @"Done for day";
        }
        else if([@"4" isEqualToString:status]) {
            return @"withdrawn";
        }
        else if([@"5" isEqualToString:status]) {
            return @"Amended";
        }
        else if([@"6" isEqualToString:status]) {
            return @"Pending Cancel";
        }
        else if([@"7" isEqualToString:status]) {
            return @"Stopped";
        }
        else if([@"8" isEqualToString:status]) {
            return @"Rejected";
        }
        else if([@"9" isEqualToString:status]) {
            return @"In Process";
        }
        else if([@"A" isEqualToString:status]) {
            return @"Pending New";
        }
        else if([@"B" isEqualToString:status]) {
            return @"Calculated";
        }
        else if([@"C" isEqualToString:status]) {
            return @"Expired";
        }
        else if([@"D" isEqualToString:status]) {
            return @"Accepted for Bidding";
        }
        else if([@"E" isEqualToString:status]) {
            return @"Pending Replace";
        }
        else if([@"KA" isEqualToString:status]) {
            return @"Preopening Not Submitted";
        }
        else if([@"KB" isEqualToString:status]) {
            return @"Preopening Submitted";
        }
        else if([@"KC" isEqualToString:status]) {
            return @"Pooling Not Submitted";
        }
        else if([@"KD" isEqualToString:status]) {
            return @"Pooling Submitted";
        }
        else if([@"kc" isEqualToString:status]) {
            return @"Pooling Cancel";
        }
        else if([@"r" isEqualToString:status]) {
            return @"Internal Reject";
            //return @"Rejected";
        }
        else if([@"W" isEqualToString:status]) {
            return @"Waiting Process";
        }
        else if([@"1x0001" isEqualToString:status]) {
            return @"Order Received By Server";
        }
    }
    
    return @"";
}

- (NSMutableDictionary *)getOrderDictionary
{
    NSLog(@"MarketTrade Step 15");
//    NSLog(@"MarketTrade Step 11");
    return marketTrade.orderDictionary;
}

- (NSArray *)getTrades
{
    NSLog(@"MarketTrade Step 16");
//    NSLog(@"MarketTrade Step 12");
    if (nil != marketTrade.tradeDictionary)
        return marketTrade.tradeDictionary.allValues;
    
    return nil;
}

- (NSMutableDictionary *)getTradeDictionary
{
    NSLog(@"MarketTrade Step 17");
//    NSLog(@"MarketTrade Step 13");
    return marketTrade.tradeDictionary;
}

- (void)clearMarketTrade
{
    NSLog(@"MarketTrade Step 18");
//    NSLog(@"MarketTrade Step 14");
    if (nil != marketTrade.pulseTimer) {
        [marketTrade.pulseTimer invalidate];
        marketTrade.pulseTimer = nil;
    }
    
    marketTrade.arrayClientlist = nil;
    marketTrade.tradeDictionary = nil;
    marketTrade.tradeDictionary = nil;
    marketTrade = nil;
    [SysAdmin sharedInstance].loginTrade = nil;
    [SysAdmin sharedInstance].loginFeed = nil;
    self.asyncSocket = nil;
}


// subscribe

- (void)loginFeed:(NSString *)userid passwd:(NSString *)passwd
{
    NSLog(@"MarketTrade Step 19");
//    NSLog(@"MarketTrade Step 15");
    //    NSLog(@"%s userid = %@, passwd = %@", __PRETTY_FUNCTION__, userid, passwd);
    
    RequestData_Builder *builder = [RequestData builder];
    builder.username = userid;
    builder.password = passwd;
    builder.loginType = LOGINTYPE;
    builder.version = VERSION;
    builder.recordType = RecordTypeLoginMi;
    builder.requestType = RequestGet;
    builder.applicationType = APPLICATIONTYPE;
    builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDMARKETSESSION];
//        builder.ipAddress = marketTrade_HOST;
    builder.ipAddress = UDID;
    
    [self subscribeBuidler:builder];
}

- (void)LoginTrade:(NSString *)pin
{
    NSLog(@"MarketTrade Step 20");
//    NSLog(@"MarketTrade Step 16");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        NSLog(@"%s pin = %@", __PRETTY_FUNCTION__, pin);
        
        
        
        NSString *ipTrade = [SysAdmin sharedInstance].sysAdminData.ipTrade;
        //NSString *ipMarket = @"192.168.150.10:7000";
        if(!ipTrade)
            ipTrade = @"192.168.150.10:7000";
        NSArray *splitIp = [ipTrade componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeLoginOl;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        builder.pin = pin;
        builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDTRADINGSESSION];
        builder.version = VERSION;
        builder.ipAddress = ip;
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribe:(RecordType)recType requestType:(Request)reqType
{
    NSLog(@"MarketTrade Step 21");
//    NSLog(@"MarketTrade Step 17");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        NSLog(@"%s RecordType = %u, Request = %u", __PRETTY_FUNCTION__, recType, reqType);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = recType;
        builder.requestType = reqType;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        
        if(nil != [SysAdmin sharedInstance].loginTrade) {
            builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribe:(RecordType)recType requestType:(Request)reqType clientcode:(NSString *)code
{
    NSLog(@"MarketTrade Step 22");
//    NSLog(@"MarketTrade Step 18");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        NSLog(@"%s RecordType = %u, Request = %u, Clientcode = %@", __PRETTY_FUNCTION__, recType, reqType, code);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = recType;
        builder.requestType = reqType;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.clientcode = code;
        
        if(nil != [SysAdmin sharedInstance].loginTrade) {
            builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeOrderList
{
    NSLog(@"MarketTrade Step 23");
//    NSLog(@"MarketTrade Step 19");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
        NSLog(@"%s", __PRETTY_FUNCTION__);
//        [[MasterData sharedInstance] log:@"SUBSCRIBE ORDER LIST"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetOrders;
        builder.requestType = RequestSubscribe;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        builder.deviceType = DeviceTypeIphone;
        if([SysAdmin sharedInstance].loginFeed != nil) {
            builder.userType = [SysAdmin sharedInstance].loginFeed.usertype;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeAvaiable:(NSString *)stock clientcode:(NSString *)code
{
    NSLog(@"MarketTrade Step 24");
//    NSLog(@"MarketTrade Step 20");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
        NSLog(@"%s stock = %@, clientcode = %@", __PRETTY_FUNCTION__, stock, code);
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetAvaiableStock;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        builder.clientcode = code;
        builder.stockcode = stock;
        
        [self subscribeBuidler:builder];
    }
}

- (void)subscribeTrade
{
    NSLog(@"MarketTrade Step 25");
//    NSLog(@"MarketTrade Step 21");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
//        [[MasterData sharedInstance] log:@"SUBSCRIBE TRADE"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeGetTrades;
        builder.requestType = RequestSubscribe;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        builder.deviceType = DeviceTypeIphone;
        if([SysAdmin sharedInstance].loginFeed != nil) {
            builder.userType = [SysAdmin sharedInstance].loginFeed.usertype;
        }
        
        [self subscribeBuidler:builder];
    }
}

- (void)changePassword:(NSString *)oldPasswd newPasswd:(NSString *)newPasswd
{
    NSLog(@"MarketTrade Step 26");
//    NSLog(@"MarketTrade Step 22");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        NSLog(@"%s old passwd = %@, new passwd = %@", __PRETTY_FUNCTION__, oldPasswd, newPasswd);
//        [[MasterData sharedInstance] log:@"CHANGE PASSWORD"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePassword;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        builder.password = oldPasswd;
        builder.general = newPasswd;
        
        [self subscribeBuidler:builder];
    }
}

- (void)getDataURL:(NSString *)URL
{
    NSLog(@"URL nya adalah = %@",URL);
    
    NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:URL]];
    NSString *newStr = [NSString stringWithUTF8String:[data bytes]];
    
    NSLog(@"STRING DARI URL nya adalah = %@",newStr);
}


- (void)changePin:(NSString *)oldPin newPin:(NSString *)newPin
{
    NSLog(@"MarketTrade Step 27");
//    NSLog(@"MarketTrade Step 23");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
        NSLog(@"%s old pin = %@, new pin = %@", __PRETTY_FUNCTION__, oldPin, newPin);
//        [[MasterData sharedInstance] log:@"CHANGE PIN"];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePin;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        builder.pin = oldPin;
        builder.general = newPin;
        
        [self subscribeBuidler:builder];
    }
}

- (void)forceChange:(NSString *)pin passwd:(NSString *)password;
{
    NSLog(@"MarketTrade Step 28");
//    NSLog(@"MarketTrade Step 24");
    if (nil != [SysAdmin sharedInstance].loginFeed) {
        NSLog(@"%s force change new password = %@, new pin = %@", __PRETTY_FUNCTION__, pin, password);
//        [[MasterData sharedInstance] log:@"FORCE CHANGE PASSWORD & PIN"];
        
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeChangePinPassword;
        builder.requestType = RequestGet;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        builder.pin = pin;
        builder.password = password;
        builder.ipAddress = UDID;//[SysAdmin sharedInstance].loginFeed.ipMarket;
        
        [self subscribeBuidler:builder];
        
    }
}

- (void)composeMsg:(NSDictionary*)op composeMsg:(BOOL)b
{
    NSLog(@"MarketTrade Step 29");
//    NSLog(@"MarketTrade Step 25");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeSendSubmitOrder;
        builder.requestType = RequestGet;
        builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        
        NSString *submitOrder = [ConstractOrder composeMsgNew:op];
        long long skey = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        
        NSLog(@"TRX sKey %lld", skey);
        
//        [[MasterData sharedInstance] log:[NSString stringWithFormat:@"COMPOSE TRX MSG:: %@", submitOrder]];
        
        builder.messageOrder = submitOrder;
        builder.general = [NSString stringWithFormat:@"%lld", skey];
        builder.version = VERSION;
        
        
        [self subscribeBuidler:builder];
    }
}

- (void)entryCashWitdraw:(float)amount pin:(NSString*)tradePin clientcode:(NSString *)code
{
    NSLog(@"MarketTrade Step 30");
//    NSLog(@"MarketTrade Step 26");
    if (nil != [SysAdmin sharedInstance].loginFeed && nil != [SysAdmin sharedInstance].loginTrade) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
//        [[MasterData sharedInstance] log:[NSString stringWithFormat:@"ENTRY CASH WITHDRAW:: %.0f", amount]];
        
        RequestData_Builder *builder = [RequestData builder];
        builder.recordType = RecordTypeSubmitCashWithdraw;
        builder.requestType = RequestGet;
        builder.deviceType = DeviceTypeIphone;
        builder.sessionMi = [SysAdmin sharedInstance].loginFeed.sessionMi;
        builder.username = [SysAdmin sharedInstance].loginFeed.username;
        builder.clientcode = code;
        builder.pin = tradePin;
        
        if(nil != [SysAdmin sharedInstance].loginTrade) {
            builder.sessionOl = [SysAdmin sharedInstance].loginTrade.sessionOl;
        }
        
        CashWithdraw_Builder *cash_builder = [CashWithdraw builder];
        cash_builder.amount = amount;
        cash_builder.tradingPin = tradePin;
        cash_builder.statusAgrement = @"1";
        
        builder.cashWithdraw = [cash_builder build];
        
        [self subscribeBuidler:builder];
    }
}

- (void)doLogout
{
    NSLog(@"MarketTrade Step 31");
//    NSLog(@"MarketTrade Step 27");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self clearMarketTrade];
//    if(self.asyncSocket != nil)
//        [self.asyncSocket disconnect];
//
}

#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"MarketTrade Step 32");
//    NSLog(@"MarketTrade Step 28");
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];
    
    LoginData *login = [SysAdmin sharedInstance].sysAdminData;
    [[MarketTrade sharedInstance] loginFeed:login.username passwd:login.sessionMi];
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"MarketTrade Step 33");
//    NSLog(@"MarketTrade Step 29");
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
    NSLog(@"MarketTrade Step 34");
//    NSLog(@"MarketTrade Step 30");
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s error: %@ %@", __PRETTY_FUNCTION__, err, sock.connectedHost);
    
    
    if (nil != err && [err.description rangeOfString:@"host timed out"].location != NSNotFound) {
        NSLog(@"socketdidDisconent step 1");
        NSLog(@"HOST TIMED OUT");
        //set callback
        TradingMessage_Builder *builder = [TradingMessage builder];
        LoginData_Builder *login_builder = [LoginData builder];
        login_builder.sessionMi = @"-3";
        builder.recStatusReturn = StatusReturnResult;
        builder.recType = RecordTypeLoginMi;
        builder.recLoginData = [login_builder build];
        
//        UIViewController *v = (UIViewController *)marketTrade.objectSelector;
//        [v performSelector:marketTrade.selector withObject:[builder build] afterDelay:0.1];
        
//        [SysAdmin sharedInstance].loginFeed = nil;
        [SysAdmin sharedInstance].loginTrade = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (nil != marketTrade) {
                NSString *title = @"Network Connection Error";
                NSString *message = @"Attempt to connect to host timed out";
                
                id handler = ^(SIAlertView *alert) {
                    
                };
                SIAlertView *alert = [SystemAlert alert:title message:message handler:handler button:@"OK"];
                [alert show];
            }
        });
    }
    else {
        NSLog(@"forceLogout step 2");
        [marketTrade clearMarketTrade];
        [MarketTrade sharedInstance].forceLogout = YES;
        
        [SysAdmin sharedInstance].loginFeed = nil;
        [SysAdmin sharedInstance].loginTrade = nil;
        
    }
}

- (NSInteger)parseHeader:(NSData *)data
{
    NSLog(@"MarketTrade Step 36");
//    NSLog(@"MarketTrade Step 32");
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}

@end
