//
//  MarketSummaryViewController.m
//  Ciptadana
//
//  Created by Reyhan on 1/24/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "MarketSummaryViewController.h"
#import "ImageResources.h"
#import "AppDelegate.h"

@interface MarketSummaryViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSTimer *timer;

@property NSNumberFormatter *formatter2comma;

@end

@implementation MarketSummaryViewController


- (void)backBarItemClicked:(id)s
{
    if(nil != _timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    if(nil != _timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [_backBarItem setCustomView:backButton];
    [_homeBarItem setCustomView:homeButton];
    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    
    [self updateMarketSummary];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateMarketSummary) userInfo:nil repeats:YES];
}

- (void)updateMarketSummary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        KiIndices *indices = [[DBLite sharedInstance] getIndicesCode:@"COMPOSITE"];
        if (nil != indices)
            [self updateIndicesIHSG:@[indices]];
        
        [_tableview reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)formatter2Comma:(float)value
{
    if (value > 1000000000L || value < -1000000000L) {
        return [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(value / 1000000000.0f)]]];
    }
    else if (value > 100000L || value < -100000L) {
        return [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(value / 100000.0f)]]];
    }
    else {
        return [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:value]];
    }
}



#pragma mark
#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(3 == section)
        return 3;
    
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketSummaryCell"];
    
    if(nil == cell)
        cell = [[MarketSummaryCell alloc] init];
    
    MarketSummary *summary = [AgentFeed sharedInstance].marketSummary;
    
    if (nil != summary) {
        DBLite *db = [DBLite sharedInstance];
        
        // D/F Summary
        if(3 == indexPath.section) {
            cell.freqLabel.adjustsFontSizeToFitWidth = YES;
            
            if(0 == indexPath.row ) {
                cell.typeLabel.text = @" Domestic";
                
                NSLog(@"Domesic");
                NSLog(@" BUY: %Lf", db.fdValue.d_buyvalue);
                NSLog(@"SELL: %Lf", db.fdValue.d_sellvalue);
                NSLog(@" NET: %Lf", (db.fdValue.d_buyvalue - db.fdValue.d_sellvalue));
                NSLog(@"_");
                
                cell.volLabel.text = [self formatter2Comma:db.fdValue.d_buyvalue];
                cell.freqLabel.text = [self formatter2Comma:db.fdValue.d_sellvalue];
                cell.valLabel.text = [self formatter2Comma:(db.fdValue.d_buyvalue - db.fdValue.d_sellvalue)];
            }
            else if(1 == indexPath.row ) {
                cell.typeLabel.text = @" Foreign";
                
                NSLog(@"Foreign");
                NSLog(@" BUY: %Lf", db.fdValue.f_buyvalue);
                NSLog(@"SELL: %Lf", db.fdValue.f_sellvalue);
                NSLog(@" NET: %Lf", (db.fdValue.f_buyvalue - db.fdValue.f_sellvalue));
                NSLog(@"_");
                
                cell.volLabel.text = [self formatter2Comma:db.fdValue.f_buyvalue];
                cell.freqLabel.text = [self formatter2Comma:db.fdValue.f_sellvalue];
                cell.valLabel.text = [self formatter2Comma:(db.fdValue.f_buyvalue - db.fdValue.f_sellvalue)];
            }
            else if(2 == indexPath.row ) {
                cell.typeLabel.text = @" Nett F/D";
                
                long double net_buy = db.fdValue.d_buyvalue - db.fdValue.f_buyvalue;
                long double net_sell = db.fdValue.d_sellvalue - db.fdValue.f_sellvalue;
                long double net = (fabsl(db.fdValue.d_buyvalue - db.fdValue.d_sellvalue)) - (fabsl(db.fdValue.f_buyvalue - db.fdValue.f_sellvalue));
                
                NSLog(@"Nett F/D");
                NSLog(@" BUY: %Lf", net_buy);
                NSLog(@"SELL: %Lf", net_sell);
                NSLog(@" NET: %Lf", net);
                NSLog(@"_");
                
                cell.volLabel.text = [self formatter2Comma:net_buy];
                cell.freqLabel.text = [self formatter2Comma:net_sell];
                cell.valLabel.text = [self formatter2Comma:net];
            }
        }
        else {
            if(0 == indexPath.row) {
                cell.typeLabel.text = @" Regular";
            }
            else if(1 == indexPath.row) {
                cell.typeLabel.text = @" Nego";
            }
            else if(2 == indexPath.row) {
                cell.typeLabel.text = @" Cash";
            }
            else if(3 == indexPath.row) {
                cell.typeLabel.text = @" Total";
            }
            
            // Security
            if(0 == indexPath.section) {
                if (0 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.stockRg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.stockRg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.stockRg.frequency];
                }
                else if (1 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.stockNg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.stockNg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.stockNg.frequency];
                }
                else if (2 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.stockTn.value];
                    cell.volLabel.text = [self formatter2Comma:summary.stockTn.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.stockTn.frequency];
                }
                else if (3 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:(summary.stockRg.value + summary.stockNg.value + summary.stockTn.value)];
                    cell.volLabel.text = [self formatter2Comma:(summary.stockRg.volume + summary.stockNg.volume + summary.stockTn.volume)];
                    cell.freqLabel.text = [self formatter2Comma:(summary.stockRg.frequency + summary.stockNg.frequency + summary.stockTn.frequency)];
                }
            }
            // Rights
            else if(1 == indexPath.section) {
                if (0 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.rightRg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.rightRg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.rightRg.frequency];
                }
                else if (1 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.rightNg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.rightNg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.rightNg.frequency];
                }
                else if (2 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.rightTn.value];
                    cell.volLabel.text = [self formatter2Comma:summary.rightTn.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.rightTn.frequency];
                }
                else if (3 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:(summary.rightRg.value + summary.rightNg.value + summary.rightTn.value)];
                    cell.volLabel.text = [self formatter2Comma:(summary.rightRg.volume + summary.rightNg.volume + summary.rightTn.volume)];
                    cell.freqLabel.text = [self formatter2Comma:(summary.rightRg.frequency + summary.rightNg.frequency + summary.rightTn.frequency)];
                }
                
            }
            // Warrant
            else if(2 == indexPath.section) {
                if (0 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.warantRg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.warantRg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.warantRg.frequency];
                }
                else if (1 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.warantNg.value];
                    cell.volLabel.text = [self formatter2Comma:summary.warantNg.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.warantNg.frequency];
                }
                else if (2 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:summary.warantTn.value];
                    cell.volLabel.text = [self formatter2Comma:summary.warantTn.volume];
                    cell.freqLabel.text = [self formatter2Comma:summary.warantTn.frequency];
                }
                else if (3 == indexPath.row) {
                    cell.valLabel.text = [self formatter2Comma:(summary.warantRg.value + summary.warantNg.value + summary.warantTn.value)];
                    cell.volLabel.text = [self formatter2Comma:(summary.warantRg.volume + summary.warantNg.volume + summary.warantTn.volume)];
                    cell.freqLabel.text = [self formatter2Comma:(summary.warantRg.frequency + summary.warantNg.frequency + summary.warantTn.frequency)];
                }
                
            }
        }
    }
    else {
        cell.volLabel.text = @"0";
        cell.freqLabel.text = @"0";
        cell.valLabel.text = @"0";
    }
    
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MarketSummaryCell *cell = [[MarketSummaryCell alloc] init];
    
    cell.backgroundColor = gold;
    cell.typeLabel.backgroundColor = gold;
    cell.volLabel.backgroundColor = gold;
    cell.freqLabel.backgroundColor = gold;
    cell.valLabel.backgroundColor = gold;
    cell.typeLabel.textColor = white;
    cell.volLabel.textColor = white;
    cell.freqLabel.textColor = white;
    cell.valLabel.textColor = white;
    
    cell.volLabel.text = @"Volume";
    cell.freqLabel.text = @"Freq";
    cell.valLabel.text = @"Value";
    
    if(0 == section)
        cell.typeLabel.text = @" Securities";
    else if(1 == section)
        cell.typeLabel.text = @" Rights";
    else if(2 == section)
        cell.typeLabel.text = @" Warrant";
    else if(3 == section) {
        cell.typeLabel.text = @" D/F Summary";
        cell.volLabel.text = @"B Value";
        cell.freqLabel.text = @"S Value";
        cell.valLabel.text = @"Nett";
    }
    
    return cell;
}

@end





@implementation MarketSummaryCell

- (id)init
{
    if(self = [super init]) {
        _typeLabel = labelOnTable(CGRectMake(0, 2, 66, 16));
        _volLabel = labelOnTable(CGRectMake(68, 2, 85, 16));
        _freqLabel = labelOnTable(CGRectMake(156, 2, 75, 16));
        _valLabel = labelOnTable(CGRectMake(233, 2, 85, 16));
        
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _volLabel.font = [UIFont systemFontOfSize:14];
        _freqLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.font = [UIFont systemFontOfSize:14];
        
        _typeLabel.adjustsFontSizeToFitWidth = YES;
        _volLabel.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundColor = black;
        
        [self addSubview:_typeLabel];
        [self addSubview:_volLabel];
        [self addSubview:_freqLabel];
        [self addSubview:_valLabel];
    }
    
    return self;
}

@end