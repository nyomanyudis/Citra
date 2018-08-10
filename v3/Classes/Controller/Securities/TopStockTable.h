//
//  TopStockTable.h
//  Ciptadana
//
//  Created by Reyhan on 11/1/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

@class TopStockTableCell;

@interface TopStockTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)doSortByGainer;//top gainer
- (void)doSortByLoser;//top loser
- (void)doSortByValue;//top value
- (void)doSortByActive;//most active

@end

@interface TopStockTableCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end
