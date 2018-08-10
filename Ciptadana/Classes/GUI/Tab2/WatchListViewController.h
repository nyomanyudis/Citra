//
//  WatchListViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/4/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "Protocol.pb.h"

@interface WatchListViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *detailview;
@property (weak, nonatomic) IBOutlet UIButton *addRemoveButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiLabel;
@property (weak, nonatomic) IBOutlet UILabel *loLabel;
@property (weak, nonatomic) IBOutlet UILabel *volLabel;
@property (weak, nonatomic) IBOutlet UILabel *peLabel;

@property (weak, nonatomic) IBOutlet UILabel *capLabel;
@property (weak, nonatomic) IBOutlet UILabel *hi52Label;
@property (weak, nonatomic) IBOutlet UILabel *lo52Label;
@property (weak, nonatomic) IBOutlet UILabel *avgLabel;
@property (weak, nonatomic) IBOutlet UILabel *yieldLabel;

@end




@interface WatchListCell : UITableViewCell

@property (retain, nonatomic) UILabel *codeLabel;
@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *prevLabel;
@property (retain, nonatomic) UIButton *chgLabel;

@property (retain, nonatomic) KiStockSummary *kiStockSummary;
@property (retain, nonatomic) KiStockData *kiStockData;

@end