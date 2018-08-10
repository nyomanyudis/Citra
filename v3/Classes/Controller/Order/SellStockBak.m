//
//  SellStock.m
//  Ciptadana
//
//  Created by Reyhan on 11/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SellStockBak.h"
#import "SellStockPutPrice.h"
#import "StockSuggestionField.h"
#import "UITextField+Addons.h"

@interface SellStockBak ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet StockSuggestionField *stockSuggestion;

@end

@implementation SellStockBak

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribeOrderList];
    }
    
    [self performSelector:@selector(stockFieldCallback)];
    [self.stockSuggestion initRightButtonKeyboardToolbar:@"Next" target:self selector:@selector(nextStep:)];
    [self.stockSuggestion becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"putSellPriceIdentifier"]) {
        SellStockPutPrice *vc = (SellStockPutPrice *) segue.destinationViewController;
        if(vc) {
            // Pass any objects to the view controller here, like...
            vc.stockCode = [self.stockSuggestion.text uppercaseString];
        }
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self nextStep:nil];
    return YES;
}

#pragma  mark - private

- (void)stockFieldCallback
{
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        stock = [stock uppercaseString];
        self.stockSuggestion.text = stock;
        
        //[self performSegueWithIdentifier:@"putPriceIdentifier" sender:nil];
        [self nextStep:nil];
    };
    
    self.stockSuggestion.callback = stockCallback;
}

- (void)nextStep:(id)sender
{
    if(self.stockSuggestion.text.length > 0)
        [self performSegueWithIdentifier:@"putSellPriceIdentifier" sender:nil];
}

@end