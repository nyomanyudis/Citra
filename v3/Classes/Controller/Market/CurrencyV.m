//
//  CurrencyV.m
//  Ciptadana
//
//  Created by Reyhan on 2/15/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "CurrencyV.h"

#import "KiCurrencyTable.h"
#import "MarketFeed.h"
#import "PDKeychainBindings.h"

@interface CurrencyV ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *currGrid;
@property (strong, nonatomic) KiCurrencyTable *currencyTable;

@end

@implementation CurrencyV

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
    
    self.currencyTable =[[KiCurrencyTable alloc] initWithGridView:self.currGrid];
    
    [self updateCurrencies:[[MarketData sharedInstance] getCurrencies]];
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

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(ok && record) {
        if(record.recordType == RecordTypeKiCurrency) {
            [self updateCurrencies:[[MarketData sharedInstance] getCurrencies]];
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


@end
