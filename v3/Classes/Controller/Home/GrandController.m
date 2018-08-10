//
//  GrandController.m
//  Ciptadana
//
//  Created by Reyhan on 10/6/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "GrandController.h"

#import "SWRevealViewController.h"
#import "SystemAlert.h"
#import "SettingV3.h"
#import "OrderGrid.h"

#import "UIView+Toast.h"
#import "PDKeychainBindings.h"
#import "ObjectBuilder.h"


@interface GrandController ()

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok;
- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok;
@property (strong, nonatomic) UIScrollView *scrollViewMenu;

@end

@implementation GrandController

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *class = NSStringFromClass([self class]);
    
    if(![class isEqualToString:@"Reconnecting"]){
        self.standardView = [[StandardView alloc] initWithFrame:CGRectMake(0, -8, self.view.bounds.size.width, 1)];
        self.standardBottom = [[StandardView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 1)];
        
        
        [self.view addSubview:self.standardView];
        [self setUpScrollViewMenu];
    }
    
    
    [self performSelector:@selector(callback)];
    [[MarketFeed sharedInstance] initMarket];
    
    NSArray *indices = [[MarketData sharedInstance] getIndices];
    [self updateComposite:indices];
    
    UINavigationItem *itemNav = self.navigationItem;
    if(itemNav) {
        UIBarButtonItem *itemLeft = [itemNav leftBarButtonItem];
        if(itemLeft) {
            itemLeft.tintColor = [UIColor grayColor];
            
            UIBarButtonItem *original = [[UIBarButtonItem alloc] initWithImage:[itemLeft.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                             style:UIBarButtonItemStylePlain
                                            target:itemLeft.target
                                            action:itemLeft.action];
            
        
        }
    }
    
    NSInteger passwordStatus = [[MarketTrade sharedInstance] getPasswordStatus];
    LoginData *loginData = [[SysAdmin sharedInstance] loginFeed];
    
    if(passwordStatus == 1 && ([loginData.usertype isEqualToString:@"ICO"] || [loginData.usertype isEqualToString:@"RCO"])){
        [self createAlertController:nil reTypePassword:nil pin:nil reTypePin:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification");
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *username = [bindings objectForKey:@"username"];
    NSString *password = [bindings objectForKey:@"password"];
    NSString *DateLogin = [bindings objectForKey:@"DateLogin"];
    
    NSDateFormatter *DateNow=[[NSDateFormatter alloc] init];
    [DateNow setDateFormat:@"yyyy-MM-dd"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"dateFormatter = %@",[DateNow stringFromDate:[NSDate date]]);
    
    
    
    LoginData *sysAdminData = [[SysAdmin sharedInstance] sysAdminData];
    NSLog(@"sysAdminData ipMarket = %@",sysAdminData.ipMarket);
    
    
    
    
    if([SysAdmin sharedInstance].loginFeed == nil && username.length != 0 && password.length != 0 && [DateLogin isEqualToString:[DateNow stringFromDate:[NSDate date]]]){
        SWRevealViewController *revealController = self.revealViewController;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"reconnectingIdentity"];
        if(vc)
            // Pass any objects to the view controller here, like...
            [revealController pushFrontViewController:vc animated:YES];
    }
    else if([SysAdmin sharedInstance].loginFeed == nil){
        [[MarketFeed sharedInstance] doLogout];
        [[MarketTrade sharedInstance] doLogout];
        
        [bindings setObject:@"" forKey:@"username"];
        [bindings setObject:@"" forKey:@"fullname"];
        [bindings setObject:@"" forKey:@"usertype"];
        [bindings setObject:@"" forKey:@"password"];
        [bindings setObject:@"" forKey:@"ipMarket"];
        [bindings setObject:@"" forKey:@"ipTrade"];
        [bindings setObject:@"" forKey:@"userId"];
        [bindings setObject:@"" forKey:@"userPriv"];
        [bindings setObject:@"" forKey:@"allowOrders"];
        [bindings setObject:@"" forKey:@"allowTrades"];
        [bindings setObject:@""  forKey:@"serverType"];
        [bindings setObject:@"" forKey:@"ipMarketWebservice"];
        [bindings setObject:@""forKey:@"ipTradeWebservice"];
        [bindings setObject:@"" forKey:@"lotSize"];
        [bindings setObject:@"" forKey:@"ipProxy"];
        
        SWRevealViewController *revealController = self.revealViewController;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        if(vc) {
            // Pass any objects to the view controller here, like...
            [revealController pushFrontViewController:vc animated:YES];
            
            [[MarketFeed sharedInstance] doLogout];
            
            [vc.view makeToast:@"              Logout               "
                      duration:3.5f
                      position:CSToastPositionTop
                         title:nil
                         image:nil//[UIImage imageNamed:@"arrowgreen"]
                         style:nil
                    completion:^(BOOL didTap) {
                        if (didTap) {
                            NSLog(@"completion from tap");
                        } else {
                            NSLog(@"completion without tap");
                        }
                    }];
            
            [SysAdmin sharedInstance].loginTrade = nil;
            
        }

    }
    
}


-(void) createAlertController:(NSString *)password reTypePassword:(NSString *) reTypePassword pin:(NSString *)pin reTypePin:(NSString *)reTypePin
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Change Password and PIN"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Change Password";
        //textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.backgroundColor = COLOR_CLEAR;
        textField.background = nil;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = password;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Retype Password";
        //textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.backgroundColor = COLOR_CLEAR;
        textField.background = nil;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = reTypePassword;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Change PIN";
        //textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.backgroundColor = COLOR_CLEAR;
        textField.background = nil;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = pin;
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Retype PIN";
        //textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.backgroundColor = COLOR_CLEAR;
        textField.background = nil;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = reTypePin;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSArray * textfields = alertController.textFields;
        
        UITextField * passwordfiled = textfields[0];
        NSString *password = passwordfiled.text;
        
        UITextField * reTypePasswordfiled = textfields[1];
        NSString *reTypePassword = reTypePasswordfiled.text;
        
        UITextField * pinfiled = textfields[2];
        NSString *pin = pinfiled.text;
        
        UITextField * reTypePinfiled = textfields[3];
        NSString *reTypePin = reTypePinfiled.text;
        
        NSLog(@"password = %@",password);
        NSLog(@"reTypePassword = %@",reTypePassword);
        NSLog(@"pin = %@",pin);
        NSLog(@"reTypePin = %@",reTypePin);
        
        
        if([password length] ==0)
            [self ErrorAlertChangePinAndPassword:@"Password is empty" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if([reTypePassword length] ==0)
            [self ErrorAlertChangePinAndPassword:@"ReTypePassword is empty" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if([pin length] ==0)
            [self ErrorAlertChangePinAndPassword:@"Pin is empty" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if([reTypePin length] ==0)
            [self ErrorAlertChangePinAndPassword:@"ReTypePin is empty" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if([password length] < 6)
            [self ErrorAlertChangePinAndPassword:@"Minimum length Password is 6" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if([pin length] < 4)
            [self ErrorAlertChangePinAndPassword:@"Minimum length Pin is 4" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if(![password isEqualToString:reTypePassword])
            [self ErrorAlertChangePinAndPassword:@"Password and ReTypePassword is not match" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else if(![pin isEqualToString:reTypePin])
            [self ErrorAlertChangePinAndPassword:@"Pin and ReTypePin is not match" password:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        else
            [[MarketTrade sharedInstance] forceChange:pin passwd:password];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void) ErrorAlertChangePinAndPassword:(NSString *)message password:(NSString *)password reTypePassword:(NSString *) reTypePassword pin:(NSString *)pin reTypePin:(NSString *)reTypePin
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Error Alert"
                                                                              message: message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createAlertController:password reTypePassword:reTypePassword pin:pin reTypePin:reTypePin];
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


-(void) setUpScrollViewMenu
{
    NSMutableArray *wordsArray = [NSMutableArray arrayWithObjects:@"Running Trade", @"Stock Watch", @"Watchlist", @"Net B/S By Stock", @"Regional Summary", @"Buy Stock", @"Sell Stock",nil];
    
    self.scrollViewMenu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-68, self.view.bounds.size.width, 29.0)];
    NSLog(@"GrandController width = %f",self.view.bounds.size.width);
    NSLog(@"GrandController height = %f",self.view.bounds.size.height);
    CGFloat btnFrameX = 0.0;
    CGFloat Width = 50.0;
    CGFloat Height = 30.0;
    UILabel *button;
    NSInteger tag = 1;
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *scrollMenuX = [bindings objectForKey:@"scrollMenuX"];
    NSString *scrollMenuName = [bindings objectForKey:@"scrollMenuName"];
    
    NSLog(@"setUpScrollViewMenu scrollMenuX = %f",[scrollMenuX floatValue]);
    
    [self.scrollViewMenu setContentOffset:CGPointMake([scrollMenuX floatValue], 0)];
    
    for (NSString *text in wordsArray) {
        
        //        button = [UILabel buttonWithType:UIButtonTypeCustom];
        //        button.titleLabel.font = FONT_TITLE_DEFAULT_BUTTON_NYOMAN;
        //        [button.titleLabel setFont:[UIFont systemFontOfSize:1.0f]];
        
        //        [button setTitle:text forState:UIControlStateNormal];
        //        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button = [[UILabel alloc]initWithFrame:CGRectMake(btnFrameX, 0, Width, Height)];
        button.text = text;
        button.numberOfLines = 0;
        button.textAlignment = NSTextAlignmentCenter;
        button.font = [UIFont fontWithName:@"Rajdhani-Bold" size:8];
        
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5;
        
        if([text isEqualToString:scrollMenuName]){
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtapped"]];
            button.backgroundColor = [UIColor blackColor];
            button.textColor = [UIColor whiteColor];
        }
        else{
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnormal"]];
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnavigation"]];
            button.backgroundColor = [ObjectBuilder colorWithHexString:@"93885A"];
//            button.backgroundColor = [ObjectBuilder colorWithHexString:@"B2A37A"];
            button.textColor = [UIColor whiteColor];
        }
        
        
        button.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
        [button addGestureRecognizer:tapGesture];
        button.textAlignment = NSTextAlignmentCenter;
        button.tag = tag;
        //        [tapGesture release];
        //        button.frame = CGRectMake(btnFrameX, 0, Width, Height);
        
        
        [self.scrollViewMenu addSubview:button];
        
        btnFrameX = btnFrameX + Width ;
        tag ++;
    }
    
    CGSize contentSize = self.scrollViewMenu.frame.size;
    contentSize.width = btnFrameX ;
    contentSize.height = Height;
    self.scrollViewMenu.contentSize = contentSize;
    
    self.scrollViewMenu.bounces = NO;
    self.scrollViewMenu.scrollsToTop = NO;
    
    [self.view addSubview:self.scrollViewMenu];
}

- (void) buttonClicked: (id)button
{
    NSString *storyBoard = @"";
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%f",self.scrollViewMenu.contentOffset.x] forKey:@"scrollMenuX"];
    
    
    UIGestureRecognizer *rec = (UIGestureRecognizer *)button;
    id hitLabel = [self.view hitTest:[rec locationInView:self.view] withEvent:UIEventTypeTouches];
    if ([hitLabel isKindOfClass:[UILabel class]]) {
        NSString *label = ((UILabel *)hitLabel).text;
        if([label isEqualToString: @"Running Trade"]){
            storyBoard = @"runningtradeIdentity";
            [bindings setObject:@"Running Trade" forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString: @"Stock Watch"]){
            storyBoard = @"stockwatchIdentity";
            [bindings setObject:@"Stock Watch"forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString: @"Net B/S By Stock"]){
            storyBoard = @"netStockIdentity";
            [bindings setObject:@"Net B/S By Stock" forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString: @"Regional Summary"]){
            storyBoard = @"regionalSummaryIdentity";
            [bindings setObject:@"Regional Summary" forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString: @"Watchlist"]){
            storyBoard = @"watchlistIdentity";
            [bindings setObject:@"My Watch List" forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString: @"Buy Stock"]){
            storyBoard = @"buyStockIdentity";
            [bindings setObject:@"Buy Stock" forKey:@"scrollMenuOrder"];
            if([SysAdmin sharedInstance].loginTrade){
                [bindings setObject:@"Buy Stock" forKey:@"scrollMenuName"];
            }
            
        }
        else if([label isEqualToString: @"Sell Stock"]){
            storyBoard = @"sellStockIdentity";
            [bindings setObject:@"Sell Stock" forKey:@"scrollMenuOrder"];
            if([SysAdmin sharedInstance].loginTrade){
                [bindings setObject:@"Sell Stock" forKey:@"scrollMenuName"];
            }
        }
        
    }
    
    
    NSLog(@"storyBoard = %@",storyBoard);
    
    if([storyBoard isEqualToString:@"buyStockIdentity"] || [storyBoard isEqualToString:@"sellStockIdentity"]){
        if([SysAdmin sharedInstance].loginTrade){
            SWRevealViewController *revealController = self.revealViewController;
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
            GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyBoard];
            if(vc)
                // Pass any objects to the view controller here, like...
                [revealController pushFrontViewController:vc animated:YES];
        }
        else{
            NSLog(@"SGrandController loginfeed = %@",[SysAdmin sharedInstance].loginFeed);
            NSString *usertype = [SysAdmin sharedInstance].loginFeed.usertype;
//            NSLog(@"GrandController userType = %@",usertype);
            if(usertype && ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
                [self performSelector:@selector(logintrade)];
            }
            else {
                
                NSString *title = @"Access Rules";
                NSString *message = @"Your account is not authorized access this feature";
                
                id handler = ^(SIAlertView *alert) {
                    
                };
                SIAlertView *alert = [SystemAlert alert:title message:message handler:handler button:@"OK"];
                [alert show];
                
            }
        }
        
    }
    else{
        SWRevealViewController *revealController = self.revealViewController;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyBoard];
        if(vc)
            // Pass any objects to the view controller here, like...
            [revealController pushFrontViewController:vc animated:YES];
    }
}

- (void)logintrade
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"PIN"
                                                                              message: @""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"pin";
        //textField.textColor = [UIColor blueColor];
        //textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;
        textField.backgroundColor = COLOR_CLEAR;
        textField.background = nil;
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * passwordfiled = textfields[0];
        NSString *pin = passwordfiled.text;
        
        if(pin.length > 0)
            [[MarketTrade sharedInstance] LoginTrade:pin];
        else
            [[SystemAlert alert:@"Alert" message:@"PIN is null" handler:nil button:@"OK"] show];
        
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - private

- (void)successLoginPin
{
    GrandController *vc = self;
    if(vc) {
        [vc.view makeToast:@"Success Login Trade"
                  duration:3.5f
                  position:CSToastPositionTop
                     title:nil
                     image:nil
                     style:nil
                completion:nil];
        
//        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        UIStoryboard *citraStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle: nil];
//        RearMenu *leftMenu = (RearMenu*)[citraStoryboard instantiateViewControllerWithIdentifier: @"rearMenuIdentity"];
//        if(leftMenu) {
//            [leftMenu showNewMenu];
//                }
        [[MarketTrade sharedInstance] subscribe:RecordTypeClientList requestType:RequestGet];
    }
    
    SWRevealViewController *revealController = self.revealViewController;
    [revealController revealToggleAnimated:YES];
}

-(void)LoginBuyStock
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"buyStockIdentity"];
    if(vc)
        // Pass any objects to the view controller here, like...
        [revealController pushFrontViewController:vc animated:YES];
}

-(void)LoginSellStock
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"sellStockIdentity"];
    if(vc)
        // Pass any objects to the view controller here, like...
        [revealController pushFrontViewController:vc animated:YES];
}

#pragma mark - protected

- (void)callback
{
    __weak typeof(self) weakSelf = self;
    
    MarketFeedCallback recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        [self recordCallback:record message:message response:ok];
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
            }
        }
    };
    
    MarketTradeCallback tradeCallback = ^void(TradingMessage *tm, NSString *message, BOOL ok) {
        if([SysAdmin sharedInstance].loginTrade) {
            [self tradeCallback:tm message:message response:ok];
            if(ok && tm) {
                if(tm.recStatusReturn == StatusReturnResult) {
                    if(tm.recType == RecordTypeSendSubmitOrder) {
                        NSLog(@"==submit order");
                        NSLog(@"%@", tm);
                    }
                    else if(tm.recType == RecordTypeGetOrders) {
                        NSLog(@"==get order");
                        NSLog(@"%@", tm);
                        
                        SettingApp *app = [SettingV3 loadSetting];
                        if(app && app.popsconfirm) {
                            if(tm.recOrderlist && tm.recOrderlist.count > 0) {
                                TxOrder *order = [tm.recOrderlist objectAtIndex:0];
                                if(![order.orderStatus isEqualToString:@"5"]) {
                                    NSString *status = [OrderGrid statusDescription:order.orderStatus];
                                    NSString *reason = order.reasonText;
                                    if([reason isEqualToString:@""] || [reason isEqualToString:@" "])
                                        reason = order.description;
                                    NSString *message = [NSString stringWithFormat:@"%@ is %@\n%@", order.securityCode, status, reason];
                                    
                                    
                                    NSString *json = [[NSUserDefaults standardUserDefaults] stringForKey:STORAGESETTINGKEY];
                                    NSLog(@"json = %@",json);
                                    if(json) {
                                        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
                                        
                                        
                                        
                                        NSError *error;
                                        
                                        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                                        NSMutableDictionary *dictSetting = [jsonObject objectForKey:@"setting"];
                                        
                                        if(dictSetting) {
                                            BOOL popupStatus = [[dictSetting objectForKey:@"POPUPSTATUS"] isEqualToString:@"YES"] ? YES : NO;
                                            if(popupStatus){
                                                [[SystemAlert alert:@"Order Response" message:message handler:nil button:@"OK"] show];
                                            }
                                        }
                                    }

                                    
                                    
                                    
                                    //                            if(tm.recClordid) {
                                    //                                TxOrder *tx=  [[MarketTrade sharedInstance].getOrderDictionary objectForKey:tm.recClordid];
                                    //                                NSLog(@"tx = %@", tx);
                                    //                            }
                                }
                                
                            }
                        }
                    }
                }
                else if(tm.recStatusReturn == StatusReturnError) {
                    
                    NSString *errMessage = tm.recStatusMessage;
                    if(errMessage.length <= 0)
                        errMessage = @"Unknown Error";
                    
                    [[SystemAlert alert:@"Error!" message:errMessage handler:nil button:@"OK"] show];
                }
                else if(tm.recStatusReturn == StatusReturnNoresult) {
                    NSLog(@"NO RESULT: %@", tm);
                }
                
                if(tm.recType == RecordTypeLoginOl) {
                    NSLog(@"trading message login - %@", tm);
                    if(tm.recStatusReturn == StatusReturnResult) {
                        PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
                        NSString *scrollMenuName = [bindings objectForKey:@"scrollMenuOrder"];
                        if([scrollMenuName isEqualToString:@"Buy Stock"]){
                            [weakSelf performSelector:@selector(LoginBuyStock)];
                        }
                        else if([scrollMenuName isEqualToString:@"Sell Stock"]){
                            [weakSelf performSelector:@selector(LoginSellStock)];
                        }
                        else{
                           [weakSelf performSelector:@selector(successLoginPin)];
                        }
                        //sukses login trade
                        
                    }
                    else {
                        NSString *errMessage = tm.recStatusMessage;
                        if(errMessage.length <= 0)
                            errMessage = @"Unknown Error";
                        
                        [[SystemAlert alert:@"Failed Login Trade" message:errMessage handler:nil button:@"OK"] show];
                    }
                }
                else if(tm.recType == RecordTypeClientList) {
                    NSLog(@"clients: %@", tm.recClientList);
                }
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
    [MarketTrade sharedInstance].callback = tradeCallback;
}

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    
}

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    
}

#pragma private

- (void)updateComposite:(NSArray *)indices
{
    if(indices && indices.count > 0) {
        for(KiIndices *indi in indices) {
            
            KiIndicesData *data = [[MarketData sharedInstance] getIndicesData:indi.codeId];
            if([data.code isEqualToString:@"COMPOSITE"] && self.composite == nil)
                self.composite = data;
            
            if(indi.codeId == self.composite.id) {
                [self.standardView updateComposite:indi];
            }
        }
    }
}

#pragma public

- (void)updateIndices:(KiRecord *)record
{
    if(record.recordType == RecordTypeKiIndices) {
        [self updateComposite:record.indices];
    }
}

//#pragma classic
//
//long long stringToHexa(NSString *hexa) {
////    NSScanner* scan = [NSScanner scannerWithString: hexa];
////    
////    int value;
////    return [scan scanInt:&value];
//    
//    return (UInt64)strtoull([hexa UTF8String], NULL, 16);
//}

@end
