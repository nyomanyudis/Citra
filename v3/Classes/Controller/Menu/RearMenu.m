//
//  RearMenu.m
//  Ciptadana
//
//  Created by Reyhan on 10/6/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "RearMenu.h"
//#import "SubMenu.h"
#import "RearMenuCell.h"

#import "Home.h"
#import "GrandController.h"
#import "UIView+Toast.h"
#import "SystemAlert.h"

#import "MarketTrade.h"

#import "SysAdmin.h"

#import <QuartzCore/QuartzCore.h>

#import "PDKeychainBindings.h"

//#import "SWRevealViewController.h"

#define ICON(icon) [UIImage imageNamed:icon]
#define ICONS @[@"home", @"markets", @"securities", @"trade", @"settings", @"logout"]

#define MENUITEMS @[@"menu1", @"menu2", @"menu3", @"menu4", @"menu5", @"menu6", @"menu7", @"menu8"]
#define MENUHOME @[@"HOME", @"MARKETS", @"SECURITIES", @"TRADE", @"SETTINGS", @"Change Password" ,@"LOGOUT"]
#define MENUHOME2 @[@"HOME", @"MARKETS", @"SECURITIES", @"ORDER", @"ACCOUNT", /*@"MESSAGES", */@"SETTINGS", @"Change Password" , @"LOGOUT"]
#define MENUMARKETS @[@"Back", @"Running Trade", @"Market Summary", @"Regional Summary", @"Currency", @"Top Broker", @"F/D Net Buy Sell", @"Net B/S By Broker"]
#define MENUSECURITIES @[@"Back", @"Stock Watch", @"Watchlist", @"Top Stock", @"Net B/S By Stock", @"Capital Market Calendar"]
#define ORDER @[@"Back", @"Buy Stock", @"Sell Stock", @"Order List", @"Trade List"]
#define ACCOUNT @[@"Back", @"Portfolio", @"Cash Flow", @"Account Info", @"Entry Cash Withdraw", @"Deposit Withdraw List", @"Change PIN"]
#define ELSE @[@"Back"]

static RearMenu *rearMenu;

@interface RearMenu () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableMenu;
@property (strong, nonatomic) UITableView *tableFrontMenu;
@property (assign, nonatomic) NSInteger selected;
@property (strong, nonatomic) NSArray *menus;
@property (strong, nonatomic) NSArray *submenus;

 @end

@implementation RearMenu

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if([SysAdmin sharedInstance].loginTrade)
        self.menus = MENUHOME2;
    else self.menus = MENUHOME;
    
    [self.tableMenu reloadData];
}

+ (RearMenu *)sharedInstance
{    if (nil == rearMenu) {
        rearMenu = [[RearMenu alloc] init];
    }
    
    return rearMenu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableMenu.dataSource = self;
    self.tableMenu.delegate = self;
    self.tableMenu.backgroundColor = [UIColor clearColor];
    
    self.selected = -1;
    
    CGRect tmpBounds = self.view.bounds;
    tmpBounds.origin.x = tmpBounds.size.width + 5;
    tmpBounds.origin.y = 25;
    self.tableFrontMenu = [[UITableView alloc] initWithFrame:tmpBounds];
    [self.view addSubview:self.tableFrontMenu];
    
    self.tableFrontMenu.layer.masksToBounds = NO;
    self.tableFrontMenu.layer.shadowOffset = CGSizeMake(-2.0f, 0);
    self.tableFrontMenu.layer.shadowRadius = 2.5;
    self.tableFrontMenu.layer.shadowOpacity = 0.7;
    
    self.tableFrontMenu.dataSource = self;
    self.tableFrontMenu.delegate = self;
    
    self.menus = MENUHOME;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"indentifierCustom"]) {
        
    }
}
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

#pragma mark - public

- (void)showNewMenu
{
    
    self.menus = MENUHOME2;
    [self.tableMenu reloadData];
}


#pragma - mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    if(tableView == self.tableMenu) {
        
        NSString *label = [self.menus objectAtIndex:indexPath.row];
        //@[@"HOME", @"MARKETS", @"SECURITIES", @"ORDER", @"ACCOUNT", @"MESSAGES", @"LOGOUT"]
        if([label isEqualToString:@"HOME"]) {
            [bindings setObject:@"HOME" forKey:@"scrollMenuName"];
        }
        else if([label isEqualToString:@"MESSAGES"]) {
        }
        else if([label isEqualToString:@"LOGOUT"]) {
            [self performSelector:@selector(logout)];
        }
        else if([label isEqualToString:@"Change Password"]){
            SWRevealViewController *revealController = self.revealViewController;
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
            GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changePasswordIdentity"];
            if(vc)
                // Pass any objects to the view controller here, like...
                [revealController pushFrontViewController:vc animated:YES];
        }
        else if([label isEqualToString:@"SETTINGS"]) {
            SWRevealViewController *revealController = self.revealViewController;
            [bindings setObject:@"SETTINGS" forKey:@"scrollMenuName"];
            [bindings setObject:@"0" forKey:@"scrollMenuX"];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
            GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"settingIdentity"];
            if(vc)
                // Pass any objects to the view controller here, like...
                [revealController pushFrontViewController:vc animated:YES];
        }
        else if([label isEqualToString:@"TRADE"]) {
            
            SWRevealViewController *revealController = self.revealViewController;
            [revealController revealToggleAnimated:YES];
            
            NSString *usertype = [SysAdmin sharedInstance].loginFeed.usertype;
            NSLog(@"UserType RearMenu Nyoman = %@",usertype);
            if(usertype && ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
                [bindings setObject:@"" forKey:@"scrollMenuOrder"];
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
        else {
            
            if(indexPath.row != self.selected && self.tableFrontMenu.frame.origin.x == 60) {
                // Animate
                [UIView animateWithDuration:.15f delay:0
                     usingSpringWithDamping:.75f
                      initialSpringVelocity:.0f
                                    options:0 animations:^{
                                        CGRect tmpFrame = self.view.bounds;
                                        tmpFrame.origin.x = tmpFrame.size.width + 5;
                                        tmpFrame.origin.y = 25;
                                        self.tableFrontMenu.frame = tmpFrame;
                                    } completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.25f delay:0
                                             usingSpringWithDamping:.75f
                                              initialSpringVelocity:3.1f
                                                            options:0 animations:^{
                                                                CGRect tmpFrame = self.tableFrontMenu.frame;
                                                                tmpFrame.origin.x = 60;
                                                                tmpFrame.origin.y = 25;
                                                                self.tableFrontMenu.frame = tmpFrame;
                                                            } completion:nil];
                                    }];
            }
            else if(indexPath.row == self.selected && self.tableFrontMenu.frame.origin.x == 60) {
                // Animate
                [UIView animateWithDuration:.15f delay:0
                     usingSpringWithDamping:.75f
                      initialSpringVelocity:.0f
                                    options:0 animations:^{
                                        CGRect tmpFrame = self.view.bounds;
                                        tmpFrame.origin.x = tmpFrame.size.width + 5;
                                        tmpFrame.origin.y = 25;
                                        self.tableFrontMenu.frame = tmpFrame;
                                    } completion:nil];
            }
            else {
                // Animate
                [UIView animateWithDuration:.35f delay:0
                     usingSpringWithDamping:.75f
                      initialSpringVelocity:3.1f
                                    options:0 animations:^{
                                        CGRect tmpFrame = self.tableFrontMenu.frame;
                                        tmpFrame.origin.x = 60;
                                        tmpFrame.origin.y = 25;
                                        self.tableFrontMenu.frame = tmpFrame;
                                    } completion:nil];
            }
            
            if([label isEqualToString:@"MARKETS"]) {
                self.submenus = MENUMARKETS;
            }
            else if([label isEqualToString:@"SECURITIES"]) {
                self.submenus = MENUSECURITIES;
            }
            else if([label isEqualToString:@"ORDER"]) {
                self.submenus = ORDER;
            }
            else if([label isEqualToString:@"ACCOUNT"]) {
                self.submenus = ACCOUNT;
            }
            else {
                self.submenus = ELSE;
            }
            
            [self.tableFrontMenu reloadData];
        }
        
        self.selected = indexPath.row;

    }
    else if(tableView == self.tableFrontMenu) {
        NSString *label = [self.menus objectAtIndex:self.selected];
        if([label isEqualToString:@"MARKETS"]) {
            if(1 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Running Trade" forKey:@"scrollMenuName"];
                [bindings setObject:@"0" forKey:@"scrollMenuX"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"runningtradeIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(2 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Market Summary" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"marketSummaryIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(3 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Regional Summary" forKey:@"scrollMenuName"];
                [bindings setObject:@"400" forKey:@"scrollMenuX"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"regionalSummaryIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(4 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Currency" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"currencyIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(5 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Top Broker" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"topBrokerIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(6 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"F/D Net Buy Sell" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"fdnetbsIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(7 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Net B/S By Broker" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"netBrokerIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
        }
        else if([label isEqualToString:@"SECURITIES"]) {
            if(1 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Stock Watch" forKey:@"scrollMenuName"];
                [bindings setObject:@"100" forKey:@"scrollMenuX"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"stockwatchIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(2 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Watchlist" forKey:@"scrollMenuName"];
                [bindings setObject:@"200" forKey:@"scrollMenuX"];
                
                NSString *scrollMenuX = [bindings objectForKey:@"scrollMenuX"];
                NSString *scrollMenuName = [bindings objectForKey:@"scrollMenuName"];
                
                NSLog(@"scrollMenuX WathcList = %@",scrollMenuX);
                NSLog(@"scrollMenuName WathcList = %@",scrollMenuName);
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"watchlistIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(3 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Top Stock" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"topStockIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(4 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Net B/S By Stock" forKey:@"scrollMenuName"];
                [bindings setObject:@"300" forKey:@"scrollMenuX"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"netStockIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
            else if(5 == indexPath.row) {
                SWRevealViewController *revealController = self.revealViewController;
                [bindings setObject:@"Capital Market Calendar" forKey:@"scrollMenuName"];
                
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
                GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"calendarIdentity"];
                if(vc)
                    // Pass any objects to the view controller here, like...
                    [revealController pushFrontViewController:vc animated:YES];
                
            }
        }
        else if([label isEqualToString:@"ACCOUNT"]) {
            MarketTrade *trade = [MarketTrade sharedInstance];
            if((trade.getClients && trade.getClients.count > 0) || indexPath.row == 0) {
                if(1 == indexPath.row) {
                        SWRevealViewController *revealController = self.revealViewController;
                        [revealController revealToggleAnimated:YES];
                        [bindings setObject:@"Portofolio" forKey:@"scrollMenuName"];
                        
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"portfolioIdentity"];
                        if(vc)
                            // Pass any objects to the view controller here, like...
                            [revealController pushFrontViewController:vc animated:YES];
                }
                else if(2 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Cash Flow" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"cashflowIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                else if(3 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Account Info" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"accountInfoIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                else if(4 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Entry Cash Withdraw" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"entryCashWithdrawIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                else if(5 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Deposit Withdraw List" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"depositWithdrawIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                else if(6 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Change PIN" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Account" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"changePinIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                
            }
            else {
                [self performSelector:@selector(noClientList)];
            }
        }
        else if([label isEqualToString:@"ORDER"]) {
            MarketTrade *trade = [MarketTrade sharedInstance];
            if((trade.getClients && trade.getClients.count > 0) || indexPath.row == 0) {
                if(1 == indexPath.row) {
                        SWRevealViewController *revealController = self.revealViewController;
                        [bindings setObject:@"Buy Stock" forKey:@"scrollMenuName"];
                        [bindings setObject:@"400" forKey:@"scrollMenuX"];
                    
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"buyStockIdentity"];
                        if(vc)
                            // Pass any objects to the view controller here, like...
                            [revealController pushFrontViewController:vc animated:YES];
                }
                else if(2 == indexPath.row) {
                        SWRevealViewController *revealController = self.revealViewController;
                        [bindings setObject:@"Sell Stock" forKey:@"scrollMenuName"];
                        [bindings setObject:@"400" forKey:@"scrollMenuX"];
                        
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                        GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"sellStockIdentity"];
                        if(vc)
                            // Pass any objects to the view controller here, like...
                            [revealController pushFrontViewController:vc animated:YES];
                }
                else if(3 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Order List" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"orderStockIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
                else if(4 == indexPath.row) {
                    SWRevealViewController *revealController = self.revealViewController;
                    [bindings setObject:@"Trade List" forKey:@"scrollMenuName"];
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Order" bundle:nil];
                    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"tradeStockIdentity"];
                    if(vc)
                        // Pass any objects to the view controller here, like...
                        [revealController pushFrontViewController:vc animated:YES];
                    
                }
            }
            else {
                [self performSelector:@selector(noClientList)];
            }
        }
//        else if([label isEqualToString:@"MESSAGES"]) {
//            MarketTrade *trade = [MarketTrade sharedInstance];
//            if(trade.getClients && trade.getClients.count > 0) {
//            }
//            else {
//                [self performSelector:@selector(noClientList)];
//            }
//        }
        
        float secs = .15f;
//        [UIView animateWithDuration:secs delay:0.0 options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             CGRect tmpFrame = self.view.bounds;
//                             tmpFrame.origin.x = tmpFrame.size.width + 5;
//                             self.tableFrontMenu.frame = tmpFrame;
//                         }
//                         completion:nil];
        [UIView animateWithDuration:secs delay:0
             usingSpringWithDamping:.75f
              initialSpringVelocity:.0f
                            options:0 animations:^{
                                CGRect tmpFrame = self.view.bounds;
                                tmpFrame.origin.x = tmpFrame.size.width + 5;
                                tmpFrame.origin.y = 25;
                                self.tableFrontMenu.frame = tmpFrame;
                            } completion:nil];
    }
}

#pragma - mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableFrontMenu) {
        if(self.submenus && self.submenus.count > 0) {
            return [self.submenus count];
        }
        
        return 1;
        
    }
    return [self.menus count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RearMenuCell *cell;
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    NSString *scrollMenuName = [bindings objectForKey:@"scrollMenuName"];
    if(tableView == self.tableMenu) {
        NSString *CellIdentifier = [MENUITEMS objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSString *menu = [self.menus objectAtIndex:indexPath.row];
        [cell setTitle:[NSString stringWithFormat:@"%@", menu]];
        
        if([menu isEqualToString:scrollMenuName]){
            cell.backgroundColor = [UIColor cyanColor];
        }
        else{
            cell.backgroundColor = [UIColor clearColor];
        }
        
        UIImageView *icon = [cell.contentView viewWithTag:1];
        UIImage *image = [UIImage imageNamed:[menu lowercaseString]];//ICON(menu);
        
        if(image)
            icon.image = image;
    }
    else if(tableView == self.tableFrontMenu) {
        if(cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RearMenuCell" owner:self options:nil] objectAtIndex:0];
        }
        
        
        NSString *submenu = [self.submenus objectAtIndex:indexPath.row];
        //[cell setTitle:[NSString stringWithFormat:@"%@", [self.submenus objectAtIndex:indexPath.row]]];
        [cell setTitle:submenu];
        
        if([submenu isEqualToString:scrollMenuName]){
            cell.backgroundColor = [UIColor cyanColor];
        }
        else{
            cell.backgroundColor = [UIColor clearColor];
        }

        
        if([submenu isEqualToString:@"F/D Net Buy Sell"])
            submenu = @"fd net buy sell";
        else if([submenu isEqualToString:@"Net B/S By Broker"])
            submenu = @"net bs by broker";
        else if([submenu isEqualToString:@"Net B/S By Stock"])
            submenu = @"net bs by stock";
        
        UIImageView *icon = [cell.contentView viewWithTag:1];
        UIImage *image = [UIImage imageNamed:[submenu lowercaseString]];//ICON(submenu);
                
        if(image)
            icon.image = image;
    }
    
    return cell;
}

#pragma - private

- (void)logout
{

    [[MarketFeed sharedInstance] doLogout];
    [[MarketTrade sharedInstance] doLogout];
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
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

- (void)noClientList
{
//    SWRevealViewController *revealController = self.revealViewController;
//    [revealController revealToggleAnimated:YES];
//    [[SystemAlert alert:@"Alert" message:@"Your Account is not Authorized access this feature" handler:nil button:@"OK"] show];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Your Account is not Authorized access this feature"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [self logout];
                                }];
    
//    UIAlertAction* noButton = [UIAlertAction
//                               actionWithTitle:@"No, thanks"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction * action) {
//                                   //Handle no, thanks button
//                               }];
    
    [alert addAction:yesButton];
//    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginStep1"];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
