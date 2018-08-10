//
//  RedTheme.m
//  Ciptadanav3
//
//  Created by Reyhan on 7/27/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "RedTheme.h"
#import "ThemeUITableViewCell.h"

@implementation RedTheme

- (void) decorate
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[ThemeUITableViewCell class]]] setBackgroundColor:[UIColor yellowColor]];
}

@end
