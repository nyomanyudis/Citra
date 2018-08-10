//
//  Storage.h
//  Ciptadana
//
//  Created by Reyhan on 10/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

+ (BOOL)storejsonProperties:(NSString *)json;
+ (NSString *)jsonProperties;

@end
