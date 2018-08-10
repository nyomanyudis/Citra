//
//  NSString+StringAdditions.m
//  Ciptadana
//
//  Created by Reyhan on 1/24/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "NSString+StringAdditions.h"

@implementation NSString (StringAdditions)

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

- (NSString *)concat:(NSString *)first
{
    
    return [NSString stringWithFormat:@"%@%@", self, first];
//    va_list args;
//    va_start(args, strings);
//    
//    NSString *s;
//    NSString *con = [self stringByAppendingString:strings];
//    
//    while((s = va_arg(args, NSString *)))
//        con = [con stringByAppendingString:s];
//    
//    va_end(args);
//    return con;
    
//    NSString * result = @"";
//    id eachArg;
//    va_list alist;
//    if(first)
//    {
//        result = [result stringByAppendingString:first];
//        va_start(alist, first);
//        while (eachArg == va_arg(alist, id))
//        {
//            result = [result stringByAppendingString:eachArg];
//        }
//        va_end(alist);
//    }
//    
//    return result;
}

#pragma
#pragma static
+(NSString*)formatWithThousandSeparator:(Float32)number
{
    //  Format a number with thousand seperators, eg: "12,345"
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *result = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:number]];
    return result;
}


@end
