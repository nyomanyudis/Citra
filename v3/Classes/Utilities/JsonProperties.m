//
//  JsonProperties.m
//  Ciptadana
//
//  Created by Reyhan on 10/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "JsonProperties.h"
#import "Storage.h"

static NSDictionary *citraios;

@interface JsonProperties()

@end

@implementation JsonProperties

+ (void)printJsonProperties
{
    NSString *jsonString = self.jsonString;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
    }
    else {
        NSLog(@"jsonObject: %@", jsonObject);
    }
}

// sample
+ (NSString *)jsonString
{
    NSString *json = [Storage jsonProperties];
    if(json)
        return json;
    
    return @"{\"citraios\":{\"userid\":\"\",\"password\":\"\",\"pin\":\"\",\"stockwatch\":\"\",\"watchlist\":[],\"fdnetbuysell\":[],\"netbsbroker\":\"\",\"netbsstock\":\"\"},\"version\":0.1}";
}

+ (void)storeJson
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.citraiosDictionary
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [Storage storejsonProperties:jsonString];
    }
}

+ (NSDictionary *)citraiosDictionary
{
    if(citraios) {
        return citraios;
    }
    else {
        
        NSString *storage = [Storage jsonProperties];
        NSString *json = storage != nil ? storage : self.jsonString;
        
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        
        if(!error) {
            citraios = jsonObject;//[jsonObject objectForKey:@"citraios"];
            return citraios;
        }
    }

    return nil;
}

+ (NSDictionary*)setUserId:(NSString*)userid
{
    if(!userid)
        userid = @"";
    
    NSDictionary *dict = [self citraiosDictionary];
    if(dict) {
        NSMutableDictionary *tmpMutable = [[NSMutableDictionary alloc] initWithDictionary:[dict objectForKey:@"citraios"]];
        [tmpMutable setObject:userid forKey:@"userid"];
        
        NSMutableDictionary *tmp2Mutable = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tmp2Mutable setValue:tmpMutable forKey:@"citraios"];
        
        citraios = nil;
        citraios = tmp2Mutable;
        tmp2Mutable = nil;
        tmpMutable = nil;
        
        [self storeJson];
        
        return citraios;
        
    }
    
    return nil;
}

+ (NSString *)getUserId
{
    if(self.citraiosDictionary) {
        return [[citraios objectForKey:@"citraios"] objectForKey:@"userid"];
    }
    return nil;
}

+ (NSDictionary *)setPassword:(NSString *)password
{
    if(!password)
        password = @"";
    
    NSDictionary *dict = [self citraiosDictionary];
    if(dict) {
        NSMutableDictionary *tmpMutable = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tmpMutable setObject:password forKey:@"password"];
        
        NSMutableDictionary *tmp2Mutable = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tmp2Mutable setValue:tmpMutable forKey:@"citraios"];
        
        citraios = nil;
        citraios = tmp2Mutable;
        tmp2Mutable = nil;
        tmpMutable = nil;
        
        return citraios;
        
    }
    
    return nil;
}

+ (NSString *)getPassword
{
    if(self.citraiosDictionary) {
        return [[citraios objectForKey:@"citraios"] objectForKey:@"password"];
    }
    return nil;
}

+ (NSDictionary *)getCitraios
{
    if(self.citraiosDictionary) {
        NSDictionary *citra = [citraios objectForKey:@"citraios"];
        return citra;
    }
    return nil;
}

+ (NSDictionary *)setWatchlist:(NSMutableArray *)watchlist
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getCitraios]];
    if(dict) {
        
        NSMutableArray *watchlistMutable = [NSMutableArray arrayWithCapacity:watchlist.count];
        for(int n = 0; n < watchlist.count; n ++) {
            NSString *stock = [watchlist objectAtIndex:n];
            NSDictionary *tmpDict = [NSDictionary dictionaryWithObject:stock forKey:@"stock"];
            [watchlistMutable addObject:tmpDict];
        }
        
        NSMutableDictionary *tmpMutable = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tmpMutable setObject:watchlistMutable forKey:@"watchlist"];
        
        citraios = nil;
        citraios = [NSDictionary dictionaryWithObject:tmpMutable forKey:@"citraios"];
        
        [self storeJson];
        
        return tmpMutable;
        
    }
    return nil;
}

+ (NSArray *)getWatchlistStock
{
    NSDictionary *dict = [self getCitraios];
    if(dict) {
        NSMutableDictionary *tmpMutable = [[[NSMutableDictionary alloc] initWithDictionary:dict] objectForKey:@"watchlist"];
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *inDict in tmpMutable) {
            [array addObject:[inDict objectForKey:@"stock"]];
        }
        
        return array;
    }
    return nil;
}

+ (NSDictionary *)setForeignDomestic:(NSMutableArray *)stocks
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self getCitraios]];
    if(dict) {
        
        NSMutableArray *stockstMutable = [NSMutableArray arrayWithCapacity:stocks.count];
        for(int n = 0; n < stocks.count; n ++) {
            NSString *stock = [stocks objectAtIndex:n];
            NSDictionary *tmpDict = [NSDictionary dictionaryWithObject:stock forKey:@"stock"];
            [stockstMutable addObject:tmpDict];
        }
        
        NSMutableDictionary *tmpMutable = [[NSMutableDictionary alloc] initWithDictionary:dict];
        [tmpMutable setObject:stockstMutable forKey:@"fdnetbuysell"];
        
        citraios = nil;
        citraios = [NSDictionary dictionaryWithObject:tmpMutable forKey:@"citraios"];
        
        [self storeJson];
        
        return tmpMutable;
        
    }
    return nil;
}

+ (NSArray *)getForeignDomestic
{
    NSDictionary *dict = [self getCitraios];
    if(dict) {
        NSMutableDictionary *tmpMutable = [[[NSMutableDictionary alloc] initWithDictionary:dict] objectForKey:@"fdnetbuysell"];
        NSMutableArray *array = [NSMutableArray array];
        for(NSDictionary *inDict in tmpMutable) {
            [array addObject:[inDict objectForKey:@"stock"]];
        }
        
        return array;
    }

    return nil;
}

@end


// {"citraios":{"userid":"","password":"","pin":"","stockwatch":"","watchlist":[{"stock":"bumi"},{"stock":"isat"}],"fdnetbuysell":[{"stock":"nrca"}],"netbsbroker":"","netbsstock":""},"version":0}
