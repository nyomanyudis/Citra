//
//  Storage.m
//  Ciptadana
//
//  Created by Reyhan on 10/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "Storage.h"

#define STORAGEKEY @"0Dcdk3klsfj86A3mfOmEOlkdfo9DKd312"

@implementation Storage

+ (BOOL)storejsonProperties:(NSString *)json
{
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:STORAGEKEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)jsonProperties
{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString *json = [prefs stringForKey:STORAGEKEY];

    return [[NSUserDefaults standardUserDefaults] stringForKey:STORAGEKEY];
}

@end
