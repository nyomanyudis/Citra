//
//  ScrollableGridCellView.h
//  Ciptadanav3
//
//  Created by Reyhan on 9/19/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "HKKScrollableGridView.h"

@interface ScrollableGridViewCell : HKKScrollableGridTableCellView


@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

@end
