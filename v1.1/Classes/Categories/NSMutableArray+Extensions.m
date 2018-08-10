//
//  NSMutableArray+Extensions.m
//  Ciptadana
//
//  Created by Reyhan on 7/1/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "NSMutableArray+Extensions.h"

@implementation NSMutableArray (Extensions)

- (void)removeDuplicateObjects
{
    NSArray *copy = [self copy];
    NSUInteger total = copy.count;
    for (NSUInteger i = total - 1; i > 0; i--)
    {
        id obj = [copy objectAtIndex:i];
        if ([self indexOfObject:obj inRange:NSMakeRange(0, i)] != NSNotFound)
        {
            [self removeObjectAtIndex:i];
        }
    }
}

- (void)removeDuplicatedSortedArray
{
    NSArray *copy = [self copy];
    uint32_t total = (uint32_t)(copy.count - 2);
    for (uint32_t i = 0; i < total; i ++) {
        if ([[[copy objectAtIndex:i] description] isEqual:[[copy objectAtIndex:(i + 1)] description]]) {
            
        }
    }
}

@end
