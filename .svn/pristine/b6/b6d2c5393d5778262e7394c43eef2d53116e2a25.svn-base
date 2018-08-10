//
//  WebControllerViewController.m
//  Ciptadana
//
//  Created by Reyhan on 6/24/16.
//  Copyright © 2016 Reyhan. All rights reserved.
//

#import "WebControllerViewController.h"
#import "ImageResources.h"

@interface WebControllerViewController ()

@property NSURL *uri;
@property (strong, nonatomic) NSString *webTitle;

@end

@implementation WebControllerViewController

@synthesize backBarItem, titleBarItem, webview;
@synthesize uri, webTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title uri:(NSString *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        webTitle = title;
        uri = [NSURL URLWithString:url];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleBarItem.title = webTitle;
    
    UIButton *backButton = [self backTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:uri];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma MARK
#pragma PRIVATE
- (void)backBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

- (UIButton *)backTabButton
{
    UIImage *image = [ImageResources imageBack];
    
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15, image.size.height + 5)];
    buttonAction.frame = CGRectMake(0, 0, image.size.width + 15, image.size.height + 5);
    
    [buttonAction setImage:image forState:UIControlStateNormal];
    [buttonAction setImage:image forState:UIControlStateHighlighted];
    
    
    return buttonAction;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
