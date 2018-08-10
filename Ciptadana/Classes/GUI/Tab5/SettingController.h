//
//  SettingController.h
//  Ciptadana
//
//  Created by Reyhan on 6/13/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"

@interface SettingController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn;

@end
