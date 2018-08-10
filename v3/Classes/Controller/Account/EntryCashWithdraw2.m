//
//  EntryCashWithdraw2.m
//  Ciptadana
//
//  Created by Reyhan on 11/22/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "EntryCashWithdraw2.h"

#import "EntryCashWithdrawCell.h"
#import "UITextField+Addons.h"
#import "BBRealTimeCurrencyFormatter.h"
#import "BEMCheckBox.h"
#import "SystemAlert.h"

@interface EntryCashWithdraw2 () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) CashWithdraw *cash;

@end

@implementation EntryCashWithdraw2

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
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCashWithdraw requestType:RequestGet clientcode:c.clientcode];
    }
    
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
    UITableViewCell *cellAgreement = (UITableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    EntryCashWithdrawCell *cellAmount = (EntryCashWithdrawCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    EntryCashWithdrawCell *cellPin = (EntryCashWithdrawCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    UISwitch *sw = [cellAgreement.contentView viewWithTag:2];
    Float32 amount = 0;
    NSString *pin = cellPin.inputField.text;
    
    @try {
        amount = [numberFormatter numberFromString:cellAmount.inputField.text].floatValue;
    } @catch (NSException *exception) {
        
    }
    
    if(!sw.on)
        [self errorAlert:@"Agree before submit"];
    else if(amount <= 0)
        [self errorAlert:@"Amount is empty or zero"];
    else if(pin.length <= 0)
        [self errorAlert:@"PIN is empty"];
    else {
        ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
        if(c) {
            NSString *message = @"Is these data correct?";
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Confirm" andMessage:message];
            
            
            [alertView addButtonWithTitle:@"YES"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      [[MarketTrade sharedInstance] entryCashWitdraw:amount pin:pin clientcode:c.clientcode];
                                      
                                      cellAmount.inputField.text = @"";
                                      cellPin.inputField.text = @"";
                                  }];
            [alertView addButtonWithTitle:@"CANCEL"
                                     type:SIAlertViewButtonTypeCancel
                                  handler:^(SIAlertView *alert) {
                                      
                                  }];
            
//            alertView.willShowHandler = ^(SIAlertView *alertView) {
//                //NSLog(@"1.%@, willShowHandler", alertView);
//            };
//            alertView.didShowHandler = ^(SIAlertView *alertView) {
//                //NSLog(@"2.%@, didShowHandler", alertView);
//            };
//            alertView.willDismissHandler = ^(SIAlertView *alertView) {
//                //NSLog(@"3.%@, willDismissHandler", alertView);
//            };
//            alertView.didDismissHandler = ^(SIAlertView *alertView) {
//                //NSLog(@"4.%@, didDismissHandler", alertView);
//            };
            
            alertView.transitionStyle = SIAlertViewTransitionStyleFade;
            [alertView show];
        }
        else {
            [self errorAlert:@"Client is empty"];
        }
    }
    
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
        if(tm.recType == RecordTypeGetCashWithdraw) {
            CashWithdraw *cash = tm.recCashWithdraw;
            self.cash = cash;
            [self.table reloadData];
            
        }
        else if(tm.recType == RecordTypeSubmitCashWithdraw) {
            if(tm.recStatusReturn == StatusReturnError) {
//                NSString *alert = [NSString stringWithFormat:@"ada error di message %@", tm.recCashWithdraw];
//                NSLog(@"errornya?: %@", alert);
            }
            else {
                NSString *message = [NSString stringWithFormat:@"Cash Withdraw was accepted with ID %@", tm.recCashWithdraw.id];
                
                SIAlertView *alert = [SystemAlert alert:@"RESULT" message:message handler:nil button:@"OK"];
                [alert show];
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
        return NO;
    }
    return YES;
}

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
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < 6) {
        EntryCashWithdrawCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
        
        if(!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EntryCashWithdrawCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(0 == indexPath.row) {
                cell.label.text = @"CURRENT CASH";
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputField.enabled = NO;
                cell.inputField.textAlignment = NSTextAlignmentRight;
                if(self.cash)
                   [cell.inputField setText:[NSString localizedStringWithFormat:@"%.0f", self.cash.currentCash]];
            }
            if(1 == indexPath.row) {
                cell.label.text = @"TRANSFER TO";
                cell.inputField.enabled = NO;
                if(self.cash) {
                    NSArray *arr = [self.cash.transferTo componentsSeparatedByString:@"|"];
                    if(arr.count > 2)
                        [cell.inputField setText:[arr objectAtIndex:0]];
                }
            }
            if(2 == indexPath.row) {
                cell.label.text = @"";
                cell.inputField.enabled = NO;
                if(self.cash) {
                    NSArray *arr = [self.cash.transferTo componentsSeparatedByString:@"|"];
                    if(arr.count > 2)
                        [cell.inputField setText:[arr objectAtIndex:1]];
                }
            }
            if(3 == indexPath.row) {
                cell.label.text = @"";
                cell.inputField.enabled = NO;
                if(self.cash) {
                    NSArray *arr = [self.cash.transferTo componentsSeparatedByString:@"|"];
                    if(arr.count > 2)
                        [cell.inputField setText:[arr objectAtIndex:2]];
                }
            }
            if(4 == indexPath.row) {
                cell.label.text = @"AMOUNT";
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputField.textAlignment = NSTextAlignmentRight;
                //[cell.inputField becomeFirstResponder];
            }
            if(5 == indexPath.row) {
                cell.label.text = @"TRADE PIN";
                cell.inputField.keyboardType = UIKeyboardTypeNumberPad;
                cell.inputField.textAlignment = NSTextAlignmentRight;
                cell.inputField.secureTextEntry = YES;
            }
            
            cell.inputField.delegate = self;
            
        }
        
        return cell;
    }
    else if (6 == indexPath.row) {
        UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EntryCashWithdrawCell" owner:self options:nil] objectAtIndex:1];
        return cell;
    }
    else {
        NSString *text = @"Saya menyetujui prosedur penarikan dana ini, dan membebaskan PT. Ciptadana Securities dari segala tanggung jawab atas kesalahan yang dapat terjadi dari penarikan ini";
        if(indexPath.row == 8)
            text = @"I agree with this fund withdrawal procedure and acquit PT. Ciptadana Securities from all responsibility of any failure that may beoccured from this fund withdrawal";
        
        NSString *reuseIdentifier = [NSString stringWithFormat:@"DefaultIdentifier%d", (int)indexPath.row];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font = FONT_TITLE_DEFAULT_LABEL ;
        cell.textLabel.text = text;
        
        if(indexPath.row == 8)
            cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        
        return cell;
    }
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
    if(indexPath.row > 6)
        return UITableViewAutomaticDimension;
    return 35.f;
}

@end
