//
//  AgentSysadmin.m
//  Ciptadana
//
//  Created by Reyhan on 5/30/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "AgentFeed.h"
#import "AgentSysadmin.h"
#import "GCDAsyncSocket.h"
#import "UIBAlertView.h"
#import "Connectivity.h"


static AgentSysadmin *agentSysadmin;

@interface AgentSysadmin() <GCDAsyncSocketDelegate>

@property GCDAsyncSocket *asyncSocket;
@property (nonatomic, copy) AgentSysadmincCallback callback;
@property (assign, nonatomic) id objectSelector;
@property (assign, nonatomic) SEL selector;

- (void) runAgent;

@end

@implementation AgentSysadmin

+ (AgentSysadmin *)sharedInstance
{
    if(agentSysadmin == nil) {
        agentSysadmin = [[AgentSysadmin alloc] init];
    }
    return agentSysadmin;
}

#pragma mark -
#pragma private

- (void)runAgent
{
    @try {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        if(self.asyncSocket != nil)
            [self.asyncSocket disconnect];
        
        self.asyncSocket = nil;
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        NSError *error;
        
        NSLog(@"SYSADMIN HOST:%@, PORT:%i", AGENTTRADE_HOST, AGENTTRADE_PORT);
        
        if (![self.asyncSocket connectToHost:AGENTTRADE_HOST onPort:AGENTTRADE_PORT withTimeout:10 error:&error]) {
            NSLog(@"%s [***] Unable to connect to due to invalid configuration: %@", __PRETTY_FUNCTION__, error);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%s SYSADMIN exception: %@", __PRETTY_FUNCTION__, exception);
    }
}

- (void)subscribeBuidler:(RequestData_Builder *)builder
{
    TradingMessage *message = [[[TradingMessage builder] setRecReqDataBuilder:builder] build];
    
    uint32_t fileLength = CFSwapInt32((uint32_t)message.data.length);
    NSData *lengthData = [NSData dataWithBytes:&fileLength length:sizeof(4)];
    
    NSMutableData *mutable = [NSMutableData dataWithData:lengthData];
    [mutable appendData:message.data];
    
    [self.asyncSocket writeData:mutable withTimeout:-1 tag:0];
    
}

#pragma mark -
#pragma public

- (void)startAgent
{
    if (isConnectivityAvailable()) {
        [NSTimer scheduledTimerWithTimeInterval:.15 target:agentSysadmin selector:@selector(runAgent) userInfo:nil repeats:NO];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *title = @"No Network Connection";
            NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
            NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
            
            
            [[[UIBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
        });
    }
}

- (void)loginSysadmin:(NSString *)userid passwd:(NSString *)passwd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *udid = [defaults objectForKey:@"userIdentifier"];
    
    RequestData_Builder *builder = [RequestData builder];
    builder.username = userid;
    builder.password = passwd;
    builder.loginType = LOGINTYPE;
    builder.version = VERSION;
    builder.recordType = RecordTypeLoginMi;
    builder.requestType = RequestGet;
    builder.applicationType = APPLICATIONTYPE;
    builder.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDMARKETSESSION];
    //    builder.ipAddress = AGENTTRADE_HOST;
    builder.ipAddress = udid;
    
    [self subscribeBuidler:builder];
}

- (void)agentSelector:(SEL)selector withObject:(id)object
{
    self.selector = selector;
    self.objectSelector = object;
    
    agentSysadmin.selector = selector;
    agentSysadmin.objectSelector = _objectSelector;
}

- (void)agentSysadminCallback:(AgentSysadmincCallback)callback
{
    self.callback = callback;
    agentSysadmin.callback = callback;
}

- (void)parseReadData:(NSData*)data
{
    @try {
        TradingMessage *msg = [TradingMessage parseFromData:data];
        if (nil != agentSysadmin.objectSelector && nil != agentSysadmin.selector) {
            if([agentSysadmin.objectSelector isKindOfClass:[UIViewController class]]) {
                UIViewController *v = (UIViewController *)agentSysadmin.objectSelector;
                [v performSelector:agentSysadmin.selector withObject:msg afterDelay:0];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s [***] exception %@", __PRETTY_FUNCTION__, exception);
    }
}

#pragma mark -
#pragma GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s host %@: port %hu", __PRETTY_FUNCTION__, host, port);
    
    [sock readDataToLength:4 withTimeout:-1.0 tag:0];
    
    //ready login (set callback)
    TradingMessage_Builder *builder = [TradingMessage builder];
    LoginData_Builder *login_builder = [LoginData builder];
    login_builder.sessionMi = @"-1";
    builder.recStatusReturn = StatusReturnResult;
    builder.recType = RecordTypeLoginMi;
    builder.recLoginData = [login_builder build];
    
    if (nil != agentSysadmin.objectSelector && nil != agentSysadmin.selector) {
        if([agentSysadmin.objectSelector isKindOfClass:[UIViewController class]]) {
            UIViewController *v = (UIViewController *)agentSysadmin.objectSelector;
            [v performSelector:agentSysadmin.selector withObject:[builder build] afterDelay:0];
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
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
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s error: %@ %@", __PRETTY_FUNCTION__, err, sock.connectedHost);
}

- (NSInteger)parseHeader:(NSData *)data
{
    return CFSwapInt32BigToHost(* (int *) ([data bytes]));
}

@end
