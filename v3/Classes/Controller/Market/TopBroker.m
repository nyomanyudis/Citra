//
//  TopBroker.m
//  Ciptadana
//
//  Created by Reyhan on 10/19/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TopBroker.h"

#import "KiBrokerTable.h"
#import "HKKScrollableGridView.h"
#import "DropdownButton.h"
#import "PDKeychainBindings.h"

#define SORT_TYPE @[@"FREQUENCY", @"VALUE", @"VOLUME"]
#define SORT_ORDER @[@"Asc", @"Desc"]

@interface TopBroker()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (strong, nonatomic) KiBrokerTable *brokerTable;
@property (weak, nonatomic) IBOutlet DropdownButton *typeButton;
@property (weak, nonatomic) IBOutlet DropdownButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *FrequencyButton;
@property (weak, nonatomic) IBOutlet UIButton *ValueButton;
@property (weak, nonatomic) IBOutlet UIButton *VolumeButton;
@property (assign, nonatomic) NSInteger sortBy;
@property (assign, nonatomic) NSInteger orderBy;

@property (strong, nonatomic) NSTimer *autoSortTimer;
@property (assign, nonatomic) BOOL refresh;
@property (assign, nonatomic) NSString *buttonTextClicked;

@end

@implementation TopBroker

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
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    
    self.buttonTextClicked = @"";
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.brokerTable =[[KiBrokerTable alloc] initWithGridView:self.gridView];
    
    [self.brokerTable updateBroker:[[MarketData sharedInstance] getBrokerSummaries]];
    
    self.typeButton.items = SORT_TYPE;
    self.sortButton.items = SORT_ORDER;
    
//    [self performSelector:@selector(dropdownCallback)];
    [self performSelector:@selector(buttonCallBack)];
    

    
    self.autoSortTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(doSort) userInfo:nil repeats:YES];
}

- (void) buttonCallBack
{
    [self.FrequencyButton addTarget:self action:@selector(doSortByFreq) forControlEvents:UIControlEventTouchUpInside];
    [self.ValueButton addTarget:self action:@selector(doSortByValue) forControlEvents:UIControlEventTouchUpInside];
    [self.VolumeButton addTarget:self action:@selector(doSortByVolume) forControlEvents:UIControlEventTouchUpInside];
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
            else if(record.recordType == RecordTypeBrokerSummary) {
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
//        self.sortBy = index;
//        [self doSort:index];
//    };
//    
//    DropdownCallback orderCallback = ^void(NSInteger index, NSString *string) {
//        self.orderBy = index;
//        [self doSort:self.typeButton.selectionIndex];
//    };
//    
//    [self.typeButton setDropdownCallback:sortCallback];
//    [self.sortButton setDropdownCallback:orderCallback];
//}

- (void)doSort
{
    if(self.refresh) {
        self.refresh = !self.refresh;
        if([self.buttonTextClicked isEqualToString:@""]) {
            //[self doSortByBroker];
            [self doSortByValue];
        }
        else if([self.buttonTextClicked isEqualToString:@"Value"]) {
            [self doSortByValue];
        }
        else if([self.buttonTextClicked isEqualToString:@"Volume"]) {
            [self doSortByVolume];
        }
        else if([self.buttonTextClicked isEqualToString:@"Freq"]) {
            [self doSortByFreq];
        }
    }
}

//- (void)doSort:(NSInteger)index
//{
//    if(index == 0) {
//        //[self doSortByBroker];
//        [self doSortByFreq];
//    }
//    else if(index == 1) {
//        [self doSortByValue];
//    }
//    else if(index == 2) {
//        [self doSortByVolume];
//    }
//    else if(index == 4) {
//        [self doSortByFreq];
//    }
//}

- (void)doSortByBroker
{
    NSArray *tmp = [[MarketData sharedInstance] getBrokerSummariesByTVal:[[MarketData sharedInstance] getBrokerSummaries]];
    if(tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            KiBrokerData *b1 = [[MarketData sharedInstance] getBrokerDataById:a.codeId];
            KiBrokerData *b2 = [[MarketData sharedInstance] getBrokerDataById:b.codeId];
            
            if(self.sortButton.selectionIndex > 0) {
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
        
        [self.brokerTable updateBroker:sort];
    }
}

- (void)doSortByValue
{
    self.buttonTextClicked = @"Value";
    
    [self.ValueButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.ValueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.FrequencyButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.FrequencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.VolumeButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.VolumeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSArray *tmp = [[MarketData sharedInstance] getBrokerSummariesByTVal:[[MarketData sharedInstance] getBrokerSummaries]];
    if(tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            Transaction *bRG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            float ValRG = 0, ValTN = 0, ValNG = 0;
            
            
            if(aRG)
                ValRG = aRG.buy.value + aRG.sell.value;
            
            if(aTN)
                ValTN = aTN.buy.value + aTN.sell.value;
            
            if(aNG)
                ValNG = aNG.buy.value + aNG.sell.value;
            
            
            float aVal = ValRG + ValTN + ValNG;
            
            
            ValRG = 0, ValTN = 0, ValNG = 0;
            
            if(bRG)
                ValRG = bRG.buy.value + bRG.sell.value;
            
            if(bTN)
                ValTN = bTN.buy.value + bTN.sell.value;
            
            if(bNG)
                ValNG = bNG.buy.value + bNG.sell.value;
            
            
            float bVal = ValRG + ValTN + ValNG;
            
//            if (self.sortButton.selectionIndex > 0) {
                if (aVal > bVal)
                    return NSOrderedAscending;
                else if(aVal < bVal)
                    return NSOrderedDescending;
//            }
//            else {
//                if (aVal < bVal)
//                    return NSOrderedAscending;
//                else if(aVal > bVal)
//                    return NSOrderedDescending;
//            }
            
            
            return NSOrderedSame;
        }];
        
        [self.brokerTable updateBroker:sort];
    }
}

- (void)doSortByVolume
{
    self.buttonTextClicked = @"Volume";
    [self.VolumeButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.VolumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.FrequencyButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.FrequencyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.ValueButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.ValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSArray *tmp = [[MarketData sharedInstance] getBrokerSummariesByTVal:[[MarketData sharedInstance] getBrokerSummaries]];
    if(tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            Transaction *bRG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            float ValRG = 0, ValTN = 0, ValNG = 0;
            
            
            if(aRG)
                ValRG = aRG.buy.volume + aRG.sell.volume;
            
            if(aTN)
                ValTN = aTN.buy.volume + aTN.sell.volume;
            
            if(aNG)
                ValNG = aNG.buy.volume + aNG.sell.volume;
            
            
            float aVal = ValRG + ValTN + ValNG;
            
            
            ValRG = 0, ValTN = 0, ValNG = 0;
            
            if(bRG)
                ValRG = bRG.buy.volume + bRG.sell.volume;
            
            if(bTN)
                ValTN = bTN.buy.volume + bTN.sell.volume;
            
            if(bNG)
                ValNG = bNG.buy.volume + bNG.sell.volume;
            
            
            float bVal = ValRG + ValTN + ValNG;
            
//            if (self.sortButton.selectionIndex > 0) {
                if (aVal > bVal)
                    return NSOrderedAscending;
                else if(aVal < bVal)
                    return NSOrderedDescending;
//            }
//            else {
//                if (aVal < bVal)
//                    return NSOrderedAscending;
//                else if(aVal > bVal)
//                    return NSOrderedDescending;
//            }
            
            
            return NSOrderedSame;
        }];
        
        [self.brokerTable updateBroker:sort];
    }
}

- (void)doSortByFreq
{
    self.buttonTextClicked = @"Freq";
    //    [self.FrequencyButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.FrequencyButton setBackgroundImage:[UIImage imageNamed:@"bgtapped"] forState:UIControlStateNormal];
    [self.FrequencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.ValueButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.ValueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.VolumeButton setBackgroundImage:[UIImage imageNamed:@"bgnormal"] forState:UIControlStateNormal];
    [self.VolumeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    NSArray *tmp = [[MarketData sharedInstance] getBrokerSummariesByTVal:[[MarketData sharedInstance] getBrokerSummaries]];
    if(tmp && tmp.count > 0) {
        NSArray *sort = [tmp sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
            Transaction *aRG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardRg];
            Transaction *aTN = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardTn];
            Transaction *aNG = [[MarketData sharedInstance] getBrokerSummaryById:a.codeId andBoard:BoardNg];
            
            Transaction *bRG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardRg];
            Transaction *bTN = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardTn];
            Transaction *bNG = [[MarketData sharedInstance] getBrokerSummaryById:b.codeId andBoard:BoardNg];
            
            float ValRG = 0, ValTN = 0, ValNG = 0;
            
            
            if(aRG)
                ValRG = aRG.buy.frequency + aRG.sell.frequency;
            
            if(aTN)
                ValTN = aTN.buy.frequency + aTN.sell.frequency;
            
            if(aNG)
                ValNG = aNG.buy.frequency + aNG.sell.frequency;
            
            
            float aVal = ValRG + ValTN + ValNG;
            
            
            ValRG = 0, ValTN = 0, ValNG = 0;
            
            if(bRG)
                ValRG = bRG.buy.frequency + bRG.sell.frequency;
            
            if(bTN)
                ValTN = bTN.buy.frequency + bTN.sell.frequency;
            
            if(bNG)
                ValNG = bNG.buy.frequency + bNG.sell.frequency;
            
            
            float bVal = ValRG + ValTN + ValNG;
            
//            if (self.sortButton.selectionIndex > 0) {
                if (aVal > bVal)
                    return NSOrderedAscending;
                else if(aVal < bVal)
                    return NSOrderedDescending;
//            }
//            else {
//                if (aVal < bVal)
//                    return NSOrderedAscending;
//                else if(aVal > bVal)
//                    return NSOrderedDescending;
//            }
            
            
            return NSOrderedSame;
        }];
        
        [self.brokerTable updateBroker:sort];
    }
}

@end
