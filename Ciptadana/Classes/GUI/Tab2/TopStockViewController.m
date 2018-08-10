//
//  TopStockViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/2/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "TopStockViewController.h"
#import "AppDelegate.h"
#import "REMenu.h"
#import "ImageResources.h"

#define TOPSTOCKS @[@" Top Gainer", @" Top Loser", @" Top Value", @" Most Active"]


@interface TopStockViewController () <UITableViewDelegate, UITableViewDataSource, UIDropListDelegate>

@property (weak, nonatomic) REMenu *menu;
@property (retain, nonatomic) UIHomeTopStockCell *headerCell;
@property (nonatomic) NSNumberFormatter *formatter;

@end


@implementation TopStockViewController
{
    CGRect menuRect;
    NSArray *stocks;
    
    NSInteger type;
    NSTimer *sortTimer;
    
    BOOL refresh;
}


@synthesize homeBarItem, backBarItem, titleBarItem, topstockButton;
@synthesize tableview;
@synthesize menu;


- (void)backBarItemClicked:(id)s
{
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] unsubscribeSecurityTopStock];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)homeBarItemClicked:(id)s
{
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] unsubscribeSecurityTopStock];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    if (nil != sortTimer) {
        [sortTimer invalidate];
        sortTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    self.formatter = [[NSNumberFormatter alloc] init];
    [self.formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter setDecimalSeparator:@"."];
    [self.formatter setGroupingSeparator:@","];
    [self.formatter setAllowsFloats:YES];
    
    _headerCell = [[UIHomeTopStockCell alloc] init];
    
    stocks = [[DBLite sharedInstance] getStockSummaryByChgPercent:[DBLite sharedInstance].getStockSummaries];
    type = 0;
    refresh = NO;

    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    
    sortTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sortStock) userInfo:nil repeats:YES];
    
    [topstockButton arrayList:TOPSTOCKS];
    topstockButton.dropDelegate = self;
}

- (void)reMenuClicked:(id)sender
{    
    if(menu.isOpen)
        return [menu close];
    
    [menu showFromRect:menuRect inView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setTitleBarItem:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

- (void)sortStock
{
    if (refresh) {
        NSArray *source ;
        if (1 == type) {
            self.headerCell.chgLabel.frame = CGRectMake(190, 0, 60, 20);
            self.headerCell.chgpLabel.frame = CGRectMake(260, 0, 60, 20);
            self.headerCell.chgLabel.text = @"Chg";
            self.headerCell.chgpLabel.text = @"%";
//            source = getTopStockArraykByChangePercentNegasi(getKiStockSummaryMutable().allValues);
            source = [[DBLite sharedInstance] getStockSummaryByChgPercentNegasi:[DBLite sharedInstance].getStockSummaries];
        }
        else if(2 == type) {
            self.headerCell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            self.headerCell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            self.headerCell.chgLabel.text = @"TVal";
            self.headerCell.chgpLabel.text = @"";
//            source = getTopStockArraykByValue(getKiStockSummaryMutable().allValues);
            source = [[DBLite sharedInstance] getStockSummaryByValue:[DBLite sharedInstance].getStockSummaries];
        }
        else if(3 == type) {
            self.headerCell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            self.headerCell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            self.headerCell.chgLabel.text = @"TFreq";
            self.headerCell.chgpLabel.text = @"";
//            source = getTopStockArraykByMostActive(getKiStockSummaryMutable().allValues);
            source = [[DBLite sharedInstance] getStockSummaryByFrequency:[DBLite sharedInstance].getStockSummaries];
        }
        else {
            self.headerCell.chgLabel.frame = CGRectMake(190, 0, 60, 20);
            self.headerCell.chgpLabel.frame = CGRectMake(260, 0, 60, 20);
            self.headerCell.chgLabel.text = @"Chg";
            self.headerCell.chgpLabel.text = @"%";
//            source = getTopStockArraykByChangePercent(getKiStockSummaryMutable().allValues);
            source = [[DBLite sharedInstance] getStockSummaryByChgPercent:[DBLite sharedInstance].getStockSummaries];
        }
        
        refresh = NO;
        stocks = source;
        [tableview reloadData];
    }
}




#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    if(index != type) {
        type = index;
        refresh = YES;
        [self sortStock];
    }
}




#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
        
        refresh = YES;
    }
}




#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil == stocks)
        return 0;
    if (stocks.count > 50)
        return 50;
    
    return stocks.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIHomeTopStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeTopStockCell"];
    
    if(nil == cell) {
        cell = [[UIHomeTopStockCell alloc] init];
    }
    
    KiStockSummary *p = [stocks objectAtIndex:indexPath.row];
    
    KiStockData *data = [[DBLite sharedInstance] getStockDataById:p.codeId];
    
    float chg = p.stockSummary.change;
    float chgp = 0;
    if(p.stockSummary.ohlc.close > 0)
        chgp = chgprcnt(chg, p.stockSummary.previousPrice);
    
    cell.noLabel.text = [NSString stringWithFormat:@"%i", (uint32_t)indexPath.row + 1 ];
    cell.stockLabel.text = [NSString stringWithFormat:@"%@", data.code];
    cell.lastLabel.text = currencyStringFromInt(p.stockSummary.ohlc.close);
    
    if (type == 0 || type == 1) {
        cell.chgLabel.frame = CGRectMake(190, 0, 60, 20);
        cell.chgpLabel.frame = CGRectMake(260, 0, 60, 20);
        cell.chgLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithFloat:chg]];//currencyString([NSNumber numberWithFloat:chg]);
        cell.chgpLabel.text = [NSString stringWithFormat:@"%.2f", chgp];
    }
    else if (type == 2){
        cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
        cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
        cell.chgLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithLongLong:p.stockSummary.tradedValue]];//currencyString([NSNumber numberWithFloat:p.stockSummary.tradedValue]);
        cell.chgpLabel.text = @"";
    }
    else if (type == 3){
        cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
        cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
        cell.chgLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithInt:p.stockSummary.tradedFrequency]];//currencyString([NSNumber numberWithFloat:p.stockSummary.tradedFrequency]);
        cell.chgpLabel.text = @"";
    }
    
    cell.stockLabel.textColor = [UIColor colorWithHexString:data.color];
    
    if(chg > 0) {
        cell.lastLabel.textColor = GREEN;
        cell.chgLabel.textColor = GREEN;
        cell.chgpLabel.textColor = GREEN;
    }
    else if(chg < 0) {
        cell.lastLabel.textColor = red;
        cell.chgLabel.textColor = red;
        cell.chgpLabel.textColor = red;
    }
    else {
        cell.lastLabel.textColor = yellow;
        cell.chgLabel.textColor = yellow;
        cell.chgpLabel.textColor = yellow;
    }
    
    return cell;
}
@end
