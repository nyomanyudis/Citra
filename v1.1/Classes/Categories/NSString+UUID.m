//
//  NSString+UUID.m
//  Ciptadana
//
//  Created by Reyhan on 9/24/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)uuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }
    return uuidString;
}


@end
