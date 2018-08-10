//
//  StockWatchViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/7/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "Protocol.pb.h"


static NSMutableDictionary *chartDictionary;
static NSMutableDictionary *level2Dictionary;

@interface StockWatchViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UITextField *stockTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *buySellSegment;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *chgLabel;
@property (weak, nonatomic) IBOutlet UILabel *chgpLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiLabel;
@property (weak, nonatomic) IBOutlet UILabel *loLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UILabel *prevLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UILabel *vol2Label;
@property (weak, nonatomic) IBOutlet UILabel *val2Label;
@property (weak, nonatomic) IBOutlet UILabel *valLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLabel;


@end





@interface StockWatchLevel2Cell : UITableViewCell

@property (retain, nonatomic) UILabel *bLabel;
@property (retain, nonatomic) UILabel *lotLabel;
@property (retain, nonatomic) UILabel *bidLabel;
@property (retain, nonatomic) UILabel *offerLabel;
@property (retain, nonatomic) UILabel *lot2Label;
@property (retain, nonatomic) UILabel *oLabel;

@end

@interface StockWatchLevel3Cell : UITableViewCell

@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *blotLabel;
@property (retain, nonatomic) UILabel *slotLabel;
@property (retain, nonatomic) UILabel *lotLabel;

@end

@interface StockWatchTradeCell : UITableViewCell

@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *lotLabel;
@property (retain, nonatomic) UILabel *bLabel;
@property (retain, nonatomic) UILabel *sLabel;
@property (retain, nonatomic) UILabel *buyerLabel;
@property (retain, nonatomic) UILabel *sellerLabel;

@end