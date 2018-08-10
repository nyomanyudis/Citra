//
//  MarketSummaryTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"


@class MarketSummaryCellV3;

@interface MarketSummaryTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)newSummary:(NSArray *)summary;

@end

@interface MarketSummaryCellV3 : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;

- (id)init;

@end