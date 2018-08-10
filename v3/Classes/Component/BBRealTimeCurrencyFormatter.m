//
//  BBRealTimeCurrencyFormatter.m
//  Ciptadana
//
//  Created by Reyhan on 11/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "BBRealTimeCurrencyFormatter.h"
#import <UIKit/UIKit.h>

@implementation BBRealTimeCurrencyFormatter

//Update textfield with given range and string
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string includeCurrencySymbol:(BOOL)symbol
{
    
    //get current text after typing
    NSString * currentText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //format amount into a string
    NSString *newValueString = [self amountToString:[[self keepOnlyNumbers:currentText] doubleValue] includeCurrencySymbol:symbol];
    
    //update textfield
    [textField setText:newValueString];
    
    return NO;
}


//Remove all characters BUT numbers
+ (nullable NSString *)keepOnlyNumbers:(nonnull NSString *)string
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *exp;
    dispatch_once(&onceToken, ^{
        exp = [NSRegularExpression regularExpressionWithPattern:@"[^\\d]" options:0 error:nil];
    });
    return [exp stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:@""];
}

//Return a currency formatted string
+ (nonnull NSString *)amountToString:(double)amount includeCurrencySymbol:(BOOL)symbol
{
    
//    NSLocale *locale  = [NSLocale currentLocale];
//    
//    //Convert it to currency
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setLocale:locale];
//    
//    //Set currency style
//    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    [numberFormatter setDecimalSeparator:[locale objectForKey:NSLocaleDecimalSeparator]];
//    [numberFormatter setCurrencyGroupingSeparator:[locale objectForKey:NSLocaleGroupingSeparator]];
//    
//    if(!symbol){
//        //Remove currency symbol - This'll avoid NaN results
//        [numberFormatter setCurrencySymbol:@""];
//    }
//    
//    //return new amount string
//    return [numberFormatter stringFromNumber:@(amount / 100.0f)];
    
    if(symbol)
        return [NSString localizedStringWithFormat:@"Rp %.0f", amount/1.f];
    return [NSString localizedStringWithFormat:@"%.0f", amount/1.f];
}

@end
