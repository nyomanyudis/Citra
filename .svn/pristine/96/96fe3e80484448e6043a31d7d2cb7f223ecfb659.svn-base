//
//  WatchListViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/4/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "WatchListViewController.h"
#import "AppDelegate.h"
#import "AddRemoveWatchListViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "UIButton+Customized.h"
#import "ImageResources.h"
#import "UIColor+ColorStyle.h"
#import "NSString+StringAdditions.h"
#import "Logger.h"


@interface WatchListViewController () <AddRemoveWatchListDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray *watchList;
@property (nonatomic) NSNumberFormatter *formatter2comma;


@end

//static NSMutableArray *watchList;

@implementation WatchListViewController
{
    BOOL showChg;
}

@synthesize homeBarItem, backBarItem;
@synthesize addRemoveButton, detailview, nameLabel, openLabel, hiLabel, loLabel, volLabel, peLabel, capLabel, hi52Label, lo52Label, avgLabel, yieldLabel;
@synthesize tableview;
@synthesize watchList;

- (void)backBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"##WATCHLIST %@", watchList);
    [tableview reloadData];
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    logDebug(@"WATCHLIST -END");
}

- (void)viewDidLoad
{
    NSLog(@"init watchlist");
    [super viewDidLoad];
    logDebug(@"WATCHLIST");
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
    showChg = YES;
    
    detailview.layer.cornerRadius = 10.0f;
    
    [addRemoveButton BlackBackgroundCustomized];
    [addRemoveButton addTarget:self action:@selector(addRemoveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    if(nil == watchList)
        watchList = [NSMutableArray array];
    
//    if (watchList.count == 0) {
//        for (NSString *code in [[DBLite sharedInstance] getWatchlistArray]) {
//            logDebug([NSString stringWithFormat:@"ADD CODE STARTUP: %@", code]);
//            [self insertStock:code];
//        }
//    }
    
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.allowsSelection = YES;
    
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    [self performSelector:@selector(loadWatchlist) withObject:nil afterDelay:0.1f];
}

- (void)loadWatchlist
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (watchList.count <= 0) {
            for (NSString *code in [[DBLite sharedInstance] getWatchlistArray]) {
                logDebug([NSString stringWithFormat:@"ADD CODE STARTUP: %@", code]);
                [self insertStock:code];
                [tableview reloadData];
            }
        }
    });
}

- (void)addRemoveButtonClicked
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    
    AddRemoveWatchListViewController *c = [[AddRemoveWatchListViewController alloc] initWithNibName:@"AddRemoveWatchListViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self.previouseController];
    [c watchListController:self];
    c.delegate = self;
    [self presentViewController:c animated:YES completion:nil];
}

- (void)insertStock:(NSString *)code
{
    NSLog(@"(void)insertStock:(NSString *)code %@", code);
    Board b = BoardRg;
    if ([code containsString:@".TN"]) {
        b = BoardTn;
    }
    else if ([code containsString:@".NG"]) {
        b = BoardNg;
    }

    NSRange rng = [code rangeOfString:@"." options:0];
    if (rng.length > 0) { //found
        code = [code substringToIndex:rng.location];
    }

    //NSLog(@"##INSERT CODE %@ BOARD %u", code, b);
    KiStockSummary *s = [[DBLite sharedInstance] getStockSummaryByStock:code andBoard:b];
    if (nil != s) {
        [watchList addObject:s];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    logDebug(@"WATCHLIST -DONE");
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setAddRemoveButton:nil];
    [self setNameLabel:nil];
    [self setOpenLabel:nil];
    [self setHiLabel:nil];
    [self setLoLabel:nil];
    [self setVolLabel:nil];
    [self setPeLabel:nil];
    [self setCapLabel:nil];
    [self setHi52Label:nil];
    [self setLo52Label:nil];
    [self setAvgLabel:nil];
    [self setYieldLabel:nil];
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
    else if(RecordTypeKiStockSummary == rec.recordType) {
        [self updateWatchlist:rec.stockSummary];
    }
}

- (void)updateWatchlist:(NSArray *)arrayStockSummary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL reload = NO;
        for(KiStockSummary *kiStockSummary in arrayStockSummary) {
            
            for(int n = 0; n < watchList.count; n ++) {
                NSObject *obj = [watchList objectAtIndex:n];
                
                if ([obj isKindOfClass:[KiStockSummary class]]) {
                    KiStockSummary *s = (KiStockSummary *)obj;
                    if(s.codeId == kiStockSummary.codeId && s.stockSummary.board == kiStockSummary.stockSummary.board) {
                        logDebug(@"UPDATE WATCHLIST");
                        
                        [watchList replaceObjectAtIndex:n withObject:kiStockSummary];
                        reload = YES;
                        
                        //NSLog(@"buka sekarang");
                        
                        //break;
                    }
                }
            }

        }
                
        
        if(reload)
            [tableview reloadData];
        else if(watchList.count == 0)
            [self performSelector:@selector(loadWatchlist) withObject:nil afterDelay:0.1f];
    });
}




#pragma mark
#pragma AddRemoveWatchListDelegate
//- (void)insertStock:(NSString *)code
//{
//    NSLog(@"(void)insertStock:(NSString *)code %@", code);
//    Board b = BoardRg;
//    if ([code containsString:@".TN"]) {
//        b = BoardTn;
//    }
//    else if ([code containsString:@".NG"]) {
//        b = BoardNg;
//    }
//    
//    NSRange rng = [code rangeOfString:@"." options:0];
//    if (rng.length > 0) { //found
//        code = [code substringToIndex:rng.location];
//    }
//    
//    //NSLog(@"##INSERT CODE %@ BOARD %u", code, b);
//    KiStockSummary *s = [[DBLite sharedInstance] getStockSummaryByStock:code andBoard:b];
//    if (nil != s) {
//        [watchList addObject:s];
//    }
//}
//
//- (void)deleteStock:(NSString *)code board:(Board)b
//{
//    
//    NSLog(@"(void)deleteStock:(NSString *)code board:(Board)b %@", code);
//        //NSLog(@"##DELETE CODE %@ BOARD %u", code, b);
//        KiStockSummary *s = [[DBLite sharedInstance] getStockSummaryByStock:code andBoard:b];
//        @try {
//            [watchList removeObject:s];
//        }
//        @catch (NSException *exception) {
//            //NSLog(@"##%s %@", __PRETTY_FUNCTION__, exception);
//        }
//    
//    
////    if (nil != s) {
////        [watchList removeObject:s];
////    }
//}

- (void)updateStocks:(NSArray *)stocks
{
    NSLog(@"(void)updateStocks:(NSArray *)stocks");
    [watchList removeAllObjects];
    
    for (AddRemoveStockCell *cell in stocks) {
        //NSLog(@"## CODE %@ BOARD %u", cell.codeLabel.text, cell.board);
        logDebug([NSString stringWithFormat:@"UPDATE STOCK: %@", cell.codeLabel.text]);
        KiStockSummary *s = [[DBLite sharedInstance] getStockSummaryByStock:cell.codeLabel.text andBoard:cell.board];
        if (nil != s) {
            [watchList addObject:s];
        }
    }
    
    [tableview reloadData];
}

- (void)chgButtonClicked
{
    showChg = !showChg;
    [tableview reloadData];
}


#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return watchList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(nil == cell) {
        cell = [[WatchListCell alloc] init];
    }
    
    NSObject *obj = [watchList objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[KiStockSummary class]]) {
        KiStockSummary *s = (KiStockSummary *)obj;
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        
        logDebug([NSString stringWithFormat:@"RENDER STOCK: %@ CODE: %d", d.code, d.id]);
        
        cell.codeLabel.text = s.stockSummary.board == BoardRg ? d.code : s.stockSummary.board == BoardTn ? CONCAT(d.code, @".TN") : CONCAT(d.code, @".NG");
        cell.codeLabel.textColor = [UIColor colorWithHexString:d.color];
        cell.priceLabel.text = currencyString([NSNumber numberWithFloat:s.stockSummary.ohlc.close]);
        cell.prevLabel.text = currencyString([NSNumber numberWithFloat:s.stockSummary.previousPrice]);
        
        if(NO == showChg) {
            float chgp = chgprcnt(s.stockSummary.change, s.stockSummary.previousPrice);
            [cell.chgLabel setTitle:[NSString stringWithFormat:@"%.2f%%", chgp] forState:UIControlStateNormal];
            [cell.chgLabel setTitle:[NSString stringWithFormat:@"%.2f%%", chgp] forState:UIControlStateHighlighted];
        }
        else {
            [cell.chgLabel setTitle:currencyString([NSNumber numberWithFloat:s.stockSummary.change]) forState:UIControlStateNormal];
            [cell.chgLabel setTitle:currencyString([NSNumber numberWithFloat:s.stockSummary.change]) forState:UIControlStateHighlighted];
        }
        
        cell.chgLabel.tag = indexPath.row;
        [cell.chgLabel addTarget:self action:@selector(chgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        if(s.stockSummary.change > 0) {
            cell.priceLabel.textColor = GREEN;
            [cell.chgLabel GreenBackgroundCustomized];
        }
        else if(s.stockSummary.change < 0) {
            cell.priceLabel.textColor = red;
            [cell.chgLabel OrangeBackgroundCustomized];
        }
        else {
            cell.priceLabel.textColor = yellow;
            [cell.chgLabel BlackBackgroundCustomized];
        }

    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:167.0/255.0 green:152.0/255.0 blue:101.0/255.0 alpha:1.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [watchList objectAtIndex:indexPath.row];
    if(nil != obj && [obj isKindOfClass:[KiStockSummary class]]) {
        KiStockSummary *s = (KiStockSummary*) obj;
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        
        WatchListCell *cellHighlighted = (WatchListCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (nil != cellHighlighted) {
            cellHighlighted.codeLabel.textColor = [UIColor colorWithHexString:d.color];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [watchList objectAtIndex:indexPath.row];
    if(nil != obj && [obj isKindOfClass:[KiStockSummary class]]) {
        
        KiStockSummary *s = (KiStockSummary *)obj;
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        nameLabel.text = d.name;
        
        WatchListCell *cellHighlighted = (WatchListCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (nil != cellHighlighted) {
            cellHighlighted.codeLabel.textColor = white;
        }

        float chgp = chgprcnt(s.stockSummary.change, s.stockSummary.previousPrice);
        
        openLabel.text = currencyStringFromInt(s.stockSummary.ohlc.open);
        hiLabel.text = currencyStringFromInt(s.stockSummary.ohlc.high);
        loLabel.text = currencyStringFromInt(s.stockSummary.ohlc.low);
        volLabel.text = currencyStringFromInt(s.stockSummary.change);
        //peLabel.text = currencyString([NSNumber numberWithFloat:chgp]);
        peLabel.text = currencyStringWithFormat([NSNumber numberWithFloat:chgp], self.formatter2comma);
        
        
        if (s.stockSummary.tradedValue >= 1000000) {
            //yieldLabel.text = currencyRoundedWithFloat(s.stockSummary.tradedValue);
            yieldLabel.text = currencyRoundedWithFloatWithFormat(s.stockSummary.tradedValue, self.formatter2comma);
        }
        else {
            //yieldLabel.text = currencyString([NSNumber numberWithFloat:s.stockSummary.tradedValue]);
            yieldLabel.text = currencyStringWithFormat([NSNumber numberWithFloat:s.stockSummary.tradedValue], self.formatter2comma);
        }
        if(s.stockSummary.tradedVolume >= 1000000) {
            //capLabel.text = currencyRoundedWithFloat(s.stockSummary.tradedVolume);
            capLabel.text = currencyRoundedWithFloatWithFormat(s.stockSummary.tradedVolume, self.formatter2comma);
        }
        else {
            //capLabel.text = currencyString([NSNumber numberWithFloat:s.stockSummary.tradedVolume]);
            capLabel.text = currencyStringWithFormat([NSNumber numberWithFloat:s.stockSummary.tradedVolume], self.formatter2comma);
        }
        
        if(s.stockSummary.tradedVolume > 0) {
            avgLabel.text = currencyString([NSNumber numberWithFloat:(s.stockSummary.tradedValue/s.stockSummary.tradedVolume)]);
        }
        else {
            avgLabel.text = [NSString stringWithFormat:@"0"];
        }
        
        if (s.stockSummary.previousPrice > s.stockSummary.ohlc.open)
            openLabel.textColor = red;
        else if(s.stockSummary.previousPrice < s.stockSummary.ohlc.open)
            openLabel.textColor = GREEN;
        else
            openLabel.textColor = yellow;
        
        if (s.stockSummary.previousPrice > s.stockSummary.ohlc.high)
            hiLabel.textColor = red;
        else if(s.stockSummary.previousPrice < s.stockSummary.ohlc.high)
            hiLabel.textColor = GREEN;
        else
            hiLabel.textColor = yellow;
        
        if (s.stockSummary.previousPrice > s.stockSummary.ohlc.low)
            loLabel.textColor = red;
        else if(s.stockSummary.previousPrice < s.stockSummary.ohlc.low)
            loLabel.textColor = GREEN;
        else
            loLabel.textColor = yellow;

        if (s.stockSummary.change > 0) {
            volLabel.textColor = GREEN;//chg
            peLabel.textColor = GREEN;//chg%
        }
        else if (s.stockSummary.change < 0) {
            volLabel.textColor = red;
            peLabel.textColor = red;
        }
        else {
            volLabel.textColor = yellow;
            peLabel.textColor = yellow;
        }
    }
    else if(nil != obj && [obj isKindOfClass:[KiStockData class]]) {
        KiStockData *d = (KiStockData *)obj;
        nameLabel.text = d.name;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WatchListCell *cell = [[WatchListCell alloc] init];
    [cell.chgLabel setBackgroundImage:nil forState:UIControlStateNormal];
    [cell.chgLabel setBackgroundImage:nil forState:UIControlStateHighlighted];
    return cell;
}

@end






@implementation WatchListCell

@synthesize codeLabel, priceLabel, chgLabel, prevLabel;
@synthesize kiStockSummary, kiStockData;

- (id)init
{
    if(self = [super init]) {
        codeLabel = labelOnTable(CGRectMake(3, 10, 80, 21));
        prevLabel = labelOnTable(CGRectMake(85, 10, 65, 21));
        priceLabel = labelOnTable(CGRectMake(155, 10, 65, 21));
        chgLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        chgLabel.frame = CGRectMake(225, 5, 85, 30);
        [chgLabel BlackBackgroundCustomized];
        
        codeLabel.text = @"Stock";
        priceLabel.text = @"Last";
        prevLabel.text = @"Previous";
        [chgLabel setTitle:@"Chg (Chg%)" forState:UIControlStateNormal];
        [chgLabel setTitle:@"Chg (Chg%)" forState:UIControlStateHighlighted];
        
        codeLabel.textAlignment = NSTextAlignmentLeft;
        
        [codeLabel setFont:[UIFont systemFontOfSize:14]];
        [priceLabel setFont:[UIFont systemFontOfSize:14]];
        [prevLabel setFont:[UIFont systemFontOfSize:14]];
        [chgLabel.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [chgLabel setTitleColor:white forState:UIControlStateNormal];
        chgLabel.userInteractionEnabled = YES;
        chgLabel.titleLabel.textAlignment = NSTextAlignmentRight;
        
        //self.selectionStyle = UITableViewCellSelectionStyleGray;
        prevLabel.adjustsFontSizeToFitWidth = YES;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundColor = black;
        
        [self addSubview:codeLabel];
        [self addSubview:prevLabel];
        [self addSubview:priceLabel];
        [self addSubview:chgLabel];
    }
    
    return self;
}

@end


