//
//  SearchStock.m
//  Ciptadana
//
//  Created by Reyhan on 11/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SearchStock.h"
#import "NetByStock.h"

#import "StockSuggestionField.h"

@interface SearchStock()

@property (weak, nonatomic) IBOutlet StockSuggestionField *suggestionField;
@property (weak, nonatomic) NSString *stockCode;

@end

@implementation SearchStock

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        //[self performSegueWithIdentifier:@"unwindToNetByBroker" sender:self];
        self.stockCode = stock;
        [self performSegueWithIdentifier:@"unwindToNetByStock" sender:self];
    };
    
    self.suggestionField.callback = stockCallback;
    [self.suggestionField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NetByStock *stock = segue.destinationViewController;
    stock.stockCode = self.stockCode;
}

#pragma mark - private

- (IBAction)cancelButtonTapped:(id)sender
{
    self.stockCode = nil;
    [self performSegueWithIdentifier:@"unwindToNetByStock" sender:self];
}

@end
