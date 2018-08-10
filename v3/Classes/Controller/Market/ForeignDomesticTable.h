    //
//  ForeignDomesticTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/20/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "HKKScrollableGridView.h"

#import "Protocol.pb.h"

@class FDGridViewCell;

@interface ForeignDomesticTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)newSummary:(NSMutableArray *)summaries;
- (void)updateSummary:(NSArray *)summaries;
- (void)resetSummary:(NSArray *)summaries;
- (NSArray *)stockSummaryList;

@end

@interface FDGridViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) KiStockSummary *summary;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end