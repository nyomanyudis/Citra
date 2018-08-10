//
//  UIViewController+Controller.m
//  Ciptadana
//
//  Created by Reyhan on 6/13/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "UIViewController+Controller.h"

@implementation UIViewController (Controller)

//+ (UIViewController *)topViewController
//{
//    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//}
//
//+ (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//    if (rootViewController.presentedViewController == nil) {
//        return rootViewController;
//    }
//
//    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
//        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
//        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
//        return [self topViewController:lastViewController];
//    }
//
//    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
//    return [self topViewController:presentedViewController];
//}

- (UIViewController *)currentViewController
{
    if (self.presentedViewController == nil)
        return self;
    
    if ([self.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return lastViewController;
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return presentedViewController;
}

@end
