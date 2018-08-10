//
//  StockWatchLevel3V3.m
//  Ciptadana
//
//  Created by Reyhan on 10/31/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "StockWatchLevel3V3.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"


#define IDENTIFIER @"GridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChanged"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffset"


static NSMutableDictionary *lastLevel3;

@interface StockWatchLevel3V3()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) StockWatchLevel3V3Cell *gridHeader;
@property (strong, nonatomic) Level3 *level3;
@property (strong, nonatomic) KiStockSummary *summary;
@property (assign) unsigned long max;

@end


@implementation StockWatchLevel3V3

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
        [self.scrollGrid registerClassForGridCellView:[StockWatchLevel3V3Cell class] reuseIdentifier:IDENTIFIER];
        
        lastLevel3 = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)updateLevel3:(NSArray *)level3 data:(KiStockData *)data
{
    if(level3) {
        self.summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
        if(level3 && level3.count > 0) {
            self.level3 = [level3 objectAtIndex:0];
            [self.scrollGrid reloadData];
            
            [lastLevel3 setObject:self.level3 forKey:data.code];
        }
        else {
            self.level3 = [lastLevel3 objectForKey:data.code];
            
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
    if(self.level3)
        return  self.level3.detail.count;
    return 10;
}


- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    StockWatchLevel3V3Cell *cellView = (StockWatchLevel3V3Cell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 4; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
//        label.font = FONT_TITLE_LABEL_CELL;
        
        Level3Detail *detail = [self.level3.detail objectAtIndex:rowIndex];
        if(n == 1) {
            label.text = [NSString localizedStringWithFormat:@"%d", detail.price];
            [label setFrame:CGRectMake(4, -3, 40, 28)];
        }
        else if(n == 2){
            label.text = [NSString localizedStringWithFormat:@"%d", detail.buyVolume];
            [label setFrame:CGRectMake(64, -3, 60, 28)];
        }
        else if(n == 3){
            label.text = [NSString localizedStringWithFormat:@"%d", detail.sellVolume];
            [label setFrame:CGRectMake(134, -3, 60, 28)];
        }
        else if(n == 4){
            label.text = [NSString localizedStringWithFormat:@"%d", detail.buyVolume+detail.sellVolume];
            [label setFrame:CGRectMake(214, -3, 60, 28)];
        }
        
        if(n == 2 || n == 3) {
            if(detail.price > self.summary.stockSummary.previousPrice)
                label.textColor = GREEN;
            else if(detail.price < self.summary.stockSummary.previousPrice)
                label.textColor = RED;
            else
                label.textColor = YELLOW;
        }
    }
    
    return cellView;
}


- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 0.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 285.f;
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
- (StockWatchLevel3V3Cell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[StockWatchLevel3V3Cell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface StockWatchLevel3V3Cell()

@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation StockWatchLevel3V3Cell

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
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(4, 0, 40, 28) withLabel:@"PRICE" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(64, 0, 60, 28) withLabel:@"B LOT" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(134, 0, 60, 28) withLabel:@"S LOT" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(214, 0, 60, 28) withLabel:@"T LOT" andTag:4]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
