//
//  OrderWithdraw.m
//  Ciptadana
//
//  Created by Reyhan on 12/21/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "OrderWithdraw.h"

#import "BBRealTimeCurrencyFormatter.h"
#import "TableAlert.h"
#import "ConstractOrder.h"

@interface OrderWithdraw () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UITextField *client;
@property (weak, nonatomic) IBOutlet UITextField *stock;
@property (weak, nonatomic) IBOutlet UITextField *jatsid;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *lot;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UITextField *balance;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@property (assign, nonatomic) Float64 orderPower;

@end

@implementation OrderWithdraw

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        
        
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame = CGRectMake(0 , 0, 80, 38);
        [actionButton setTitle:@"Withdraw" forState:UIControlStateNormal];
        [actionButton setTitle:@"Withdraw" forState:UIControlStateHighlighted];
        [actionButton setTitle:@"Withdraw" forState:UIControlStateFocused];
        [actionButton setTitle:@"Withdraw" forState:UIControlStateSelected];
        [actionButton addTarget:self action:@selector(submitWithdraw:) forControlEvents:UIControlEventTouchDown];
        [self.actionButton setCustomView:actionButton];
        
        
        ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
        if(c) {
            self.client.text = c.name;
            
            if(order.side == 1)
                [[MarketTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:c.clientcode];
            else
                [[MarketTrade sharedInstance] subscribeAvaiable:order.securityCode clientcode:c.clientcode];
        }
        
        if(order.side == 1) {
            self.title = @"WITHDRAW BUY";
            self.balanceLabel.text = @"Order Power";
        }
        else {
            self.title = @"WITHDRAW SELL";
            self.balanceLabel.text = @"Avaiable";
        }
    }
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

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeGetOrderPower) {
            self.orderPower = tm.recOrderPower;
            [self calculate];
        }
        else if(tm.recType == RecordTypeGetAvaiableStock) {
            self.orderPower = tm.recAvaiableStock;
            [self calculate];
        }
    }
}

#pragma mark - private

- (void)calculate
{
    if(self.order && self.orderPower > 0) {
        int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
        if(share == 0)
            share = 100;
        
        double value = self.order.price * self.order.orderQty * share;
        
        self.value.text = [NSString localizedStringWithFormat:@"%.0f", value];
        
        if(self.order.side == 1) {
            Float64 op = self.orderPower + (self.order.price * (fabs(self.order.tradeQty - self.order.orderQty)) * share);
            
            self.balance.text = [NSString localizedStringWithFormat:@"%.0f", op];
        }
        else {
            self.balance.text = [NSString localizedStringWithFormat:@"%.0f", (self.orderPower - self.order.orderQty)];
        }
        
        NSLog(@"balance: %@", self.balance.text);
    }
}

- (IBAction)submitWithdraw:(id)sender
{
    if(self.order) {
        NSArray *cells = [self orderDetail:self.order];
        
        void (^withdrawOnClick)(void) = ^{
            NSLog(@"WITHDRAW CLICKED");
            ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
            if(c) {
                //[self composeMsgAmend:c txOrder:self.order quantity:orderQty price:price];
                //[self performSegueWithIdentifier:@"unwindToOrderStock" sender:self];
            }
        };
        
        NSString *title  = @"WITHDRAW BUY";
        if(self.order.side == 2)
            title = @"WITHDRAW SELL";
        
        MLTableAlert *alert = [TableAlert alertConfirmation:cells titleAlert:@"WITHDRAW ORDER"  okTitle:@"SUBMIT" cancelTitle:@"CANCEL" okOnClick:withdrawOnClick cancelOnClick:nil cellsColor:nil];
        
        [alert setHeight:210.f];
        [alert showWithColor:WHITE];
    }
}

- (NSArray *)orderDetail:(TxOrder *)order
{
    int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
    if(share == 0)
        share = 100;
    
    double value = order.price * order.orderQty * share;
    
    NSArray *cells = [NSArray arrayWithObjects: @"Client Name", order.clientName,
                      @"Stock", order.securityCode,
                      @"Price", [NSString localizedStringWithFormat:@"%d", order.price],
                      @"Lot", [NSString localizedStringWithFormat:@"%.0f", order.orderQty],
                      @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                      //@"Status", [OrderGrid statusDescription:order.orderStatus],
                      nil];
    return cells;
}

- (void)composeMsgWithdraw:(ClientList*)client txOrder:(TxOrder*)order
{
    LoginData *account = [SysAdmin sharedInstance].loginFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"F" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    
    // Body
    [op setObject:account.userId forKey:O_CLIENTID];
    [op setObject:order.jatsOrderId forKey:O_ORDERID];
    [op setObject:order.orderId forKey:O_ORIGCLORDID];
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:order.securityCode forKey:O_SYMBOL];
    [op setObject:order.board forKey:O_SYMBOLSFX];
    [op setObject:[NSString stringWithFormat:@"%i", order.side] forKey:O_SIDE];
    [op setObject:[NSString stringWithFormat:@"%.2f", order.orderQty] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%i", order.price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    //[op setObject:@"1" forKey:O_ORIGGTCID];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    [[MarketTrade sharedInstance] composeMsg:op composeMsg:NO];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
        return NO;
    }
    
    return YES;
}

@end
