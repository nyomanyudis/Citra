//
//  NewsViewController.h
//  Ciptadana
//
//  Created by Reyhan on 1/3/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"

@interface NewsViewController : AbstractViewController

- (id)initWithNews:(NSString*)news;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *iconBarItem;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@end
