//
//  ForeignDomesticNetBS.m
//  Ciptadana
//
//  Created by Reyhan on 10/20/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "ForeignDomesticNetBS.h"

#import "HKKScrollableGridView.h"
#import "ForeignDomesticTable.h"
#import "JsonProperties.h"
#import "TableAlert.h"
#import "PDKeychainBindings.h"

@interface ForeignDomesticNetBS()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (strong, nonatomic) ForeignDomesticTable *table;
@property (retain, nonatomic) NSMutableArray *savedWatchlist;

@end

@implementation ForeignDomesticNetBS

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    [JsonProperties setForeignDomestic:self.stocks];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *array = [JsonProperties getForeignDomestic];
    self.savedWatchlist = [NSMutableArray array];
    for(NSString *s in array) {
        KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryByStock:s];
        if(summary) {
            [self.savedWatchlist addObject:summary];
        }
    }
    
    [self.table newSummary:self.savedWatchlist];
    
    [self reCallbackGrid];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table = [[ForeignDomesticTable alloc] initWithGridView:self.gridView];
}

#pragma mark - protected

- (void)callback
{
    //__weak typeof(self) theSelf = self;
    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
            }
            else if(record.recordType == RecordTypeKiStockSummary) {
                NSMutableArray *tmp = [NSMutableArray array];
                for(KiStockSummary *summary in record.stockSummary) {
                    if([self isSavedSummary:summary]) {
                        [tmp addObject:summary];
                    }
                }
                if(tmp.count > 0)
                    [self.table updateSummary:tmp];
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
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

- (void)reCallbackGrid
{
    HKKScrollableGridCallback callback = ^void(NSInteger index, id object) {
        NSLog(@"index callback = %d",index);
        if(object && [object isMemberOfClass:[KiStockSummary class]]) {
            KiStockSummary *summary = object;
            KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
            
            void (^deleteOnClick)(void) = ^{
                NSLog(@"DELETE CLICKED %@", object);
                if(index >= 0 && index < self.table.stockSummaryList.count) {
                    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.table.stockSummaryList];
                    [tmp removeObjectAtIndex:index];
                    [self.table resetSummary:tmp];
                    
                    NSMutableArray *tmpStocks = [NSMutableArray array];
                    for(KiStockSummary *summary in tmp) {
                        KiStockData *data = [[MarketData sharedInstance] getStockDataById:summary.codeId];
                        [tmpStocks addObject:data.code];
                    }
                    
                    [JsonProperties setForeignDomestic:tmpStocks];
                    
                    tmp = nil;
                    tmpStocks = nil;
                }
                
            };
            
            NSArray *cells = [NSArray arrayWithObjects: @"STOCK", data.code,
                              nil];
            
            MLTableAlert *alert = [TableAlert alertConfirmationOKCancel:cells titleAlert:@"DELETE CONFIRMATION" okOnClick:deleteOnClick cancelOnClick:nil];
            [alert setHeight:150.f];
            [alert showWithColor:WHITE];
        }
    };
    self.gridView.callback = callback;
}

@end
