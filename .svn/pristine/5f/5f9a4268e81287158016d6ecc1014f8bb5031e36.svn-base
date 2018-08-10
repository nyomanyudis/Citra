//
//  FirstChangeController.m
//  Ciptadana
//
//  Created by Reyhan on 6/27/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "FirstChangeController.h"
#import "UIButton+Customized.h"
#import "AppDelegate.h"
#import "ImageResources.h"
#import "AgentFeed.h"
#import "MLTableAlert.h"
#import "TabViewController.h"

@interface FirstChangeController () <UITextFieldDelegate>

@property NSInteger keyboard_h;

@end

@implementation FirstChangeController

@synthesize backItemButton, oldPasswdTxt, baruPasswrdTxt, baru2PasswordTxt;
@synthesize submitButton, oldPinTxt, baruPinTxt, baru2PinTxt;
@synthesize transparetView, animator, scrollView, keyboard_h, panel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    [backButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [backItemButton setCustomView:backButton];
    [submitButton BlackBackgroundCustomized];
    
    [submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    baruPasswrdTxt.delegate = self;
    baru2PasswordTxt.delegate = self;
    baruPinTxt.delegate = self;
    baru2PinTxt.delegate = self;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    [self registerForKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self refresh_layout];
    scrollView.contentOffset = CGPointMake(0, 0);
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //keyboard_h = UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? rect.size.width : rect.size.height;
    keyboard_h = rect.size.height;
    [self refresh_layout];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    keyboard_h = 0;
    [self refresh_layout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self refresh_layout];
}

- (void)refresh_layout {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    //CGFloat window_width = UIDeviceOrientationIsLandscape(self.interfaceOrientation) ? size.height : size.width;
    CGFloat window_width = size.width;
    
    panel.frame = CGRectMake(
                             round((window_width - panel.frame.size.width) / 2),
                             0,
                             panel.frame.size.width,
                             panel.frame.size.height
                             );
    
    size = [[UIApplication sharedApplication] statusBarFrame].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake( MIN(size.width, size.height),
                                                0,
                                                panel.frame.origin.y + panel.frame.size.height + keyboard_h,
                                                0
                                                );
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

//- (void)keyboardWasShown:(NSNotification*)aNotification
//{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//}
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification
//{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    scrollView.contentInset = contentInsets;
//    scrollView.scrollIndicatorInsets = contentInsets;
//}

- (UIButton *)backTabButton
{
    UIImage *image = [ImageResources imageBack];
    
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15, image.size.height + 5)];
    buttonAction.frame = CGRectMake(0, 0, image.size.width + 15, image.size.height + 5);
    
    [buttonAction setImage:image forState:UIControlStateNormal];
    [buttonAction setImage:image forState:UIControlStateHighlighted];
    
    
    return buttonAction;
}

- (void)submitButtonClicked
{
    if([baruPasswrdTxt.text isEqualToString:@""]) {
        [baruPasswrdTxt becomeFirstResponder];
        [self error:@"Please fill new password"];
    }
    else if([baru2PasswordTxt.text isEqualToString:@""]) {
        [baru2PasswordTxt becomeFirstResponder];
        [self error:@"Please fill retype password"];
    }
    else if([baruPinTxt.text isEqualToString:@""]) {
        [baruPinTxt becomeFirstResponder];
        [self error:@"Please fill new pin"];
    }
    else if([baru2PinTxt.text isEqualToString:@""]) {
        [baru2PinTxt becomeFirstResponder];
        [self error:@"Please fill retype pin"];
    }
    else if(![baruPasswrdTxt.text isEqualToString:baru2PasswordTxt.text]) {
        [baruPasswrdTxt becomeFirstResponder];
        [self error:@"Password do not match"];
    }
    else if(![baruPinTxt.text isEqualToString:baru2PinTxt.text]) {
        [baruPinTxt becomeFirstResponder];
        [self error:@"Pin do not match"];
    }
    else {
        [animator startAnimating];
        transparetView.hidden = NO;
        transparetView.alpha = 0.75;
        
        [[AgentTrade sharedInstance] forceChange:baruPinTxt.text passwd:baruPasswrdTxt.text];
    }
}

- (void)homeBarItemClicked:(id)s
{
    //[[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    //[[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)handleSingleTap:(id)sender
{
    if(oldPasswdTxt.isFirstResponder)
        [oldPasswdTxt resignFirstResponder];
    else if(baruPasswrdTxt.isFirstResponder)
        [baruPasswrdTxt resignFirstResponder];
    else if(baru2PasswordTxt.isFirstResponder)
        [baru2PasswordTxt resignFirstResponder];
    else if(oldPinTxt.isFirstResponder)
        [oldPinTxt resignFirstResponder];
    else if(baruPinTxt.isFirstResponder)
        [baruPinTxt resignFirstResponder];
    else if(baru2PinTxt.isFirstResponder)
        [baru2PinTxt resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)error:(NSString *)error
{
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor whiteColor];
        celltable.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        celltable.textLabel.numberOfLines = 0;
        
        celltable.textLabel.text = error;
        
        return celltable;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        return celltable.frame.size.height + 2;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return 1;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Alert"
                                          cancelButtonTitle:@"OK"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == baruPasswrdTxt) {
        [baru2PasswordTxt becomeFirstResponder];
    }
    else if(textField == baru2PasswordTxt) {
        [baruPinTxt becomeFirstResponder];
    }
    else if(textField == baruPinTxt) {
        [baru2PinTxt becomeFirstResponder];
    }
    else if(textField == baru2PinTxt) {
        [self resignFirstResponder];
        [self submitButtonClicked];
    }
    return YES;
}

- (void)showTab
{
    dispatch_async(dispatch_get_main_queue(), ^{
        TabViewController *c = [[TabViewController alloc] initWithNibName:@"TabViewController" bundle:[NSBundle mainBundle]];
        //[self presentViewController:c animated:YES completion:nil];
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:c animated:YES completion:nil];
    });
}


#pragma mark -
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [animator stopAnimating];
        transparetView.hidden = YES;
        transparetView.alpha = 0;
        
        if(msg.recStatusReturn == StatusReturnResult) {
            if(msg.recType == RecordTypeChangePinPassword) {
                if(msg.recLoginData.changePassword == ChangePasswordSuccess) {
                    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
                    
                    [AgentTrade sharedInstance].forceChange = NO;
                    [self dismissViewControllerAnimated:NO completion:^{
                        [self performSelector:@selector(showTab)];
                    }];
                    
                }
                else if(msg.recLoginData.changePassword == ChangePasswordNotCorrect) {
                    [self error:@"Pin or Password Not Correct"];
                }
                else if(msg.recLoginData.changePassword == ChangePasswordSessionExpired) {
                    [self error:@"Session Expired"];
                }
            }
        }
        else if(msg.recStatusMessage != nil){
            [self error:msg.recStatusMessage];
        }
        else {
            [self error:@"Unknown error"];
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
