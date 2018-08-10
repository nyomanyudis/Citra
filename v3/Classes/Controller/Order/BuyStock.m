//
//  BuyStock.m
//  Ciptadana
//
//  Created by Reyhan on 11/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "BuyStock.h"

#import "UITextField+Addons.h"
#import "BBRealTimeCurrencyFormatter.h"
#import "BuyStockPutPrice.h"
#import "StockSuggestionField.h"
#import "UITextField+Addons.h"
//#import "StockWatchLevel2V3.h"
#import "Level2BuySell.h"
#import "TableAlert.h"
#import "SystemAlert.h"
#import "ConstractOrder.h"
#import "SettingV3.h"

@interface BuyStock () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *containerScroller;
@property (weak, nonatomic) IBOutlet StockSuggestionField *stockSuggestion;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *lot;
@property (weak, nonatomic) IBOutlet UITextField *orderpower;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UITextField *cash;
@property (weak, nonatomic) IBOutlet UIView *level2Grid;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@property (strong, nonatomic) Level2BuySell *level2;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property Float64 recOrderPower;

@end

@implementation BuyStock

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.containerScroller.backgroundColor = [UIColor greenColor];
    self.scroller.backgroundColor = [UIColor greenColor];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    NSLog(@"Client Name Nyoman = %@",c.name); //JENNY AGUS SETIAWAN
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribeOrderList];
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:c.clientcode];
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:c.clientcode];
    }

    [self performSelector:@selector(stockFieldCallback)];
    //[self.stockSuggestion initRightButtonKeyboardToolbar:@"Next" target:self selector:@selector(nextStep:)];
    [self.self.stockSuggestion initLeftRightButtonKeyboardToolbar:@"Hide" labelRight:@"Next" target:self selectorLeft:@selector(hideStep:) selectorRight:@selector(nextStep:)];
    [self.lot initLeftRightButtonKeyboardToolbar:@"Hide" labelRight:@"Next" target:self selectorLeft:@selector(hideStep:) selectorRight:@selector(nextStep:)];
    [self.price initLeftRightButtonKeyboardToolbar:@"Hide" labelRight:@"Next" target:self selectorLeft:@selector(hideStep:) selectorRight:@selector(nextStep:)];
//    [self.stockSuggestion becomeFirstResponder];
    
    NSLog(@"level2 width = %f",self.view.frame.size.width - 20);
    NSLog(@"level2 height = %f",self.level2Grid.frame.size.height);
    
    self.level2 = [[Level2BuySell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width+25, self.level2Grid.frame.size.height+148)];
    self.level2Grid.backgroundColor = [UIColor clearColor];
    [self.level2Grid addSubview:self.level2.scrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.price.delegate = self;
    self.lot.delegate = self;

    //untuk membuat padding right
    UIView *paddingViewPrice = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];
    UIView *paddingViewLot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];
    UIView *paddingViewOrderPower = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];
    UIView *paddingViewValue = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];
    UIView *paddingViewCash = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 20)];

    self.price.rightView = paddingViewPrice;
    self.price.rightViewMode = UITextFieldViewModeAlways;
    self.lot.rightView = paddingViewLot;
    self.lot.rightViewMode = UITextFieldViewModeAlways;
    self.orderpower.rightView = paddingViewOrderPower;
    self.orderpower.rightViewMode = UITextFieldViewModeAlways;
    self.value.rightView = paddingViewValue;
    self.value.rightViewMode = UITextFieldViewModeAlways;
    self.cash.rightView = paddingViewCash;
    self.cash.rightViewMode = UITextFieldViewModeAlways;
    
    // membuat placeholder color jd grey
    UIColor *color = [UIColor lightGrayColor];
    [self.stockSuggestion setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.price setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.lot setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.orderpower setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.value setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.cash setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
    
    // untuk kasih style di action button buy nya
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0 , 0, 60, 38);
    [actionButton setTitle:@"BUY" forState:UIControlStateNormal];
    [actionButton setTitle:@"BUY" forState:UIControlStateHighlighted];
    [actionButton setTitle:@"BUY" forState:UIControlStateFocused];
    [actionButton setTitle:@"BUY" forState:UIControlStateSelected];
    [actionButton addTarget:self action:@selector(buyTapped:) forControlEvents:UIControlEventTouchDown];
    [self.actionButton setCustomView:actionButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.stockSuggestion)
        [self nextStep:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
        [self calculate];
        
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

#pragma  mark - private

- (IBAction)buyTapped:(id)sender
{
    [self orderBuy];
}

- (void)orderBuy
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        int lot = 0;
        int price = 0;
        int share = 0;
        double value = 0;//price * lot * share;
        double cash = 0;
        
        KiStockData *marginStock = [[MarketData sharedInstance] getStockDataByStock:self.stockSuggestion.text];
        
        @try {
            share = [SysAdmin sharedInstance].loginFeed.lotSize;
            if(share <= 0)
                share = 100;
            lot = [self.numberFormatter numberFromString:self.lot.text].intValue;
            price = [self.numberFormatter numberFromString:self.price.text].intValue;
            cash = [self.numberFormatter numberFromString:self.cash.text].doubleValue;
            //self.cash.text = [NSString localizedStringWithFormat:@"%lu", (long)(lot * price * share)];
            
            value = price * lot * share;
            
        } @catch (NSException *exception) {
            
        }
        
        if(self.price.text.length == 0) {
            [self error:@"Price is empty"];
        }
        else if(self.lot.text.length == 0) {
            [self error:@"Lot is empty"];
        }
        else if (value > self.recOrderPower) {
            [self error:[NSString stringWithFormat:@"Client Don't have enough Order Power to Buy %@", marginStock.code]];
        }
        else if(c.isMargin && marginStock.clientType != 33) {
            [self error:[NSString stringWithFormat:@"%@ is restricted for margin client", marginStock.code]];
        }
        else {
            NSArray *cells = [NSArray arrayWithObjects: @"Client Name", c.name,
                              @"Stock", marginStock.code,
                              @"Price", [NSString localizedStringWithFormat:@"%d", price],
                              @"Lot", [NSString localizedStringWithFormat:@"%d", lot],
                              @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                              //@"Status", [OrderGrid statusDescription:order.orderStatus],
                              nil];
            
            void (^amendOnClick)(void) = ^{
                NSLog(@"BUY CLICKED");
                ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
                if(c) {
                    [self composeMsgNew:c side:@"1" stock:marginStock.code price:price qty:lot];
                    //[self performSegueWithIdentifier:@"unwindToOrderStock" sender:self];
                    
                    SWRevealViewController *revealController = self.revealViewController;
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"orderStockIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
            };
            
            
            
            NSString *title  = [NSString stringWithFormat:@"BUY %@", marginStock.code];
            
            MLTableAlert *alert = [TableAlert alertConfirmation:cells titleAlert:title  okTitle:@"CONFIRM" cancelTitle:@"CANCEL" okOnClick:amendOnClick cancelOnClick:nil cellsColor:nil];
            
            [alert setHeight:240.f];
            [alert showWithColor:WHITE];
        }
    }
    else {
        [self error:@"Client List Not Found!"];
    }
}

- (void)updateLevel2:(NSArray *)level2
{
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockSuggestion.text];
    [self.level2 updateLevel2:level2 data:data];
    
    if(self.price.text.length == 0 && level2) {
        Level2 *tmp = [level2 objectAtIndex:0];
        BuySell *buy = [tmp.bid objectAtIndex:0];
        self.price.text = [NSString localizedStringWithFormat:@"%d", buy.price];
    }
}

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(record.recordType == RecordTypeLevel2) {
        [self updateLevel2:record.level2];
    }
}

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    NSLog(@"tradeCallBackSell Nyoman = %u",tm.recType);
    if(ok && tm) {
        if(tm.recType == RecordTypeGetOrderPower) {
            NSLog(@"tradeCallBackSell Nyoman 1");
            self.recOrderPower =  tm.recOrderPower;
            self.orderpower.text = [NSString localizedStringWithFormat:@"%.0f", self.recOrderPower];
        }
        else if(tm.recType ==  RecordTypeGetCustomerPosition) {
            NSLog(@"tradeCallBackSell Nyoman 2");
            self.cash.text = [NSString localizedStringWithFormat:@"%.0f", tm.recCustomerPosition.loanBalance];
        }
    }
}

- (void)calculate
{
    if(self.recOrderPower > 0) {
        int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
        if(share == 0)
            share = 100;
        
        double price = [self.numberFormatter numberFromString:self.price.text].doubleValue;
        int32_t orderQty = [self.numberFormatter numberFromString:self.lot.text].intValue;
        
        double value = price * orderQty * share;
        
        self.value.text = [NSString localizedStringWithFormat:@"%.0f", value];
        
    }
}


- (void) keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scroller scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
}

- (void)stockFieldCallback
{
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        stock = [stock uppercaseString];
        [self nextStep:self.stockSuggestion];
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:stock];
        if(data) {
            [[MarketFeed sharedInstance] subscribe:RecordTypeLevel2 status:RequestSubscribe code:data.code];
            
            if(self.level2) {
                [self.level2 updateLevel2:[NSArray array] data:data];
            }
        }

        
    };
    
    self.stockSuggestion.callback = stockCallback;
}

- (void)nextStep:(id)sender
{
    if(sender == self.stockSuggestion) {
        if(self.stockSuggestion.text.length > 3) {
            self.price.text = @"";
            self.lot.text = @"";
            self.value.text = @"";
            //            self.cash.text = @"";
        }
    }
    else {
        [self orderBuy];
    }

}

- (void)hideStep:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//1=buy 2=sell 5=sell short M=margin
- (void)composeMsgNew:(ClientList*)client side:(NSString*)side stock:(NSString*)code price:(int)price qty:(int)lot
{
    NSLog(@"Compose New Msg ==> Client = %@, Stock = %@, Price = %i, Lot = %i", client.name, code, price, lot);
    
    LoginData *account = [SysAdmin sharedInstance].loginFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"D" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    // Body
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:code forKey:O_SYMBOL];
    [op setObject:@"0RG" forKey:O_SYMBOLSFX];
    [op setObject:side forKey:O_SIDE];
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    
    NSDate *addAHour = [date dateByAddingTimeInterval:60*60];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    [op setObject:[NSString stringWithFormat:@"%i", price] forKey:O_PRICE];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:[dateFormat stringFromDate:addAHour] forKey:O_EXPIREDATE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    //[self SubmitOrderCallback:op];
    
    [[MarketTrade sharedInstance] composeMsg:op composeMsg:YES];
}

- (void)error:(NSString *)message
{
    [[SystemAlert alertError:message handler:nil] show];
}

@end
