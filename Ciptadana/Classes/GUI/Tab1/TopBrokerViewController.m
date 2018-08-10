//
//  TopBrokerViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/25/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "ViewController.h"
#import "TopBrokerViewController.h"
#import "ImageResources.h"
#import "AppDelegate.h"
#import "AgentFeed.h"
#import "MLTableAlert.h"
#import "OrderListViewController.h"


#define white [UIColor whiteColor]
#define black [UIColor blackColor]
#define yellow [UIColor yellowColor]
#define magenta [UIColor magentaColor]


@interface TopBrokerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSNumberFormatter *formatter2comma;
@property (retain, nonatomic) UITopBrokerCell *cellHeader;
@property (assign, nonatomic) UIImage *imageUp, *imageDown;

@property (assign) uint sortBy;

@end

@implementation TopBrokerViewController
{
    NSArray *topBrokers;
    NSTimer *sortTimer;
    BOOL refresh;
}

@synthesize backBarItem, homeBarItem;
@synthesize tableview;
@synthesize formatter2comma;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    _imageUp = [UIImage imageNamed:@"arrow_up"];
    _imageDown = [UIImage imageNamed:@"arrow_down"];
    
    NSLog(@"image up: %@", _imageUp);
    NSLog(@"image down: %@", _imageDown);
    

    _cellHeader = [[UITopBrokerCell alloc] init];
    _cellHeader.roundImage = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 10, _imageDown.size.width, _imageDown.size.height)];
    _cellHeader.roundImage.image = _imageDown;
    
    [_cellHeader addSubview:_cellHeader.roundImage];
    
    // poisisi panah k bawah
    CGSize expectedSize = [_cellHeader.bkLabel.text sizeWithFont:_cellHeader.bkLabel.font];
    uint expectedPos = expectedSize.width + _cellHeader.bkLabel.frame.origin.x + 5;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, 1, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);

    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
    refresh = YES;
    [self sortBroker];
    
    sortTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(sortBroker) userInfo:nil repeats:YES];
    
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    _sortBy = 1;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setHomeBarItem:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

- (void)sortBroker
{
    if (refresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            refresh = NO;
            //topBrokers = [[DBLite sharedInstance] getBrokerSummariesByTVal:[[DBLite sharedInstance] getBrokerSummaries]];
            
            if(1 == _sortBy || (1 ^ 0xff) == _sortBy)
                [self sortByBK];
            else if(2 == _sortBy || (2 ^ 0xff) == _sortBy)
                [self sortByVal];
            else if(3 == _sortBy || (3 ^ 0xff) == _sortBy)
                [self sortByVol];
            else if(4 == _sortBy || (4 ^ 0xff) == _sortBy)
                [self sortByFreq];
            
            //[tableview reloadData];
        });
    }
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
    }
    else if (RecordTypeBrokerSummary == rec.recordType) {
        refresh = YES;
    }
}

#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (nil == topBrokers)
        return 0;
    if (topBrokers.count > 50)
        return 50;

    return  topBrokers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITopBrokerCell *cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(nil == cell)
        cell = [[UITopBrokerCell alloc] init];
    
    
    Transaction *t = [topBrokers objectAtIndex:indexPath.row];
    Transaction *RG = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardRg];
    Transaction *TN = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardTn];
    Transaction *NG = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardNg];
    
    float ValRG = 0, ValTN = 0, ValNG = 0;
    float VolRG = 0, VolTN = 0, VolNG = 0;
    float freqRG = 0, freqTN = 0, freqNG = 0;
    
    
    if(nil != RG) {
        ValRG = RG.buy.value + RG.sell.value;
        VolRG = RG.buy.volume + RG.sell.volume;
        freqRG = RG.buy.frequency + RG.sell.frequency;
    }
    if(nil != TN) {
        ValTN = TN.buy.value + TN.sell.value;
        VolTN = TN.buy.volume + TN.sell.volume;
        freqTN = TN.buy.frequency + TN.sell.frequency;
    }
    if(nil != NG) {
        ValNG = NG.buy.value + NG.sell.value;
        VolNG = NG.buy.volume + NG.sell.volume;
        freqNG = NG.buy.frequency + NG.sell.frequency;
    }
    
    cell.freqLabel.text = currencyString([NSNumber numberWithFloat:(freqNG + freqRG + freqTN)]);
    cell.volumeLabel.text = currencyRoundedWithFloatWithFormat(VolNG + VolRG + VolTN, formatter2comma);
    cell.totalLabel.text = currencyRoundedWithFloatWithFormat(ValNG + ValRG + ValTN, formatter2comma);

    KiBrokerData *data = [[DBLite sharedInstance] getBrokerDataById:t.codeId];

    cell.noLabel.text = [NSString stringWithFormat:@"%i", (uint)indexPath.row + 1];
    cell.bkLabel.text = data.code;
    
    cell.bkLabel.textColor = data.type == InvestorTypeD ?  white : magenta;
    cell.freqLabel.textColor = data.type == InvestorTypeD ?  white : magenta;
    cell.volumeLabel.textColor = data.type == InvestorTypeD ?  white : magenta;
    cell.totalLabel.textColor = data.type == InvestorTypeD ?  white : magenta;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Transaction *t = [topBrokers objectAtIndex:indexPath.row];
    Transaction *RG = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardRg];
    Transaction *TN = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardTn];
    Transaction *NG = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardNg];
    
    KiBrokerData *data = [[DBLite sharedInstance] getBrokerDataById:t.codeId];
    
    float ValRG = 0, ValTN = 0, ValNG = 0;
    float VolRG = 0, VolTN = 0, VolNG = 0;
    float freqRG = 0, freqTN = 0, freqNG = 0;
    
    
    if(nil != RG) {
        ValRG = RG.buy.value + RG.sell.value;
        VolRG = RG.buy.volume + RG.sell.volume;
        freqRG = RG.buy.frequency + RG.sell.frequency;
    }
    if(nil != TN) {
        ValTN = TN.buy.value + TN.sell.value;
        VolTN = TN.buy.volume + TN.sell.volume;
        freqTN = TN.buy.frequency + TN.sell.frequency;
    }
    if(nil != NG) {
        ValNG = NG.buy.value + NG.sell.value;
        VolNG = NG.buy.volume + NG.sell.volume;
        freqNG = NG.buy.frequency + NG.sell.frequency;
    }
    
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath){
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        cell.leftLabel.textColor = white;
        cell.leftLabel.backgroundColor = [UIColor clearColor];
        cell.sepLabel.backgroundColor = [UIColor clearColor];
        cell.rightLabel.backgroundColor = [UIColor clearColor];
        
        if (0 == indexPath.row) {
            cell.leftLabel.text = @"Code";
            cell.rightLabel.text = data.code;
        }
        else if (1 == indexPath.row) {
            cell.leftLabel.text = @"Name";
            cell.rightLabel.text = data.name;
        }
        else if (2 == indexPath.row ) {
            cell.leftLabel.text = @"Value";
            cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithFloat:(ValNG + ValRG + ValTN)]];
        }
        else if (3 == indexPath.row ) {
            cell.leftLabel.text = @"Volume";
            cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithFloat:(VolNG + VolRG + VolTN)]];
        }
        else if (4 == indexPath.row ) {
            cell.leftLabel.text = @"Freq";
            cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithFloat:(freqNG + freqRG + freqTN)]];
        }
        
        
        cell.rightLabel.textColor = data.type == InvestorTypeD ?  white : magenta;
        
        return cell;
    };
    
    MLTableAlert *alert = [[MLTableAlert alloc] initWithTitle:@"Top Broker Detail"
                                            cancelButtonTitle:@"Close"
                                                 numberOfRows:^NSInteger(NSInteger section) {
                                                     return 5;
                                                 }
                                                     andCells:cell
                                               andCellsHeight:^CGFloat(MLTableAlert *alert, NSIndexPath *indexPath) {
                                                   return 25;
                                               }
                           ];
    [alert show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    //if(nil == _cellHeader) {
//        _cellHeader = [[UITopBrokerCell alloc] init];
//        _cellHeader.roundImage = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 10, _imageDown.size.width, _imageDown.size.height)];
//        _cellHeader.roundImage.image = _imageDown;
//        
//        [_cellHeader addSubview:_cellHeader.roundImage];
//        
//        // poisisi panah k bawah
//        CGSize expectedSize = [_cellHeader.bkLabel.text sizeWithFont:_cellHeader.bkLabel.font];
//        uint expectedPos = expectedSize.width + _cellHeader.bkLabel.frame.origin.x + 5;
//        _cellHeader.roundImage.frame = CGRectMake(expectedPos, 1, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
    
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bkClicked:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(valClicked:)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(volClicked:)];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freqClicked:)];
        
        _cellHeader.bkLabel.userInteractionEnabled = YES;
        _cellHeader.totalLabel.userInteractionEnabled = YES;
        _cellHeader.volumeLabel.userInteractionEnabled = YES;
        _cellHeader.freqLabel.userInteractionEnabled = YES;
        
        [_cellHeader.bkLabel addGestureRecognizer:tap1];
        [_cellHeader.totalLabel addGestureRecognizer:tap2];
        [_cellHeader.volumeLabel addGestureRecognizer:tap3];
        [_cellHeader.freqLabel addGestureRecognizer:tap4];

    //}
    
    return _cellHeader;
}

- (void)bkClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(1 == _sortBy || (1 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 1;
    
    [self sortByBK];
    
    CGSize expectedSize = [_cellHeader.bkLabel.text sizeWithFont:_cellHeader.bkLabel.font];
    uint expectedPos = expectedSize.width + _cellHeader.bkLabel.frame.origin.x + 5;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)valClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(2 == _sortBy || (2 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 2;
    
    [self sortByVal];
    
    CGSize expectedSize = [_cellHeader.totalLabel.text sizeWithFont:_cellHeader.totalLabel.font];
    uint expectedPos = _cellHeader.totalLabel.frame.origin.x + _cellHeader.totalLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)volClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(3 == _sortBy || (3 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 3;
    
    [self sortByVol];
    
    CGSize expectedSize = [_cellHeader.volumeLabel.text sizeWithFont:_cellHeader.volumeLabel.font];
    uint expectedPos = _cellHeader.volumeLabel.frame.origin.x + _cellHeader.volumeLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)freqClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(4 == _sortBy || (4 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 4;
    
    [self sortByFreq];
    
    CGSize expectedSize = [_cellHeader.freqLabel.text sizeWithFont:_cellHeader.freqLabel.font];
    uint expectedPos = _cellHeader.freqLabel.frame.origin.x + _cellHeader.freqLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

#pragma mark
#pragma private sort
-(void) sortByBK
{
    BOOL ascending = YES;
    if((1 ^ 0xff) == _sortBy) {
        ascending = NO;
        _imageDown = [UIImage imageNamed:@"arrow_down"];
        _cellHeader.roundImage.image = _imageDown;
    }
    else {
        _imageUp = [UIImage imageNamed:@"arrow_up"];
        _cellHeader.roundImage.image = _imageUp;
    }
    
    NSArray *tmp = [[DBLite sharedInstance] getBrokerSummariesByTVal:[[DBLite sharedInstance] getBrokerSummaries]];
    if(nil != tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            KiBrokerData *b1 = [[DBLite sharedInstance] getBrokerDataById:a.codeId];
            KiBrokerData *b2 = [[DBLite sharedInstance] getBrokerDataById:b.codeId];
            
            if(!ascending) {
                NSComparisonResult result = [b1.code compare:b2.code];
                if (result == NSOrderedDescending) {
                    return NSOrderedAscending;
                }
                else if(result == NSOrderedAscending) {
                    return NSOrderedDescending;
                }
            }
            
            return ([b1.code compare:b2.code]);
        }];
        
        topBrokers = nil;
        topBrokers = sort;
        [tableview reloadData];
    }
}

-(void) sortByVal
{
    BOOL ascending = YES;
    if((2 ^ 0xff) == _sortBy) {
        ascending = NO;
        _imageDown = [UIImage imageNamed:@"arrow_down"];
        _cellHeader.roundImage.image = _imageDown;
    }
    else {
        _imageUp = [UIImage imageNamed:@"arrow_up"];
        _cellHeader.roundImage.image = _imageUp;
    }
    
    NSArray *tmp = [[DBLite sharedInstance] getBrokerSummariesByTVal:[[DBLite sharedInstance] getBrokerSummaries]];
    if(nil != tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            float ValRG = 0, ValTN = 0, ValNG = 0;
            
            
            if(nil != aRG) {
                ValRG = aRG.buy.value + aRG.sell.value;
            }
            if(nil != aTN) {
                ValTN = aTN.buy.value + aTN.sell.value;
            }
            if(nil != aNG) {
                ValNG = aNG.buy.value + aNG.sell.value;
            }
            
            float aVal = ValRG + ValTN + ValNG;
            
            Transaction *bRG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            ValRG = 0, ValTN = 0, ValNG = 0;
            
            if(nil != bRG) {
                ValRG = bRG.buy.value + bRG.sell.value;
            }
            if(nil != bTN) {
                ValTN = bTN.buy.value + bTN.sell.value;
            }
            if(nil != bNG) {
                ValNG = bNG.buy.value + bNG.sell.value;
            }
            
            float bVal = ValRG + ValTN + ValNG;
            
            if (ascending) {
                if (aVal > bVal)
                    return NSOrderedAscending;
                else if(aVal < bVal)
                    return NSOrderedDescending;
            }
            else {
                if (aVal < bVal)
                    return NSOrderedAscending;
                else if(aVal > bVal)
                    return NSOrderedDescending;
            }

            
            return NSOrderedSame;
        }];
        
        topBrokers = nil;
        topBrokers = sort;
        [tableview reloadData];
    }
}

-(void) sortByVol
{
    BOOL ascending = YES;
    if((3 ^ 0xff) == _sortBy) {
        ascending = NO;
        _imageDown = [UIImage imageNamed:@"arrow_down"];
        _cellHeader.roundImage.image = _imageDown;
    }
    else {
        _imageUp = [UIImage imageNamed:@"arrow_up"];
        _cellHeader.roundImage.image = _imageUp;
    }
    
    NSArray *tmp = [[DBLite sharedInstance] getBrokerSummariesByTVal:[[DBLite sharedInstance] getBrokerSummaries]];
    if(nil != tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            float VolRG = 0, VolTN = 0, VolNG = 0;
            
            
            if(nil != aRG) {
                VolRG = aRG.buy.volume + aRG.sell.volume;
            }
            if(nil != aTN) {
                VolTN = aTN.buy.volume + aTN.sell.volume;
            }
            if(nil != aNG) {
                VolNG = aNG.buy.volume + aNG.sell.volume;
            }
            
            float aVol = VolRG + VolTN + VolNG;
            
            Transaction *bRG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            VolRG = 0, VolTN = 0, VolNG = 0;
            
            if(nil != bRG) {
                VolRG = bRG.buy.volume + bRG.sell.volume;
            }
            if(nil != bTN) {
                VolTN = bTN.buy.volume + bTN.sell.volume;
            }
            if(nil != bNG) {
                VolNG = bNG.buy.volume + bNG.sell.volume;
            }
            
            float bVol = VolRG + VolTN + VolNG;
            
            if (ascending) {
                if (aVol > bVol)
                    return NSOrderedAscending;
                else if(aVol < bVol)
                    return NSOrderedDescending;
            }
            else {
                if (aVol < bVol)
                    return NSOrderedAscending;
                else if(aVol > bVol)
                    return NSOrderedDescending;
            }
            
            
            return NSOrderedSame;
        }];
        
        topBrokers = nil;
        topBrokers = sort;
        [tableview reloadData];
    }
}

-(void) sortByFreq
{
    BOOL ascending = YES;
    if((4 ^ 0xff) == _sortBy) {
        ascending = NO;
        _imageDown = [UIImage imageNamed:@"arrow_down"];
        _cellHeader.roundImage.image = _imageDown;
    }
    else {
        _imageUp = [UIImage imageNamed:@"arrow_up"];
        _cellHeader.roundImage.image = _imageUp;
    }
    
    NSArray *tmp = [[DBLite sharedInstance] getBrokerSummariesByTVal:[[DBLite sharedInstance] getBrokerSummaries]];
    if(nil != tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[DBLite sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            float FreqRG = 0, FreqTN = 0, FreqNG = 0;
            
            
            if(nil != aRG) {
                FreqRG = aRG.buy.frequency + aRG.sell.frequency;
            }
            if(nil != aTN) {
                FreqTN = aTN.buy.frequency + aTN.sell.frequency;
            }
            if(nil != aNG) {
                FreqNG = aNG.buy.frequency + aNG.sell.frequency;
            }
            
            float aFreq = FreqRG + FreqTN + FreqNG;
            
            Transaction *bRG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[DBLite sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            FreqRG = 0, FreqTN = 0, FreqNG = 0;
            
            if(nil != bRG) {
                FreqRG = bRG.buy.frequency + bRG.sell.frequency;
            }
            if(nil != bTN) {
                FreqTN = bTN.buy.frequency + bTN.sell.frequency;
            }
            if(nil != bNG) {
                FreqNG = bNG.buy.frequency + bNG.sell.frequency;
            }
            
            float bFreq = FreqRG + FreqTN + FreqNG;
            
            if (ascending) {
                if (aFreq > bFreq)
                    return NSOrderedAscending;
                else if(aFreq < bFreq)
                    return NSOrderedDescending;
            }
            else {
                if (aFreq < bFreq)
                    return NSOrderedAscending;
                else if(aFreq > bFreq)
                    return NSOrderedDescending;
            }
            
            
            return NSOrderedSame;
        }];
        
        topBrokers = nil;
        topBrokers = sort;
        [tableview reloadData];
    }
}

@end



@implementation UITopBrokerCell

@synthesize noLabel, bkLabel, freqLabel, volumeLabel, totalLabel;

- (id)init
{
    if(self = [super init]) {
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 25, 15)];
        bkLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 2, 30, 15)];
        
        totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 2, 70, 15)];
        volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 2, 85, 15)];
        freqLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 77, 15)];
        
        noLabel.textAlignment = NSTextAlignmentRight;
        bkLabel.textAlignment = NSTextAlignmentCenter;
        freqLabel.textAlignment = NSTextAlignmentRight;
        volumeLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.textAlignment = NSTextAlignmentRight;
        
        noLabel.textColor = white;
        bkLabel.textColor = white;
        freqLabel.textColor = white;
        volumeLabel.textColor = white;
        totalLabel.textColor = white;
        
        noLabel.backgroundColor = black;
        bkLabel.backgroundColor = black;
        freqLabel.backgroundColor = black;
        volumeLabel.backgroundColor = black;
        totalLabel.backgroundColor = black;
        self.backgroundColor = black;
        
        noLabel.font = [UIFont systemFontOfSize:14];
        bkLabel.font = [UIFont systemFontOfSize:14];
        freqLabel.font = [UIFont systemFontOfSize:14];
        volumeLabel.font = [UIFont systemFontOfSize:14];
        totalLabel.font = [UIFont systemFontOfSize:14];
        
        freqLabel.adjustsFontSizeToFitWidth = YES;
        volumeLabel.adjustsFontSizeToFitWidth = YES;
        totalLabel.adjustsFontSizeToFitWidth = YES;
        
        noLabel.text = @"No";
        bkLabel.text = @"BK";
        freqLabel.text = @"Freq";
        volumeLabel.text = @"Volume";
        totalLabel.text = @"Value";
        
        [self addSubview:noLabel];
        [self addSubview:bkLabel];
        [self addSubview:freqLabel];
        [self addSubview:volumeLabel];
        [self addSubview:totalLabel];

    }
    
    return self;
}

@end
