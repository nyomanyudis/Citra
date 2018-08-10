//
//  PortfolioBotTable.h
//  Ciptadana
//
//  Created by Reyhan on 11/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

@class PortfolioBotTableCell;

@interface PortfolioBotTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updatePortfolio:(NSArray *)porttolios;

@end


@interface PortfolioBotTableCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end