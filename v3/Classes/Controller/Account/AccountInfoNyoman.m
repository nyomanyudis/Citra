//
//  AccountInfoNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 8/1/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "AccountInfoNyoman.h"

@interface AccountInfoNyoman () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
//@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) AccountInfo *account;

@end

@implementation AccountInfoNyoman

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
//    self.table.dataSource = self;
//    self.table.delegate = self;
    
//    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
//        self.client.text = c.name;
//        [[MarketTrade sharedInstance] subscribe:RecordTypeGetAccountInfo requestType:RequestGet clientcode:c.clientcode];
    }
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
