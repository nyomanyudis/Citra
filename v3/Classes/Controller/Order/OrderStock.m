//
//  OrderStock.m
//  Ciptadana
//
//  Created by Reyhan on 11/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "OrderStock.h"

#import "OrderAmend.h"
#import "OrderWithdraw.h"

#import "HKKScrollableGridView.h"
#import "OrderGrid.h"
#import "TableAlert.h"

#import "ConstractOrder.h"
#import "DropdownButton.h"
#import "MarketTrade.h"

#define ORDER_TYPE @[@"ALL", @"BUY", @"SELL"]
#define ORDER_STATUS @[@"ALL", @"OPEN", @"FULLY MATCH",@"PARTIAL MATCH",@"POOLING",@"AMENDED",@"WITHDRAW",@"REJECTED",@"IN PROCESS",@"WAITING PROCESS"]

@interface OrderStock ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (strong, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (weak, nonatomic) IBOutlet DropdownButton *OrderTypeButton;
@property (weak, nonatomic) IBOutlet DropdownButton *OrderStatusButton;
@property (strong, nonatomic) OrderGrid *grid;

@property (strong,nonatomic) NSString *OrderType;
@property (strong,nonatomic) NSString *OrderStatus;

//@property (weak,nonatomic) 

@end

@implementation OrderStock

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self tradeCallback];
    [self callback];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // remove previous controller
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if(![controller isKindOfClass:[OrderStock class]]) {
            [controller removeFromParentViewController];
        }
    }
    
    self.client.text = @"";
    self.OrderType = @"ALL";
    self.OrderStatus = @"ALL";
    
    self.OrderTypeButton.items = ORDER_TYPE;
    self.OrderStatusButton.items = ORDER_STATUS;
    
    self.grid =[[OrderGrid alloc] initWithGridView:self.gridView];
    [self.grid updateTrades:[MarketTrade sharedInstance].getOrders OrderType:self.OrderType OrderStatus:self.OrderStatus];
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribeOrderList];
    }
    
    [self performSelector:@selector(gridCallback)];
    [self performSelector:@selector(dropdownCallback)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dropdownCallback
{
    DropdownCallback TypeCallback = ^void(NSInteger index, NSString *string) {
        self.OrderType = string;
        [self updateTradesCallBack];
    };
    
    DropdownCallback StatusCallback = ^void(NSInteger index, NSString *string) {
        self.OrderStatus = string;
        [self updateTradesCallBack];
    };
    
    
    
    [self.OrderTypeButton setDropdownCallback:TypeCallback];
    [self.OrderStatusButton setDropdownCallback:StatusCallback];
    
    
}

-(void) updateTradesCallBack
{
    MarketTrade *marketTrade = [[MarketTrade alloc] init];
    if( ([@"ALL" caseInsensitiveCompare:self.OrderType] == NSOrderedSame) && ([@"ALL" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame) ){
        NSLog(@"callback 1");
        [self.grid updateTrades:[MarketTrade sharedInstance].getOrders OrderType:self.OrderType OrderStatus:self.OrderStatus];
    }
    else if(([@"ALL" caseInsensitiveCompare:self.OrderType] == NSOrderedSame) && !([@"ALL" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame)){
        NSLog(@"callback 2");
        [self.grid updateTrades:[marketTrade getOrdersSpecificStatus:self.OrderStatus] OrderType:self.OrderType OrderStatus:self.OrderStatus];
    }
    else if(!([@"ALL" caseInsensitiveCompare:self.OrderType] == NSOrderedSame) && ([@"ALL" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame)){
        NSLog(@"callback 3");
        [self.grid updateTrades:[marketTrade getOrdersSpecificType:self.OrderType] OrderType:self.OrderType OrderStatus:self.OrderStatus];
    }
    else if(!([@"ALL" caseInsensitiveCompare:self.OrderType] == NSOrderedSame) && !([@"ALL" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame)){
        NSLog(@"callback 4");
        [self.grid updateTrades:[marketTrade getOrdersSpecificTypeAndSpecificStatus:self.OrderType OrderStatus:self.OrderStatus] OrderType:self.OrderType OrderStatus:self.OrderStatus];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"orderAmendIdentifier"]) {
        OrderAmend *vc = (OrderAmend *) segue.destinationViewController;
        if(vc) {
            // Pass any objects to the view controller here, like...
            vc.order = sender;
        }
    }
    else if ([[segue identifier] isEqualToString:@"orderWithdrawIdentifier"]) {
        OrderWithdraw *vc = (OrderWithdraw *) segue.destinationViewController;
        if(vc) {
            // Pass any objects to the view controller here, like...
            vc.order = sender;
        }
    }
}



#pragma mark - protected

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeGetOrders) {
            NSLog(@"dapet order");
            //[self.grid updateTrades:tm.recOrderlist];
            [self.grid updateTrades:[MarketTrade sharedInstance].getOrders OrderType:self.OrderType OrderStatus:self.OrderStatus];
        }
    }
}

#pragma mark - private

- (void)gridCallback
{
    HKKScrollableGridCallback callback = ^void(NSInteger index, id object) {
        if(object && [object isKindOfClass:[TxOrder class]]) {
            TxOrder *order = object;
            
            void (^amendOnClick)(void) = ^{
                //NSLog(@"AMEND CLICKED");
                [self performSegueWithIdentifier:@"orderAmendIdentifier" sender:order];
            };
            
            void (^withdrawOnClick)(void) = ^{
                //NSLog(@"WITHDRAW CLICKED");
                //[self performSegueWithIdentifier:@"orderWithdrawIdentifier" sender:order];
                [self withdrawConfirmation:order];
            };
            
            NSArray *cells = [self orderDetail:order];
            
            MLTableAlert *alert;
            
            if([order.orderStatus isEqualToString:@"1"] || [order.orderStatus isEqualToString:@"0"]) {
                alert = [TableAlert alertConfirmation:cells titleAlert:@"ORDER"  okTitle:@"AMEND" cancelTitle:@"WITHDRAW" otherTitle:@"CANCEL" okOnClick:amendOnClick cancelOnClick:withdrawOnClick otherOnClick:nil cellsColor:nil];
            }
            else if([order.orderStatus isEqualToString:@"2"]) {
                alert = [TableAlert alertConfirmationOKOnly:cells titleAlert:@"ORDER MATCH" okOnClick:nil];
            }
            else {
                NSString *title  = @"ORDER BUY";
                if(order.side == 2)
                    title = @"ORDER SELL";
                alert = [TableAlert alertConfirmationOKOnly:cells titleAlert:title okOnClick:nil];
            }
            
            if(alert) {
                [alert setHeight:300.f];
                [alert showWithColor:WHITE];
            }
        }
    };
    
    self.gridView.callback = callback;
}

- (void)withdrawConfirmation:(TxOrder *)order
{
     NSArray *cells = [self orderDetail:order];
    
    void (^withdrawOnClick)(void) = ^{
        //NSLog(@"Withdraw CONFIRMED");
        ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
        if(c)
           [self composeMsgWithdraw:c txOrder:order];
    };
    
    MLTableAlert *alert = [TableAlert alertConfirmation:cells titleAlert:@"Withdraw Confirmation" okTitle:@"Confirm" cancelTitle:@"Cancel" okOnClick:withdrawOnClick cancelOnClick:nil cellsColor:nil];
    
    [alert setHeight:300.f];
    [alert showWithColor:WHITE];
}

- (NSArray *)orderDetail:(TxOrder *)order
{
    int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
    if(share == 0)
        share = 100;
    double value = order.price * order.orderQty * share;
    
    NSArray *cells;
    
//    NSLog(@"Hasil Order Buy PopUP = %s",order.jatsOrderId);
    
    if([order.orderStatus isEqualToString:@"8"]) {
        cells = [NSArray arrayWithObjects: @"Client Name", order.clientName,
                 @"Stock", order.securityCode,
                 @"Price", [NSString localizedStringWithFormat:@"%d", order.price],
                 @"Lot", [NSString localizedStringWithFormat:@"%.0f", order.orderQty],
                 @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                 @"Status", [OrderGrid statusDescription:order.orderStatus],
                 @"Reason", order.description,
                 @"Side", 1 == order.side ? @"BUY" : @"SELL",
                 @"Match", [NSString localizedStringWithFormat:@"%.0f", order.cumQty],
                 @"Balance", [NSString localizedStringWithFormat:@"%.0f", (order.orderQty - order.cumQty)],
                 @"Jats ID", order.jatsOrderId,
                 @"Clord ID", order.orderId,
                 nil];
    }
    else {
        cells = [NSArray arrayWithObjects: @"Client Name", order.clientName,
                      @"Stock", order.securityCode,
                      @"Price", [NSString localizedStringWithFormat:@"%d", order.price],
                      @"Lot", [NSString localizedStringWithFormat:@"%.0f", order.orderQty],
                      @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                      @"Status", [OrderGrid statusDescription:order.orderStatus],
                      @"Side", 1 == order.side ? @"BUY" : @"SELL",
                      @"Match", [NSString localizedStringWithFormat:@"%.0f", order.cumQty],
                      @"Balance", [NSString localizedStringWithFormat:@"%.0f", (order.orderQty - order.cumQty)],
                      @"Jats ID", order.jatsOrderId,
                      @"Clord ID", order.orderId,
                      nil];
    }
    return cells;
}

- (NSArray *)orderWithdrawDetail:(TxOrder *)order
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
                      @"Status", [OrderGrid statusDescription:order.orderStatus],
                      @"Clord ID", order.orderId,
                      @"Jats ID", order.jatsOrderId,
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

@end
