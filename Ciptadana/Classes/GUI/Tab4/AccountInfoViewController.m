//
//  AccountInfoViewController.m
//  Ciptadana
//
//  Created by Reyhan on 10/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AccountInfoViewController.h"
//#import "AppDelegate.h"
#import "MLTableAlert.h"

#import <QuartzCore/QuartzCore.h>

@interface AccountInfoViewController () <UIDropListDelegate>

@property (retain, nonatomic) NSArray *arrayClientList;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation AccountInfoViewController


@synthesize backBarItem, homeBarItem;
@synthesize scrollView, clientDropList;
@synthesize arrayClientList;
@synthesize cityTF, zipTF, provinceTF, phoneTF, faxTF, mPhoneTF, sidTF, subRekTF, rdiAccountTF, rdiNumberTF, bankTF, rekTF, addressTF;


- (void)backBarItemClicked:(id)s
{
    [[AgentTrade sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    [clientDropList setDropDelegate:self];
    
    addressTF.layer.borderColor = [UIColor grayColor].CGColor;
    addressTF.layer.borderWidth = 1;
    
    addressTF.text = @"ini text alamat";
    
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
        [self.indicator startAnimating];
        [trade subscribe:RecordTypeGetAccountInfo requestType:RequestGet clientcode:client.clientcode];
        
        _clientTF.text = client.clientcode;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHomeBarItem:nil];
    [self setBackBarItem:nil];
    [self setScrollView:nil];
    [self setClientDropList:nil];
    [self setCityTF:nil];
    [self setZipTF:nil];
    [self setProvinceTF:nil];
    [self setPhoneTF:nil];
    [self setFaxTF:nil];
    [self setMPhoneTF:nil];
    [self setSidTF:nil];
    [self setSubRekTF:nil];
    [self setRdiAccountTF:nil];
    [self setBankTF:nil];
    [self setRekTF:nil];
    [self setRdiNumberTF:nil];
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
    else if (RecordTypeGetAccountInfo == msg.recType) {
        [self updateAccountInfo:msg.recAccountInfo];
    }
}

- (void)updateAccountInfo:(AccountInfo *)accountInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.indicator stopAnimating];
        
        if(nil != accountInfo) {
            //NSLog(@"Account Info %@", accountInfo);
            cityTF.text = accountInfo.city;
            zipTF.text = accountInfo.zipcode;
            provinceTF.text = accountInfo.province;
            phoneTF.text = accountInfo.phone;
            faxTF.text = accountInfo.fax;
            mPhoneTF.text = accountInfo.mobilePhone;
            sidTF.text = accountInfo.sid;
            subRekTF.text = accountInfo.subRek;
            rdiAccountTF.text = accountInfo.rdiAccountName;
            rdiNumberTF.text = accountInfo.rdiAccountNo;
            bankTF.text = accountInfo.bankAccount;
            rekTF.text = accountInfo.bankAccountNo;
            addressTF.text = accountInfo.address;
        }
    });
}

#pragma mark
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    if(nil != arrayClientList && index < arrayClientList.count && index != clientDropList.selectedIndex) {
        ClientList *client = [arrayClientList objectAtIndex:clientDropList.selectedIndex];
        [self.indicator startAnimating];
        [[AgentTrade sharedInstance] subscribe:RecordTypeGetAccountInfo requestType:RequestGet clientcode:client.clientcode];
        
        _clientTF.text = client.clientcode;
    }
}

@end
