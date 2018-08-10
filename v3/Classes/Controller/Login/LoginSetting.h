//
//  LoginSetting.h
//  Ciptadana
//
//  Created by Reyhan on 8/6/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STORAGESETTINGKEY @"1Ce3Fbck3klsfj86A3mf34Fe0lkdfo9DKd312"

@interface LoginSetting : UIViewController

@end

@interface  SettingApp : NSObject

@property (strong, nonatomic) NSString *host;
@property uint32_t port;
@property (assign, nonatomic) BOOL popstatus;
@property (assign, nonatomic) BOOL popsconfirm;

@end
