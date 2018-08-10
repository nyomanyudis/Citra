//
//  StockWatchNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 5/8/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "StockWatchNyoman.h"

#import "HKKScrollableGridView.h"
#import "MarketData.h"
#import "SummaryTable.h"
#import "StockWatchChart.h"
#import "StockWatchLevel2V3.h"
#import "StockWatchLevel3V3.h"
#import "StockWatchTradeV3.h"

#import "UIButton+Appearance.h"

#define buttonGreen [[UIImage imageNamed:@"bggreen"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]
#define buttonRed [[UIImage imageNamed:@"bgred"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]

@interface StockWatchNyoman ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *horizontalView;
//@property (weak, nonatomic) IBOutlet HKKScrollableGridView *summaryTable;
@property (weak, nonatomic) IBOutlet UITableView *tableSummary;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *chgpLabel;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;


@property (assign, nonatomic) BOOL unsubscribe;

@property (strong, nonatomic) StockWatchChart *chart;
@property (strong, nonatomic) StockWatchLevel2V3 *level2;
@property (strong, nonatomic) StockWatchLevel3V3 *level3;
@property (strong, nonatomic) StockWatchTradeV3 *trade;

@property (strong, nonatomic) KiStockSummary *summary;
@property (strong, nonatomic) SummaryTable *table;


@end

@implementation StockWatchNyoman

// 3
- (void)viewWillAppear:(BOOL)animated
{
    [self callback];
    
    self.unsubscribe = YES;
    if(self.stockCode) {
        KiStockData *data  = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
        self.summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
        [self updateSummary:self.summary];
        
        if(self.chart) {
            [self.chart updateChart:data lines:[NSArray array] colors:[NSArray array]];
        }
        
//        if(self.level2) {
//            [self.level2 updateLevel2:[NSArray array] data:data];
//        }
//        
//        if(self.level3) {
//            [self.level3 updateLevel3:[NSArray array] data:data];
//        }
//        
//        if(self.trade) {
//            [self.trade updateTrade:[NSArray array] data:data];
//        }
        
        [[MarketFeed sharedInstance] subscribe:RecordTypeLevel2 status:RequestSubscribe code:data.code];
        [[MarketFeed sharedInstance] subscribe:RecordTypeLevel3 status:RequestSubscribe code:data.code];
        [[MarketFeed sharedInstance] subscribe:RecordTypeStockHistory status:RequestSubscribe code:data.code];
        [[MarketFeed sharedInstance] subscribe:RecordTypeKiLastTrade status:RequestSubscribe code:data.code];
        
        [self performSelector:@selector(buttonSelector:) withObject:[self.view viewWithTag:12] afterDelay:.1];
    }
    
}

// 5
#define buttonNormal [[UIImage imageNamed:@"bgnormal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]
#define buttonHighlighted [[UIImage imageNamed:@"bgtapped"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]
- (IBAction)buttonSelector:(id)sender
{
    if(self.stockCode) {
        UIButton *tapped = sender;
        for(int n = 11; n <= 14; n ++) {
            UIButton *button = [self.view viewWithTag:n];
            
            if([tapped.titleLabel.text isEqualToString:button.titleLabel.text]) {
                [button setBackgroundImage:buttonHighlighted forState:UIControlStateNormal];
                [button setBackgroundImage:buttonNormal forState:UIControlStateHighlighted];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON forState:UIControlStateHighlighted];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateHighlighted];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_HIGHLIGHTED forState:UIControlStateNormal];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_SELECTED forState:UIControlStateSelected];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateSelected];
            }
            else {
                [button setBackgroundImage:buttonNormal forState:UIControlStateNormal];
                [button setBackgroundImage:buttonHighlighted forState:UIControlStateHighlighted];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON forState:UIControlStateNormal];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_HIGHLIGHTED forState:UIControlStateHighlighted];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateHighlighted];
                [button setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_SELECTED forState:UIControlStateSelected];
                [button setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateSelected];
            }
            
        }
        
        if([tapped.titleLabel.text isEqualToString:@"CHART"])
            [self performSelector:@selector(showChart)];
//        else if([tapped.titleLabel.text isEqualToString:@"LEVEL 2"])
//            [self performSelector:@selector(showLevel2)];
//        else if([tapped.titleLabel.text isEqualToString:@"LEVEL 3"])
//            [self performSelector:@selector(showLevel3)];
//        else if([tapped.titleLabel.text isEqualToString:@"TRADE"])
//            [self performSelector:@selector(showTrade)];
    }
}

- (void)showChart
{
    NSLog(@"showChart ");
    for(UIView *v in self.container.subviews) {
        [v removeFromSuperview];
    }
    
    if(!self.chart)
        self.chart = [[StockWatchChart alloc] initWithStock:nil rect:self.container.frame];
    
    [self.container addSubview:self.chart.chartView];
}

- (void)updateChart:(NSArray*)stockHistories
{
    if(!self.chart)
        self.chart = [[StockWatchChart alloc] initWithStock:nil rect:self.container.frame];
    
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
    KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
    
    int32_t previous = summary.stockSummary.previousPrice;
    for (StockHistory *history in stockHistories) {
        NSMutableArray *arrayChartLine = [NSMutableArray array];
        NSMutableArray *arrayChartColor = [NSMutableArray array];
        
        for(OHLC *ohlc in history.ohlc) {
            [arrayChartLine addObject:[NSNumber numberWithInt:ohlc.close]];
            
            if(previous < ohlc.close) [arrayChartColor addObject:GREEN];
            else if(previous > ohlc.close) [arrayChartColor addObject:RED];
            else [arrayChartColor addObject:YELLOW];
        }
        
        [self.chart updateChart:data lines:arrayChartLine colors:arrayChartColor];
    }
}


// 4 Paham
#define chg(close, prev) prev - close
#define chgprcnt(chg, prev) chg * 100 / prev
- (void)updateSummary:(KiStockSummary *)summary
{
    if(summary) {
        KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
        self.nameLabel.text = data.name;
        self.codeLabel.text = data.code;
        
        self.nameLabel.textColor = UIColorFromHex(data.color);
        self.codeLabel.textColor = UIColorFromHex(data.color);
        
        float chg = summary.stockSummary.change;
        float chgp = chgprcnt(summary.stockSummary.change, summary.stockSummary.previousPrice);
        
        self.priceLabel.text = [NSString localizedStringWithFormat:@"%.2d", summary.stockSummary.ohlc.close];
        self.changeLabel.text = [NSString localizedStringWithFormat:@"%.2f", chg];
        self.chgpLabel.text = [NSString localizedStringWithFormat:@"%.2f%%", chgp];
        
        if(chg > 0) {
            self.priceLabel.textColor = GREEN;
            self.changeLabel.textColor = GREEN;
            self.chgpLabel.textColor = GREEN;
        }
        else if(chg < 0) {
            self.priceLabel.textColor = RED;
            self.changeLabel.textColor = RED;
            self.chgpLabel.textColor = RED;
        }
        else {
            self.priceLabel.textColor = YELLOW;
            self.changeLabel.textColor = YELLOW;
            self.chgpLabel.textColor = YELLOW;
        }
        
        [self.table updateSummary:summary];
    }
}


// 1
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.nameLabel.text = @"";
    self.codeLabel.text = @"";
    self.priceLabel.text = @"";
    self.changeLabel.text = @"";
    self.chgpLabel.text = @"";
    
    self.table = [[SummaryTable alloc] initWithTableView:self.tableSummary];
    
    [self performSelector:@selector(viewInit) withObject:nil afterDelay:.1];


}

// Paham
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.unsubscribe = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 2
- (void)viewInit
{
    for(int n = 11; n <= 14; n ++) {
        UIButton *button = [self.view viewWithTag:n];
        [button setTitleFont:[FONT_TITLE_DEFAULT_BUTTON fontWithSize:14]];
    }
    
    [self.buyButton setBackgroundImage:buttonGreen forState:UIControlStateNormal];
    [self.buyButton setTitleColor:COLOR_TITLE_WHITE_BUTTON forState:UIControlStateNormal];
    [self.buyButton setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
    [self.buyButton setTitleColor:COLOR_TITLE_WHITE_BUTTON forState:UIControlStateSelected];
    [self.buyButton setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateSelected];
    [self.buyButton setTitleFont:[FONT_TITLE_DEFAULT_BUTTON fontWithSize:14]];
    
    [self.sellButton setBackgroundImage:buttonRed forState:UIControlStateNormal];
    [self.sellButton setTitleColor:COLOR_TITLE_WHITE_BUTTON forState:UIControlStateNormal];
    [self.sellButton setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
    [self.sellButton setTitleColor:COLOR_TITLE_WHITE_BUTTON forState:UIControlStateSelected];
    [self.sellButton setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateSelected];
    [self.sellButton setTitleFont:[FONT_TITLE_DEFAULT_BUTTON fontWithSize:14]];
}

- (void)callback
{
    //__weak typeof(self) theSelf = self;
    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
            }
            else if(record.recordType == RecordTypeKiStockSummary) {
                if(self.summary) {
                    for(KiStockSummary *summary in record.stockSummary) {
                        if(summary.codeId == self.summary.codeId) {
                            [self updateSummary:summary];
                        }
                    }
                }
            }
            else if(record.recordType == RecordTypeStockHistory) {
                [self updateChart:record.stockHistory];
            }
//            else if(record.recordType == RecordTypeLevel2) {
//                [self updateLevel2:record.level2];
//            }
//            else if(record.recordType == RecordTypeLevel3) {
//                [self updateLevel3:record.level3];
//            }
//            else if(record.recordType == RecordTypeKiLastTrade) {
//                [self updateTrade:record.lastTrade];
//            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
