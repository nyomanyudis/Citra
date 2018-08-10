//
//  ViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDropList.h"
#import "Protocol.pb.h"



//Broker
//code - name - totVolume - totVolumeLot - totValue - totFreq
//
//Stock
//time - level - sector - stockcode - stockname - lastPrice - chg - chgPct - totVolume - totVolumeLot - totValue - totFreq
//
//Indices
//time - IdxCode - IdxLast - IdxOpen - IdxHighest - IdxLowest - IdxPrev - IdxChg - IdxChgPct
//
//Currency
//key - close - chg - chgPct
//
//Regional
//key - name - close - chg - chgPct
//
//Futures
//key - name - close - chg - chgPct
//
//Summary
//volume - value - freq


@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *iconBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarItem;

@property (strong, nonatomic) NSMutableDictionary *indicesDictionary;
@property (strong, nonatomic) NSMutableDictionary *regionalDictionary;
@property (strong, nonatomic) NSMutableDictionary *futureDictionary;


@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftValuePersenLabel;
@property (weak, nonatomic) IBOutlet UIDropList *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightValuePersenLabel;
@property (weak, nonatomic) IBOutlet UIDropList *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *rightPriceLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;

- (IBAction)citraAction:(id)sender;


//- (NSMutableArray *)mutableBroker;
- (KiIndices *)indicesIhsg;

- (void)startCallback;

- (void)httpSysAdmin;
- (void)httpStop;

//- (void)startMarketInfoAgent;
//- (void)subscribeHome;


@end





@interface UIHomeTopStockCell : UITableViewCell

@property (retain, nonatomic) UILabel *noLabel;
@property (retain, nonatomic) UILabel *stockLabel;
@property (retain, nonatomic) UILabel *lastLabel;
@property (retain, nonatomic) UILabel *chgLabel;
@property (retain, nonatomic) UILabel *chgpLabel;

@end


@interface UIHomeTopBrokerCell : UITableViewCell

@property (retain, nonatomic) UILabel *noLabel;
@property (retain, nonatomic) UILabel *brokerLabel;
@property (retain, nonatomic) UILabel *tvalLabel;
@property (retain, nonatomic) UILabel *tvolLabel;
@property (retain, nonatomic) UILabel *tfreqLabel;

@end


@interface BrokerSummary : NSObject

@property (assign) float tval;
@property (assign) float tvol;
@property (assign) float tfreq;

- (id)initWithTransaction:(Transaction *)t;

@end
