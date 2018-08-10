//
//  KiRunTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"


@class RunGridViewCell;

@interface KiRunTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)newTrade:(NSArray *)trades;

@end


@interface RunGridViewCell : HKKScrollableGridTableCellView

//@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end