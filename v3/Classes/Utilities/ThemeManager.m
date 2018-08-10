//
//  ThemeManager.m
//  Ciptadanav3
//
//  Created by Reyhan on 7/27/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "ThemeManager.h"

#import "ThemeUITableViewCell.h"
#import "UIBoldLabel.h"

#import "UIButton+Appearance.h"
#import "UIButton+Addons.h"

#import "HKKScrollableGridView.h"

#import "Util.h"

@implementation ThemeManager

#pragma mark singleton
+ (id)createTheme
{
    static ThemeManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id) init
{
    if(self = [super init]) {
        self.theme = [[GoldTheme alloc] init];
        
    }
    
    return self;
}

- (void)setTheme:(Theme *)theme
{
    [theme decorate];
}


@end


@implementation Theme

//- (id)init
//{
//    if(self = [super init]) {
//        [self decorate];
//    }
//    
//    return self;
//}

- (void) decorate
{
    
}

@end

@implementation GoldTheme

- (void) decorate
{
    NSDictionary *attributeTitleController = @{NSForegroundColorAttributeName:COLOR_TITLE_CONTROLLER,
                                               NSFontAttributeName:FONT_TITLE_CONTROLLER};
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    //[[UINavigationBar appearance] setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];//remove underline
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];//remove underline
    [[UINavigationBar appearance] setTitleTextAttributes:attributeTitleController];
    
    [[UILabel appearance] setFont:FONT_TITLE_DEFAULT_LABEL];
    [[UILabel appearance] setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    //[[UILabel appearance] setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    //[[UILabel appearance] setShadowColor:[UIColor clearColor]];
    
    [[UIBoldLabel appearance] setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
    [[UIBoldLabel appearance] setTextColor:COLOR_TITLE_DEFAULT_BOLD_LABEL];
    //[[UIBoldLabel appearance] setShadowColor:COLOR_TITLE_DEFAULT_BOLD_LABEL_SHADOW];
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"bgnormal"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *buttonHighlighted = [[UIImage imageNamed:@"bgtapped"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    UIImage *buttonSelected = [UIImage imageNamed:@"gray3"];
//    UIImage *buttonDisabled = [UIImage imageNamed:@"gray4"];
    [[UIButton appearance] setBackgroundImage:buttonNormal forState:UIControlStateNormal];
    [[UIButton appearance] setBackgroundImage:buttonHighlighted forState:UIControlStateHighlighted];
//    [[UIButton appearance] setBackgroundImage:buttonSelected forState:UIControlStateSelected];
//    [[UIButton appearance] setBackgroundImage:buttonDisabled forState:UIControlStateDisabled];
    [[UIButton appearance] setTitleColor:COLOR_TITLE_DEFAULT_BUTTON forState:UIControlStateNormal];
    //[[UIButton appearance] setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
    [[UIButton appearance] setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_HIGHLIGHTED forState:UIControlStateHighlighted];
    //[[UIButton appearance] setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateHighlighted];
    [[UIButton appearance] setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_DISABLED forState:UIControlStateDisabled];
    //[[UIButton appearance] setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateDisabled];
    [[UIButton appearance] setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_SELECTED forState:UIControlStateSelected];
    //[[UIButton appearance] setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateSelected];
    [[UIButton appearance] setTitleFont:FONT_TITLE_DEFAULT_BUTTON];
    
    UIImage *blueBox = [[UIImage imageNamed:@"bluebox"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *blackBox = [[UIImage imageNamed:@"blackbox"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    //UIImage *blueBox = [[UIImage imageNamed:@"bluebox"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    //UIImage *blackBox = [[UIImage imageNamed:@"blackbox"] resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setBackgroundImage:blueBox forState:UIControlStateNormal];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setBackgroundImage:blackBox forState:UIControlStateHighlighted];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setTitleColor:COLOR_TITLE_DEFAULT_BUTTON_HIGHLIGHTED forState:UIControlStateNormal];
    //[[UIButton appearanceWhenContainedInInstancesOfClasses:@[[UIToolbar class]]] setTitleShadowColor:COLOR_TITLE_DEFAULT_BUTTON_SHADOW forState:UIControlStateNormal];
    
    
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"longbar"]]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setFont:FONT_TITLE_HEADERCELL_LABEL];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    //[[UILabel appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setBackgroundColor:[UIColor clearColor]];
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]] setFont:FONT_TITLE_LABEL_CELL];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]] setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    //[[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]] setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]] setBackgroundColor:[UIColor clearColor]];
        
    //[[UITableView appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"brushed_alu"]]];
    //[[UITableView appearance] setSeparatorColor:[UIColor clearColor]];
    [[UITableView appearance] setSeparatorColor:COLOR_UITABLEVIEW_SEPARATOR];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 10, 4)];
    left.backgroundColor = RED;
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(4, 4, 10, 4)];
    right.backgroundColor = MAGENTA;
    [[UITextField appearance] setTextColor:COLOR_TITLE_DEFAULT_TEXTFIELD];
    [[UITextField appearance] setFont:FONT_TITLE_TEXTFIELD];
    [[UITextField appearance] setLeftView:left];
    [[UITextField appearance] setRightView:right];
    [[UITextField appearance] setBorderStyle:UITextBorderStyleRoundedRect];
//    [[UITextField appearance] setLeftViewMode:UITextFieldViewModeAlways];
//    [[UITextField appearance] setRightViewMode:UITextFieldViewModeAlways];
    //[[UITextField appearance] setBackground:[[UIImage imageNamed:@"uitextfieldbg"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)]];
    [[UITextField appearance] setBackground:[[UIImage imageNamed:@"uitextfieldbgnormal"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 24, 24, 24)]];
    [[UITextField appearance] setDisabledBackground:[[UIImage imageNamed:@"uitextfieldbgdisabled"] resizableImageWithCapInsets:UIEdgeInsetsMake(24, 24, 24, 24)]];
    [[UITextField appearance] setBorderStyle:UITextBorderStyleNone];
    //[[UITextField appearance] setAutocorrectionType:UITextAutocorrectionTypeNo];
    //[[UITextField appearance] setSpellCheckingType:UITextSpellCheckingTypeNo];
    
    //[[UITextField appearance] setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}]];
    
    [[UIToolbar appearance]setBackgroundImage:[UIImage imageNamed:@"boxpattern"] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    //[[UIToolbar appearance] setShadowImage:nil forToolbarPosition:UIBarPositionBottom];
    
//    UIImage *imageLeft = [UIImage imageNamed:@"plus"];
//    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
//    [btn setImage:imageLeft forState:UIControlStateNormal];
//    [btn clearBackground];
//    //[self.backButton setCustomView:btn];
//    
//    [[UINavigationBar appearance] setBackIndicatorImage:imageLeft];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:imageLeft];

}

@end

