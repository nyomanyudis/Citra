//
//  Calendar.m
//  Ciptadana
//
//  Created by Reyhan on 6/9/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "Calendar.h"

@implementation Calendar

+ (NSString *)relativeDateStringForDate:(NSDate *)date
{
    return [Calendar relativeDateStringForDate:date toDate:[NSDate date]];
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date toDate:(NSDate *)todate
{
    
    if (nil == date || todate == nil) {
        return nil;
    }
    
    NSCalendarUnit units = NSDayCalendarUnit | NSWeekOfYearCalendarUnit |
    NSMonthCalendarUnit | NSYearCalendarUnit;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:todate
                                                                    options:0];
    
    if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

//+ (BOOL)isYesterdayForDate:(NSDate *)date
//{
////    NSCalendarUnit units = NSDayCalendarUnit | NSWeekOfYearCalendarUnit |
////    NSMonthCalendarUnit | NSYearCalendarUnit;
////    
////    // if `date` is before "now" (i.e. in the past) then the components will be positive
////    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
////                                                                   fromDate:date
////                                                                     toDate:[NSDate date]
////                                                                    options:0];
////    if (components.day > 0) {
////        return YES;
////    }
////    
////    return NO;
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = DATE_FORMAT;
//    
//    NSString *date0 = [formatter stringFromDate:[NSDate date]];
//    int year0 = [[date0 substringWithRange:NSMakeRange(0, 4)] intValue];
//    int month0 = [[date0 substringWithRange:NSMakeRange(5, 2)] intValue];
//    int day0 = [[date0 substringWithRange:NSMakeRange(8, 2)] intValue];
//    
//    
//    
//    return YES;
//}

+ (NSString *)currentStringDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *currentDate = [NSDate date];
    return [formatter stringFromDate:currentDate];
}

@end
