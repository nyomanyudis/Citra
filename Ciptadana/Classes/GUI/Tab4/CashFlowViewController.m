//
//  CashFlowViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "CashFlowViewController.h"
#import "UIButton+Customized.h"
#import "MLTableAlert.h"

@interface CashFlowViewController () <UIDropListDelegate>

@property (retain, nonatomic) NSArray *arrayClientList;
@property (weak, nonatomic) IBOutlet UILabel *receive0;
@property (weak, nonatomic) IBOutlet UILabel *receive1;
@property (weak, nonatomic) IBOutlet UILabel *receive2;
@property (weak, nonatomic) IBOutlet UILabel *receive3;
@property (weak, nonatomic) IBOutlet UILabel *pay0;
@property (weak, nonatomic) IBOutlet UILabel *pay1;
@property (weak, nonatomic) IBOutlet UILabel *pay2;
@property (weak, nonatomic) IBOutlet UILabel *pay3;
@property (weak, nonatomic) IBOutlet UILabel *nett0;
@property (weak, nonatomic) IBOutlet UILabel *nett1;
@property (weak, nonatomic) IBOutlet UILabel *nett2;
@property (weak, nonatomic) IBOutlet UILabel *nett3;
@property (weak, nonatomic) IBOutlet UILabel *nettCash0;
@property (weak, nonatomic) IBOutlet UILabel *nettCash1;
@property (weak, nonatomic) IBOutlet UILabel *nettCash2;
@property (weak, nonatomic) IBOutlet UILabel *nettCash3;

@end

@implementation CashFlowViewController

@synthesize backBarItem, homeBarItem;
@synthesize clientDropList;
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
    [self dismissViewControllerAnimated:YES completion:^{
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
    
    [clientDropList setDropDelegate:self];
    
    NSArray *parse = [[AgentTrade sharedInstance].loginDataFeed.generalMsg componentsSeparatedByString: @"|"];
    if(parse != nil && parse.count > 1) {
        NSString *tgl = [parse objectAtIndex:1];
        NSArray *t = [tgl componentsSeparatedByString:@"~"];
        if(t.count >= 4) {
            NSString *dateString0 = [t objectAtIndex:0];
            NSString *dateString1 = [t objectAtIndex:1];
            NSString *dateString2 = [t objectAtIndex:2];
            NSString *dateString3 = [t objectAtIndex:3];
            
            _receive0.text = dateString0;
            _receive1.text = dateString1;
            _receive2.text = dateString2;
            _receive3.text = dateString3;
            
            _pay0.text = dateString0;
            _pay1.text = dateString1;
            _pay2.text = dateString2;
            _pay3.text = dateString3;
            
            _nett0.text = dateString0;
            _nett1.text = dateString1;
            _nett2.text = dateString2;
            _nett3.text = dateString3;
            
            _nettCash0.text = dateString0;
            _nettCash1.text = dateString1;
            _nettCash2.text = dateString2;
            _nettCash3.text = dateString3;
        }
        
        t = nil;
    }
    parse = nil;
    
    //_scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height -  (clientDropList.frame.size.height + clientDropList.frame.origin.y));
    
    [self setupView:YES];
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

- (void)setupView:(bool)requestClientList
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
    
    if (nil != arrayClientList && arrayClientList.count > 0) {
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.selectedIndex];
        [trade subscribe:RecordTypeGetCashFlow requestType:RequestGet clientcode:client.clientcode];
        [self playAnimate];
    }

}

- (void)playAnimate
{
    self.clientDropList.userInteractionEnabled = NO;
    self.scrollview.userInteractionEnabled = NO;
    [self.animIndicator startAnimating];
}

- (void)stopAnimate
{
    self.clientDropList.userInteractionEnabled = YES;
    self.scrollview.userInteractionEnabled = YES;
    [self.animIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setRt1Label:nil];
    [self setRt2Label:nil];
    [self setRt3Label:nil];
    [self setPt1Label:nil];
    [self setPt2Label:nil];
    [self setPt3Label:nil];
    [self setNt1Label:nil];
    [self setNt2Label:nil];
    [self setNt3Label:nil];
    [self setClientDropList:nil];
    [super viewDidUnload];
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
    else if (RecordTypeGetCashFlow == msg.recType) {
        [self updateCashFlow:msg.recCashflow];
    }
}

- (void)updateCashFlow:(NSArray *)arrayCashFlow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.positiveFormat = @"###,###.##";
        formatter.roundingMode = NSNumberFormatterNoStyle;
        
        for (CashFlow *cash in arrayCashFlow) {
            
            NSString *desc = cash.description;
//            NSLog(@"cashflow %@", desc);
//            NSLog(@"t0 = %.0f", cash.t0);
//            NSLog(@"t1 = %.0f", cash.t1);
//            NSLog(@"t2 = %.0f", cash.t2);
//            NSLog(@"t3 = %.0f", cash.t3);
            
//            if([@"Receivable" isEqualToString:desc]) {
//                _rt0Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t0]];
//                _rt1Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t1]];
//                _rt2Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t2]];
//                _rt3Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t3]];
//            }
//            else if([@"Payable" isEqualToString:desc]) {
//                _pt0Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t0]];
//                _pt1Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t1]];
//                _pt2Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t2]];
//                _pt3Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t3]];
//            }
            if([@"Nett" isEqualToString:desc]) {
                _nt0Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t0]];
                _nt1Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t1]];
                _nt2Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t2]];
                _nt3Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t3]];
            }
            else if([@"Nett Cash" isEqualToString:desc]) {
                _nc0Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t0]];
                _nc1Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t1]];
                _nc2Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t2]];
                _nc3Label.text = [formatter stringFromNumber:[NSNumber numberWithFloat:cash.t3]];
            }
        }
        
        [self stopAnimate];
    });
}

#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    if(nil != arrayClientList && index < arrayClientList.count && index != clientDropList.selectedIndex) {
        ClientList *client = [arrayClientList objectAtIndex:index];
        [[AgentTrade sharedInstance] subscribe:RecordTypeGetCashFlow requestType:RequestGet clientcode:client.clientcode];
        [self playAnimate];
    }
}

@end
