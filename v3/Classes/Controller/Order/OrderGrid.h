//
//  OrderGrid.h
//  Ciptadana
//
//  Created by Reyhan on 12/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@interface OrderGrid : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateTrades:(NSArray *)orders OrderType:(NSString *)OrderType OrderStatus:(NSString *)OrderStatus;

+ (NSMutableArray *)sortOrderByCreatedTime:(NSArray *)source;
+ (NSString*) statusDescription:(NSString*)status;

@end

@interface OrderGridViewCell : HKKScrollableGridTableCellView

//@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (strong, nonatomic) TxOrder *order;
@property (nonatomic, copy) HKKScrollableGridCallback callback;
@property (assign, nonatomic, getter=isHeader) BOOL header;

- (id)init;

@end