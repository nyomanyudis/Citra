//
//  Level2BuySell.m
//  Ciptadana
//
//  Created by Reyhan on 1/24/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "Level2BuySell.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"


#define IDENTIFIER @"Level2BuySellGridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedLevel2BuySell"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetLevel2BuySell"

static NSMutableDictionary *lastLevelBuySell2;

@interface Level2BuySell()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) Level2BuySellCell *gridHeader;
@property (strong, nonatomic) Level2 *level2;
@property (strong, nonatomic) KiStockSummary *summary;
@property (assign) unsigned long max;

@end

@implementation Level2BuySell

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
        [self.scrollGrid registerClassForGridCellView:[Level2BuySellCell class] reuseIdentifier:IDENTIFIER];
        
        if(lastLevelBuySell2 == nil)
            lastLevelBuySell2 = [NSMutableDictionary dictionary];
        
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
            [lastLevelBuySell2 setObject:self.level2 forKey:data.code];
        }
        else {
            self.level2 = [lastLevelBuySell2 objectForKey:data.code];
            
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
    Level2BuySellCell *cellView = (Level2BuySellCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0)
        [cellView setBackgroundColor:[UIColor whiteColor]];
    else
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 6; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
        label.text = @"";
        label.font = FONT_TITLE_LABEL_CELL;
    
        
        if(self.level2.bid.count > rowIndex) {
            BuySell *bid = [self.level2.bid objectAtIndex:rowIndex];
            //if(n == 1) label.text = [NSString localizedStringWithFormat:@"%d", bid.queue];
            if(n == 2){
                label.text = [NSString localizedStringWithFormat:@"%lld", bid.volume];
                [label setFrame:CGRectMake(0, -3, 75, 28)];
            }
            else if(n == 3){
                label.text = [NSString localizedStringWithFormat:@"%d", bid.price];
                [label setFrame:CGRectMake(110, -3, 50, 28)];
            }
            
            if(n > 1) {
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
            //if(n == 6) label.text = [NSString localizedStringWithFormat:@"%d", offer.queue];
            if(n == 5) {
                label.text = [NSString localizedStringWithFormat:@"%lld", offer.volume];
                [label setFrame:CGRectMake(250, -3, 75, 28)];
            }
            else if(n == 4){
                label.text = [NSString localizedStringWithFormat:@"%d", offer.price];
                [label setFrame:CGRectMake(200, -3, 50, 28)];
            }
            
            if(n < 6) {
                if(offer.price > self.summary.stockSummary.previousPrice)
                    label.textColor = GREEN;
                else if(offer.price < self.summary.stockSummary.previousPrice)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            else label.textColor = BLACK;
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return .0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 290.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 24.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 20.0f;
}
- (Level2BuySellCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[Level2BuySellCell alloc] init];
    }
    return self.gridHeader;
}

@end

@interface Level2BuySellCell()

@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation Level2BuySellCell

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
    return nil;
}

- (UIView*)scrollableAreaViewInit
{
    if (self.scrollableAreaView == nil) {
        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
        
        NSLog(@"lebar nya = %f",self.scrollableAreaView.frame.size.width);
        
        //[self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 50, 32) withLabel:@"#B" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 75, 28) withLabel:@"Lot" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(110, 0, 50, 28) withLabel:@"Bid" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(200, 0, 50, 28) withLabel:@"Offer" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(250, 0, 75, 28) withLabel:@"Lot" andTag:5]];
        //[self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(370, 0, 50, 32) withLabel:@"#O" andTag:6]];
        
        //((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        //((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
