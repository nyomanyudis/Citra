//
//  TabViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/25/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.pb.h"


typedef enum {
    ScreenOrderLoginMi = 1,
    ScreenOrderLoginOlAccountCashFlow,
    ScreenOrderLoginOlAccountPortfolio,
    ScreenOrderLoginOlAccountInfo,
    ScreenOrderLogoutMi,
    
    ScreenOrderList,
    ScreenOrderTradeList,
    ScreenOrderFormBuy,
    ScreenOrderFormSell,
    
    ScreenOrderAccountInfo,
    ScreenOrderAccountCashFlow,
    ScreenOrderAccountPortfolioList,
    ScreenOrderAccountPortfolioOrder,
    ScreenOrderAccountEntryCashWithdraw,
    ScreenOrderAccountDepositWithdrawList,
    
    ScreenOrderToolsChangePasswd,
    ScreenOrderToolsChangePin,
    
} ScreenOrderType;

typedef enum {
    ScreenHomeCurrency = 0,
    ScreenHomeIndices,
    ScreenHomeRegionalIndices,
    ScreenHomeTopStock,//home currency, ihsg
    ScreenHomeScroll1View,
    ScreenHomeRegionalSummary,
    
    ScreenAbstractIHSG,
    
    ScreenMarketRunningTrade,
    ScreenMarketTopBroker,
    ScreenMarketFDNetBuySell,
    ScreenMarketNetBSByBroker,
    ScreenMarketRegionalSummary,
    
    
    ScreenSecurityNetBSByStock,
    ScreenSecurityTopStock,
    ScreenSecurityWatchList,
    ScreenSecurityStockWatch,
    ScreenSecurityStockWatchOrder,
} ScreenType;


@interface TabViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iconBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *captionBarItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *marketTabBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;

@property (weak, nonatomic) IBOutlet UIButton *marketButton;
@property (weak, nonatomic) IBOutlet UIButton *toolsButton;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *securityButton;


@end


@interface PopupLoginTrade : NSObject

@property (nonatomic) id<UIAlertViewDelegate> delegate;

- (id)initWithTabView:(TabViewController *)c andScreenType:(ScreenOrderType)type;

@end