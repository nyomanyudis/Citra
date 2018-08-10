//
//  KiRegionalTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/18/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKKScrollableGridView.h"


@class RegionalGridViewCell;

@interface KiRegionalTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateRegionalIndices:(NSArray *)regional;

@end

@interface RegionalGridViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end