//
//  PortfolioTopTable.m
//  Ciptadana
//
//  Created by Reyhan on 11/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "PortfolioTopTable.h"

@interface PortfolioTopTable() <UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) CustomerPosition *customer;

@end

@implementation PortfolioTopTable

#pragma mark - public

- (id)initWithTable:(UITableView *)table
{
    self = [super init];
    if(self) {
        self.table = table;
        self.table.dataSource = self;
        //self.table.delegate = self;
    }
    
    return self;
}

- (void)updateCustomerPosition:(CustomerPosition *)customer
{
    self.customer = customer;
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource

//#define CUSTOMER @[@"Cash Balance", @"Order Power", @"Loan Ratio", @"Buy Trade Value", @"Sell Trade Value", @"Market Value", @"Buying Power", @"Outstanding", @"NETT P/L", @"NETT %P/L"]
#define CUSTOMER @[@"Cash Balance", @"Order Power", @"Loan Ratio", @"Buy Trade Value", @"Sell Trade Value", @"Market Value", @"Buying Power", @"Outstanding"]

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CUSTOMER count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", (int)(indexPath.row + 1)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *left = [cell.contentView viewWithTag:1];
    UILabel *right = [cell.contentView viewWithTag:2];
    
    left.text = [CUSTOMER objectAtIndex:indexPath.row];
    right.text = @"0.00";
    
    if(self.customer) {
        if(indexPath.row == 0)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.loanBalance];
        else if(indexPath.row == 1)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.orderPower];
        else if(indexPath.row == 2)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.loanRatio];
        else if(indexPath.row == 3)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.buyTradeValue];
        else if(indexPath.row == 4)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.sellTradeValue];
        else if(indexPath.row == 5)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.marketValue];
        else if(indexPath.row == 6)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.buyingPower];
        else if(indexPath.row == 7)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.outstanding];
        else if(indexPath.row == 8)
            right.text = [NSString localizedStringWithFormat:@"%.2f", self.customer.nettProfitLoss];
        else if(indexPath.row == 9)
            right.text = [NSString localizedStringWithFormat:@"%.2f%%", self.customer.nettProfitLossPct];
    }
    
    return cell;
}

@end
