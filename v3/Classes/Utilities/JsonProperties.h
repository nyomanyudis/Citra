//
//  JsonProperties.h
//  Ciptadana
//
//  Created by Reyhan on 10/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonProperties : NSObject

+ (void)printJsonProperties;
//+ (NSDictionary *)citraiosDictionary:(NSString *)jsonString
//{
//    if(citraios) {
//        return citraios;
//    }
//    else {
//        
//        NSData *jsonData = [self.jsonString dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//        
//        
//        if(!error) {
//            citraios = [jsonObject objectForKey:@"citraios"];;
//            return citraios;
//        }
//    }
//    
//    return nil;
//}

+ (NSDictionary *)setUserId:(NSString*)userid;
+ (NSString *)getUserId;
+ (NSDictionary *)setPassword:(NSString *)password;
+ (NSString *)getPassword;
+ (NSDictionary *)setWatchlist:(NSMutableArray *)watchlist;
+ (NSArray *)getWatchlistStock;
+ (NSDictionary *)setForeignDomestic:(NSMutableArray *)stocks;
+ (NSArray *)getForeignDomestic;

@end
