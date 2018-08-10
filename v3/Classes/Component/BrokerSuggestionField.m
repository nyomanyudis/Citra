//
//  BrokerSuggestionField.m
//  Ciptadana
//
//  Created by Reyhan on 10/24/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "BrokerSuggestionField.h"

#import "MarketData.h"

@interface BrokerSuggestionField() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *autoCompleteTableView;
@property (nonatomic, retain) NSMutableArray *autoCompleteArray;
@property (nonatomic, retain) NSArray *autoCompleteFilterArray;

@end

@implementation BrokerSuggestionField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)]];
    [self setRightView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)]];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setRightViewMode:UITextFieldViewModeAlways];
    
    self.autoCompleteArray = [NSMutableArray arrayWithArray:[[MarketData sharedInstance] getStringBrokerData]];
    
    self.autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 340, 600) style:UITableViewStylePlain];
    
    [[self.autoCompleteTableView layer] setMasksToBounds:NO];
    [[self.autoCompleteTableView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.autoCompleteTableView layer] setShadowOffset:CGSizeMake(0.0f, 5.0f)];
    [[self.autoCompleteTableView layer] setShadowOpacity:0.3f];
    
    self.delegate = self;
    self.autoCompleteTableView.delegate = self;
    self.autoCompleteTableView.dataSource = self;
    
}

#pragma mark - private

- (void)didShowHideTable
{
    CGRect rect = self.autoCompleteTableView.frame;
    if ([self.autoCompleteFilterArray count]==0) {
        rect.origin.y = 0;
        self.autoCompleteTableView.frame = rect;
        [self.autoCompleteTableView removeFromSuperview];
    }else if(rect.origin.y <= 0){
        rect.origin.y = self.frame.origin.y + 5 + self.frame.size.height;
        rect.origin.x = self.frame.origin.x;
        rect.size.width = self.frame.size.width;
        self.autoCompleteTableView.frame = rect;
        [self.superview addSubview:self.autoCompleteTableView];
    }
}

#pragma mark - UITextField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *passcode = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.autoCompleteFilterArray = [self.autoCompleteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"SELF BEGINSWITH %@",[passcode uppercaseString]]];
    
    [self didShowHideTable];
    
    [self.autoCompleteTableView reloadData];
    
    return TRUE;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.autoCompleteFilterArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.autoCompleteFilterArray objectAtIndex:indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    
    //UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 20)];/// change size as you need.
    UIView* separatorLineView = [[UIView alloc] initWithFrame:[cell bounds]];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor clearColor];// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.text = cell.textLabel.text;
    
    self.autoCompleteFilterArray = nil;
    self.autoCompleteFilterArray = [NSArray array];
    [self.autoCompleteTableView reloadData];
    [self didShowHideTable];
    
    if(self.callback) {
        self.callback(self.text);
    }
    self.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.callback)
        self.callback(textField.text.uppercaseString);
    return YES;
}

@end
