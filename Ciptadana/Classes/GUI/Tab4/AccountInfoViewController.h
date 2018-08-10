//
//  AccountInfoViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/22/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "UIDropList.h"

@interface AccountInfoViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

@property (weak, nonatomic) IBOutlet UIDropList *clientDropList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *zipTF;
@property (weak, nonatomic) IBOutlet UITextField *provinceTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *faxTF;
@property (weak, nonatomic) IBOutlet UITextField *mPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *sidTF;
@property (weak, nonatomic) IBOutlet UITextField *subRekTF;
@property (weak, nonatomic) IBOutlet UITextField *rdiAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *bankTF;
@property (weak, nonatomic) IBOutlet UITextField *rekTF;
@property (weak, nonatomic) IBOutlet UITextField *rdiNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *clientTF;
@property (weak, nonatomic) IBOutlet UITextView *addressTF;

@end
