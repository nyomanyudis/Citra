//
//  AccountInfoV3.m
//  Ciptadana
//
//  Created by Reyhan on 11/15/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "AccountInfoV3.h"

#import "ThemeUITableViewCell.h"

@interface AccountInfoV3 () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) AccountInfo *account;

@end

@implementation AccountInfoV3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table.dataSource = self;
    self.table.delegate = self;
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetAccountInfo requestType:RequestGet clientcode:c.clientcode];
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

#pragma mark - protected

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeGetAccountInfo) {
            self.account = tm.recAccountInfo;
            [self.table reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.account) {
        if(section == 0)
            return 8;
        else if(section == 1)
            return 2;
        else if(section == 2)
            return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", (int)(indexPath.row + 1)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *left = [cell.contentView viewWithTag:1];
    UILabel *right = [cell.contentView viewWithTag:2];
    
    right.lineBreakMode = NSLineBreakByWordWrapping;
    right.numberOfLines = 10;
    
    [right addConstraint:[NSLayoutConstraint constraintWithItem:right
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute: NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:200]];
    
    
    if(self.account) {
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                left.text = @"Client Code";
                right.text = self.account.clientcode;
            }
            else if(indexPath.row == 1) {
                left.text = @"Name";
                right.text = self.account.name;
            }
            else if(indexPath.row == 2) {
                left.text = @"Address";
                right.text = self.account.address;
            }
            else if(indexPath.row == 3) {
                left.text = @"City";
                right.text = self.account.city;
            }
            else if(indexPath.row == 4) {
                left.text = @"Province";
                right.text = self.account.province;
            }
            else if(indexPath.row == 5) {
                left.text = @"Zipcode";
                right.text = self.account.zipcode;
            }
            else if(indexPath.row == 6) {
                left.text = @"Phone";
                right.text = self.account.phone;
            }
            else if(indexPath.row == 7) {
                left.text = @"Fax";
                right.text = self.account.fax;
            }
        }
        else if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                left.text = @"RDI Account Name";
                right.text = self.account.rdiAccountName;
            }
            else if(indexPath.row == 1) {
                left.text = @"RDI Account No";
                right.text = self.account.rdiAccountNo;
            }
        }
        else if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                left.text = @"Bank Account";
                right.text = self.account.bankAccount;
            }
            else if(indexPath.row == 1) {
                left.text = @"Bank Account No";
                right.text = self.account.bankAccountNo;
            }
        }
    }
    else {
        left.text = @"";
        right.text = @"";
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", (int)(section + 1)];
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    UILabel *left = [cell.contentView viewWithTag:1];
//    UILabel *right = [cell.contentView viewWithTag:2];
//    
//    left.text = @"";
//    right.text = @"";
    
//    ThemeUITableViewCell *cell = [[ThemeUITableViewCell alloc] init];
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d", 9];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *left = [cell.contentView viewWithTag:1];
//    UILabel *right = [cell.contentView viewWithTag:2];
    
    left.text = @"nyomanganteng";
    
    
    [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"longbar"]]];

    return cell;
}

@end
