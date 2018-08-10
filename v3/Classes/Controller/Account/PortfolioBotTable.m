//
//  PortfolioBotTable.m
//  Ciptadana
//
//  Created by Reyhan on 11/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "PortfolioBotTable.h"

#import "SysAdmin.h"
#import "MarketData.h"
#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#define IDENTIFIER @"GridIdentifierPortfolio"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChangedPortfolio"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffsetPortfolio"


@interface PortfolioBotTable()  <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) PortfolioBotTableCell *gridHeader;
@property (strong, nonatomic) NSArray *porttolios;

@end


@implementation PortfolioBotTable

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
        [self.scrollGrid registerClassForGridCellView:[PortfolioBotTableCell class] reuseIdentifier:IDENTIFIER];
    }
    return self;
}

- (void)updatePortfolio:(NSArray *)porttolios
{
    self.porttolios = porttolios;
    [self.scrollGrid reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.porttolios)
        return self.porttolios.count;
    return 0;
}

#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    PortfolioBotTableCell *cellView = (PortfolioBotTableCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    
    Portfolio *p = [self.porttolios objectAtIndex:rowIndex];
    
    if(p) {
        
        int32_t lotSize = [SysAdmin sharedInstance].sysAdminData.lotSize;
        if(lotSize <= 0) lotSize = 100;
        
        UILabel* left = cellView.fixedLabelInit;
        left.text = [NSString stringWithFormat:@"  %@", p.stockcode];
        
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:p.stockcode];
        left.textColor = UIColorFromHex(data.color);
        
        UIView* scrollAreaView = cellView.scrollableAreaViewInit;
        for(int n = 1; n <= 8; n ++) {
            UILabel* label = [scrollAreaView viewWithTag:n];
            
            double avgPrice =  p.avgPrice;
            
            if(n == 1) label.text = [NSString localizedStringWithFormat:@"%.0f", p.lot];
            else if(n == 2) label.text = [NSString localizedStringWithFormat:@"%.0f", p.lot/lotSize];
            else if(n == 3) label.text = [NSString localizedStringWithFormat:@"%.0f", p.outstanding];
            else if(n == 4) label.text = @"0.00";
            else if(n == 5) label.text = @"0.00";
            else if(n == 6) label.text = @"0.00";
            else if(n == 7) label.text = [NSString localizedStringWithFormat:@"%.2f", avgPrice];
            else if(n == 8) label.text = @"0.00";
            
            KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryByStock:p.stockcode];
            if(summary) {
                int32_t lastprice = summary.stockSummary.ohlc.close;
                if(lastprice == 0)
                    lastprice = summary.stockSummary.previousPrice;
                
                double profitloss = (p.lot * lastprice) - (p.lot * avgPrice);
                double profitlossPct = ((lastprice - avgPrice) / avgPrice) * 100;

                if(n == 4) label.text = [NSString localizedStringWithFormat:@"%.2f", profitlossPct];
                if(n == 5) label.text = [NSString localizedStringWithFormat:@"%.0f", profitloss];
                else if(n == 6) label.text = [NSString localizedStringWithFormat:@"%d", summary.stockSummary.ohlc.close];
                else if(n == 8) label.text = [NSString localizedStringWithFormat:@"%.0f", p.lot * lastprice];
                
                if(n == 4)
                    label.textColor = profitlossPct > 0 ? GREEN : profitlossPct < 0 ? RED : YELLOW;
                else if(n == 5)
                    label.textColor = profitloss > 0 ? GREEN : profitloss < 0 ? RED : YELLOW;
                
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
    return 545.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 32.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 28.0f;
}
- (PortfolioBotTableCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[PortfolioBotTableCell alloc] init];
    }
    return self.gridHeader;
}

@end


@interface PortfolioBotTableCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation PortfolioBotTableCell

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
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 60, 28) withLabel:@"  STOCK" andTag:0];
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
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 60, 32) withLabel:@"SHARE" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(64, 0, 40, 32) withLabel:@"LOT" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(118, 0, 70, 32) withLabel:@"SELL ORDER" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(192, 0, 40, 32) withLabel:@"%P/L" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(246, 0, 60, 32) withLabel:@"P/L" andTag:5]];
        //[self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(252, 0, 100, 32) withLabel:@"% P/L" andTag:4]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(310, 0, 40, 32) withLabel:@"LAST" andTag:6]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(354, 0, 60, 32) withLabel:@"AVG" andTag:7]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(418, 0, 60, 32) withLabel:@"VALUE" andTag:8]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:7]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:8]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:9]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end