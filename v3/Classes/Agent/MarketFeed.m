//
//  MarketFeed.m
//  Ciptadana
//
//  Created by Reyhan on 10/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "MarketFeed.h"
#import "MarketData.h"

#import "SystemAlert.h"

#import "GCDAsyncSocket.h"
#import "Connectivity.h"


static MarketFeed *marketFeed;

@interface MarketFeed () <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *asyncSocket;
@property (nonatomic) MarketSummary *market;

@end

@implementation MarketFeed

+ (MarketFeed *)sharedInstance
{
    if (nil == marketFeed) {
        NSString *ipMarket = [SysAdmin sharedInstance].sysAdminData.ipMarket;
        NSArray *splitIp = [ipMarket componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        int port = [[splitIp objectAtIndex:1] intValue];
        
        NSLog(@"init market %s %@:%d", __PRETTY_FUNCTION__, ip, port);
        marketFeed = [[MarketFeed alloc] init];
    }
    
    return marketFeed;
}

#pragma  mark - public

- (void)initMarket
{
    if (isConnectivityAvailable()) {
        if(self.isON == NO) {
            [[MarketFeed sharedInstance] clearMarketSummary];
            [NSTimer scheduledTimerWithTimeInterval:.25 target:marketFeed selector:@selector(runMarket) userInfo:nil repeats:NO];
        }
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

- (void)subscribeHandshake
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = RecordTypeKiRequest;
    req.status = RequestGet;
    req.key = @"C1PT4D4N4";
    
    [self subscribeBuidler:req];
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

- (void)unsubscribe:(RecordType)type
{
    NSLog(@"%s type = %i", __PRETTY_FUNCTION__, type);
    
    KiRequest_Builder *req = [KiRequest builder];
    req.type = type;
    req.status = RequestUnsubscribe;
    
    [self subscribeBuidler:req];
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


- (void)doLogout
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self clearMarketSummary];
    if(self.asyncSocket != nil)
        [self.asyncSocket disconnect];
    
    self.asyncSocket = nil;
}

#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    self.isON = YES;
    
    [self subscribeHandshake];
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            
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
    self.isON = NO;
}

#pragma mark - private

- (void)runMarket
{
    @try {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        if(self.asyncSocket != nil)
            [self.asyncSocket disconnect];
        
        self.asyncSocket = nil;
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        NSError *error;
        
        NSString *ipMarket = [SysAdmin sharedInstance].sysAdminData.ipMarket;
        if(!ipMarket)
            ipMarket = @"192.168.150.10:45045";
        NSArray *splitIp = [ipMarket componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        int port = [[splitIp objectAtIndex:1] intValue];
        
        NSLog(@"%s %@, PORT:%i", __PRETTY_FUNCTION__, ip, port);
        
        if (![self.asyncSocket connectToHost:ip onPort:port withTimeout:30 error:&error]) {
            
            NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
            NSString *err = [NSString stringWithFormat:@"[***] Unable to connect to due to invalid configuration. %@", error];
            [[SystemAlert alertError:err handler:nil] show];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%s SYSADMIN : %@", __PRETTY_FUNCTION__, exception);
        NSString *err = [NSString stringWithFormat:@"[***] exception. %@", exception];
        [[SystemAlert alertError:err handler:nil] show];
    }
}

- (void)subscribeAllData
{
    [self subscribe:RecordTypeKiStockData status:RequestGet];
    [self subscribe:RecordTypeKiBrokerData status:RequestGet];
    [self subscribe:RecordTypeKiIndicesData status:RequestGet];
    [self subscribe:RecordTypeKiRegionalIndicesData status:RequestGet];
    [self subscribe:RecordTypeKiCurrencyData status:RequestGet];
    
    [self subscribe:RecordTypeKiStockSummary status:RequestSubscribe];
    [self subscribe:RecordTypeKiIndices status:RequestSubscribe];
    [self subscribe:RecordTypeKiCurrency status:RequestSubscribe];
    [self subscribe:RecordTypeBrokerSummary status:RequestSubscribe];
    [self subscribe:RecordTypeKiRegionalIndices status:RequestSubscribe];
    [self subscribe:RecordTypeFutures status:RequestSubscribe];
    [self subscribe:RecordTypeMarketSummary status:RequestSubscribe];
}

- (void)parseReadData:(NSData*)data
{
    @try {
        
        KiRecord *ki = [KiRecord parseFromData:data];
        
        if(RecordTypeKiRequest == ki.recordType) {
            NSLog(@"%s HANDSHAKING SUCCESS", __PRETTY_FUNCTION__);
            [self subscribeAllData];
        }
        
        
        else if(RecordTypeKiStockData == ki.recordType) {
            [[MarketData sharedInstance] storeStockData:ki.stockData];
        }
        
        else if(RecordTypeKiBrokerData == ki.recordType) {
            [[MarketData sharedInstance] storeBrokerData:ki.brokerData];
        }
        
        else if(RecordTypeKiIndicesData == ki.recordType) {
            [[MarketData sharedInstance] storeIndicesData:ki.indicesData];
        }
        
        else if(RecordTypeKiRegionalIndicesData == ki.recordType) {
            [[MarketData sharedInstance] storeRegionalIndicesData:ki.regionalIndicesData];
        }
        else if(RecordTypeKiCurrencyData == ki.recordType) {
            [[MarketData sharedInstance] storeCurrencyData:ki.currencyData];
        }
        
        else if(RecordTypeMarketSummary == ki.recordType) {
            self.market = ki.marketSummary;
        }
        else if(RecordTypeKiStockSummary == ki.recordType) {
            [[MarketData sharedInstance] storeStockSummary:ki.stockSummary];
        }
        else if(RecordTypeBrokerSummary == ki.recordType) {
            [[MarketData sharedInstance] storeBrokerSummary:ki.brokerSummary];
        }
        else if(RecordTypeKiIndices == ki.recordType) {
            [[MarketData sharedInstance] storeIndices:ki.indices];
        }
        else if(RecordTypeKiRegionalIndices == ki.recordType) {
            [[MarketData sharedInstance] storeRegionalIndices:ki.regionalIndices];
        }
        else if(RecordTypeFutures == ki.recordType) {
            [[MarketData sharedInstance] storeFuture:ki.future];
        }
        else if(RecordTypeKiCurrency == ki.recordType) {
            
            
            [[MarketData sharedInstance] storeCurrency:ki.currency];
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
            //NSLog(@"level3: %@", ki.level3);
        }
        else if(RecordTypeStockHistory == ki.recordType) {
            //NSLog(@"history: %@", ki.stockHistory);
        }
        else if(RecordTypeIdxTradingStatus == ki.recordType) {
            //NSLog(@"%s PING STATUS", __PRETTY_FUNCTION__);
        }
        
        
        
        @try {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.callback) {
                    self.callback(ki, nil, YES);
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
        NSLog(@"%s exception = %@", __PRETTY_FUNCTION__, exception);
        if(self.callback) {
            self.callback(nil, [NSString stringWithFormat:@"exception = %@", exception], NO);
        }
    }
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


- (NSInteger)parseHeader:(NSData *)data
{
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}

@end
