//
//  KiBrokerTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/19/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

@class BrokerGridViewCell;

@interface KiBrokerTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateBroker:(NSArray *)broker;
- (void)newBroker:(NSArray *)broker;

@end

@interface BrokerGridViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end