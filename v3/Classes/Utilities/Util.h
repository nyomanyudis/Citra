//
//  Util.h
//  Ciptadanav3
//
//  Created by Reyhan on 7/21/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#ifndef Util_h
#define Util_h

//long long stringToHexa(NSString *hexa) {
//    //    NSScanner* scan = [NSScanner scannerWithString: hexa];
//    //
//    //    int value;
//    //    return [scan scanInt:&value];
//    
//    return (UInt64)strtoull([hexa UTF8String], NULL, 16);
//}

#define stringToHexa(hexa) (UInt64)strtoull([hexa UTF8String], NULL, 16)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHex(hexa) UIColorFromRGB(stringToHexa(hexa))

#define COLOR_TITLE_CONTROLLER UIColorFromRGB(0x59554e)
#define COLOR_TITLE_DEFAULT_LABEL UIColorFromRGB(0x333333)
#define COLOR_TITLE_DEFAULT_LABEL_SHADOW UIColorFromRGB(0xf2f2f2)
#define COLOR_TITLE_DEFAULT_BOLD_LABEL UIColorFromRGB(0x333333)
#define COLOR_TITLE_DEFAULT_BOLD_LABEL_SHADOW UIColorFromRGB(0xf2f2f2)
#define COLOR_TITLE_DEFAULT_BUTTON UIColorFromRGB(0x474747)
#define COLOR_TITLE_WHITE_BUTTON UIColorFromRGB(0xf2f2f2)
#define COLOR_TITLE_DEFAULT_BUTTON_HIGHLIGHTED UIColorFromRGB(0xf2f2f2)
#define COLOR_TITLE_DEFAULT_BUTTON_SELECTED UIColorFromRGB(0x0000ff)
#define COLOR_TITLE_DEFAULT_BUTTON_DISABLED UIColorFromRGB(0x999696)
#define COLOR_TITLE_DEFAULT_BUTTON_SHADOW UIColorFromRGB(0xf2f2f2)
#define COLOR_ARROW UIColorFromRGB(0x3f3f3f)
#define COLOR_BORDER_DROPDOWN_BUTTON UIColorFromRGB(0xf2f2f2)
#define COLOR_UITABLEVIEW_SEPARATOR UIColorFromRGB(0xf3f4e5)
#define COLOR_TITLE_DEFAULT_TEXTFIELD UIColorFromRGB(0x474747)
#define COLOR_CLEAR [UIColor clearColor]
#define COLOR_HYPERLINK UIColorFromRGB(0x0645AD)



#define FONT_TITLE_CONTROLLER [UIFont fontWithName:@"Khand-Regular" size:27]
#define FONT_TITLE_DEFAULT_LABEL [UIFont fontWithName:@"Rajdhani-Regular" size:17]
#define FONT_TITLE_BOLD_LABEL [UIFont fontWithName:@"Rajdhani-Bold" size:17]
#define FONT_TITLE_DEFAULT_BOLD_LABEL [UIFont fontWithName:@"Rajdhani-SemiBold" size:15]
#define FONT_TITLE_LABEL_CELL [UIFont fontWithName:@"Rajdhani-Regular" size:13]
#define FONT_TITLE_NUMERIC_LABEL [UIFont fontWithName:@"Dosis-Light" size:17]
#define FONT_TITLE_DEFAULT_BUTTON [UIFont fontWithName:@"Rajdhani-Bold" size:17]
#define FONT_TITLE_DEFAULT_BUTTON_NYOMAN [UIFont fontWithName:@"Rajdhani-Bold" size:5]
#define FONT_TITLE_DEFAULT_BUTTONP_HYPERLINK [UIFont fontWithName:@"Rajdhani-Light" size:17]
#define FONT_TITLE_HEADERCELL_LABEL [UIFont fontWithName:@"Rajdhani-SemiBold" size:13]
#define FONT_TITLE_TEXTFIELD [UIFont fontWithName:@"Rajdhani-Regular" size:19]

#define UDID @"Citra Mobile"



#define GRADIENT_GRAY_SUPERLIGHT [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:204.0/255.0 green:205/255.0 blue:206/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255/255.0 alpha:1.0] CGColor], nil]


#define GREEN UIColorFromRGB(0x278711)
#define RED UIColorFromRGB(0xc62d2d)
#define YELLOW UIColorFromRGB(0xd1ca4f)
#define MAGENTA [UIColor magentaColor]
#define BLACK [UIColor blackColor]
#define WHITE [UIColor whiteColor]


#endif /* Util_h */

