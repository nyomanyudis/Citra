//
//  NSString+Addons.m
//  Ciptadana
//
//  Created by Reyhan on 9/29/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NSString+Addons.h"

@implementation NSString (Addons)

- (NSString *)replacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:error];
    return [regex stringByReplacingMatchesInString:self
                                           options:0
                                             range:NSMakeRange(0, self.length)
                                      withTemplate:withTemplate];
}

- (NSString *)replacingString:(NSString *)origin withString:(NSString *)newone
{
    return [self stringByReplacingOccurrencesOfString:origin withString:newone];
}

@end
