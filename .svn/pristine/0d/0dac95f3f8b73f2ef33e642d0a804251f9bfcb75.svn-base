//
//  AutocompletionTableView.m
//
//  Created by Gushin Arseniy on 11.03.12.
//  Copyright (c) 2012 Arseniy Gushin. All rights reserved.
//

#import "AutocompletionTableView.h"
#import  "QuartzCore/QuartzCore.h"

#define tableheight 135

@interface AutocompletionTableView () 
@property (nonatomic, strong) NSArray *suggestionOptions; // of selected NSStrings 
@property (nonatomic, strong) UITextField *textField; // will set automatically as user enters text
@property (nonatomic, strong) UIFont *cellLabelFont; // will copy style from assigned textfield
@end

@implementation AutocompletionTableView

@synthesize suggestionsDictionary = _suggestionsDictionary;
@synthesize suggestionOptions = _suggestionOptions;
@synthesize textField = _textField;
@synthesize cellLabelFont = _cellLabelFont;
@synthesize options = _options;

#pragma mark - Initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *)parentViewController withOptions:(NSDictionary *)options
{
    return [self initWithTextField:textField yPos:textField.frame.origin.y+textField.frame.size.height inViewController:parentViewController withOptions:options];
}

- (UITableView *)initWithTextField:(UITextField *)textField yPos:(CGFloat)y inViewController:(UIViewController *)parentViewController withOptions:(NSDictionary *)options
{
    //set the options first
    self.options = options;
    
    // frame must align to the textfield 
    CGRect frame = CGRectMake(textField.frame.origin.x + 5, y, textField.frame.size.width - 10, tableheight);
//
//    NSLog(@"super view height = %.2f", textField.superview.frame.size.height);
//    
//    NSLog(@"pos y = %.2f", frame.origin.y);
//    
//    if (frame.origin.y + tableheight + 3 > textField.superview.frame.size.height) {
//        frame.origin.y = textField.frame.origin.y - tableheight;
//    }
    
    // save the font info to reuse in cells
    self.cellLabelFont = textField.font;
    
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    self.separatorColor = [UIColor lightGrayColor];
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = .8f;
    self.rowHeight = 30;
    
    // turn off standard correction
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // to get rid of "extra empty cell" on the bottom
    // when there's only one cell in the table
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.width, 1)]; 
    v.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:v];
    self.hidden = YES;  
    [parentViewController.view addSubview:self];

    return self;
}

#pragma mark - Logic staff
- (BOOL) substringIsInDictionary:(NSString *)subString
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSRange range;
    
    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:suggestionsFor:)]) {
        self.suggestionsDictionary = [_autoCompleteDelegate autoCompletion:self suggestionsFor:subString];
    }
    
    for (NSString *tmpString in self.suggestionsDictionary)
    {
        range = ([[self.options valueForKey:ACOCaseSensitive] isEqualToNumber:[NSNumber numberWithInt:1]]) ? [tmpString rangeOfString:subString] : [tmpString rangeOfString:subString options:NSCaseInsensitiveSearch];
        //if (range.location != NSNotFound) [tmpArray addObject:tmpString];
        if (range.location == 0) [tmpArray addObject:tmpString];
    }
    if ([tmpArray count]>0)
    {
        self.suggestionOptions = tmpArray;
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestionOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(167/255.0) green:(152/255.0) blue:(101/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
    }
    
    if ([self.options valueForKey:ACOUseSourceFont]) 
    {
        cell.textLabel.font = [self.options valueForKey:ACOUseSourceFont];
    } else 
    {
        cell.textLabel.font = self.cellLabelFont;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.text = [self.suggestionOptions objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textField setText:[self.suggestionOptions objectAtIndex:indexPath.row]];
    [self.textField resignFirstResponder];
    
    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:didSelectAutoCompleteSuggestionWithIndex:)]) {
        [_autoCompleteDelegate autoCompletion:self didSelectAutoCompleteSuggestionWithIndex:indexPath.row];
    }
    
    [self hideOptionsView];
}

#pragma mark - UITextField delegate
- (void)textFieldValueChanged:(UITextField *)textField
{
    self.textField = textField;
    NSString *curString = textField.text;
    
    if (![curString length])
    {
        [self hideOptionsView];
        return;
    } else if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        } else [self hideOptionsView];
}

#pragma mark - Options view control
- (void)showOptionsView
{
    self.hidden = NO;
}

- (void) hideOptionsView
{
    self.hidden = YES;
}

@end
