//
//  JoinUs.m
//  Ciptadana
//
//  Created by Reyhan on 1/8/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "JoinUs.h"

#import "UIButton+Addons.h"

@interface JoinUs ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation JoinUs

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *url = @"http://ciptadana-securities.com/online-registration-institutional/new";
    NSURL *uri = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:uri];
    [self.webView loadRequest:request];
    
    [self performSelector:@selector(initPrivate) withObject:nil afterDelay:.01];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - private

- (void)initPrivate
{
    UIImage *imageLeft = [UIImage imageNamed:@"left"];
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
    [btn setImage:imageLeft forState:UIControlStateNormal];
    [btn clearBackground];
    [self.backButton setCustomView:btn];
    
    [btn addTarget:self action:@selector(backSelector:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)backSelector:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
