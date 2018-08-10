//
//  NetByStockTable.h
//  Ciptadana
//
//  Created by Reyhan on 11/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "Protocol.pb.h"
#import "HKKScrollableGridView.h"

@class NetByStockCell;

@interface NetByStockTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)newNetbuysell:(NetBuySell *)nbs stockData:(KiStockData *)data;
- (void)updateNetbuysell:(NetBuySell *)nbs stockData:(KiStockData *)data;
- (BOOL)refreshStock:(KiStockData *)data checkedRegular:(BOOL)checkedRegular checkedNego:(BOOL)checkedNego checkedCash:(BOOL)checkedCash;
- (NSMutableArray *) getArrayTransaction:(NSInteger) index;

@end

@interface NetByStockCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) KiStockSummary *summary;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end