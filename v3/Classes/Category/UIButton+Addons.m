//
//  UIButton+Addons.m
//  Ciptadana
//
//  Created by Reyhan on 9/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "UIButton+Addons.h"

@implementation UIButton (Addons)

- (void)clearBackground
{
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundImage:nil forState:UIControlStateNormal];
    [self setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self setBackgroundImage:nil forState:UIControlStateDisabled];
    [self setBackgroundImage:nil forState:UIControlStateSelected];
    
}

@end
