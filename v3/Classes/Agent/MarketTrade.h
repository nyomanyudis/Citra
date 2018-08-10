//
//  MarketTrade.h
//  Ciptadana
//
//  Created by Reyhan on 11/7/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"

#define LOGINTYPE @"0"
#define VERSION @"1.1"
#define APPLICATIONTYPE @"2"
#define EXPIREDMARKETSESSION 720 //dalam menit (12 Jam)
#define EXPIREDTRADINGSESSION 720 //dalam menit (12 Jam)
//#define EXPIREDTRADINGSESSION 1 //


typedef void (^MarketTradeCallback)(TradingMessage *tm, NSString *message, BOOL ok);

@interface MarketTrade : NSObject

+ (MarketTrade *)sharedInstance;

@property (nonatomic, copy) MarketTradeCallback callback;

- (void)startAgent:(NSString *)host port:(int32_t)port reconnect:(BOOL)reconnect;
//- (void)startAgent:(NSString *)userid passwd:(NSString *)passwd;
- (void)loginFeed:(NSString *)userid passwd:(NSString *)passwd;
- (void)LoginTrade:(NSString *)pin;
- (void)subscribe:(RecordType)recType requestType:(Request)reqType;
- (void)subscribe:(RecordType)recType requestType:(Request)reqType clientcode:(NSString *)code;
- (void)subscribeOrderList;
- (void)subscribeAvaiable:(NSString *)stock clientcode:(NSString *)code;
- (void)subscribeTrade;
- (void)changePassword:(NSString *)oldPasswd newPasswd:(NSString *)newPasswd;
- (void)getDataURL:(NSString *)URL;
- (void)changePin:(NSString *)oldPin newPin:(NSString *)newPin;
- (void)composeMsg:(NSDictionary*)op composeMsg:(BOOL)b;
- (void)entryCashWitdraw:(float)amount pin:(NSString*)tradePin clientcode:(NSString *)code;
- (void)forceChange:(NSString *)pin passwd:(NSString *)password;

- (void)clearMarketTrade;
- (NSArray *)getClients;
//- (NSArray *)getOrders;
+ (NSString*) statusDescription:(NSString*)status;
- (NSMutableArray *)getOrders;
- (NSInteger )getPasswordStatus;
- (Boolean )getForceLogout;
- (NSMutableArray *)getOrdersSpecificType:(NSString *)OrderType;
- (NSMutableArray *)getOrdersSpecificStatus:(NSString *)OrderStatus;
- (NSMutableArray *)getOrdersSpecificTypeAndSpecificStatus:(NSString *)OrderType OrderStatus:(NSString *)OrderStatus;
- (NSMutableDictionary *)getOrderDictionary;
- (NSArray *)getTrades;
- (NSMutableDictionary *)getTradeDictionary;
- (void)doLogout;

@end
