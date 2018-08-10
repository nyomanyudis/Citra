//
//  TradeListViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "TradeListViewController.h"
#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "ImageResources.h"
//#import "GRAlertView.h"
#import "MLTableAlert.h"
#import "OrderListViewController.h"

@interface TradeListViewController () <UIDropListDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray *arrayClientList;
@property (retain, nonatomic) NSMutableDictionary *originOrderDictionary;
@property (retain, nonatomic) NSMutableArray *orderArray;
@property (retain, nonatomic) NSArray *allKeys;

@end

@implementation TradeListViewController


@synthesize homeBarItem, backBarItem;
@synthesize originOrderDictionary, allKeys, orderArray;
@synthesize clientDropList, bsDropList, tableview, scrollview;
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
    
    [bsDropList arrayList:ACTION];
    
    [clientDropList setDropDelegate:self];
    [bsDropList setDropDelegate:self];
    [clientDropList showRightIcon:NO];
    
    [[AgentTrade sharedInstance] subscribeTrade];
    
    tableview.autoresizesSubviews=NO;
    tableview.frame = CGRectMake(tableview.frame.origin.x, tableview.frame.origin.y , tableview.frame.size.width+82, tableview.frame.size.height+5);
    scrollview.contentSize = CGSizeMake(tableview.frame.size.width, scrollview.frame.size.height + 100);
    
    orderArray =  [NSMutableArray array];
    
    originOrderDictionary = [AgentTrade sharedInstance].getTradeDictionary;
    if(nil != originOrderDictionary) {
        allKeys = originOrderDictionary.allKeys;
        [orderArray addObjectsFromArray:originOrderDictionary.allValues];
    }
    
    
    if(nil != orderArray)
        orderArray = [OrderListViewController sortOrderList:orderArray];
    
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
        
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.currActiveIndex];
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
    [self setTableview:nil];
    [super viewDidUnload];
}




#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupClient:NO];
            [tableview reloadData];
        });
    }
    else if(RecordTypeGetTrades == msg.recType) {
        [self updateTrade:[AgentTrade sharedInstance].getTradeDictionary];
    }
}

#pragma mark
#pragma AgentOrderListDelegate
- (void)updateTrade:(NSMutableDictionary*)tradeDictionary
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil != tradeDictionary && tradeDictionary.count > 0) {
            originOrderDictionary = tradeDictionary;
            
            if(nil != originOrderDictionary) {
                allKeys = originOrderDictionary.allKeys;
                
                [orderArray removeAllObjects];
                [orderArray addObjectsFromArray:originOrderDictionary.allValues];
                
                if(nil != orderArray)
                    orderArray = [OrderListViewController sortOrderList:orderArray];
                
                [tableview reloadData];
            }
        }
    });
}

#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    [orderArray removeAllObjects];
    
//    for (NSObject *key in allKeys) {
//        TxOrder *order = [originOrderDictionary objectForKey:key];
    for (TxOrder *order in originOrderDictionary.allValues) {
        
        uint32_t idxClient = clientDropList.currActiveIndex;
        uint32_t idxAction = bsDropList.currActiveIndex;
        
        NSString *clientcode = @"All";
        
        if (idxClient > 0) {
            ClientList *client = [arrayClientList objectAtIndex:idxClient - 1];
            clientcode = client.clientcode;
        }
        
        if(
           ((idxClient == 0) || [order.clientCode isEqualToString:clientcode]) &&
           ((idxAction == 0) || (idxAction == order.side))) {
            
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
    OrderListCell *cell = [[OrderListCell alloc] init];
    cell.sLabel.text = @"Client";
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TxOrder *order = [orderArray objectAtIndex:indexPath.row];
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell"];
    
    if(nil == cell)
        cell = [[OrderListCell alloc] init];
    
    NSArray *array = [AgentTrade sharedInstance].getClients;
    NSString *clientName = @"";
    for (ClientList *cl in array) {
        if ([cl.clientcode isEqualToString:order.clientCode]) {
            clientName = cl.name;
        }
    }
    
    NSString *time = order.tradeTime;
    if(time.length > 8) {
        time = [time substringToIndex:8];
    }
    
    cell.sLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    cell.timeLabel.text = time;
    cell.aLabel.text = order.side == 1 ? @"B" : @"S";
    cell.stockLabel.text = order.securityCode;
    cell.priceLabel.text = currencyString([NSNumber numberWithInt:order.tradePrice]);
    cell.lotLabel.text = currencyString([NSNumber numberWithFloat:order.tradeQty]);
    cell.sLabel.text = clientName;
    
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


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [OrderListViewController TxOrderPopup:[orderArray objectAtIndex:indexPath.row] tradeDone:YES];
    
    [self txOrderPopup:[orderArray objectAtIndex:indexPath.row] tradeDone:YES];
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
    [mdic setObject:currencyStringFromInt(tx.price) forKey:@"Price"];
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
        cell.rightLabel.textColor = [UIColor blackColor];
        
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
        
        CGSize constraint = CGSizeMake(175, 20000.f);
        CGSize size = [cell.rightLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        cell.rightLabel.frame = CGRectMake(85, 2, 175, MAX(size.height, 20));
        
        
        //cell.backgroundColor = 1 == tx.side ? [UIColor redColor] : [UIColor greenColor];
        cell.backgroundColor = white;
        
        return  cell;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        TxOrderCell *cell = [[TxOrderCell alloc] init];
        
        cell.rightLabel.textColor = [UIColor blackColor];
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

@end
