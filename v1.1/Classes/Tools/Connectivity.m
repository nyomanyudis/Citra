//
//  Connectivity.m
//  Ciptadana
//
//  Created by Reyhan on 6/9/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "Connectivity.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation Connectivity

BOOL isConnectivityAvailable()
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress)); // ?? idknyoman
    zeroAddress.sin_len = sizeof(zeroAddress); // ukuran untuk struct zeroAddress adalah 16 bytes
    zeroAddress.sin_family = AF_INET; // ?? idknyoman
    
    // Recovery reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr*) &zeroAddress); // The handle to a network address or name.
    SCNetworkReachabilityFlags flags; // Flags that indicate the reachability of a network node name or address, including whether a connection is required, and whether some user intervention might be required when establishing a connection.
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags); // Determines if the specified network target is reachable using the current network configuration.
    
    CFRelease(defaultRouteReachability); // Releases a Core Foundation object.
    
    if(!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

@end
