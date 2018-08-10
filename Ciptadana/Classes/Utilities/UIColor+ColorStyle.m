//
//  UIColor+ColorStyle.m
//  Ciptadana
//
//  Created by Reyhan on 9/24/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "UIColor+ColorStyle.h"

@implementation UIColor (ColorStyle)

+ (UIColor*)colorWithHexString:(NSString*)hex
{   
    return [self colorWithHexString:hex alpha:1.0];
}


+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    @try {
        if((nil != rString && ![@"" isEqualToString:rString])
           && (nil != gString && ![@"" isEqualToString:gString])
           && (nil != bString && ![@"" isEqualToString:bString])) {
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Scanner expectoin: %@", exception);
    }
    
    if(alpha > 1)
        alpha = 1;
    else if(alpha < 0)
        alpha = 0;
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
