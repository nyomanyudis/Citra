//
//  MarketFeed.h
//  Ciptadana
//
//  Created by Reyhan on 10/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SysAdmin.h"

#import "Protocol.pb.h"


typedef void (^MarketFeedCallback)(KiRecord *record, NSString *message, BOOL ok);

@interface MarketFeed : NSObject

+ (MarketFeed *)sharedInstance;

@property (nonatomic, copy) MarketFeedCallback callback;
@property (nonatomic, assign) BOOL isON;

- (void)initMarket;
- (void)subscribe:(RecordType)type status:(Request)status;
- (void)subscribe:(RecordType)type status:(Request)status code:(NSString *)code;
- (void)unsubscribe:(RecordType)type;

- (MarketSummary *)marketSummary;
- (void)clearMarketSummary;

- (void)doLogout;

@end
