//
//  StockWatchLevel3V3.h
//  Ciptadana
//
//  Created by Reyhan on 10/31/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@class StockWatchLevel3V3Cell;

@interface StockWatchLevel3V3 : HKKScrollableGridTableCellView

- (id)initWithFrame:(CGRect)frame;
- (void)updateLevel3:(NSArray *)level3 data:(KiStockData *)data;
- (UIView *)scrollView;

@end


@interface StockWatchLevel3V3Cell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end