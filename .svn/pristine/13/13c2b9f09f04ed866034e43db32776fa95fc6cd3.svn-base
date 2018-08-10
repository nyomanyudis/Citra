//
//  UITextKeyboard.m
//  UILatihan
//
//  Created by Reyhan on 11/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "UITextKeyboard.h"
#import "UITextField+FocusColor.h"

@interface UITextKeyboard()

@property CGPoint originalPoint;
@property CGSize originalSize;

@end

@implementation UITextKeyboard

- (id)init
{
    self = [super init];
    if (self) {
        [self setupKeyboardListener];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupKeyboardListener];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupKeyboardListener];
    }
    
    return self;
}

- (void)setupKeyboardListener
{
    [self changeFocusColor];
    
    // keyboard listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    self.originalPoint = self.frame.origin;
    self.originalSize = self.frame.size;
}

- (void)keyboardWillShow:(NSNotification *)note
{
    if (self.isFirstResponder && self.isEnabled) {
        CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        uint32_t hiLimit = self.superview.frame.size.height - keyboardSize.height - self.frame.size.height - 6;
        
        CGFloat hiToolbar = self.frame.size.height + self.frame.size.height / 2;
        CGFloat yToolbar = self.superview.frame.size.height - keyboardSize.height - hiToolbar;
        
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.origin.y - 6, self.superview.frame.size.width, hiToolbar)];
        toolbar.alpha = 0;
        toolbar.tag = 1;
        
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *btnImage1 = [UIImage imageNamed:@"close_button"];
        UIImage *btnImage2 = [UIImage imageNamed:@"button_close"];
        [button setImage:btnImage1 forState:UIControlStateNormal];
        [button setImage:btnImage2 forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, btnImage1.size.width, btnImage1.size.height);
        [button addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        toolbar.items = @[itemSpace, itemCancel];
        
        if (self.frame.origin.y > hiLimit) {
            
            [self.superview insertSubview:toolbar belowSubview:self];
            
            [UIView animateWithDuration:.2f
                             animations:^{
                                 
                                 CGRect frame = self.frame;
                                 
                                 frame.origin.y = hiLimit;
                                 frame.origin.x = 5;
                                 
                                 //text width
                                 if(self.frame.origin.x + self.frame.size.width > button.frame.origin.x - 3) {
                                     frame.size.width = self.superview.frame.size.width - button.frame.size.width - 30;
                                 }
                                 self.frame = frame;
                                 
                                 //toolbar pos
                                 //toolbar.frame = CGRectMake(0, yToolbar, self.superview.frame.size.width, hiToolbar);
                                 toolbar.frame = CGRectMake(0, 150, self.superview.frame.size.width, hiToolbar);
                                 toolbar.alpha = 1;
                                 
                             }
                             completion:^(BOOL finished) {
                             }];
            
        }
        else {
            
            [self.superview insertSubview:toolbar belowSubview:self];
            //[self.superview addSubview:toolbar];
            toolbar.frame = CGRectMake(0, self.superview.frame.size.height, self.superview.frame.size.width, hiToolbar);
            
            [UIView animateWithDuration:.2f
                             animations:^{
                                 
                                 //toolbar pos
                                 toolbar.frame = CGRectMake(0, yToolbar, self.superview.frame.size.width, hiToolbar);
                                 toolbar.alpha = 1;
                                 
                             }
                             completion:^(BOOL finished) {
                             }];
        }
    }
    else {
        self.enabled = NO;
    }
}

- (void)cancelButtonClicked
{
    if(self.isFirstResponder && self.isEnabled) {
        self.text = @"";
        [self resignFirstResponder];
    }
}

- (void)keyboardDidShow:(NSNotification *)note
{    
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isFirstResponder && self.isEnabled) {
        
        UIView *view = [self.superview viewWithTag:1];
        
        [UIView animateWithDuration:.2f
                         animations:^{
                             
                             CGRect frame = self.frame;
                             frame.origin = self.originalPoint;
                             frame.size = self.originalSize;
                             
                             self.frame = frame;
                             
                             //toolbar pos
                             if(nil != view) {
                                 //view.frame = CGRectMake(0, self.frame.origin.y - 6, view.frame.size.width, view.frame.size.height);
                                 view.frame = CGRectMake(0, self.superview.frame.size.height, view.frame.size.width, view.frame.size.height);
                                 view.alpha = 0;
                             }
                             
                         }
                         completion:^(BOOL finished) {
                             if(nil != view)
                                 [view removeFromSuperview];
                         }];
    }
    else {
        self.enabled = YES;
    }
}

- (void)keyboardDidHide:(NSNotification *)note
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
}

@end
