//
//  Reconnecting.m
//  Ciptadana
//
//  Created by Reyhan on 7/17/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "Reconnecting.h"
#import "SysAdmin.h"
#import "MarketFeed.h"
#import "MarketTrade.h"

#import "SystemAlert.h"

#import "UIButton+Addons.h"
#import "UILabel+Addons.h"
#import "NSString+Addons.h"

#import "JsonProperties.h"
#import "PDKeychainBindings.h"

@interface Reconnecting ()
@property (nonatomic, copy) void (^sysCallback)(TradingMessage *tradingMessage, NSString *message, BOOL ok);
@property (nonatomic, copy) void (^tradeCallBack)(TradingMessage *tradingMessage, NSString *message, BOOL ok);

@end

@implementation Reconnecting

@synthesize spriteLoading;

-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(reconnect) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:@selector(keepChanging)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keepChanging
{
    NSArray *imageNames = @[@"sprite1", @"sprite2", @"sprite3",
                            @"sprite4", @"sprite5", @"sprite6",
                            @"sprite7", @"sprite8", @"sprite9"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    self.spriteLoading.animationRepeatCount = 0;
    self.spriteLoading.animationImages = images;
    self.spriteLoading.animationDuration = 0.25*9;
    
    [self.spriteLoading startAnimating];
    
}

- (void)reconnect
{
    //    __weak typeof(NSString *) userAccount = self.userAccount;
    //    __weak typeof(NSString *) passwd = self.password;
    
    __weak typeof(self) weakSelf = self;
    
    LoginData *sysAdminData = [[SysAdmin sharedInstance] sysAdminData];
    
    
    if(sysAdminData.ipMarket.length != 0 && sysAdminData.ipTrade.length !=0){
        NSLog(@"Masih ada SysAdmin");
        NSString *ipMarket = [SysAdmin sharedInstance].sysAdminData.ipTrade;
        NSArray *splitIp = [ipMarket componentsSeparatedByString:@":"];
        NSString *ip = [splitIp objectAtIndex:0];
        int port = [[splitIp objectAtIndex:1] intValue];
        
        [[MarketTrade sharedInstance] startAgent:ip port:port reconnect:YES];
        
        [weakSelf performSelector:@selector(goHome) withObject:nil afterDelay:0.5];
    }
    else{
        NSLog(@"GAGAL");
    }
    
   
    
}

- (void)goHome
{
    NSLog(@"goHome");
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *storyBoardIdentify = [bindings objectForKey:@"storyBoardIdentify"];
    
    if(storyBoardIdentify.length == 0 )
        storyBoardIdentify = @"HomeIdentity";
    
    SWRevealViewController *revealController = self.revealViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyBoardIdentify];
    if(vc)
        // Pass any objects to the view controller here, like...
        [revealController pushFrontViewController:vc animated:YES];
    
}

- (void)alert:(NSString *)message
{
    [self.spriteLoading stopAnimating];
    id handler = ^(SIAlertView *alert) {
        [self.navigationController popViewControllerAnimated:YES];
        
    };
    SIAlertView *alert = [SystemAlert alertError:message handler:handler];
    [alert show];
}


@end
