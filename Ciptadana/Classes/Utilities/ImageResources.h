//
//  ImageResources.h
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResources : NSObject

+ (UIImage *)imageBlackButton;
+ (UIImage *)imageBlackButtonHighlighted;

+ (UIImage *)imageOrangeButton;
+ (UIImage *)imageOrangeButtonHighlighted;

+ (UIImage *)imageGreenButton;
+ (UIImage *)imageGreenButtonHighlighted;

+ (UIImage *)imageStockUp;
+ (UIImage *)imageStockDown;

+ (UIImage *)imageCiptadana;

+ (UIImage *)imageThumb;

+ (UIImage *)imageBackTabBarItem;

+ (UIImage *)imageCheck;
+ (UIImage *)imageUncheck;

+ (UIImage *)imageHome;
+ (UIImage *)imageBack;


+ (UIImage *)imageSegmentRedDivider;
+ (UIImage *)imageSegmentBlueDivider;
+ (UIImage *)imageSegmentDarkGray;
+ (UIImage *)imageSegmentGreen;
+ (UIImage *)imageSegmentPurple;
+ (UIImage *)imageSegmentBottomBarRedFire;
+ (UIImage *)imageSegmentBottomBarRedFirePressed;
+ (UIImage *)imageSegmentBottomBarBlue;
+ (UIImage *)imageSegmentBottomBarBluePressed;

UIImage* separatorImage();

@end
