//
//  Level2BuySell.h
//  Ciptadana
//
//  Created by Reyhan on 1/24/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"
#import "Protocol.pb.h"

@interface Level2BuySell : HKKScrollableGridTableCellView

- (id)initWithFrame:(CGRect)frame;
- (void)updateLevel2:(NSArray *)level2 data:(KiStockData *)data;

- (UIView *)scrollView;

@end

@interface Level2BuySellCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end
