//
//  SysAdmin.m
//  Ciptadana
//
//  Created by Reyhan on 9/28/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SysAdmin.h"

#import "SettingV3.h"
#import "GCDAsyncSocket.h"
#import "Connectivity.h"
#import "Util.h"

#import "Agent.h"


static SysAdmin *sysAdmin;

@interface SysAdmin() <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *asyncSocket;

@end

@implementation SysAdmin

+ (SysAdmin *)sharedInstance
{
//    NSLog(@"SysAdmin Step 1");
    if(sysAdmin == nil)
        sysAdmin = [[SysAdmin alloc] init];
    
    return sysAdmin;
}

#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"SysAdmin didConnectToHost");
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];
    
    //ready login (set callback)
    TradingMessage_Builder *builder = [TradingMessage builder];
    LoginData_Builder *login_builder = [LoginData builder];
    login_builder.sessionMi = @"-1";
    builder.recStatusReturn = StatusReturnResult;
    builder.recType = RecordTypeLoginMi;
    builder.recLoginData = [login_builder build];
    
    if(sysAdmin != nil && sysAdmin.callback != nil)
        sysAdmin.callback([builder build], @"", YES);

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"SysAdmin didReadData");
    NSLog(@"tag = %ld",tag);
    if (0 == tag) {
        NSInteger bodyLength = [self parseHeader:data];
        [sock readDataToLength:bodyLength withTimeout:-1.0 tag:1];
    }
    else if(1 == tag) {
        
        [self parseReadData:data];
        [sock readDataToLength:4 withTimeout:-1.0 tag:0];
        
    }
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
//    NSLog(@"SysAdmin Step 4");
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
//    NSLog(@"SysAdmin Step 5");
    NSLog(@"%s error: %@ %@", __PRETTY_FUNCTION__, err, sock.connectedHost);
}

- (NSInteger)parseHeader:(NSData *)data
{
//    NSLog(@"SysAdmin Step 6");
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}

#pragma public

-(void) firstSettingIPAndPort
{
    //to save setting
    NSString *host;
    NSNumber *port;
    NSString *stringpopupStatus;
    
    NSString *json = [[NSUserDefaults standardUserDefaults] stringForKey:STORAGESETTINGKEY];
    
    if(json) {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSError *error;
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSMutableDictionary *dictSetting = [jsonObject objectForKey:@"setting"];
        if(dictSetting) {
            
            
            host = [dictSetting objectForKey:@"HOST"];
            port = [dictSetting objectForKey:@"PORT"];
            stringpopupStatus = [dictSetting objectForKey:@"POPUPSTATUS"];
            
        }
        
    }
    else{
        host = AGENTTRADE_HOST;
        port = [NSNumber numberWithInt:AGENTTRADE_PORT];
        stringpopupStatus = @"YES";
    }
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:host forKey:@"HOST"];
    [dictionary setValue:port forKey:@"PORT"];
    [dictionary setValue:stringpopupStatus forKey:@"POPUPSTATUS"];
    
    NSDictionary *dictSet = [NSDictionary dictionaryWithObject:dictionary forKey:@"setting"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictSet
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:jsonString forKey:STORAGESETTINGKEY];
    
}

- (void)doLogin:(NSString *)userid andPassword:(NSString *)passwd;
{
    
    RequestData_Builder *builder = [RequestData builder];
    builder.username = userid;
    builder.password = passwd;
    builder.loginType = LOGINTYPE;
    builder.version = VERSION;
    builder.recordType = RecordTypeLoginMi;
    builder.requestType = RequestGet;
    builder.applicationType = APPLICATIONTYPE;
    builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDMARKETSESSION];
    builder.ipAddress = UDID;
    
//    NSLog(@"Request Data Builder = %@",[builder build]);
    
    [self subscribeBuidler:builder];
}

- (void)setupAndLoginSysAdmin:(SysAdminCallback)callback
{
    NSLog(@"SysAdmin Setup And Login SysAdmin");
    if(isConnectivityAvailable()) {
        @try {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            [self firstSettingIPAndPort];
            
            sysAdmin.callback = callback;
            
            if(self.asyncSocket != nil)
                [self.asyncSocket disconnect];
            
            self.asyncSocket = nil;
            self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
            
            NSError *error;
            
            
            //untuk mensetting ip dan port
            NSString *host = AGENTTRADE_HOST;
            int32_t port = AGENTTRADE_PORT;
            
            SettingApp *set = [SettingV3 loadSetting];
            if(set && set.port > 0 && set.port != -1) {
                host = set.host;
                port = set.port;
            }
            
            NSLog(@"SYSADMIN HOST:%@, PORT:%i", host, port);
            
            if (![self.asyncSocket connectToHost:host onPort:port withTimeout:10 error:&error]) {
                NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
            }
            
        } @catch (NSException *exception) {
            NSLog(@"%s SYSADMIN exception: %@", __PRETTY_FUNCTION__, exception);
        }
    }
    else {
        callback(nil, @"No Network Available", NO);
    }
}


#pragma private

- (void)subscribeBuidler:(RequestData_Builder *)builder
{
    NSLog(@"SysAdmin subscribeBuilder");
    TradingMessage *message = [[[TradingMessage builder] setRecReqDataBuilder:builder] build];
    
    uint32_t fileLength = CFSwapInt32((uint32_t)message.data.length);
    NSData *lengthData = [NSData dataWithBytes:&fileLength length:sizeof(4)];
    
    NSMutableData *mutable = [NSMutableData dataWithData:lengthData];
    [mutable appendData:message.data];
    
    [self.asyncSocket writeData:mutable withTimeout:-1 tag:0];
    
}

- (void)parseReadData:(NSData*)data
{
    NSLog(@"SysAdmin parse Read Data");
    @try {
        TradingMessage *msg = [TradingMessage parseFromData:data];
//        NSLog(@"msg = %@",msg);
        if(sysAdmin != nil && sysAdmin.callback != nil) {
            sysAdmin.callback(msg, nil, YES);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s [***] exception %@", __PRETTY_FUNCTION__, exception);
    }
}

@end
