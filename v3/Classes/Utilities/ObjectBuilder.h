//
//  ObjectBuilder.h
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectBuilder : NSObject

+ (UILabel*)createGridLabel:(CGRect)rect withLabel:(NSString*)label;
+ (UILabel*)createGridLabel:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag;
+ (UILabel*)createGridHeaderLabel:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag;
+ (UIButton*)createGridButton:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag;
+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (UIImageView*)createGridImage:(CGRect)react  andTag:(NSInteger)tag;

@end
