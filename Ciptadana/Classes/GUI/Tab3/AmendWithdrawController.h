//
//  AmendWithdrawController.h
//  Ciptadana
//
//  Created by Reyhan on 3/25/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIButton+Customized.h"
#import "Protocol.pb.h"

@interface AmendWithdrawController : AbstractViewController

- (id) initWithTxOrder:(TxOrder*)tx isWithdraw:(BOOL)withdraw;
+ (NSMutableDictionary *)getSubmitParam;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarItem;

//@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
//@property (weak, nonatomic) IBOutlet UIButton *amendButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *stockInput;
@property (weak, nonatomic) IBOutlet UITextField *jatsInput;
@property (weak, nonatomic) IBOutlet UITextField *priceInput;
@property (weak, nonatomic) IBOutlet UITextField *lotInput;
@property (weak, nonatomic) IBOutlet UITextField *valueInput;
@property (weak, nonatomic) IBOutlet UITextField *opInput;
@property (weak, nonatomic) IBOutlet UILabel *opLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animIndicator;

@end
