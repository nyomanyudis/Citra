//
//  BBRealTimeCurrencyFormatter.h
//  Ciptadana
//
//  Created by Reyhan on 11/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITextField;

@interface BBRealTimeCurrencyFormatter : NSObject

//Update textfield with given range and string
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string includeCurrencySymbol:(BOOL)symbol;

@end
