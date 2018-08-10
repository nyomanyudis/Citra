//
//  MarketSummaryV3.m
//  Ciptadana
//
//  Created by Reyhan on 10/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "MarketSummaryV3.h"

#import "MarketSummaryTable.h"
#import "HKKScrollableGridView.h"
#import "PDKeychainBindings.h"

@interface MarketSummaryV3()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (strong, nonatomic) MarketSummaryTable *table;

@end

@implementation MarketSummaryV3

- (void)viewDidLoad
{
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table = [[MarketSummaryTable alloc] initWithGridView:self.gridView];
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
            else if(record.recordType == RecordTypeMarketSummary) {
                [self.table newSummary:nil];
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}

@end
