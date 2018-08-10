//
//  Home.m
//  Ciptadana
//
//  Created by Reyhan on 10/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "Home.h"

#import "SWRevealViewController.h"

#import "KiRegionalTable.h"
#import "KiCurrencyTable.h"
#import "KiIndicesTable.h"
#import "MarketFeed.h"

@interface Home ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *currGrid;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *indiGrid;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *worldGrid;
@property (strong, nonatomic) KiCurrencyTable *currencyTable;
@property (strong, nonatomic) KiIndicesTable *indicesTable;
@property (strong, nonatomic) KiRegionalTable *worldTable;

@end

@implementation Home



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"identifier = %@",self.restorationIdentifier);
    // Do any additional setup after loading the view.
    NSLog(@"[SysAdmin sharedInstance].sysadmindata = %@",[SysAdmin sharedInstance].sysAdminData);
    NSLog(@"[SysAdmin sharedInstance].loginFeed = %@",[SysAdmin sharedInstance].loginFeed);
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    self.currencyTable =[[KiCurrencyTable alloc] initWithGridView:self.currGrid];
    self.indicesTable = [[KiIndicesTable alloc] initWithGridView:self.indiGrid];
    self.worldTable = [[KiRegionalTable alloc] initWithGridView:self.worldGrid];
    
    
    // remove previous controller
    for(UIViewController *controller in self.navigationController.viewControllers) {
        if(![controller isKindOfClass:[Home class]]) {
            [controller removeFromParentViewController];
        }
    }
    
//    [self performSelector:@selector(callback)];
//    [[MarketFeed sharedInstance] initMarket];
    
    [self updateCurrencies:[[MarketData sharedInstance] getCurrencies]];
    [self updateIndicesTable:[[MarketData sharedInstance] getIndices]];
    [self updateWorldTable:[[MarketData sharedInstance] getRegionalIndices]];
    
    
    
    [self performSelector:@selector(gridCallback)];
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
////    UIView *preV = ((UIViewController *)self).view;
////    UIView *newV = ((UIViewController *)segue.destinationViewController).view;
////    
////    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
////    newV.center = CGPointMake(preV.center.x - preV.frame.size.width, newV.center.y);
////    [window insertSubview:newV aboveSubview:preV];
////    
////    [UIView animateWithDuration:0.4
////                     animations:^{
////                         newV.center = CGPointMake(preV.center.x, newV.center.y);
////                         preV.center = CGPointMake(preV.center.x + preV.frame.size.width, newV.center.y);}
////                     completion:^(BOOL finished){
////                         [preV removeFromSuperview];
////                         window.rootViewController = segue.destinationViewController;
////                     }];
//    
//    UIView *preV = self.view;//((UIViewController *)self).view;
//    UIView *newV = ((UIViewController *)segue.destinationViewController).view;
//    
////    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
////    newV.center = CGPointMake(preV.center.x + preV.frame.size.width, newV.center.y);
////    [window insertSubview:newV aboveSubview:preV];
//    
//    [UIView animateWithDuration:0.35
//                     animations:^{
//                         newV.center = CGPointMake(preV.center.x, newV.center.y);
//                         //preV.center = CGPointMake(0- preV.center.x, newV.center.y);
//                     }
//                     completion:^(BOOL finished){
//                         [preV removeFromSuperview];
//                         //window.rootViewController = segue.destinationViewController;
//                     }];
//}

#pragma mark - protected

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(ok && record) {
        if(record.recordType == RecordTypeKiIndices) {
            [self updateIndicesTable:[[MarketData sharedInstance] getIndices]];
        }
        else if(record.recordType == RecordTypeKiCurrency) {
            [self updateCurrencies:[[MarketData sharedInstance] getCurrencies]];
        }
        else if(record.recordType == RecordTypeKiRegionalIndices) {
            [self updateWorldTable:[[MarketData sharedInstance] getRegionalIndices]];
        }
    }
}

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    
}

#pragma mark - private

- (void)updateCurrencies:(NSArray *)currencies
{
    if(currencies && currencies.count > 0) {
        [self.currencyTable updateCurrencies:currencies];
    }
}

- (void)updateIndicesTable:(NSArray *)indices
{
    if(indices && indices.count > 0) {
        [self.indicesTable updateIndices:indices];
    }
}

- (void)updateWorldTable:(NSArray *)indices
{
    if(indices && indices.count > 0) {
        [self.worldTable updateRegionalIndices:indices];
    }
}

- (void)gridCallback
{
    HKKScrollableGridCallback callback = ^void(NSInteger index, id object) {
        //[self performSegueWithIdentifier:@"regionalIdentifier" sender:nil];
        
//        SWRevealViewController *revealController = self.revealViewController;
//        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
//        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"regionalIdentity2"];
//        
//        UIView *preV = self.view;//((UIViewController *)self).view;
//        UIView *newV = vc.view;
//        
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        newV.center = CGPointMake(preV.center.x + preV.frame.size.width, newV.center.y);
//        [window insertSubview:newV aboveSubview:preV];
//        
//        [UIView animateWithDuration:0.30
//                         animations:^{
//                             newV.center = CGPointMake(preV.center.x, newV.center.y);
//                             //preV.center = CGPointMake(0- preV.center.x, newV.center.y);
//                         }
//                         completion:^(BOOL finished){
//                             [preV removeFromSuperview];
//                             //window.rootViewController = segue.destinationViewController;
//                             if(vc)
//                                 [revealController pushFrontViewController:vc animated:YES];
//
//                         }];
        
        SWRevealViewController *revealController = self.revealViewController;
        
        UIStoryboard *mainStoryboard = self.navigationController.storyboard;
        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"regionalSummaryIdentity"];
        
        [revealController pushFrontViewController:vc animated:YES];

    };
    self.indiGrid.callback = callback;
    self.worldGrid.callback = callback;
    
    HKKScrollableGridCallback callback2 = ^void(NSInteger index, id object) {
        SWRevealViewController *revealController = self.revealViewController;
        
        UIStoryboard *mainStoryboard = self.navigationController.storyboard;
        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"currencyIdentity"];
        
        [revealController pushFrontViewController:vc animated:YES];
    };
    self.currGrid.callback = callback2;
}

@end
