//
//  NSDate+DateUltimate.m
//  Ciptadana
//
//  Created by Reyhan on 6/10/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "NSDate+DateUltimate.h"

@implementation NSDate (DateUltimate)

-(BOOL) isEqualTo:(NSDate*)date {
    /**
     if ([date1 compare:date2] == NSOrderedDescending) {
     NSLog(@"date1 is later than date2");
     } else if ([date1 compare:date2] == NSOrderedAscending) {
     NSLog(@"date1 is earlier than date2");
     } else {
     NSLog(@"dates are the same");
     }
     **/
    return !([self compare:date] == NSOrderedSame);
}

//-(BOOL) isEarlierThanOrEqualTo:(NSDate*)date {
//    return !([self compare:date] == NSOrderedDescending);
//}
-(BOOL) isLaterThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedDescending);
    
}
-(BOOL) isEarlierThan:(NSDate*)date {
    return ([self compare:date] == NSOrderedAscending);
}

- (NSDate *) dateByAddingDays:(int)days {
    NSDate *retVal;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    retVal = [gregorian dateByAddingComponents:components toDate:self options:0];
    return retVal;
}

@end
