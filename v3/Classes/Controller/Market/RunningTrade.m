//
//  RunningTrade.m
//  Ciptadana
//
//  Created by Reyhan on 10/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "RunningTrade.h"

#import "SWRevealViewController.h"

#import "HKKScrollableGridView.h"
#import "KiRunTable.h"
#import "MarketFeed.h"
#import "PDKeychainBindings.h"

@interface RunningTrade ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet HKKScrollableGridView *runGridView;
@property (strong, nonatomic) KiRunTable *runTable;

@end

@implementation RunningTrade

- (void)viewWillDisappear:(BOOL)animated
{
    [[MarketFeed sharedInstance] unsubscribe:RecordTypeKiTrade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"identifier = %@",self.restorationIdentifier);
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.runTable =[[KiRunTable alloc] initWithGridView:self.runGridView];
    
    
    [[MarketFeed sharedInstance] subscribe:RecordTypeKiTrade status:RequestSubscribe];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - protected

//- (void)callback
//{
//    //__weak typeof(self) theSelf = self;
//    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
//        if(ok && record) {
//            if(record.recordType == RecordTypeKiIndices) {
//                [self updateIndices:record];
//            }
//            else if(record.recordType == RecordTypeKiTrade) {
//                [self.runTable newTrade:record.trade];
//            }
//        }
//    };
//    
//    [MarketFeed sharedInstance].callback = recordCallback;
//}

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(ok && record) {
        if(record.recordType == RecordTypeKiTrade) {
            [self.runTable newTrade:record.trade];
        }
    }
}


@end
