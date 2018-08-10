//
//  JoinUsTree.m
//  Ciptadana
//
//  Created by Reyhan on 3/19/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "JoinUsTree.h"

#import "UIButton+Addons.h"

#define CELL @[@"Nasabah Individu", @"Nasabah Institutional", @"Nasabah Terdaftar"]

@interface JoinUsTree() <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation JoinUsTree

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self performSelector:@selector(initPrivate) withObject:nil afterDelay:.01];
    [self performSelector:@selector(initPrivate)];
}

#pragma mark - private

- (void)initPrivate
{
    self.table.dataSource = self;
    UIImage *imageLeft = [UIImage imageNamed:@"left"];
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
    [btn setImage:imageLeft forState:UIControlStateNormal];
    [btn clearBackground];
    [self.backButton setCustomView:btn];
    
    [btn addTarget:self action:@selector(backSelector:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)backSelector:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *left = [cell.contentView viewWithTag:1];
    left.text = CELL[indexPath.row];
    
    return cell;
}

@end
