//
//  FutureTable.m
//  Ciptadana
//
//  Created by Reyhan on 2/14/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "FutureTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"


#define IDENTIFIER @"RegionalGridIdentifierFuture"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedFuture"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetFuture"

@interface FutureTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) FutureViewCell *gridHeader;
@property (strong, nonatomic) NSArray *future;

@end

@implementation FutureTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.scrollGrid = gridView;
        
        self.scrollGrid.dataSource = self;
        self.scrollGrid.delegate = self;
        self.scrollGrid.verticalBounce = YES;
        
        self.scrollGrid.backgroundColor = [UIColor clearColor];
        [self.scrollGrid registerClassForGridCellView:[FutureViewCell class] reuseIdentifier:IDENTIFIER];
    }
    return self;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (void)updateFuture:(NSArray *)future
{
//    self.future = [[MarketData sharedInstance] getFutures];
    NSArray *tmp = [[MarketData sharedInstance] getFutures];
    NSArray *sort = [tmp sortedArrayUsingComparator:^(KiFuture *a, KiFuture *b) {
        float chg1 = chg(a.ohlc.close, a.previous);
        float chgp1 = chgprcnt(chg1, a.previous);
        
        float chg2 = chg(b.ohlc.close, b.previous);
        float chgp2 = chgprcnt(chg2, b.previous);
        
        if(chgp2 < chgp1)
            return (NSComparisonResult)NSOrderedAscending;
        else if(chgp2 > chgp1)
            return  (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    self.future = sort;

    [self.scrollGrid reloadData];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.future)
        return self.future.count;
    return 0;
}



- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    FutureViewCell *cellView = (FutureViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    KiFuture *value = [self.future objectAtIndex:rowIndex];
    KiRegionalIndicesData *data = [[MarketData sharedInstance] getRegionalIndicesDataById:value.codeId];
    
    float chg = chg(value.ohlc.close, value.previous);
    float chgp = chgprcnt(chg, value.previous);
    
    UILabel* label = cellView.fixedLabelInit;
    label.text = [NSString stringWithFormat:@"  %@", data.name];
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 7; n ++) {
        if(n == 7){
            UIImageView *imageView = [scrollAreaView viewWithTag:n];
            if(chg > 0)
                imageView.image = [UIImage imageNamed:@"arrowgreen"];
            else if (chg < 0)
                imageView.image = [UIImage imageNamed:@"arrowred"];
        }
        else{
            UILabel *label = [scrollAreaView viewWithTag:n];
//            label.font = FONT_TITLE_LABEL_CELL;
            
            if(n == 2){
                label.text = [NSString stringWithFormat:@"%.2f(%.2f)", chgp, chg];
                [label setFrame:CGRectMake(81, -3, 65, 28)];
            }
            else if(n == 1){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", value.ohlc.close];
                [label setFrame:CGRectMake(0, -3, 62, 28)];
            }
            else if(n == 3){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", value.ohlc.open];
                [label setFrame:CGRectMake(145, -3, 62, 28)];
            }
            else if(n == 4){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", value.ohlc.high];
                [label setFrame:CGRectMake(216, -3, 62, 28)];
            }
            else if(n == 5){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", value.ohlc.low];
                [label setFrame:CGRectMake(287, -3, 62, 28)];
            }
            else if(n == 6){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", value.previous];
                [label setFrame:CGRectMake(358, -3, 62, 28)];
            }
            
//            if(n == 2)
//                label.text = [NSString stringWithFormat:@"%.2f(%.2f)", chgp, chg];
//            else if(n == 1)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", value.ohlc.close];
//            else if(n == 3)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", value.ohlc.open];
//            else if(n == 4)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", value.ohlc.high];
//            else if(n == 5)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", value.ohlc.low];
//            else if(n == 6)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", value.previous];
            
            label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
            
            if(n == 1 || n > 2)
                label.textAlignment = NSTextAlignmentRight;
            
            if(n < 4) {
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
    return 75.f;
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
    return 28.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 20.0f;
}
- (FutureViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[FutureViewCell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface FutureViewCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation FutureViewCell

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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 100, 28) withLabel:@"  FUTURE" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
//        self.fixedLabel.adjustsFontSizeToFitWidth = YES;
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
        

        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, -0, 62, 28) withLabel:@"Last" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridImage:CGRectMake(74, 7, 7, 8) andTag:7]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(81, 0, 65, 28) withLabel:@"Change" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(145, 0, 62, 28) withLabel:@"Open" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(216, 0, 62, 28) withLabel:@"High" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(287, 0, 62, 28) withLabel:@"Low" andTag:5]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(358, 0, 62, 28) withLabel:@"Previous" andTag:6]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentRight;
        
//        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).adjustsFontSizeToFitWidth = YES;
//        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).adjustsFontSizeToFitWidth = YES;
//        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).adjustsFontSizeToFitWidth = YES;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end