//
//  SysAdmin.h
//  Ciptadana
//
//  Created by Reyhan on 9/28/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.pb.h"

typedef void (^SysAdminCallback)(TradingMessage *tradingMessage, NSString *message, BOOL ok);

@interface SysAdmin : NSObject

@property (nonatomic, copy) SysAdminCallback callback;

+ (SysAdmin *)sharedInstance;

@property (nonatomic, strong) LoginData *sysAdminData;
@property (nonatomic, strong) LoginData *loginFeed;
@property (nonatomic, strong) LoginData *loginTrade;

//- (void)doLogin:(NSString *)userid andPassword:(NSString *)passwd andCallback:(SysAdminCallback)callback;
- (void)doLogin:(NSString *)userid andPassword:(NSString *)passwd;
- (void)setupAndLoginSysAdmin:(SysAdminCallback)callback;

@end
