//
//  AmendWithdrawController.m
//  Ciptadana
//
//  Created by Reyhan on 3/25/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AmendWithdrawController.h"
#import "AppDelegate.h"
#import "MLTableAlert.h"
#import "OrderListViewController.h"
#import "ConstractOrder.h"

@interface AmendWithdrawController ()

@property ClientList *client;
@property TxOrder *txOrder;
@property Float64 tradeQty;
@property Float64 orderPower;

@property BOOL withdraw;

@property id textFieldValue;
@property id textFieldOrderpower;

@property NSNumberFormatter *nf;
@end

@implementation AmendWithdrawController


static NSMutableDictionary *opParam;


- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)homeBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[UITextField class]]) {
            if([(UITextField*)obj resignFirstResponder]) break;
        }
    }
}

- (id) initWithTxOrder:(TxOrder*)tx isWithdraw:(BOOL)withdraw
{
    if(self  = [super initWithNibName:@"AmendWithdrawController" bundle:[NSBundle mainBundle]]) {
        _txOrder = tx;
        _withdraw = withdraw;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    _nf = [[NSNumberFormatter alloc] init];
    [_nf setNumberStyle:NSNumberFormatterDecimalStyle];
    [_nf setMaximumFractionDigits:2];
    [_nf setMinimumFractionDigits:2];
    [_nf setRoundingMode:NSNumberFormatterRoundDown];
    [_nf setDecimalSeparator:@"."];
    [_nf setGroupingSeparator:@","];
    [_nf setAllowsFloats:YES];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [_backBarItem setCustomView:backButton];
    [_homeBarItem setCustomView:homeButton];
    
    [_sendButton BlackBackgroundCustomized];
    
    [_sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self tapGestureRecognizer];
    
    _textFieldValue = _valueInput;
    _textFieldOrderpower = _opInput;
    
    NSArray *array = [AgentTrade sharedInstance].getClients;
    
    for (ClientList *cl in array) {
        if ([cl.clientcode isEqualToString:self.txOrder.clientCode]) {
            self.client = cl;
        }
    }
    
    if(nil != self.client) {
        self.tradeQty = 0;
        int share = [AgentTrade sharedInstance].shares;
        
        if([@"1" isEqualToString:self.txOrder.orderStatus]) {
            NSArray *arrayDone = [AgentTrade sharedInstance].getTrades;
            for (TxOrder *txDone in arrayDone) {
                if([txDone.orderId isEqualToString:self.txOrder.orderId]) {
                    self.tradeQty += txDone.tradeQty;
                }
            }
        }

        
        self.clientLabel.text = self.client.name;
        self.stockInput.text = self.txOrder.securityCode;
        self.jatsInput.text = self.txOrder.jatsOrderId;
        self.priceInput.text = currencyString([NSNumber numberWithInt:self.txOrder.price]);
        self.lotInput.text = currencyString([NSNumber numberWithFloat:self.txOrder.orderQty]);
        self.valueInput.text = currencyString([NSNumber numberWithDouble:(self.txOrder.price * self.txOrder.orderQty * share)]);
        
        // buy
        if(1 == self.txOrder.side) {
            self.opLabel.text = @"Orderpower";
            [[AgentTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:self.client.clientcode];
        }
        // sell
        else {
            self.opLabel.text = @"Portfolio";
            [[AgentTrade sharedInstance] subscribeAvaiable:self.txOrder.securityCode clientcode:self.client.clientcode];
        }
    }
    
    if (_withdraw) {
        [self setAsWithdrawForm];
    }
    else {
        [self setAsAmendForm];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAsAmendForm
{
    
    _priceInput.text = [NSString stringWithFormat:@"%i", [[self.nf numberFromString:_priceInput.text] intValue]];
    _lotInput.text =  [NSString stringWithFormat:@"%.0f", [[self.nf numberFromString:_lotInput.text] floatValue]];
    _priceInput.enabled = YES;
    _priceInput.backgroundColor = [UIColor whiteColor];
    _lotInput.enabled = YES;
    _lotInput.backgroundColor = [UIColor whiteColor];
    
    BOOL doesContain = [self.view.subviews containsObject:_valueInput];
    if(NO == doesContain) {
        _valueInput = _textFieldValue;
        _opInput = _textFieldOrderpower;
        [self.view addSubview:_valueInput];
        [self.view addSubview:_opInput];
        
        _valueLabel.text = @"Value";
        _opLabel.text = self.txOrder.side == 1 ? @"Orderpower" : @"Portfolio";
    }
    
    [_titleBarItem setTitle:@"Amend Form"];
}

- (void)setAsWithdrawForm
{
    _priceInput.enabled = NO;
    _priceInput.backgroundColor = [UIColor grayColor];
    _lotInput.enabled = NO;
    _lotInput.backgroundColor = [UIColor grayColor];
    
    BOOL doesContain = [self.view.subviews containsObject:_valueInput];
    if(doesContain) {
        [_valueInput removeFromSuperview];
        [_opInput removeFromSuperview];
        
        _valueLabel.text = @"";
        _opLabel.text = @"";
    }
     
    [_titleBarItem setTitle:@"Withdraw Form"];

}

#pragma mark
#pragma private method

- (void)orderAmendConfirmation
{
    if(_client != nil && _client.sid != nil && _client.sid.length >= 6) {
        int32_t price = [[self.nf numberFromString:_priceInput.text] intValue];
        Float64 lot = [[self.nf numberFromString:_lotInput.text] floatValue];
        
        UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            TxOrderCell *cell = [[TxOrderCell alloc] init];
            
            cell.rightLabel.textColor = [UIColor blackColor];
            cell.leftLabel.backgroundColor = [UIColor clearColor];
            cell.sepLabel.backgroundColor = [UIColor clearColor];
            cell.rightLabel.backgroundColor = [UIColor clearColor];
            
            if (0 == indexPath.row) {
                cell.leftLabel.text = @"Client Name";
                cell.rightLabel.text  = _client.name;
            }
            else if (1 == indexPath.row) {
                cell.leftLabel.text = @"Stock";
                cell.rightLabel.text  = self.txOrder.securityCode;
            }
            else if (2 == indexPath.row) {
                cell.leftLabel.text = @"Price";
                cell.rightLabel.text  = currencyString([NSNumber numberWithInt:price]);
            }
            else if (3 == indexPath.row) {
                cell.leftLabel.text = @"Lot";
                cell.rightLabel.text  = currencyString([NSNumber numberWithFloat:lot]);
            }
            else if (4 == indexPath.row) {
                int share = [AgentTrade sharedInstance].shares;
                cell.leftLabel.text = @"Value";
                cell.rightLabel.text  = currencyString([NSNumber numberWithDouble:(price * lot * share)]);
            }
            
            cell.backgroundColor = 1 == _txOrder.side ? [UIColor redColor] : [UIColor greenColor];
            
            return  cell;
        };
        
        CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            return 25;
        };
        
        NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
            return 5;
        };
        
        NSString *sideLabel = 1 == _txOrder.side ? @" Buy Order" : @" Sell Order";
        
        // create the alert
        MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:CONCAT(@"Amend", sideLabel)
                                              cancelButtonTitle:@"Confirm"
                                                  okButtonTitle:@"Cancel"
                                               otherButtonTitle:nil
                                                   numberOfRows:row
                                                       andCells:cell
                                                 andCellsHeight:cellHeight];
        [alert setHeight:160];
        
        void (^cancelButtonOnClick)(void) = ^ {
            [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self composeMsgAmend:_client txOrder:_txOrder quantity:lot price:price];
        };
        alert.cancelButtonOnClick = cancelButtonOnClick;
        
        void (^okButtonOnClick)(void) = ^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.okButtonOnClick = okButtonOnClick;
        
        // show the alert
        if(1 == _txOrder.side)
            [alert showWithColor:[UIColor redColor]];
        else
            [alert showWithColor:[UIColor greenColor]];
    }
    else {
        [self alert:@"Invalid Client Or SID, quit App and restart to fix issue"];
    }
    
}

- (void)orderWithdrawConfirmation
{
    if(_client != nil && _client.sid != nil && _client.sid.length >= 6) {
        UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            TxOrderCell *cell = [[TxOrderCell alloc] init];
            
            cell.rightLabel.textColor = [UIColor blackColor];
            cell.leftLabel.backgroundColor = [UIColor clearColor];
            cell.sepLabel.backgroundColor = [UIColor clearColor];
            cell.rightLabel.backgroundColor = [UIColor clearColor];
            
            if (0 == indexPath.row) {
                cell.leftLabel.text = @"Client Name";
                cell.rightLabel.text  = _client.name;
            }
            else if (1 == indexPath.row) {
                cell.leftLabel.text = @"Stock";
                cell.rightLabel.text  = self.txOrder.securityCode;
            }
            else if (2 == indexPath.row) {
                cell.leftLabel.text = @"Price";
                cell.rightLabel.text  = currencyString([NSNumber numberWithInt:self.txOrder.price]);
            }
            else if (3 == indexPath.row) {
                cell.leftLabel.text = @"Lot";
                //cell.rightLabel.text  = currencyString([NSNumber numberWithFloat:self.txOrder.orderQty]);
                cell.rightLabel.text  = [NSString stringWithFormat:@"%.2f", self.txOrder.orderQty];
            }
            else if (4 == indexPath.row) {
                int share = [AgentTrade sharedInstance].shares;
                cell.leftLabel.text = @"Value";
                cell.rightLabel.text  = currencyString([NSNumber numberWithDouble:(self.txOrder.price * self.txOrder.orderQty * share)]);
            }
            
            cell.backgroundColor = 1 == _txOrder.side ? [UIColor redColor] : [UIColor greenColor];
            
            return  cell;
        };
        
        CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            return 25;
        };
        
        NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
            return 5;
        };
        
        NSString *sideLabel = 1 == _txOrder.side ? @" Buy Order" : @" Sell Order";
        
        // create the alert
        MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:CONCAT(@"Cancel", sideLabel)
                                              cancelButtonTitle:@"Confirm"
                                                  okButtonTitle:@"Cancel"
                                               otherButtonTitle:nil
                                                   numberOfRows:row
                                                       andCells:cell
                                                 andCellsHeight:cellHeight];
        [alert setHeight:160];
        
        void (^cancelButtonOnClick)(void) = ^ {
            [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self composeMsgWithdraw:_client txOrder:_txOrder];
        };
        alert.cancelButtonOnClick = cancelButtonOnClick;
        
        void (^okButtonOnClick)(void) = ^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        alert.okButtonOnClick = okButtonOnClick;
        
        // show the alert
        if(1 == _txOrder.side)
            [alert showWithColor:[UIColor redColor]];
        else
            [alert showWithColor:[UIColor greenColor]];
    }
    else {
        [self alert:@"Invalid Client Or SID, quit App and restart to fix issue"];
    }
    
    

}

- (void)sendButtonClicked
{
    if (_withdraw) {
        [self orderWithdrawConfirmation];
    }
    else {
        
        int share = [AgentTrade sharedInstance].shares;
        int32_t price = [[self.nf numberFromString:_priceInput.text] intValue];
        Float64 lot = [[self.nf numberFromString:_lotInput.text] floatValue];
        double value = price * lot * share;
        Float64 op = self.orderPower + (self.txOrder.price * (fabs(self.txOrder.tradeQty - self.txOrder.orderQty)) * share);
        
        //_valueInput.text = currencyString([NSNumber numberWithDouble:price * lot * share]);
        _valueInput.text = currencyString([NSNumber numberWithDouble:value]);
        
        //double value = [[self.nf numberFromString:_valueInput.text] doubleValue];
        //double op = [[self.nf numberFromString:_opInput.text] doubleValue];
        
        // cek ada perubahan ?
        if(price <= 0) {
            [self alert:@"Price must be greater than zero"];
        }
        else if(lot <= 0) {
            [self alert:@"Lot must be greater than zero"];
        }
        else if(price == _txOrder.price && lot == _txOrder.orderQty) {
            [self alert:@"Apologize, you must change the value to do amend"];
        }
        else if(1 == _txOrder.side && op < value) {
            [self alert:CONCAT(@"You have not enough The Orderpower to buy ", _stockInput.text.uppercaseString)];
        }
//        else if(2 == _txOrder.side && op < lot) {
//            [self alert:@"We apologize, your portfolio of this transaction is not enough"];
//        }
        else {
            [self orderAmendConfirmation];
        }
    }
}

+ (NSMutableDictionary *)getSubmitParam
{
    return opParam;
}

- (void)composeMsgWithdraw:(ClientList*)client txOrder:(TxOrder*)order
{
    LoginData *account = [AgentTrade sharedInstance].loginDataFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"F" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    
    // Body
    [op setObject:account.userId forKey:O_CLIENTID];
    [op setObject:order.jatsOrderId forKey:O_ORDERID];
    [op setObject:order.orderId forKey:O_ORIGCLORDID];
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:order.securityCode forKey:O_SYMBOL];
    [op setObject:order.board forKey:O_SYMBOLSFX];
    [op setObject:[NSString stringWithFormat:@"%i", order.side] forKey:O_SIDE];
    [op setObject:[NSString stringWithFormat:@"%.2f", order.orderQty] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%i", order.price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    //[op setObject:@"1" forKey:O_ORIGGTCID];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    opParam = op;
    
    [[AgentTrade sharedInstance] composeMsg:op composeMsg:NO];
}

- (void)composeMsgAmend:(ClientList*)client txOrder:(TxOrder*)order quantity:(uint32_t)lot price:(Float32)price;
{
    LoginData *account = [AgentTrade sharedInstance].loginDataFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"G" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    
    // Body
    [op setObject:account.userId forKey:O_CLIENTID];
    [op setObject:order.jatsOrderId forKey:O_ORDERID];
    [op setObject:order.orderId forKey:O_ORIGCLORDID];
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:order.securityCode forKey:O_SYMBOL];
    [op setObject:order.board forKey:O_SYMBOLSFX];
    [op setObject:[NSString stringWithFormat:@"%i", order.side] forKey:O_SIDE];
    //    [op setObject:[NSString stringWithFormat:@"%.0f", order.orderQty] forKey:O_ORDERQTY];
    //    [op setObject:[NSString stringWithFormat:@"%i", order.price] forKey:O_PRICE];
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%.0f", price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    opParam = op;
    
    [[AgentTrade sharedInstance] composeMsg:op composeMsg:YES];
}

- (void)alert:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeGetOrderPower == msg.recType) {
        self.orderPower = msg.recOrderPower;
        [self updateOrderPower:msg.recOrderPower];
    }
    else if(RecordTypeGetAvaiableStock == msg.recType) {
        self.orderPower = msg.recOrderPower;
        [self updateAvaibleStock:msg.recAvaiableStock];
    }
}

- (void)updateOrderPower:(Float64)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.opInput.text = currencyString([NSNumber numberWithFloat:value]);
    });
    
}

- (void)updateAvaibleStock:(Float64)value
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.opInput.text = currencyString([NSNumber numberWithFloat:value / [AgentTrade sharedInstance].shares]);
    });
}

@end
