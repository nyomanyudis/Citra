//
//  SummaryTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/27/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SummaryTable.h"

#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

//#define MAXROW 40
//
//#define IDENTIFIER @"BrokerGridIdentifier"
//#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedBroker"
//#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetBroker"


@interface SummaryTable()  <UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) KiStockSummary *summary;

@end

@implementation SummaryTable


- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if(self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (void)updateSummary:(KiStockSummary *)summary
{
    self.summary = summary;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Identifier = [NSString stringWithFormat:@"cell%d", (int)(indexPath.row + 1)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if(self.summary) {
        //hi low open prev volume val
        UILabel *label1 = [cell.contentView viewWithTag:1];
        UILabel *label2 = [cell.contentView viewWithTag:2];
        
        if(indexPath.row == 0) {
            label1.text = [NSString localizedStringWithFormat:@"%d", self.summary.stockSummary.ohlc.high];
            label2.text = [NSString localizedStringWithFormat:@"%d", self.summary.stockSummary.previousPrice];
            
            label2.textColor = self.summary.stockSummary.ohlc.high > self.summary.stockSummary.previousPrice ? GREEN : self.summary.stockSummary.ohlc.high < self.summary.stockSummary.previousPrice ? RED : YELLOW;
        }
        else if(indexPath.row == 1) {
            label1.text = [NSString localizedStringWithFormat:@"%d", self.summary.stockSummary.ohlc.low];
            //label2.text = [NSString localizedStringWithFormat:@"%lld", self.summary.stockSummary.tradedVolume];
            
            int64_t volume = self.summary.stockSummary.tradedVolume;
            if(volume > 10000000)
                label2.text = [NSString localizedStringWithFormat:@"%lldK", (volume/1000)];
            else
                label2.text = [NSString localizedStringWithFormat:@"%lld", volume];
        }
        else if(indexPath.row == 2) {
            label1.text = [NSString localizedStringWithFormat:@"%d", self.summary.stockSummary.ohlc.open];
            int64_t value = self.summary.stockSummary.tradedValue;
            if(value > 1000000)
                label2.text = [NSString localizedStringWithFormat:@"%lldM", (value/1000000)];
            else if(value > 1000)
                label2.text = [NSString localizedStringWithFormat:@"%lldK", (value/1000)];
            else
                label2.text = [NSString localizedStringWithFormat:@"%lld", value];
        }
        
        label1.textColor = self.summary.stockSummary.ohlc.high > self.summary.stockSummary.previousPrice ? GREEN : self.summary.stockSummary.ohlc.high < self.summary.stockSummary.previousPrice ? RED : YELLOW;
    }
    
    return cell;
}

@end

//@interface SummaryTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>
//
//@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
//@property (strong, nonatomic) SummaryTableCell *gridHeader;
//@property (strong, nonatomic) KiStockSummary *summary;
//
//@end
//
//@implementation SummaryTable
//
//#pragma public
//
//- (id)initWithGridView:(HKKScrollableGridView *)gridView
//{
//    self = [super init];
//    if(self) {
//        self.scrollGrid = gridView;
//        
//        self.scrollGrid.dataSource = self;
//        self.scrollGrid.delegate = self;
//        self.scrollGrid.verticalBounce = YES;
//        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
//        self.scrollGrid.backgroundColor = [UIColor clearColor];
//        [self.scrollGrid registerClassForGridCellView:[SummaryTableCell class] reuseIdentifier:IDENTIFIER];
//    }
//    return self;
//}
//
//- (void)updateSummary:(KiStockSummary *)summary
//{
//    self.summary = summary;
//    [self.scrollGrid reloadData];
//}
//
//#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
//- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
//{
//    return 6;
//}
//
//- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
//{
//    SummaryTableCell *cellView = (SummaryTableCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
//    
//    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
//    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
//    
//    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
//    for(int n = 1; n <= 4; n ++) {
//        UILabel *label = [scrollAreaView viewWithTag:n];
//        
//        if(rowIndex == 0) {
//            if(n == 1) label.text = @"Close";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"Market Cap";
//            //else if(n == 4) label.text = @"0";
//            
//            if(self.summary) {
//                if(n == 2) label.text = [NSString localizedStringWithFormat:@"%.2d", self.summary.stockSummary.ohlc.close];
//            }
//        }
//        else if(rowIndex == 1) {
//            if(n == 1) label.text = @"Open";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"PE";
//            else if(n == 4) label.text = @"N/A";
//            
//            if(self.summary) {
//                if(n == 2) label.text = [NSString localizedStringWithFormat:@"%.2d", self.summary.stockSummary.ohlc.open];
//            }
//        }
//        else if(rowIndex == 2) {
//            if(n == 1) label.text = @"52wk Low";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"EPS";
//            else if(n == 4) label.text = @"N/A";
//        }
//        else if(rowIndex == 3) {
//            if(n == 1) label.text = @"52wk High";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"Div";
//            else if(n == 4) label.text = @"N/A";
//        }
//        else if(rowIndex == 4) {
//            if(n == 1) label.text = @"Volume";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"Earning";
//            else if(n == 4) label.text = @"N/A";
//            
//            if(self.summary) {
//                if(n == 2) label.text = [NSString localizedStringWithFormat:@"%.2lld", self.summary.stockSummary.tradedVolume];
//            }
//        }
//        else if(rowIndex == 5) {
//            if(n == 1) label.text = @"Avg. Volume";
//            //else if(n == 2) label.text = @"0";
//            else if(n == 3) label.text = @"1y Target Est";
//            else if(n == 4) label.text = @"N/A";
//            
//        }
//    }
//    
//    return cellView;
//}
//
//
//- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
//{
//    return 0.f;
//}
//
//- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
//{
//    return 500.f;
//}
//
//- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
//{
//    return nil;
//}
//
//- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
//{
//    return 0.f;
//}
//- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
//{
//    return 32.0f;
//}
//
//@end
//
//
//@interface SummaryTableCell()
//
//@property (nonatomic, readwrite) UIView* scrollableAreaView;
//
//@end
//
//@implementation SummaryTableCell
//
//- (id)init
//{
//    self  = [super init];
//    if(self) {
//        self.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
//        self.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
//    }
//    return self;
//}
//
///*
// // Only override drawRect: if you perform custom drawing.
// // An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect {
// // Drawing code
// }
// */
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    self.scrollableAreaViewInit.frame = self.scrolledContentView.bounds;
//    
//}
//
//- (UILabel *)fixedLabelInit
//{
//    return nil;
//}
//
//- (UIView*)scrollableAreaViewInit
//{
//    if (self.scrollableAreaView == nil) {
//        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
//        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
//        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
//        
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 80, 32) withLabel:@"" andTag:1]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(90, 0, 120, 32) withLabel:@"" andTag:2]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(234, 0, 80, 32) withLabel:@"" andTag:3]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(324, 0, 120, 32) withLabel:@"" andTag:4]];
//        
//        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentLeft;
//        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
//        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentLeft;
//        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
//        
//        [self.scrolledContentView addSubview:self.scrollableAreaView];
//    }
//    return self.scrollableAreaView;
//}
//
//@end
