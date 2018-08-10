//
//  Logger.m
//  Ciptadana
//
//  Created by Reyhan on 1/8/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "Logger.h"

#define LOG_DEBUG NO

@implementation Logger


@end

static NSMutableArray *logs;
static NSDateFormatter *timeFormat;

void logDebug(NSObject *obj)
{
    if(LOG_DEBUG) {
        if(nil == logs || nil == timeFormat) {
            logs = [NSMutableArray array];
            timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"HH:mm:ss"];
        }
    
        NSDate *now = [[NSDate alloc] init];
        NSString *time = [timeFormat stringFromDate:now];
        NSString *log = [NSString stringWithFormat:@"%@ - %@", time, obj];
    
        NSLog(@"%@", log);
    
        [logs insertObject:log atIndex:0];
    }
}

NSMutableArray *getArrayLog()
{
    return logs;
}