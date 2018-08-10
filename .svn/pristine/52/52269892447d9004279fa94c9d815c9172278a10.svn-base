//
//  FDNetBuySellViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/26/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "FDNetBuySellViewController.h"
#import "UIButton+Customized.h"
#import "ImageResources.h"
#import "UIColor+ColorStyle.h"
#import "AppDelegate.h"
#import "AutocompletionTableView.h"
#import "NSString+StringAdditions.h"
#import "MLTableAlert.h"
#import "OrderListViewController.h"


#define netown(fbought, fsold) fbought - fsold

@interface FDNetBuySellViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextFieldDelegate, UIDropListDelegate, AutocompletionTableViewDelegate>

@property FDNetBuySellCell *headerCell;

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic) NSNumberFormatter *formatter2comma;

@end

static NSMutableArray *stocks;

@implementation FDNetBuySellViewController
{
    
}

@synthesize backBarItem, homeBarItem;
@synthesize tableview, brokerText, insertButton;
@synthesize formatter2comma;

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:NO] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.brokerText inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    
    return _autoCompleter;
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
    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
    if(nil == stocks) {
        stocks = [NSMutableArray array];
    }
    
    if (stocks.count == 0) {
        [self insertRow:[DBLite sharedInstance].getForeignDomesticArray];
    }
    
    _headerCell = [[FDNetBuySellCell alloc] init];
    [_fdDroplist arrayList:@[@"Foreign", @"Domestic"]];
    _fdDroplist.dropDelegate = self;
    
    [insertButton BlackBackgroundCustomized];
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    brokerText.delegate = self;
    brokerText.autocorrectionType = UITextAutocorrectionTypeNo;
    brokerText.spellCheckingType = UITextSpellCheckingTypeNo;
    [brokerText addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

    
    [insertButton addTarget:self action:@selector(insertButtonClicked:) forControlEvents:UIControlEventTouchDown];
}

- (void)insertRow:(NSArray *)stringArray
{
    if (nil != stringArray) {
        BOOL reload = NO;
        
        for(NSString *string in stringArray) {
            NSString *s = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(s.length > 0) {
                
                reload = YES;
                
                BOOL found = NO;
                
                Board b = BoardRg;
                if ([s containsString:@".TN"]) {
                    b = BoardTn;
                }
                else if ([s containsString:@".NG"]) {
                    b = BoardNg;
                }
                
                NSRange rng = [s rangeOfString:@"." options:0];
                if (rng.length > 0) { //found
                    s = [s substringToIndex:rng.location];
                }
                
                KiStockData *d = [[DBLite sharedInstance] getStockDataByStock:s];
                
                
                KiStockSummary *stockSummary = [[DBLite sharedInstance] getStockSummaryById:d.id andBoard:b];
                if(nil != stockSummary && nil != s) {
                    [[DBLite sharedInstance] storeForeignDomesticStock:s];
                    [stocks addObject:stockSummary];
                    
                    found = YES;
                }
            }
        }
        
        if(reload)
            [tableview reloadData];
    }
}

- (void)insertButtonClicked:(id)sender
{
    
    if (nil != brokerText.text) {
        NSArray *stringArray = [brokerText.text.uppercaseString componentsSeparatedByString: @","];
        
        brokerText.text = @"";
        
        [self insertRow:stringArray];
    }
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
    [self setBrokerText:nil];
    [self setTableview:nil];
    [self setInsertButton:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma AutocompletionTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
    return [[DBLite sharedInstance] getStringStockData];
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    [brokerText resignFirstResponder];
    [self insertButtonClicked:[self insertButton]];
}


#pragma mark -
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    if (index == 0) {
        self.headerCell.fbLabel.text = @"F buy";
        self.headerCell.fsLabel.text = @"F sell";
        self.headerCell.noLabel.text = @"Net F";
    }
    else {
        self.headerCell.fbLabel.text = @"D buy";
        self.headerCell.fsLabel.text = @"D sell";
        self.headerCell.noLabel.text = @"Net D";
    }
    
    [tableview reloadData];
}


#pragma mark
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [brokerText resignFirstResponder];
    [self insertButtonClicked:[self insertButton]];
    [self.autoCompleter hideOptionsView];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([@" " isEqualToString:string]) {
        textField.text = [NSString stringWithFormat:@"%@,", textField.text];
    }
    
    return YES;
}


#pragma mark
#pragma UITableView Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stocks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FDNetBuySellCell *cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(nil == cell)
        cell = [[FDNetBuySellCell alloc] init];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSObject *o = [stocks objectAtIndex:indexPath.row];
    if([o isKindOfClass:[KiStockSummary class]]) {
        KiStockSummary *s = (KiStockSummary *) o;
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        if(nil != d) {
            
            float valBuy, valSell, netown;
            
            if (self.fdDroplist.selectedIndex == 0) {
                valBuy = s.foreignValBought;
                valSell = s.foreignValSold;
                netown = valBuy - valSell;
            }
            else {
                valBuy = s.stockSummary.tradedValue - s.foreignValBought;
                valSell = s.stockSummary.tradedValue - s.foreignValSold;
                netown = valBuy - valSell;
            }
            
            cell.stockLabel.text = s.stockSummary.board == BoardTn ? [d.code concat:@".TN"] : s.stockSummary.board == BoardNg ? [d.code concat:@".NG"] : d.code;
            cell.fbLabel.text = currencyRoundedWithFloatWithFormat(valBuy, self.formatter2comma);
            cell.fsLabel.text = currencyRoundedWithFloatWithFormat(valSell, self.formatter2comma);
            
            cell.noLabel.text = currencyRoundedWithFloatWithFormat(netown, self.formatter2comma);
            
            cell.stockLabel.textColor = [UIColor colorWithHexString:d.color];
            
            cell.noLabel.adjustsFontSizeToFitWidth = YES;
            
            if(netown > 0 ) {
                cell.fbLabel.textColor = GREEN;
                cell.fsLabel.textColor = GREEN;
                cell.noLabel.textColor = GREEN;
            }
            else if(netown < 0) {
                cell.fbLabel.textColor = red;
                cell.fsLabel.textColor = red;
                cell.noLabel.textColor = red;
            }
            else {
                cell.fbLabel.textColor = yellow;
                cell.fsLabel.textColor = yellow;
                cell.noLabel.textColor = yellow;
            }
        }
    }
    else {
        cell.stockLabel.text = @"";
        cell.fbLabel.text = @"";
        cell.fsLabel.text = @"";
        cell.noLabel.text = @"";
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *o = [stocks objectAtIndex:indexPath.row];
    NSString *code = @"";
    if([o isKindOfClass:[NSString class]]) {
        code = [stocks objectAtIndex:indexPath.row];
    }
    else if([o isKindOfClass:[KiStockSummary class]]) {
        KiStockSummary *s = (KiStockSummary *) o;
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        code = d.code;
    }
    
    if(![@"" isEqualToString:code]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"F/D Options"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"View Detail", @"Delete", nil];
        alertView.tag = indexPath.row;
        [alertView show];
    }
}


#pragma mark
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(2 == buttonIndex) {
        
        KiStockSummary *s = [stocks objectAtIndex:alertView.tag];
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        //NSString *code = s.stockSummary.board == BoardTn ? [d.code concat:@".TN"] : s.stockSummary.board == BoardNg ? [d.code concat:@".NG"] : d.code;
        NSString *code = s.stockSummary.board == BoardRg ? d.code : s.stockSummary.board == BoardTn ? CONCAT(d.code, @".TN") : CONCAT(d.code, @".NG");
       
        [stocks removeObject:s];
        [tableview reloadData];
        
        [[DBLite sharedInstance] removeForeignDomesticStock:code];
    }
    
    else if(1 == buttonIndex) {
        
        KiStockSummary *s = [stocks objectAtIndex:alertView.tag];
        KiStockData *d = [[DBLite sharedInstance] getStockDataById:s.codeId];
        
        UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath){
            TxOrderCell *cell = [[TxOrderCell alloc] init];
            
            cell.leftLabel.textColor = white;
            cell.leftLabel.backgroundColor = [UIColor clearColor];
            cell.sepLabel.backgroundColor = [UIColor clearColor];
            cell.rightLabel.backgroundColor = [UIColor clearColor];
            
            if (0 == indexPath.row) {
                cell.leftLabel.text = @"Code";
                cell.rightLabel.text = s.stockSummary.board == BoardTn ? [d.code concat:@".TN"] : s.stockSummary.board == BoardNg ? [d.code concat:@".NG"] : d.code;
                cell.rightLabel.textColor = [UIColor colorWithHexString:d.color];
            }
            else if (1 == indexPath.row) {
                cell.leftLabel.text = @"Name";
                cell.rightLabel.text = d.name;
                cell.rightLabel.textColor = [UIColor colorWithHexString:d.color];
            }
            else {
                long netown = 0;
                if (2 == indexPath.row) {
                    cell.leftLabel.text = @"F Buy";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:s.foreignValBought]];
                    netown = s.foreignValBought - s.foreignValSold;
                }
                else if(3 == indexPath.row) {
                    cell.leftLabel.text = @"F Sell";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:s.foreignValSold]];
                    netown = s.foreignValBought - s.foreignValSold;
                }
                else if(4 == indexPath.row) {
                    netown = s.foreignValBought - s.foreignValSold;
                    cell.leftLabel.text = @"Net F";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:netown]];
                }
                else if (5 == indexPath.row) {
                    cell.leftLabel.text = @"D Buy";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:s.stockSummary.tradedValue - s.foreignValBought]];
                    netown = (s.stockSummary.tradedValue - s.foreignValBought) - (s.stockSummary.tradedValue - s.foreignValSold);
                }
                else if(6 == indexPath.row) {
                    cell.leftLabel.text = @"D Sell";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:s.stockSummary.tradedValue - s.foreignValSold]];
                    netown = (s.stockSummary.tradedValue - s.foreignValBought) - (s.stockSummary.tradedValue - s.foreignValSold);
                }
                else if(7 == indexPath.row) {
                    netown = (s.stockSummary.tradedValue - s.foreignValBought) - (s.stockSummary.tradedValue - s.foreignValSold);
                    cell.leftLabel.text = @"Net D";
                    cell.rightLabel.text = [formatter2comma stringFromNumber:[NSNumber numberWithLongLong:netown]];
                }
                
                if(netown > 0 ) {
                    cell.rightLabel.textColor = GREEN;
                }
                else if(netown < 0) {
                    cell.rightLabel.textColor = red;
                }
                else {
                    cell.rightLabel.textColor = yellow;
                }
            }
            return cell;
        };
        MLTableAlert *alert = [[MLTableAlert alloc] initWithTitle:@"F/D Detail"
                                                cancelButtonTitle:@"Close"
                                                     numberOfRows:^NSInteger(NSInteger section) {
                                                         return 8;
                                                     }
                                                         andCells:cell
                                                   andCellsHeight:^CGFloat(MLTableAlert *alert, NSIndexPath *indexPath) {
                                                       return 25;
                                                   }
                               ];
        [alert setHeight:350];
        [alert show];
    }
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
    }
    else if (RecordTypeKiStockSummary == rec.recordType) {
        [self updateStockSummary:rec.stockSummary];
    }
}

- (void)updateStockSummary:(NSArray *)arrayStockSummary;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL found = NO;
        for (KiStockSummary *s in arrayStockSummary) {
            int n = 0;
            for (KiStockSummary *sum in stocks) {
                if (sum.codeId == s.codeId && sum.stockSummary.board == s.stockSummary.board) {
                    found = YES;
                    
                    [stocks removeObject:sum];
                    [stocks insertObject:s atIndex:n];
                    
                    n ++;
                    break;
                }
            }
        }
        
        if(found)
            [tableview reloadData];
    });
}

@end




@implementation FDNetBuySellCell

@synthesize stockLabel, fbLabel, fsLabel, noLabel;

- (id)init
{
    if(self = [super init]) {
        stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 80, 15)];
        fbLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 2, 75, 15)];
        fsLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 2, 70, 15)];
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 2, 77, 15)];
        
        fbLabel.textAlignment = NSTextAlignmentRight;
        fsLabel.textAlignment = NSTextAlignmentRight;
        noLabel.textAlignment = NSTextAlignmentRight;
        
        stockLabel.textColor = white;
        fbLabel.textColor = white;
        fsLabel.textColor = white;
        noLabel.textColor = white;
        
        stockLabel.backgroundColor = black;
        fbLabel.backgroundColor = black;
        fsLabel.backgroundColor = black;
        noLabel.backgroundColor = black;
        self.backgroundColor = black;
        
        stockLabel.font = [UIFont systemFontOfSize:14];
        fbLabel.font = [UIFont systemFontOfSize:14];
        fsLabel.font = [UIFont systemFontOfSize:14];
        noLabel.font = [UIFont systemFontOfSize:14];
        
        stockLabel.text = @"Stock";
        fbLabel.text = @"F buy";
        fsLabel.text = @"F sell";
        noLabel.text = @"Net F";
        
        [self addSubview:stockLabel];
        [self addSubview:fbLabel];
        [self addSubview:fsLabel];
        [self addSubview:noLabel];
    }
    
    return self;
}

@end