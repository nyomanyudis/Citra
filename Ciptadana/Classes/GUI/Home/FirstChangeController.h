//
//  FirstChangeController.h
//  Ciptadana
//
//  Created by Reyhan on 6/27/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstChangeController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItemButton;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswdTxt;
@property (weak, nonatomic) IBOutlet UITextField *baruPasswrdTxt;
@property (weak, nonatomic) IBOutlet UITextField *baru2PasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *oldPinTxt;
@property (weak, nonatomic) IBOutlet UITextField *baruPinTxt;
@property (weak, nonatomic) IBOutlet UITextField *baru2PinTxt;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *transparetView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *animator;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *panel;

@end
