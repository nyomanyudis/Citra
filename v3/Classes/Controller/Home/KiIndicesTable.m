//
//  KiIndicesTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "KiIndicesTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"


#define INDI_IDENTIFIER @"IndiGridIdentifier"

@interface KiIndicesTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) IndiGridViewCell *gridHeader;
@property (strong, nonatomic) NSArray *indices;

@end

@implementation KiIndicesTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.scrollGrid = gridView;
        
//        self.scrollGrid.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedIndi";
//        self.scrollGrid.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetIndi";
        
        self.scrollGrid.dataSource = self;
        self.scrollGrid.delegate = self;
        self.scrollGrid.verticalBounce = YES;
        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        self.scrollGrid.backgroundColor = [UIColor clearColor];
        [self.scrollGrid registerClassForGridCellView:[IndiGridViewCell class] reuseIdentifier:INDI_IDENTIFIER];
    }
    return self;
}

#define chg(close, prev) prev - close
#define chgprcnt(chg, prev) chg * 100 / prev

- (void)updateIndices:(NSArray *)indices
{
    NSMutableArray *tmp = [NSMutableArray array];
    for(KiIndices *i in indices) {
        //KiIndices *indi = [self.indices objectAtIndex:rowIndex];
        KiIndicesData *indiData = [[MarketData sharedInstance] getIndicesData:i.codeId];
        if(indiData) {
            if([indiData.code isEqualToString:@"COMPOSITE"] && tmp.count > 0)
                [tmp insertObject:i atIndex:0];
            else
                [tmp addObject:i];
        }
    }
    
    NSArray *sort = [tmp sortedArrayUsingComparator:^(KiIndices *a, KiIndices *b) {
        float chg1 = chg(a.indices.previous, a.indices.ohlc.close);
        float chgp1 = chgprcnt(chg1, a.indices.previous);
        
        float chg2 = chg(b.indices.previous, b.indices.ohlc.close);
        float chgp2 = chgprcnt(chg2, b.indices.previous);
        
        if(chgp2 < chgp1)
            return (NSComparisonResult)NSOrderedAscending;
        else if(chgp2 > chgp1)
            return  (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    self.indices = sort;
    [self.scrollGrid reloadData];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.indices)
        return self.indices.count;
    return 0;
}

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    IndiGridViewCell *cellView = (IndiGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:INDI_IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedIndi";
    cellView.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetIndi";
    cellView.callback = self.scrollGrid.callback;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f0f0f0"];
    }
    else if(rowIndex %2 == 1){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    KiIndices *indi = [self.indices objectAtIndex:rowIndex];
    KiIndicesData *indiData = [[MarketData sharedInstance] getIndicesData:indi.codeId];
    
    float chg = chg(indi.indices.previous, indi.indices.ohlc.close);
    float chgp = chgprcnt(chg, indi.indices.previous);
    
    UILabel* label = cellView.fixedLabelInit;
    if([indiData.code isEqualToString:@"COMPOSITE"])
        label.text = @"  IHSG";
    else label.text = [NSString stringWithFormat:@"  %@", indiData.code];
    
//    if(chg > 0) label.textColor = GREEN;
//    else if(chg < 0) label.textColor = RED;
//    else label.textColor = YELLOW;
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 7; n ++) {
        //[((UILabel*)[scrollAreaView viewWithTag:n]) setText:[NSString stringWithFormat:@"%d.-%d", (unsigned int)rowIndex, n]];
        if(n == 7){
            UIImageView *imageView = [scrollAreaView viewWithTag:n];
            if(chg > 0)
                imageView.image = [UIImage imageNamed:@"arrowgreen"];
            else if (chg < 0)
                imageView.image = [UIImage imageNamed:@"arrowred"];
            else
                imageView.image = nil;
        }
        else{
            UILabel *label = [scrollAreaView viewWithTag:n];
//            label.font = FONT_TITLE_LABEL_CELL;
            
            if(n == 2){
                label.text = [NSString stringWithFormat:@"%.2f(%.2f)", chgp, chg];
                [label setFrame:CGRectMake(81, -3, 65, 28)];
            }
            else if(n == 1){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", indi.indices.ohlc.close];
                [label setFrame:CGRectMake(0, -3, 62, 28)];
            }
            else if(n == 3){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", indi.indices.ohlc.open];
                [label setFrame:CGRectMake(145, -3, 62, 28)];
            }
            else if(n == 4){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", indi.indices.ohlc.high];
                [label setFrame:CGRectMake(216, -3, 62, 28)];
            }
            else if(n == 5){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", indi.indices.ohlc.low];
                [label setFrame:CGRectMake(287, -3, 62, 28)];
            }
            else if(n == 6){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", indi.indices.previous];
                [label setFrame:CGRectMake(358, -3, 62, 28)];
            }

            
//            if(n == 2)
//                label.text = [NSString stringWithFormat:@"%.2f(%.2f)", chgp, chg];
//            else if(n == 1)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", indi.indices.ohlc.close];
//            else if(n == 3)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", indi.indices.ohlc.open];
//            else if(n == 4)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", indi.indices.ohlc.high];
//            else if(n == 5)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", indi.indices.ohlc.low];
//            else if(n == 6)
//                label.text = [NSString localizedStringWithFormat:@"%.2f", indi.indices.previous];
            
            label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
            
            if(n == 1 || n > 2)
                label.textAlignment = NSTextAlignmentRight;
            
            if(n < 4) {
                if(chg > 0) label.textColor = GREEN;
                else if(chg < 0) label.textColor = RED;
                else label.textColor = YELLOW;
                //else label.textColor = [UIColor yellowColor];
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
    return 440.0f;
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
- (IndiGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[IndiGridViewCell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface IndiGridViewCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation IndiGridViewCell

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedIndi";
        self.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetIndi";
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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(5, 0, 100, 20) withLabel:@"  INDICES" andTag:0];
//        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
//        self.fixedLabel.adjustsFontSizeToFitWidth = YES;
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
    if(self.callback) {
        self.callback(0, nil);
    }
    
}

@end