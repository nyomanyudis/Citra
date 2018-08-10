//
//  CitraIdlingWindow.m
//  Ciptadana
//
//  Created by Reyhan on 10/5/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "CitraIdlingWindow.h"
#import "AgentTrade.h"

//NSString * const CitraIdlingWindowIdleNotification   = @"CitraIdlingWindowIdleNotification";
//NSString * const CitraIdlingWindowActiveNotification = @"CitraIdlingWindowActiveNotification";
//
//@interface CitraIdlingWindow (PrivateMethods)
//- (void)windowIdleNotification;
//- (void)windowActiveNotification;
//
//
//@end
//
//
//@implementation CitraIdlingWindow
//@synthesize idleTimer, idleTimeInterval;
//
//- (id) initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.idleTimeInterval = 0;
//    }
//    return self;
//}
//#pragma mark activity timer
//
//- (void)sendEvent:(UIEvent *)event {
//    [super sendEvent:event];
//    
//    NSSet *allTouches = [event allTouches];
//    if ([allTouches count] > 0) {
//        
//        // To reduce timer resets only reset the timer on a Began or Ended touch.
//        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
//        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
//            if (!idleTimer) {
//                [self windowActiveNotification];
//            } else {
//                [idleTimer invalidate];
//            }
//            if (idleTimeInterval != 0) {
//                self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeInterval
//                                                                  target:self
//                                                                selector:@selector(windowIdleNotification)
//                                                                userInfo:nil repeats:NO];
//            }
//        }
//    }
//}
//
//
//- (void)windowIdleNotification {
//    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
//    [dnc postNotificationName:CitraIdlingWindowIdleNotification
//                       object:self
//                     userInfo:nil];
//    self.idleTimer = nil;
//}
//
//- (void)windowActiveNotification {
//    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
//    [dnc postNotificationName:CitraIdlingWindowActiveNotification
//                       object:self
//                     userInfo:nil];
//}
//
//- (void)dealloc {
//    if (self.idleTimer) {
//        [self.idleTimer invalidate];
//        self.idleTimer = nil;
//    }
//}
//
//@end

@implementation CitraIdlingWindow

//here we are listening for any touch. If the screen receives touch, the timer is reset
-(void)sendEvent:(UIEvent *)event
{
    [super sendEvent:event];
    
    if (!myidleTimer)
    {
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
            [self resetIdleTimer];
        }
        
    }
}
//as labeled...reset the timer
-(void)resetIdleTimer
{
    if (myidleTimer)
    {
        [myidleTimer invalidate];
    }
    //convert the wait period into minutes rather than seconds
    int timeout = kApplicationTimeoutInMinutes * 60;
    myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    
}
//if the timer reaches the limit as defined in kApplicationTimeoutInMinutes, post this notification
-(void)idleTimerExceeded
{
    NSLog(@"## cek login feed");
    if([AgentTrade sharedInstance] != nil && [AgentTrade sharedInstance].loginDataTrade != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
    }
}


@end