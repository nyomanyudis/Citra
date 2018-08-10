//
//  OrderForm3ViewController.m
//  Ciptadana
//
//  Created by Reyhan on 2/24/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "OrderForm3ViewController.h"
#import "AppDelegate.h"
#import "ImageResources.h"
#import "UIButton+Customized.h"
#import "OrderListViewController.h"
#import "MLTableAlert.h"
#import "AutocompletionTableView.h"
#import "NSString+StringAdditions.h"
#import "ConstractOrder.h"
#import "StockWatchViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


#define MAXQUEUE 100

@interface OrderForm3ViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIDropListDelegate, UITextFieldDelegate>


@property Order3View *lastView;
@property Level2 *level2;
@property NSArray *arrayClientList;
@property NSMutableArray *arrayOrderList;
@property uint currentPage;

@property BOOL orderProses;

@property (assign, nonatomic) KiStockData *lastStockData;
@property (assign, nonatomic) OrderSide orderSide;

@property (weak, nonatomic) NSString *statusString;
@property (weak, nonatomic) id alertPopup;

@property uint32_t lastAmendPrice;
@property Float64 lastAmendLot;

- (void)initView;
- (void)initScrollView;
- (void)inittable;
- (void)initOrderList;

@end


@implementation OrderForm3ViewController

@synthesize orderSide;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil side:(OrderSide)side
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        orderSide = side;
    }
    return self;
}

- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [[AgentTrade sharedInstance] agentTradeCallback:nil];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)homeBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [[AgentTrade sharedInstance] agentTradeCallback:nil];
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    
    if(level2Dictionary == nil) {
        level2Dictionary = [NSMutableDictionary dictionary];
    }
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [_backBarItem setCustomView:backButton];
    [_homeBarItem setCustomView:homeButton];
    
    if(orderSide == SideBuy) {
        _titleBarItem.title = @"Buy";
    }
    else {
        _titleBarItem.title = @"Sell";
    }
    
    _buyView.priceInput.delegate = self;
    _buyView.lotInput.delegate = self;
    
    [_buyButton addTarget:self action:@selector(buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sellButton addTarget:self action:@selector(sellButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //_flagLabel.backgroundColor = [UIColor redColor];
    _flagLabel.backgroundColor = SELL_COLOR;
    
    self.submitOrder = NO;
    
    [self initView];
    [self initClientList:YES];
    [self initScrollView];
    [self inittable];
    [self initOrderList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buyButtonClicked
{
    [_lastView handleSingleTap:nil];
    _currentPage = 0;
    
    _level2 = nil;
    [_level2table reloadData];
    
    _buyView.stockInput.text = @"";
    _buyView.valueInput.text = @"";
    _buyView.lotInput.text = @"";
    _buyView.priceInput.text = @"";
//    _sellView.orderpowerInput.text = @"0";
//    _sellView.stockInput.text = @"";
//    _sellView.valueInput.text = @"";
//    _sellView.lotInput.text = @"";
//    _sellView.priceInput.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    _flagLabel.frame = CGRectMake(_buyButton.frame.origin.x, _flagLabel.frame.origin.y, _flagLabel.frame.size.width, _flagLabel.frame.size.height);
    //_flagLabel.backgroundColor = [UIColor redColor];
    _flagLabel.backgroundColor = SELL_COLOR;
    
    [_orderScroll scrollRectToVisible:_buyView.frame animated:YES];

    _lastView = _buyView;
    [_buyView handleSingleTap:nil];
    
    [UIView commitAnimations];
}

- (void)sellButtonClicked
{
    [_lastView handleSingleTap:nil];
    _currentPage = 1;
    
    _level2 = nil;
    [_level2table reloadData];
    
    _buyView.stockInput.text = @"";
    _buyView.valueInput.text = @"";
    _buyView.lotInput.text = @"";
    _buyView.priceInput.text = @"";
//    _sellView.orderpowerInput.text = @"0";
//    _sellView.stockInput.text = @"";
//    _sellView.valueInput.text = @"";
//    _sellView.lotInput.text = @"";
//    _sellView.priceInput.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    _flagLabel.frame = CGRectMake(_sellButton.frame.origin.x, _flagLabel.frame.origin.y, _flagLabel.frame.size.width, _flagLabel.frame.size.height);
    //_flagLabel.backgroundColor = [UIColor greenColor];
    _flagLabel.backgroundColor = BUY_COLOR;
    
//    [_orderScroll scrollRectToVisible:_sellView.frame animated:YES];
//    
//    _lastView = _sellView;
//    [_sellView handleSingleTap:nil];
    
    [UIView commitAnimations];
}

- (void)alert:(NSString*)message
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
//    [alertView show];
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor whiteColor];
        celltable.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        celltable.textLabel.numberOfLines = 0;
        
        celltable.textLabel.text = message;
        
        return celltable;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        return celltable.frame.size.height + 2;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return 1;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Alert"
                                          cancelButtonTitle:@"OK"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

- (ClientList*)getClient:(TxOrder*)tx
{
    NSArray *array = [AgentTrade sharedInstance].getClients;
    for (ClientList *cl in array) {
        if ([cl.clientcode isEqualToString:tx.clientCode]) {
            return cl;
        }
    }
    
    return nil;
}

#pragma mark
#pragma private method
- (void)initView
{
    _currentPage = 0;
    
    _buyView = [[Order3View alloc] initWithOrderForm:self];
//    _sellView = [[Order3View alloc] initWithOrderForm:self];
    
//    _sellView.opLabel.text = @"Av.";
//    [_sellView.actionButton setTitle:@"Sell" forState:UIControlStateNormal];
    
    _buyView.backgroundColor = BUY_COLOR;
//    _sellView.backgroundColor = BUY_COLOR;
    
    
//    _sellView.orderpowerInput.placeholder = @"Portfolio";
    
    if(orderSide == SideSell) {
        _buyView.opLabel.text = @"Av.";
        _buyView.orderpowerInput.placeholder = @"Portfolio";
        [_buyView.actionButton setTitle:@"Sell" forState:UIControlStateNormal];
        _buyView.backgroundColor = SELL_COLOR;
    }
    
    _lastView = _buyView;
    
    [_buyButton BlackBackgroundCustomized];
    [_sellButton BlackBackgroundCustomized];
    
    _clientDroplist.dropDelegate = self;
    [[AgentTrade sharedInstance] subscribeOrderList];
    
}

- (void)initScrollView
{
//    uint x = _orderScroll.frame.size.width;
    uint y = _orderScroll.frame.origin.y;//190;
    _orderScroll.frame = CGRectMake(0, y, self.view.frame.size.width, _orderScroll.frame.size.height);
    _orderScroll.contentSize = CGSizeMake(1 * _orderScroll.frame.size.width, _orderScroll.frame.size.height);
    _orderScroll.delegate = self;
    
    _buyView.frame      = CGRectMake(0,     0, _buyView.frame.size.width, _buyView.frame.size.height);
//    _sellView.frame     = CGRectMake(x,     0, _sellView.frame.size.width, _sellView.frame.size.height);
    
    [_orderScroll addSubview:_buyView];
//    [_orderScroll addSubview:_sellView];
}

- (void)inittable
{
    _level2table.delegate = self;
    _level2table.dataSource = self;

    _ordertable.delegate = self;
    _ordertable.dataSource = self;
    
    _level2table.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    _ordertable.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    
    _ordertable.frame = CGRectMake(0, 365, _ordertable.frame.size.width, _ordertable.frame.size.height);
}

- (void)initClientList:(bool)requestClientList
{
    AgentTrade *trade = [AgentTrade sharedInstance];
    if (nil != trade && nil != trade.getClients) {
        self.arrayClientList = trade.getClients;
        
        NSMutableArray *array = [NSMutableArray array];
        for (ClientList *client in self.arrayClientList) {
            [array addObject:client.name];
        }
        
        [self.clientDroplist arrayList:array];
        
        ClientList *client = [self.arrayClientList objectAtIndex:self.clientDroplist.selectedIndex];
        [self.clientDroplist setTitle:client.name forState:UIControlStateNormal];
    }
    else if(requestClientList){
        [[AgentTrade sharedInstance] subscribe:RecordTypeClientList requestType:RequestGet];
    }
    else {
        //[self alert:@"You don't have Client List and Order Power"];
    }
    
    if (nil != self.arrayClientList && self.arrayClientList.count > 0) {
        ClientList *client = [self.arrayClientList objectAtIndex:self.clientDroplist.selectedIndex];
//        [self.indicator startAnimating];
        [trade subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:client.clientcode];
        [trade subscribe:RecordTypeGetCustomerPosition requestType:RequestGet clientcode:client.clientcode];
    }
}

- (void)initOrderList
{
    NSMutableDictionary *originOrderDictionary = [AgentTrade sharedInstance].getOrderDictionary;
    
    if(nil == self.arrayOrderList)
        self.arrayOrderList =  [NSMutableArray array];
    
    if(nil != originOrderDictionary) {
        [self.arrayOrderList addObjectsFromArray:originOrderDictionary.allValues];
    }
    
    if(nil != self.arrayOrderList) {
        self.arrayOrderList = [OrderListViewController sortOrderList:self.arrayOrderList];
    }
    
    [self.ordertable reloadData];
}

#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initClientList:NO];
        });
    }
    else if (RecordTypeGetOrderPower == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(orderSide == SideBuy) {
                _buyView.orderpowerInput.text = currencyString([NSNumber numberWithFloat:msg.recOrderPower]);
                NSLog(@"## Order Power: Rp %@", _buyView.orderpowerInput.text);
            }
        });
    }
    else if (RecordTypeGetAvaiableStock == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float share = msg.recAvaiableStock;
            if (share > 0) {
                share /= [AgentTrade sharedInstance].shares;
            }
            
//            if (1 == _currentPage) {
//                _sellView.orderpowerInput.text = [NSString stringWithFormat:@"%.0f", share];
//            }
            if(orderSide == SideSell) {
                _buyView.orderpowerInput.text = [NSString stringWithFormat:@"%.0f", share];
            }
        });
    }
    else if (RecordTypeGetOrders == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
            
            if(msg.recClordid != nil) {
                TxOrder *tx=  [[AgentTrade sharedInstance].getOrderDictionary objectForKey:msg.recClordid];
                if (nil != tx) {
                    [self updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
                    //[self updateSubmitTxOrder:tx received:NO];
                }
                else {
                    if(msg.recOrderlist != nil && msg.recOrderlist.count > 0) {
                        NSArray *txArray = msg.recOrderlist;
                        for (TxOrder *tx in txArray) {
                            [[AgentTrade sharedInstance].getOrderDictionary setObject:tx forKey:tx.orderId];
                            [self updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
                            
                            if([DBLite sharedInstance].popupOrderStatus &&
                               [OrderListViewController isStatusAllowed:tx.orderStatus]) {
                                [self updateSubmitTxOrder:tx received:NO];
                            }
                        }
                    }
                }
            }
        });
    }
    else if(RecordTypeGetCustomerPosition == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(msg.recCustomerPosition != nil) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.positiveFormat = @"###,###.##";
                formatter.roundingMode = NSNumberFormatterNoStyle;
                [formatter setDecimalSeparator:@"."];
                [formatter setGroupingSeparator:@","];
                [formatter setAllowsFloats:YES];
                
                //cashBalanceTxt.text =[ formatter stringFromNumber:[NSNumber numberWithDouble:msg.recCustomerPosition.loanBalance]];
                _buyView.cashInput.text =[ formatter stringFromNumber:[NSNumber numberWithDouble:msg.recCustomerPosition.loanBalance]];
            }
        });
    }
}

- (void)updateOrderList:(NSMutableDictionary*)orderDictionary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.animIndicator stopAnimating];
        self.orderScroll.userInteractionEnabled = YES;
        self.clientDroplist.userInteractionEnabled = YES;
        
        self.arrayOrderList = nil;
        [self.ordertable reloadData];
        [self initOrderList];
        
        
        if  (self.orderProses) {
            self.orderProses = NO;
            if(nil != self.arrayOrderList && self.arrayOrderList.count > 0) {
                TxOrder *tx = [self.arrayOrderList objectAtIndex:0];
                self.statusString = [OrderListViewController statusDescription:tx.orderStatus];
                
                if (nil != self.alertPopup) {
                    [((MLTableAlert*)self.alertPopup).table reloadData];
                }
            }
            if(nil != _arrayClientList && 0 < _arrayClientList.count) {
                ClientList *client = [_arrayClientList objectAtIndex:_clientDroplist.selectedIndex];
                [[AgentTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:client.clientcode];
            }
        }
    });
}

- (void)updateSubmitTxOrder:(TxOrder *)txOrder received:(BOOL)receive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        if(self.submitOrder) {
            if (nil != txOrder) {
                ClientList *client;
                
                self.statusString = [OrderListViewController statusDescription:txOrder.orderStatus];
                
                NSArray *arrayClient = [AgentTrade sharedInstance].getClients;
                for (ClientList *cl in arrayClient) {
                    if ([cl.clientcode isEqualToString:txOrder.clientCode]) {
                        client = cl;
                        break;
                    }
                }
                
                
                if (nil != client) {
                    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                        TxOrderCell *cell = [[TxOrderCell alloc] init];
                        
                        cell.rightLabel.textColor = [UIColor blackColor];
                        UIColor *color = [UIColor clearColor];//1 == txOrder.side ? [UIColor redColor] : [UIColor greenColor];
                        cell.leftLabel.backgroundColor = color;
                        cell.sepLabel.backgroundColor = color;
                        cell.rightLabel.backgroundColor = color;
                        
                        cell.backgroundColor = 1 == txOrder.side ? red : GREEN;
                        
                        if (0 == indexPath.row) {
                            cell.leftLabel.text = @"Client Name";
                            cell.rightLabel.text  = client.name;
                        }
                        else if (1 == indexPath.row) {
                            cell.leftLabel.text = @"Stock";
                            cell.rightLabel.text  = txOrder.securityCode;
                        }
                        else if (2 == indexPath.row) {
                            cell.leftLabel.text = @"Price";
                            cell.rightLabel.text  = currencyString([NSNumber numberWithInt:txOrder.price]);
                        }
                        else if (3 == indexPath.row) {
                            cell.leftLabel.text = @"Lot";
                            cell.rightLabel.text  = currencyString([NSNumber numberWithFloat:txOrder.orderQty]);
                        }
                        else if (4 == indexPath.row) {
                            cell.leftLabel.text = @"Value";
                            double val = (double)txOrder.price * (double)txOrder.orderQty * [AgentTrade sharedInstance].shares;
                            cell.rightLabel.text  = currencyString([NSNumber numberWithDouble:val]);
                        }
                        else if (5 == indexPath.row) {
                            cell.leftLabel.text = @"Status";
                            cell.rightLabel.text  = [OrderListViewController statusDescription:txOrder.orderStatus];
                        }
                        
                        
                        //cell.backgroundColor = 1 == txOrder.side ? [UIColor redColor] : [UIColor greenColor];
                        cell.backgroundColor = white;
                        
                        return  cell;
                    };
                    
                    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                        return 25;
                    };
                    
                    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
                        return 6;
                    };
                    
                    NSString *alertTitle = receive ? @"Order Receive" : @"Order Result";
                    
                    // create the alert
                    MLTableAlert *alertOrderResult = [MLTableAlert tableAlertWithTitle:alertTitle
                                                                     cancelButtonTitle:@"OK"
                                                                          numberOfRows:row
                                                                              andCells:cell
                                                                        andCellsHeight:cellHeight];
                    [alertOrderResult setHeight:240];
                    self.alertPopup = alertOrderResult;
                    self.orderProses = YES;
                    
                    [alertOrderResult showWithColor:white];
//                    // show the alert
//                    if(1 == txOrder.side)
//                        [alertOrderResult showWithColor:[UIColor redColor]];
//                    else
//                        [alertOrderResult showWithColor:[UIColor greenColor]];
                }
//            }
//            
//            self.submitOrder = NO;
        }
        
    });
}

- (void)updateLevel2:(NSArray *)level2
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(level2.count > 0) {
            
            
            Level2 *lvl2 = [level2 objectAtIndex:0];
            if (nil != _lastStockData && _lastStockData.id == lvl2.codeId) {
                
                [level2Dictionary setObject:level2 forKey:_lastStockData.code];
                
                _level2 = [level2 objectAtIndex:0];
                [level2Dictionary setObject:lvl2 forKey:_lastStockData.code];
                
                [_level2table reloadData];
                
                if(_level2.offer != nil && _level2.offer.count > 0 && orderSide == SideSell) {
                    BuySell *offer = [_level2.offer objectAtIndex:0];
                    if([_buyView.priceInput.text isEqualToString:@""]) {
                        _buyView.priceInput.text = [NSString stringWithFormat:@"%d", offer.price];
                        //[_buyView.lotInput becomeFirstResponder];
                    }
                }
                else if(_level2.bid != nil && _level2.bid.count > 0 && orderSide == SideBuy) {
                    BuySell *bid = [_level2.bid objectAtIndex:0];
                    if([_buyView.priceInput.text isEqualToString:@""]) {
                        _buyView.priceInput.text = [NSString stringWithFormat:@"%d", bid.price];
                        //[_buyView.lotInput becomeFirstResponder];
                    }
                }
            }
        }
    });
}

- (void)readLevel2:(NSString *)stockCode
{
    dispatch_async(dispatch_get_main_queue(), ^{
        Level2 *lvl2 = [level2Dictionary objectForKey:stockCode];
        if (lvl2 != nil && _lastStockData != nil) {
            //        int32_t lvl2Id = lvl2.codeId;
            //        if(lastId == lvl2Id) {
            _level2 = lvl2;
            
            [_level2table reloadData];
            
            if(_level2.offer != nil && _level2.offer.count > 0 && orderSide == SideSell) {
                BuySell *offer = [_level2.offer objectAtIndex:0];
                if([_buyView.priceInput.text isEqualToString:@""]) {
                    _buyView.priceInput.text = [NSString stringWithFormat:@"%d", offer.price];
                    //[_buyView.lotInput becomeFirstResponder];
                }
            }
            else if(_level2.bid != nil && _level2.bid.count > 0 && orderSide == SideBuy) {
                BuySell *bid = [_level2.bid objectAtIndex:0];
                if([_buyView.priceInput.text isEqualToString:@""]) {
                    _buyView.priceInput.text = [NSString stringWithFormat:@"%d", bid.price];
                    //[_buyView.lotInput becomeFirstResponder];
                }
            }
            //        }
        }
    });
    
}

#pragma mark
#pragma AgentFeedCallback
- (void)AgentFeedCallback:(KiRecord *)rec
{
    if (RecordTypeLevel2 == rec.recordType) {
        [self updateLevel2:rec.level2];
    }
}


#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    _buyView.orderpowerInput.text = @"0";
    _buyView.stockInput.text = @"";
    _buyView.valueInput.text = @"";
    _buyView.lotInput.text = @"";
    _buyView.priceInput.text = @"";
//    _sellView.orderpowerInput.text = @"0";
//    _sellView.stockInput.text = @"";
//    _sellView.valueInput.text = @"";
//    _sellView.lotInput.text = @"";
//    _sellView.priceInput.text = @"";
    
    _level2 = nil;
    [_level2table reloadData];
    
    if(nil != _arrayClientList && index < _arrayClientList.count) {
        ClientList *client = [_arrayClientList objectAtIndex:index];
        [[AgentTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:client.clientcode];
        [_lastView handleSingleTap:nil];
    }
}

#pragma mark
#pragma UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _level2table && nil != _level2) {
        //NSInteger max = MAX(_level2.offer.count, _level2.bid.count);
        NSInteger max = _level2.offer.count > _level2.bid.count ? _level2.offer.count : _level2.bid.count;
        return max > MAXQUEUE ? MAXQUEUE :max;
    }
    else if(tableView == _ordertable && nil != _arrayOrderList) {
        return _arrayOrderList.count;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL OK = NO;
    TxOrder *order = [_arrayOrderList objectAtIndex:indexPath.row];
    _selectedTxOrder = order;
    
    if([@"32" isEqualToString:order.orderType]) {
        uint32_t buffer_type = order.orderBufferType;
        if(buffer_type == 6 && ([@"KC" isEqualToString:order.orderStatus] || [@"kc" isEqualToString:order.orderStatus])) {
            // pooling gtd
        }
        else if(buffer_type == 6 && [@"KC" isEqualToString:order.orderStatus]) {
            // gtd
        }
        else if(buffer_type == 7) {
            // gtd
        }
        else {
            // day
            OK = YES;
        }
    }
    else if([@"42" isEqualToString:order.orderType]) {
        // session
    }
    
    BOOL isNotOpen = YES;
    
    if(OK) {
        if( 2 == _currentPage ) {
            if([@"0" isEqualToString:order.orderStatus] || [@"1" isEqualToString:order.orderStatus] ||
               [@"KA" isEqualToString:order.orderStatus] || [@"KC" isEqualToString:order.orderStatus]) {
                
                isNotOpen = NO;
                
                _lastAmendPrice = order.price;
                _lastAmendLot = order.orderQty;
                
                ClientList *cl = [self getClient:order];
                
                if(nil != cl) {
                    if(1 == order.side) {
                        [[AgentTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:cl.clientcode];
                        _flagLabel.backgroundColor = SELL_COLOR;
                    }
                    else {
                        [[AgentTrade sharedInstance] subscribeAvaiable:order.securityCode clientcode:cl.clientcode];
                        _flagLabel.backgroundColor = BUY_COLOR;
                    }
                }
            }
        }
        else if( 3 == _currentPage &&
                ([@"0" isEqualToString:order.orderStatus] || [@"1" isEqualToString:order.orderStatus] ||
                 [@"KA" isEqualToString:order.orderStatus] || [@"KC" isEqualToString:order.orderStatus])) {
                    
                    isNotOpen = NO;
                    
                    ClientList *cl = [self getClient:order];
                    if(nil != cl) {
                        if(1 == order.side) {
                            [[AgentTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:cl.clientcode];
                            _flagLabel.backgroundColor = SELL_COLOR;
                        }
                        else {
                            [[AgentTrade sharedInstance] subscribeAvaiable:order.securityCode clientcode:cl.clientcode];
                            _flagLabel.backgroundColor = BUY_COLOR;
                        }
                    }
                }
    }
    
    
    if(isNotOpen) {
        [OrderListViewController TxOrderPopup:order tradeDone:NO];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _level2table) {
        Order3Level2Cell *cell;
        
        if(nil == cell) {
            
            cell = [[Order3Level2Cell alloc] init];
            cell.bidlotLabel.text = @"";
            cell.bidpriceLabel.text = @"";
            cell.offerlotLabel.text = @"";
            cell.offerpriceLabel.text = @"";
            
            if (_level2.bid.count > indexPath.row) {
                BuySell *bid = [_level2.bid objectAtIndex:indexPath.row];
                
                cell.bidpriceLabel.text = currencyStringFromInt(bid.price);
                cell.bidlotLabel.text = currencyStringFromInt(bid.volume);
                
                if(bid.price > _level2Price) {
                    cell.bidpriceLabel.textColor = GREEN;
                    cell.bidlotLabel.textColor = GREEN;
                }
                else if(bid.price < _level2Price) {
                    cell.bidpriceLabel.textColor = red;
                    cell.bidlotLabel.textColor = red;
                }
                else {
                    cell.bidpriceLabel.textColor = yellow;
                    cell.bidlotLabel.textColor = yellow;
                }
            }
            
            if (_level2.offer.count > indexPath.row) {
                BuySell *offer = [_level2.offer objectAtIndex:indexPath.row];
                
                cell.offerpriceLabel.text = currencyStringFromInt(offer.price);
                cell.offerlotLabel.text = currencyStringFromInt(offer.volume);
                
                if(offer.price > _level2Price) {
                    cell.offerpriceLabel.textColor = GREEN;
                    cell.offerlotLabel.textColor = GREEN;
                }
                else if(offer.price < _level2Price) {
                    cell.offerpriceLabel.textColor = red;
                    cell.offerlotLabel.textColor = red;
                }
                else {
                    cell.offerpriceLabel.textColor = yellow;
                    cell.offerlotLabel.textColor = yellow;
                }
            }
        }
        
        return cell;
    }
    else if(tableView == _ordertable) {
        OrderListCell *cell;
        
        if(nil == cell) {
            cell = [[OrderListCell alloc] init];
            TxOrder *order = [_arrayOrderList objectAtIndex:indexPath.row];
            
            NSString *status = [OrderListViewController statusDescription:order.orderStatus];
            
            cell.timeLabel.text = order.createdTime;
            cell.aLabel.text = order.side == 1 ? @"B" : @"S";
            cell.stockLabel.text = order.securityCode;
            cell.priceLabel.text = currencyString([NSNumber numberWithInt:order.price]);
            cell.lotLabel.text = currencyString([NSNumber numberWithInt:order.orderQty]);
            cell.sLabel.text = status;
            
            if (1 == order.side) {
                cell.aLabel.textColor = red;
                cell.stockLabel.textColor = red;
                cell.priceLabel.textColor = red;
                cell.lotLabel.textColor = red;
                cell.sLabel.textColor = red;
            }
            else {
                cell.aLabel.textColor = GREEN;
                cell.stockLabel.textColor = GREEN;
                cell.priceLabel.textColor = GREEN;
                cell.lotLabel.textColor = GREEN;
                cell.sLabel.textColor = GREEN;
            }
            
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:167.0/255.0 green:152.0/255.0 blue:101.0/255.0 alpha:1.0];
        }
        
        return cell;
    }
    
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == _level2table) {
        return [[Order3Level2Cell alloc] init];
    }
    else if(tableView == _ordertable) {
        return [[OrderListCell alloc] init];
    }
    
    return nil;
}


#pragma mark
#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if(scrollView == self.orderScroll) {
//        CGFloat pageWidth = self.orderScroll.frame.size.width;
//        _currentPage = floor((self.orderScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//        
//        if(0 == _currentPage)
//            [self buyButtonClicked];
//        else if(1 == _currentPage)
//            [self sellButtonClicked];
//    }
}

@end




//=== Class Order3View

@interface Order3View () <AutocompletionTableViewDelegate>

//@property OrderConfirmationView *view;

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end

@implementation Order3View

- (id)initWithOrderForm:(OrderForm3ViewController*)vc
{
    if(self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Order3View" owner:self options:nil] objectAtIndex:0];
        
        _vc = vc;
        
        [_actionButton BlackBackgroundCustomized];
        [_clearButton BlackBackgroundCustomized];
        
        [_actionButton addTarget:self action:@selector(actionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_clearButton addTarget:self action:@selector(clearButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _stockInput.delegate = self;
        _priceInput.delegate = self;
        _lotInput.delegate = self;
        
        [self.valueInput setValue:black forKeyPath:@"_placeholderLabel.textColor"];
        [self.orderpowerInput setValue:black forKeyPath:@"_placeholderLabel.textColor"];
        
        [_priceInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_lotInput addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.stockInput addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
    }
    
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    @try {
        double price = 0;
        double lot = 0;
        if(![_priceInput.text isEqualToString:@""] && ![_lotInput.text isEqualToString:@""]) {
            price = [_priceInput.text doubleValue];
            lot = [_lotInput.text doubleValue];
        }
        double val = price * lot * [AgentTrade sharedInstance].shares;
        _valueInput.text = currencyString([NSNumber numberWithDouble:val]);
    }
    @catch (NSException *exception) {
        //[self alert:[NSString stringWithFormat:@"%@", exception]];
    }
}

- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:NO] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        CGFloat ypos = self.frame.origin.y + _stockInput.frame.origin.y + 115;
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.stockInput yPos:ypos inViewController:self.vc withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
    }
    
    return _autoCompleter;
}

- (void)handleSingleTap:(id)recognizer
{
    [_stockInput resignFirstResponder];
    [_priceInput resignFirstResponder];
    [_lotInput resignFirstResponder];
    [_autoCompleter hideOptionsView];
}

- (void)orderBuySellConfirmation:(ClientList*)client withStock:(NSString*)stock andSide:(NSString*)side andPrice:(double)price andQuantity:(double)quantity
{
    if(client != nil && client.sid != nil && client.sid.length >= 6) {
        UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            TxOrderCell *cell = [[TxOrderCell alloc] init];
            
            cell.rightLabel.textColor = [UIColor blackColor];
            cell.leftLabel.backgroundColor = [UIColor clearColor];
            cell.sepLabel.backgroundColor = [UIColor clearColor];
            cell.rightLabel.backgroundColor = [UIColor clearColor];
            
            if (0 == indexPath.row) {
                cell.leftLabel.text = @"Client Name";
                cell.rightLabel.text  = client.name;
            }
            else if (1 == indexPath.row) {
                cell.leftLabel.text = @"Stock";
                cell.rightLabel.text  = stock;
            }
            else if (2 == indexPath.row) {
                cell.leftLabel.text = @"Price";
                cell.rightLabel.text  = currencyString([NSNumber numberWithInt:price]);
            }
            else if (3 == indexPath.row) {
                cell.leftLabel.text = @"Lot";
                cell.rightLabel.text  = currencyString([NSNumber numberWithInt:quantity]);
            }
            else if (4 == indexPath.row) {
                double val = price * quantity * [AgentTrade sharedInstance].shares;
                
                cell.leftLabel.text = @"Value";
                cell.rightLabel.text  = currencyString([NSNumber numberWithDouble:val]);
            }
            
            //cell.backgroundColor = [@"1" isEqualToString:side] ? red : GREEN;
            cell.backgroundColor = white;
            
            return  cell;
        };
        
        CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
            return 25;
        };
        
        NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
            return 5;
        };
        
        NSString *sideLabel = [@"1" isEqualToString:side] ? @"Buy" : @"Sell";
        
        // create the alert
        MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:CONCAT(sideLabel, @" Order")
                                              cancelButtonTitle:@"Confirm"
                                                  okButtonTitle:@"Cancel"
                                               otherButtonTitle:nil
                                                   numberOfRows:row
                                                       andCells:cell
                                                 andCellsHeight:cellHeight];
        [alert setHeight:240];
        
        
        void (^cancelButtonOnClick)(void) = ^ {
            _vc.submitOrder = YES;
            [_vc.animIndicator startAnimating];
            _vc.orderScroll.userInteractionEnabled = NO;
            _vc.clientDroplist.userInteractionEnabled = NO;
            
            [self composeMsgNew:client side:side stock:stock price:price qty:quantity];
            [self clearButtonClicked];
        };
        alert.cancelButtonOnClick = cancelButtonOnClick;
        
        [alert showWithColor:white];
        //	// show the alert
        //    if([@"1" isEqualToString:side])
        //        [alert showWithColor:[UIColor redColor]];
        //    else
        //        [alert showWithColor:[UIColor greenColor]];
    }
    else {
        [self alert:@"Invalid Client Or SID, quit App and restart to fix issue"];
    }
    

}

- (void)actionButtonClicked
{
    [self handleSingleTap:nil];

    if([@"" isEqualToString:_stockInput.text]) {
        [self alert:@"Stock is empty"];
    }
    else if([@"" isEqualToString:_lotInput.text]) {
        [self alert:@"Lot is empty"];
    }
    else if([@"" isEqualToString:_priceInput.text]) {
        [self alert:@"Price is empty"];
    }
    else {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        [nf setNumberStyle:NSNumberFormatterDecimalStyle];
        [nf setMaximumFractionDigits:2];
        [nf setMinimumFractionDigits:2];
        [nf setRoundingMode:NSNumberFormatterRoundDown];
        [nf setDecimalSeparator:@"."];
        [nf setGroupingSeparator:@","];
        [nf setAllowsFloats:YES];
        
        ClientList *client = [_vc.arrayClientList objectAtIndex:_vc.clientDroplist.selectedIndex];
        
        int share = [AgentTrade sharedInstance].shares;
        double price = [[nf numberFromString:_priceInput.text] doubleValue];
        double lot = [[nf numberFromString:_lotInput.text] doubleValue];
        double value = price * lot * share;
        float orderPower = [[nf numberFromString:_orderpowerInput.text] floatValue];
        
        
        if(price <= 0) {
            [self alert:@"Price must be greater than zero"];
        }
        else if(lot <= 0) {
            [self alert:@"Lot must be greater than zero"];
        }
        else if([@"Buy" isEqualToString:_actionButton.titleLabel.text]) {
            KiStockData *marginStock = [[DBLite sharedInstance] getStockDataByStock:_stockInput.text.uppercaseString];
            if (value > orderPower) {
                [self alert:CONCAT(@"You have not enough The Orderpower to buy ", _stockInput.text.uppercaseString)];
            }
            else if(client.isMargin && marginStock.clientType != 33) {
                [self alert:CONCAT(_stockInput.text.uppercaseString, @" is restricted for margin client")];
                [self clearButtonClicked];
            }
            else {
                [self orderBuySellConfirmation:client withStock:_stockInput.text.uppercaseString andSide:@"1" andPrice:price andQuantity:lot];
            }
        }
        else if([@"Sell" isEqualToString:_actionButton.titleLabel.text]) {
            if (lot > orderPower) {
                [self alert:CONCAT(@"You have not enough portfolio to sell ", _stockInput.text.uppercaseString)];
            }
            else {
                [self orderBuySellConfirmation:client withStock:_stockInput.text.uppercaseString andSide:@"2" andPrice:price andQuantity:lot];
                //[self clearButtonClicked];
            }
        }
    }
}

- (void)clearButtonClicked
{
    _stockInput.text = @"";
    _priceInput.text = @"";
    _lotInput.text = @"";
    _valueInput.text = @"";
    _vc.flagLabel.backgroundColor = [UIColor darkGrayColor];
    
    
    if(![@"Buy" isEqualToString:_actionButton.titleLabel.text]) {
        _orderpowerInput.text = @"";
    }
    
    if([@"Amend" isEqualToString:_actionButton.titleLabel.text] || [@"Withdraw" isEqualToString:_actionButton.titleLabel.text]) {
        self.backgroundColor = [UIColor darkGrayColor];
    }
    
    _vc.level2 = nil;
    [_vc.level2table reloadData];
    
    [self handleSingleTap:nil];
}

- (void)lookForStock:(NSString*)stock
{
    self.vc.lastStockData = nil;
    _vc.level2 = nil;
    [_vc.level2table reloadData];
    
    if(![@"" isEqualToString:stock]) {
        KiStockData *d = [[DBLite sharedInstance] getStockDataByStock:stock];
        if (nil != d && [d.code isEqualToString:stock]) {
            _stockInput.text = stock;
            _vc.stockLabel.text = d.name;
            _vc.stockLabel.textColor = [UIColor colorWithHexString:d.color];
            
            KiStockSummary *summary = [[DBLite sharedInstance] getStockSummaryById:d.id];
            self.vc.lastStockData = [[DBLite sharedInstance] getStockDataById:summary.codeId];
            
            _vc.level2Price = summary.stockSummary.previousPrice;
            
            [_vc readLevel2:d.code];
        }
    }
    
    if (nil != self.vc.lastStockData) {
        _priceInput.text = @"";
        [[AgentFeed sharedInstance] subscribe:RecordTypeLevel2 status:RequestSubscribe code:stock];
        
        if([@"Sell" isEqualToString:_actionButton.titleLabel.text]) {
            _orderpowerInput.text = @"";
            ClientList *client = [_vc.arrayClientList objectAtIndex:_vc.clientDroplist.selectedIndex];
            [[AgentTrade sharedInstance] subscribeAvaiable:stock clientcode:client.clientcode];
        }
    }
    else {
        if (![@"" isEqualToString:_stockInput.text]) {
            _stockInput.text = @"";
            [self alert:CONCAT(stock, @" is not valid or not available")];
        }
    }
}

- (void)alert:(NSString*)message
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
//    [alertView show];
    
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor whiteColor];
        celltable.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        celltable.textLabel.numberOfLines = 0;
        
        celltable.textLabel.text = message;
        
        return celltable;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        return celltable.frame.size.height + 2;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return 1;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Alert"
                                          cancelButtonTitle:@"OK"
                                              okButtonTitle:nil
                                           otherButtonTitle:nil
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:celltable.frame.size.height + 2];
    
    void (^cancelButtonOnClick)(void) = ^ {
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    [alert showWithColor:[UIColor blackColor]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleSingleTap:nil];
}

#pragma mark
#pragma AutoCompleteTableViewDelegate

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string
{
//    NSMutableArray *mutableArray = [NSMutableArray array];
//    for (NSString *stock in arrayStock()) {
//        if(![stock containsString:@"-R"]) {
//            [mutableArray addObject:stock];
//        }
//    }
//
//    NSArray *sortedArrayOfString = [mutableArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
//        }];
//    
//    return sortedArrayOfString;
    
    return [DBLite sharedInstance].getStringStockData;
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index
{
    
}



#pragma mark
#pragma UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_stockInput == textField) {
        [self lookForStock:_stockInput.text.uppercaseString];
    }
    else if((_priceInput == textField || _lotInput == textField) && (![@"" isEqualToString:_priceInput.text] && ![@"" isEqualToString:_lotInput.text])) {
        @try {
            double val = [_priceInput.text doubleValue] * [_lotInput.text doubleValue] * [AgentTrade sharedInstance].shares;
            _valueInput.text = currencyString([NSNumber numberWithDouble:val]);
        }
        @catch (NSException *exception) {
            [self alert:[NSString stringWithFormat:@"%@", exception]];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:nil];
}


#pragma mark
#pragma Submit Order

-(void)SubmitOrderCallback:(NSMutableDictionary *)op
{
    [[AgentTrade sharedInstance] agentTradeCallback:^(TradingMessage *msg) {
        
        if (StatusReturnResult == msg.recStatusReturn) {
            if (RecordTypeSendSubmitOrder == msg.recType) {
                NSString *createdTime = [msg.recTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].uppercaseString;

//                TxOrder *tx = [[AgentTrade sharedInstance].getOrderDictionary objectForKey:msg.recClordid];
//                
//                if (nil != tx) {
//                    [self.vc updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
//                    [self.vc updateSubmitTxOrder:tx];
//                }
//                else {
//                    TxOrder_Builder *builder = [TxOrder builder];
//                    builder.price = [[op objectForKey:O_PRICE] intValue];
//                    builder.orderQty = [[op objectForKey:O_ORDERQTY] floatValue];
//                    builder.side = [[op objectForKey:O_SIDE] intValue];
//                    builder.securityCode = [op objectForKey:O_SYMBOL];
//                    builder.orderStatus = @"9";
//                    builder.clientCode = [op objectForKey:O_CLIENTCODE];
//                    builder.orderId = msg.recClordid;
//                    builder.createdTime = [createdTime substringWithRange:NSMakeRange(9, 8)];
//                    
//                    TxOrder *txorder = [builder build];
//
//                    [[AgentTrade sharedInstance].getOrderDictionary setObject:txorder forKey:txorder.orderId];
//                    [self.vc updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
//                    [self.vc updateSubmitTxOrder:txorder];
//                }
                
                NSString *recMessage = msg.recStatusMessage;
                //terima receive?
                if(recMessage != nil &&
                   [recMessage containsString:@"Accepted"] &&
                   [DBLite sharedInstance].popupReceiveStatus) {
                    
                    TxOrder_Builder *builder = [TxOrder builder];
                    builder.price = [[op objectForKey:O_PRICE] intValue];
                    builder.orderQty = [[op objectForKey:O_ORDERQTY] floatValue];
                    builder.side = [[op objectForKey:O_SIDE] intValue];
                    builder.securityCode = [op objectForKey:O_SYMBOL];
                    builder.orderStatus = @"1x0001";
                    builder.clientCode = [op objectForKey:O_CLIENTCODE];
                    builder.orderId = msg.recClordid;
                    builder.createdTime = [createdTime substringWithRange:NSMakeRange(9, 8)];
                    
                    [self.vc updateSubmitTxOrder:[builder build] received:YES];
                }
                //terima order
//                else if (OrderListViewController isStatusAllowed:msg.){
//                    TxOrder *tx = [[AgentTrade sharedInstance].getOrderDictionary objectForKey:msg.recClordid];
//                    if (nil != tx) {
//                        [self.vc updateOrderList:[AgentTrade sharedInstance].getOrderDictionary];
//                        [self.vc updateSubmitTxOrder:tx received:NO];
//                    }
//                    else
//                }
            }
        }
        
    }];
}

//1=buy 2=sell 5=sell short M=margin
- (void)composeMsgNew:(ClientList*)client side:(NSString*)side stock:(NSString*)code price:(int)price qty:(int)lot
{
    NSLog(@"Compose New Msg ==> Client = %@, Stock = %@, Price = %i, Lot = %i", client.name, code, price, lot);
    
    LoginData *account = [AgentTrade sharedInstance].loginDataFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"D" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    // Body
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:code forKey:O_SYMBOL];
    [op setObject:@"0RG" forKey:O_SYMBOLSFX];
    [op setObject:side forKey:O_SIDE];
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    
    NSDate *addAHour = [date dateByAddingTimeInterval:60*60];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    [op setObject:[NSString stringWithFormat:@"%i", price] forKey:O_PRICE];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:[dateFormat stringFromDate:addAHour] forKey:O_EXPIREDATE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    [self SubmitOrderCallback:op];
    
    [[AgentTrade sharedInstance] composeMsg:op composeMsg:YES];
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
    [op setObject:[NSString stringWithFormat:@"%.0f", order.orderQty] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%i", order.price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    [self SubmitOrderCallback:op];
    
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
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    [op setObject:[NSString stringWithFormat:@"%.0f", price] forKey:O_PRICE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    [self SubmitOrderCallback:op];
    
    [[AgentTrade sharedInstance] composeMsg:op composeMsg:YES];
}

@end




@implementation Order3Level2Cell

- (id)init
{
    if(self = [super init]) {

        _bidlotLabel = [self createLabel:@"Bid Lot" rect:CGRectMake(3, 0, 74, 20)];
        _bidpriceLabel = [self createLabel:@"Bid Price" rect:CGRectMake(80, 0, 74, 20)];
        _offerpriceLabel = [self createLabel:@"Offer Price" rect:CGRectMake(160, 0, 74, 20)];
        _offerlotLabel = [self createLabel:@"Offer Lot" rect:CGRectMake(238, 0, 74, 20)];

        
        self.backgroundColor = black;
        
        [self addSubview:_bidpriceLabel];
        [self addSubview:_bidlotLabel];
        [self addSubview:_offerpriceLabel];
        [self addSubview:_offerlotLabel];
    }
    
    return self;
}

-(UILabel*)createLabel:(NSString*)text rect:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentRight;
    
    label.text = text;
    label.textColor = white;
    label.backgroundColor = black;
    label.font = [UIFont systemFontOfSize:14];
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

@end
