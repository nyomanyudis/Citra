//
//  ThemeManager.h
//  Ciptadanav3
//
//  Created by Reyhan on 7/27/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class Theme;
@class GoldTheme;

@interface ThemeManager : NSObject

+(id)createTheme;

@property (strong, nonatomic) Theme *theme;

@end

@interface Theme : NSObject

- (void)decorate;

@end


@interface GoldTheme : Theme

@end