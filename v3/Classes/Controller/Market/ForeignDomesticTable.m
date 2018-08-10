//
//  ForeignDomesticTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/20/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "ForeignDomesticTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#define IDENTIFIER @"BrokerGridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedBroker"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetBroker"

@interface ForeignDomesticTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) FDGridViewCell *gridHeader;
@property (strong, nonatomic) NSMutableArray *summaries;

@end

@implementation ForeignDomesticTable

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
        [self.scrollGrid registerClassForGridCellView:[FDGridViewCell class] reuseIdentifier:IDENTIFIER];
        
        self.summaries = [NSMutableArray array];
    }
    return self;
}

- (void)newSummary:(NSMutableArray *)summaries
{
    self.summaries = summaries;
    [self.scrollGrid reloadData];
}

- (void)updateSummary:(NSArray *)summaries
{
    for(KiStockSummary *summary in summaries) {
        if([self isUnique:summary]) {
            [self.summaries addObject:summary];
        }
    }
    
    [self.scrollGrid reloadData];
}

- (void)resetSummary:(NSArray *)summaries
{
    [self.summaries removeAllObjects];
    for(KiStockSummary *summary in summaries) {
        [self.summaries addObject:summary];
    }
    [self.scrollGrid reloadData];
}

- (NSArray *)stockSummaryList
{
    return self.summaries;
}

#pragma mark - private

- (BOOL)isUnique:(KiStockSummary *)summary
{
    if(self.summaries && [self.summaries count] > 0) {
        for(KiStockSummary *tmp in self.summaries) {
            if(tmp.codeId == summary.codeId)
                return NO;
        }
    }
    return YES;
}

- (NSString *)currencySimplyfy:(double)currency
{
    if(fabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%.2fB", (currency / 1000000000)];
    else if(fabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%.2fM", (currency / 1000000)];
    else if(fabs(currency) > 1000)
        return [NSString localizedStringWithFormat:@"%.2fK", (currency / 1000)];
    
    return [NSString localizedStringWithFormat:@"%.2f", currency];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.summaries)
        return self.summaries.count;
    return 0;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    FDGridViewCell *cellView = (FDGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    cellView.callback = gridView.callback;
    
    //KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:[self.summaries objectAtIndex:rowIndex]];
//    KiStockData *data = [self.summaries objectAtIndex:rowIndex];
//    data = [[MarketData sharedInstance] getStockDataById:data.id];
    KiStockSummary *summary = [self.summaries objectAtIndex:rowIndex];
    summary = [[MarketData sharedInstance] getStockSummaryById:summary.codeId];
    if(summary) {
        cellView.summary = summary;
        cellView.index = rowIndex;
        
        KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
        float chg = summary.stockSummary.change;
        float chgp = chgprcnt(summary.stockSummary.change, summary.stockSummary.previousPrice);
        
        float fBuy, fSell, netF;
        float dBuy, dSell, netD;
        
        fBuy = summary.foreignValBought;
        fSell = summary.foreignValSold;
        netF = fBuy - fSell;
        
        dBuy = summary.stockSummary.tradedValue - summary.foreignValBought;
        dSell = summary.stockSummary.tradedValue - summary.foreignValSold;
        netD = dBuy - dSell;
        
        UILabel* label = cellView.fixedLabelInit;
        label.text = [NSString stringWithFormat:@"  %@", data.code];
        label.textColor = UIColorFromHex(data.color);
        
        if(rowIndex % 2 == 0)
            cellView.backgroundColor = UIColorFromHex(@"0xf7f7f7");
        
        UIView* scrollAreaView = cellView.scrollableAreaViewInit;
        for(int n = 1; n <= 11; n ++) {
            UILabel *label = [scrollAreaView viewWithTag:n];
            
            if(n == 1)
                label.text = @"F";
            else if(n == 2)
                label.text = @"D";
            else if(n == 3)
                label.text = [self currencySimplyfy:fBuy];
            else if(n == 4)
                label.text = [self currencySimplyfy:dBuy];
            else if(n == 5)
                label.text = [self currencySimplyfy:fSell];
            else if(n == 6)
                label.text = [self currencySimplyfy:dSell];
            else if(n == 7)
                label.text = [self currencySimplyfy:netF];
            else if(n == 8)
                label.text = [self currencySimplyfy:netD];
//            else if(n == 9)
//                label.text = [NSString localizedStringWithFormat:@"%d", summary.stockSummary.ohlc.close];
//            else if(n == 10)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", chg];
//            else if(n == 11)
//                label.text = [NSString localizedStringWithFormat:@"%.2f%%", chgp];
            
            if(n == 4 || n == 6 || n == 8) {
                if(netD > 0)
                    label.textColor = GREEN;
                else if(netD < 0)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            
            if(n == 3 || n == 5 || n == 7) {
                if(netF > 0)
                    label.textColor = GREEN;
                else if(netF < 0)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            
//            if(n > 2)
//                label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
            
            if(n > 8) {
                label.font =  [FONT_TITLE_LABEL_CELL fontWithSize:18];
                
                if(chg > 0) label.textColor = GREEN;
                else if(chg < 0) label.textColor = RED;
                else label.textColor = YELLOW;
            }
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 70.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 475.0f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 32.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 48.f;
}
- (FDGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[FDGridViewCell alloc] init];
        UIView *scrollAreaView = self.gridHeader.scrollableAreaViewInit;
        
        for(int n = 2; n <= 8;) {
            UIView *view = [scrollAreaView viewWithTag:n];
            [view removeFromSuperview];
            
            n += 2;
        }
    }
    return self.gridHeader;
}

@end


@interface FDGridViewCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation FDGridViewCell

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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 100, 28) withLabel:@"   STOCK" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
        self.fixedLabel.backgroundColor = [UIColor clearColor];
        [self.fixedView addSubview:self.fixedLabel];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.fixedView addGestureRecognizer:singleFingerTap];
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
        
//        CGFloat x = 0;
//        CGFloat pad = 8;
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 60) + (pad * x), 0, 120, 32) withLabel:@"Name" andTag:1]];x++;
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 120) + (pad * x), 0, 120, 32) withLabel:@"Value" andTag:2]];x++;
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 120) + (pad * x), 0, 100, 32) withLabel:@"Volume" andTag:3]];x++;
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(140 + (x * 70) + (pad * x), 0, 70, 32) withLabel:@"Frequency" andTag:4]];x++;
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, 0, 20, 32) withLabel:@" " andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, 20, 20, 32) withLabel:@" " andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(32, 0, 60, 32) withLabel:@"BUY" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(32, 20, 60, 32) withLabel:@" " andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(100, 0, 60, 32) withLabel:@"SELL" andTag:5]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(100, 20, 60, 32) withLabel:@" " andTag:6]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(168, 0, 60, 32) withLabel:@"NET" andTag:7]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(168, 20, 60, 32) withLabel:@" " andTag:8]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(236, 0, 80, 32) withLabel:@"PRICE" andTag:9]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(324, 0, 70, 32) withLabel:@"CHANGE" andTag:10]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(402, 0, 60, 32) withLabel:@"%" andTag:11]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:7]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:8]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:9]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:10]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:11]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.scrolledContentView addGestureRecognizer:singleFingerTap];
    }
    return self.scrollableAreaView;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    //NSLog(@"handle single tap: %@", self.summary);
    
    if(self.callback) {
        self.callback(self.index, self.summary);
    }
    
}

@end
