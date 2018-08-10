//
//  KiWatchlistTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "KiWatchlistTable.h"

#import "WatchlistCell.h"
#import "AddWatchlistCell.h"

#import "MarketData.h"
#import "NSArray+Addons.h"
#import "NSString+Addons.h"
#import "Util.h"
#import "JsonProperties.h"
#import "ObjectBuilder.h"

#define IDENTIFIER @"TableIdentifierWatchlist"

@interface KiWatchlistTable() <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *watchlist;

@end

@implementation KiWatchlistTable


#pragma mark - public

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if(self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.watchlist = [NSMutableArray array];
    }
    
    return self;
}

- (void)newSummary:(NSMutableArray *)summaries
{
    self.watchlist = summaries;
    [self.tableView reloadData];
}

- (void)updateSummary:(NSArray *)summaries
{
    for(KiStockSummary *summary in summaries) {
        if([self isUnique:summary]) {
            [self.watchlist addObject:summary];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - private

- (BOOL)isUnique:(KiStockSummary *)summary
{
    if(self.watchlist && [self.watchlist count] > 0) {
        for(KiStockSummary *tmp in self.watchlist) {
            if(tmp.codeId == summary.codeId)
                return NO;
        }
    }
    return YES;
}


#pragma UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.watchlist)
        return self.watchlist.count;
    return 0;
}

#define chg(close, prev) prev - close
#define chgprcnt(chg, prev) chg * 100 / prev

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchlistCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WatchlistCell" owner:self options:nil] objectAtIndex:0];
        
    if(indexPath.row % 2 == 0){
        cell.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    else if(indexPath.row %2 == 1){
        cell.backgroundColor = [UIColor whiteColor];
    }
        
//        AddWatchlistCell *cell2 = [[[NSBundle mainBundle] loadNibNamed:@"AddWatchlistCell" owner:self options:nil] objectAtIndex:0];
//        cell.editingAccessoryView = cell2;
    }
    
//    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:[self.watchlist objectAtIndex:indexPath.row]];
//    KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
    KiStockSummary *summary = [self.watchlist objectAtIndex:indexPath.row];
    summary = [[MarketData sharedInstance] getStockSummaryById:summary.codeId];
    KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
    
    float chg = summary.stockSummary.change;
    float chgp = chgprcnt(summary.stockSummary.change, summary.stockSummary.previousPrice);
    
    cell.stock.text = data.code;
    cell.name.text = data.name;
    
    cell.price.text = [NSString localizedStringWithFormat:@"%.2d", summary.stockSummary.ohlc.close];
    cell.change.text = [NSString localizedStringWithFormat:@"%.2f", chg];
    cell.changepct.text = [NSString localizedStringWithFormat:@"%.2f%%", chgp];
    
    
    [cell.change.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
    [cell.changepct.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
    
    
    cell.stock.textColor = UIColorFromRGB(stringToHexa(data.color));
    cell.name.textColor = UIColorFromRGB(stringToHexa(data.color));
    
    if(chg > 0) {
        cell.price.textColor = GREEN;
        cell.change.textColor = GREEN;
        cell.changepct.textColor = GREEN;
        cell.changepctImage.image = [UIImage imageNamed:@"arrowgreen"];
    }
    else if(chg < 0) {
        cell.price.textColor = RED;
        cell.change.textColor = RED;
        cell.changepct.textColor = RED;
        cell.changepctImage.image = [UIImage imageNamed:@"arrowred"];
    }
    else {
        cell.price.textColor = YELLOW;
        cell.change.textColor = YELLOW;
        cell.changepct.textColor = YELLOW;
        cell.changepctImage.image = nil;
    }
    
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        NSLog(@"adfafd");
////        static NSString *cellIdentifier = @"Cell";
////        
////        AddWatchlistCell *cell = (AddWatchlistCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
////        
//////        AddWatchlistCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
////        
////        if(!cell)
////            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddWatchlistCell" owner:self options:nil] objectAtIndex:0];
//    //}
//}
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your editAction here
//        NSLog(@"Clona");
//    }];
//    editAction.backgroundColor = [UIColor clearColor];
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        StockSummary *tmp = [self.watchlist objectAtIndex:indexPath.row];
//        [self.watchlist removeObject:tmp];
//        [self.tableView reloadData];
//    }];
//    deleteAction.backgroundColor = [UIColor clearColor];
//    return @[deleteAction,editAction];
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
    //        //insert your editAction here
    //        NSLog(@"Clona");
    //    }];
    //    editAction.backgroundColor = [UIColor clearColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        if(indexPath.row >= 0 && indexPath.row < self.watchlist.count) {
            [self.watchlist removeObjectAtIndex:indexPath.row];
            
            NSMutableArray *tmp = [NSMutableArray array];
            for(KiStockSummary *summary in self.watchlist) {
                KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
                if(data)
                    [tmp addObject:data.code];
            }
            
            [JsonProperties setWatchlist:tmp];
            tmp = nil;
            
            [self.tableView reloadData];
            
        }
    }];
    deleteAction.backgroundColor = [UIColor whiteColor];
    //return @[deleteAction,editAction];
    return @[deleteAction];
}

@end
