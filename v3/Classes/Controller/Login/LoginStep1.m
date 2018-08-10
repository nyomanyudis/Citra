//
//  LoginStep1ViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/25/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "LoginStep1.h"
#import "LoginStep2.h"
//#import "SystemAlert.h"

#import "UIButton+Addons.h"
#import "UIButton+Appearance.h"
#import "UITextField+Addons.h"
#import "UIViewController+Addons.h"

#import "JsonProperties.h"
#import "Util.h"
#import "SysAdmin.h"
#import "PDKeychainBindings.h"
#import "MarketTrade.h"


@interface LoginStep1 () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *userAccountTxt;
@property (weak, nonatomic) IBOutlet UIButton *joinUs;
@property (weak, nonatomic) IBOutlet UIButton *disclaimer;
@property (weak, nonatomic) IBOutlet UIButton *contactUs;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation LoginStep1

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.userAccountTxt becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.logo setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.logo addGestureRecognizer:singleTap];
    
    
    NSLog(@"identifier = %@",self.restorationIdentifier);
    
    [self.userAccountTxt initRightButtonKeyboardToolbar:@"Next" target:self selector:@selector(buttonToolbarClicked)];
    self.userAccountTxt.delegate = self;
    
    [self initLinearGradient:CGPointMake(0.2, 1) endPoint:CGPointZero colors:GRADIENT_GRAY_SUPERLIGHT];
    
    NSString *userAccount = [JsonProperties getUserId];
    [self.userAccountTxt setText:userAccount];
    //[self performSelector:@selector(nextStep:) withObject:userAccount];
    
    [self performSelector:@selector(initPrivate) withObject:nil afterDelay:.1];
    
    // Jika mau reconnecting ketika membuka halaman login1
//    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
//    NSString *username = [bindings objectForKey:@"username"];
//    NSString *fullname = [bindings objectForKey:@"fullname"];
//    NSString *usertype = [bindings objectForKey:@"usertype"];
//    NSString *password = [bindings objectForKey:@"password"];
//    NSString *ipMarket = [bindings objectForKey:@"ipMarket"];
//    NSString *ipTrade = [bindings objectForKey:@"ipTrade"];
//    NSString *userId = [bindings objectForKey:@"userId"];
//    NSString *userPriv = [bindings objectForKey:@"userPriv"];
//    NSString *allowOrders = [bindings objectForKey:@"allowOrders"];
//    NSString *allowTrades = [bindings objectForKey:@"allowTrades"];
//    NSString *serverType = [bindings objectForKey:@"serverType"];
//    NSString *ipMarketWebservice = [bindings objectForKey:@"ipMarketWebservice"];
//    NSString *ipTradeWebservice = [bindings objectForKey:@"ipTradeWebservice"];
//    NSString *lotSize = [bindings objectForKey:@"lotSize"];
//    NSString *ipProxy = [bindings objectForKey:@"ipProxy"];
//    
//    [bindings setObject:@"Home" forKey:@"scrollMenuName"];
//    [bindings setObject:@"0" forKey:@"scrollMenuX"];
//    
//    
//    if([SysAdmin sharedInstance].sysAdminData == nil && username.length != 0 && password.length !=0){
//        __weak typeof(self) weakSelf = self;
//        
//        
//        
//        LoginData_Builder *loginBuilder = [LoginData builder];
//        loginBuilder.username = username;
//        loginBuilder.fullname = fullname;
//        loginBuilder.usertype = usertype;
//        loginBuilder.sessionMi = password;
//        loginBuilder.ipMarket = ipMarket;
//        loginBuilder.ipTrade = ipTrade;
//        loginBuilder.userId = userId;
//        loginBuilder.userPriv = userPriv;
//        loginBuilder.allowOrders = [allowOrders integerValue];
//        loginBuilder.allowTrades = [allowTrades integerValue];
//        loginBuilder.serverType = [serverType integerValue];
//        loginBuilder.ipMarketWebservice = ipMarketWebservice;
//        loginBuilder.ipTradeWebservice = ipTradeWebservice;
//        loginBuilder.lotSize = [lotSize integerValue];
//        loginBuilder.ipProxy = ipProxy;
//        
//        [SysAdmin sharedInstance].sysAdminData = [loginBuilder build];
//        
//        [weakSelf performSelector:@selector(goReconnect) withObject:nil afterDelay:0.5];
//        
//        
//        
//    }
//    
//    NSLog(@"[SysAdmin sharedInstance].sysAdminData = %@",[SysAdmin sharedInstance].sysAdminData);
    
    
   
}

-(void)settingTapping:(UIGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"IdentifierLoginSetting" sender:nil];
}

- (void)goReconnect
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"reconnecting"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"identifierStep2"]) {
        
        //__weak typeof(UITextField *)textfield = self.userAccountTxt;
        UITextField *textfield = self.userAccountTxt;
        NSDictionary *defaultAttributes = self.userAccountTxt.defaultTextAttributes;
        [textfield setDefaultTextAttributes:defaultAttributes];
        
        // Get reference to the destination view controller
        LoginStep2 *vc = (LoginStep2*) segue.destinationViewController;
        if(vc)
            // Pass any objects to the view controller here, like...
            [vc updateUserAccount:textfield.text];
        
        textfield = nil;
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonToolbarClicked];
    return YES;
}

#pragma private

- (void)initPrivate
{
    [self.joinUs clearBackground];
    [self.disclaimer clearBackground];
    [self.contactUs clearBackground];
    
    [self.joinUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateNormal];
    [self.joinUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateSelected];
    [self.joinUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateHighlighted];
    [self.disclaimer setTitleColor:COLOR_HYPERLINK forState:UIControlStateNormal];
    [self.disclaimer setTitleColor:COLOR_HYPERLINK forState:UIControlStateSelected];
    [self.disclaimer setTitleColor:COLOR_HYPERLINK forState:UIControlStateHighlighted];
    [self.contactUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateNormal];
    [self.contactUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateSelected];
    [self.contactUs setTitleColor:COLOR_HYPERLINK forState:UIControlStateHighlighted];
    
    [self.joinUs setTitleFont:FONT_TITLE_DEFAULT_BUTTONP_HYPERLINK];
    [self.disclaimer setTitleFont:FONT_TITLE_DEFAULT_BUTTONP_HYPERLINK];
    [self.contactUs setTitleFont:FONT_TITLE_DEFAULT_BUTTONP_HYPERLINK];
}

- (void)buttonToolbarClicked
{
    [self performSegueWithIdentifier:@"identifierStep2" sender:nil];
    
}

- (void)nextStep:(id)object
{
    NSString *userAccount = object;
    if(userAccount && ![userAccount isEqualToString:@""]) {
        self.userAccountTxt.text = userAccount;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginStep2 *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginStep2Identity"];
        if(vc)
            // Pass any objects to the view controller here, like...
            [vc updateUserAccount:userAccount];
        [self.navigationController pushViewController:vc animated:NO];    }
    
}

- (IBAction)selectorJoinUs:(id)sender
{
    
}

- (IBAction)selectorDisclaimer:(id)sender
{
    
}

- (IBAction)selectorContactUs:(id)sender
{
    
}

@end
