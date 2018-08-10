//
//  UITextField+Addons.h
//  Ciptadana
//
//  Created by Reyhan on 9/26/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^MyClassCallback)(id something);

@interface UITextField (Addons)

//@property (nonatomic, readwrite, copy) MyClassCallback callback;
//- (void)doSomething;
//- (void)cekCallback:(MyClassCallback)callback;

- (void)initRightButtonKeyboardToolbar:(NSString *)label target:(id)target selector:(SEL)selector;
- (void)initLeftButtonKeyboardToolbar:(NSString *)label target:(id)target selector:(SEL)selector;
- (void)initLeftRightButtonKeyboardToolbar:(NSString *)labelLeft labelRight:(NSString *)labelRight target:(id)target selectorLeft:(SEL)selectorLeft selectorRight:(SEL)selectorRight;
- (void)initPasswordField;
- (void)padding;
- (void)thousandNumeric;


@end