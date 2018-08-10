//
//  AgentSysadmin.h
//  Ciptadana
//
//  Created by Reyhan on 5/30/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocol.pb.h"


typedef void (^AgentSysadmincCallback)(TradingMessage *msg);

@interface AgentSysadmin : NSObject

+ (AgentSysadmin *)sharedInstance;

- (void)startAgent;
- (void)loginSysadmin:(NSString *)userid passwd:(NSString *)passwd;

- (void)agentSelector:(SEL)selector withObject:(id)object;
- (void)agentSysadminCallback:(AgentSysadmincCallback)callback;

@end
