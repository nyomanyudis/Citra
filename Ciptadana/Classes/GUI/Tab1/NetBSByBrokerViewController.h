//
//  NetBSByBrokerViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/27/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "Protocol.pb.h"

@interface NetBSByBrokerViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;

@property (weak, nonatomic) IBOutlet UITextField *brokerTextField;
@property (weak, nonatomic) IBOutlet UILabel *kiLabel;
@property (weak, nonatomic) IBOutlet UIButton *regularButton;
@property (weak, nonatomic) IBOutlet UIButton *negoButton;
@property (weak, nonatomic) IBOutlet UIButton *cashButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;


@end





@interface NetBSByBrokerCell : UITableViewCell

@property (retain, nonatomic) UILabel *stockLabel;
@property (retain, nonatomic) UILabel *tvalLabel;
@property (retain, nonatomic) UILabel *tlotLabel;
@property (retain, nonatomic) UILabel *nvalLabel;
@property (retain, nonatomic) UILabel *nlotLabel;
@property UIImageView *roundImage;

@end


@interface Transaction2 : NSObject

-(id)initWithTransaction:(Transaction*)transaction andBoard:(Board)board;

@property int32_t codeId;//stock code
@property Board board;
@property int64_t tvalue;
@property int64_t tlot;
@property int64_t nvalue;
@property int64_t nlot;

@end