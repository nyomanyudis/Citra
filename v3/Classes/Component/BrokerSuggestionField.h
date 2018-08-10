//
//  BrokerSuggestionField.h
//  Ciptadana
//
//  Created by Reyhan on 10/24/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BrokerSuggestionCallback)(NSString *broker);

@interface BrokerSuggestionField : UITextField

@property (strong, nonatomic) BrokerSuggestionCallback callback;

@end
