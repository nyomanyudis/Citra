//
//  SummaryTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/27/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

//#import "HKKScrollableGridView.h"
#import "Protocol.pb.h"

@interface SummaryTable : NSObject

- (id)initWithTableView:(UITableView *)tableView;
- (void)updateSummary:(KiStockSummary *)summary;

@end

//@interface SummaryTable : HKKScrollableGridTableCellView
//
//- (id)initWithGridView:(HKKScrollableGridView *)gridView;
//- (void)updateSummary:(KiStockSummary *)summary;
//
//@end
//
//@interface SummaryTableCell : HKKScrollableGridTableCellView
//
//@property (nonatomic, strong) UIView* scrollableAreaViewInit;
//
//- (id)init;
//
//@end
