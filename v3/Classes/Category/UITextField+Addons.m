//
//  UITextField+Addons.m
//  Ciptadana
//
//  Created by Reyhan on 9/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "UITextField+Addons.h"

#import "NSString+Addons.h"
#import "Util.h"

#define HIDE [UIImage imageNamed:@"hide"]
#define SHOW [UIImage imageNamed:@"show"]

#define BLUEBOX [UIImage imageNamed:@"bluebox"]
#define BLACKBOX [UIImage imageNamed:@"blackbox"]

@implementation UITextField (Addons)

//@dynamic callback;
- (void)initRightButtonKeyboardToolbar:(NSString *)label target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0 , 0, 80, 40);
    [button setTitle:label forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    //[button setBackgroundImage:BLUEBOX forState:UIControlStateNormal];
    //[button setBackgroundImage:BLACKBOX forState:UIControlStateHighlighted];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:target action:selector];
    
    [rightBarButton setCustomView:button];
    
    keyboardToolbar.items = @[flexBarButton, rightBarButton];
    self.inputAccessoryView = keyboardToolbar;
}

- (void)initLeftButtonKeyboardToolbar:(NSString *)label target:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0 , 0, 80, 40);
    [button setTitle:label forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:target action:selector];
    
    [leftBarButton setCustomView:button];
    
    keyboardToolbar.items = @[leftBarButton, flexBarButton];
    self.inputAccessoryView = keyboardToolbar;
}



- (void)initLeftRightButtonKeyboardToolbar:(NSString *)labelLeft labelRight:(NSString *)labelRight target:(id)target selectorLeft:(SEL)selectorLeft selectorRight:(SEL)selectorRight
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0 , 0, 80, 40);
    [button1 setTitle:labelLeft forState:UIControlStateNormal];
    [button1 addTarget:target action:selectorLeft forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0 , 0, 80, 40);
    [button2 setTitle:labelRight forState:UIControlStateNormal];
    [button2 addTarget:target action:selectorRight forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:target action:selectorLeft];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:target action:selectorRight];
    
    [leftBarButton setCustomView:button1];
    [rightBarButton setCustomView:button2];
    
    keyboardToolbar.items = @[leftBarButton, flexBarButton, rightBarButton];
    self.inputAccessoryView = keyboardToolbar;
}

//- (void)cekCallback:(MyClassCallback)callback
//{
//    self.callback =callback;
//}
//
//- (void)doSomething {
//    if (self.callback != nil) {
//        self.callback(@"SOMETHING");
//    }
//}

- (void)initPasswordField
{
//    CGRect frame = CGRectMake(0, 0, HIDE.size.width+2, HIDE.size.height + 2);
//    UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [eyeButton setImage:HIDE forState:UIControlStateNormal];
//    [eyeButton setFrame:frame];
//    [eyeButton addTarget:self action:@selector(eyeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    eyeButton.tag = 0;
//    
//    
//    self.rightViewMode = UITextFieldViewModeAlways;
//    [self setRightView:eyeButton];
//    [eyeButton setBackgroundColor:[UIColor clearColor]];

}

- (void)padding
{
    UIView *pad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.leftView = pad;
    self.rightView = pad;
}


- (void)thousandNumeric
{
    [self addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - private

- (void)eyeButtonClicked
{   UIButton *eyeButton = (UIButton *)self.rightView;
    eyeButton.tag = eyeButton.tag == 0 ? 1 : 0;
    [eyeButton setImage:(eyeButton.tag == 0 ? HIDE : SHOW ) forState:UIControlStateNormal];
 
    [self setTextColor:COLOR_TITLE_DEFAULT_TEXTFIELD];
    [self setFont:FONT_TITLE_TEXTFIELD];
    
    [self setSecureTextEntry:(eyeButton.tag == 0 ? YES : NO)];
    
}

- (void)textFieldDidChange:(id)sender
{
    NSLog(@"text field did change: %@", self.text);
    NSString *text = [self.text replacingString:@"," withString:@"."];
    self.text = [NSString localizedStringWithFormat:@"%@", text];
}

@end
