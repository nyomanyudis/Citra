//
//  CashFlowV3
//  Ciptadana
//
//  Created by Reyhan on 11/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "CashFlowV3.h"

#import "CashFlowNettTable.h"
#import "CashFlowCashTable.h"

@interface CashFlowV3 ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UITableView *topTable;
@property (weak, nonatomic) IBOutlet UITableView *botTable;

@property (strong, nonatomic) CashFlowNettTable *nettTable;
@property (strong, nonatomic) CashFlowCashTable *cashTable;

@end

@implementation CashFlowV3

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
    
    self.nettTable = [[CashFlowNettTable alloc] initWithTable:self.topTable];
    self.cashTable = [[CashFlowCashTable alloc] initWithTable:self.botTable];
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCashFlow requestType:RequestGet clientcode:c.clientcode];
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
        if(tm.recType == RecordTypeGetCashFlow) {
            for(CashFlow *cash in tm.recCashflow) {
                if([cash.description isEqualToString:@"Nett"])
                    [self.nettTable updateCashFlow:cash];
                else
                    [self.cashTable updateCashFlow:cash];
            }
        }
    }
}

@end
