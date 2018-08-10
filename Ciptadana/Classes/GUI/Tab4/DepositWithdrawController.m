//
//  DepositWithdrawController.m
//  Ciptadana
//
//  Created by Reyhan on 6/7/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "DepositWithdrawController.h"
#import "ImageResources.h"
#import "MLTableAlert.h"
#import "NSString+StringAdditions.h"

@interface DepositWithdrawController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIDepositCell *headerCell;
@property (retain, nonatomic) NSArray *arrayClientList;
@property (retain, nonatomic) NSArray *arrayCashWithdraw;

@end

@implementation DepositWithdrawController

@synthesize backBarItem, homeBarItem;
@synthesize tableview, headerCell;
@synthesize arrayClientList, arrayCashWithdraw;
@synthesize animator;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AgentTrade sharedInstance] agentSelector:@selector(AgentTradeCallback:) withObject:self];
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    headerCell = [[UIDepositCell alloc] init];
    
    tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self setupView:YES];
}

- (void)setupView:(bool)requestClientList
{
    AgentTrade *trade = [AgentTrade sharedInstance];
    if (trade != nil && trade.getClients != nil) {
        [self subscribeDepositList];
    }
    else if(requestClientList){
        [trade subscribe:RecordTypeClientList requestType:RequestGet];
    }
    else {
        //[self alert:@"You don't have Client List and Order Power"];
    }
}

- (void)subscribeDepositList
{
    if ([AgentTrade sharedInstance] != nil && [AgentTrade sharedInstance].getClients != nil) {
        arrayClientList = [AgentTrade sharedInstance].getClients;
        [animator startAnimating];
        
        if(arrayClientList.count > 0) {
            ClientList *client = [arrayClientList objectAtIndex:0];
            [[AgentTrade sharedInstance] subscribe:RecordTypeGetCashWithdrawList requestType:RequestGet clientcode:client.clientcode];
        }
    }
}

- (void)alert:(NSString*)message
{
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma AgentTradeCallback
- (void)AgentTradeCallback:(TradingMessage *)msg
{
    if (RecordTypeClientList == msg.recType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupView:NO];
        });
    }
    else if(msg.recType == RecordTypeGetCashWithdrawList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            arrayCashWithdraw = msg.recCashWithdrawList;
            [tableview reloadData];
            [animator stopAnimating];
        });
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayCashWithdraw == nil ? 0 : arrayCashWithdraw.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIDepositCell *cell = [tableview dequeueReusableCellWithIdentifier:@"Cell"];
    
    CashWithdraw *cash = [arrayCashWithdraw objectAtIndex:indexPath.row];
    
    if(nil == cell)
        cell = [[UIDepositCell alloc] init];
    
    cell.amountTxt.text = [NSString formatWithThousandSeparator:cash.amount];
    cell.statusTxt.text = cash.reqStatus;
    cell.requestDateTxt.text = cash.reqDate;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MLTableAlert *alert = [[MLTableAlert alloc] initWithTitle:@"Deposit Withdraw Detail"
//                                            cancelButtonTitle:@"Close"
//                                                 numberOfRows:^NSInteger(NSInteger section) {
//                                                     return 5;
//                                                 }
//                                                     andCells:nil
//                                               andCellsHeight:^CGFloat(MLTableAlert *alert, NSIndexPath *indexPath) {
//                                                   return 25;
//                                               }
//                           ];
//    [alert show];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return headerCell;
}

@end



#define white [UIColor whiteColor]
#define black [UIColor blackColor]
#define yellow [UIColor yellowColor]
#define magenta [UIColor magentaColor]
@implementation UIDepositCell

@synthesize amountTxt, statusTxt, requestDateTxt;

- (id)init
{
    if(self = [super init]) {
        //tradeIdTxt = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, 15)];
        requestDateTxt = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 100, 15)];
        amountTxt = [[UILabel alloc] initWithFrame:CGRectMake(105, 2, 75, 15)];
        statusTxt = [[UILabel alloc] initWithFrame:CGRectMake(187, 2, 131, 15)];
        
        amountTxt.textAlignment = NSTextAlignmentRight;
        statusTxt.textAlignment = NSTextAlignmentLeft;
        requestDateTxt.textAlignment = NSTextAlignmentLeft;
        
        amountTxt.textColor = white;
        statusTxt.textColor = white;
        requestDateTxt.textColor = white;
        
        amountTxt.font = [UIFont systemFontOfSize:14];
        statusTxt.font = [UIFont systemFontOfSize:14];
        requestDateTxt.font = [UIFont systemFontOfSize:14];
        
        amountTxt.adjustsFontSizeToFitWidth = YES;
        requestDateTxt.adjustsFontSizeToFitWidth = YES;
        
        amountTxt.text = @"Amount(Rp)";
        statusTxt.text = @"Status";
        requestDateTxt.text = @"Request Date";
        
        self.backgroundColor = black;
        amountTxt.highlightedTextColor = black;
        statusTxt.highlightedTextColor = black;
        requestDateTxt.highlightedTextColor = black;
        
        [self addSubview:amountTxt];
        [self addSubview:statusTxt];
        [self addSubview:requestDateTxt];
        
    }
    
    return self;
}

@end
