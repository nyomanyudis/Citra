//
//  PortfolioOwn.m
//  Ciptadana
//
//  Created by Reyhan on 11/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "PortfolioOwn.h"

#import "PortfolioTopTable.h"
#import "PortfolioBotTable.h"
#import "HKKScrollableGridView.h"

@interface PortfolioOwn ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableTop;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *tableBottom;
@property (strong, nonatomic) PortfolioTopTable *topTable;
@property (strong, nonatomic) PortfolioBotTable *botTable;
@property (weak, nonatomic) IBOutlet UILabel *client;

@end

@implementation PortfolioOwn

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.topTable = [[PortfolioTopTable alloc] initWithTable:self.tableTop];
    self.botTable = [[PortfolioBotTable alloc] initWithGridView:self.tableBottom];
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:c.clientcode];
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetPortfolioList requestType:RequestGet clientcode:c.clientcode];
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
        if(tm.recType == RecordTypeGetPortfolioList) {
            [self.botTable updatePortfolio:tm.recPortfolio];
        }
        else if(tm.recType == RecordTypeGetCustomerPosition) {
            [self.topTable updateCustomerPosition:tm.recCustomerPosition];
        }
    }
}

@end
