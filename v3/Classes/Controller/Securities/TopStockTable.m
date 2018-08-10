//
//  TopStockTable.m
//  Ciptadana
//
//  Created by Reyhan on 11/1/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TopStockTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#define IDENTIFIER @"GridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChanged"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffset"

@interface TopStockTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) TopStockTableCell *gridHeader;
@property (strong, nonatomic) NSArray *stocks;

@end

@implementation TopStockTable

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
        [self.scrollGrid registerClassForGridCellView:[TopStockTableCell class] reuseIdentifier:IDENTIFIER];
    }
    return self;
}

- (void)doSortByGainer//top gainer
{
    self.stocks = [[MarketData sharedInstance] getStockSummaryByChgPercent:[MarketData sharedInstance].getStockSummaries];
    [self.scrollGrid reloadData];
}

- (void)doSortByLoser//top loser
{
    self.stocks = [[MarketData sharedInstance] getStockSummaryByChgPercentNegasi:[MarketData sharedInstance].getStockSummaries];
    [self.scrollGrid reloadData];
}

- (void)doSortByValue//top value
{
    self.stocks = [[MarketData sharedInstance] getStockSummaryByValue:[MarketData sharedInstance].getStockSummaries];
    [self.scrollGrid reloadData];
}

- (void)doSortByActive//most active
{
    self.stocks = [[MarketData sharedInstance] getStockSummaryByFrequency:[MarketData sharedInstance].getStockSummaries];
    [self.scrollGrid reloadData];
}

#pragma mark - private

- (NSString *)currencySimplyfyInt64:(int64_t)currency
{
    if(llabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%lldB", (currency / 1000000000)];
    else if(llabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%lldM", (currency / 1000000)];
    //    else if(llabs(currency) > 1000)
    //        return [NSString localizedStringWithFormat:@"%lldK", (currency / 1000)];
    
    return [NSString localizedStringWithFormat:@"%lld", currency];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.stocks)
        return self.stocks.count;
    return 0;
}

#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    TopStockTableCell *cellView = (TopStockTableCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    KiStockSummary *summary = [self.stocks objectAtIndex:rowIndex];
    KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
    
    if(data) {
        float chgp = 0;
        if(summary.stockSummary.ohlc.close > 0)
            chgp = chgprcnt(summary.stockSummary.change, summary.stockSummary.previousPrice);
        
        UILabel* label = cellView.fixedLabelInit;
        label.text = [NSString stringWithFormat:@"  %@", data.code];
        label.textColor = UIColorFromHex(data.color);
        
        
        UIView* scrollAreaView = cellView.scrollableAreaViewInit;
        for(int n = 1; n <= 6; n ++) {
            if(n==6){
                UIImageView *imageView = [scrollAreaView viewWithTag:n];
                if(chgp > 0)
                    imageView.image = [UIImage imageNamed:@"arrowgreen"];
                else if (chgp < 0)
                    imageView.image = [UIImage imageNamed:@"arrowred"];
                else
                    imageView.image = nil;
            }
            else{
                UILabel *label = [scrollAreaView viewWithTag:n];
                label.font = FONT_TITLE_LABEL_CELL;
                
                if(n == 1){
                    label.text = [NSString localizedStringWithFormat:@"%d", summary.stockSummary.ohlc.close];
                    [label setFrame:CGRectMake(0, -3, 40, 28)];
                }
                else if(n == 2){
                    label.text = [NSString localizedStringWithFormat:@"%.0f", summary.stockSummary.change];
                    [label setFrame:CGRectMake(48, -3, 50, 28)];
                }
                else if(n == 3){
                    label.text = [NSString localizedStringWithFormat:@"%.2f", chgp];
                    [label setFrame:CGRectMake(126, -3, 35, 28)];
                }
                else if(n == 4){
                    label.text = [self currencySimplyfyInt64:summary.stockSummary.tradedValue];
                    [label setFrame:CGRectMake(164, -3, 50, 28)];
                }
                else if(n == 5){
                    label.text = [NSString localizedStringWithFormat:@"%d", summary.stockSummary.tradedFrequency];
                    [label setFrame:CGRectMake(232, -3, 40, 28)];
                }
                
                if(n < 4) {
                    if(summary.stockSummary.change > 0)
                        label.textColor = GREEN;
                    else if(summary.stockSummary.change < 0)
                        label.textColor = RED;
                    else
                        label.textColor = YELLOW;
                    
                    label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
                }
            }
            
        }

    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 60.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 325.f;
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
- (TopStockTableCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[TopStockTableCell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface TopStockTableCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation TopStockTableCell

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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 110, 28) withLabel:@"   STOCK" andTag:0];
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
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 40, 28) withLabel:@"LAST" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(48, 0, 50, 28) withLabel:@"CHANGE" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridImage:CGRectMake(116, 7, 7, 8)  andTag:6]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(126, 0, 35, 28) withLabel:@"%" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(164, 0, 50, 28) withLabel:@"T VAL" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(232, 0, 45, 28) withLabel:@"T FREQ" andTag:5]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
