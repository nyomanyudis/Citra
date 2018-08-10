//
//  NetBSByBrokerViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/27/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "NetBSByBrokerViewController.h"
#import "AppDelegate.h"
#import "UIButton+Customized.h"
#import "ImageResources.h"
#import "UIColor+ColorStyle.h"
#import "MLTableAlert.h"
#import "OrderListViewController.h"

#define total(buy, sell) buy + sell
#define net(buy, sell) buy - sell


@interface NetBSByBrokerViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property NetBSByBrokerCell *cellHeader;
@property uint sortBy;//1 = stock, 2 = tval, 3 = tlot, 4 nval, 5 = nlot
@property UIImage *imageUp, *imageDown;

@property NSMutableArray * arrayTransaction;

@property NSNumberFormatter *formatter2comma;

@property NSTimer *refreshTimer;
@property BOOL shouldRefresh;

@end


static KiBrokerData * kiBrokerData;
static NSMutableDictionary * dictionaryBroker;//untuk ngumpulin broker yg udh di query
static NSMutableDictionary * dictionaryTransaction;



@implementation NetBSByBrokerViewController
{
    BOOL request;
}

@synthesize backBarItem, homeBarItem;
@synthesize brokerTextField, kiLabel, regularButton, negoButton, cashButton, tableview;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[AgentFeed sharedInstance ] unsubscribe:RecordTypeBrokerNetbuysell];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    if (nil != _refreshTimer) {
        [_refreshTimer invalidate];
        _refreshTimer = nil;
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
    
    request = NO;
    _shouldRefresh = NO;
    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSort) userInfo:nil repeats:YES];
    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
//    [self tapGestureRecognizer];
    
    
    if(nil == dictionaryTransaction)
        dictionaryTransaction = [NSMutableDictionary dictionary];
    
    if(nil == dictionaryBroker)
        dictionaryBroker = [NSMutableDictionary dictionary];
    
    brokerTextField.delegate = self;
    brokerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    brokerTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    regularButton.selected = YES;
    negoButton.selected = YES;
    cashButton.selected = YES;
    
    [regularButton ButtonCheckbox];
    [negoButton ButtonCheckbox];
    [cashButton ButtonCheckbox];
    
    [regularButton addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
    [negoButton addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
    [cashButton addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchUpInside];
    
    if(nil != kiBrokerData) {
        kiLabel.text = kiBrokerData.name;
        kiLabel.textColor = kiBrokerData.type == InvestorTypeD ? white : magenta;
        
        if(nil != dictionaryTransaction)
            _arrayTransaction = [NSMutableArray arrayWithArray:dictionaryTransaction.allValues];
        
        [[AgentFeed sharedInstance] subscribe:RecordTypeBrokerNetbuysell status:RequestSubscribe code:kiBrokerData.code];
    }

    _sortBy = 1;
    
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    
}

- (void)checkbox:(id)sender
{
    UIButton *b = sender;
    if(b.selected)
        b.selected = NO;
    else
        b.selected = YES;

    [self filterArrayTransaction];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [brokerTextField resignFirstResponder];
}

- (void)backBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance ] unsubscribe:RecordTypeBrokerNetbuysell];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance ] unsubscribe:RecordTypeBrokerNetbuysell];
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
    [self setKiLabel:nil];
    [self setRegularButton:nil];
    [self setNegoButton:nil];
    [self setCashButton:nil];
    [self setBrokerTextField:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

- (void)requestBroker:(NSString *)broker
{
    kiBrokerData = nil;
    [dictionaryTransaction removeAllObjects];
    _arrayTransaction = nil;
    [tableview reloadData];
    
    if (nil != broker) {
        broker = broker.uppercaseString;
        brokerTextField.text = broker;
        kiLabel.text = @"";
        
        kiBrokerData = [[DBLite sharedInstance] getBrokerDataByCode:broker];
        kiLabel.text = kiBrokerData.name;
        kiLabel.textColor = kiBrokerData.type == InvestorTypeD ? white : magenta;
        
        if (nil != kiBrokerData) {
            [self.animIndicator startAnimating];
            
            
            NSMutableDictionary *dictionary = [dictionaryBroker objectForKey:broker];
            if(nil != dictionary) {
                [dictionaryTransaction removeAllObjects];
                dictionaryTransaction = nil;
                dictionaryTransaction = [NSMutableDictionary dictionaryWithObjects:dictionary.allValues forKeys:dictionary.allKeys];
                
                [self.animIndicator stopAnimating];
                [self filterArrayTransaction];
                
            }
            else {
                [dictionaryTransaction removeAllObjects];
                [self filterArrayTransaction];
            }
            
            [[AgentFeed sharedInstance] subscribe:RecordTypeBrokerNetbuysell status:RequestSubscribe code:broker];
        }

    }
}

- (void)filterArrayTransaction
{
    if(nil != dictionaryTransaction) {
        
        _arrayTransaction = nil;
        _arrayTransaction = [NSMutableArray array];
        
        for(Transaction2 *t2 in dictionaryTransaction.allValues) {
            
            Transaction2 *tmpT2 = [[Transaction2 alloc] init];
            tmpT2.codeId = t2.codeId;
            tmpT2.tlot = t2.tlot;
            tmpT2.tvalue = t2.tvalue;
            tmpT2.nlot = t2.nlot;
            tmpT2.nvalue = t2.nvalue;
            tmpT2.board = t2.board;
            
            if(regularButton.selected && tmpT2.board == BoardRg) {
                if (negoButton.selected) {
                    Transaction2 *trx2Ng = [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardNg]];
                    if (nil != trx2Ng) {
                        tmpT2.tvalue += trx2Ng.tvalue;
                        tmpT2.tlot += trx2Ng.tlot;
                        tmpT2.nvalue += trx2Ng.nvalue;
                        tmpT2.nlot += trx2Ng.nlot;
                    }
                }
                
                if (cashButton.selected) {
                    Transaction2 *trx2Tn = [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardTn]];
                    if (nil != trx2Tn) {
                        tmpT2.tvalue += trx2Tn.tvalue;
                        tmpT2.tlot += trx2Tn.tlot;
                        tmpT2.nvalue += trx2Tn.nvalue;
                        tmpT2.nlot += trx2Tn.nlot;
                    }
                }
                
                [_arrayTransaction addObject:tmpT2];
            }
            if(negoButton.selected && tmpT2.board == BoardNg) {
                if ((nil == [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardRg]] ) || !regularButton.selected) {
                    if (cashButton.selected) {
                        Transaction2 *trx2Tn = [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardTn]];
                        if (nil != trx2Tn) {
                            tmpT2.tvalue += trx2Tn.tvalue;
                            tmpT2.tlot += trx2Tn.tlot;
                            tmpT2.nvalue += trx2Tn.nvalue;
                            tmpT2.nlot += trx2Tn.nlot;
                        }
                    }
                    
                    [_arrayTransaction addObject:tmpT2];
                }
            }
            if(cashButton.selected && tmpT2.board == BoardTn) {
                if ((nil == [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardRg]] ) || !regularButton.selected) {
                    if (nil == [dictionaryTransaction objectForKey:[NSString stringWithFormat:@"%i-%u", tmpT2.codeId, BoardNg]] || !negoButton.selected) {
                        [_arrayTransaction addObject:tmpT2];
                    }
                }
            }
            
            if(1 == _sortBy || (1 ^ 0xff) == _sortBy) {
                [self sortByStock];
            }
            else if(2 == _sortBy || (2 ^ 0xff) == _sortBy) {
                [self sortByTval];
            }
            else if(3 == _sortBy || (3 ^ 0xff) == _sortBy) {
                [self sortByTlot];
            }
            else if(4 == _sortBy || (4 ^ 0xff) == _sortBy) {
                [self sortByNval];
            }
            else if(5 == _sortBy || (5 ^ 0xff) == _sortBy) {
                [self sortByNlot];
            }
        }
        
        [tableview reloadData];
    }
}

- (void)autoSort
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.shouldRefresh && nil != kiBrokerData) {
            self.shouldRefresh = NO;
            NSMutableDictionary *dictionary = [dictionaryBroker objectForKey:kiBrokerData.code];
            if(nil != dictionary) {
                [dictionaryTransaction removeAllObjects];
                dictionaryTransaction = nil;
                dictionaryTransaction = [NSMutableDictionary dictionaryWithObjects:dictionary.allValues forKeys:dictionary.allKeys];
                
                [self filterArrayTransaction];
                [self.animIndicator stopAnimating];
            }
        }
    });
}


#pragma mark
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [brokerTextField resignFirstResponder];
    [self requestBroker:brokerTextField.text.uppercaseString];
    textField.text = textField.text.uppercaseString;
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([@"" isEqualToString:string])
        return YES;
    
    if(textField.text.length >= 2)
        return NO;
    
    return YES;
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
    }
    else if(RecordTypeBrokerNetbuysell == rec.recordType) {
        [self updateNetbuysell:rec.brokerNetbuysell];
    }
}

- (void)updateNetbuysell:(NetBuySell *)nbs
{
    KiBrokerData *bk = [[DBLite sharedInstance] getBrokerDataById:nbs.codeId];

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.shouldRefresh = YES;
        
        BOOL same = NO;
        if (nil != kiBrokerData && kiBrokerData.id == nbs.codeId) {
            same = YES;
        }
        
        NSMutableDictionary *dictionary = [dictionaryBroker objectForKey:bk.code];
        if(nil == dictionary) {
            dictionary = [NSMutableDictionary dictionary];
            [dictionaryBroker setObject:dictionary forKey:bk.code];
        }
                
        for (Transaction *t in nbs.transaction) {
            
            id key = [NSString stringWithFormat:@"%i-%u", t.codeId, nbs.board];
            Transaction2 *trx2 = [dictionaryTransaction objectForKey:key];
            
            if (nil == trx2) {
                trx2 = [[Transaction2 alloc] initWithTransaction:t andBoard:nbs.board];
                
                if (same)
                    [dictionaryTransaction setObject:trx2 forKey:key];
            }
            else {
                trx2.tvalue = t.buy.value + t.sell.value;
                trx2.nvalue = t.buy.value - t.sell.value;
                trx2.tlot = t.buy.volume + t.sell.volume;
                trx2.nlot = t.buy.volume - t.sell.volume;
            }
            
            if (nil != trx2) {
                [dictionary setObject:trx2 forKey:key];
            }
        }
    });
    
}


#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil != _arrayTransaction)
        return  _arrayTransaction.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetBSByBrokerCell *cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(nil == cell)
        cell = [[NetBSByBrokerCell alloc] init];
    
    Transaction2 *t = [_arrayTransaction objectAtIndex:indexPath.row];
    KiStockData *d = [[DBLite sharedInstance] getStockDataById:t.codeId];
    
    cell.stockLabel.text = d.code;
    cell.stockLabel.textColor = [UIColor colorWithHexString:d.color];
    
    if (t.tvalue > 1000000000L || t.tvalue < -1000000000L) {
        cell.tvalLabel.text = [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(t.tvalue / 1000000000.0f)]]];
    }
    else if (t.tvalue > 1000000L || t.tvalue < -1000000L) {
        cell.tvalLabel.text = [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(t.tvalue / 1000000.0f)]]];
    }
    else {
        [_formatter2comma setMinimumFractionDigits:0];
        cell.tvalLabel.text = [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:t.tvalue]];
        [_formatter2comma setMinimumFractionDigits:2];
    }
    
    float tlot = t.tlot / [AgentTrade sharedInstance].shares;
    float nlot = t.nlot / [AgentTrade sharedInstance].shares;
    
    //tlot
    if(tlot >= 1000000)
        cell.tlotLabel.text = currencyRoundedWithFloat(tlot);
    else
        cell.tlotLabel.text = currencyString([NSNumber numberWithFloat:tlot]);
    //nlot
    if(nlot >= 1000000 || t.nlot <= -1000000)
        cell.nlotLabel.text = currencyRoundedWithFloat(ABS(nlot));
    else
        cell.nlotLabel.text = currencyString([NSNumber numberWithFloat:ABS(nlot)]);
    //nval
    if (t.nvalue > 1000000000L || t.nvalue < -1000000000L) {
        cell.nvalLabel.text = [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS((t.nvalue / 1000000000.0f))]]];
    }
    else if (t.nvalue > 1000000L || t.nvalue < -1000000L) {
        cell.nvalLabel.text = [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS((t.nvalue / 1000000.0f))]]];
    }
    else {
        [_formatter2comma setMinimumFractionDigits:0];
        cell.nvalLabel.text = [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS(t.nvalue)]];
        [_formatter2comma setMinimumFractionDigits:2];
    }
    
    if(t.nlot > 0) {
        cell.nvalLabel.textColor = GREEN;
        cell.nlotLabel.textColor = GREEN;
    }
    else if(t.nlot < 0) {
        cell.nvalLabel.textColor = red;
        cell.nlotLabel.textColor = red;
    }
    else {
        cell.nvalLabel.textColor = yellow;
        cell.nlotLabel.textColor = yellow;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row >= 0 && row < _arrayTransaction.count) {
        Transaction2 *t = [_arrayTransaction objectAtIndex:indexPath.row];
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:t.codeId];
        
        UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath){
            TxOrderCell *cell = [[TxOrderCell alloc] init];
            
            cell.leftLabel.textColor = white;
            cell.leftLabel.backgroundColor = [UIColor clearColor];
            cell.sepLabel.backgroundColor = [UIColor clearColor];
            cell.rightLabel.backgroundColor = [UIColor clearColor];
            
            if (0 == indexPath.row) {
                cell.leftLabel.text = @"Stock";
                cell.rightLabel.text = d.code;
                cell.rightLabel.textColor = [UIColor colorWithHexString:d.color];
            }
            else if (1 == indexPath.row) {
                cell.leftLabel.text = @"Name";
                cell.rightLabel.text = d.name;
                cell.rightLabel.textColor = [UIColor colorWithHexString:d.color];
            }
            else if (2 == indexPath.row) {
                cell.leftLabel.text = @"TVal";
                //                if (t.tvalue > 1000000000L || t.tvalue < -1000000000L) {
                //                    cell.rightLabel.text = [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(t.tvalue / 1000000000.0f)]]];
                //                }
                //                else if (t.tvalue > 1000000L || t.tvalue < -1000000L) {
                //                    cell.rightLabel.text = [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(t.tvalue / 1000000.0f)]]];
                //                }
                //                else {
                [_formatter2comma setMinimumFractionDigits:0];
                cell.rightLabel.text = [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:t.tvalue]];
                [_formatter2comma setMinimumFractionDigits:2];
                //                }
                cell.rightLabel.textColor = white;
            }
            else if (3 == indexPath.row) {
                cell.leftLabel.text = @"Tlot";
                if(t.tlot/100 >= 100000)
                    cell.rightLabel.text = currencyRoundedWithFloat(t.tlot/100);
                else
                    cell.rightLabel.text = currencyString([NSNumber numberWithFloat:t.tlot/100]);
                
                cell.rightLabel.textColor = white;
            }
            else if (4 == indexPath.row) {
                cell.leftLabel.text = @"NVal";
                //                if (t.nvalue > 1000000000L || t.nvalue < -1000000000L) {
                //                    cell.rightLabel.text = [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS((t.nvalue / 1000000000.0f))]]];
                //                }
                //                else if (t.nvalue > 1000000L || t.nvalue < -1000000L) {
                //                    cell.rightLabel.text = [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS((t.nvalue / 1000000.0f))]]];
                //                }
                //                else {
                [_formatter2comma setMinimumFractionDigits:0];
                cell.rightLabel.text = [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:ABS(t.nvalue)]];
                [_formatter2comma setMinimumFractionDigits:2];
                //                }
                
                cell.rightLabel.textColor = t.nlot > 0 ? GREEN : t.nlot < 0 ? red : yellow;
            }
            else if (5 == indexPath.row) {
                cell.leftLabel.text = @"Nlot";
                if(t.nlot/100 >= 100000 || t.nlot/100 <= -100000)
                    cell.rightLabel.text = currencyRoundedWithFloat(ABS(t.nlot/100));
                else
                    cell.rightLabel.text = currencyString([NSNumber numberWithFloat:ABS(t.nlot/100)]);
                
                
                cell.rightLabel.textColor = t.nlot > 0 ? GREEN : t.nlot < 0 ? red : yellow;
            }
            
            return  cell;
        };
        
        MLTableAlert *alert = [[MLTableAlert alloc] initWithTitle:@"Net B/S By Broker Detail"
                                                cancelButtonTitle:@"Close"
                                                     numberOfRows:^NSInteger(NSInteger section) {
                                                         return 6;
                                                     }
                                                         andCells:cell
                                                   andCellsHeight:^CGFloat(MLTableAlert *alert, NSIndexPath *indexPath) {
                                                       return 25;
                                                   }
                               ];
        [alert show];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (nil == _cellHeader) {
        _cellHeader = [[NetBSByBrokerCell alloc] init];
        _cellHeader.stockLabel.text = @"Stock";
        _cellHeader.tvalLabel.text = @"TVal";
        _cellHeader.tlotLabel.text = @"Tlot";
        _cellHeader.nvalLabel.text = @"NVal";
        _cellHeader.nlotLabel.text = @"NLot";
        
        _cellHeader.stockLabel.frame = CGRectMake(4, 2, 60, 30);
        _cellHeader.tvalLabel.frame = CGRectMake(68, 2, 60, 30);
        _cellHeader.tlotLabel.frame = CGRectMake(131, 2, 50, 30);
        _cellHeader.nvalLabel.frame = CGRectMake(184, 2, 75, 30);
        _cellHeader.nlotLabel.frame = CGRectMake(263, 2, 53, 30);
        
        _cellHeader.roundImage = [[UIImageView alloc] initWithFrame:CGRectMake(-20, 10, _imageDown.size.width, _imageDown.size.height)];
        _cellHeader.roundImage.image = _imageDown;
        
        [_cellHeader addSubview:_cellHeader.roundImage];
        
        // poisisi panah k bawah
        CGSize expectedSize = [_cellHeader.stockLabel.text sizeWithFont:_cellHeader.stockLabel.font];
        uint expectedPos = expectedSize.width + _cellHeader.stockLabel.frame.origin.x + 1;
        _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
        //
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stockClicked:)];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tvalClicked:)];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tlotClicked:)];
        UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nvalClicked:)];
        UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nlotClicked:)];
        
        _cellHeader.stockLabel.userInteractionEnabled = YES;
        _cellHeader.tvalLabel.userInteractionEnabled = YES;
        _cellHeader.tlotLabel.userInteractionEnabled = YES;
        _cellHeader.nvalLabel.userInteractionEnabled = YES;
        _cellHeader.nlotLabel.userInteractionEnabled = YES;
        
        [_cellHeader.stockLabel addGestureRecognizer:tap1];
        [_cellHeader.tvalLabel addGestureRecognizer:tap2];
        [_cellHeader.tlotLabel addGestureRecognizer:tap3];
        [_cellHeader.nvalLabel addGestureRecognizer:tap4];
        [_cellHeader.nlotLabel addGestureRecognizer:tap5];

    }
        
    return _cellHeader;
}

- (void)stockClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(1 == _sortBy || (1 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 1;
    
    [self sortByStock];
    
    CGSize expectedSize = [_cellHeader.stockLabel.text sizeWithFont:_cellHeader.stockLabel.font];
    uint expectedPos = expectedSize.width + _cellHeader.stockLabel.frame.origin.x + 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)tvalClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(2 == _sortBy || (2 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 2;
    
    [self sortByTval];
    
    CGSize expectedSize = [_cellHeader.tvalLabel.text sizeWithFont:_cellHeader.tvalLabel.font];
    uint expectedPos = _cellHeader.tvalLabel.frame.origin.x + _cellHeader.tvalLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)tlotClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(3 == _sortBy || (3 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 3;
    
    [self sortByTlot];
    
    CGSize expectedSize = [_cellHeader.tlotLabel.text sizeWithFont:_cellHeader.tlotLabel.font];
    uint expectedPos = _cellHeader.tlotLabel.frame.origin.x + _cellHeader.tlotLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)nvalClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(4 == _sortBy || (4 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 4;
    
    [self sortByNval];
    
    CGSize expectedSize = [_cellHeader.nvalLabel.text sizeWithFont:_cellHeader.nvalLabel.font];
    uint expectedPos = _cellHeader.nvalLabel.frame.origin.x + _cellHeader.nvalLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width - 1;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)nlotClicked:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if(5 == _sortBy || (5 ^ 0xff) == _sortBy)
        _sortBy ^= 0xff;
    else
        _sortBy = 5;
    
    [self sortByNlot];
    
    CGSize expectedSize = [_cellHeader.nlotLabel.text sizeWithFont:_cellHeader.nlotLabel.font];
    uint expectedPos = _cellHeader.nlotLabel.frame.origin.x + _cellHeader.nlotLabel.frame.size.width - expectedSize.width - _cellHeader.roundImage.image.size.width;
    _cellHeader.roundImage.frame = CGRectMake(expectedPos, _cellHeader.roundImage.frame.origin.y, _cellHeader.roundImage.frame.size.width, _cellHeader.roundImage.frame.size.height);
}

- (void)sortByStock
{
    
    BOOL ascending = YES;
    if((1 ^ 0xff) == _sortBy) {
        ascending = NO;
        _cellHeader.roundImage.image = _imageUp;
    }
    else {
        _cellHeader.roundImage.image = _imageDown;
    }
    
    if(nil != _arrayTransaction) {
        NSArray *arraySource = [_arrayTransaction subarrayWithRange:NSMakeRange(0, _arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction2 *a, Transaction2 *b) {
                
                KiStockData *d1 = [[DBLite sharedInstance] getStockDataById:a.codeId];
                KiStockData *d2 = [[DBLite sharedInstance] getStockDataById:b.codeId];
                
                if(!ascending) {
                    NSComparisonResult result =  [d1.code compare:d2.code];
                    if (result == (NSComparisonResult)NSOrderedDescending) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if (result == (NSComparisonResult)NSOrderedAscending) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                
                
                return ([d1.code compare:d2.code]);
            }];
            
            [_arrayTransaction removeAllObjects];
            [_arrayTransaction addObjectsFromArray:arraySort];
            [tableview reloadData];
        }
    }
}

- (void)sortByTval
{
    
    BOOL ascending = YES;
    if((2 ^ 0xff) == _sortBy) {
        ascending = NO;
        _cellHeader.roundImage.image = _imageUp;
    }
    else {
        _cellHeader.roundImage.image = _imageDown;
    }
    
    if(nil != _arrayTransaction) {
        NSArray *arraySource = [_arrayTransaction subarrayWithRange:NSMakeRange(0, _arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction2 *a, Transaction2 *b) {
                
                if(ascending) {
                    if((a.tvalue) > (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tvalue) < (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.tvalue) < (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tvalue) > (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }                
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [_arrayTransaction removeAllObjects];
            [_arrayTransaction addObjectsFromArray:arraySort];
            [tableview reloadData];
        }

        
    }
}

- (void)sortByTlot
{
    BOOL ascending = YES;
    if((3 ^ 0xff) == _sortBy) {
        ascending = NO;
        _cellHeader.roundImage.image = _imageUp;
    }
    else {
        _cellHeader.roundImage.image = _imageDown;
    }
    
    if(nil != _arrayTransaction) {
        NSArray *arraySource = [_arrayTransaction subarrayWithRange:NSMakeRange(0, _arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction2 *a, Transaction2 *b) {
                
                if(ascending) {
                    if((a.tlot) > (b.tlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tlot) < (b.tlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.tlot) < (b.tlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tlot) > (b.tlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [_arrayTransaction removeAllObjects];
            [_arrayTransaction addObjectsFromArray:arraySort];
            [tableview reloadData];
        }

        
    }    
}

- (void)sortByNval
{
    BOOL ascending = YES;
    if((4 ^ 0xff) == _sortBy) {
        ascending = NO;
        _cellHeader.roundImage.image = _imageUp;
    }
    else {
        _cellHeader.roundImage.image = _imageDown;
    }
    
    if(nil != _arrayTransaction) {
        NSArray *arraySource = [_arrayTransaction subarrayWithRange:NSMakeRange(0, _arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction2 *a, Transaction2 *b) {
                
                if(ascending) {
                    if((a.nvalue) > (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nvalue) < (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.nvalue) < (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nvalue) > (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [_arrayTransaction removeAllObjects];
            [_arrayTransaction addObjectsFromArray:arraySort];
            [tableview reloadData];
        }
        
    }
    
}

- (void)sortByNlot
{
    BOOL ascending = YES;
    if((5 ^ 0xff) == _sortBy) {
        ascending = NO;
        _cellHeader.roundImage.image = _imageUp;
    }
    else {
        _cellHeader.roundImage.image = _imageDown;
    }
    
    if(nil != _arrayTransaction) {
        NSArray *arraySource = [_arrayTransaction subarrayWithRange:NSMakeRange(0, _arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction2 *a, Transaction2 *b) {
                
                if(ascending) {
                    if((a.nlot) > (b.nlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nlot) < (b.nlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }

                }
                else {
                    if((a.nlot) < (b.nlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nlot) > (b.nlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }

                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [_arrayTransaction removeAllObjects];
            [_arrayTransaction addObjectsFromArray:arraySort];
            [tableview reloadData];
        }

        
    }    
}



@end





@implementation NetBSByBrokerCell

@synthesize stockLabel, tvalLabel, tlotLabel, nvalLabel, nlotLabel;

- (id)init
{
    if(self = [super init]) {
        stockLabel = labelOnTable(CGRectMake(4, 2, 60, 15));
        tvalLabel = labelOnTable(CGRectMake(68, 2, 60, 15));
        tlotLabel = labelOnTable(CGRectMake(131, 2, 50, 15));
        nvalLabel = labelOnTable(CGRectMake(184, 2, 75, 15));
        nlotLabel = labelOnTable(CGRectMake(263, 2, 53, 15));
        
        stockLabel.textAlignment = NSTextAlignmentLeft;
        
        stockLabel.font = [UIFont systemFontOfSize:14];
        tvalLabel.font = [UIFont systemFontOfSize:14];
        tlotLabel.font = [UIFont systemFontOfSize:14];
        nvalLabel.font = [UIFont systemFontOfSize:14];
        nlotLabel.font = [UIFont systemFontOfSize:14];
        
        tvalLabel.adjustsFontSizeToFitWidth = YES;
        nvalLabel.adjustsFontSizeToFitWidth = YES;
        tlotLabel.adjustsFontSizeToFitWidth = YES;
        nlotLabel.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundColor = black;
                
        [self addSubview:stockLabel];
        [self addSubview:tvalLabel];
        [self addSubview:tlotLabel];
        [self addSubview:nvalLabel];
        [self addSubview:nlotLabel];
    }
    
    return self;
}

@end



@implementation Transaction2

- (id)initWithTransaction:(Transaction *)transaction andBoard:(Board)board
{
    if(self = [super init]) {
        _codeId = transaction.codeId;
        _board = board;
        _tvalue = transaction.buy.value + transaction.sell.value;
        _tlot = transaction.buy.volume + transaction.sell.volume;
        _nvalue = transaction.buy.value - transaction.sell.value;
        _nlot = transaction.buy.volume - transaction.sell.volume;
    }
    
    return self;
}

@end
