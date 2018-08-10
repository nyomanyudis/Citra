//
//  OrderForm3ViewController.h
//  Ciptadana
//
//  Created by Reyhan on 2/24/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"
#import "Protocol.pb.h"

@class Order3View;

@interface OrderForm3ViewController : AbstractViewController

typedef enum {
    SideBuy,
    SideSell,
} OrderSide;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;


@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
//@property (weak, nonatomic) IBOutlet UIButton *amendButton;
//@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *orderScroll;
@property (weak, nonatomic) IBOutlet UITableView *level2table;
@property (weak, nonatomic) IBOutlet UITableView *ordertable;
@property (weak, nonatomic) IBOutlet UIDropList *clientDroplist;
@property Order3View *buyView;//, *sellView;//, *amendView, *withdrawView;
@property TxOrder *selectedTxOrder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;

//@property (weak, nonatomic) IBOutlet UITextField *cashBalanceTxt;

@property BOOL submitOrder;
@property uint level2Price;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil side:(OrderSide)side;
- (void)alert:(NSString*)message;

@end




@interface Order3View : UIView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *stockInput;
@property (strong, nonatomic) IBOutlet UITextField *priceInput;
@property (strong, nonatomic) IBOutlet UITextField *lotInput;
@property (strong, nonatomic) IBOutlet UITextField *valueInput;
@property (strong, nonatomic) IBOutlet UITextField *orderpowerInput;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property OrderForm3ViewController* vc;
@property (weak, nonatomic) IBOutlet UILabel *opLabel;
@property (weak, nonatomic) IBOutlet UITextField *cashInput;

- (id)initWithOrderForm:(OrderForm3ViewController*)vc;
- (void)handleSingleTap:(UITapGestureRecognizer*)recognizer;

@end


@interface Order3Level2Cell : UITableViewCell

@property UILabel *bidpriceLabel;
@property UILabel *bidlotLabel;
@property UILabel *offerpriceLabel;
@property UILabel *offerlotLabel;

@end
