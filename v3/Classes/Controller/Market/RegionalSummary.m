//
//  RegionalSummary.m
//  Ciptadana
//
//  Created by Reyhan on 10/18/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "RegionalSummary.h"

#import "KiRegionalTable.h"
#import "KiIndicesTable.h"
#import "FutureTable.h"
#import "HKKScrollableGridView.h"
#import "PDKeychainBindings.h"

@interface RegionalSummary()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *indiGrid;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *regGridView;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *futureGrid;
@property (strong, nonatomic) KiIndicesTable *indicesTable;
@property (strong, nonatomic) KiRegionalTable *regionalTable;
@property (strong, nonatomic) FutureTable *futureTable;

@end

@implementation RegionalSummary

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.indicesTable =[[KiIndicesTable alloc] initWithGridView:self.indiGrid];
    self.regionalTable =[[KiRegionalTable alloc] initWithGridView:self.regGridView];
    self.futureTable =[[FutureTable alloc] initWithGridView:self.futureGrid];
    
    [self.indicesTable updateIndices:[[MarketData sharedInstance] getIndices]];
    [self.regionalTable updateRegionalIndices:[[MarketData sharedInstance] getRegionalIndices]];
    [self.futureTable updateFuture:[[MarketData sharedInstance] getFutures]];
}

#pragma mark - protected

- (void)callback
{
    //__weak typeof(self) theSelf = self;
    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
                [self.indicesTable updateIndices:[[MarketData sharedInstance] getIndices]];
            }
            else if(record.recordType == RecordTypeKiRegionalIndices) {
                // 3 min
                [self.regionalTable updateRegionalIndices:record.regionalIndices];
            }
            else if(record.recordType == RecordTypeFutures) {
                // 4 min
                [self.futureTable updateFuture:record.future];
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}

@end
