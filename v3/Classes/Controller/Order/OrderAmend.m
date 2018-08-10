//
//  OrderAmend.m
//  Ciptadana
//
//  Created by Reyhan on 12/21/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "OrderAmend.h"

#import "BBRealTimeCurrencyFormatter.h"
#import "TableAlert.h"
#import "SystemAlert.h"
#import "ConstractOrder.h"
#import "UIButton+Addons.h"

@interface OrderAmend () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *client;
@property (weak, nonatomic) IBOutlet UITextField *stock;
@property (weak, nonatomic) IBOutlet UITextField *jatsid;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *lot;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property (assign, nonatomic) Float64 orderPower;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation OrderAmend

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.price.delegate = self;
    self.lot.delegate = self;
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0 , 0, 70, 38);
    [actionButton setTitle:@"AMEND" forState:UIControlStateNormal];
    [actionButton setTitle:@"AMEND" forState:UIControlStateHighlighted];
    [actionButton setTitle:@"AMEND" forState:UIControlStateFocused];
    [actionButton setTitle:@"AMEND" forState:UIControlStateSelected];
    [actionButton addTarget:self action:@selector(submitAmend:) forControlEvents:UIControlEventTouchDown];
    [self.actionButton setCustomView:actionButton];
    
    UIImage *imageLeft = [UIImage imageNamed:@"left"];
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
    [btn setImage:imageLeft forState:UIControlStateNormal];
    [btn clearBackground];
    
    [self.backButton setCustomView:btn];
    [btn addTarget:self action:@selector(backSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.order) {
        TxOrder *order = self.order;
        int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
        if(share == 0)
            share = 100;
        
        double value = order.price * order.orderQty * share;
        
        //Float64 op = self.orderPower + (self.txOrder.price * (fabs(self.txOrder.tradeQty - self.txOrder.orderQty)) * share);
        self.client.text = order.clientName;
        self.stock.text = order.securityCode;
        self.jatsid.text = order.jatsOrderId;
        self.price.text = [NSString localizedStringWithFormat:@"%d", order.price];
        self.lot.text = [NSString localizedStringWithFormat:@"%.0f", order.orderQty];
        self.value.text = [NSString localizedStringWithFormat:@"%.0f", value];
        
        
        ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
        if(c) {
            self.client.text = c.name;
            
            if(order.side == 1)
                [[MarketTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:c.clientcode];
            else
                [[MarketTrade sharedInstance] subscribeAvaiable:order.securityCode clientcode:c.clientcode];
        }
        
        if(order.side == 1) {
            self.title = @"AMEND BUY";
            self.balanceLabel.text = @"Order Power";
        }
        else {
            self.title = @"AMEND SELL";
            self.balanceLabel.text = @"Avaiable";
        }
        
        [self.price becomeFirstResponder];
        
        [self addpadding];
        
        [self performSelector:@selector(highlightedPrice) withObject:nil afterDelay:.1f];
    }
}

- (void) addpadding
{
    UIView *paddingViewClient = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewStock = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewJatsID = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewPrice = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewLot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewValue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    UIView *paddingViewBalance = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    
    
    self.client.leftView = paddingViewClient;
    self.client.leftViewMode = UITextFieldViewModeAlways;
    self.stock.leftView = paddingViewStock;
    self.stock.leftViewMode = UITextFieldViewModeAlways;
    self.jatsid.leftView = paddingViewJatsID;
    self.jatsid.leftViewMode = UITextFieldViewModeAlways;
    self.price.leftView = paddingViewPrice;
    self.price.leftViewMode = UITextFieldViewModeAlways;
    self.lot.leftView = paddingViewLot;
    self.lot.leftViewMode = UITextFieldViewModeAlways;
    self.value.leftView = paddingViewValue;
    self.value.leftViewMode = UITextFieldViewModeAlways;
    self.balance.leftView = paddingViewBalance;
    self.balance.leftViewMode = UITextFieldViewModeAlways;
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

#pragma mark - protected

//- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
//{
//    NSLog(@"tradeCallBackSell Nyoman = %u",tm.recType);
//    if(ok && tm) {
//        if(tm.recType == RecordTypeGetOrderPower) {
//            NSLog(@"tradeCallBackSell Nyoman 1");
//            self.recOrderPower =  tm.recOrderPower;
//            self.orderpower.text = [NSString localizedStringWithFormat:@"%.0f", self.recOrderPower];
//        }
//        else if(tm.recType ==  RecordTypeGetCustomerPosition) {
//            NSLog(@"tradeCallBackSell Nyoman 2");
//            self.cash.text = [NSString localizedStringWithFormat:@"%.0f", tm.recCustomerPosition.loanBalance];
//        }
//    }
//}


- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeGetOrderPower) {
            NSLog(@"Order Power Amend = %f",tm.recOrderPower);
            self.orderPower = tm.recOrderPower;
            self.balance.text = [NSString localizedStringWithFormat:@"%.0f", self.orderPower];
            [self calculate];
        }
        else if(tm.recType == RecordTypeGetAvaiableStock) {
            self.orderPower = tm.recAvaiableStock;
            [self calculate];
        }
    }
}

#pragma mark - private

- (IBAction)backSelector:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToOrderStock" sender:self];
}
- (void)highlightedPrice
{
    [self.price setSelectedTextRange:[self.price textRangeFromPosition:self.price.beginningOfDocument toPosition:self.price.endOfDocument]];
}

- (void)calculate
{
    if(self.order && self.orderPower > 0) {
        int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
        if(share == 0)
            share = 100;
        
        double price = [self.numberFormatter numberFromString:self.price.text].doubleValue;
        int32_t orderQty = [self.numberFormatter numberFromString:self.lot.text].intValue;
        
        double value = price * orderQty * share;
        
        self.value.text = [NSString localizedStringWithFormat:@"%.0f", value];
        
//        if(self.order.side == 1) {
//            Float64 op = self.orderPower - (price * (fabs(self.order.tradeQty - orderQty)) * share);
//            
//            self.balance.text = [NSString localizedStringWithFormat:@"%.0f", op];
//        }
//        else {
//            self.balance.text = [NSString localizedStringWithFormat:@"%.0f", (self.orderPower - orderQty)];
//        }
        
//        NSLog(@"balance: %@", self.balance.text);
    }
}

- (IBAction)submitAmend:(id)sender
{
    
    if(self.order) {
        int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
        if(share == 0)
            share = 100;
        
        double price = [self.numberFormatter numberFromString:self.price.text].doubleValue;
        int32_t orderQty = [self.numberFormatter numberFromString:self.lot.text].intValue;
        //double value = price * orderQty * share;
        Float64 op = self.orderPower - (price * (fabs(self.order.tradeQty - orderQty)) * share);
        
        if(price == 0) {
            [self alert:@"Price must be greater than zero"];
        }
        else if(orderQty == 0) {
            [self alert:@"Lot must be greater than zero"];
        }
        else if(orderQty == self.order.orderQty && price == self.order.price) {
            [self alert:@"Change the value to do Amend"];
        }
        else if(1 == self.order.side && op < 0) {
            [self alert:@"You don't have enough Orderpower"];
        }
        else {
            NSArray *cells = [self orderDetail:self.order];
            
            void (^amendOnClick)(void) = ^{
                NSLog(@"AMEND CLICKED");
                ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
                if(c) {
                    [self composeMsgAmend:c txOrder:self.order quantity:orderQty price:price];
                    [self performSegueWithIdentifier:@"unwindToOrderStock" sender:self];
                }
            };
            
            NSString *title  = @"AMEND BUY";
            if(self.order.side == 2)
                title = @"AMEND SELL";
            
            MLTableAlert *alert = [TableAlert alertConfirmation:cells titleAlert:@"AMEND ORDER"  okTitle:@"SUBMIT" cancelTitle:@"CANCEL" okOnClick:amendOnClick cancelOnClick:nil cellsColor:nil];
            
            [alert setHeight:210.f];
            [alert showWithColor:WHITE];
        }
    }
    else {
        [self alert:@"Order not found, back and try again"];
    }
    
}

- (NSArray *)orderDetail:(TxOrder *)order
{
    int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
    if(share == 0)
        share = 100;
    
    double price = [self.numberFormatter numberFromString:self.price.text].doubleValue;
    int32_t orderQty = [self.numberFormatter numberFromString:self.lot.text].intValue;
    
    double value = price * orderQty * share;
    
    NSArray *cells = [NSArray arrayWithObjects: @"Client Name", order.clientName,
                      @"Stock", order.securityCode,
                      @"Price", [NSString localizedStringWithFormat:@"%.0f", price],
                      @"Lot", [NSString localizedStringWithFormat:@"%d", orderQty],
                      @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                      //@"Status", [OrderGrid statusDescription:order.orderStatus],
                      nil];
    return cells;
}

- (void)alert:(NSString *)message
{
    [[SystemAlert alertError:message handler:nil] show];
}

- (void)composeMsgAmend:(ClientList*)client txOrder:(TxOrder*)order quantity:(uint32_t)lot price:(Float32)price;
{
    LoginData *account = [SysAdmin sharedInstance].loginFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"G" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    
    // Body
    [op setObject:order.clientId forKey:O_CLIENTID];
    [op setObject:order.jatsOrderId forKey:O_ORDERID];
    [op setObject:order.orderId forKey:O_ORIGCLORDID];
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:order.securityCode forKey:O_SYMBOL];
    [op setObject:order.board forKey:O_SYMBOLSFX];
    [op setObject:[NSString stringWithFormat:@"%i", order.side] forKey:O_SIDE];
    //    [op setObject:[NSString stringWithFormat:@"%.0f", order.orderQty] forKey:O_ORDERQTY];
    //    [op setObject:[NSString stringWithFormat:@"%i", order.price] forKey:O_PRICE];
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%.0f", price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
//     NSLog(@"op = %@",op);
    
    [[MarketTrade sharedInstance] composeMsg:op composeMsg:YES];
}

- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scroll scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroll.contentInset = contentInsets;
    self.scroll.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL ret = YES;
    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
        //return NO;
        ret = NO;
    }
    
    if(textField == self.price || textField == self.lot ) {
        [self calculate];
    }
    
    return ret;
}

@end
