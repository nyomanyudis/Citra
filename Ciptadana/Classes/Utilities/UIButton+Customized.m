//
//  UIButton+Customized.m
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "UIButton+Customized.h"
#import "ImageResources.h"

@implementation UIButton (Customized)

- (UIButton *)BlackBackgroundCustomized
{
    
    [self setBackgroundImage:[ImageResources imageBlackButton] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageBlackButton] forState:UIControlStateDisabled];
    [self setBackgroundImage:[ImageResources imageBlackButtonHighlighted] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}

- (UIButton *)OrangeBackgroundCustomized
{
    
    [self setBackgroundImage:[ImageResources imageOrangeButton] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageOrangeButtonHighlighted] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}

- (UIButton *)GreenBackgroundCustomized
{
    
    [self setBackgroundImage:[ImageResources imageGreenButton] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageGreenButtonHighlighted] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}

- (UIButton *)RedBackgroundCustomized
{
    [self setBackgroundImage:[ImageResources imageSegmentBottomBarRedFire] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageSegmentDarkGray] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}

- (UIButton *)PurpleBackgroundCustomized
{
    [self setBackgroundImage:[ImageResources imageSegmentPurple] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageSegmentDarkGray] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}

- (UIButton *)BlueBackgroundCustomized
{
    [self setBackgroundImage:[ImageResources imageSegmentBottomBarBlue] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageSegmentDarkGray] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    return self;
}


- (UIButton *)TabBarItemBackgroundCustomized
{
    
    [self setBackgroundImage:[ImageResources imageBackTabBarItem] forState:UIControlStateNormal];
    
    return self;
}


- (UIButton *)ButtonCheckbox
{
    [self setImage:[ImageResources imageUncheck] forState:UIControlStateNormal];
    [self setImage:[ImageResources imageCheck] forState:UIControlStateSelected];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
//    [self addTarget:self action:@selector(buttonCheckboxClicked:) forControlEvents:UIControlEventTouchDown];
    
    return self;
}

//- (void)buttonCheckboxClicked:(id)s
//{
//    if(self.selected)
//        self.selected = NO;
//    else
//        self.selected = YES;
//}

- (UIButton *)DisableButtonCustomized
{
    [self setBackgroundImage:[UIImage imageNamed:@"disableButton.png"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"disableButton.png"] forState:UIControlStateDisabled];
//    [self setBackgroundImage:[ImageResources imageBlackButtonHighlighted] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    return self;
}

@end
