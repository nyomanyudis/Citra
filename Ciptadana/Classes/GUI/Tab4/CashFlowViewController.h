//
//  CashFlowViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"

@interface CashFlowViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UIDropList *clientDropList;
@property (weak, nonatomic) IBOutlet UILabel *rt0Label;
@property (weak, nonatomic) IBOutlet UILabel *rt1Label;
@property (weak, nonatomic) IBOutlet UILabel *rt2Label;
@property (weak, nonatomic) IBOutlet UILabel *rt3Label;
@property (weak, nonatomic) IBOutlet UILabel *pt0Label;
@property (weak, nonatomic) IBOutlet UILabel *pt1Label;
@property (weak, nonatomic) IBOutlet UILabel *pt2Label;
@property (weak, nonatomic) IBOutlet UILabel *pt3Label;
@property (weak, nonatomic) IBOutlet UILabel *nt0Label;
@property (weak, nonatomic) IBOutlet UILabel *nt1Label;
@property (weak, nonatomic) IBOutlet UILabel *nt2Label;
@property (weak, nonatomic) IBOutlet UILabel *nt3Label;
@property (weak, nonatomic) IBOutlet UILabel *nc0Label;
@property (weak, nonatomic) IBOutlet UILabel *nc1Label;
@property (weak, nonatomic) IBOutlet UILabel *nc2Label;
@property (weak, nonatomic) IBOutlet UILabel *nc3Label;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;

@end
