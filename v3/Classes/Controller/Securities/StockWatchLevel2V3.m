//
//  StockWatchLevel2V3.m
//  Ciptadana
//
//  Created by Reyhan on 10/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "StockWatchLevel2V3.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"


#define IDENTIFIER @"RegionalGridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedRegional"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetRegional"


static NSMutableDictionary *lastLevel2;

@interface StockWatchLevel2V3()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) StockWatchLevel2V3Cell *gridHeader;
@property (strong, nonatomic) Level2 *level2;
@property (strong, nonatomic) KiStockSummary *summary;
@property (assign) unsigned long max;

@end


@implementation StockWatchLevel2V3

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
        [self.scrollGrid registerClassForGridCellView:[StockWatchLevel2V3Cell class] reuseIdentifier:IDENTIFIER];
        
        if(lastLevel2 == nil)
            lastLevel2 = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)updateLevel2:(NSArray *)level2 data:(KiStockData *)data
{
    if(level2 && data) {
        self.summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
        if(level2 && level2.count > 0) {
            Level2 *tmpLevel2 = [level2 objectAtIndex:0];
            self.level2 = tmpLevel2;//[level2 objectAtIndex:0];
            self.max = MAX(self.level2.bid.count, self.level2.offer.count);
            [self.scrollGrid reloadData];
            
            NSLog(@"SAVE %@ ROW %@", data.code, tmpLevel2);
            [lastLevel2 setObject:self.level2 forKey:data.code];
        }
        else {
            self.level2 = [lastLevel2 objectForKey:data.code];
            
            NSLog(@"LOAD %@ ROW %@", data.code, self.level2);
            
            if(self.level2) {
                self.max = MAX(self.level2.bid.count, self.level2.offer.count);
            }
            
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
    if(self.level2)
        return MAX(self.level2.bid.count, self.level2.offer.count)-1;
    return 0;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    StockWatchLevel2V3Cell *cellView = (StockWatchLevel2V3Cell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    BuySell *bid = [self.level2.bid objectAtIndex:rowIndex];
    
    UILabel* leftLabel = cellView.fixedLabelInit;
    leftLabel.text = [NSString stringWithFormat:@"%d", bid.queue];
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 6; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
        label.text = @"";
//        label.font = FONT_TITLE_LABEL_CELL;
        
        
        
        if(self.level2.bid.count > rowIndex) {
//            if(n == 1) label.text = [NSString localizedStringWithFormat:@"%d", bid.queue];
            if(n == 1) {
                label.text = [NSString localizedStringWithFormat:@"%lld", bid.volume];
                [label setFrame:CGRectMake(0, -3, 45, 28)];
            }
            else if(n == 2){
                label.text = [NSString localizedStringWithFormat:@"%d", bid.price];
                [label setFrame:CGRectMake(30, -3, 75, 28)];
            }
            
            if(n == 2) {
                if(bid.price > self.summary.stockSummary.previousPrice)
                    label.textColor = GREEN;
                else if(bid.price < self.summary.stockSummary.previousPrice)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            else label.textColor = BLACK;
        }
        
        if(self.level2.offer.count > rowIndex) {
            BuySell *offer = [self.level2.offer objectAtIndex:rowIndex];
            if(n == 5) {
                label.text = [NSString localizedStringWithFormat:@"%d", offer.queue];
                [label setFrame:CGRectMake(180, -3, 50, 28)];
            }
            else if(n == 4){
                label.text = [NSString localizedStringWithFormat:@"%lld", offer.volume];
                [label setFrame:CGRectMake(120, -3, 75, 28)];
            }
            else if(n == 3){
                label.text = [NSString localizedStringWithFormat:@"%d", offer.price];
                [label setFrame:CGRectMake(80, -3, 75, 28)];
            }
            
            if(n == 3) {
                if(offer.price > self.summary.stockSummary.previousPrice)
                    label.textColor = GREEN;
                else if(offer.price < self.summary.stockSummary.previousPrice)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            else if(n != 2) label.textColor = BLACK;
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 30.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 425.f;
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
- (StockWatchLevel2V3Cell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[StockWatchLevel2V3Cell alloc] init];
        
//        UIView* scrollAreaView = self.gridHeader.scrollableAreaViewInit;
//        for(int n = 1; n <= 6; n ++) {
//            UILabel *label = [scrollAreaView viewWithTag:n];
//            label.textAlignment = NSTextAlignmentCenter;
//        }
    }
    return self.gridHeader;
}

@end


@interface StockWatchLevel2V3Cell()

@property (nonatomic, readwrite) UIView* scrollableAreaView;
@property (nonatomic, strong) UILabel* fixedLabel;

@end

@implementation StockWatchLevel2V3Cell

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

//- (UILabel *)fixedLabelInit
//{
//    return nil;
//}




- (UILabel *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 100, 28) withLabel:@"#B" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentRight;
        self.fixedLabel.adjustsFontSizeToFitWidth = YES;
        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
        self.fixedLabel.backgroundColor = [UIColor clearColor];
//        [self.fixedLabel setFont:[UIFont fontWithName:@"Arial" size:15]];
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
        
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 50, 32) withLabel:@"#B" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 45, 28) withLabel:@"Lot" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(30, 0, 75, 28) withLabel:@"Bid" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(80, 0, 75, 28) withLabel:@"Offer" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(120, 0, 75, 28) withLabel:@"Lot" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(180, 0, 50, 28) withLabel:@"#O" andTag:5]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
