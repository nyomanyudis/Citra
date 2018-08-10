//
//  TradeListViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"

@interface TradeListViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

//@property (weak, nonatomic) IBOutlet UIDropList *borderDropList;
@property (weak, nonatomic) IBOutlet UIDropList *clientDropList;
@property (weak, nonatomic) IBOutlet UIDropList *bsDropList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@end
