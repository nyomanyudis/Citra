//
//  LoginMiViewController.h
//  Ciptadana
//
//  Created by Reyhan on 1/23/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"

@interface LoginMiViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iconBarItem;
@property (weak, nonatomic) IBOutlet UITextField *tfUserid;
@property (weak, nonatomic) IBOutlet UITextField *tfPasswd;
@property (weak, nonatomic) IBOutlet UIButton *btnRememberme;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (id)initWithoutCancel;
- (void)autoLoginWithUserid:(NSString*)userid andPasswd:(NSString*)password;

@end
