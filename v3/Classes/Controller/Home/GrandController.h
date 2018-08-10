//
//  GrandController.h
//  Ciptadana
//
//  Created by Reyhan on 10/6/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRevealViewController.h"
#import "MarketData.h"
#import "MarketFeed.h"
#import "MarketTrade.h"
#import "StandardView.h"
#import "ShortCutMenuView.h"

#import "Util.h"

@interface GrandController : UIViewController

@property (strong, nonatomic, nonnull) StandardView* standardView;
@property (strong, nonatomic, nonnull) StandardView* standardBottom;
@property (strong, nonatomic, nonnull) ShortCutMenuView* shortCutMenuView;
@property (strong, nonnull) KiIndicesData *composite;


- (void)callback;
- (void)updateIndices:(KiRecord * _Nullable)record;

//long long stringToHexa(NSString *hexa);

@end
