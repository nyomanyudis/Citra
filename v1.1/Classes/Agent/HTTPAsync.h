//
//  HTTPAsync.h
//  Ciptadana
//
//  Created by Reyhan on 10/15/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HTTPCallback)(NSString *result, NSError *error);

@protocol HTTPAsyncDelegate <NSObject>

@required
- (void)HTTPOK:(NSString *)result;

@optional
- (void)HTTPERROR:(NSError *)error;

@end

@interface HTTPAsync : NSObject

- (void)delegate:(id <HTTPAsyncDelegate>)delegate;
- (void)callback:(HTTPCallback)callback;
- (void)requestURL:(NSString *)pathUrl;

@end
