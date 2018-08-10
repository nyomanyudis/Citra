//
//  KiRunTable.m
//  Ciptadana
//
//  Created by Reyhan on 10/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "KiRunTable.h"

#import "GrandController.h"

#import "ObjectBuilder.h"
#import "NSString+Addons.h"
#import "MarketData.h"
#import "SysAdmin.h"
#import "Util.h"

#define IDENTIFIER @"GridIdentifierRunning"
#define HKKScrollableOffsetChanged @"kHKKScrollableGridTableCellViewScrollOffsetChangedRunning"
#define NotifiticationUserInfoContentOffset @"kNotificationUserInfoContentOffsetRunning"

#define MAX_RUNNINGTRADE 50


@interface KiRunTable() <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *gridView;
@property (strong, nonatomic) RunGridViewCell *gridHeader;

@property (strong, nonatomic) NSMutableArray *trades;
@property (strong, nonatomic) LoginData *loginData;
@property (assign, nonatomic) NSInteger color;

@end

@implementation KiRunTable


#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.gridView = gridView;
        self.color = 1;
        
        //        self.currGrid.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr";
        //        self.currGrid.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetCurr";
        
        self.gridView.dataSource = self;
        self.gridView.delegate = self;
        self.gridView.verticalBounce = NO;
        self.gridView.backgroundColor = [UIColor clearColor];
        [self.gridView registerClassForGridCellView:[RunGridViewCell class] reuseIdentifier:IDENTIFIER];
        [self.gridView accessibilityScroll:UIAccessibilityScrollDirectionUp];
        
        self.trades = [NSMutableArray array];
        self.loginData = [SysAdmin sharedInstance].sysAdminData;
    }
    return self;
}

- (void)newTrade:(NSArray *)trades
{
    if(trades) {
        
        [self.trades insertObjects:trades atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, trades.count)]];
//        if(self.trades.count > MAX_RUNNINGTRADE)
//            [self.trades removeObjectsInRange:NSMakeRange(MAX_RUNNINGTRADE - 1, self.trades.count - MAX_RUNNINGTRADE)];
//        [self.gridView reloadData];
        
        
////        if(trades.count + self.trades.count > MAX_RUNNINGTRADE) {
////            int count = (trades.count + self.trades.count) - MAX_RUNNINGTRADE;
////            [self.trades removeObjectsInRange:NSMakeRange(self.trades.count - count - 1, self.trades.count - 1)];
////        }
//        [self.trades insertObjects:trades atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, trades.count)]];
//        
//        
        NSMutableArray *insertIndexPaths = [NSMutableArray array];
        if(trades && trades.count > 0) {
            int max = trades.count > MAX_RUNNINGTRADE ? MAX_RUNNINGTRADE : trades.count;
            for(int n = 0; n < max; n ++) {
                [insertIndexPaths addObject:[NSIndexPath indexPathForRow:n inSection:0]];
            }
        }
        [self.gridView insertNewCells:insertIndexPaths maxRow:MAX_RUNNINGTRADE];
        //[self.gridView reloadData];
    }
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.trades)
        return self.trades.count;
    return 0;
}

#define chg(last, prev) last - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    RunGridViewCell *cellView = (RunGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    
    cellView.kHKKScrollableOffsetChanged = HKKScrollableOffsetChanged;
    cellView.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
    
    if(rowIndex % 2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    else if(rowIndex %2 == 1){
        cellView.backgroundColor = [UIColor whiteColor];
    }
    
    KiTrade *p = [self.trades objectAtIndex:rowIndex];
    KiBrokerData *b = [[MarketData sharedInstance] getBrokerDataById:p.buyerBrokerId];
    KiBrokerData *s = [[MarketData sharedInstance] getBrokerDataById:p.sellerBrokerId];
    KiStockData *stock = [[MarketData sharedInstance] getStockDataById:p.codeId];
    
    float chg = chg(p.trade.price, p.previous);
    float chgp = chgprcnt(chg, p.previous);
    
    uint time = p.trade.tradeTime;
    
    uint seconds = time % 100;
    time = (time - seconds) / 100;
    uint minutes = time % 100;
    uint hours = (time - minutes) / 100;
//    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    UIView* fixedView = cellView.fixedLabelInit;
    UILabel *label1 = [fixedView viewWithTag:1];
    UILabel *label2 = [fixedView viewWithTag:2];
    
    label1.text = [NSString stringWithFormat:@"  %02d:%02d:%02d", hours, minutes, seconds];
    if(stock) {
        label2.text = stock.code;
        label2.textColor = UIColorFromHex(stock.color);//UIColorFromRGB(stringToHexa(stock.color));
    }
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 7; n ++) {
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
            
            if(n == 5) {
                label.text = b.code;
                label.textColor = b.type == InvestorTypeD ? BLACK : MAGENTA;
            }
            else if(n == 6) {
                label.text = s.code;
                label.textColor = s.type == InvestorTypeD ? BLACK : MAGENTA;
            }
            else if(n == 4) {
                if(self.loginData && self.loginData.lotSize > 0)
                    label.text = [NSString localizedStringWithFormat:@"%d", (p.trade.volume / self.loginData.lotSize)];
                else
                    label.text = [NSString localizedStringWithFormat:@"%d", (p.trade.volume / 100)];
            }
            else if(n == 1)
                label.text = [NSString localizedStringWithFormat:@"%d", p.trade.price];
            else if(n == 2 && chg < 0)
                label.text = [NSString localizedStringWithFormat:@"%.0f", chg];
            else if(n == 2 && chg > 0)
                label.text = [NSString localizedStringWithFormat:@"%.0f", chg];
            else if(n == 3)
                label.text = [NSString localizedStringWithFormat:@"%.2f", chgp];
            
            if(n <= 3) {
                if(chg > 0)
                    label.textColor = GREEN;
                else if(chg < 0)
                    label.textColor = RED;
                else
                    label.textColor = YELLOW;
            }
            
            if(n == 3)
                label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
        }
        
    }
    return cellView;
}

- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 120.f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 350.0f;
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
- (RunGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[RunGridViewCell alloc] init];
    }
    return self.gridHeader;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface RunGridViewCell()

@property (nonatomic, strong) UIView* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation RunGridViewCell

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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(0, -5, 70, 28) withLabel:@"   TIME" andTag:1]];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(75, -5, 60, 28) withLabel:@"STOCK" andTag:2]];
        
        self.fixedLabel = view;
        [self.fixedView addSubview:self.fixedLabel];
//        self.layer.borderWidth = 0.5f;
//        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(5, -5, 100, 28) withLabel:@"   TIME" andTag:0];
//        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
//        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
//        self.fixedLabel.backgroundColor = [UIColor clearColor];
//        [self.fixedView addSubview:self.fixedLabel];
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
//        self.layer.borderWidth = 0.5f;
        
        CGFloat x = 0;
        CGFloat pad = 8;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 60) + (pad * x), -6, 60, 32) withLabel:@"Price" andTag:1]];x++;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridImage:CGRectMake((x * 60) + (pad * x), 5, 7, 8) andTag:7]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 60) + (pad * x), -6, 50, 32) withLabel:@"Change" andTag:2]];x++;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 50) + (pad * x), -6, 50, 32) withLabel:@"%" andTag:3]];x++;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 50) + (pad * x), -6, 60, 32) withLabel:@"Lot" andTag:4]];x++;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 60) + (pad * x), -6, 30, 32) withLabel:@"B" andTag:5]];x++;
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake((x * 60)-30 + (pad * x), -6, 30, 32) withLabel:@"S" andTag:6]];x++;
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:6]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

@end
