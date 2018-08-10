//
//  KiBrokerTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/19/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "KiBrokerTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#define MAXROW 50

#define IDENTIFIER @"BrokerGridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedBroker"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetBroker"

@interface KiBrokerTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) BrokerGridViewCell *gridHeader;
@property (strong, nonatomic) NSArray *broker;

@end


@implementation KiBrokerTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.scrollGrid = gridView;
        
        self.scrollGrid.dataSource = self;
        self.scrollGrid.delegate = self;
        self.scrollGrid.verticalBounce = YES;
        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        self.scrollGrid.backgroundColor = [UIColor clearColor];
        [self.scrollGrid registerClassForGridCellView:[BrokerGridViewCell class] reuseIdentifier:IDENTIFIER];
    }
    return self;
}

- (void)updateBroker:(NSArray *)broker
{
    self.broker = broker;
    [self.scrollGrid reloadData];
}

- (void)newBroker:(NSArray *)broker
{
    
}


#pragma mark - private

- (NSString *)currencySimplyfy:(double)currency
{
    if(fabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%.2fB", (currency / 1000000000)];
    else if(fabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%.2fM", (currency / 1000000)];
    else if(fabs(currency) > 1000)
        return [NSString localizedStringWithFormat:@"%.2fK", (currency / 1000)];
    
    return [NSString localizedStringWithFormat:@"%.0f", currency];
}
- (NSString *)freqSimplyfy:(double)currency
{
    if(fabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%.0fB", (currency / 1000000000)];
    else if(fabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%.0fM", (currency / 1000000)];
    
    return [NSString localizedStringWithFormat:@"%.0f", currency];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.broker)
        return self.broker.count > MAXROW ? MAXROW : self.broker.count;
    return 0;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    BrokerGridViewCell *cellView = (BrokerGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    Transaction *t = [self.broker objectAtIndex:rowIndex];
    Transaction *RG = [[MarketData sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardRg];
    Transaction *TN = [[MarketData sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardTn];
    Transaction *NG = [[MarketData sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardNg];
    
    
    
    KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataById:t.codeId];
    
    double totalValue = 0;
    double totalVolume = 0;
    double totalFreq = 0;
    
    if(RG) {
        totalValue += RG.buy.value + RG.sell.value;
        totalVolume += RG.buy.volume + RG.sell.volume;
        totalFreq += RG.buy.frequency + RG.sell.frequency;
    }
    if(TN) {
        totalValue += TN.buy.value + TN.sell.value;
        totalVolume += TN.buy.volume + TN.sell.volume;
        totalFreq += TN.buy.frequency + TN.sell.frequency;
    }
    if(NG) {
        totalValue += NG.buy.value + NG.sell.value;
        totalVolume += NG.buy.volume + NG.sell.volume;
        totalFreq += NG.buy.frequency + NG.sell.frequency;
    }
    
    UILabel* label = cellView.fixedLabelInit;
    label.text = [NSString stringWithFormat:@"  %u. %@", (rowIndex + 1), data.code];
    label.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
//    label.font = FONT_TITLE_LABEL_CELL;
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 4; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
//        label.font = FONT_TITLE_LABEL_CELL;
        
        if(n == 1){
            label.text = data.name;
            [label setFrame:CGRectMake(8, -3, 120, 28)];
        }
        else if(n == 2){
            label.text = [self currencySimplyfy:totalValue];
            [label setFrame:CGRectMake(128, -3, 60, 28)];
        }
        else if(n == 3){
            label.text = [self currencySimplyfy:totalVolume];
            [label setFrame:CGRectMake(196, -3, 60, 28)];
        }
        else if(n == 4){
            label.text = [self freqSimplyfy:totalFreq];
            [label setFrame:CGRectMake(264, -3, 65, 28)];
        }
        
        if(n == 1) {
            label.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
        }
        else {
            label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 50.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 335.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 28.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 20.0f;
}
- (BrokerGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[BrokerGridViewCell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface BrokerGridViewCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation BrokerGridViewCell

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
        self.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fixedLabelInit.frame = self.fixedView.bounds;
    self.scrollableAreaViewInit.frame = self.scrolledContentView.bounds;
    
}

- (UILabel *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 100, 28) withLabel:@"   BK" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
        self.fixedLabel.backgroundColor = [UIColor clearColor];
        [self.fixedView addSubview:self.fixedLabel];
    }
    return self.fixedLabel;
}

- (UIView*)scrollableAreaViewInit
{
    if (self.scrollableAreaView == nil) {
        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, 0, 120, 28) withLabel:@"Name" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(128, 0, 60, 28) withLabel:@"Value" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(196, 0, 60, 28) withLabel:@"Volume" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(264, 0, 65, 28) withLabel:@"Frequency" andTag:4]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end