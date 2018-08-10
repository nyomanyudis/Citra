//
//  PortfolioViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>//CGAffineTransform
#import "PortfolioViewController.h"
#import "AppDelegate.h"
#import "ImageResources.h"
#import "MLTableAlert.h"

@interface PortfolioViewController () <UIDropListDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray *arrayClientList;
@property (retain, nonatomic) NSArray *arayPortfolio;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation PortfolioViewController

@synthesize backBarItem, homeBarItem;
@synthesize arrayClientList;
@synthesize clientDropList,opTF, loanTF, bovTF, btvTF, stvTF, marketTF, tableview, cashBalanceTxt;
@synthesize scrollview;

static CustomerPosition *cCustomerPosition;


- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{

    }];

}

- (void)homeBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    //tableview.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
    tableview.autoresizesSubviews=NO;
    tableview.frame = CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y , tableview.frame.size.width+345, tableview.frame.size.height+5);
    scrollview.contentSize = CGSizeMake(tableview.frame.size.width, scrollview.frame.size.height);
    
    if (nil != cCustomerPosition) {
        [self updateCustomerPosition:cCustomerPosition];
    }
    
    [clientDropList setDropDelegate:self];
    
    [self setupView:YES];
}

- (void)alert:(NSString*)message
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    //    [alertView show];
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor whiteColor];
        celltable.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        celltable.textLabel.numberOfLines = 0;
        
        celltable.textLabel.text = message;
        
        return celltable;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        return celltable.frame.size.height + 2;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return 1;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Alert"
                                          cancelButtonTitle:@"OK"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

- (void)setupView:(bool)requestClientList
{
    
    AgentTrade *trade = [AgentTrade sharedInstance];
    if (nil != trade && nil != trade.getClients) {
        arrayClientList = trade.getClients;
        
        NSMutableArray *array = [NSMutableArray array];
        for (ClientList *client in arrayClientList) {
            [array addObject:client.name];
        }
        
        [clientDropList arrayList:array];
        
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.selectedIndex];
        [clientDropList setTitle:client.name forState:UIControlStateNormal];
    }
    else if(requestClientList){
        [[AgentTrade sharedInstance] subscribe:RecordTypeClientList requestType:RequestGet];
    }
    else {
        //[self alert:@"You don't have Client List and Order Power"];
    }
    
    if (nil != arrayClientList && arrayClientList.count > 0) {
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.selectedIndex];
        [self.indicator startAnimating];
        [trade subscribe:RecordTypeGetPortfolioList requestType:RequestGet clientcode:client.clientcode];
        [trade subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:client.clientcode];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setClientDropList:nil];
    [self setOpTF:nil];
    [self setLoanTF:nil];
    [self setBovTF:nil];
    [self setBtvTF:nil];
    [self setStvTF:nil];
    [self setMarketTF:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupView:NO];
        });
    }
    else if (RecordTypeGetPortfolioList == msg.recType) {
        [self updatePortfolio:msg.recPortfolio];
    }
    else if(RecordTypeGetCustomerPosition == msg.recType) {
        [self updateCustomerPosition:msg.recCustomerPosition];
    }
}

- (void)updatePortfolio:(NSArray*)arrayPortfolio
{   
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.indicator stopAnimating];
        
        _arayPortfolio = arrayPortfolio;
        
        [tableview reloadData];
        if(nil != arrayPortfolio && arrayPortfolio.count > 0) {
            tableview.alpha = 1;
        }
        else {
            tableview.alpha = 0;
        }
    });
}

- (void)updateCustomerPosition:(CustomerPosition *)cusPosition
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.indicator stopAnimating];
        
        cCustomerPosition = cusPosition;
        
        NSLog(@"Customer Position = %@", cusPosition);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"###,###.##";
        formatter.roundingMode = NSNumberFormatterNoStyle;
        [formatter setDecimalSeparator:@"."];
        [formatter setGroupingSeparator:@","];
        [formatter setAllowsFloats:YES];
        
        cashBalanceTxt.text =[ formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.loanBalance]];
        opTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.orderPower]];
        loanTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.loanRatio]];
        bovTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.buyOrderValue]];
        btvTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.buyTradeValue]];
        stvTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.sellTradeValue]];
        marketTF.text = [formatter stringFromNumber:[NSNumber numberWithDouble:cusPosition.marketValue]];
    });
}

#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    if(nil != arrayClientList && index < arrayClientList.count && index != clientDropList.selectedIndex) {
        ClientList *client = [arrayClientList objectAtIndex:index];
        [self.indicator startAnimating];
        [[AgentTrade sharedInstance] subscribe:RecordTypeGetPortfolioList requestType:RequestGet clientcode:client.clientcode];
        [[AgentTrade sharedInstance] subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:client.clientcode];
    }
}

#pragma mark
#pragma UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil != _arayPortfolio)
        return _arayPortfolio.count;
    
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PortfolioCell *cell = [[PortfolioCell alloc] init];
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Portfolio *p = [_arayPortfolio objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"PortfolioCell";
    //PortfolioCell *cell = [[PortfolioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    PortfolioCell *cell = (PortfolioCell*)[tableview dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[PortfolioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.stockLabel.text = p.stockcode;
        cell.shareLabel.text = currencyString([NSNumber numberWithFloat:p.lot]);
        cell.lotLabel.text = currencyString([NSNumber numberWithFloat:(p.lot / [AgentTrade sharedInstance].shares)]);
        cell.outstandingLabel.text = currencyString([NSNumber numberWithFloat:p.outstanding]);
        cell.profitLabel.text = @"";
        cell.lastLabel.text = @"";
        cell.avgLabel.text = currencyString([NSNumber numberWithFloat:p.avgPrice]);
        cell.valueLabel.text = @"";
        
        KiStockSummary *stockSummary = [[DBLite sharedInstance] getStockSummaryByStock:p.stockcode];
        if(stockSummary != nil) {
            int32_t last = stockSummary.stockSummary.ohlc.close;
            if(last == 0) {
                last = stockSummary.stockSummary.previousPrice;
            }
            double profitLoss = (p.lot * last) - (p.lot * p.avgPrice);
            
            cell.profitLabel.text = currencyString([NSNumber numberWithDouble:profitLoss]);
            //cell.lastLabel.text = currencyString([NSNumber numberWithInt:stockSummary.stockSummary.previousPrice]);
            //cell.valueLabel.text = currencyString([NSNumber numberWithInt:stockSummary.stockSummary.ohlc.close]);
            cell.lastLabel.text = currencyString([NSNumber numberWithInt:stockSummary.stockSummary.ohlc.close]);
            
            //long value = p.lot * stockSummary.stockSummary.ohlc.close * [AgentTrade sharedInstance].shares;
            long value = p.lot * last;
            cell.valueLabel.text = currencyString([NSNumber numberWithLong:value]);
        }
    }
    
    return cell;
}

@end




@implementation PortfolioCell

@synthesize stockLabel, shareLabel, lotLabel, outstandingLabel, profitLabel, lastLabel, avgLabel, valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        stockLabel = labelOnTableWithLabel(@"Stock", CGRectMake(2, 0, 60, 15));
        shareLabel = labelOnTableWithLabel(@"Share", CGRectMake(63, 0, 90, 15));
        lotLabel = labelOnTableWithLabel(@"Lot", CGRectMake(155, 0, 55, 15));
        outstandingLabel = labelOnTableWithLabel(@"Open Sell Order", CGRectMake(215, 0, 102, 15));
        profitLabel = labelOnTableWithLabel(@"P/L", CGRectMake(320, 0, 100, 15));
        lastLabel = labelOnTableWithLabel(@"Last", CGRectMake(422, 0, 80, 15));
        avgLabel = labelOnTableWithLabel(@"Avg.", CGRectMake(504, 0, 75, 15));
        valueLabel = labelOnTableWithLabel(@"Value", CGRectMake(584, 0, 80, 15));
        
        stockLabel.adjustsFontSizeToFitWidth = YES;
        shareLabel.adjustsFontSizeToFitWidth = YES;
        lotLabel.adjustsFontSizeToFitWidth = YES;
        outstandingLabel.adjustsFontSizeToFitWidth = YES;
        profitLabel.adjustsFontSizeToFitWidth = YES;
        lastLabel.adjustsFontSizeToFitWidth = YES;
        avgLabel.adjustsFontSizeToFitWidth = YES;
        valueLabel.adjustsFontSizeToFitWidth = YES;
        
        stockLabel.textAlignment = NSTextAlignmentLeft;
        
        self.backgroundColor = black;
        
        [self addSubview:stockLabel];
        [self addSubview:shareLabel];
        [self addSubview:lotLabel];
        [self addSubview:outstandingLabel];
        [self addSubview:profitLabel];
        [self addSubview:lastLabel];
        [self addSubview:avgLabel];
        [self addSubview:valueLabel];
        
        //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+102, self.frame.size.height);
        //self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }
    
    return self;
}

@end