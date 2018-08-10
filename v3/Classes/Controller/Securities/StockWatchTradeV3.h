//
//  StockWatchTradeV3.h
//  Ciptadana
//
//  Created by Reyhan on 10/31/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@class StockWatchTradeV3Cell;

@interface StockWatchTradeV3 : HKKScrollableGridTableCellView

- (id)initWithFrame:(CGRect)frame;
- (void)updateTrade:(NSArray *)trade data:(KiStockData *)data;
- (UIView *)scrollView;

@end

@interface StockWatchTradeV3Cell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end