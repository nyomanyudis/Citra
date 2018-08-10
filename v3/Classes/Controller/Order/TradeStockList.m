//
//  TradeStockList.m
//  Ciptadana
//
//  Created by Reyhan on 11/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TradeStockList.h"

#import "TradeGrid.h"
#import "TableAlert.h"
#import "OrderGrid.h"

@interface TradeStockList ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (strong, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (strong, nonatomic) TradeGrid *grid;

@end

@implementation TradeStockList

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
    
    self.client.text = @"";
    
    self.grid =[[TradeGrid alloc] initWithGridView:self.gridView];
    [self.grid updateTrades:[MarketTrade sharedInstance].getTrades];
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribeTrade];
    }
    
    [self performSelector:@selector(gridCallback)];
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
        if(tm.recType == RecordTypeGetTrades) {
            NSLog(@"dapet order");
            //[self.grid updateTrades:tm.recOrderlist];
            [self.grid updateTrades:[MarketTrade sharedInstance].getTrades];
        }
    }
}

#pragma mark - private

- (void)gridCallback
{
    HKKScrollableGridCallback callback = ^void(NSInteger index, id object) {
        if(object && [object isKindOfClass:[TxOrder class]]) {
            TxOrder *order = object;
            
            NSArray *cells = [self orderDetail:order];
            
            MLTableAlert *alert = [TableAlert alertConfirmationOKOnly:cells titleAlert:@"ORDER MATCH" okOnClick:nil];
            
            [alert setHeight:260.f];
            [alert showWithColor:WHITE];
        }
    };
    
    self.gridView.callback = callback;
}

- (NSArray *)orderDetail:(TxOrder *)order
{
    int32_t share = [SysAdmin sharedInstance].loginFeed.lotSize;
    double value = order.price * order.orderQty * share;
    
    NSArray *cells = [NSArray arrayWithObjects: @"Client Name", order.clientName,
                      @"Stock", order.securityCode,
                      @"Price", [NSString localizedStringWithFormat:@"%d", order.price],
                      @"Lot", [NSString localizedStringWithFormat:@"%.0f", order.orderQty],
                      @"Value", [NSString localizedStringWithFormat:@"%.0f", value],
                      //@"Status", [OrderGrid statusDescription:order.orderStatus],
                      @"Side", 1 == order.side ? @"BUY" : @"SELL",
                      @"Match", [NSString localizedStringWithFormat:@"%.0f", order.cumQty],
                      @"Balance", [NSString localizedStringWithFormat:@"%.0f", (order.orderQty - order.cumQty)],
                      @"Clord ID", order.orderId,
                      nil];
    return cells;
}

@end
