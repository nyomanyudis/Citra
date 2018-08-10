//
//  HTTPAsync.m
//  Ciptadana
//
//  Created by Reyhan on 10/15/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "HTTPAsync.h"

@interface HTTPAsync() <NSURLConnectionDelegate>

@property (strong, nonatomic) NSMutableData *mResponseData;
@property (strong, nonatomic) id<HTTPAsyncDelegate> delegate;
@property (strong, nonatomic) HTTPCallback callback;

@end

@implementation HTTPAsync

@synthesize mResponseData;


- (void)delegate:(id<HTTPAsyncDelegate>)delegate
{
    self.delegate = delegate;
}

- (void)callback:(HTTPCallback)callback
{
    self.callback = callback;
}

- (void)requestURL:(NSString *)pathUrl
{
    if (nil != pathUrl) {
        NSString *properlyEscapedURL = [pathUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Create the request.
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:20.0];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:properlyEscapedURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
        
        // Create url connection and fire request
        id obj = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        obj = nil;
    }
}

- (void)requestURL:(NSString *)pathUrl params:(NSString *)params
{
    if (nil != pathUrl) {
        // Create the request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathUrl]];
        
        // Specify that it will be a POST request
        request.HTTPMethod = @"POST";
        
        // This is how we set header fields
        [request setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        // Convert your data and set your request's HTTPBody property
        if (nil != params) {
            NSData *requestBodyData = [params dataUsingEncoding:NSUTF8StringEncoding];
            request.HTTPBody = requestBodyData;
        }
        
        // Create url connection and fire request
        id conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        conn = nil;
    }
}

//upload image
//NSString *urlString = @"URL";
//
//NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
//[request setURL:[NSURL URLWithString:urlString]];
//[request setHTTPMethod:@"POST"];
//
//NSString *boundary = @"---------------------------14737809831466499882746641449";
//NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//
//NSMutableData *body = [NSMutableData data];
//[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"Test.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//[body appendData:[NSData dataWithData:imageData]];
//[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//[request setHTTPBody:body];
//
//NSData *returnData = [NSURLConnection  sendSynchronousRequest:request returningResponse:nil error:nil];
//NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //NSLog(@"- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response");
    mResponseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    
    //NSLog(@"- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data ");
    if (nil != mResponseData)
        [mResponseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    //NSLog(@"- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse ");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    //NSLog(@"- (void)connectionDidFinishLoading:(NSURLConnection *)connection");
    
    if (nil != mResponseData) {
        NSString *result = [[NSString alloc] initWithData:mResponseData encoding:NSASCIIStringEncoding];
        
        if (nil != self.delegate)
            [self.delegate HTTPOK:result];
        
        if (nil != self.callback) {
            self.callback(result, nil);
        }
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
    // The request has failed for some reason!
    // Check the error var
    //NSLog(@"- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error: %@", error);
    
    if (nil != self.callback) {
        self.callback(nil, error);
    }
}

@end
