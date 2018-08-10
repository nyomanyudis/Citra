//
//  Agent.h
//  BackgroundTaskApp
//
//  Created by Reyhan on 5/16/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.pb.h"
#import "DBLite.h"
#import "AgentTrade.h"

//#define AGENTFEED_HOST @"202.77.108.68" //market info
//#define AGENTFEED_PORT 45027 //market info

#define AGENTTRADE_HOST @"sysadmin1.ciptadana.com" //trading prod
#define AGENTTRADE_PORT 45000 //trading

//#define AGENTTRADE_HOST @"10.10.1.90" //sysadmin demo
//#define AGENTTRADE_PORT 9000 //demo

#define HTTP_INTERVAL 30
#define URL_HTTP_SYSADMIN @"http://202.77.108.68:9000/WebserviceMarketinfo/systemadmin.jsp?id=" //prod
#define URL_SUB_TOPBROKER @"WebserviceMarketinfo/mobile.jsp?param=TopBrokerValue"
#define URL_SUB_TOPSTOCK @"WebserviceMarketinfo/mobile.jsp?param=TopStockGainerPct"
#define URL_SUB_TOPLOSER @"WebserviceMarketinfo/mobile.jsp?param=TopStockLoserPct"
#define URL_SUB_TOPVALUE @"WebserviceMarketinfo/mobile.jsp?param=TopStockValue"
#define URL_SUB_TOPACTIVE @"WebserviceMarketinfo/mobile.jsp?param=TopStockFreq"
#define URL_SUB_SUMMARY @"WebserviceMarketinfo/mobile.jsp?param=Summary"
#define URL_SUB_INDICES @"WebserviceMarketinfo/mobile.jsp?param=Indices"
#define URL_SUB_REGIONAL_INDICES @"WebserviceMarketinfo/mobile.jsp?param=Regional"
#define URL_SUB_FUTURE @"WebserviceMarketinfo/mobile.jsp?param=Futures"
#define URL_SUB_CURRENCY @"WebserviceMarketinfo/mobile.jsp?param=Currency"


typedef void (^AgentCallback)(KiRecord *record);
static NSString *FEED_HOST_IP;
static NSInteger FEED_HOST_PORT;

@interface AgentFeed : NSObject

+ (AgentFeed *)sharedInstance;
+ (void)updateHost:(NSString *)host;
+ (void)updatePORT:(NSInteger)port;

- (void)startAgent;
- (void)endAgent;

- (MarketSummary *)marketSummary;
- (void)clearMarketSummary;
- (void)clearMarketSummary:(BOOL)forcelogout;

- (void)clearAgentFeed;

//subscribe
- (void)subscribe:(RecordType)type status:(Request)status;
- (void)subscribe:(RecordType)type status:(Request)status code:(NSString *)code;
- (void)subscribeHandshake;
- (void)unsubscribe:(RecordType)type;

//block-callback
- (void)agentSelector:(SEL)selector withObject:(id)object;
- (void)agentHomeSelector:(SEL)selector withObject:(id)object;
- (void)agentCallback:(AgentCallback)callback;


@end
