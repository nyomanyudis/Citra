//
//  UIView+DropShadow.h
//  Ciptadana
//
//  Created by Reyhan on 6/24/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DropShadow)

- (void)addDropShadow:(UIColor *)color
           withOffset:(CGSize)offset
               radius:(CGFloat)radius
              opacity:(CGFloat)opacity;

@end
