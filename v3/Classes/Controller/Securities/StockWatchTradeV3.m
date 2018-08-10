//
//  StockWatchTradeV3.m
//  Ciptadana
//
//  Created by Reyhan on 10/31/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "StockWatchTradeV3.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#import "SysAdmin.h"


#define IDENTIFIER @"GridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChanged"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffset"


static NSMutableDictionary *lastTrade;

@interface StockWatchTradeV3()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) StockWatchTradeV3Cell *gridHeader;
@property (strong, nonatomic) NSArray *trade;
@property (strong, nonatomic) KiStockSummary *summary;
@property (assign) unsigned long max;

@end

@implementation StockWatchTradeV3

#pragma mark - public

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        //self.scrollGrid = [[HKKScrollableGridView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollGrid = [[HKKScrollableGridView alloc] initWithFrame:frame];
        
        self.scrollGrid.dataSource = self;
        self.scrollGrid.delegate = self;
        self.scrollGrid.verticalBounce = YES;
        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        self.scrollGrid.backgroundColor = [UIColor clearColor];
        [self.scrollGrid registerClassForGridCellView:[StockWatchTradeV3Cell class] reuseIdentifier:IDENTIFIER];
        
        lastTrade = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)updateTrade:(NSArray *)trade data:(KiStockData *)data
{
    if(trade) {
        self.summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
        if(trade && trade.count > 0) {
            self.trade = trade;
            [self.scrollGrid reloadData];
            
            [lastTrade setObject:self.trade forKey:data.code];
        }
        else {
            self.trade = [lastTrade objectForKey:data.code];
            
            [self.scrollGrid reloadData];
        }
    }
}

- (UIView *)scrollView
{
    return self.scrollGrid;
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.trade)
        return self.trade.count;
    return 0;
}

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    StockWatchTradeV3Cell *cellView = (StockWatchTradeV3Cell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    int lotSize = [SysAdmin sharedInstance].sysAdminData.lotSize;
    if(lotSize <= 0) lotSize = 100;
    
    KiTrade *trade = [self.trade objectAtIndex:rowIndex];
    
    KiBrokerData *buyer = [[MarketData sharedInstance] getBrokerDataById:trade.buyerBrokerId];
    KiBrokerData *seller = [[MarketData sharedInstance] getBrokerDataById:trade.sellerBrokerId];
    
    
    NSMutableString *time = [NSMutableString stringWithFormat:@"%i", trade.trade.tradeTime];
    if(5 == time.length)
        [time insertString:@"0" atIndex:0];
    
    if(6 == time.length) {
        [time insertString:@":" atIndex:2];
        [time insertString:@":" atIndex:5];
    }
    
    UILabel* leftLabel = cellView.fixedLabelInit;
    leftLabel.text = [NSString stringWithFormat:@" %@", time];
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 6; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
//        label.font = FONT_TITLE_LABEL_CELL;
        
        if(n == 1){
            label.text = [NSString localizedStringWithFormat:@"%d", trade.trade.price];
            [label setFrame:CGRectMake(0, -3, 60, 28)];
        }
        else if(n == 2){
            label.text = [NSString localizedStringWithFormat:@"%d", trade.trade.volume / lotSize];
            [label setFrame:CGRectMake(44, -3, 60, 28)];
        }
        else if(n == 3){
            label.text = buyer ? (buyer.type == InvestorTypeD ? @"D" : @"F") : @"";
            [label setFrame:CGRectMake(112, -3, 30, 28)];
        }
        else if(n == 4){
            label.text = buyer ? buyer.code : @"";
            [label setFrame:CGRectMake(150, -3, 50, 28)];
        }
        else if(n == 5){
            label.text = seller ? seller.code : @"";
            [label setFrame:CGRectMake(208, -3, 50, 28)];
        }
        else if(n == 6){
            label.text = seller ? (seller.type == InvestorTypeD ? @"D" : @"F") : @"";
            [label setFrame:CGRectMake(266, -3, 30, 28)];
        }
        
        if(n < 3) {
            if(trade.trade.price > self.summary.stockSummary.previousPrice) label.textColor = GREEN;
            else if(trade.trade.price > self.summary.stockSummary.previousPrice) label.textColor = RED;
            else label.textColor = YELLOW;
        }
        else {
            if(n == 3 || n == 4) {
                label.textColor = buyer.type == InvestorTypeF ? MAGENTA : BLACK;
            }
            else {
                label.textColor = seller.type == InvestorTypeF ? MAGENTA : BLACK;
            }
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 60.f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 340.f;
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
- (StockWatchTradeV3Cell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[StockWatchTradeV3Cell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface StockWatchTradeV3Cell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation StockWatchTradeV3Cell

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
        self.fixedLabel = [ObjectBuilder createGridLabel:CGRectMake(0, 0, 100, 28) withLabel:@"  TIME" andTag:0];
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
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 60, 28) withLabel:@"PRICE" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(44, 0, 60, 28) withLabel:@"LOT" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(112, 0, 30, 28) withLabel:@"B" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(150, 0, 50, 28) withLabel:@"BUYER" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(208, 0, 50, 28) withLabel:@"SELLER" andTag:5]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(266, 0, 30, 28) withLabel:@"S" andTag:6]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentCenter;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end

