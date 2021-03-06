//
//  LoginMiViewController.m
//  Ciptadana
//
//  Created by Reyhan on 1/23/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "LoginMiViewController.h"
#import "ImageResources.h"
#import "UIButton+Customized.h"
#import "TabViewController.h"
#import "AppDelegate.h"
//#import "UserDefaults.h"
//#import "Setting.h"
#import "AgentTrade.h"
#import "Connectivity.h"
#import "AgentSysadmin.h"
#import "FirstChangeController.h"
#import "MLTableAlert.h"
#import "Calendar.h"
#import "UIAlertView+Blocks.h"

@interface LoginMiViewController (private) <UITextFieldDelegate>

@end

@interface LoginMiViewController()

@property UIAlertView *alertLogin;
@property BOOL waitingLogin;
@property NSTimer* countDownTimer;
@property int32_t countDown;

@end

@implementation LoginMiViewController
{
    NSString *uid;
    NSString *passwd;
    NSInteger flag;
    NSString *generalMsg;
    
    NSString *host_ip;
    NSInteger *host_port;
}


@synthesize iconBarItem;
@synthesize btnCancel, btnLogin, btnRegister, tfPasswd, tfUserid, btnRememberme, errorLabel;


- (id)initWithoutCancel
{
    if(self = [super initWithNibName:@"LoginMiViewController" bundle:[NSBundle mainBundle]]) {
        
        flag = 10;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self autoloadUserId];
    
    UIImage *buttonImage = [ImageResources imageCiptadana];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:buttonImage];
    [iconBarItem setCustomView:iconView];
    
    if (flag == 10) {
        
        CGRect rect = btnLogin.frame;
        rect.origin.x = btnCancel.frame.origin.x;
        rect.origin.y = btnLogin.frame.origin.y;
        rect.size.width = rect.size.width * 2 + 20;
        btnLogin.frame = rect;
        
        [btnCancel removeFromSuperview];
    }
    else {
        [btnCancel BlackBackgroundCustomized];
    }
    
    [btnLogin BlackBackgroundCustomized];
    [btnRegister BlackBackgroundCustomized];
    
    [btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchDown];
    [btnLogin addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [btnRegister addTarget:self action:@selector(btnRegisterClicked) forControlEvents:UIControlEventTouchDown];
    
    tfUserid.delegate = self;
    tfPasswd.delegate = self;
    
    //tfUserid.text = @"mdmi0037";
    //tfPasswd.text = @"password37";
    
    [btnRememberme ButtonCheckbox];
    [btnRememberme addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchDown];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    self.waitingLogin = NO;
}

- (void)autoloadUserId
{
    NSString *userid = [DBLite sharedInstance].restoreUserid;
    if (nil != userid && ![@"" isEqualToString:userid]) {
        tfUserid.text = userid;
        btnRememberme.selected = YES;
        [tfPasswd becomeFirstResponder];
        
        AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
        tfPasswd.text = delegate.passwd;
        if([tfPasswd.text isEqualToString:@""]) {
            [tfPasswd becomeFirstResponder];
        }
    }
}

- (void)closeAlertLogin
{
    self.waitingLogin = NO;
    btnLogin.enabled = YES;
    
    if(self.countDownTimer != nil) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    if (nil != self.alertLogin) {
        [self.alertLogin dismissWithClickedButtonIndex:0 animated:YES];
        self.alertLogin = nil;
    }
    
    [self autoloadUserId];
}

- (void)showAlertLogin
{
    self.waitingLogin = YES;
    self.alertLogin = [[UIAlertView alloc] initWithTitle:@"Signing In\nPlease Wait." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.alertLogin show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(self.alertLogin.bounds.size.width / 2, self.alertLogin.bounds.size.height - 50);
    [indicator startAnimating];
    [self.alertLogin addSubview:indicator];
    
    //tunggu 20 detik atau relogin
    //[self performSelector:@selector(waitToLong) withObject:nil afterDelay:20.0];
    
    if(self.countDownTimer == nil) {
        self.countDown = 19;
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(countDownLogin)
                                                             userInfo:nil
                                                              repeats:YES];
    }
}

- (void)waitToLong
{
    if(self.waitingLogin) {
        [self closeAlertLogin];
    }
}

- (void)countDownLogin
{
    if(self.countDown >= 0 && self.alertLogin != nil) {
        if(self.countDown > 15) {
            //self.alertLogin.title = [NSString stringWithFormat:@"Signing In\nPlease Wait."];
            self.countDown --;
        }
        else {
            self.alertLogin.title = [NSString stringWithFormat:@"Signing In\nPlease Wait.(%d)", self.countDown --];
        }
    }
    else if(self.countDownTimer != nil) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        [self closeAlertLogin];
        //[self autoloadUserId];
    }
}

- (void)checkbox:(UIButton*)b
{
    if(b.selected)
        b.selected = NO;
    else
        b.selected = YES;
}

- (void)handleSingleTap:(id)sender
{
    if(tfUserid.isFirstResponder)
        [tfUserid resignFirstResponder];
    else if(tfPasswd.isFirstResponder)
        [tfPasswd resignFirstResponder];
}


- (void)btnCancelClicked:(UIButton*)button
{
    //[[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)btnRegisterClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ciptadana-securities.com/online-registration-individual/new"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnCancel:nil];
    [self setIconBarItem:nil];
    [self setTfUserid:nil];
    [self setTfPasswd:nil];
    [self setBtnRememberme:nil];
    [self setErrorLabel:nil];
    [self setBtnLogin:nil];
    [super viewDidUnload];
}

- (void)login
{
    btnRegister.hidden = YES;
    errorLabel.text = @"";

    if (isConnectivityAvailable()) {
        if (tfUserid.text.length > 0 && tfPasswd.text.length > 0) {
            
            [tfUserid resignFirstResponder];
            [tfPasswd resignFirstResponder];
            
            uid = tfUserid.text;
            passwd = tfPasswd.text;
            
//            [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
//            [[AgentTrade sharedInstance] startAgent];
            
            [self setupSysadmin];
            //[self setupTradeFeed];
            
            tfUserid.text = @"";
            tfPasswd.text = @"";
            
            btnLogin.enabled = NO;
            [self showAlertLogin];
        }
        else {
            errorLabel.text = @"Please fill the required fields (Userid & Password).";
        }
    }
    else {
        [tfUserid resignFirstResponder];
        [tfPasswd resignFirstResponder];
        NSString *title = @"No Network Connection";
        NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
        //[[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:@"CANCEL", nil];
        av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == alertView.cancelButtonIndex) {
                [self login];
            }
            else if(buttonIndex == alertView.firstOtherButtonIndex) {
                [self autoloadUserId];
                tfPasswd.text = @"";
            }
        };
        
        [av show];
    }
    
}

- (void)autoLoginWithUserid:(NSString*)userid andPasswd:(NSString*)password
{
    btnRegister.hidden = YES;
    errorLabel.text = @"";
    
    if (isConnectivityAvailable()) {
        if (userid.length > 0 && password.length > 0) {
            
            
            [tfUserid resignFirstResponder];
            [tfPasswd resignFirstResponder];
            
            uid = userid;
            passwd = password;
            
            [self setupSysadmin];
            
            tfUserid.text = @"";
            tfPasswd.text = @"";
            
            btnLogin.enabled = NO;
            [self showAlertLogin];
        }
        else {
            errorLabel.text = @"Please fill the required fields (Userid & Password).";
        }
    }
    else {
        [tfUserid resignFirstResponder];
        [tfPasswd resignFirstResponder];
        NSString *title = @"No Network Connection";
        NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
        //[[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:@"CANCEL", nil];
        av.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == alertView.cancelButtonIndex) {
                AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
                [self autoLoginWithUserid:delegate.userid  andPasswd:delegate.passwd];
            }
            else if(buttonIndex == alertView.firstOtherButtonIndex) {
                AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
                delegate.passwd = nil;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        };
        
        [av show];
    }
    
}

- (void)setupSysadmin
{
    [[AgentSysadmin sharedInstance] agentSelector:@selector(AgentSysadminCallback:) withObject:self];
    [[AgentSysadmin sharedInstance] startAgent];
}

- (void)setupTradeFeed
{
    NSLog(@"setupTradeFeed HOST : %@", TRADE_HOST_IP);
    NSLog(@"setupTradeFeed PORT : %ld", (long)TRADE_HOST_PORT);
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    [[AgentTrade sharedInstance] startAgent:TRADE_HOST_IP port:(int32_t)TRADE_HOST_PORT];
}

- (void)showTabController
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        [AgentTrade sharedInstance].loginMI = YES;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController httpStop];
        
        btnLogin.enabled = YES;
        [self closeAlertLogin];
        
        [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController startCallback];
        
        TabViewController *c = [[TabViewController alloc] initWithNibName:@"TabViewController" bundle:[NSBundle mainBundle]];
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:c animated:YES completion:nil];
    }];
}

- (void)showForceChangePasswordController
{
    [self dismissViewControllerAnimated:NO completion:^{
        
        [AgentTrade sharedInstance].forceChange = YES;
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController httpStop];
        
        btnLogin.enabled = YES;
        [self closeAlertLogin];
        
        [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
        
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController startCallback];
        
        FirstChangeController *c = [[FirstChangeController alloc] initWithNibName:@"FirstChangeController" bundle:[NSBundle mainBundle]];
        [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:c animated:YES completion:nil];
    }];
}



#pragma mark
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if(tfPasswd.text.length > 0 && tfUserid.text.length > 0) {
        [self resignFirstResponder];
        [self login];
    }
    else if(textField == tfUserid) {
        //[tfPasswd becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark -
- (void)AgentFeedCallback:(uint32_t)respons
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
        
        // request previlleges setelah sukses login
        btnLogin.enabled = YES;
        [self closeAlertLogin];
        
        if(generalMsg != nil) {
            NSArray *split = [generalMsg componentsSeparatedByString:@"|"];
            if(split.count >= 2) {
                if([@"1" isEqualToString:(NSString *)[split objectAtIndex:2]]) {
                    //harus ganti pin dan password
                    [self performSelector:@selector(showForceChangePasswordController) withObject:nil];
                }
                else {
                    [self performSelector:@selector(showTabController) withObject:nil];
                }
            }
            else {
                [self performSelector:@selector(showTabController) withObject:nil];
            }
        }
        else {
            [self performSelector:@selector(showTabController) withObject:nil];
        }
    });
}

#pragma mark -
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (RecordTypeLoginMi == msg.recType) {
            if(StatusReturnResult == msg.recStatusReturn) {
                if (nil != msg.recLoginData) {
                    if (nil != msg.recLoginData.sessionMi && [@"" isEqualToString:msg.recLoginData.sessionMi]) {
                        [AgentTrade sharedInstance].shares = msg.recLoginData.lotSize;
                    }
                    
                    if ([@"-1" isEqualToString:msg.recLoginData.sessionMi]) {
                        //did connected
                        [[AgentTrade sharedInstance] loginFeed:uid passwd:passwd];
                        
                    }
                    else if ([@"-2" isEqualToString:msg.recLoginData.sessionMi] && !btnLogin.enabled) {
                        //did disconnected
                        if (nil != uid && nil != passwd) {
                            [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
//                            [[AgentTrade sharedInstance] startAgent];
                            [[AgentTrade sharedInstance] performSelector:@selector(startAgent) withObject:nil afterDelay:.5];
                        }
                    }
                    else if([@"-2" isEqualToString:msg.recLoginData.sessionMi]) {
                        //blank
                    }
                    else if([@"-3" isEqualToString:msg.recLoginData.sessionMi]) {
                        btnLogin.enabled = YES;
                        errorLabel.text = @"";
                        [self closeAlertLogin];
                    }
                    else if (nil != msg.recLoginData.sessionMi && ![@"" isEqualToString:msg.recLoginData.sessionMi]) {
                        [((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopHomeTimer];
                        
                        if (btnRememberme.selected) {
                            [[DBLite sharedInstance] storeUserid:msg.recLoginData.username];
                        }
                        else {
                            [[DBLite sharedInstance] storeUserid:@""];
                        }
                        
                        if (nil != msg.recLoginData.ipMarket) {
                            @try {
                                NSArray *parse = [msg.recLoginData.ipMarket componentsSeparatedByString:@"|"];
                                if (parse.count >= 3) {
                                    [AgentTrade sharedInstance].shares = [[parse objectAtIndex:2] intValue];
                                }
                            }
                            @catch (NSException *exception) {
                                NSLog(@"%s exception: %@", __PRETTY_FUNCTION__, exception);
                            }
                        }
                        
                        generalMsg = msg.recLoginData.generalMsg;
                        [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
                        [[AgentFeed sharedInstance] startAgent];
                        
                    }
                }
                else {
                    //((AppDelegate *)[[UIApplication sharedApplication] delegate]).userid = nil;
                    //((AppDelegate *)[[UIApplication sharedApplication] delegate]).passwd = nil;
                    
                    btnLogin.enabled = YES;
                    errorLabel.text = @"WE ARE SORRY, AN ERROR FROM OUR SERVER, PLEASE RELOGIN OR QUIT AND REOPEN CITRA FOR iOS";
                    [self closeAlertLogin];
                }
                
            }
            else {
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).userid = nil;
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).passwd = nil;
                
                btnLogin.enabled = YES;
                errorLabel.text = msg.recStatusMessage;
                [self closeAlertLogin];
            }
        }
        else {
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).userid = nil;
            ((AppDelegate *)[[UIApplication sharedApplication] delegate]).passwd = nil;
            
            btnLogin.enabled = YES;
            errorLabel.text = msg.recStatusMessage;
            [self closeAlertLogin];
        }
    });
}


#pragma mark -
#pragma AgentTradeCallback

- (void)AgentSysadminCallback:(TradingMessage *)msg
{
    if (RecordTypeLoginMi == msg.recType) {
        if(StatusReturnResult == msg.recStatusReturn) {
            if (nil != msg.recLoginData) {
                if ([@"-1" isEqualToString:msg.recLoginData.sessionMi]) {
                    //did connected
                    [[AgentSysadmin sharedInstance] loginSysadmin:uid passwd:passwd];
                }
                else if ([@"-2" isEqualToString:msg.recLoginData.sessionMi] && !btnLogin.enabled) {
                    //did disconnected
                    if (nil != uid && nil != passwd) {
                        [self setupSysadmin];
                    }
                }
                else if([@"-2" isEqualToString:msg.recLoginData.sessionMi]) {
                    //blank
                }
                else if([@"-3" isEqualToString:msg.recLoginData.sessionMi]) {
                    //did disconnected
                    errorLabel.text = @"Host timed out. Please Re-login";
                    [self closeAlertLogin];
                    [self setupSysadmin];
                }
                else {
                    //login sukses
                    //[((AppDelegate *)[[UIApplication sharedApplication] delegate]) stopHomeTimer];
                    
                    AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
                    delegate.userid = uid;
                    delegate.passwd = passwd;
                    delegate.stringDate = [Calendar currentStringDate];
                    
                    NSLog(@"SYSADMIN TRADE : %@", msg.recLoginData.ipTrade);
                    NSLog(@"SYSADMIN FEED : %@", msg.recLoginData.ipMarket);
                    
                    NSArray *parse = [msg.recLoginData.ipTrade componentsSeparatedByString: @":"];
                    if (nil != parse && parse.count == 2) {
                        TRADE_HOST_IP = [parse objectAtIndex:0];
                        TRADE_HOST_PORT = [[parse objectAtIndex:1] integerValue];
                        [self setupTradeFeed];
                    }
                    
                    parse = [msg.recLoginData.ipMarket componentsSeparatedByString: @":"];
                    if (nil != parse && parse.count == 2) {
                        FEED_HOST_IP = [parse objectAtIndex:0];
                        FEED_HOST_PORT = [[parse objectAtIndex:1] integerValue];
                        [AgentFeed updateHost:[parse objectAtIndex:0]];
                        [AgentFeed updatePORT:[[parse objectAtIndex:1] integerValue]];
                    }
                }
            }
            else {
                btnLogin.enabled = YES;
                errorLabel.text = @"WE ARE SORRY, AN ERROR FROM OUR SERVER, PLEASE RELOGIN OR QUIT AND REOPEN CITRA FOR iOS";
                [self closeAlertLogin];
            }
        }
        else {
            if([@"Need to Update Version" isEqualToString:msg.recStatusMessage]) {
                [self closeAlertLogin];
                [self alert:[NSString stringWithFormat:@"%@.\nNew version available at Play Store", msg.recStatusMessage]];
            }
            btnLogin.enabled = YES;
            errorLabel.text = msg.recStatusMessage;
            [self closeAlertLogin];
        }
    }
    else {
        btnLogin.enabled = YES;
        errorLabel.text = msg.recStatusMessage;
        [self closeAlertLogin];
    }
}

- (void)alert:(NSString*)message
{
    
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor whiteColor];
        celltable.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        celltable.textLabel.numberOfLines = 0;
        
        celltable.textLabel.text = message;
        
        return celltable;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        return celltable.frame.size.height + 2;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return 1;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"New Version"
                                          cancelButtonTitle:@"Go to Play Store"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/id/app/ciptadana/id818184215?mt=8&uo=4"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/id/app/ciptadana/id818184215?mt=8"]];
        [alert dismissTableAlert];
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

@end
