//
//  MarketSummaryTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "MarketSummaryTable.h"

#import "ObjectBuilder.h"
#import "NSString+Addons.h"
#import "MarketFeed.h"
#import "MarketData.h"
#import "SysAdmin.h"
#import "Util.h"

#define IDENTIFIER @"GridIdentifierRunning"
#define HKKScrollableOffsetChanged @"kHKKScrollableGridTableCellViewScrollOffsetChangedRunning"
#define NotifiticationUserInfoContentOffset @"kNotificationUserInfoContentOffsetRunning"

@interface MarketSummaryTable() <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *gridView;
//@property (strong, nonatomic) MarketSummaryCell *gridHeader;
@property (retain, nonatomic) NSMutableArray *arraySummary;
@property (assign, nonatomic) NSInteger rowTable;


@end

@implementation MarketSummaryTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.gridView = gridView;
        
        //        self.currGrid.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr";
        //        self.currGrid.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetCurr";
        
        self.gridView.dataSource = self;
        self.gridView.delegate = self;
        self.gridView.verticalBounce = YES;
        self.gridView.backgroundColor = [UIColor clearColor];
        [self.gridView registerClassForGridCellView:[MarketSummaryCellV3 class] reuseIdentifier:IDENTIFIER];
        [self.gridView accessibilityScroll:UIAccessibilityScrollDirectionUp];
        
        self.arraySummary = [NSMutableArray arrayWithObjects:
                             [NSArray arrayWithObjects:@"  SECURITIES", @"VALUE", @"VOLUME", @"FREQUENCY", @"HEADER", nil],
                             [NSArray arrayWithObjects:@"  REGULAR", @"0", @"0", @"0", @"", nil],
                             [NSArray arrayWithObjects:@"  NEGO", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  CASH", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  TOTAL", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"", @"", @"", @"",  @"", nil],
                             [NSArray arrayWithObjects:@"  RIGHTS", @"VALUE", @"VOLUME", @"FREQUENCY",  @"HEADER", nil],
                             [NSArray arrayWithObjects:@"  REGULAR", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  NEGO", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  CASH", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  TOTAL", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"", @"", @"", @"",  @"", nil],
                             [NSArray arrayWithObjects:@"  WARRANT", @"VALUE", @"VOLUME", @"FREQUENCY",  @"HEADER", nil],
                             [NSArray arrayWithObjects:@"  REGULAR", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  NEGO", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  CASH", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  TOTAL", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"", @"", @"", @"",  @"", nil],
                             [NSArray arrayWithObjects:@"  D/F SUMMARY", @"B VALUE", @"S VALUE", @"NETT",  @"HEADER", nil],
                             [NSArray arrayWithObjects:@"  DOMESTIC", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  FOREIGN", @"0", @"0", @"0",  @"", nil],
                             [NSArray arrayWithObjects:@"  NET F/D", @"0", @"0", @"0",  @"", nil],
                             nil];
        
    }
    return self;
}

- (void)newSummary:(NSArray *)summary
{
    [self.gridView reloadData];
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
    
    return [NSString localizedStringWithFormat:@"%.2f", currency];
}

- (NSString *)currencySimplyfyInt64:(int64_t)currency
{
    if(llabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%.2fB", (currency / 1000000000.f)];
    else if(llabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%.2fM", (currency / 1000000.f)];
//    else if(llabs(currency) > 1000)
//        return [NSString localizedStringWithFormat:@"%lldK", (currency / 1000)];
    
    return [NSString localizedStringWithFormat:@"%lld", currency];
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.arraySummary.count;
}

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    MarketSummaryCellV3 *cellView = (MarketSummaryCellV3 *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = HKKScrollableOffsetChanged;
    cellView.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
    
    NSArray *array = [self.arraySummary objectAtIndex:rowIndex];
    
    UILabel* label = cellView.fixedLabelInit;
    label.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:0]];
    
    BOOL isHeader = NO;
    
    if([@"HEADER" isEqualToString:[array objectAtIndex:4]]) {
        isHeader = YES;
        [cellView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"longbar"]]];
        self.rowTable = 0;
    }
    else {
        if(self.rowTable %2 == 0)
            [cellView setBackgroundColor:[UIColor whiteColor]];
        else
            cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
        
        self.rowTable++;
    }
    
    
    UIView *scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 3; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
        label.font = FONT_TITLE_LABEL_CELL;
        label.text = @"";
        
        if(isHeader && rowIndex < 17) {
            if(n == 1) label.text = @"VALUE";
            else if(n == 2) label.text = @"VOLUME";
            else if(n == 3) label.text = @"FREQ";
        }
        else if(isHeader && rowIndex >= 17) {
            if(n == 1) label.text = @"B VALUE";
            else if(n == 2) label.text = @"S VALUE";
            else if(n == 3) label.text = @"NETT";
        }
        else {
            MarketSummary *summary = [MarketFeed sharedInstance].marketSummary;
            
            if(rowIndex > 17) {
                //d/f summary
                MarketData *db = [MarketData sharedInstance];
                
                if(rowIndex == 19) {
                    if(n == 1) label.text = [self currencySimplyfy:db.fdValue.d_buyvalue];
                    else if(n == 2) label.text = [self currencySimplyfy:db.fdValue.d_sellvalue];
                    else if(n == 3) label.text = [self currencySimplyfy:db.fdValue.d_buyvalue - db.fdValue.d_sellvalue];
                }
                else if(rowIndex == 20) {
                    if(n == 1) label.text = [self currencySimplyfy:db.fdValue.f_buyvalue];
                    else if(n == 2) label.text = [self currencySimplyfy:db.fdValue.f_sellvalue];
                    else if(n == 3) label.text = [self currencySimplyfy:db.fdValue.f_buyvalue - db.fdValue.f_sellvalue];
                }
                else if(rowIndex == 21) {
                    long double net_buy = db.fdValue.d_buyvalue - db.fdValue.f_buyvalue;
                    long double net_sell = db.fdValue.d_sellvalue - db.fdValue.f_sellvalue;
                    long double net = (fabsl(db.fdValue.d_buyvalue - db.fdValue.d_sellvalue)) - (fabsl(db.fdValue.f_buyvalue - db.fdValue.f_sellvalue));
                    
                    if(n == 1) label.text = [self currencySimplyfy:net_buy];
                    else if(n == 2) label.text = [self currencySimplyfy:net_sell];
                    else if(n == 3) label.text = [self currencySimplyfy:net];
                }
            }
            else if(rowIndex > 11) {
                //warrant
                if(rowIndex == 13) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.warantRg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.warantRg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.warantRg.value];
                }
                if(rowIndex == 14) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.warantNg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.warantNg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.warantNg.value];
                }
                if(rowIndex == 15) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.warantTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.warantTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.warantTn.value];
                }
                if(rowIndex == 16) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.warantRg.volume + summary.warantNg.volume + summary.warantTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.warantRg.frequency + summary.warantNg.frequency + summary.warantTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.warantRg.value + summary.warantNg.value + summary.warantTn.value];
                }
            }
            else if(rowIndex > 5) {
                //rights
                
                if(rowIndex == 7) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.rightRg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.rightRg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.rightRg.value];
                }
                if(rowIndex == 8) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.rightNg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.rightNg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.rightNg.value];
                }
                if(rowIndex == 9) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.rightTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.rightTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.rightTn.value];
                }
                if(rowIndex == 10) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.rightRg.volume + summary.rightNg.volume + summary.rightTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.rightRg.frequency + summary.rightNg.frequency + summary.rightTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.rightRg.value + summary.rightNg.value + summary.rightTn.value];
                }
            }
            else if(rowIndex > 0) {
                //security
                
                if(rowIndex == 1) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.stockRg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.stockRg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.stockRg.value];
                }
                if(rowIndex == 2) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.stockNg.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.stockNg.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.stockNg.value];
                }
                if(rowIndex == 3) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.stockTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.stockTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.stockTn.value];
                }
                if(rowIndex == 4) {
                    if(n == 2) label.text = [self currencySimplyfyInt64: summary.stockRg.volume + summary.stockNg.volume + summary.stockTn.volume];
                    else if(n == 3) label.text = [self currencySimplyfyInt64: summary.stockRg.frequency + summary.stockNg.frequency + summary.stockTn.frequency];
                    else if(n == 1) label.text = [self currencySimplyfyInt64: summary.stockRg.value + summary.stockNg.value + summary.stockTn.value];
                }
            }
        }
    }
    
    return cellView;
}

- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 110.f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 206.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    //return self.gridHeaderViewInit;
    return nil;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 0.f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
//    if(rowIndex == 5 || rowIndex == 11 || rowIndex == 17)
//        return 5.f;
//    
//    return 28.0f;
    return 20.0f;
}

//- (MarketSummaryCell *)gridHeaderViewInit
//{
//    if (self.gridHeader == nil) {
//        self.gridHeader = [[MarketSummaryCell alloc] init];
//    }
//    return self.gridHeader;
//}

@end


@interface MarketSummaryCellV3()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation MarketSummaryCellV3

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = HKKScrollableOffsetChanged;
        self.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
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

- (UIView *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, -4, 110, 28) withLabel:@"   securities" andTag:0];
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
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, -4, 60, 32) withLabel:@"0" andTag:1]];//value
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(68, -4, 60, 32) withLabel:@"0" andTag:2]];//volume
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(134, -4, 60, 32) withLabel:@"0" andTag:3]];//frequency
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
