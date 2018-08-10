//
//  ChangePasswdViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/23/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"

@interface ChangePasswdViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;

@property (weak, nonatomic) IBOutlet UILabel *oldPasswdLabel;
@property (weak, nonatomic) IBOutlet UILabel *nwPasswdLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *nwPasswdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (assign, nonatomic) BOOL changePin;

@end
