//
//  UIColor+ColorStyle.h
//  Ciptadana
//
//  Created by Reyhan on 9/24/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorStyle)

+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (UIColor*)colorWithHexString:(NSString*)hex alpha:(CGFloat)alpha;

@end
