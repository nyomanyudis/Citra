//
//  StockWatchLevel2V3.h
//  Ciptadana
//
//  Created by Reyhan on 10/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@class StockWatchLevel2V3Cell;

@interface StockWatchLevel2V3 : HKKScrollableGridTableCellView

- (id)initWithFrame:(CGRect)frame;
- (void)updateLevel2:(NSArray *)level2 data:(KiStockData *)data;

- (UIView *)scrollView;

@end

@interface StockWatchLevel2V3Cell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end