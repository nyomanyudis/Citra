//
//  OrderListViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/28/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"
#import "Protocol.pb.h"


#define BORDER @[@"All", @"Regular", @"Negotiation", @"Cash"]
#define ACTION @[@"All", @"Buy", @"Sell"]
#define STATUS @[@"All", @"Open", @"Fully Match", @"Partial Match", @"Pooling", @"Amended", @"Withdraw", @"Rejected", @"In Process", @"Waiting Process"]

@interface OrderListViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIDropList *clientDropList;
//@property (weak, nonatomic) IBOutlet UIDropList *borderDropList;
@property (weak, nonatomic) IBOutlet UIDropList *bsDropList;
@property (weak, nonatomic) IBOutlet UIDropList *statusDropList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

//- (NSString*) statusInitial:(NSString*)status;
//- (NSString*) statusDescription:(NSString*)status;
+ (NSString*) statusInitial:(NSString*)status;
+ (NSString*) statusDescription:(NSString*)status;
+ (NSMutableArray *)sortOrderList:(NSArray *)source;
+ (NSMutableArray *)sortOrderList2:(NSArray *)source;
+ (BOOL) isStatusAllowed:(NSString*)status;

+ (void)TxOrderPopup:(TxOrder*)tx tradeDone:(BOOL)done;

@end




@interface OrderListCell : UITableViewCell

@property (retain, nonatomic) UILabel *timeLabel;
@property (retain, nonatomic) UILabel *aLabel;
@property (retain, nonatomic) UILabel *stockLabel;
@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *lotLabel;
@property (retain, nonatomic) UILabel *sLabel;

@end



@interface OrderList2Cell : UITableViewCell

@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *volLabel;

@end


@interface TxOrderCell : UITableViewCell

@property (retain, nonatomic) UILabel *leftLabel;
@property (retain, nonatomic) UILabel *sepLabel;
@property (retain, nonatomic) UILabel *rightLabel;

@end