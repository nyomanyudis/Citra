//
//  Agent.m
//  BackgroundTaskApp
//
//  Created by Reyhan on 5/16/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AppDelegate.h"
#import "AgentFeed.h"
//#import "Protocol.pb.h"
#import "GCDAsyncSocket.h"
#import "Connectivity.h"
#import "UIViewController+Controller.h"
#import "AbstractViewController.h"
#import "ViewController.h"
#import "LoginMiViewController.h"

#import "UIBAlertView.h"


static AgentFeed *agentMarket;

@interface AgentFeed () <GCDAsyncSocketDelegate>

@property (assign, nonatomic) id objectSelector;
@property (assign, nonatomic) SEL selector;
@property (assign, nonatomic) id objectHomeSelector;
@property (assign, nonatomic) SEL homeSelector;
@property (strong, nonatomic) GCDAsyncSocket *asyncSocket;
@property (nonatomic, copy) AgentCallback agentCallback;
@property (nonatomic) MarketSummary *market;
@property BOOL forcelogout;
- (void)runAgent;


@end




@implementation AgentFeed

+ (AgentFeed*)sharedInstance
{
    if (nil == agentMarket) {
        //NSLog(@"%s %@:%i", __PRETTY_FUNCTION__, AGENTFEED_HOST, AGENTFEED_PORT);
        NSLog(@"%s %@:%li", __PRETTY_FUNCTION__, FEED_HOST_IP, (long)FEED_HOST_PORT);
        agentMarket = [[AgentFeed alloc] init];
    }
    
    return agentMarket;
}

+ (void)updateHost:(NSString *)host
{
    FEED_HOST_IP = host;
}

+ (void)updatePORT:(NSInteger)port
{
    FEED_HOST_PORT = port;
}


- (void)startAgent
{
    self.forcelogout = NO;
    
    if (isConnectivityAvailable()) {
        [[DBLite sharedInstance] clearDictionary];
        [[AgentFeed sharedInstance] clearMarketSummary];
        
        [NSTimer scheduledTimerWithTimeInterval:.5 target:agentMarket selector:@selector(runAgent) userInfo:nil repeats:NO];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //[NSTimer scheduledTimerWithTimeInterval:10 target:agentMarket selector:@selector(startAgent) userInfo:nil repeats:NO];
            
            AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
            UIViewController *top = [delegate topViewController];
            
            [delegate goToFirstPage:top];
            
//            if(![top isMemberOfClass:[UIAlertController class]]) {
//                NSString *title = @"No Network Connection";
//                NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
//                NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
//                
//                [[[UIBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
//
//                top = [delegate topViewController];
//                if(![top isMemberOfClass:[UIAlertController class]])
//                    [delegate gotoHome:top];
//            }
//            else {
//            }
            
        });
    }
}

- (void)endAgent
{
    if (nil != self.asyncSocket) {
        [self.asyncSocket disconnect];
    }
}

- (MarketSummary *)marketSummary
{
    return self.market;
}

- (void)clearMarketSummary
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.market = nil;
}

- (void)clearMarketSummary:(BOOL)forcelogout
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.market = nil;
    
    if (forcelogout) {
        self.forcelogout = forcelogout;
        if (nil != self.asyncSocket) {
            [self.asyncSocket disconnect];
        }
    }
}

- (void)clearAgentFeed
{
    agentMarket = nil;
}

- (void)agentSelector:(SEL)selector withObject:(id)object
{
    agentMarket.selector = selector;
    agentMarket.objectSelector = object;
}

- (void)agentHomeSelector:(SEL)selector withObject:(id)object
{
    self.homeSelector = selector;
    self.objectHomeSelector = object;
}

- (void)agentCallback:(AgentCallback)callback
{
    agentMarket.agentCallback = callback;
}

- (void)subscribe:(RecordType)type status:(Request)status
{
    NSLog(@"%s type = %u, status = %u", __PRETTY_FUNCTION__, type, status);
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = type;
    req.status = status;
    
    [self subscribeBuidler:req];
}

- (void)subscribe:(RecordType)type status:(Request)status code:(NSString *)code
{
    NSLog(@"%s type = %u, status = %u, code = %@", __PRETTY_FUNCTION__, type, status, code);
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = type;
    req.status = status;
    req.code = code;
    
    [self subscribeBuidler:req];
}

- (void)subscribeHandshake
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *udid = [defaults objectForKey:@"userIdentifier"];
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = RecordTypeKiRequest;
    req.status = RequestGet;
//    req.key = [NSString stringWithFormat:@"%@|%@", @"C1PT4D4N4", udid];
    req.key = @"C1PT4D4N4";
    
    [self subscribeBuidler:req];
}

- (void)unsubscribe:(RecordType)type
{
    NSLog(@"%s type = %i", __PRETTY_FUNCTION__, type);
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = type;
    req.status = RequestUnsubscribe;
    
    [self subscribeBuidler:req];
}

#pragma mark -
#pragma private method

- (void)runAgent
{
    @try {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        NSString *host = FEED_HOST_IP;
        NSInteger port = FEED_HOST_PORT;
        
        if (nil == host) {
            NSLog(@"Ga Dapet Feed");
//            host = AGENTFEED_HOST;
//            port = AGENTFEED_PORT;
        }
        
        NSLog(@"%s RUN AGENT %@ %i", __PRETTY_FUNCTION__, host, (int)port);
        
        self.asyncSocket = nil;
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        NSError *error = nil;
        
        
        
        if (![self.asyncSocket connectToHost:host
                                      onPort:port
                                 withTimeout:30
                                       error:&error]) {
            NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception: %@", __PRETTY_FUNCTION__, exception);
    }
}

- (void)reconnectAgent
{
    SEL selector = agentMarket.selector;
    AgentCallback callback = agentMarket.agentCallback;
    
    
    self.asyncSocket = nil;
    agentMarket = nil;
    
    agentMarket = [AgentFeed sharedInstance];
    [agentMarket startAgent];
    agentMarket.selector = selector;
    agentMarket.agentCallback = callback;
}

- (void)subscribeBuidler:(KiRequest_Builder*)req
{
    KiRecord *record = [[[KiRecord builder] setRequest:req.build] build];
    
    uint32_t fileLength = CFSwapInt32((uint32_t)record.data.length);
    NSData *lengthData = [NSData dataWithBytes:&fileLength length:sizeof(4)];
    
    NSMutableData *mutable = [NSMutableData dataWithData:lengthData];
    [mutable appendData:record.data];
    
    [self.asyncSocket writeData:mutable withTimeout:-1 tag:0];
}

- (void)subscribeAllData
{
    if ([[DBLite sharedInstance] shouldUpdateDB]) {
        NSLog(@"%s REQUEST UPDATE DB", __PRETTY_FUNCTION__);
        [self subscribe:RecordTypeKiStockData status:RequestGet];
        [self subscribe:RecordTypeKiBrokerData status:RequestGet];
        [self subscribe:RecordTypeKiIndicesData status:RequestGet];
        [self subscribe:RecordTypeKiRegionalIndicesData status:RequestGet];
        [self subscribe:RecordTypeKiCurrencyData status:RequestGet];
    }
    
    [self subscribe:RecordTypeKiStockSummary status:RequestSubscribe];
    [self subscribe:RecordTypeBrokerSummary status:RequestSubscribe];
    [self subscribe:RecordTypeKiIndices status:RequestSubscribe];
    [self subscribe:RecordTypeKiRegionalIndices status:RequestSubscribe];
    [self subscribe:RecordTypeFutures status:RequestSubscribe];
    [self subscribe:RecordTypeMarketSummary status:RequestSubscribe];
    [self subscribe:RecordTypeKiCurrency status:RequestSubscribe];
}

- (void)parseReadData:(NSData*)data
{
    @try {
        
        KiRecord *ki = [KiRecord parseFromData:data];
        
        if(RecordTypeKiRequest == ki.recordType) {
            NSLog(@"%s HANDSHAKING SUCCESS", __PRETTY_FUNCTION__);
            [self subscribeAllData];
        }
        
        // ### Begin - Data ###
        //#1
        else if(RecordTypeKiStockData == ki.recordType) {
            [[DBLite sharedInstance] storeStockData:ki.stockData];
        }
        //#2
        else if(RecordTypeKiBrokerData == ki.recordType) {
            [[DBLite sharedInstance] storeBrokerData:ki.brokerData];
        }
        //#3
        else if(RecordTypeKiIndicesData == ki.recordType) {
            [[DBLite sharedInstance] storeIndicesData:ki.indicesData];
        }
        //#4
        else if(RecordTypeKiRegionalIndicesData == ki.recordType) {
            [[DBLite sharedInstance] storeRegionalIndicesData:ki.regionalIndicesData];
            
//            //debug only
//            for(KiRegionalIndicesData *d in ki.regionalIndicesData) {
//                NSLog(@"### REGIONAL INDICES DATA CODE:%@, NAME:%@", d.code, d.name);
//            }
        }
        //#5
        else if(RecordTypeKiCurrencyData == ki.recordType) {
            [[DBLite sharedInstance] storeCurrencyData:ki.currencyData];
            
            if ([[DBLite sharedInstance] shouldUpdateDB]) {
                [[DBLite sharedInstance] updateLastDB];
            }
        }
        // ### End - Data ###
//        else {
//            NSLog(@"%@", ki);
//        }
        
        else if(RecordTypeMarketSummary == ki.recordType) {
            self.market = ki.marketSummary;
        }
        else if(RecordTypeKiStockSummary == ki.recordType) {
            [[DBLite sharedInstance] storeStockSummary:ki.stockSummary];
        }
        else if(RecordTypeBrokerSummary == ki.recordType) {
            [[DBLite sharedInstance] storeBrokerSummary:ki.brokerSummary];
        }
        else if(RecordTypeKiIndices == ki.recordType) {
            [[DBLite sharedInstance] storeIndices:ki.indices];
        }
        else if(RecordTypeKiRegionalIndices == ki.recordType) {
            [[DBLite sharedInstance] storeRegionalIndices:ki.regionalIndices];
        }
        else if(RecordTypeFutures == ki.recordType) {
            [[DBLite sharedInstance] storeFuture:ki.future];
        }
        else if(RecordTypeKiCurrency == ki.recordType) {
            
            //[((AppDelegate *)[[UIApplication sharedApplication] delegate]) startHometimer];
            
            [[DBLite sharedInstance] storeCurrency:ki.currency];
        }
        else if(RecordTypeMarketSummary == ki.recordType) {
            
        }
        else if(RecordTypeKiTrade == ki.recordType) {
            
        }
        else if(RecordTypeBrokerNetbuysell == ki.recordType) {
            
        }
        else if(RecordTypeStockNetbuysell == ki.recordType) {
            
        }
        else if(RecordTypeKiLastTrade == ki.recordType) {
            
        }
        else if(RecordTypeLevel2 == ki.recordType) {
            //NSLog(@"level2: %@", ki.level2);
        }
        else if(RecordTypeLevel3 == ki.recordType) {
            
        }
        else if(RecordTypeStockHistory == ki.recordType) {
            
        }
        else if(RecordTypeIdxTradingStatus == ki.recordType) {
            //NSLog(@"%s PING STATUS", __PRETTY_FUNCTION__);
        }
        
        
        // Callback
        @try {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (nil != agentMarket.objectSelector && nil != agentMarket.selector) {
                    if([agentMarket.objectSelector isKindOfClass:[AbstractViewController class]]) {
                        AbstractViewController *v = (AbstractViewController *)agentMarket.objectSelector;
                        [v performSelector:agentMarket.selector withObject:ki afterDelay:0];
                    }
                    
                }
                else if (nil != agentMarket.objectHomeSelector && nil != agentMarket.homeSelector) {
                    if ([agentMarket.objectHomeSelector isKindOfClass:[ViewController class]]) {
                        ViewController *v = (ViewController *)agentMarket.objectHomeSelector;
                        [v performSelector:agentMarket.homeSelector withObject:ki afterDelay:0];
                    }
                }
                
                if (nil != agentMarket.agentCallback) {
                    agentMarket.agentCallback(ki);
                }
            });
        }
        @catch (NSException *exception) {
            NSLog(@"NSException %@", exception);
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception = %@", __PRETTY_FUNCTION__, exception);
    }
}


- (NSInteger)parseHeader:(NSData *)data
{
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}


#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    [self subscribeHandshake];
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];
    
    // Callback
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (nil != agentMarket.objectSelector && nil != agentMarket.selector) {
                if([agentMarket.objectSelector isKindOfClass:[LoginMiViewController class]]) {
                    LoginMiViewController *v = (LoginMiViewController *)agentMarket.objectSelector;
                    [v performSelector:agentMarket.selector withObject:nil afterDelay:0];
                }
                
            }
        });
    }
    @catch (NSException *exception) {
        NSLog(@"NSException %@", exception);
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
    
    if (!self.forcelogout)
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reconnectAgent) userInfo:nil repeats:NO];
}

@end
