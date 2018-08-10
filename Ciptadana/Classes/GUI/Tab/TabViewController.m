//
//  TabViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/25/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "TabViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "ImageResources.h"
#import "UIColor+ColorStyle.h"
#import "UIButton+Customized.h"

#import "ViewController.h"

#import "RunningTradeViewController.h"
#import "MarketSummaryViewController.h"
#import "TopBrokerViewController.h"
#import "FDNetBuySellViewController.h"
#import "NetBSByBrokerViewController.h"
#import "RegionalSummaryViewController.h"

#import "NetBSByStockViewController.h"
#import "TopStockViewController.h"
#import "WatchListViewController.h"
#import "StockWatchViewController.h"
#import "CapitalMarketCalendarViewController.h"

//#import "OrderFormViewController.h"
//#import "OrderForm2ViewController.h"
#import "OrderForm3ViewController.h"
#import "OrderListViewController.h"
#import "TradeListViewController.h"

#import "AccountInfoViewController.h"
#import "PortfolioViewController.h"
#import "CashFlowViewController.h"
#import "EntryCashWithdrawController.h"
#import "DepositWithdrawController.h"
#import "SettingController.h"

#import "ChangePasswdViewController.h"

#import "AppDelegate.h"
//#import "AgentOrderDelegate.h"
#import "GRAlertView.h"

#import "UIImage+Extras.h"
#import "AgentTrade.h"

#define CAPTION @[@"Market", @"Securities", @"Order", @"My Account", @"Tools"]


@class PopupLoginTrade;


typedef enum {
    ControllerMarketRunningTrade = 0,
    ControllerMarketSummary,
    ControllerMarketRegionalSummary,
    ControllerMarketTopBroker,
    ControllerMarketFDNetBuySell,
    ControllerMarketNetBSByBroker,
    
    ControllerSecurityStockWatch,
    ControllerSecurityWatchList,
    ControllerSecurityTopStock,
    ControllerSecurityNetBSByStock,
    ControllerSecurityCaptMarketCalendar,
    
    ControllerOrderFormBuy,
    ControllerOrderFormSell,
    ControllerOrderList,
    ControllerOrderTradeList,
    
    ControllerAccountPortfolio,
    ControllerAccountCashFlow,
    ControllerAccountInfo,
    ControllerEntryCashWitdraw,
    ControllerDepositWithdrawList,
    
    ControllerToolsChangePin,
    ControllerToolsChangePasswd,
    ControllerToolsLogout,
    ControllerToolsSetting,
    
} ControllerType;

@interface TabViewController () <UIScrollViewDelegate, UITabBarDelegate>

@property UIAlertView *alertLogout;

@end

@implementation TabViewController
{
    UIView *view1;
    UIView *view2;
    UIView *view3;
    UIView *view4;
    UIView *view5;
}

@synthesize iconBarItem, actionBarItem, captionBarItem;
@synthesize scrollview;
@synthesize tabbar, marketTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonImage = [ImageResources imageCiptadana];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [iconBarItem setCustomView:button];
    
    UIImage *image = [ImageResources imageHome];
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    //[buttonAction setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //[buttonAction OrangeBackgroundCustomized];
    [buttonAction setImage:image forState:UIControlStateNormal];
    [buttonAction setImage:image forState:UIControlStateHighlighted];
    [buttonAction addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarItem setCustomView:buttonAction];
    
    _toolbar.frame = CGRectMake(0,
                                86,
                                _toolbar.frame.size.width,
                                43);
    
    [self initTab];
    
    scrollview.delegate = self;
    
    [captionBarItem setTitle:CAPTION[0]];
    tabbar.delegate = self;
    
    [_marketButton addTarget:self action:@selector(marketButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_securityButton addTarget:self action:@selector(securityButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_orderButton addTarget:self action:@selector(orderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_accountButton addTarget:self action:@selector(accountButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_toolsButton addTarget:self action:@selector(toolsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showScrollPage:(int)page
{
    [captionBarItem setTitle:CAPTION[page]];
    
    if(0 == page) {
        [scrollview scrollRectToVisible:view1.frame animated:YES];
    }
    else if(1 == page) {
        [scrollview scrollRectToVisible:view2.frame animated:YES];
    }
    else if(2 == page) {
        [scrollview scrollRectToVisible:view3.frame animated:YES];
    }
    else if(3 == page) {
        [scrollview scrollRectToVisible:view4.frame animated:YES];
    }
    else if(4 == page) {
        [scrollview scrollRectToVisible:view5.frame animated:YES];
    }
}

- (void)marketButtonClicked
{
    [self showScrollPage:0];
}

- (void)securityButtonClicked
{
    [self showScrollPage:1];
}

- (void)orderButtonClicked
{
    [self showScrollPage:2];
}

- (void)accountButtonClicked
{
    [self showScrollPage:3];
}

- (void)toolsButtonClicked
{
    [self showScrollPage:4];
}

- (void) initTab
{
    CGRect frame = self.view.frame;
    frame.size.height = scrollview.frame.size.height - 87;
    view1 = [[UIView alloc] initWithFrame:frame];
    frame.origin.x = frame.size.width;
    view2 = [[UIView alloc] initWithFrame:frame];
    frame.origin.x = 2 * frame.size.width;
    view3 = [[UIView alloc] initWithFrame:frame];
    frame.origin.x = 3 * frame.size.width;
    view4 = [[UIView alloc] initWithFrame:frame];
    frame.origin.x = 4 * frame.size.width;
    view5 = [[UIView alloc] initWithFrame:frame];
    
    view1.backgroundColor = black;
    view2.backgroundColor = black;
    view3.backgroundColor = black;
    view4.backgroundColor = black;
    view5.backgroundColor = black;
    
    // tab 1
    UIView *view1a = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
    [view1a addSubview:[self buttonWithControllerType:ControllerMarketRunningTrade resize:NO]];
    UIView *view1b = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
    [view1b addSubview:[self buttonWithControllerType:ControllerMarketSummary resize:NO]];
    UIView *view1c = [[UIView alloc] initWithFrame:CGRectMake(214, 5, 86, 130)];
    [view1c addSubview:[self buttonWithControllerType:ControllerMarketRegionalSummary resize:NO]];
    UIView *view1d = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 86, 130)];
    [view1d addSubview:[self buttonWithControllerType:ControllerMarketTopBroker resize:NO]];
    UIView *view1e = [[UIView alloc] initWithFrame:CGRectMake(117, 160, 86, 130)];
    [view1e addSubview:[self buttonWithControllerType:ControllerMarketFDNetBuySell resize:NO]];
    UIView *view1f = [[UIView alloc] initWithFrame:CGRectMake(214, 160, 86, 130)];
    [view1f addSubview:[self buttonWithControllerType:ControllerMarketNetBSByBroker resize:NO]];
    
    [view1 addSubview:view1a];
    [view1 addSubview:view1b];
    [view1 addSubview:view1c];
    [view1 addSubview:view1d];
    [view1 addSubview:view1e];
    [view1 addSubview:view1f];
    
    
    // tab 2
    UIView *view2a = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
    [view2a addSubview:[self buttonWithControllerType:ControllerSecurityStockWatch resize:NO]];
    UIView *view2b = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
    [view2b addSubview:[self buttonWithControllerType:ControllerSecurityWatchList resize:NO]];
    UIView *view2c = [[UIView alloc] initWithFrame:CGRectMake(214, 5, 86, 130)];
    [view2c addSubview:[self buttonWithControllerType:ControllerSecurityTopStock resize:NO]];
    UIView *view2d = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 86, 130)];
    [view2d addSubview:[self buttonWithControllerType:ControllerSecurityNetBSByStock resize:NO]];
    UIView *view2e = [[UIView alloc] initWithFrame:CGRectMake(117, 160, 86, 130)];
    [view2e addSubview:[self buttonWithControllerType:ControllerSecurityCaptMarketCalendar resize:NO]];
    
//    UILabel *label2e = [self labelWithTitle:@"Capital Market Calendar"];
//    label2e.adjustsFontSizeToFitWidth = YES;
//    label2e.frame = CGRectMake(5, 78, 76, 50);
//    [view2e addSubview: label2e];
    
    [view2 addSubview:view2a];
    [view2 addSubview:view2b];
    [view2 addSubview:view2c];
    [view2 addSubview:view2d];
    [view2 addSubview:view2e];
    
    // tab 3
    UIView *view3a = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
    [view3a addSubview:[self buttonWithControllerType:ControllerOrderFormBuy resize:NO]];
    UIView *view3b = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
    [view3b addSubview:[self buttonWithControllerType:ControllerOrderFormSell resize:NO]];
    UIView *view3c = [[UIView alloc] initWithFrame:CGRectMake(214, 5, 86, 130)];
    [view3c addSubview:[self buttonWithControllerType:ControllerOrderList resize:NO]];
    UIView *view3d = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 86, 130)];
    [view3d addSubview:[self buttonWithControllerType:ControllerOrderTradeList resize:NO]];
    
    [view3 addSubview:view3a];
    [view3 addSubview:view3b];
    [view3 addSubview:view3c];
    [view3 addSubview:view3d];
    
    // tab 4
    UIView *view4a = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
    [view4a addSubview:[self buttonWithControllerType:ControllerAccountPortfolio resize:NO]];
    UIView *view4b = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
    [view4b addSubview:[self buttonWithControllerType:ControllerAccountCashFlow resize:NO]];
    UIView *view4c = [[UIView alloc] initWithFrame:CGRectMake(214, 5, 86, 130)];
    [view4c addSubview:[self buttonWithControllerType:ControllerAccountInfo resize:NO]];
    //ver 2.1
    UIView *view4d = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 86, 130)];
    [view4d addSubview:[self buttonWithControllerType:ControllerEntryCashWitdraw resize:NO]];
    UIView *view4e = [[UIView alloc] initWithFrame:CGRectMake(117, 160, 86, 130)];
    [view4e addSubview:[self buttonWithControllerType:ControllerDepositWithdrawList resize:NO]];
    UIView *view4f = [[UIView alloc] initWithFrame:CGRectMake(214, 160, 86, 130)];
    [view4f addSubview:[self buttonWithControllerType:ControllerToolsChangePin resize:NO]];
    UIView *view4g = [[UIView alloc] initWithFrame:CGRectMake(20, 315, 86, 130)];
    [view4g addSubview:[self buttonWithControllerType:ControllerToolsChangePasswd resize:NO]];
    
    UIScrollView *scroll2view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, view4.frame.origin.y, view4.frame.size.width, view4.frame.size.height + 85)];
    scroll2view.contentSize = CGSizeMake(scroll2view.frame.size.width, 480 + 85);
    
    UIView *tmp4View = [[UIView alloc] initWithFrame:CGRectMake(0, view4.frame.origin.y, view4.frame.size.width, view4.frame.size.height + 85)];
    
    [tmp4View addSubview:view4a];
    [tmp4View addSubview:view4b];
    [tmp4View addSubview:view4c];
    [tmp4View addSubview:view4d];
    [tmp4View addSubview:view4e];
    [tmp4View addSubview:view4f];
    [tmp4View addSubview:view4g];
    [scroll2view addSubview:tmp4View];
    [view4 addSubview:scroll2view];
    
    // tab 5
//    UIView *view5a = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
//    [view5a addSubview:[self buttonWithControllerType:ControllerToolsChangePin resize:NO]];
//    UIView *view5b = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
//    [view5b addSubview:[self buttonWithControllerType:ControllerToolsChangePasswd resize:NO]];
    //UIView *view5c = [[UIView alloc] initWithFrame:CGRectMake(214, 5, 86, 130)];
    UIView *view5c = [[UIView alloc] initWithFrame:CGRectMake(117, 5, 86, 130)];
    [view5c addSubview:[self buttonWithControllerType:ControllerToolsLogout resize:NO]];
    //ver 2.1
    //UIView *view5d = [[UIView alloc] initWithFrame:CGRectMake(20, 160, 86, 130)];
    UIView *view5d = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 86, 130)];
    [view5d addSubview:[self buttonWithControllerType:ControllerToolsSetting resize:NO]];
    
//    [view5 addSubview:view5a];
//    [view5 addSubview:view5b];
    [view5 addSubview:view5c];
    [view5 addSubview:view5d];

    
    [scrollview addSubview:view1];
    [scrollview addSubview:view2];
    [scrollview addSubview:view3];
    [scrollview addSubview:view4];
    [scrollview addSubview:view5];
    
    scrollview.contentSize = CGSizeMake(5 * scrollview.frame.size.width, scrollview.frame.size.height);
    
    [tabbar setSelectedItem:marketTabBar];
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 93, 76, 37)];
    label.text = title;
    //label.textColor = white;
    label.backgroundColor = black;
    label.font = [UIFont systemFontOfSize:14];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.baselineAdjustment = UIBaselineAdjustmentNone;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.adjustsFontSizeToFitWidth = YES;
    
    //label.textColor = [UIColor colorWithRed:167 green:152 blue:101 alpha:1];
    label.textColor = [UIColor colorWithHexString:@"A79865"];
    
    return label;
}

- (UIButton *)buttonWithControllerType:(ControllerType)type
{
    return  [self buttonWithControllerType:type resize:YES];
}

- (UIButton *)buttonWithControllerType:(ControllerType)type resize:(BOOL)resize
{
    UIImage *thumb = nil;
    
    if(ControllerMarketRunningTrade == type)
        thumb = [UIImage imageNamed:@"runningtrade"];
    else if(ControllerMarketSummary == type)
        thumb = [UIImage imageNamed:@"marketsummary"];
    else if(ControllerMarketRegionalSummary == type)
        thumb = [UIImage imageNamed:@"regionalsummary"];
    else if(ControllerMarketTopBroker == type)
        thumb = [UIImage imageNamed:@"topbroker"];
    else if(ControllerMarketFDNetBuySell == type)
        thumb = [UIImage imageNamed:@"foreignnetbs"];
    else if(ControllerMarketNetBSByBroker == type)
        thumb = [UIImage imageNamed:@"netbsbybroker"];
    
    else if(ControllerSecurityStockWatch == type)
        thumb = [UIImage imageNamed:@"stockwatch2"];
    else if(ControllerSecurityWatchList == type)
        thumb = [UIImage imageNamed:@"watchlist2"];
    else if(ControllerSecurityTopStock == type)
        thumb = [UIImage imageNamed:@"topstocks2"];
    else if(ControllerSecurityCaptMarketCalendar == type)
        thumb = [UIImage imageNamed:@"marketcalendar"];
    else if(ControllerSecurityNetBSByStock == type)
        thumb = [UIImage imageNamed:@"netbsbystock"];
    
    
    else if(ControllerOrderFormBuy == type) {
        thumb = [UIImage imageNamed:@"orderbuy"];
    }
    else if(ControllerOrderFormSell == type) {
        thumb = [UIImage imageNamed:@"ordersell"];
    }
    else if(ControllerOrderList == type) {
        thumb = [UIImage imageNamed:@"orderlist"];
    }
    else if(ControllerOrderTradeList == type) {
        thumb = [UIImage imageNamed:@"tradelist"];
    }
    
    
    else if(ControllerAccountPortfolio == type) {
        thumb = [UIImage imageNamed:@"portfolio"];
    }
    else if(ControllerAccountCashFlow == type) {
        thumb = [UIImage imageNamed:@"cashflow"];
    }
    else if(ControllerAccountInfo == type) {
        thumb = [UIImage imageNamed:@"accountinfo"];
    }
    else if(ControllerEntryCashWitdraw == type) {
        thumb = [UIImage imageNamed:@"entrycashwithdraw"];
    }
    else if(ControllerDepositWithdrawList == type) {
        thumb = [UIImage imageNamed:@"depositwithdrawlist"];
    }
    
    
    else if(ControllerToolsChangePin == type) {
        thumb = [UIImage imageNamed:@"changepin"];
    }
    else if(ControllerToolsChangePasswd == type) {
        thumb = [UIImage imageNamed:@"changepasswd"];
    }
    else if(ControllerToolsLogout == type) {
        thumb = [UIImage imageNamed:@"logout2"];
    }
    else if(ControllerToolsSetting == type) {
        thumb = [UIImage imageNamed:@"setting"];
    }
    
    if(nil == thumb) {
        return [self buttonWithImage:[ImageResources imageThumb] type:type resize:resize];
        //return [self buttonWithImage:[UIImage imageNamed:@"netbsbystock"] type:type resize:resize];
    }
    else if(resize) {
        if(ControllerSecurityCaptMarketCalendar == type)
            thumb = [thumb imageByScalingProportionallyToSize:CGSizeMake(70, 70)];
        else
            thumb = [thumb imageByScalingProportionallyToSize:CGSizeMake(76, 76)];
        
    }
    
    return [self buttonWithImage:thumb type:type resize:resize];
}

- (UIButton *)buttonWithImage:(UIImage *)image type:(ControllerType)type resize:(BOOL)resize
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (resize) button.frame = CGRectMake(0, 0, 86, 86);
    else button.frame = CGRectMake(0, 0, 86, 130);
    [button setImage:image forState:UIControlStateNormal];
    
    SEL selector = nil;
    if(ControllerMarketRunningTrade == type) {
        selector = @selector(controllerRunningTradeClicked);
    }
    else if(ControllerMarketSummary == type) {
        selector = @selector(controllerMarketSummaryClicked);
    }
    else if(ControllerMarketTopBroker == type) {
        selector = @selector(controllerTopBrokerClicked);
    }
    else if(ControllerMarketFDNetBuySell == type) {
        selector = @selector(controllerFDNetBuySellClicked);
    }
    else if(ControllerMarketNetBSByBroker == type) {
        selector = @selector(controllerNetBSByBrokerClicked);
    }
    else if(ControllerMarketRegionalSummary == type) {
        selector = @selector(controllerMarketRegionalSummaryClicked);
    }
    
    
    
    else if(ControllerSecurityStockWatch == type) {
        selector = @selector(controllerSecurityStockWatchClicked);
    }
    else if(ControllerSecurityWatchList == type) {
        selector = @selector(controllerSecurityWatchListClicked);
    }
    else if(ControllerSecurityTopStock == type) {
        selector = @selector(controllerSecurityTopStockClicked);
    }
    else if(ControllerSecurityNetBSByStock == type) {
        selector = @selector(controllerSecurityNetBSByStockClicked);
    }
    else if(ControllerSecurityCaptMarketCalendar == type) {
        selector = @selector(controllerSecurityCaptMarketCalendarClicked);
    }
    
    else if(ControllerOrderList == type) {
        selector = @selector(controllerOrderListClicked);
    }
    else if(ControllerOrderTradeList == type) {
        selector = @selector(controllerOrderTradeListClicked);
    }
    else if(ControllerOrderFormBuy == type) {
        selector = @selector(controllerOrderFormBuyClicked);
    }
    else if(ControllerOrderFormSell == type) {
        selector = @selector(controllerOrderFormSellClicked);
    }
    
    
    else if(ControllerAccountInfo == type) {
        selector = @selector(controllerAccountInfoClicked);
    }
    else if(ControllerAccountPortfolio == type) {
        selector = @selector(controllerAccountPortfolioClicked);
    }
    else if(ControllerAccountCashFlow == type) {
        selector = @selector(controllerAccountCashFlowClicked);
    }
    else if(ControllerEntryCashWitdraw == type) {
        selector = @selector(controllerEntryCashWitdrawClicked);
    }
    else if(ControllerDepositWithdrawList == type) {
        selector = @selector(controllerDepositWitdrawClicked);
    }
    
    
    else if(ControllerToolsChangePin == type) {
        selector = @selector(controllerToolsChangePinClicked);
    }
    else if(ControllerToolsChangePasswd == type) {
        selector = @selector(controllerToolsChangePasswdClicked);
    }
    else if(ControllerToolsLogout == type) {
        selector = @selector(controllerToolsLogoutClicked);
    }
    else if(ControllerToolsSetting == type) {
        selector = @selector(controllerToolsSettingClicked);
    }
    
    
    if(nil != selector)
        [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)viewWithRect:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.layer.cornerRadius = 8;
    view.layer.borderColor = [UIColor colorWithHexString:@"A79865"].CGColor;
    view.layer.borderWidth = 1.5f;
    
    //view.backgroundColor = black;
    //view.layer.cornerRadius = 5.0f;
    
    return view;
}

- (void)controllerNotAvailable
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your account is not authorized access this feature" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}

// tab-1
- (void)controllerRunningTradeClicked
{
    RunningTradeViewController *c = [[RunningTradeViewController alloc] initWithNibName:@"RunningTradeViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerMarketSummaryClicked
{
    MarketSummaryViewController *c = [[MarketSummaryViewController alloc] initWithNibName:@"MarketSummaryViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}


- (void)controllerTopBrokerClicked
{
    TopBrokerViewController *c = [[TopBrokerViewController alloc] initWithNibName:@"TopBrokerViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerFDNetBuySellClicked
{
    FDNetBuySellViewController *c = [[FDNetBuySellViewController alloc] initWithNibName:@"FDNetBuySellViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerNetBSByBrokerClicked
{
    NetBSByBrokerViewController *c = [[NetBSByBrokerViewController alloc] initWithNibName:@"NetBSByBrokerViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerMarketRegionalSummaryClicked
{
    static RegionalSummaryViewController *c;
    
    if(nil == c)
        c = [[RegionalSummaryViewController alloc] initWithNibName:@"RegionalSummaryViewController" bundle:[NSBundle mainBundle]];
    
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}




// tab-2
- (void)controllerSecurityStockWatchClicked
{
    StockWatchViewController *c = [[StockWatchViewController alloc] initWithNibName:@"StockWatchViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerSecurityNetBSByStockClicked
{
    NetBSByStockViewController *c = [[NetBSByStockViewController alloc] initWithNibName:@"NetBSByStockViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerSecurityTopStockClicked
{
    TopStockViewController *c = [[TopStockViewController alloc] initWithNibName:@"TopStockViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerSecurityWatchListClicked
{
    WatchListViewController *c = [[WatchListViewController alloc] initWithNibName:@"WatchListViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerSecurityCaptMarketCalendarClicked
{
    CapitalMarketCalendarViewController *c = [[CapitalMarketCalendarViewController alloc] initWithNibName:@"CapitalMarketCalendarViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}


// tab-3

- (void)controllerOrderFormBuyClicked
{
    
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showOrderFormBuy];
        }
        else {
            [self loginTrade:ScreenOrderFormBuy];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}
- (void)controllerOrderFormSellClicked
{
    
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showOrderFormSell];
        }
        else {
            [self loginTrade:ScreenOrderFormSell];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}

- (void)showOrderFormBuy
{
    OrderForm3ViewController *c = [[OrderForm3ViewController alloc] initWithNibName:@"OrderForm3ViewController" bundle:[NSBundle mainBundle] side:SideBuy];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)showOrderFormSell
{
    OrderForm3ViewController *c = [[OrderForm3ViewController alloc] initWithNibName:@"OrderForm3ViewController" bundle:[NSBundle mainBundle] side:SideSell];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}


- (void)controllerOrderListClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showOrderList];
        }
        else {
            [self loginTrade:ScreenOrderList];
        }
    }
    else {
        [self controllerNotAvailable];
    }
    
    
}

- (void)showOrderList
{
    OrderListViewController *c = [[OrderListViewController alloc] initWithNibName:@"OrderListViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerOrderTradeListClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showTradeList];
        }
        else {
            [self loginTrade:ScreenOrderTradeList];
        }
    }
    else {
        [self controllerNotAvailable];
    }
    
}

- (void)showTradeList
{
    TradeListViewController *c = [[TradeListViewController alloc] initWithNibName:@"TradeListViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)loginTrade:(ScreenOrderType)type
{
    PopupLoginTrade *loginTrade = [[PopupLoginTrade alloc] initWithTabView:self andScreenType:type];
    
    GRAlertView *alertLoginOl = [[GRAlertView alloc] initWithTitle:@"Login Trading"
                                                           message:@"Please type Your PIN"
                                                          delegate:loginTrade.delegate
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Login", nil];
    
    alertLoginOl.style = GRAlertStyleInfo;
    alertLoginOl.animation = GRAlertAnimationNone;
    alertLoginOl.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertLoginOl.tag = type;
    [alertLoginOl show];
}

// tab-4
- (void)controllerAccountInfoClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showAccountInfo];
        }
        else {
            [self loginTrade:ScreenOrderLoginOlAccountInfo];
        }

    }
    else {
        [self controllerNotAvailable];
    }
    
}

- (void)showAccountInfo
{
    AccountInfoViewController *c = [[AccountInfoViewController alloc] initWithNibName:@"AccountInfoViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerAccountPortfolioClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showAccountPortfolio];
        }
        else {
            [self loginTrade:ScreenOrderLoginOlAccountPortfolio];
        };
    }
    else {
        [self controllerNotAvailable];
    }

}

- (void)showAccountPortfolio
{
    PortfolioViewController *c = [[PortfolioViewController alloc] initWithNibName:@"PortfolioViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)controllerAccountCashFlowClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showAccountCashFlow];
        }
        else {
            [self loginTrade:ScreenOrderLoginOlAccountCashFlow];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}

- (void)controllerEntryCashWitdrawClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showEntryCashWitdraw];
        }
        else {
            [self loginTrade:ScreenOrderAccountEntryCashWithdraw];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}

-(void)showEntryCashWitdraw
{
    EntryCashWithdrawController *c = [[EntryCashWithdrawController alloc] initWithNibName:@"EntryCashWithdrawController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}



- (void)controllerDepositWitdrawClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showDepositWitdraw];
        }
        else {
            [self loginTrade:ScreenOrderAccountDepositWithdrawList];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}

-(void)showDepositWitdraw
{
    DepositWithdrawController *c = [[DepositWithdrawController alloc] initWithNibName:@"DepositWithdrawController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)showAccountCashFlow
{
    CashFlowViewController *c = [[CashFlowViewController alloc] initWithNibName:@"CashFlowViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}



// tab-5
- (void)showChangePin
{
    ChangePasswdViewController *c = [[ChangePasswdViewController alloc] initWithNibName:@"ChangePasswdViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
    
    c.titleBarItem.title = @"Change PIN";
    c.oldPasswdLabel.text = @"Old PIN";
    c.nwPasswdLabel.text = @"New PIN";
    c.changePin = YES;
}

- (void)controllerToolsChangePinClicked
{
    NSString *usertype = [AgentTrade sharedInstance].loginDataFeed.usertype;
    if(nil != usertype &&
       ([usertype isEqualToString:@"RCO"] || [usertype isEqualToString:@"ICO"])) {
        LoginData *accountOl = [AgentTrade sharedInstance].loginDataTrade;
        if(nil != accountOl) {
            [self showChangePin];
        }
        else {
            [self loginTrade:ScreenOrderToolsChangePin];
        }
    }
    else {
        [self controllerNotAvailable];
    }
}

- (void)controllerToolsChangePasswdClicked
{
    ChangePasswdViewController *c = [[ChangePasswdViewController alloc] initWithNibName:@"ChangePasswdViewController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
    
    c.changePin = NO;
}

- (void)controllerToolsLogoutClicked
{
    
    [AgentTrade sharedInstance].loginMI = NO;
    
    [[AgentTrade sharedInstance] clearAgentTrade];
    [[AgentFeed sharedInstance] clearMarketSummary:YES];
    [[DBLite sharedInstance] clearDictionary];
    
    [[[[UIApplication sharedApplication] delegate] window].rootViewController dismissViewControllerAnimated:YES completion:nil];
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController httpSysAdmin];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).userid = nil;
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).passwd = nil;
    
    
    self.alertLogout = [[UIAlertView alloc] initWithTitle:@"Signing out\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.alertLogout show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(self.alertLogout.bounds.size.width / 2, self.alertLogout.bounds.size.height - 50);
    [indicator startAnimating];
    [self.alertLogout addSubview:indicator];
    
    [self performSelector:@selector(closeAlertLogout) withObject:nil afterDelay:3];
}

- (void)controllerToolsSettingClicked
{
    SettingController *c = [[SettingController alloc] initWithNibName:@"SettingController" bundle:[NSBundle mainBundle]];
    [c setPreviouseController:self];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)closeAlertLogout
{
    if (nil != self.alertLogout) {
        [self.alertLogout dismissWithClickedButtonIndex:0 animated:YES];
    }
}




- (void)actionButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setIconBarItem:nil];
    [self setActionBarItem:nil];
    [self setScrollview:nil];
    [self setCaptionBarItem:nil];
    [self setTabbar:nil];
    [self setMarketTabBar:nil];
    [super viewDidUnload];
}


#pragma mark
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollview.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pagewidth / 2) / pagewidth) + 1;
    
    [captionBarItem setTitle:CAPTION[page]];
    NSArray *items = tabbar.items;
    [tabbar setSelectedItem:[items objectAtIndex:page]];
}


#pragma mark
#pragma UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(0 == item.tag) {
        [scrollview scrollRectToVisible:view1.frame animated:YES];
    }
    else if(1 == item.tag) {
        [scrollview scrollRectToVisible:view2.frame animated:YES];
    }
    else if(2 == item.tag) {
        [scrollview scrollRectToVisible:view3.frame animated:YES];
    }
    else if(3 == item.tag) {
        [scrollview scrollRectToVisible:view4.frame animated:YES];
    }
    else if(4 == item.tag) {
        [scrollview scrollRectToVisible:view5.frame animated:YES];
    }
}

@end




@interface PopupLoginTrade() <UIAlertViewDelegate>

@property (nonatomic) TabViewController *ctrl;
@property (nonatomic) ScreenOrderType screenType;

@end

@implementation PopupLoginTrade

- (id)initWithTabView:(TabViewController *)c andScreenType:(ScreenOrderType)type
{
    if ([super init]) {
        _ctrl = c;
        _screenType = type;
        _delegate = self;
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) {
        NSString* pin = ((UITextField*)[alertView textFieldAtIndex:0]).text;
        
        if(pin.length > 0) {
            
            [self.ctrl.animIndicator startAnimating];
            [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
            [[AgentTrade sharedInstance] LoginTrade:pin];
        }
        else {
            [self performSelector:@selector(loginError:) withObject:@"PIN is empty, please input pin before login" afterDelay:.5];
        }
    }
}

- (void)loginError:(NSString *)message
{
    GRAlertView *alertLoginOl = [[GRAlertView alloc] initWithTitle:@"Login Trading"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Login", nil];
    
    alertLoginOl.style = GRAlertStyleInfo;
    alertLoginOl.animation = GRAlertAnimationNone;
    alertLoginOl.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertLoginOl.tag = self.screenType;
    [alertLoginOl show];
}

#pragma mark -
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    NSLog(@"%s\n%@", __PRETTY_FUNCTION__, msg);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.ctrl.animIndicator stopAnimating];
        
        if (RecordTypeLoginOl == msg.recType) {
            if(StatusReturnResult == msg.recStatusReturn) {
                
                if(ScreenOrderLoginOlAccountCashFlow == self.screenType)
                    [self.ctrl showAccountCashFlow];
                else if(ScreenOrderLoginOlAccountPortfolio == self.screenType)
                    [self.ctrl showAccountPortfolio];
                else if(ScreenOrderLoginOlAccountInfo == self.screenType)
                    [self.ctrl showAccountInfo];
                else if(ScreenOrderToolsChangePin == self.screenType)
                    [self.ctrl showChangePin];
                else if(ScreenOrderList == self.screenType)
                    [self.ctrl showOrderList];
                else if(ScreenOrderTradeList == self.screenType)
                    [self.ctrl showTradeList];
                else if(ScreenOrderFormBuy == self.screenType)
                    [self.ctrl showOrderFormBuy];
                else if(ScreenOrderFormSell == self.screenType)
                    [self.ctrl showOrderFormSell];
                else if(ScreenOrderAccountEntryCashWithdraw == self.screenType)
                    [self.ctrl showEntryCashWitdraw];
                else if(ScreenOrderAccountDepositWithdrawList == self.screenType)
                    [self.ctrl showDepositWitdraw];

                [[AgentTrade sharedInstance] subscribe:RecordTypeClientList requestType:RequestGet];
            }
            else {
                [self loginError:msg.recStatusMessage];
            }
        }
    });
}

@end
