//
//  UITextField+FocusColor.m
//  UILatihan
//
//  Created by Reyhan on 11/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"

#import "UITextField+FocusColor.h"


@implementation UITextField (FocusColor)


- (UITextField*)changeFocusColor
{
    //textField1.layer.borderColor = (__bridge CGColorRef)([UIColor orangeColor]);
    //self.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 5.0f;
    self.clipsToBounds = YES;
    
    // uitextfield listener
    [self addTarget:self action:@selector(textFieldListenerBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textFieldListenerEnd:) forControlEvents:UIControlEventEditingDidEnd];
    [self addTarget:self action:@selector(textFieldListenerEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    return self;
}

#pragma mark
#pragma UITextField listener
- (void)textFieldListenerBegin:(UITextField*)textField
{
    self.layer.borderColor = [[UIColor blueColor] CGColor];
    self.layer.borderWidth = 1.5f;
}

- (void)textFieldListenerEnd:(UITextField*)textField
{
    self.layer.borderColor = [[UIColor grayColor] CGColor];
    self.layer.borderWidth = 0.5f;
}

- (void)textFieldListenerEndOnExit:(UITextField*)textField
{
    
}

#pragma mark
#pragma keyboard listener
- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:.2f
                     animations:^{
                         
                         CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         CGRect frame = self.frame;
                         
                         frame.origin.y = keyboardSize.height - 5;
                         frame.origin.x = 5;
                         
                         self.frame = frame;
                         
                     }
                     completion:^(BOOL finished){
                     }];
    
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
}

- (void)keyboardWillHide:(NSNotification *)note
{
//    [UIView animateWithDuration:.2f
//                     animations:^{
//                         
//                         CGRect frame = self.frame;
//                         //frame.origin = self.originalPoint;
//                         
//                         self.frame = frame;
//                         
//                     }
//                     completion:^(BOOL finished){
//                     }];
}

- (void)keyboardDidHide:(NSNotification *)note
{
    
}

@end
