//
//  NetByBrokerTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/24/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"
#import "HKKScrollableGridView.h"


@class NetByBrokerCell;
@class Transaction3;

@interface NetByBrokerTable : HKKScrollableGridTableCellView

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)newNetbuysell:(NetBuySell *)nbs brokerData:(KiBrokerData *)data;
- (void)updateNetbuysell:(NetBuySell *)nbs brokerData:(KiBrokerData *)data;
- (BOOL)refreshBroker:(KiBrokerData *)data checkedRegular:(BOOL)checkedRegular checkedNego:(BOOL)checkedNego checkedCash:(BOOL)checkedCash;
- (NSMutableArray *) getArrayTransaction:(NSInteger) index;

@property (assign, nonatomic) BOOL rg;
@property (assign, nonatomic) BOOL ng;
@property (assign, nonatomic) BOOL tn;

@end


@interface NetByBrokerCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) KiStockSummary *summary;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end

@interface Transaction3 : NSObject

-(id)initWithTransaction:(Transaction*)transaction andBoard:(Board)board;

@property int32_t codeId;//stock code
@property Board board;
@property int64_t tvalue;
@property int64_t tlot;
@property int64_t nvalue;
@property int64_t nlot;
@property int64_t tfreq;

@end


