//
//  ChangePasswdViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/23/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "ChangePasswdViewController.h"
#import "UIButton+Customized.h"
#import "GRAlertView.h"

@interface ChangePasswdViewController () <UIAlertViewDelegate>

@end

@implementation ChangePasswdViewController
{
    GRAlertView *alert;
}

@synthesize homeBarItem, backBarItem, titleBarItem;
@synthesize oldPasswdLabel, nwPasswdLabel;
@synthesize oldPasswdTextField, confirmTextField, nwPasswdTextField;
@synthesize updateButton;
@synthesize changePin;

- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    [updateButton BlackBackgroundCustomized];
    [updateButton addTarget:self action:@selector(updateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateButtonClicked
{
    [oldPasswdTextField resignFirstResponder];
    [nwPasswdTextField resignFirstResponder];
    [confirmTextField resignFirstResponder];
    
    NSString *oldPasswd = oldPasswdTextField.text;
    NSString *nwPasswd = nwPasswdTextField.text;
    NSString *confirm = confirmTextField.text;
    
    oldPasswdTextField.text = @"";
    nwPasswdTextField.text = @"";
    confirmTextField.text = @"";

    
    if(oldPasswd.length > 0 && nwPasswd.length > 5 && confirm.length > 5) {
        
        if(changePin) {
        
            if([nwPasswd isEqualToString:confirm]) {
                [[AgentTrade sharedInstance] changePin:oldPasswd newPin:nwPasswd];
                [self progressView:@"Request changing PIN..."];
            }
            else {
                [self errorInput:@"PIN does not match the confirm PIN"];
            }
            
        }
        else {
            
            if([nwPasswd isEqualToString:confirm]) {
                [[AgentTrade sharedInstance] changePassword:oldPasswd newPasswd:nwPasswd];
                [self progressView:@"Request changing password..."];
            }
            else {
                [self errorInput:@"Password does not match the confirm password"];
            }
            
        }
    }
    else if(nwPasswd.length <= 5 || confirm.length <= 5) {
        if(changePin)
            [self errorInput:@"Pin at least 6 characters long"];
        else
            [self errorInput:@"Password at least 6 characters long"];
    }
    else {
        [self errorInput:@"Please complete all required fields"];
    }
}

- (void)errorInput:(NSString*)message
{
    GRAlertView *alertError = [[GRAlertView alloc] initWithTitle:@"Caution!"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alertError.style = GRAlertStyleAlert;
    alertError.animation = GRAlertAnimationNone;
    [alertError show];

}

- (void)progressView:(NSString*)message;
{
    alert = [[GRAlertView alloc] initWithTitle:nil
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    alert.style = GRAlertStyleInfo;
    alert.animation = GRAlertAnimationLines;
    [alert setImage:@"info"];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setOldPasswdLabel:nil];
    [self setNwPasswdLabel:nil];
    [self setOldPasswdTextField:nil];
    [self setNwPasswdTextField:nil];
    [self setConfirmTextField:nil];
    [self setUpdateButton:nil];
    [self setTitleBarItem:nil];
    [super viewDidUnload];
}



#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeChangePin == msg.recType) {
        [self changePin:msg];
    }
    else if(RecordTypeChangePassword == msg.recType) {
        [self changePasswd:msg];
    }
}

- (void)changePasswd:(TradingMessage *)tm
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(nil != alert)
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        if (nil != tm) {
            if(StatusReturnResult == tm.recStatusReturn) {
                GRAlertView *alerts = [[GRAlertView alloc] initWithTitle:@"Congratulation"
                                                                 message:@"Password Changed"
                                                                delegate:(ChangePasswdViewController*)self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                alerts.style = GRAlertStyleSuccess;
                alerts.animation = GRAlertAnimationNone;
                [alerts show];
            }
            else {
                [self errorInput:tm.recStatusMessage];
            }
        }
    });
}

- (void)changePin:(TradingMessage *)tm
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(nil != alert)
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        if (nil != tm) {
            if(StatusReturnResult == tm.recStatusReturn) {
                GRAlertView *alerts = [[GRAlertView alloc] initWithTitle:@"Congratulation"
                                                                 message:@"PIN Changed"
                                                                delegate:(ChangePasswdViewController*)self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
                alerts.style = GRAlertStyleSuccess;
                alerts.animation = GRAlertAnimationNone;
                [alerts show];
            }
            else {
                [self errorInput:tm.recStatusMessage];
            }
        }
    });
}


#pragma mark
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backBarItemClicked:nil];
}

@end
