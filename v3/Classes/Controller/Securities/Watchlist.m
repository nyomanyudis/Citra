//
//  Watchlist.m
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "Watchlist.h"

#import "KiWatchlistTable.h"
#import "WatchlistCell.h"
#import "PDKeychainBindings.h"

#import "JsonProperties.h"

@interface Watchlist() <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusButton;
@property (weak, nonatomic) IBOutlet UITableView *watchTable;
@property (weak, nonatomic) IBOutlet UITableView *watchHeaderTable;
@property (retain, nonatomic) NSMutableArray *savedWatchlist;

@property (strong, nonatomic) KiWatchlistTable *watchlist;
@property (strong, nonatomic) WatchlistCell *headerCell;

@end

@implementation Watchlist

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *array = [JsonProperties getWatchlistStock];
    self.savedWatchlist = [NSMutableArray array];
    for(NSString *s in array) {
        KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryByStock:s];
        if(summary) {
            [self.savedWatchlist addObject:summary];
        }
    }
    
    if(!self.headerCell) {
        self.headerCell = [[[NSBundle mainBundle] loadNibNamed:@"WatchlistCell" owner:self options:nil] objectAtIndex:0];
        
        self.headerCell.stock.text = @"STOCK";
        self.headerCell.price.text = @"PRICE";
        self.headerCell.change.text = @"CHANGE";
        self.headerCell.changepct.text = @"%";
        
        [self.headerCell.stock setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
        [self.headerCell.price setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
        [self.headerCell.change setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
        [self.headerCell.changepct setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
        
        self.headerCell.changepct.textAlignment = NSTextAlignmentCenter;
        
        [self.headerCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cellGrey"]]];
    }
    
    [self.watchlist newSummary:self.savedWatchlist];
    [self callback];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"identifier = %@",self.restorationIdentifier);
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.watchHeaderTable.delegate = self;
    self.watchlist = [[KiWatchlistTable alloc] initWithTableView:self.watchTable];
}

#pragma mark - protected

//- (void)callback
//{
//    //__weak typeof(self) theSelf = self;
//    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
//        if(ok && record) {
//            if(record.recordType == RecordTypeKiIndices) {
//                [self updateIndices:record];
//            }
//            else if(record.recordType == RecordTypeKiStockSummary) {
//                NSMutableArray *tmp = [NSMutableArray array];
//                for(KiStockSummary *summary in record.stockSummary) {
//                    if([self isSavedSummary:summary]) {
//                        [tmp addObject:summary];
//                    }
//                }
//                if(tmp.count > 0)
//                    [self.watchlist updateSummary:tmp];
//            }
//        }
//    };
//    
//    [MarketFeed sharedInstance].callback = recordCallback;
//}

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(ok && record) {
        if(record.recordType == RecordTypeKiStockSummary) {
            NSMutableArray *tmp = [NSMutableArray array];
            for(KiStockSummary *summary in record.stockSummary) {
                if([self isSavedSummary:summary]) {
                    [tmp addObject:summary];
                }
            }
            if(tmp.count > 0)
                [self.watchlist updateSummary:tmp];
        }
    }
}

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    
}

#pragma mark - private

- (BOOL)isSavedSummary:(KiStockSummary *)summary
{
    if(self.savedWatchlist && self.savedWatchlist.count > 0) {
        for(KiStockSummary *tmp in self.savedWatchlist) {
            if(tmp.codeId == summary.codeId)
                return YES;
        }
    }
    return NO;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *labelStock = [[UIView alloc] initWithFrame: CGRectMake(0,0, 50, 50)];
    labelStock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    labelStock.backgroundColor = [UIColor yellowColor];
    UIView *labelPrice = [[UIView alloc] initWithFrame: CGRectMake(0,0, 50, 50)];
    labelPrice.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    labelPrice.backgroundColor = [UIColor yellowColor];
    UIView *labelChange = [[UIView alloc] initWithFrame: CGRectMake(0,0, 50, 50)];
    labelChange.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    labelChange.backgroundColor = [UIColor yellowColor];
    UIView *labelChangePct = [[UIView alloc] initWithFrame: CGRectMake(0,0, 50, 50)];
    labelChangePct.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    labelChangePct.backgroundColor = [UIColor yellowColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.headerCell.stock addSubview:labelStock];
    [self.headerCell.price addSubview:labelPrice];
    [self.headerCell.change addSubview:labelChange];
    [self.headerCell.changepct addSubview:labelChangePct];
    return self.headerCell;
}

@end
