//
//  UITextField+Addons.m
//  Ciptadana
//
//  Created by Reyhan on 9/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//


//#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "UIViewController+Addons.h"

@implementation UIViewController (Addons)

- (void)initLinearGradient:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
//    gradient.startPoint = CGPointMake(0.2, 1);
//    gradient.endPoint = CGPointZero;
    gradient.startPoint = startPoint;
    gradient.endPoint = endPoint;
    //    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:34.0/255.0 green:211/255.0 blue:198/255.0 alpha:1.0] CGColor],
    //                       (id)[[UIColor colorWithRed:145/255.0 green:72.0/255.0 blue:203/255.0 alpha:1.0] CGColor], nil];
    gradient.colors = colors;
    [self.view.layer addSublayer:gradient];
}

@end
