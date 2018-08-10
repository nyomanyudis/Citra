//
//  ObjectBuilder.m
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "ObjectBuilder.h"
#import "Util.h"

@implementation ObjectBuilder

+ (UILabel*)createGridLabel:(CGRect)rect withLabel:(NSString*)label
{
    return [self createGridLabel:rect withLabel:label andTag:0];
}

+ (UILabel*)createGridLabel:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag
{
    UILabel* uilabel = [[UILabel alloc] initWithFrame:rect];
    uilabel.text = label;
    uilabel.tag = tag;
//    uilabel.layer.borderWidth = 0.9f;
//    uilabel.layer.borderColor = [self colorWithHexString:@"f1f1f1"].CGColor;
    uilabel.textAlignment = NSTextAlignmentCenter;
    
    [uilabel setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
    [uilabel setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    [uilabel setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [uilabel setBackgroundColor:[UIColor clearColor]];
    
    
//    NSScanner *scanner = [NSScanner scannerWithString:label];
//    float val;
//    BOOL isNumeric = [scanner scanFloat:&val] && [scanner isAtEnd];
//    if(isNumeric)
//        uilabel.textAlignment = NSTextAlignmentRight;
//    else
//        uilabel.textAlignment = NSTextAlignmentLeft;
    
    return uilabel;
}

+ (UIImageView*)createGridImage:(CGRect)react  andTag:(NSInteger)tag
{
    UIImageView* uiImageView = [[UIImageView alloc] initWithFrame:react];
    uiImageView.tag = tag;
    
    return uiImageView;
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UILabel*)createGridHeaderLabel:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag
{
    
    UILabel* uilabel = [[UILabel alloc] initWithFrame:rect];
    uilabel.text = label;
    uilabel.tag = tag;
//    uilabel.layer.borderWidth = 0.9f;
//    uilabel.layer.borderColor = [self colorWithHexString:@"f1f1f1"].CGColor;
    uilabel.textAlignment = NSTextAlignmentCenter;
    
    [uilabel setFont:FONT_TITLE_DEFAULT_BOLD_LABEL];
    [uilabel setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    [uilabel setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [uilabel setBackgroundColor:[UIColor clearColor]];
    
    return uilabel;
}

+ (UIButton*)createGridButton:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:label forState:UIControlStateNormal];
    [button setTitle:label forState:UIControlStateSelected];
    [button setTitle:label forState:UIControlStateHighlighted];
    [button setTitle:label forState:UIControlStateFocused];
    button.tag = tag;
    button.frame = rect;
    
    return button;
}

@end
