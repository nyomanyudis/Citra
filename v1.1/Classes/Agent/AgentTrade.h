//
//  AgentTrade.h
//  Ciptadana
//
//  Created by Reyhan on 6/17/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.pb.h"

#define LOGINTYPE @"0"
#define VERSION @"1.1"
#define APPLICATIONTYPE @"2"
#define EXPIREDMARKETSESSION 0 //dalam menit (12 Jam)
#define EXPIREDTRADINGSESSION 720 //dalam menit (12 Jam)
//#define EXPIREDTRADINGSESSION 1 //


static NSString *TRADE_HOST_IP;
static NSInteger TRADE_HOST_PORT;


typedef void (^AgentTradeCallback)(TradingMessage *msg);

@interface AgentTrade : NSObject


@property (nonatomic) uint32_t shares;
@property (nonatomic) BOOL loginMI;
@property (nonatomic) BOOL forceChange;


+ (AgentTrade *)sharedInstance;

- (void)startAgent:(NSString *)host port:(int32_t)port;
//- (void)startAgent:(NSString *)userid passwd:(NSString *)passwd;
- (void)loginFeed:(NSString *)userid passwd:(NSString *)passwd;
- (void)LoginTrade:(NSString *)pin;
- (LoginData *)loginDataFeed;
- (LoginData *)loginDataTrade;
- (void)subscribe:(RecordType)recType requestType:(Request)reqType;
- (void)subscribe:(RecordType)recType requestType:(Request)reqType clientcode:(NSString *)code;
- (void)subscribeOrderList;
- (void)subscribeAvaiable:(NSString *)stock clientcode:(NSString *)code;
- (void)subscribeTrade;
- (void)changePassword:(NSString *)oldPasswd newPasswd:(NSString *)newPasswd;
- (void)changePin:(NSString *)oldPin newPin:(NSString *)newPin;
- (void)composeMsg:(NSDictionary*)op composeMsg:(BOOL)b;
- (void)entryCashWitdraw:(float)amount pin:(NSString*)tradePin clientcode:(NSString *)code;
- (void)forceChange:(NSString *)pin passwd:(NSString *)password;

- (void)clearAgentTrade;
- (NSArray *)getClients;
- (NSArray *)getOrders;
- (NSMutableDictionary *)getOrderDictionary;
- (NSArray *)getTrades;
- (NSMutableDictionary *)getTradeDictionary;

//block-callback
- (void)agentSelector:(SEL)selector withObject:(id)object;
- (void)agentTradeCallback:(AgentTradeCallback)callback;

- (void)logoutAlert:(NSString *)title message:(NSString *)msg idle:(BOOL)idle;


//@property (assign, nonatomic) NSString *userid;
//@property (assign, nonatomic) NSString *passwd;

@end
