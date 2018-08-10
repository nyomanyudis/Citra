//
//  CitraIdlingWindow.h
//  Ciptadana
//
//  Created by Reyhan on 10/5/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//extern NSString * const CitraIdlingWindowIdleNotification;
//extern NSString * const CitraIdlingWindowActiveNotification;
//
//@interface CitraIdlingWindow : UIWindow {
//    NSTimer *idleTimer;
//    NSTimeInterval idleTimeInterval;
//}
//
//@property (assign) NSTimeInterval idleTimeInterval;
//
//@property (nonatomic, retain) NSTimer *idleTimer;
//
//
//@end

#import <Foundation/Foundation.h>

//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 5

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"CitraIdlingWindow"

@interface CitraIdlingWindow : UIApplication
{
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;

@end
