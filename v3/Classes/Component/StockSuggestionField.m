//
//  StockSuggestionField.m
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "StockSuggestionField.h"

#import "MarketData.h"

@interface StockSuggestionField() <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) UITableView *autoCompleteTableView;
@property (nonatomic, retain) NSMutableArray *autoCompleteArray;
@property (nonatomic, retain) NSArray *autoCompleteFilterArray;

@end

@implementation StockSuggestionField

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
    
    self.autoCompleteArray = [NSMutableArray arrayWithArray:[[MarketData sharedInstance] getStringStockData]];
    
    self.autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 340, 600) style:UITableViewStylePlain];
    
    [[self.autoCompleteTableView layer] setMasksToBounds:NO];
    [[self.autoCompleteTableView layer] setShadowColor:[UIColor blackColor].CGColor];
    [[self.autoCompleteTableView layer] setShadowOffset:CGSizeMake(0.0f, 5.0f)];
    [[self.autoCompleteTableView layer] setShadowOpacity:0.3f];
    
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.spellCheckingType = UITextSpellCheckingTypeNo;
    
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
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    if (isBackSpace == -8) {// is backspace
        textField.text = @"";
    }
    else {
        NSString *passcode = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        self.autoCompleteFilterArray = [self.autoCompleteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"SELF BEGINSWITH %@",[passcode uppercaseString]]];
        
        [self didShowHideTable];
        
        [self.autoCompleteTableView reloadData];
        
        return TRUE;
    }
}

// change cursor position
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    int isBackSpace = strcmp(_char, "\b");
//    if (isBackSpace == -8) // is backspace
//    {
//        // UITextFieldの編集セッション終了後にbackspaceキーを押すと入力内容がクリアされてしまうiOS仕様への対応
//        NSMutableString *str = [NSMutableString stringWithString:textField.text];
//        if ( [str length] > 0) {
//            [str deleteCharactersInRange:range];
//            textField.text = str;
//            [self performSelector:@selector(updateTextFieldCursorPosition:) withObject:@[textField, NSStringFromRange(range)] afterDelay:0.001f];
//        }
//        return NO;
//    }
//    else if (string.length > 0)
//    {
//        // UITextField.secureの編集セッション終了後に文字キーを押すと入力内容がクリアされてしまうiOS仕様への対応
//        NSMutableString *str = [NSMutableString stringWithString:textField.text];
//        [str insertString:string atIndex:range.location];
//        textField.text = str;
//        range = NSMakeRange(range.location + string.length, range.length);
//        [self performSelector:@selector(updateTextFieldCursorPosition:) withObject:@[textField, NSStringFromRange(range)] afterDelay:0.001f];
//        return NO;
//    }
//    return YES;
//}
//
//- (void)updateTextFieldCursorPosition:(NSArray *)params
//{
//    UITextField *tf = (UITextField *)[params objectAtIndex:0];
//    NSRange range = NSRangeFromString([params objectAtIndex:1]);
//    UITextPosition *newPosition = [tf positionFromPosition:tf.beginningOfDocument offset:range.location];
//    UITextRange *newRange = [tf textRangeFromPosition:newPosition toPosition:newPosition];
//    tf.selectedTextRange = newRange;
//    [tf setNeedsLayout];
//}

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
    //self.text = @"";
}

@end
