//
//  RunningTradeViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/25/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "RunningTradeViewController.h"
#import "ImageResources.h"
#import "Protocol.pb.h"
#import "AppDelegate.h"
#import "UIColor+ColorStyle.h"


static NSMutableArray *trades;
static int cursor;

@interface RunningTradeViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSNumberFormatter *timeFormatter;
@property NSNumberFormatter *formatter2comma;

@end

@implementation RunningTradeViewController
{
    int maxrow;
}

@synthesize backBarItem, homeBarItem;
@synthesize tableview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    [[AgentFeed sharedInstance] subscribe:RecordTypeKiTrade status:RequestSubscribe];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    if(nil == trades) {
        trades = [NSMutableArray array];
        cursor = 0;
    }
    
    _formatter2comma = [[NSNumberFormatter alloc] init];
    [_formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [_formatter2comma setMaximumFractionDigits:2];
    [_formatter2comma setMinimumFractionDigits:2];
    [_formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [_formatter2comma setDecimalSeparator:@"."];
    [_formatter2comma setGroupingSeparator:@","];
    [_formatter2comma setAllowsFloats:YES];
    
    _timeFormatter = [[NSNumberFormatter alloc] init];
    _timeFormatter.positiveFormat = @"##:##:##";
    
    maxrow = (tableview.frame.size.height - 20 - 64 ) / 20;
    
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
}

- (void)backBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] unsubscribe:RecordTypeKiTrade];

    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)homeBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] unsubscribe:RecordTypeKiTrade];
    
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
    }
    else if(RecordTypeKiTrade == rec.recordType) {
        [self updateRunningTrade:rec.trade];
    }
}

- (void)updateRunningTrade:(NSArray *)arrayTrade
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(cursor >= maxrow - 1) {
            cursor = 0;
        }
        
        cursor += arrayTrade.count;
        
        //[trades addObjectsFromArray:arrayTrade];
        [trades insertObjects:arrayTrade atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arrayTrade.count)]];
        
        if(trades.count > maxrow) {
            [trades removeObjectsInRange:NSMakeRange(maxrow, trades.count - maxrow)];
        }
        
        [tableview reloadData];

    });
}


#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return trades.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RunningTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RunningTradeCell"];
    
    if(nil == cell)
        cell = [[RunningTradeCell alloc] init];
    
    DBLite *db = [DBLite sharedInstance];
    
    KiTrade *p = [trades objectAtIndex:indexPath.row];
    KiBrokerData *b = [db getBrokerDataById:p.buyerBrokerId];
    KiBrokerData *s = [db getBrokerDataById:p.sellerBrokerId];
    KiStockData *stock = [db getStockDataById:p.codeId];
    
    float chg = p.trade.price - p.previous;
    float chgp = (chg * 100) / p.previous;
    
    
    uint time = p.trade.tradeTime;
    
    uint seconds = time % 100;
    time = (time - seconds) / 100;
    uint minutes = time % 100;
    uint hours = (time - minutes) / 100;
    cell.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
    cell.stockLabel.text = stock.code;
    cell.buyerLabel.text = b.code;
    cell.sellerLabel.text = s.code;
    
    cell.lotLabel.text = currencyString([NSNumber numberWithInt:(p.trade.volume / [AgentTrade sharedInstance].shares)]);
    cell.priceLabel.text = currencyStringFromInt(p.trade.price);
    cell.chgLabel.text = [NSString stringWithFormat:@"%@ (%@)", currencyString([NSNumber numberWithFloat:chg]), [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
    
    cell.stockLabel.textColor = [UIColor colorWithHexString:stock.color];
    cell.buyerLabel.textColor = b.type == InvestorTypeD ? white : magenta;
    cell.sellerLabel.textColor = s.type == InvestorTypeD ? white : magenta;
    
    if(chg > 0) {
        cell.lotLabel.textColor = GREEN;
        cell.priceLabel.textColor = GREEN;
        cell.chgLabel.textColor = GREEN;
    }
    else if(chg < 0) {
        cell.lotLabel.textColor = red;
        cell.priceLabel.textColor = red;
        cell.chgLabel.textColor = red;
    }
    else {
        cell.lotLabel.textColor = yellow;
        cell.priceLabel.textColor = yellow;
        cell.chgLabel.textColor = yellow;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    RunningTradeCell *cell = [[RunningTradeCell alloc] init];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(cursor == indexPath.row) {
    //if(cursor <= indexPath.row) {
        cell.backgroundColor = grey;
        
        ((RunningTradeCell *) cell).timeLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).stockLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).buyerLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).sellerLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).lotLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).priceLabel.backgroundColor = grey;
        ((RunningTradeCell *) cell).chgLabel.backgroundColor = grey;
    }
}

@end





@implementation RunningTradeCell

@synthesize timeLabel;
@synthesize stockLabel;
@synthesize buyerLabel;
@synthesize sellerLabel;
@synthesize lotLabel;
@synthesize priceLabel;
@synthesize chgLabel;

- (id)init {
    
    if(self = [super init]) {
//        timeLabel   = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 47, 15)];
//        stockLabel  = [[UILabel alloc] initWithFrame:CGRectMake(52, 2, 80, 15)];
//        buyerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(130, 2, 32, 15)];
//        sellerLabel = [[UILabel alloc] initWithFrame:CGRectMake(171, 2, 32, 15)];
//        lotLabel    = [[UILabel alloc] initWithFrame:CGRectMake(204, 2, 40, 15)];
//        priceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(244, 2, 40, 15)];
//        chgLabel    = [[UILabel alloc] initWithFrame:CGRectMake(284, 2, 35, 15)];
        
        timeLabel   = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 47, 15)];
        stockLabel  = [[UILabel alloc] initWithFrame:CGRectMake(52, 2, 55, 15)];
        buyerLabel  = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 30, 15)];
        sellerLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 2, 30, 15)];
        lotLabel    = [[UILabel alloc] initWithFrame:CGRectMake(166, 2, 40, 15)];
        priceLabel  = [[UILabel alloc] initWithFrame:CGRectMake(209, 2, 40, 15)];
        chgLabel    = [[UILabel alloc] initWithFrame:CGRectMake(252, 2, 65, 15)];
        
        timeLabel.adjustsFontSizeToFitWidth = YES;
        lotLabel.adjustsFontSizeToFitWidth = YES;
        stockLabel.adjustsFontSizeToFitWidth = YES;
        chgLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        buyerLabel.textAlignment = NSTextAlignmentCenter;
        sellerLabel.textAlignment = NSTextAlignmentCenter;
        lotLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textAlignment = NSTextAlignmentRight;
        chgLabel.textAlignment = NSTextAlignmentRight;
        
        timeLabel.textColor = white;
        stockLabel.textColor = white;
        buyerLabel.textColor = white;
        sellerLabel.textColor = white;
        lotLabel.textColor = white;
        priceLabel.textColor = white;
        chgLabel.textColor = white;
        
        timeLabel.backgroundColor = black;
        stockLabel.backgroundColor = black;
        buyerLabel.backgroundColor = black;
        sellerLabel.backgroundColor = black;
        lotLabel.backgroundColor = black;
        priceLabel.backgroundColor = black;
        chgLabel.backgroundColor = black;
        self.backgroundColor = black;
        
        timeLabel.font = [UIFont systemFontOfSize:12];
        stockLabel.font = [UIFont systemFontOfSize:12];
        buyerLabel.font = [UIFont systemFontOfSize:12];
        sellerLabel.font = [UIFont systemFontOfSize:12];
        lotLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.font = [UIFont systemFontOfSize:12];
        chgLabel.font = [UIFont systemFontOfSize:12];
        
        timeLabel.text = @"Time";
        stockLabel.text = @"Stock";
        buyerLabel.text = @"B";
        sellerLabel.text = @"S";
        lotLabel.text = @"Lot";
        priceLabel.text = @"Price";
        chgLabel.text = @"Chg (%)";
        
        [self addSubview:timeLabel];
        [self addSubview:stockLabel];
        [self addSubview:buyerLabel];
        [self addSubview:sellerLabel];
        [self addSubview:lotLabel];
        [self addSubview:priceLabel];
        [self addSubview:chgLabel];
    }
    
    return self;
}

@end
