//
//  DisclaimerViewController.m
//  Ciptadana
//
//  Created by Reyhan on 2/11/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController



- (void)backBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self backTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [_backBarItem setCustomView:backButton];
    
//    NSString* readme = [[NSBundle mainBundle] pathForResource:@"Disclaimer" ofType:@"rtf"];
////    NSString *readme = [NSString  stringWithContentsOfFile:@"Disclaimer" encoding:NSASCIIStringEncoding error:NULL];
//    _textarea.text = readme;
//    _textarea.textColor = [UIColor whiteColor];
    
    NSError *error;
    NSString *strFileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                   pathForResource: @"Disclaimer" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
    if(error) {  //Handle error
        
    }
    
    _textarea.text = strFileContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setTextarea:nil];
    [super viewDidUnload];
}
@end
