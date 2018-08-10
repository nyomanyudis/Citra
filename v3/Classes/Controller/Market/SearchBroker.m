//
//  SearchBroker.m
//  Ciptadana
//
//  Created by Reyhan on 10/24/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SearchBroker.h"
#import "NetByBroker.h"

#import "BrokerSuggestionField.h"
#import "PDKeychainBindings.h"

@interface SearchBroker()

@property (weak, nonatomic) IBOutlet BrokerSuggestionField *suggestionField;
@property (weak, nonatomic) NSString *brokerCode;

@end

@implementation SearchBroker

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    
    BrokerSuggestionCallback brokerCallback = ^void(NSString* broker) {
        //[self performSegueWithIdentifier:@"unwindToNetByBroker" sender:self];
        self.brokerCode = broker;
        [self performSegueWithIdentifier:@"unwindToNetByBroker" sender:self];
    };
    
    //self.suggestionField.delegate = self;
    self.suggestionField.callback = brokerCallback;
    [self.suggestionField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NetByBroker *broker = segue.destinationViewController;
    broker.brokerCode = self.brokerCode;
}

#pragma mark - private

- (IBAction)cancelButtonTapped:(id)sender
{
    self.brokerCode = nil;
    [self performSegueWithIdentifier:@"unwindToNetByBroker" sender:self];
}

@end
