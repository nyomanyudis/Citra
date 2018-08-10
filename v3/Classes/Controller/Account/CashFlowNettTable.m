//
//  CashFlowNettTable.m
//  Ciptadana
//
//  Created by Reyhan on 11/15/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "CashFlowNettTable.h"

@interface CashFlowNettTable() <UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) CashFlow *cash;

@end

@implementation CashFlowNettTable

#pragma mark - public

- (id)initWithTable:(UITableView *)table
{
    self = [super init];
    if(self) {
        self.table = table;
        self.table.dataSource = self;
    }
    
    return self;
}

- (void)updateCashFlow:(CashFlow *)cash
{
    self.cash = cash;
    [self.table reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", (int)(indexPath.row + 1)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *left = [cell.contentView viewWithTag:1];
    
    if(self.cash) {
        if(indexPath.row == 0) left.text = [NSString localizedStringWithFormat:@"t0: %.2f", self.cash.t0];
        else if(indexPath.row == 1) left.text = [NSString localizedStringWithFormat:@"t1: %.2f", self.cash.t1];
        else if(indexPath.row == 2) left.text = [NSString localizedStringWithFormat:@"t2: %.2f", self.cash.t2];
        else if(indexPath.row == 3) left.text = [NSString localizedStringWithFormat:@"t3: %.2f", self.cash.t3];
    }
    else left.text = @"";
    
    return cell;
}

@end
