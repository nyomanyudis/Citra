//
//  DepositWithdrawController.h
//  Ciptadana
//
//  Created by Reyhan on 6/7/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"

@interface DepositWithdrawController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animator;

@end



@interface UIDepositCell : UITableViewCell

@property (retain, nonatomic) UILabel *amountTxt;
@property (retain, nonatomic) UILabel *statusTxt;
@property (retain, nonatomic) UILabel *requestDateTxt;

@end