//
//  ContactUs.m
//  Ciptadana
//
//  Created by Reyhan on 1/8/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "ContactUs.h"

#import "UIButton+Addons.h"

@interface ContactUs () <UIWebViewDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UILabel *ciptadana;

@end

@implementation ContactUs

- (void)viewDidLoad {
    NSLog(@"Sequence Contact 1");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSString *url = @"http://ciptadana-securities.com/about#profile";
//    NSURL *uri = [NSURL URLWithString:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:uri];
//    [self.webView loadRequest:request];
    
    [self performSelector:@selector(initPrivate) withObject:nil afterDelay:.0f];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Sequence Contact 2");
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

#pragma mark - protected

- (IBAction)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC
{
    NSLog(@"Sequence Contact 3");
}

#pragma mark - private

- (void)initPrivate
{
//    UIImage *imageLeft = [UIImage imageNamed:@"left"];
//    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
//    [btn setImage:imageLeft forState:UIControlStateNormal];
//    [btn clearBackground];
//    [self.backButton setCustomView:btn];
//    
//    [btn addTarget:self action:@selector(backSelector:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"Sequence Contact 4");
    self.ciptadana.font = [UIFont fontWithName:self.ciptadana.font.fontName size:self.ciptadana.font.pointSize + 4];
}

- (IBAction)backSelector:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Sequence Contact 5");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Sequence Contact 6");
}

@end
