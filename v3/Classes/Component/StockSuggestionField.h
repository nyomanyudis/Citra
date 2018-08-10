//
//  StockSuggestionField.h
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^StockSuggestionCallback)(NSString *stock);

@interface StockSuggestionField : UITextField

@property (strong, nonatomic) StockSuggestionCallback callback;

@end
