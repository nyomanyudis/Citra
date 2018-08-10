//
//  AppDelegate.m
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//


//---v3---
#import "ThemeManager.h"

//#import "AgentMi.h"
#import "AppDelegate.h"
#import "LoginMiViewController.h"
#import "NSString+StringAdditions.h"
#import "NSString+UUID.h"
#import "AgentTrade.h"
#import "CitraIdlingWindow.h"
#import "UIBAlertView.h"


NSString *const RotisSansSerifLight = @"RotisSansSerif-Light";
NSString *const RotisSansSerifBold = @"RotisSansSerif-Bold";
NSString *const RotisSemiSerifBold = @"RotisSemiSerif-Bold";
NSString *const DINNextLTProRegular = @"DINNextLTPro-Regular";
NSString *const DINAlternateBold = @"DINAlternate-Bold";

int32_t const IDLE_TIME = 60.f * 2.0f;

#define MAJORVERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]
#define MINORVERSION [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleVersion"]

@interface AppDelegate()

@property (strong, nonatomic) NSTimer *homeTimer;

@end



@implementation AppDelegate

@synthesize homeTimer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions:");
    
    //---v3---
    [ThemeManager createTheme];
    //---v3---
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
    if(getenv("NSZombieEnabled")) {
        NSLog(@"*** WARNING *** NSZombieEnabled !!!");
    }
    
//    //disable blacklight/screen off
//    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
//    
//    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    
//    NSDictionary *barButtonAppearanceDict = @{UITextAttributeFont : [UIFont fontWithName:DINNextLTProRegular size:20.0]};
//    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
//    
//    
//    numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
////    [numberFormatter setMaximumFractionDigits:2];
//    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
//    [numberFormatter setDecimalSeparator:@"."];
//    [numberFormatter setGroupingSeparator:@","];
//    [numberFormatter setAllowsFloats:YES];
//    
//    // Override point for customization after application launch.
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
//    self.window.rootViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//    [self.window setRootViewController:self.viewController];
//    [self.window makeKeyAndVisible];
//    
//    [[DBLite sharedInstance] readSetting];
//    [[DBLite sharedInstance] shouldUpdate];
////    NSMutableArray *array = [[DBLite sharedInstance] log];
//    
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    if ([defaults objectForKey:@"userIdentifier"] == nil) {
//        [defaults setObject:[NSString uuid] forKey:@"userIdentifier"];
//        [defaults synchronize];
//    }
//    
//    
////    NSLog(@"==== check fonts ====");
////    for (NSString* family in [UIFont familyNames])
////    {
////        if ([@"Rotis Semi Serif" isEqualToString:family] || [@"Rotis Sans Serif" isEqualToString:family]) {
////            NSLog(@"%@", family);
////            
////            for (NSString* name in [UIFont fontNamesForFamilyName: family])
////            {
////                NSLog(@"  %@", name);
////            }
////        }
////        else if([family containsString:@"DIN"]) {
////            NSLog(@"%@", family);
////            
////            for (NSString* name in [UIFont fontNamesForFamilyName: family])
////            {
////                NSLog(@"  %@", name);
////            }
////        }
////    }
////    NSLog(@"====  end check  ====");
//    
//    //timer idle
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    
    return YES;
}

-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog (@"### time exceeded!! ###");
    
    //This is where storyboarding vs xib files comes in. Whichever view controller you want to revert back to, on your storyboard, make sure it is given the identifier that matches the following code. In my case, "mainView". My storyboard file is called MainStoryboard.storyboard, so make sure your file name matches the storyboardWithName property.
//    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"mainView"];
//    
//    [(UINavigationController *)self.window.rootViewController pushViewController:controller animated:YES];
    
    NSLog(@"go home");
//    [(UINavigationController *)self.window.rootViewController pushViewController:self.viewController animated:YES];
    //[[AgentTrade sharedInstance] logoutAlert:@"Citra Idle" message:@"Idle for 5 minutes or more. Please relogin" idle:YES];
    // You've been away for 5 minutes or more. Please relogin
    [[AgentTrade sharedInstance] logoutAlert:@"Information!" message:@"Idle for 5 minutes or more. Please relogin" idle:YES];
}

- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition
{
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:viewController.view
                      duration:0.65f
                       options:transition
                    completion:^(BOOL finished){
                        self.window.rootViewController = viewController;
                    }];
}

- (void)startHometimer
{
    if (nil == homeTimer) {
        NSLog(@"START HOME TIMER");
        //homeTimer = [NSTimer scheduledTimerWithTimeInterval:IDLE_TIME target:self selector:@selector(doLogin) userInfo:nil repeats:NO];
    }
    
}

- (void)stopHomeTimer
{
    if (nil != homeTimer) {
        //NSLog(@"STOP HOME TIMER");
        
        [homeTimer invalidate];
//        homeTimer = nil;
    }
}

- (void)doLogin
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"LOGIN NOW OR QUIT");
        
//        LoginMiViewController *vc = [[LoginMiViewController alloc] initWithNibName:@"LoginMiViewController" bundle:[NSBundle mainBundle]];
        //UIViewController *me = self.viewController;
        UIViewController *me = [self topViewController];
        LoginMiViewController *vc = [[LoginMiViewController alloc] initWithoutCancel];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
        [me presentViewController:vc animated:YES completion:nil];

    });
}


- (NSString *)appNameAndVersionNumberDisplayString {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@, Version %@ (%@)",
            appDisplayName, majorVersion, minorVersion];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive:");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground:");
}

- (void)goToFirstPage:(UIViewController*)v
{
    dispatch_async(dispatch_get_main_queue(), ^{
            if(![v isKindOfClass:[ViewController class]] ) {
                [v dismissViewControllerAnimated:YES completion:nil];
                UIViewController *v2 = [self topViewController];
                [self performSelector:@selector(goToFirstPage:) withObject:v2 afterDelay:.1];
            }
            else {
                NSString *title = @"No Network Connection";
                NSString *message = @"An internet connection is required to use this application. Please verify that your internet is functional and try again.";
                NSLog(@"%s %@", __PRETTY_FUNCTION__, message);
                
                [[[UIBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"OK" otherButtonTitles:nil] showWithDismissHandler:nil];
            }
        });
}

- (void)gotoHome:(UIViewController*)v
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([v isKindOfClass:[ViewController class]] ) {
        }
        else {
            [v dismissViewControllerAnimated:YES completion:nil];
            
            UIViewController *v2 = [self topViewController];
            [self performSelector:@selector(gotoHome:) withObject:v2 afterDelay:.1];
        }
    });
}

- (UIViewController *)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground:");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"applicationDidBecomeActive: %@, %@, %@", self.userid, self.passwd, [self topViewController]);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate:");
}

BOOL isSimulator()
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#endif

    
    return NO;
}


//#pragma mark
//#pragma Agent Action
//
//- (void)initAgent
//{
//    if(nil == agent) {
//        agent = [[Agent alloc] init];
//    }
//}
//
//- (Agent*)agentMi
//{
//    return agent;
//}
//
//- (void)startAgent
//{
//    [agent startAgent];
//}
//
//- (void)disconnectAgent
//{
//    [agent disconnectAgent];
//}
//
//- (void)setAgentCallback:(id<AgentCallback>)callback
//{
//    agent.callback = callback;
//}
//
//- (void)subscribe:(NSData *)data
//{
//    [agent subscribe:data delegate:nil type:-1];
//}
//
//- (void)addSubscribeDelegate:(id)delegate type:(ScreenType)type
//{
//    if (nil != agent) {
//        [agent addSubscribeDelegate:delegate type:type];
//    }
//}
//
//- (void)removeSubscribeDelegate:(id)delegate type:(ScreenType)type
//{
//    if (nil != agent) {
//        [agent removeSubscribeDelegate:delegate type:type];
//    }
//}
//
//- (float)totalValue
//{
//    if(nil != agent)
//        return agent.totalValue;
//    return 0;
//}
//
//- (float)totalVolume
//{
//    if(nil != agent)
//        return agent.totalVolume;
//    return 0;
//}
//
//- (float)totalFrequency
//{
//    if(nil != agent)
//        return agent.totalFrequency;
//    return 0;
//}
//
//
//- (void)securityQuestion
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.key = @"C1PT4D4N4";
//        req.type = RecordTypeKiRequest;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//}
//
//- (void)subscribeOnce
//{
//    if(nil != agent) {
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiStockData;
//            req.status = RequestGet;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiBrokerData;
//            req.status = RequestGet;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiCurrencyData;
//            req.status = RequestGet;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiIndicesData;
//            req.status = RequestGet;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//    }
//
//}
//
//
//- (void)subscribeHomeCurrencyOnce:(id<AgentKiCurrencyDelegate>)delegate
//{
//    [self subscribeHomeCurrency:delegate once:YES];
//}
//
//- (void)subscribeHomeCurrency:(id<AgentKiCurrencyDelegate>)delegate once:(BOOL)once
//{
//    KiRequest_Builder *req = [KiRequest builder];
//    req.type = RecordTypeKiCurrency;
//    req.status = RequestSubscribe;
//    if(once)
//        req.status = RequestGet;//sekali
//    
//    KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//    
//    [agent subscribe:kirec.data delegate:delegate type:ScreenHomeCurrency];
//
//}
//
//// unsubscribe
//- (void)unsubscribeHomeCurrency
//{
//    KiRequest_Builder *req = [KiRequest builder];
//    req.type = RecordTypeKiCurrency;
//    req.status = RequestUnsubscribe;
//    
//    KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//    
//    [agent unsubscribe:kirec.data type:ScreenHomeCurrency];
//    
//}
//
//- (void)unsubscribeHomeCurrency:(id<AgentKiCurrencyDelegate>)delegate
//{
//    KiRequest_Builder *req = [KiRequest builder];
//    req.type = RecordTypeKiCurrency;
//    req.status = RequestUnsubscribe;
//    
//    KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//    [agent unsubscribe:kirec.data type:ScreenHomeCurrency];
//}
//
//- (void)subscribeMaster
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiStockData;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiIndicesData;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiRegionalIndicesData;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiBrokerData;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiCurrencyData;
//        req.status = RequestGet;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiStockSummary;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//    
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeMarketSummary;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//}
//
//
//- (void)subscribeHomeTopStock:(id<AgentHomeDelegate>)delegate
//{
//    if(nil != agent) {
////        KiRequest_Builder *req = [KiRequest builder];
////        req.type = RecordTypeKiStockSummary;
////        req.status = RequestSubscribe;
////        
////        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
////        [agent subscribe:kirec.data delegate:delegate type:ScreenHomeTopStock];
//        
//        [agent addSubscribeDelegate:delegate type:ScreenHomeTopStock];
//    }
//}
//
////unsubscribe
//- (void)unsubscribeHomeTopStock
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiStockSummary;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenHomeTopStock];
//    }
//}
//
//- (void)subscribeHomeTopBroker:(id<AgentHomeDelegate>)delegate
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeBrokerSummary;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenHomeTopStock];
//    }
//}
//
//// unsubscribe
//- (void)unsubscribeHomeTopBroker
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeBrokerSummary;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenHomeTopStock];
//    }
//}
//
//- (void)subscribeHomeIndices
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiIndices;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//}
//
//// Unsubscribe
//- (void)unsubscribeHomeIndices
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiIndices;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:-1];
//    }
//}
//
//
//- (void)subscribeIndices
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiIndices;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:nil type:-1];
//    }
//}
//
//- (void)subscribeHomeRegionalSummary:(id<AgentHomeDelegate>)delegate
//{
////    NSLog(@"RecordTypeKiRegionalIndices Subscribe");
////    if(nil != agent) {
////        KiRequest_Builder *req = [KiRequest builder];
////        req.type = RecordTypeKiRegionalIndices;
////        req.status = RequestSubscribe;
////        
////        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
////        [agent subscribe:kirec.data delegate:delegate type:ScreenHomeRegionalSummary];
////    }
//}
//
//- (void)subscribeHomeFuture:(id<AgentHomeDelegate>)delegate
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeFutures;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenHomeRegionalSummary];
//    }
//}
//
//
//
//
//
//
//
//- (void)subscribeMarketRunningTrade:(id<AgentMarketRunningTradeDelegate>)delegate
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiTrade;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenMarketRunningTrade];
//    }
//
//}
//
//- (void)unsubscribeMarketRunningTrade
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiTrade;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenMarketRunningTrade];
//    }
//}
//
//- (void)subscribeMarketTopBroker:(id<AgentMarketTopBrokerDelegate>)delegate
//{
//}
//
//- (void)unsubscribeMarketTopBroker
//{
//    
//}
//
//- (void)subscribeMarketFDNetBuySell:(id<AgentMarketFDNetBuySellDelegate>)delegate
//{
//    if(nil != agent) {
//        id d = [agent.agentDelegates objectForKey:[NSNumber numberWithInt:ScreenHomeTopStock]];
//        
//        if(nil == d) {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiStockSummary;
//            req.status = RequestSubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:ScreenMarketFDNetBuySell];
//        }
//        else {
//            [agent addSubscribeDelegate:delegate type:ScreenMarketFDNetBuySell];
//        }
//    }
//
//}
//
//- (void)unsubscribeMarketFDNetBuySell
//{
//    if(nil != agent) {
//        id d = [agent.agentDelegates objectForKey:[NSNumber numberWithInt:ScreenHomeTopStock]];
//        
//        if(nil == d) {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiStockSummary;
//            req.status = RequestUnsubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent unsubscribe:kirec.data type:ScreenMarketFDNetBuySell];
//        }
//        else {
//            [agent removeSubscribeDelegate:nil type:ScreenMarketFDNetBuySell];
//        }
//    }
//}
//
//- (void)subscribeMarketNetBSByBroker:(id<AgentMarketNetBSByBrokerDelegate>)delegate broker:(NSString *)broker
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeBrokerNetbuysell;
//        req.status = RequestSubscribe;
//        req.code = broker;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenMarketNetBSByBroker];
//    }
//}
//
//- (void)unsubscribeMarketNetBSByBroker
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeBrokerNetbuysell;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenMarketNetBSByBroker];
//    }
//}
//
//- (void)subscribeMarketRegionalSummary:(id<AgentMarketRegionalSummaryDelegate>)delegate
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiRegionalIndices;
//        req.status = RequestSubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenMarketRegionalSummary];
//        
//        
////        id d = [agent.agentDelegates objectForKey:[NSNumber numberWithInt:ScreenHomeTopStock]];
////        
////        if(nil == d) {
////            KiRequest_Builder *req = [KiRequest builder];
////            req.type = RecordTypeKiRegionalIndices;
////            req.status = RequestSubscribe;
////            
////            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
////            [agent subscribe:kirec.data delegate:delegate type:ScreenMarketRegionalSummary];
////        }
////        else {
////            [agent addSubscribeDelegate:delegate type:ScreenMarketRegionalSummary];
////        }
//    }
//}
//
//- (void)unsubscribeMarketRegionalSummary
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeKiRegionalIndices;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenMarketRegionalSummary];
//    }
//}
//
//
//
//- (void)subscribeSecurityNetBSByStock:(id<AgentSecurityNetBSByStockDelegate>)delegate stock:(NSString *)stock
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeStockNetbuysell;
//        req.status = RequestSubscribe;
//        req.code = stock;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent subscribe:kirec.data delegate:delegate type:ScreenSecurityNetBSByStock];
//    }
//}
//
//- (void)unsubscribeSecurityNetBSByStock
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeStockNetbuysell;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:ScreenSecurityNetBSByStock];
//    }
//}
//
//
//- (void)subscribeSecurityTopStock:(id<AgentSecurityTopStockDelegate>)delegate
//{
//    if(nil != agent) {
//        [agent addSubscribeDelegate:delegate type:ScreenSecurityTopStock];
//    }
//}
//
//- (void)unsubscribeSecurityTopStock
//{
//    if(nil != agent) {
//        [agent removeSubscribeDelegate:nil type:ScreenSecurityTopStock];
//    }
//}
//
//
//- (void)subscribeSecurityWatchList:(id<AgentSecurityWatchListDelegate>)delegate
//{
//    if(nil != agent) {
//        [agent addSubscribeDelegate:delegate type:ScreenSecurityWatchList];
//    }
//}
//
//- (void)unsubscribeSecurityWatchList
//{
//    if(nil != agent) {
//        [agent removeSubscribeDelegate:nil type:ScreenSecurityWatchList];
//    }
//}
//
//- (void)subscribeSecurityStockWatch:(id<AgentSecurityStockWatchDelegate>)delegate stock:(NSString *)stock
//{
//    if(nil != agent) {
//        {
////            NSLog(@"Subscribe RecordTypeLevel2");
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeLevel2;
//            req.status = RequestSubscribe;
//            req.code = stock;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:ScreenSecurityStockWatch];
//            
//            NSArray *arrayLevel2 = getArrayLevel2(stock);
//            if(nil != arrayLevel2)
//                [delegate onAgentSecurityStockWatchLevel2:arrayLevel2];
//            
//        }
//        {
////            NSLog(@"Subscribe RecordTypeLevel3");
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeLevel3;
//            req.status = RequestSubscribe;
//            req.code = stock;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:ScreenSecurityStockWatch];
//        }
//        {
////            NSLog(@"Subscribe RecordTypeKiLastTrade");
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiLastTrade;
//            req.status = RequestSubscribe;
//            req.code = stock;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:ScreenSecurityStockWatch];
//        }
//        {
////            NSLog(@"Subscribe RecordTypeStockHistory");
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeStockHistory;
//            req.status = RequestSubscribe;
//            req.code = stock;
//            req.board = BoardRg;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:ScreenSecurityStockWatch];
//        }
//    }
//}
//
//- (void)subscribeSecurityStockWatch:(id<AgentSecurityStockWatchDelegate>)delegate stock:(NSString *)stock screen:(ScreenType)type
//{
//    if(nil != agent) {
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeLevel2;
//            req.status = RequestSubscribe;
//            req.code = stock;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:delegate type:type];
//        }
//    }
//}
//
//- (void)unsubscribeSecurityStockWatch:(ScreenType)type
//{
//    if(nil != agent) {
//        KiRequest_Builder *req = [KiRequest builder];
//        req.type = RecordTypeLevel2;
//        req.status = RequestUnsubscribe;
//        
//        KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//        [agent unsubscribe:kirec.data type:type];
//    }
//}
//
//- (void)unsubscribeSecurityStockWatch
//{
//    if(nil != agent) {
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeLevel2;
//            req.status = RequestUnsubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent unsubscribe:kirec.data type:ScreenSecurityStockWatch];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeLevel3;
//            req.status = RequestUnsubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeKiTrade;
//            req.status = RequestUnsubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//        {
//            KiRequest_Builder *req = [KiRequest builder];
//            req.type = RecordTypeStockHistory;
//            req.status = RequestUnsubscribe;
//            
//            KiRecord *kirec = [[[KiRecord builder] setRequest:req.build] build];
//            [agent subscribe:kirec.data delegate:nil type:-1];
//        }
//    }
//}
//
//
//
//
//
//// Agent Order
//- (AgentOrder*)agentOrder
//{
//    return agentOrder;
//}
//
//- (void)removeOrderSubscribe:(ScreenOrderType)type
//{
//    if(nil != agentOrder) {
//        [agentOrder removeDelegate:type];
//    }
//}
//
//- (void)checkSession
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi) {
//        
//        NSMutableDictionary *dict = agentOrder.orderListDictionary;
//        int seqno = 0;
//        if (nil != dict) {
//            TxOrder *tx = [dict.allValues objectAtIndex:dict.allValues.count - 1];
//            seqno = tx.sequenceNo;
//        }
//        
//        //NSLog(@"check Session %i", seqno);
//        
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetStatusSession;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        req.general = [NSString stringWithFormat:@"%@|%@|%i", HOST_ORDER, HOST, seqno];
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subcribe:tm.data];
//    }
//}
//
//- (void)loginMi:(id<AgentOrderDelegate>)delegate uid:(NSString*)uid passwd:(NSString*)passwd
//{
//
//    agentOrder = nil;
//    agentOrder = [[AgentOrder alloc] init];
//
//    [agentOrder startAgent];
//    
//    RequestData_Builder *req = [RequestData builder];
//    req.username = uid;
//    req.password = passwd;
//    req.loginType = LOGINTYPE;
//    req.version = VERSION;
//    req.recordType = RecordTypeLoginMi;
//    req.requestType = RequestGet;
//    req.applicationType = APPLICATIONTYPE;
//    req.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDMARKETSESSION];
//    req.ipAddress = HOST_ORDER;
//    
//    TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//    [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderLoginMi];
//}
//
//- (void)loginOl:(id<AgentOrderDelegate>)delegate pin:(NSString*)pin screen:(ScreenOrderType)type
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeLoginOl;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        req.pin = pin;
//        req.expiredSession = [NSString stringWithFormat:@"%i", EXPIREDTRADINGSESSION];
//        req.version = VERSION;
//        req.ipAddress = HOST_ORDER;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        
//        [agentOrder subscribe:tm.data delegate:delegate type:type];
//
//    }
//}
//
//- (void)logoutMi
//{
//    if(nil != agentOrder) {
//        
//        [agentOrder setAccountMi:nil];
//        [agentOrder setAccountOl:nil];
//        
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeLogoutMi;
//        req.requestType = RequestGet;
//        req.loginType = LOGINTYPE;
//        req.version = VERSION;
//        req.applicationType = APPLICATIONTYPE;
//        req.ipAddress = HOST_ORDER;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:nil type:-1];
//    }
//}
//
//- (LoginData*)accountMi
//{
//    if(nil != agentOrder) {
//        return [agentOrder accountMi];
//    }
//    return nil;
//}
//
//- (LoginData*)accountOl
//{
//    if(nil != agentOrder) {
//        return [agentOrder accountOl];
//    }
//    return nil;
//}
//
//- (void)requestPrevilleges
//{   
//    if(nil != agentOrder && nil != agentOrder.accountMi) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeMPrevilleges;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subcribe:tm.data];
//    }
//}
//
//- (void)requestMenu
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeMMenu;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subcribe:tm.data];
//    }
//}
//
//
//
//
//- (void)requestClientList
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeClientList;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subcribe:tm.data];
//    }
//}
//
//
//- (void)requestClientList:(id<AgentOrderDelegate>)delegate screen:(ScreenOrderType)type
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeClientList;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:type];
//    }
//}
//
//- (void)requestOrderList:(id<AgentOrderListDelegate>)delegate
//{
//    [self requestOrderList:delegate screen:ScreenOrderList];
//}
//
//- (void)requestOrderList:(id<AgentOrderListDelegate>)delegate screen:(ScreenOrderType)type
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetOrders;
//        req.requestType = RequestSubscribe;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.userType = @"RCO";
//        req.deviceType = DeviceTypeIphone;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:type];
//    }
//}
//
//- (void)requestOrderTradeList:(id<AgentOrderListDelegate>)delegate
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetOrders;
//        req.requestType = RequestSubscribe;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.userType = @"RCO";
//        req.deviceType = DeviceTypeIphone;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderTradeList];
//    }
//}
//
//- (void)requestOrderPower:(id<AgentOrderFormDelegate>)delegate clientCode:(NSString*)code
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetOrderPower;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderForm];
//    }
//}
//
//- (void)requestOrderAvaiableStock:(id<AgentOrderFormDelegate>)delegate clientCode:(NSString*)code stockCode:(NSString*)stock
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetAvaiableStock;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        req.stockcode = stock;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderForm];
//    }
//}
//
//- (void)composeMsg:(NSDictionary*)op composeMsg:(BOOL)b
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeSendSubmitOrder;
//        req.requestType = RequestGet;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.username = agentOrder.accountMi.username;
//        
//        NSString *submitOrder = [ConstractOrder composeMsgNew:op];
//        long long skey = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
//        
////        NSLog(@"sKey %lld", skey);
////        NSLog(@"param %@", submitOrder);
//        
//        req.messageOrder = submitOrder;
//        req.general = [NSString stringWithFormat:@"%lld", skey];
//        req.version = VERSION;
//        
//        if (b) {
//            TxOrder_Builder *builder = [TxOrder builder];
//            builder.price = [[op objectForKey:O_PRICE] intValue];
//            builder.orderQty = [[op objectForKey:O_ORDERQTY] floatValue];
//            builder.side = [[op objectForKey:O_SIDE] intValue];
//            builder.securityCode = [op objectForKey:O_SYMBOL];
//            builder.orderStatus = @"9";
//            builder.clientCode = [op objectForKey:O_CLIENTCODE];
//            
//            
//            [agentOrder orderPacket:[builder build]];
//        }
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subcribe:tm.data];
//    }
//}
//
//- (void)requestAccountInfo:(id<AgentOrderAccountInfoDelegate>)delegate clientCode:(NSString*)code;
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetAccountInfo;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderAccountInfo];
//    }
//
//}
//
//- (void)requestAccountCashFlow:(id<AgentOrderAccountCashFlowDelegate>)delegate clientCode:(NSString*)code
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetCashFlow;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderAccountCashFlow];
//    }
//}
//
//- (void)requestAccountPortfolioList:(id<AgentOrderAccountPortfolioDelegate>)delegate clientCode:(NSString*)code
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetPortfolioList;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderAccountPortfolioList];
//    }
//}
//
//- (void)requestAccountPortfolioOrder:(id<AgentOrderAccountPortfolioDelegate>)delegate clientCode:(NSString*)code
//{
////    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
////        RequestData_Builder *req = [RequestData builder];
////        req.recordType = RecordTypeGetPortfolioOrder;
////        req.requestType = RequestGet;
////        req.username = agentOrder.accountMi.username;
////        req.sessionOl = agentOrder.accountOl.sessionOl;
////        req.clientcode = code;
////        
////        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
////        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderAccountPortfolioOrder];
////    }
//    
////    //sleep(1);
////    //Shares Information
////    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
////        RequestData_Builder *req = [RequestData builder];
////        req.recordType = RecordTypeSharesInfo;
////        req.requestType = RequestGet;
////        req.username = agentOrder.accountMi.username;
////        req.sessionOl = agentOrder.accountOl.sessionOl;
////        //req.clientcode = code;
////        
////        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
////        [agentOrder subcribe:tm.data];
////    }
////    
////    //sleep(1);
////    //Market Capping
////    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
////        RequestData_Builder *req = [RequestData builder];
////        req.recordType = RecordTypeMarketCapping;
////        req.requestType = RequestGet;
////        req.username = agentOrder.accountMi.username;
////        req.sessionOl = agentOrder.accountOl.sessionOl;
////        //req.clientcode = code;
////        
////        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
////        [agentOrder subcribe:tm.data];
////    }
//}
//
//- (void)requestAccountCustomerPosition:(id<AgentOrderAccountPortfolioDelegate>)delegate clientCode:(NSString*)code
//{
//    if (nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeGetCustomerPosition;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.clientcode = code;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderAccountPortfolioList];
//    }
//}
//
//
//- (void)changePasswd:(id<AgentOrderChangePasswdDelegate>)delegate oldPasswd:(NSString *)oldPasswd nwPasswd:(NSString *)nwPasswd
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeChangePassword;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        req.password = oldPasswd;
//        req.general = nwPasswd;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderToolsChangePasswd];
//    }
//}
//
//- (void)changePin:(id<AgentOrderChangePasswdDelegate>)delegate oldPin:(NSString *)oldPin nwPin:(NSString *)nwPin
//{
//    if(nil != agentOrder && nil != agentOrder.accountMi && nil != agentOrder.accountOl) {
//        RequestData_Builder *req = [RequestData builder];
//        req.recordType = RecordTypeChangePin;
//        req.requestType = RequestGet;
//        req.username = agentOrder.accountMi.username;
//        req.sessionMi = agentOrder.accountMi.sessionMi;
//        req.sessionOl = agentOrder.accountOl.sessionOl;
//        req.pin = oldPin;
//        req.general = nwPin;
//        
//        TradingMessage *tm = [[[TradingMessage builder] setRecReqDataBuilder:req] build];
//        [agentOrder subscribe:tm.data delegate:delegate type:ScreenOrderToolsChangePin];
//    }
//}

@end







NSNumberFormatter* currencyFormatter()
{
    return numberFormatter;
}

NSString* currencyString(NSNumber *number)
{
    return [numberFormatter stringFromNumber:number];
}

NSString* currencyStringFromInt(NSInteger integer)
{
    return [numberFormatter stringFromNumber:[NSNumber numberWithInt:(int)integer]];
}

NSString* currencyStringFromFloat(NSInteger integer)
{
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:integer]];
}

NSString* currencyStringWithFormat(NSNumber *number, NSNumberFormatter *formatter)
{
    return [formatter stringFromNumber:number];
}

NSString* currencyRounded(NSInteger rupiah)
{
    float tmp = rupiah / 1000000.0f;
    NSString *stringval = [NSString stringWithFormat:@"%@M", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
    if(tmp >= 1000.0f) {
        tmp /= 1000.0f;
        stringval = [NSString stringWithFormat:@"%@B", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
    }
    return stringval;
}

NSString* currencyRoundedWithFloat(float rupiah)
{
    if (rupiah > 1000000.0f || rupiah < -1000000.0f) {
        float tmp = rupiah / 1000000.0f;
        NSString *stringval = [NSString stringWithFormat:@"%@M", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
        if(tmp >= 1000.0f) {
            tmp /= 1000.0f;
            stringval = [NSString stringWithFormat:@"%@B", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
        }
        
        return stringval;
    }
    else if(rupiah == 0) {
        return @"0";
    }
    else {
        return [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:[NSNumber numberWithFloat:rupiah]]];
    }
    
}

NSString* currencyRoundedWithFloatWithFormat(float rupiah, NSNumberFormatter *formatter)
{
    if (rupiah > 1000000.0f || rupiah < -1000000.0f) {
        float tmp = rupiah / 1000000.0f;
        NSString *stringval = [NSString stringWithFormat:@"%@M", [formatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
        if(tmp >= 1000.0f) {
            tmp /= 1000.0f;
            stringval = [NSString stringWithFormat:@"%@B", [formatter stringFromNumber:[NSNumber numberWithFloat:tmp]]];
        }
        
        return stringval;
    }
    else if(rupiah == 0) {
        return @"0";
    }
    else {
        return [NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithFloat:rupiah]]];
    }
    
}

NSString* currencyRoundedWithUint64(uint64_t rupiah)
{
    uint64_t tmp = rupiah / 1000000.0f;
    NSString *stringval = [NSString stringWithFormat:@"%@M", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:tmp]]];
    if(tmp >= 1000.0f) {
        tmp /= 1000.0f;
        stringval = [NSString stringWithFormat:@"%@B", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:tmp]]];
    }
    
    if (0 ==tmp) {
        stringval = @"0";
    }
    
    return stringval;
}