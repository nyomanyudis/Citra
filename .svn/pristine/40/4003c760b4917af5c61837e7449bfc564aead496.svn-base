//
//  AddRemoveWatchListViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/4/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AddRemoveWatchListViewController.h"
#import "UIButton+Customized.h"
#import "ImageResources.h"
#import "AutocompletionTableView.h"
#import "AppDelegate.h"
#import "Logger.h"

@interface AddRemoveWatchListViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AutocompletionTableViewDelegate>

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end

static NSMutableArray *stocks;

@implementation AddRemoveWatchListViewController


@synthesize homeBarItem, backBarItem;
@synthesize stockTextField, addButton, deleteButton, tableview;
@synthesize watchListController;
@synthesize delegate;

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

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:NO] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:stockTextField inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    
    return _autoCompleter;
}

- (void)viewDidDisappear:(BOOL)animated
{
    logDebug(@"ADD/REMOVE WATCHLIST -END");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    logDebug([NSString stringWithFormat:@"ADD/REMOVE WATCHLIST"]);
    
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    stockTextField.delegate = self;
    [stockTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [deleteButton BlackBackgroundCustomized];
    [addButton BlackBackgroundCustomized];
    [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchDown];
    
    if(nil == stocks) {
        stocks = [NSMutableArray array];
    
        NSArray *codeArray = [[DBLite sharedInstance] getWatchlistArray];
        for (NSString *code in codeArray) {
            Board board = BoardRg;
            
            NSString *s = code;
            
            NSRange range = [code rangeOfString:@".TN"];
            if(range.length > 0) {
                s = [code substringToIndex:range.location];
                board = BoardTn;
            }
            else if((range = [code rangeOfString:@".NG"]).length > 0) {
                s = [code substringToIndex:range.location];
                board = BoardNg;
            }
            
            AddRemoveStockCell *cell = [[AddRemoveStockCell alloc] init];
            
            KiStockData *d = [[DBLite sharedInstance] getStockDataByStock:s];
            
            cell.codeLabel.text = code;
            cell.nameLabel.text = d.name;
            cell.kiStockData = d;
            cell.board = board;
            [stocks addObject:cell];
            
        }
    }
    
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [stockTextField resignFirstResponder];
    [self.autoCompleter hideOptionsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)watchListController:(AbstractViewController *)watchList
{
    watchListController = watchList;
}

- (void)viewDidUnload {
    logDebug(@"ADD/REMOVE WATCHLIST -END");
    [self setStockTextField:nil];
    [self setAddButton:nil];
    [self setDeleteButton:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

- (void)addButtonClicked:(id)sender
{
    NSArray *stringArray = [stockTextField.text.uppercaseString componentsSeparatedByString: @","];
    logDebug([NSString stringWithFormat:@"ADD STOCK: %@. LENGTH: %lu", stockTextField.text, (unsigned long)stringArray.count]);
    stockTextField.text = @"";
    BOOL refresh = NO;
    //NSMutableArray *stocks = [NSMutableArray array];
    for(NSString *string in stringArray) {
        NSString *s = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].uppercaseString;
        if(s.length > 0) {
            refresh = YES;
            
            BOOL found = NO;
            
            Board board = BoardRg;
            
            NSRange range = [s rangeOfString:@".TN"];
            if(range.length > 0) {
                s = [s substringToIndex:range.location];
                board = BoardTn;
            }
            else if((range = [s rangeOfString:@".NG"]).length > 0) {
                s = [s substringToIndex:range.location];
                board = BoardNg;
            }
            
            AddRemoveStockCell *cell = [[AddRemoveStockCell alloc] init];
            
            KiStockData *d = [[DBLite sharedInstance] getStockDataByStock:s];
            if (nil != d && [s isEqualToString:d.code]) {
                found = YES;
                
                NSString *code = board == BoardRg ? s : board == BoardTn ? CONCAT(s, @".TN") : CONCAT(s, @".NG");
                if ([[DBLite sharedInstance] storeWatchlistStock:code]) {
                    cell.codeLabel.text = code;
                    cell.nameLabel.text = d.name;
                    cell.kiStockData = d;
                    cell.board = board;
                    [stocks addObject:cell];
                }
                
            }
            
        }
    }
    
    [delegate updateStocks:stocks];
    
    if(refresh) {
        [tableview reloadData];
    }
}

- (void)deleteStocks
{
    NSMutableArray *arrayStock = stocks;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL refresh = NO;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int n = 0; n < stocks.count; n ++) {
            [dict setObject:[stocks objectAtIndex:n] forKey:[NSNumber numberWithInt:n]];
        }

        for (int n = 0; n < arrayStock.count; n ++) {
            AddRemoveStockCell *cell = [stocks objectAtIndex:n];
            if (nil != cell && cell.checkButton.selected) {
                [[DBLite sharedInstance] removeWatchlistStock:cell.codeLabel.text];
                
                refresh = YES;
                
                logDebug([NSString stringWithFormat:@"DELETE STOCK: %@", cell.codeLabel.text]);
                [dict removeObjectForKey:[NSNumber numberWithInt:n]];
            }
        }
        
        if (nil != delegate) {
            [delegate updateStocks:dict.allValues];
        }
        
        stocks = nil;
        stocks = [NSMutableArray arrayWithArray:dict.allValues];
        
        if (refresh) {
            [tableview reloadData];
        }

    });
}

- (void)deleteButtonClicked:(id)sender
{
    [self performSelector:@selector(deleteStocks) withObject:nil afterDelay:.1];
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeKiIndices == rec.recordType) {
        [self updateIndicesIHSG:rec.indices];
    }
}



#pragma mark
#pragma AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
    return [DBLite sharedInstance].getStringStockData;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    [self addButtonClicked:nil];
}




#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return stocks.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddRemoveStockCell *cell = [stocks objectAtIndex:indexPath.row];
    
    logDebug([NSString stringWithFormat:@"RENDER STOCK: %@", cell.codeLabel.text]);
    
    if(nil != cell.kiStockData) {
        cell.codeLabel.textColor = [UIColor colorWithHexString:cell.kiStockData.color];
        cell.nameLabel.textColor = [UIColor colorWithHexString:cell.kiStockData.color];
    }
    
    return cell;
}




#pragma  mark
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [stockTextField resignFirstResponder];
    [self addButtonClicked:nil];
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

@end



@implementation AddRemoveStockCell

@synthesize codeLabel, nameLabel, checkButton, kiStockData;

- (id)init
{
    if(self = [super init]) {
        codeLabel = labelOnTable(CGRectMake(5, 0, 267, 21));
        nameLabel = labelOnTable(CGRectMake(5, 18, 267, 21));
        checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        checkButton.frame = CGRectMake(280, 0, 40, 40);
        [checkButton ButtonCheckbox];
        //[checkButton addTarget:self action:@selector(buttonCheckboxClicked:) forControlEvents:UIControlEventTouchUpInside];
        [checkButton addTarget:self action:@selector(buttonCheckboxClicked:) forControlEvents:UIControlEventTouchDown];
        
        codeLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        
        [codeLabel setFont:[UIFont boldSystemFontOfSize:14]];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:codeLabel];
        [self addSubview:nameLabel];
        [self addSubview:checkButton];
    }
    
    return self;
}

- (void)buttonCheckboxClicked:(UIButton*)s
{
    if(s.selected)
        s.selected = NO;
    else
        s.selected = YES;
}

@end
