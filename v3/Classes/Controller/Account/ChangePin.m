//
//  ChangePin.m
//  Ciptadana
//
//  Created by Reyhan on 11/29/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "ChangePin.h"

//#import "BBRealTimeCurrencyFormatter.h"
#import "EntryCashWithdrawCell.h"
#import "SystemAlert.h"
#import "UITextField+Addons.h"

@interface ChangePin () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (strong, nonatomic) UITextField *activeField;

@end

@implementation ChangePin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.rowHeight = UITableViewAutomaticDimension;
    
    self.client.text = @"";
    
    
    
//    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
//    if(c) {
//        self.client.text = c.name;
//        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCashWithdraw requestType:RequestGet clientcode:c.clientcode];
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.table.contentInset = contentInsets;
    self.table.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.table scrollRectToVisible:self.activeField.frame animated:YES];
    }
}


- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.table.contentInset = contentInsets;
    self.table.scrollIndicatorInsets = contentInsets;
}

- (IBAction)submitCash:(id)sender
{
    EntryCashWithdrawCell *cellPin = (EntryCashWithdrawCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    EntryCashWithdrawCell *cellPin1 = (EntryCashWithdrawCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    EntryCashWithdrawCell *cellPin2 = (EntryCashWithdrawCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    [cellPin.inputField resignFirstResponder];
    [cellPin1.inputField resignFirstResponder];
    [cellPin2.inputField resignFirstResponder];
    
    NSString *pin = cellPin.inputField.text;
    NSString *pin1 = cellPin1.inputField.text;
    NSString *pin2 = cellPin2.inputField.text;
    
    if(pin.length <= 0)
        [self errorAlert:@"OLD PIN is Empty"];
    else if(pin1.length == 0)
        [self errorAlert:@"NEW PIN is Empty"];
    else if(pin1.length <4){
        [self errorAlert:@"Minimum LENGTH NEW PIN is 4"];
    }
    else if(pin2.length == 0)
        [self errorAlert:@"REPEAT NEW PIN is Empty"];
    else if(![pin2 isEqualToString:pin1])
        [self errorAlert:@"NEW PIN Doesn't Match"];
    else
        [[MarketTrade sharedInstance] changePin:pin newPin:pin1];
    
}

- (void)errorAlert:(NSString *)message
{
    SIAlertView *alert = [SystemAlert alert:@"ERROR" message:message handler:nil button:@"OK"];
    [alert show];
}

#pragma mark - protected

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeChangePin && tm.recStatusReturn == StatusReturnResult) {
            SIAlertView *alert = [SystemAlert alert:@"Congratulation" message:@"PIN Changed" handler:nil button:@"OK"];
            [alert show];
        }
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
//        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
//        return NO;
//    }
//    return YES;
//}

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntryCashWithdrawCell *cell;
    
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EntryCashWithdrawCell" owner:self options:nil] objectAtIndex:0];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];
        
        cell.inputField.rightView = paddingView;
        cell.inputField.rightViewMode = UITextFieldViewModeAlways;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.inputField initLeftRightButtonKeyboardToolbar:@"Hide" labelRight:@"Next" target:self selectorLeft:@selector(hideStep:) selectorRight:@selector(submitCash:)];
        
        if(0 == indexPath.row) {
            cell.label.text = @"OLD PIN";
            cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputField.textAlignment = NSTextAlignmentRight;
            cell.inputField.secureTextEntry = YES;
            [cell.inputField becomeFirstResponder];
        }
        else if(1 == indexPath.row) {
            cell.label.text = @"NEW PIN";
            cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputField.textAlignment = NSTextAlignmentRight;
            cell.inputField.secureTextEntry = YES;
            //[cell.inputField becomeFirstResponder];
        }
        else if(2 == indexPath.row) {
            cell.label.text = @"REPEAT NEW PIN";
            cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputField.textAlignment = NSTextAlignmentRight;
            cell.inputField.secureTextEntry = YES;
            //[cell.inputField becomeFirstResponder];
        }
    }
    
    return cell;
}

- (void)hideStep:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < 6) {
        EntryCashWithdrawCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell) {
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.inputField becomeFirstResponder];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.f;
}

@end
