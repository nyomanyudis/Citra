//
//  SettingV3.h
//  Ciptadana
//
//  Created by Reyhan on 12/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "GrandController.h"

#define STORAGESETTINGKEY @"1Ce3Fbck3klsfj86A3mf34Fe0lkdfo9DKd312"

@class SettingApp;

@interface SettingV3 : GrandController


+ (BOOL)saveSetting:(SettingApp *)setting;
+ (SettingApp *)loadSetting;
-(void) actionbuttonSave;

@end

@interface  SettingApp : NSObject

@property (strong, nonatomic) NSString *host;
@property uint32_t port;
@property (assign, nonatomic) BOOL popstatus;
@property (assign, nonatomic) BOOL popsconfirm;

@end
