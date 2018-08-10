//
//  UIButton+Appearance.m
//  Ciptadanav3
//
//  Created by Reyhan on 7/26/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "UIButton+Appearance.h"

@implementation UIButton (ButtonAppearance)

- (UIFont *)titleFont
{
    return self.titleLabel.font;
}

- (void)setTitleFont:(UIFont *)titleFont
{
//    self = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleLabel.font = titleFont;
}

@end
