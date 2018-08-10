//
//  OrderListViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/28/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "OrderListViewController.h"
#import "UIButton+Customized.h"
#import "ImageResources.h"
#import "MLTableAlert.h"
#import "AppDelegate.h"
#import "AmendWithdrawController.h"
#import "ConstractOrder.h"

@interface OrderListViewController () <UIDropListDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray *arrayClientList;
@property (retain, nonatomic) NSMutableDictionary *originOrderDictionary;
@property (retain, nonatomic) NSMutableArray *orderArray;
@property (retain, nonatomic) NSArray *allKeys;

//@property (weak, nonatomic) MLTableAlert *alertOrderResult;
@property (weak, nonatomic) NSString *statusString;
@property (weak, nonatomic) id alertPopup;

@property BOOL orderProses;

@end

@implementation OrderListViewController

@synthesize homeBarItem, backBarItem;
@synthesize originOrderDictionary, allKeys, orderArray;
@synthesize clientDropList, bsDropList, statusDropList, orderButton, tableview, scrollview;
@synthesize arrayClientList;


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


- (void)viewDidAppear:(BOOL)animated
{
    [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    [orderButton BlackBackgroundCustomized];
    
    [bsDropList arrayList:ACTION];
    [statusDropList arrayList:STATUS];
    
    [clientDropList setDropDelegate:self];
    [bsDropList setDropDelegate:self];
    [statusDropList setDropDelegate:self];
    //[statusDropList showRightIcon:NO];
    [clientDropList showRightIcon:NO];
    
    [[AgentTrade sharedInstance] subscribeOrderList];
    
    tableview.autoresizesSubviews=NO;
    tableview.frame = CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y , tableview.frame.size.width+82, tableview.frame.size.height+5);
    scrollview.contentSize = CGSizeMake(tableview.frame.size.width, scrollview.frame.size.height + 100);
    
    orderArray =  [NSMutableArray array];
    
    originOrderDictionary = [AgentTrade sharedInstance].getOrderDictionary;
    if(nil != originOrderDictionary) {
        allKeys = originOrderDictionary.allKeys;
        [orderArray addObjectsFromArray:originOrderDictionary.allValues];
    }
    
    
    if(nil != orderArray) {
        orderArray = [OrderListViewController sortOrderList2:orderArray];
    }
    
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self setupClient:YES];
}

- (void)alert:(NSString*)message
{
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    //    [alertView show];
    UITableViewCell *celltable = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        
        celltable.backgroundColor = [UIColor blackColor];
        celltable.textLabel.backgroundColor = [UIColor blackColor];
        celltable.textLabel.textColor = [UIColor blackColor];
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

- (void)setupClient:(bool)requestClientList
{
    AgentTrade *trade = [AgentTrade sharedInstance];
    if (nil != trade && nil != trade.getClients) {
        arrayClientList = trade.getClients;
        
        NSMutableArray *array = [NSMutableArray array];
        for (ClientList *client in arrayClientList) {
            [array addObject:client.name];
        }
        
        [clientDropList arrayList:array];
        
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.selectedIndex];
        [clientDropList setTitle:client.name forState:UIControlStateNormal];
    }
    else if(requestClientList){
        [[AgentTrade sharedInstance] subscribe:RecordTypeClientList requestType:RequestGet];
    }
    else {
        //[self alert:@"You don't have Client List and Order Power"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setClientDropList:nil];
    [self setBsDropList:nil];
    [self setStatusDropList:nil];
    [self setOrderButton:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}

+ (NSMutableArray *)sortOrderList2:(NSArray *)source
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    return mutTmp;
}

+ (NSMutableArray *)sortOrderList:(NSArray *)source
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:NO];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"updatedTime" ascending:NO];
    NSArray *tmp2 = [mutTmp sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort2]];
    NSMutableArray *mutTmp2 = [NSMutableArray arrayWithArray:tmp2];
    tmp2 = nil;
    
    return mutTmp2;
}


#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupClient:NO];
        });
    }
    else if(RecordTypeGetOrders == msg.recType) {
        [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
    }
    else if(RecordTypeSendSubmitOrder == msg.recType) {
        
        NSLog(@"%s\n%@", __PRETTY_FUNCTION__, msg);
        
        TxOrder *tx = [[AgentTrade sharedInstance].getOrderDictionary objectForKey:msg.recClordid];
        
        if (nil != tx) {
            [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
            if([DBLite sharedInstance].popupOrderStatus) {
                [self updateSubmitTxOrder:tx];
            }
        }
        else if (nil != [AmendWithdrawController getSubmitParam]){
            
            NSString *createdTime = [msg.recTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].uppercaseString;
            
            NSMutableDictionary *op = [AmendWithdrawController getSubmitParam];
            
            TxOrder_Builder *builder = [TxOrder builder];
            builder.price = [[op objectForKey:O_PRICE] intValue];
            builder.orderQty = [[op objectForKey:O_ORDERQTY] floatValue];
            builder.side = [[op objectForKey:O_SIDE] intValue];
            builder.securityCode = [op objectForKey:O_SYMBOL];
            builder.orderStatus = @"9";
            builder.clientCode = [op objectForKey:O_CLIENTCODE];
            builder.orderId = msg.recClordid;
            builder.createdTime = [createdTime substringWithRange:NSMakeRange(9, 8)];
            
            TxOrder *txorder = [builder build];
            
//            [[AgentTrade sharedInstance].getOrderDictionary setObject:txorder forKey:txorder.orderId];
//            [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
            if([DBLite sharedInstance].popupReceiveStatus) {
                [self updateSubmitTxOrder:txorder];
            }
        }
        
//        if(msg.recClordid != nil) {
//            TxOrder *tx=  [[AgentTrade sharedInstance].getOrderDictionary objectForKey:msg.recClordid];
//            if (nil != tx) {
//                [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
//                //[self updateSubmitTxOrder:tx received:NO];
//            }
//            else {
//                if(msg.recOrderlist != nil && msg.recOrderlist.count > 0) {
//                    NSArray *txArray = msg.recOrderlist;
//                    for (TxOrder *tx in txArray) {
//                        [[AgentTrade sharedInstance].getOrderDictionary setObject:tx forKey:tx.orderId];
//                        [self upateOrder:[AgentTrade sharedInstance].getOrderDictionary];
//                        
//                        if([DBLite sharedInstance].popupOrderStatus &&
//                           [OrderListViewController isStatusAllowed:tx.orderStatus]) {
//                            [self updateSubmitTxOrder:tx];
//                        }
//                    }
//                }
//            }
//        }

    }
}

- (void)upateOrder:(NSMutableDictionary*)orderDictionary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != orderDictionary && orderDictionary.count > 0) {
            originOrderDictionary = [AgentTrade sharedInstance].getOrderDictionary;
            if(nil != originOrderDictionary) {
                allKeys = originOrderDictionary.allKeys;
                
                [orderArray removeAllObjects];
                [orderArray addObjectsFromArray:originOrderDictionary.allValues];
                
                if(nil != orderArray) {
                    orderArray = [OrderListViewController sortOrderList2:orderArray];
                }
                
                if  (self.orderProses) {
                    self.orderProses = NO;
                     if(nil !=self.orderArray) {
                         if (self.orderArray.count > 0) {
                             TxOrder *tx = [self.orderArray objectAtIndex:0];
                             self.statusString = [OrderListViewController statusDescription:tx.orderStatus];
                             
                             [((MLTableAlert*)self.alertPopup).table reloadData];
                         }
                         
                     }
                }
                
                [tableview reloadData];
            }
        }
    });
}

- (void)updateSubmitTxOrder:(TxOrder *)txOrder
{
    dispatch_async(dispatch_get_main_queue(), ^{
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
                        int share = [AgentTrade sharedInstance].shares;
                        cell.leftLabel.text = @"Value";
                        cell.rightLabel.text  = currencyString([NSNumber numberWithDouble:(txOrder.price * txOrder.orderQty * share)]);
                    }
                    else if (5 == indexPath.row) {
                        cell.leftLabel.text = @"Status";
                        cell.rightLabel.text  = self.statusString;//[OrderListViewController statusDescription:txOrder.orderStatus];
                    }
                    
                    cell.backgroundColor = 1 == txOrder.side ? [UIColor redColor] : [UIColor greenColor];
                    
                    return  cell;
                };
                
                CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
                    return 25;
                };
                
                NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
                    return 6;
                };
                
                
                // create the alert
                MLTableAlert *alertOrderResult = [MLTableAlert tableAlertWithTitle:@"Order Result"
                                                      cancelButtonTitle:@"OK"
                                                           numberOfRows:row
                                                               andCells:cell
                                                         andCellsHeight:cellHeight];
                [alertOrderResult setHeight:160];
                self.orderProses = YES;
                self.alertPopup = alertOrderResult;
                
                [alertOrderResult showWithColor:white];
//                // show the alert
//                if(1 == txOrder.side)
//                    [alertOrderResult showWithColor:[UIColor redColor]];
//                else
//                    [alertOrderResult showWithColor:[UIColor greenColor]];
            }
        }
    });
}

#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    [orderArray removeAllObjects];

    for (TxOrder *order in originOrderDictionary.allValues) {
        
        NSInteger idxClient = clientDropList.currActiveIndex;
        NSInteger idxAction = bsDropList.currActiveIndex;
        NSInteger idxStatus = statusDropList.currActiveIndex;
        
        //@[@"All", @"Open", @"Fully Match", @"Partial Match", @"Pooling", @"Amended", @"Withdraw", @"Reject", @"In Process", @"Waiting in Process"]
        NSString *clientcode = @"All";
        NSString *status = idxStatus == 1 ? @"0" :
        idxStatus == 2 ? @"2" :
        idxStatus == 3 ? @"1" :
        idxStatus == 4 ? @"KD" :
        idxStatus == 5 ? @"5" :
        idxStatus == 6 ? @"4" :
        idxStatus == 7 ? @"8" :
        idxStatus == 8 ? @"9" :
        idxStatus == 9 ? @"W" : @"";
        
        if (idxClient > 0) {
            ClientList *client = [arrayClientList objectAtIndex:idxClient - 1];
            clientcode = client.clientcode;
        }
        
        if(
           ((idxClient == 0) || [order.clientCode isEqualToString:clientcode]) &&
           ((idxAction == 0) || (idxAction == order.side)) &&
           ((idxStatus == 0) || ([order.orderStatus isEqualToString:status]))
           ) {
            
            [orderArray addObject:order];
        }
    }
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"createdTime" ascending:NO];
    [orderArray sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    
    [tableview reloadData];
}

#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[OrderListCell alloc] init];;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TxOrder *order = [orderArray objectAtIndex:indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    
    if(nil == cell) {
        cell = [[OrderListCell alloc] init];
        
        //NSString *status = [OrderListViewController statusInitial:order.orderStatus];
        NSString *status = [OrderListViewController statusDescription:order.orderStatus];
        
        cell.timeLabel.text = order.createdTime;
        cell.aLabel.text = order.side == 1 ? @"B" : @"S";
        cell.stockLabel.text = order.securityCode;
        cell.priceLabel.text = currencyString([NSNumber numberWithInt:order.price]);
        cell.lotLabel.text = currencyString([NSNumber numberWithInt:order.orderQty]);
        cell.sLabel.text = status;
        
        if (1 == order.side) {
            cell.aLabel.textColor = BUY_COLOR;
            cell.stockLabel.textColor = BUY_COLOR;
            cell.priceLabel.textColor = BUY_COLOR;
            cell.lotLabel.textColor = BUY_COLOR;
            cell.sLabel.textColor = BUY_COLOR;
        }
        else {
            cell.aLabel.textColor = SELL_COLOR;
            cell.stockLabel.textColor = SELL_COLOR;
            cell.priceLabel.textColor = SELL_COLOR;
            cell.lotLabel.textColor = SELL_COLOR;
            cell.sLabel.textColor = SELL_COLOR;
        }
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:167.0/255.0 green:152.0/255.0 blue:101.0/255.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TxOrder *tx = [orderArray objectAtIndex:indexPath.row];
    
    if ([@"0" isEqualToString:tx.orderStatus] || [@"1" isEqualToString:tx.orderStatus] ||
        [@"KA" isEqualToString:tx.orderStatus] || [@"KC" isEqualToString:tx.orderStatus]) {
        
        [self txOrderPopup:tx tradeDone:NO];
    }
    else {
        [OrderListViewController TxOrderPopup:tx tradeDone:NO];
    }
    
}

- (void)txOrderPopup:(TxOrder*)tx tradeDone:(BOOL)done
{
    NSArray *array = [AgentTrade sharedInstance].getClients;
    
    NSString *clientName = @"";
    
    for (ClientList *cl in array) {
        if ([cl.clientcode isEqualToString:tx.clientCode]) {
            clientName = cl.name;
        }
    }
    
    NSString *lot = @"0";
    if([@"1" isEqualToString:tx.orderStatus] ||
       [@"2" isEqualToString:tx.orderStatus] ||
       [@"4" isEqualToString:tx.orderStatus] ||
       [@"5" isEqualToString:tx.orderStatus] ||
       done == YES) {
        lot = currencyString([NSNumber numberWithFloat:tx.cumQty]);
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[OrderListViewController statusDescription:tx.orderStatus] forKey:@"Status"];
    [mdic setObject:tx.securityCode forKey:@"Stock"];
    [mdic setObject:(1 == tx.side ? @"Buy" : @"SELL") forKey:@"Side"];
    [mdic setObject:clientName forKey:@"Client Name"];
    [mdic setObject:tx.jatsOrderId forKey:@"Jats ID"];
    [mdic setObject:tx.orderId forKey:@"Clord ID"];
    [mdic setObject:lot forKey:@"Match"];
    [mdic setObject:currencyString([NSNumber numberWithFloat:tx.orderQty]) forKey:@"Lot"];
    [mdic setObject:currencyString([NSNumber numberWithFloat:(tx.orderQty - tx.cumQty)]) forKey:@"Balance"];
    
    if([@"8" isEqualToString:tx.orderStatus]) {
        if (![@" " isEqualToString:tx.description]) {
            [mdic setObject:tx.description forKey:@"Reject"];
        }
        else if(![@" " isEqualToString:tx.reasonText]) {
            [mdic setObject:tx.reasonText forKey:@"Reject"];
        }
    }
    
    if([@"r" isEqualToString:tx.orderStatus]) {
        if(![@" " isEqualToString:tx.reasonText]) {
            NSString *text = [tx.reasonText stringByReplacingOccurrencesOfString:@"Internal Reject: " withString:@""];
            [mdic setObject:text forKey:@"Internal Reject"];
        }
        else if (![@" " isEqualToString:tx.description]) {
            NSString *text = [tx.description stringByReplacingOccurrencesOfString:@"Internal Reject: " withString:@""];
            [mdic setObject:text forKey:@"Internal Reject"];
        }
    }
    
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        UIColor *color = [UIColor clearColor];
        cell.leftLabel.backgroundColor = color;
        cell.sepLabel.backgroundColor = color;
        cell.rightLabel.backgroundColor = color;
        
        cell.rightLabel.textColor = black;
        
        //    1. Client Name
        //    2. Side
        //    3. Stock
        //    4. Quantity
        //    5. Match
        //    6. Balance
        //    7. Status
        //    8. Jats ID
        //    9. Clord ID
        //    10. Reject/Internal Reject
        
        if(0 == indexPath.row) {
            cell.leftLabel.text = @"Client Name";
        }
        else if(1 == indexPath.row) {
            cell.leftLabel.text = @"Side";
        }
        else if(2 == indexPath.row) {
            cell.leftLabel.text = @"Stock";
        }
        else if(3 == indexPath.row) {
            cell.leftLabel.text = @"Lot";
        }
        else if(4 == indexPath.row) {
            cell.leftLabel.text = @"Match";
        }
        else if(5 == indexPath.row) {
            cell.leftLabel.text = @"Balance";
        }
        else if(6 == indexPath.row) {
            cell.leftLabel.text = @"Status";
        }
        else if(7 == indexPath.row) {
            cell.leftLabel.text = @"Jats ID";
        }
        else if(8 == indexPath.row) {
            cell.leftLabel.text = @"Clord ID";
        }
        else if (9 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (9 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        else if (10 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (10 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        
        cell.rightLabel.text = [mdic objectForKey:cell.leftLabel.text];
        
        CGSize constraint = CGSizeMake(175, 20000.f);
        CGSize size = [cell.rightLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        cell.rightLabel.frame = CGRectMake(85, 2, 175, MAX(size.height, 20));
        
        
        //cell.backgroundColor = 1 == tx.side ? [UIColor redColor] : [UIColor greenColor];
        cell.backgroundColor = white;
        
        return  cell;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        cell.leftLabel.backgroundColor = [UIColor clearColor];
        cell.sepLabel.backgroundColor = [UIColor clearColor];
        cell.rightLabel.backgroundColor = [UIColor clearColor];
        
        if(0 == indexPath.row) {
            cell.leftLabel.text = @"Client Name";
        }
        else if(1 == indexPath.row) {
            cell.leftLabel.text = @"Side";
        }
        else if(2 == indexPath.row) {
            cell.leftLabel.text = @"Stock";
        }
        else if(3 == indexPath.row) {
            cell.leftLabel.text = @"Lot";
        }
        else if(4 == indexPath.row) {
            cell.leftLabel.text = @"Match";
        }
        else if(5 == indexPath.row) {
            cell.leftLabel.text = @"Balance";
        }
        else if(6 == indexPath.row) {
            cell.leftLabel.text = @"Status";
        }
        else if(7 == indexPath.row) {
            cell.leftLabel.text = @"Jats ID";
        }
        else if(8 == indexPath.row) {
            cell.leftLabel.text = @"Clor ID";
        }
        else if (9 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (9 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        else if (10 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (10 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        
        cell.rightLabel.text = [mdic objectForKey:cell.leftLabel.text];
        
        CGSize constraint = CGSizeMake(175, 20000.0f);
        CGSize size = [cell.rightLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height, 20.0f);
        
        //cell.backgroundColor = 1 == tx.side ? [UIColor redColor] : [UIColor greenColor];
        cell.backgroundColor = white;
        
        return height + 4;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return mdic.allValues.count;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Change Order"
                                          cancelButtonTitle:@"Amend"
                                              okButtonTitle:@"Withdraw"
                                           otherButtonTitle:@"Cancel"
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    [alert setHeight:160];
    
    [alert setHeight:340];
    
    void (^cancelButtonOnClick)(void) = ^ {
        AmendWithdrawController *vc = [[AmendWithdrawController alloc] initWithTxOrder:tx isWithdraw:NO];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
        [self presentViewController:vc animated:YES completion:nil];
    };
    alert.cancelButtonOnClick = cancelButtonOnClick;
    
    void (^okButtonOnClick)(void) = ^ {
        AmendWithdrawController *vc = [[AmendWithdrawController alloc] initWithTxOrder:tx isWithdraw:YES];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
        [self presentViewController:vc animated:YES completion:nil];
    };
    alert.okButtonOnClick = okButtonOnClick;
    
    [alert showWithColor:white];
//	// show the alert
//	//[alert show];
//    if(1 == tx.side)
//        [alert showWithColor:[UIColor redColor]];
//    else
//        [alert showWithColor:[UIColor greenColor]];
}

+ (void)TxOrderPopup:(TxOrder*)tx tradeDone:(BOOL)done
{
    NSArray *array = [AgentTrade sharedInstance].getClients;
    
    NSString *clientName = @"";
    
    for (ClientList *cl in array) {
        if ([cl.clientcode isEqualToString:tx.clientCode]) {
            clientName = cl.name;
        }
    }
    
    NSString *lot = @"0";
    
    if([@"1" isEqualToString:tx.orderStatus] ||
       [@"2" isEqualToString:tx.orderStatus] ||
       [@"4" isEqualToString:tx.orderStatus] ||
       [@"5" isEqualToString:tx.orderStatus] ||
       done == YES) {
        lot = currencyString([NSNumber numberWithFloat:tx.cumQty]);
    }
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setObject:[OrderListViewController statusDescription:tx.orderStatus] forKey:@"Status"];
    [mdic setObject:tx.securityCode forKey:@"Stock"];
    [mdic setObject:currencyStringFromInt(tx.price) forKey:@"Price"];
    [mdic setObject:(1 == tx.side ? @"Buy" : @"SELL") forKey:@"Side"];
    [mdic setObject:clientName forKey:@"Client Name"];
    [mdic setObject:tx.jatsOrderId forKey:@"Jats ID"];
    [mdic setObject:tx.orderId forKey:@"Clord ID"];
    [mdic setObject:lot forKey:@"Match"];
    [mdic setObject:currencyString([NSNumber numberWithFloat:tx.orderQty]) forKey:@"Lot"];
    //if([@"1" isEqualToString:tx.orderStatus]) {
    [mdic setObject:currencyString([NSNumber numberWithFloat:(tx.orderQty - tx.cumQty)]) forKey:@"Balance"];
    //}
    
    if([@"8" isEqualToString:tx.orderStatus]) {
        if (![@" " isEqualToString:tx.description]) {
            [mdic setObject:tx.description forKey:@"Reject"];
        }
        else if(![@" " isEqualToString:tx.reasonText]) {
            [mdic setObject:tx.reasonText forKey:@"Reject"];
        }
    }
    
    if([@"r" isEqualToString:tx.orderStatus]) {
        if(![@" " isEqualToString:tx.reasonText]) {
            NSString *text = [tx.reasonText stringByReplacingOccurrencesOfString:@"Internal Reject: " withString:@""];
            [mdic setObject:text forKey:@"Internal Reject"];
        }
        else if (![@" " isEqualToString:tx.description]) {
            NSString *text = [tx.description stringByReplacingOccurrencesOfString:@"Internal Reject: " withString:@""];
            [mdic setObject:text forKey:@"Internal Reject"];
        }
    }
    
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        UIColor *color = [UIColor clearColor];
        cell.leftLabel.backgroundColor = color;
        cell.sepLabel.backgroundColor = color;
        cell.rightLabel.backgroundColor = color;
        
        //    1. Client Name
        //    2. Side
        //    3. Stock
        //    4. Price
        //    5. Quantity
        //    6. Match
        //    7. Balance
        //    8. Status
        //    9. Jats ID
        //    10. Clord ID
        //    11. Reject/Internal Reject
        
        if(0 == indexPath.row) {
            cell.leftLabel.text = @"Client Name";
        }
        else if(1 == indexPath.row) {
            cell.leftLabel.text = @"Side";
        }
        else if(2 == indexPath.row) {
            cell.leftLabel.text = @"Stock";
        }
        else if(3 == indexPath.row) {
            cell.leftLabel.text = @"Price";
        }
        else if(4 == indexPath.row) {
            cell.leftLabel.text = @"Lot";
        }
        else if(5 == indexPath.row) {
            cell.leftLabel.text = @"Match";
        }
        else if(6 == indexPath.row) {
            cell.leftLabel.text = @"Balance";
        }
        else if(7 == indexPath.row) {
            cell.leftLabel.text = @"Status";
        }
        else if(8 == indexPath.row) {
            cell.leftLabel.text = @"Jats ID";
        }
        else if(9 == indexPath.row) {
            cell.leftLabel.text = @"Clord ID";
        }
        else if (10 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (10 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        else if (11 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (11 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        
        cell.rightLabel.text = [mdic objectForKey:cell.leftLabel.text];
        cell.rightLabel.textColor = [UIColor blackColor];
        
        CGSize constraint = CGSizeMake(175, 20000.f);
        CGSize size = [cell.rightLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        cell.rightLabel.frame = CGRectMake(85, 2, 175, MAX(size.height, 20));
        
        
        //cell.backgroundColor = 1 == tx.side ? [UIColor redColor] : [UIColor greenColor];
        cell.backgroundColor = white;
        
        return  cell;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        cell.leftLabel.backgroundColor = [UIColor clearColor];
        cell.sepLabel.backgroundColor = [UIColor clearColor];
        cell.rightLabel.backgroundColor = [UIColor clearColor];
        
        if(0 == indexPath.row) {
            cell.leftLabel.text = @"Client Name";
        }
        else if(1 == indexPath.row) {
            cell.leftLabel.text = @"Side";
        }
        else if(2 == indexPath.row) {
            cell.leftLabel.text = @"Stock";
        }
        else if(3 == indexPath.row) {
            cell.leftLabel.text = @"Lot";
        }
        else if(4 == indexPath.row) {
            cell.leftLabel.text = @"Match";
        }
        else if(5 == indexPath.row) {
            cell.leftLabel.text = @"Balance";
        }
        else if(6 == indexPath.row) {
            cell.leftLabel.text = @"Status";
        }
        else if(7 == indexPath.row) {
            cell.leftLabel.text = @"Jats ID";
        }
        else if(8 == indexPath.row) {
            cell.leftLabel.text = @"Clor ID";
        }
        else if (9 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (9 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        else if (10 == indexPath.row && [@"8" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Reject";
        }
        else if (10 == indexPath.row && [@"r" isEqualToString:tx.orderStatus]) {
            cell.leftLabel.text = @"Internal Reject";
        }
        
        cell.rightLabel.text = [mdic objectForKey:cell.leftLabel.text];
        cell.rightLabel.textColor = [UIColor blackColor];
        
        CGSize constraint = CGSizeMake(175, 20000.0f);
        CGSize size = [cell.rightLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = MAX(size.height, 20.0f);
        
        //cell.backgroundColor = 1 == tx.side ? [UIColor redColor] : [UIColor greenColor];
        cell.backgroundColor = white;
        
        return height + 4;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        return mdic.allValues.count;
    };
    
    // create the alert
    MLTableAlert *alert = [MLTableAlert tableAlertWithTitle:@"Order Status"
                                          cancelButtonTitle:@"Close"
                                               numberOfRows:row
                                                   andCells:cell
                                             andCellsHeight:cellHeight];
    
    [alert setHeight:340];
    
    [alert showWithColor:white];
//	// show the alert
//	//[alert show];
//    if(1 == tx.side)
//        [alert showWithColor:[UIColor redColor]];
//    else
//        [alert showWithColor:[UIColor greenColor]];
}

+ (NSString*) statusInitial:(NSString*)status
{
    if(nil != status) {
        if([@"0" isEqualToString:status]) {
            return @"O";
        }
        else if([@"1" isEqualToString:status]) {
            return @"P M";
        }
        else if([@"2" isEqualToString:status]) {
            return @"F M";
        }
        else if([@"3" isEqualToString:status]) {
            return @"Dfd";
        }
        else if([@"4" isEqualToString:status]) {
            return @"W";
        }
        else if([@"5" isEqualToString:status]) {
            return @"A";
        }
        else if([@"6" isEqualToString:status]) {
            return @"P C";
        }
        else if([@"7" isEqualToString:status]) {
            return @"S";
        }
        else if([@"8" isEqualToString:status]) {
            return @"R";
        }
        else if([@"9" isEqualToString:status]) {
            return @"I P";
        }
        else if([@"A" isEqualToString:status]) {
            return @"P N";
        }
        else if([@"B" isEqualToString:status]) {
            return @"C";
        }
        else if([@"C" isEqualToString:status]) {
            return @"E";
        }
        else if([@"D" isEqualToString:status]) {
            return @"A B";
        }
        else if([@"E" isEqualToString:status]) {
            return @"P R";
        }
        else if([@"KA" isEqualToString:status]) {
            return @"Pre";
        }
        else if([@"KB" isEqualToString:status]) {
            return @"Pre";
        }
        else if([@"KC" isEqualToString:status]) {
            return @"Poo";
        }
        else if([@"KD" isEqualToString:status]) {
            return @"Poo";
        }
        else if([@"kc" isEqualToString:status]) {
            return @"Poo";
        }
        else if([@"r" isEqualToString:status]) {
            return @"I R";
        }
    }
    
    return @"";
}

+ (NSString*) statusDescription:(NSString*)status
{
    if(nil != status) {
        if([@"0" isEqualToString:status]) {
            return @"Open";
        }
        else if([@"1" isEqualToString:status]) {
            return @"Partially Match";
        }
        else if([@"2" isEqualToString:status]) {
            return @"Fully Match";
        }
        else if([@"3" isEqualToString:status]) {
            return @"Done for day";
        }
        else if([@"4" isEqualToString:status]) {
            return @"withdrawn";
        }
        else if([@"5" isEqualToString:status]) {
            return @"Amended";
        }
        else if([@"6" isEqualToString:status]) {
            return @"Pending Cancel";
        }
        else if([@"7" isEqualToString:status]) {
            return @"Stopped";
        }
        else if([@"8" isEqualToString:status]) {
            return @"Rejected";
        }
        else if([@"9" isEqualToString:status]) {
            return @"In Process";
        }
        else if([@"A" isEqualToString:status]) {
            return @"Pending New";
        }
        else if([@"B" isEqualToString:status]) {
            return @"Calculated";
        }
        else if([@"C" isEqualToString:status]) {
            return @"Expired";
        }
        else if([@"D" isEqualToString:status]) {
            return @"Accepted for Bidding";
        }
        else if([@"E" isEqualToString:status]) {
            return @"Pending Replace";
        }
        else if([@"KA" isEqualToString:status]) {
            return @"Preopening Not Submitted";
        }
        else if([@"KB" isEqualToString:status]) {
            return @"Preopening Submitted";
        }
        else if([@"KC" isEqualToString:status]) {
            return @"Pooling Not Submitted";
        }
        else if([@"KD" isEqualToString:status]) {
            return @"Pooling Submitted";
        }
        else if([@"kc" isEqualToString:status]) {
            return @"Pooling Cancel";
        }
        else if([@"r" isEqualToString:status]) {
            return @"Internal Reject";
        }
        else if([@"W" isEqualToString:status]) {
            return @"Waiting Process";
        }
        else if([@"1x0001" isEqualToString:status]) {
            return @"Order Received By Server";
        }
    }
    
    return @"";
}

//cek apakah statusnya boleh di masukan ke order list atau tidak
+ (BOOL) isStatusAllowed:(NSString*)status
{
    if(nil != status) {
        if([@"0" isEqualToString:status] ||
           [@"1" isEqualToString:status] ||
           [@"2" isEqualToString:status] ||
           [@"3" isEqualToString:status] ||
           [@"4" isEqualToString:status] ||
           [@"5" isEqualToString:status] ||
           [@"6" isEqualToString:status] ||
           [@"7" isEqualToString:status] ||
           [@"8" isEqualToString:status] ||
           [@"A" isEqualToString:status] ||
           [@"E" isEqualToString:status] ||
           [@"KA" isEqualToString:status]||
           [@"KB" isEqualToString:status]||
           [@"KC" isEqualToString:status]||
           [@"KD" isEqualToString:status]||
           [@"kc" isEqualToString:status]||
           [@"r" isEqualToString:status]) {
            
            return YES;
        }
    }
    
    return NO;
}

@end





@implementation OrderListCell

- (id)init
{
    if(self = [super init]) {
        _timeLabel = labelOnTableWithLabel(@"Time", CGRectMake(2, 0, 60, 15));
        _aLabel = labelOnTableWithLabel(@"Side", CGRectMake(63, 0, 30, 15));
        _stockLabel = labelOnTableWithLabel(@"Stock", CGRectMake(95, 0, 60, 15));
        _priceLabel = labelOnTableWithLabel(@"Price", CGRectMake(158, 0, 60, 15));
        _lotLabel = labelOnTableWithLabel(@"Lot", CGRectMake(221, 0, 55, 15));
        _sLabel = labelOnTableWithLabel(@"Status", CGRectMake(279, 0, 120, 15));
        
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _stockLabel.textAlignment = NSTextAlignmentLeft;
        _aLabel.textAlignment = NSTextAlignmentCenter;
        _sLabel.textAlignment = NSTextAlignmentLeft;
        
        _aLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _lotLabel.adjustsFontSizeToFitWidth = YES;
        _sLabel.adjustsFontSizeToFitWidth = YES;
        _stockLabel.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundColor = black;
        
        [self addSubview:_timeLabel];
        [self addSubview:_aLabel];
        [self addSubview:_stockLabel];
        [self addSubview:_priceLabel];
        [self addSubview:_lotLabel];
        [self addSubview:_sLabel];
    }
    
    return self;
}

@end




@implementation OrderList2Cell

- (id)init
{
    if(self = [super init]) {
        _priceLabel = labelOnTableWithLabel(@"Price", CGRectMake(0, 2, 78, 20));
        _volLabel = labelOnTableWithLabel(@"Volume", CGRectMake(80, 2, 78, 20));
        
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _volLabel.font = [UIFont systemFontOfSize:14];
        
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _volLabel.adjustsFontSizeToFitWidth = YES;
        
        self.backgroundColor = black;
        
        [self addSubview:_priceLabel];
        [self addSubview:_volLabel];
    }
    
    return self;
}

@end



@implementation TxOrderCell

- (id)init
{
    if(self = [super init]) {
        _leftLabel = labelOnTableWithLabel(@"LEFT", CGRectMake(2, 2, 75, 20));
        _sepLabel = labelOnTableWithLabel(@": ", CGRectMake(80, 2, 4, 20));
        _rightLabel = labelOnTableWithLabel(@"RIGHT", CGRectMake(88, 2, 175, 20));
        
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _sepLabel.font = [UIFont systemFontOfSize:14];
        
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _sepLabel.textAlignment = NSTextAlignmentCenter;
        
        _leftLabel.adjustsFontSizeToFitWidth = YES;
        _rightLabel.adjustsFontSizeToFitWidth = YES;
        
        _leftLabel.textColor = [UIColor blackColor];
        _sepLabel.textColor = [UIColor blackColor];
        
        _rightLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //_rightLabel.minimumFontSize = 14;
        _rightLabel.minimumScaleFactor = 14;
        _rightLabel.numberOfLines = 0;

        
        self.backgroundColor = black;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:_leftLabel];
        [self addSubview:_sepLabel];
        [self addSubview:_rightLabel];
    }
    
    return self;
}

@end