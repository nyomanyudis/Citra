//
//  TopStock.m
//  Ciptadana
//
//  Created by Reyhan on 10/31/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TopStock.h"

#import "HKKScrollableGridView.h"
#import "DropdownButton.h"
#import "TopStockTable.h"
#import "GroupButton.h"

#define SORT_TYPE @[@"TOP GAINER", @"TOP LOSER", @"TOP VALUE", @"MOST ACTIVE"]

@interface TopStock()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
//@property (weak, nonatomic) IBOutlet DropdownButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *TopGainerButton;
@property (weak, nonatomic) IBOutlet UIButton *TopLoserButton;
@property (weak, nonatomic) IBOutlet UIButton *TopValueButton;
//@property (weak, nonatomic) IBOutlet DropdownButton *sortButton;
@property (strong, nonatomic) TopStockTable *table;

@property (strong, nonatomic) NSTimer *autoSortTimer;
@property (assign, nonatomic) BOOL refresh;
@property (assign, nonatomic) NSString *btnActive;

@end

@implementation TopStock

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.autoSortTimer) {
        [self.autoSortTimer invalidate];
        self.autoSortTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
//    self.typeButton.items = SORT_TYPE;
    
    self.autoSortTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(doSort) userInfo:nil repeats:YES];
    
    self.table = [[TopStockTable alloc] initWithGridView:self.gridView];
//    [self performSelector:@selector(dropdownCallback)];
    [self performSelector:@selector(buttonCallBack)];

}

- (void) buttonCallBack
{
    [self.TopGainerButton addTarget:self action:@selector(actionTopGainerButton) forControlEvents:UIControlEventTouchUpInside];
    [self.TopLoserButton addTarget:self action:@selector(actionTopLoserButton) forControlEvents:UIControlEventTouchUpInside];
    [self.TopValueButton addTarget:self action:@selector(actionTopValueButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self actionTopValueButton];
}

-(void) actionTopGainerButton
{
    [self.TopGainerButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.TopGainerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.TopLoserButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopLoserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.TopValueButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnActive = @"TopGainer";
    
    [self.table doSortByGainer];
}

-(void) actionTopLoserButton
{
    [self.TopLoserButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.TopLoserButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.TopGainerButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopGainerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.TopValueButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnActive = @"TopLoser";
    
    [self.table doSortByLoser];
}

- (void) actionTopValueButton
{
    [self.TopValueButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.TopValueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.TopGainerButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopGainerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.TopLoserButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.TopLoserButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.btnActive = @"TopValue";
    
    [self.table doSortByValue];
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
                self.refresh = YES;
                //[self.brokerTable updateBroker:[[MarketData sharedInstance] getBrokerSummaries]];
                //[self.brokerTable newBroker:record.brokerSummary];
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}

//#pragma mark - private
//- (void)dropdownCallback
//{
//    DropdownCallback sortCallback = ^void(NSInteger index, NSString *string) {
//        [self doSort:self.btnActive];
//    };
//    [self.typeButton setDropdownCallback:sortCallback];
//    
//    [self doSort:0];
//}

- (void)doSort
{
    if(self.refresh) {
        self.refresh = !self.refresh;
        [self doSort:self.btnActive];
    }
}

- (void)doSort:(NSString *)btnActive
{
    NSLog(@"doSort = %@",btnActive);
    if([btnActive isEqualToString:@"TopGainer"]) {
        [self.table doSortByGainer];
    }
    else if([btnActive isEqualToString:@"TopLoser"]) {
        [self.table doSortByLoser];
    }
    else if([btnActive isEqualToString:@"TopValue"]) {
        [self.table doSortByValue];
    }
//    else if(index == 3) {
//        [self.table doSortByActive];
//    }
}


@end
