//
//  UIView+DropShadow.m
//  Ciptadana
//
//  Created by Reyhan on 6/24/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "UIView+DropShadow.h"

@implementation UIView (DropShadow)

- (void)addDropShadow:(UIColor *)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

@end
