//
//  RunningTradeViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/25/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface RunningTradeViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end




@interface RunningTradeCell : UITableViewCell

@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UILabel *stockLabel;
@property (retain, nonatomic) UILabel *buyerLabel;
@property (retain, nonatomic) UILabel *sellerLabel;
@property (retain, nonatomic) UILabel *lotLabel;
@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *chgLabel;
@property (retain, nonatomic) UIButton *chgButton;

@end