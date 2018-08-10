//
//  SearchStockWatch.m
//  Ciptadana
//
//  Created by Reyhan on 10/27/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SearchStockWatch.h"
#import "StockWatch.h"

#import "StockSuggestionField.h"

@interface SearchStockWatch()

@property (weak, nonatomic) IBOutlet StockSuggestionField *suggestionField;
@property (weak, nonatomic) NSString *stockCode;

@end

@implementation SearchStockWatch

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        //[self performSegueWithIdentifier:@"unwindToNetByBroker" sender:self];
        self.stockCode = stock;
        [self performSegueWithIdentifier:@"unwindToStockWatch" sender:self];
    };
    
    self.suggestionField.callback = stockCallback;
    [self.suggestionField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StockWatch *watch = segue.destinationViewController;
    watch.stockCode = self.stockCode;
}

#pragma mark - private

- (IBAction)cancelButtonTapped:(id)sender
{
    self.stockCode = nil;
    [self performSegueWithIdentifier:@"unwindToStockWatch" sender:self];
}

@end
