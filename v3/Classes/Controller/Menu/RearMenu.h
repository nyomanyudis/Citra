//
//  RearMenu.h
//  Ciptadana
//
//  Created by Reyhan on 10/6/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"

@interface RearMenu : UIViewController

+ (RearMenu *)sharedInstance;

- (void)showNewMenu;
- (void)logout;

@end
