//
//  NSArray+Addons.m
//  Ciptadana
//
//  Created by Reyhan on 10/17/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NSArray+Addons.h"

@implementation NSArray (Addons)

- (BOOL)isUnique:(NSString *)string
{
    if(self && [self count] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", string]; // if you need case sensitive search avoid '[c]' in the predicate
        
        NSArray *results = [self filteredArrayUsingPredicate:predicate];
        
        if(results.count > 0)
            return NO;
    }
    return YES;
}

@end
