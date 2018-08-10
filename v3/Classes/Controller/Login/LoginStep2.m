//
//  LoginStep2ViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/25/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

//#import "SysAdmin.h"

#import "LoginStep2.h"
#import "LoginStep3.h"
#import "CustomButton.h"

#import "UIButton+Addons.h"
#import "UITextField+Addons.h"
#import "UIViewController+Addons.h"

#import "Util.h"

#define HIDE [UIImage imageNamed:@"hide"]
#define SHOW [UIImage imageNamed:@"show"]

@interface LoginStep2 () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *userAccount;

@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UILabel *userAccountTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

//@property (nonatomic, copy) void (^sysCallback)(TradingMessage *tradingMessage, NSString *message, BOOL ok);

@end

@implementation LoginStep2

- (void) viewWillAppear:(BOOL)animated{
    [self.passwordTxt becomeFirstResponder];
    
    [self.prevButton clearBackground];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userAccountTxt.text = [NSString stringWithFormat:@"%@", self.userAccount];
    
    [self.passwordTxt initRightButtonKeyboardToolbar:@"Login" target:self selector:@selector(buttonToolbarClicked)];
    [self.passwordTxt initPasswordField];
    self.passwordTxt.delegate = self;
    
    
    [self initLinearGradient:CGPointMake(0.2, 1) endPoint:CGPointZero colors:GRADIENT_GRAY_SUPERLIGHT];
    
//    [self doSysAdmin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self buttonToolbarClicked];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([[segue identifier] isEqualToString:@"identifierStep3"]){
        LoginStep3 *vc = (LoginStep3 *) segue.destinationViewController;
        if(vc){
            [vc updateUserAccount:self.userAccount andPassword:self.passwordTxt.text];
        }
    }
}


#pragma public

- (void)updateUserAccount:(NSString *)userAccount
{
    self.userAccount = userAccount;
    self.userAccountTxt.text = userAccount;
}

- (IBAction)buttonToolbarClicked
{
    [self performSegueWithIdentifier:@"identifierStep3" sender:nil];
}

@end
