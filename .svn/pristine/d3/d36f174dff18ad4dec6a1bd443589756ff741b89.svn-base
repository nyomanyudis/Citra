//
//  NewsViewController.m
//  Ciptadana
//
//  Created by Reyhan on 1/3/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "NewsViewController.h"
#import "ImageResources.h"

@interface NewsViewController ()

@property NSString *stringNews;

@end

@implementation NewsViewController

@synthesize backBarItem, iconBarItem;
@synthesize textArea;

- (id)initWithNews:(NSString *)news
{
    self = [super initWithNibName:@"NewsViewController" bundle:[NSBundle mainBundle]];

    if(self) {
        _stringNews = news;
    }
    
    return self;
}

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
    
    [backBarItem setCustomView:backButton];
    
    UIImage *buttonImage = [ImageResources imageCiptadana];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [iconBarItem setCustomView:button];

    
    if(nil != _stringNews) {
        NSArray *parse = [_stringNews componentsSeparatedByString:@"|"];
        
        NSString *title = [parse objectAtIndex:0];
        //textArea.text = [NSString stringWithFormat:@"%@\n\n", [parse objectAtIndex:0]];
        
        NSArray *parse2 = [[parse objectAtIndex:1] componentsSeparatedByString:@"//"];
        
        NSString *news = @"";
        for(NSString *s in parse2) {
            news = [NSString stringWithFormat:@"%@\n%@", news, s];
        }
        
        textArea.text = [NSString stringWithFormat:@"%@\n\n%@\n\n\n", title, news];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setBackBarItem:nil];
    [self setIconBarItem:nil];
    [self setTextArea:nil];
    [super viewDidUnload];
}
@end
