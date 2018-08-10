//
//  LoginStep3ViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/29/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SysAdmin.h"
#import "MarketFeed.h"
#import "MarketTrade.h"

#import "LoginStep3.h"
#import "SystemAlert.h"

#import "UIButton+Addons.h"
#import "UILabel+Addons.h"
#import "NSString+Addons.h"

#import "JsonProperties.h"
#import "PDKeychainBindings.h"

//#define LABEL_FONT [UIFont fontWithName:@"Dosis-Semibold" size:22]

@interface LoginStep3()


@property (strong, nonatomic) NSString *userAccount;
@property (strong, nonatomic) NSString *password;
@property (nonatomic, copy) void (^sysCallback)(TradingMessage *tradingMessage, NSString *message, BOOL ok);

@property (weak, nonatomic) IBOutlet UIImageView *animView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end

@implementation LoginStep3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.backButton clearBackground];
    
    [self performSelector:@selector(keepChanging) withObject:nil afterDelay:.5];
    
//    [AppSetting setUserId:@"coba user aaj bebas"];
//    [AppSetting setPassword:@"coba1a231fa32f1a32sf"];
//    NSString *userid = [AppSetting getUserId];
//    NSString *passwd = [AppSetting getPassword];
//    NSLog(@"user id: %@", userid);
//    NSLog(@"passwd: %@", passwd);
    
    [self performSelector:@selector(doSysAdmin) withObject:nil afterDelay:0.5];
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
    
    self.animView.animationRepeatCount = 0;
    self.animView.animationImages = images;
    self.animView.animationDuration = 0.25*9;
    
    [self.animView startAnimating];
    
}

#pragma public

- (void)updateUserAccount:(NSString *)userAccount andPassword:(NSString *)passowrd
{
    self.userAccount = userAccount;
    self.password = passowrd;
}

#pragma private

- (void)doSysAdmin
{
//    __weak typeof(NSString *) userAccount = self.userAccount;
//    __weak typeof(NSString *) passwd = self.password;
    
    __weak typeof(self) weakSelf = self;
    
    self.sysCallback = ^void(TradingMessage *tradingMessage, NSString *message, BOOL ok) {
        if(ok || !tradingMessage) {
            if([tradingMessage.recLoginData.sessionMi isEqualToString:@"-1"]) {
                NSLog(@"Step 1 tradingMessage = %@",tradingMessage);
                //do login now
                NSLog(@"Step 1");
                
                SysAdmin *admin = [SysAdmin sharedInstance];
                [admin doLogin:weakSelf.userAccount andPassword:weakSelf.password];
                
            }
            else {
                NSLog(@"Step 2 tradingMessage = %@",tradingMessage);
                if(tradingMessage) {

                    if(tradingMessage.recStatusReturn == StatusReturnResult) {
                        //login succeed

                        //[SysAdmin sharedInstance].sysAdminData = tradingMessage.recLoginData;
                        //[MarketFeed sharedInstance].sysAdminData = tradingMessage.recLoginData;
                        
                        
                        [JsonProperties setUserId:weakSelf.userAccount];
                        
                        LoginData *login = tradingMessage.recLoginData;
                        LoginData_Builder *loginBuilder = [LoginData builder];
                        loginBuilder.username = login.username;
                        loginBuilder.fullname = login.fullname;
                        loginBuilder.usertype = login.usertype;
                        loginBuilder.sessionMi = weakSelf.password;
                        loginBuilder.ipMarket = login.ipMarket;
                        loginBuilder.ipTrade = login.ipTrade;
                        loginBuilder.userId = login.userId;
                        loginBuilder.userPriv = login.userPriv;
                        loginBuilder.allowOrders = login.allowOrders;
                        loginBuilder.allowTrades = login.allowTrades;
                        loginBuilder.serverType = login.serverType;
                        loginBuilder.ipMarketWebservice = login.ipMarketWebservice;
                        loginBuilder.ipTradeWebservice = login.ipTradeWebservice;
                        loginBuilder.lotSize = login.lotSize;
                        loginBuilder.ipProxy = login.ipProxy;

                        
                        [SysAdmin sharedInstance].sysAdminData = [loginBuilder build];
                        
                        NSDateFormatter *DateNow=[[NSDateFormatter alloc] init];
                        [DateNow setDateFormat:@"yyyy-MM-dd"];
                        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
                        NSLog(@"dateFormatter = %@",[DateNow stringFromDate:[NSDate date]]);
                        
                        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
                        [bindings setObject:login.username forKey:@"username"];
                        [bindings setObject:login.fullname forKey:@"fullname"];
                        [bindings setObject:login.usertype forKey:@"usertype"];
                        [bindings setObject:weakSelf.password forKey:@"password"];
                        [bindings setObject:login.ipMarket forKey:@"ipMarket"];
                        [bindings setObject:login.ipTrade forKey:@"ipTrade"];
                        [bindings setObject:login.userId forKey:@"userId"];
                        [bindings setObject:login.userPriv forKey:@"userPriv"];
                        [bindings setObject:[[NSNumber numberWithInt:login.allowOrders] stringValue] forKey:@"allowOrders"];
                        [bindings setObject:[[NSNumber numberWithInt:login.allowTrades] stringValue] forKey:@"allowTrades"];
                        [bindings setObject:[[NSNumber numberWithInt:login.serverType] stringValue]  forKey:@"serverType"];
                        [bindings setObject:login.ipMarketWebservice forKey:@"ipMarketWebservice"];
                        [bindings setObject:login.ipTradeWebservice forKey:@"ipTradeWebservice"];
                        [bindings setObject:[[NSNumber numberWithInt:login.lotSize] stringValue] forKey:@"lotSize"];
                        [bindings setObject:login.ipProxy forKey:@"ipProxy"];
                        [bindings setObject:[DateNow stringFromDate:[NSDate date]] forKey:@"DateLogin"];
                        [bindings setObject:@"HOME" forKey:@"scrollMenuName"];
                        [bindings setObject:@"0" forKey:@"scrollMenuX"];
                        [bindings setObject:@"" forKey:@"storyBoardIdentify"];

                        NSString *ipMarket = [SysAdmin sharedInstance].sysAdminData.ipTrade;
                        NSArray *splitIp = [ipMarket componentsSeparatedByString:@":"];
                        NSString *ip = [splitIp objectAtIndex:0];
                        int port = [[splitIp objectAtIndex:1] intValue];

                        [[MarketTrade sharedInstance] startAgent:ip port:port reconnect:NO];
                        
                        [weakSelf performSelector:@selector(goHome) withObject:nil afterDelay:0.5];
                    }
                    else {
                        [weakSelf alert:tradingMessage.recStatusMessage];
                    }
                }
                else {
                    [weakSelf alert:@"shall not pass here"];
                }
            }
        }
        else  {
            if(!tradingMessage)
                [weakSelf alert:tradingMessage.recStatusMessage];
            else if(!message)
                [weakSelf alert:message];
            else
                [weakSelf alert:@"Unknown error, please contact team support"];
        }
    };
    
    SysAdmin *admin = [SysAdmin sharedInstance];
    [admin setupAndLoginSysAdmin:self.sysCallback];

}

- (void)goHome
{
    NSLog(@"goHome");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Home"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)alert:(NSString *)message
{
    [self.animView stopAnimating];
    id handler = ^(SIAlertView *alert) {
        [self.navigationController popViewControllerAnimated:YES];
       
    };
    SIAlertView *alert = [SystemAlert alertError:message handler:handler];
    [alert show];
}

@end
