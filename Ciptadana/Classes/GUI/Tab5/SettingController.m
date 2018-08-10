//
//  SettingController.m
//  Ciptadana
//
//  Created by Reyhan on 6/13/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "SettingController.h"
#import "UIButton+Customized.h"

@interface SettingController ()

@end

@implementation SettingController

@synthesize homeBarItem, backBarItem;
@synthesize receiveBtn, orderStatusBtn;

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
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    [receiveBtn ButtonCheckbox];
    [orderStatusBtn ButtonCheckbox];
    [receiveBtn addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchDown];
    [orderStatusBtn addTarget:self action:@selector(checkbox:) forControlEvents:UIControlEventTouchDown];
    
    receiveBtn.selected = [DBLite sharedInstance].popupReceiveStatus;
    orderStatusBtn.selected = [DBLite sharedInstance].popupOrderStatus;
}

- (void)checkbox:(id)sender
{
    UIButton *b = sender;
    if(b.selected)
        b.selected = NO;
    else
        b.selected = YES;
    
    if(receiveBtn == b)
        [[DBLite sharedInstance] showPopupReceiveStatus:b.selected];
    else
        [[DBLite sharedInstance] showPopupOrderStatus:b.selected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
