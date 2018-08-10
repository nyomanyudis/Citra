//
//  BuyStockNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 5/3/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "BuyStockNyoman.h"
#import "StockSuggestionField.h"
#import "Level2BuySell.h"

@interface BuyStockNyoman ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet StockSuggestionField *stockSuggestion;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *lot;
@property (weak, nonatomic) IBOutlet UITextField *orderpower;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UITextField *cash;
@property (weak, nonatomic) IBOutlet UIView *level2Grid;
@property (weak, nonatomic) IBOutlet UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@property (strong,nonatomic) Level2BuySell *level2;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;


@end

@implementation BuyStockNyoman

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c){
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribeOrderList];
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:c.clientcode];
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:c.clientcode];
    }
    
    [self performSelector:@selector(stockFieldCallback)];
    
}

- (void) stockFieldCallBack
{
    StockSuggestionCallback stockCallback = ^void(NSString* stock){
        stock = [stock uppercaseString];
        
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:stock];
        
//        if(data){
//            [[MarketFeed sharedInstance] subscribe:RecordTypeLevel2 status:RequestSubscribe code:data.code];
//            
//            if(self.level2) {
//                [self.level2 updateLevel2:[NSArray array] data:data];
//            }
//
//        }
//        [self nextStep:self.stockSuggestion];
    };
    
    self.stockSuggestion.callback = stockCallback;
}

-(void)nextStep:(id) sender
{
    //    if(self.stockSuggestion.text.length > 0)
    //        [self performSegueWithIdentifier:@"putPriceIdentifier" sender:nil];
    if(sender == self.stockSuggestion){
        if(self.stockSuggestion.text.length > 3){
            self.price.text = @"";
            self.lot.text = @"";
            self.value.text = @"";
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

@end
