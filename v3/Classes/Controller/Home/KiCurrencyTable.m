//
//  KiCurrencyTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "KiCurrencyTable.h"

#import "ObjectBuilder.h"
#import "NSString+Addons.h"
#import "MarketData.h"
#import "Util.h"

#define CURR_IDENTIFIER @"CurrGridIdentifier"
#define CurrHKKScrollableOffsetChanged @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr"
#define CurrNotifiticationUserInfoContentOffset @"kNotificationUserInfoContentOffsetCurr"


@interface KiCurrencyTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *currGrid;
@property (strong, nonatomic) CurrGridViewCell *currGridHeader;

@property (strong, nonatomic) NSArray *currencies;
@end

@implementation KiCurrencyTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.currGrid = gridView;
        
//        self.currGrid.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr";
//        self.currGrid.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetCurr";
        
        self.currGrid.dataSource = self;
        self.currGrid.delegate = self;
        self.currGrid.verticalBounce = YES;
        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        self.currGrid.backgroundColor = [UIColor clearColor];
        [self.currGrid registerClassForGridCellView:[CurrGridViewCell class] reuseIdentifier:CURR_IDENTIFIER];
    }
    return self;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (void)updateCurrencies:(NSArray *)currencies
{
//    NSArray *tmp = [[MarketData sharedInstance] getCurrencies];
    NSArray *sort = [currencies sortedArrayUsingComparator:^(KiCurrency *a, KiCurrency *b) {
        float chg1 = chg(a.last, a.prev);
        float chgp1 = chgprcnt(chg1, a.prev);
        
        float chg2 = chg(b.last, b.prev);
        float chgp2 = chgprcnt(chg2, b.prev);
        
//        NSLog(@"Seperator =====================");
//        NSLog(@"cgnp1 sort Regional = %f",chgp1);
//        NSLog(@"cgnp2 sort Regional = %f",chgp2);
        
        if(chgp2 < chgp1)
            return (NSComparisonResult)NSOrderedAscending;
        else if(chgp2 > chgp1)
            return  (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    self.currencies = sort;
    [self.currGrid reloadData];

    
//    [self.currGrid reloadData];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.currencies)
        return self.currencies.count;
    return 0;
}

#define chg(last, prev) last - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    CurrGridViewCell *cellView = (CurrGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:CURR_IDENTIFIER];
    
    if(rowIndex % 2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f0f0f0"];
    }
    else if(rowIndex % 2 == 1){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    
    cellView.kHKKScrollableOffsetChanged = CurrHKKScrollableOffsetChanged;
    cellView.kNotifiticationUserInfoContentOffset = CurrNotifiticationUserInfoContentOffset;
    cellView.callback = self.currGrid.callback;
    
    KiCurrency *curr = [self.currencies objectAtIndex:rowIndex];
    KiCurrencyData *currData1 = [[MarketData sharedInstance] getCurrencyData:curr.currCode];
    KiCurrencyData *currData2 = [[MarketData sharedInstance] getCurrencyData:curr.currAgainst];
    
    UILabel* label = cellView.fixedLabelInit;
    label.text = [NSString stringWithFormat:@"  %@ - %@", currData1.code, currData2.code];
    
    float chg = chg(curr.last, curr.prev);
    float chgp = chgprcnt(chg, curr.prev);
    
//    if(chg > 0) label.textColor = GREEN;
//    else if(chg < 0) label.textColor = RED;
//    else label.textColor = YELLOW;
    
    //    label.text = [NSString stringWithFormat:@"ke-%d", (unsigned int) rowIndex];
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 7; n ++) {
        //[((UILabel*)[scrollAreaView viewWithTag:n]) setText:[NSString stringWithFormat:@"%d.-%d", (unsigned int)rowIndex, n]];
        
        if(n==7){
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
//            label.font = [label.font fontWithSize:11];
            
            if(n == 2){
                label.text = [NSString stringWithFormat:@"%.2f(%.2f)", chgp, chg];
                [label setFrame:CGRectMake(81, -3, 65, 28)];
            }
            else if(n == 1){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", curr.last];
                [label setFrame:CGRectMake(0, -3, 62, 28)];
            }
            else if(n == 3){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", curr.open];
                [label setFrame:CGRectMake(145, -3, 62, 28)];
            }
            else if(n == 4){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", curr.high];
                [label setFrame:CGRectMake(216, -3, 62, 28)];
            }
            else if(n == 5){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", curr.low];
                [label setFrame:CGRectMake(287, -3, 62, 28)];
            }
            else if(n == 6){
                label.text = [NSString localizedStringWithFormat:@"%.2f  ", curr.prev];
                [label setFrame:CGRectMake(358, -3, 62, 28)];
            }
            
            label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
            
            //        if(n == 1 || n > 2)
            label.textAlignment = NSTextAlignmentRight;
            
            if(n < 4 || n == 7) {
                if(chg > 0){
                    label.textColor = GREEN;
                }
                else if(chg < 0){
                    label.textColor = RED;
                }
                else
                    label.textColor = YELLOW;
                
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
- (CurrGridViewCell *)gridHeaderViewInit
{
    if (self.currGridHeader == nil) {
        self.currGridHeader = [[CurrGridViewCell alloc] init];
    }
    return self.currGridHeader;
}

@end


@interface CurrGridViewCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation CurrGridViewCell

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr";
        self.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetCurr";
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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(5, -5, 100, 20) withLabel:@"  CURRENCY" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
        self.fixedLabel.adjustsFontSizeToFitWidth = YES;
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
        
        
        //CGFloat x = 0;
        //CGFloat pad = 8;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, -0, 62, 28) withLabel:@"Price" andTag:1]];
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