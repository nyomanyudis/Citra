//
//  TradeGrid.h
//  Ciptadana
//
//  Created by Reyhan on 12/14/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@interface TradeGrid : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateTrades:(NSArray *)orders;

@end

@interface TradeGridViewCell : HKKScrollableGridTableCellView

//@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (assign, nonatomic) NSInteger row;
@property (strong, nonatomic) TxOrder *order;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end