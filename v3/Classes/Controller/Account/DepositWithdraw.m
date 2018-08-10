//
//  DepositWithdraw.m
//  Ciptadana
//
//  Created by Reyhan on 11/28/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "DepositWithdraw.h"

#import "DepositWithdrawCell.h"

@interface DepositWithdraw () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (strong, nonatomic) NSArray *deposits;
@property (strong, nonatomic) DepositWithdrawCell *headerCell;

@end

@implementation DepositWithdraw

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
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetCashWithdrawList requestType:RequestGet clientcode:c.clientcode];
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
        if(tm.recType == RecordTypeGetCashWithdrawList) {
            NSLog(@"%@", tm);
            self.deposits = tm.recCashWithdrawList;
            [self.table reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.deposits)
        return self.deposits.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DepositWithdrawCell *cell;
    
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DepositWithdrawCell" owner:self options:nil] objectAtIndex:0];
    
    CashWithdraw *cash = [self.deposits objectAtIndex:indexPath.row];
    
    cell.amont.text = [NSString localizedStringWithFormat:@"%.0f", cash.amount];
    cell.status.text = cash.reqStatus;
    cell.date.text = cash.reqDate;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(!self.headerCell) {
        self.headerCell = [[[NSBundle mainBundle] loadNibNamed:@"DepositWithdrawCell" owner:self options:nil] objectAtIndex:0];
        self.headerCell.date.text = @"DATE";
        self.headerCell.amont.text = @"AMOUNT";
        self.headerCell.status.text = @"STATUS";
        
        [self.headerCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"longbar"]]];
    }
    
    return self.headerCell;
}

@end
