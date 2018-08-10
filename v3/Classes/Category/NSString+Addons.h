//
//  NSString+Addons.h
//  Ciptadana
//
//  Created by Reyhan on 9/29/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addons)

- (NSString *)replacingWithPattern:(NSString *)pattern withTemplate:(NSString *)withTemplate error:(NSError **)error;
- (NSString *)replacingString:(NSString *)origin withString:(NSString *)newone;

@end
