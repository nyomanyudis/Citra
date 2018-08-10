//
//  FutureTable.h
//  Ciptadana
//
//  Created by Reyhan on 2/14/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"


@class FutureViewCell;

@interface FutureTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateFuture:(NSArray *)future;

@end

@interface FutureViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end
