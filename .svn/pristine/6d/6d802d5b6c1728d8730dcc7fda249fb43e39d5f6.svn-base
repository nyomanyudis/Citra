//
//  EntryCashWithdrawController.m
//  Ciptadana
//
//  Created by Reyhan on 6/6/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "EntryCashWithdrawController.h"
#import "UIButton+Customized.h"
#import "NSString+StringAdditions.h"
#import "MLTableAlert.h"

@interface EntryCashWithdrawController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *aggrementBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;

@property (retain, nonatomic) NSArray *arrayClientList;

@property Float32 currentCash;

@end


@implementation EntryCashWithdrawController

@synthesize backBarItem, homeBarItem, aggrementBtn, sendBtn;
@synthesize arrayClientList;
@synthesize transparentView, animator;

- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
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
    
    [aggrementBtn ButtonCheckbox];
    [aggrementBtn addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchDown];
    
    [sendBtn BlackBackgroundCustomized];
    [sendBtn addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _tradingIdTxt.delegate = self;
    _cashTxt.delegate = self;
    _transferToTxt.delegate = self;
    _amountTxt.delegate = self;
    _tradePinTxt.delegate = self;
    
    //_scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height*2);
    //_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height*1.2f);
    
    [self setupView:NO];
}

- (void)subscribeCashWithdraw
{
    if ([AgentTrade sharedInstance] != nil && [AgentTrade sharedInstance].getClients != nil) {
        arrayClientList = [AgentTrade sharedInstance].getClients;
        [animator startAnimating];
        
        if(arrayClientList.count > 0) {
            ClientList *client = [arrayClientList objectAtIndex:0];
            [[AgentTrade sharedInstance] subscribe:RecordTypeGetCashWithdraw requestType:RequestGet clientcode:client.clientcode];
        }
    }
}

- (void)checkbox:(id)sender
{
    UIButton *b = sender;
    if(b.selected)
        b.selected = NO;
    else
        b.selected = YES;
}

- (void)sendButtonClicked:(id)sender
{
    if([_amountTxt.text isEqualToString:@""]) {
        [self alert:@"Amount is empty"];
    }
    else if(![self isNumeric:_amountTxt.text]) {
        [self alert:@"Amunt is numeric only"];
    }
    else if([_tradePinTxt.text isEqualToString:@""]) {
        [self alert:@"Trade pin is empty"];
    }
    else if(!aggrementBtn.selected) {
        [self alert:@"Agree to process"];
    }
    else if(arrayClientList.count <= 0) {
        //[self alert:@"You don't have Client List and Order Power"];
    }
    else {
        if(arrayClientList.count > 0) {
            ClientList *client = [arrayClientList objectAtIndex:0];
            Float32 amount = [_amountTxt.text floatValue];
            if(self.currentCash >= amount) {
                [animator startAnimating];
                transparentView.hidden = NO;
                [[AgentTrade sharedInstance] entryCashWitdraw:amount pin:_tradePinTxt.text clientcode:client.clientcode];
            }
        }
    }
}

- (BOOL)isNumeric:(NSString*)inputString
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

- (void)playAnimate
{
    //self.clientDropList.userInteractionEnabled = NO;
    _scrollView.userInteractionEnabled = NO;
    [self.animIndicator startAnimating];
}

- (void)stopAnimate
{
    //self.clientDropList.userInteractionEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    [self.animIndicator stopAnimating];
}

- (void)setupView:(bool)requestClientList
{
    AgentTrade *trade = [AgentTrade sharedInstance];
    if (trade != nil && trade.getClients != nil) {
        [self subscribeCashWithdraw];
    }
    else if(requestClientList){
        [trade subscribe:RecordTypeClientList requestType:RequestGet];
    }
    else {
        //[self alert:@"You don't have Client List and Order Power"];
    }
}

- (void)alert:(NSString*)message
{
    [self alert:message dismiss:NO];
}

- (void)alert:(NSString*)message dismiss:(BOOL)b
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
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Alert"
                                          cancelButtonTitle:@"OK"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
        if(b) {
            [self backBarItemClicked:nil];
        }
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

- (void)AgentTradeCallback:(TradingMessage *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [animator stopAnimating];
        transparentView.hidden = YES;
    });
    if (StatusReturnError == msg.recStatusReturn || StatusReturnNoresult == msg.recStatusReturn ) {
//        NSString *alert = msg.recStatusMessage;
//        if([alert isEqualToString:@""]) {
//            alert = @"NO RESULT FROM SERVER";
//        }
//        
//        [self alert:alert];
        self.currentCash = 0;
        _cashTxt.text = @"0";
        _transferToTxt.text = @"";
    }
    else if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupView:NO];
        });
    }
    else if(RecordTypeGetCashWithdraw == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CashWithdraw *cash = msg.recCashWithdraw;
            self.currentCash = cash.currentCash;
            _cashTxt.text = [NSString formatWithThousandSeparator:cash.currentCash];
            _transferToTxt.text = [cash.transferTo stringByReplacingOccurrencesOfString:@"|" withString:@" "];
        });
    }
    else if(RecordTypeSubmitCashWithdraw == msg.recType) {
        //if(msg.recCashWithdraw != nil && [msg.recCashWithdraw.statusAgrement isEqualToString:@"0"]) {
        NSString *alert = [NSString stringWithFormat:@"Cash Withdraw was accepted with ID %@", msg.recCashWithdraw.id];
        [self alert:alert dismiss:YES];
        //}
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    _activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    //self.activeField = nil;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    if(textField == _tradingIdTxt)
//        [_cashTxt becomeFirstResponder];
//    else
        if(textField == _cashTxt)
        [_transferToTxt becomeFirstResponder];
    else if(textField == _transferToTxt)
        [_amountTxt becomeFirstResponder];
    else if(textField == _amountTxt)
        [_tradePinTxt becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)viewWillAppear:(BOOL)animated {
//    
//    [super viewWillAppear:animated];
//    
//    [self registerForKeyboardNotifications];
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    [self deregisterFromKeyboardNotifications];
//    
//    [super viewWillDisappear:animated];
//    
//}
//
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//}
//
//- (void)deregisterFromKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardDidHideNotification
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
//    
//}
//
//- (void)keyboardWasShown:(NSNotification *)notification
//{
//    NSDictionary* info = [notification userInfo];
//    
//    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
////    
////    CGPoint buttonOrigin = self.signInButton.frame.origin;
////    
////    CGFloat buttonHeight = self.signInButton.frame.size.height;
//    
//    CGPoint buttonOrigin = _activeField.frame.origin;
//    
//    CGFloat buttonHeight = _activeField.frame.size.height - 70;
//    
//    CGRect visibleRect = _scrollView.frame;
//    
//    visibleRect.size.height -= keyboardSize.height;
//    
//    NSLog(@"%f - %f", visibleRect.origin.y, buttonOrigin.y);
//    
//    if (CGRectContainsPoint(visibleRect, buttonOrigin)){
//        CGPoint scrollPoint = CGPointMake(0.0, visibleRect.size.height - buttonOrigin.y + buttonHeight);
//        NSLog(@"scroll %f - %f", scrollPoint.x, scrollPoint.y);
//        
//        [self.scrollView setContentOffset:scrollPoint animated:YES];
//        
//    }
//    
//}
//
//- (void)keyboardWillBeHidden:(NSNotification *)notification
//{
//    [self.scrollView setContentOffset:CGPointZero animated:YES];
//    
//}

@end
