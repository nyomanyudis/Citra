//
//  LoggerViewController.m
//  Ciptadana
//
//  Created by Reyhan on 1/8/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "LoggerViewController.h"
#import "Logger.h"

#import "JSONKit.h"

@interface LoggerViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@end

@implementation LoggerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self backTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [_backBarItem setCustomView:backButton];
    
    if(nil != getArrayLog()) {
        for (NSObject *obj in getArrayLog()) {
            _textArea.text = [NSString stringWithFormat:@"%@\n%@", _textArea.text, obj];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setTextArea:nil];
    [super viewDidUnload];
}
@end
