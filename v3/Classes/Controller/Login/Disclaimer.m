//
//  Disclaimer.m
//  Ciptadana
//
//  Created by Reyhan on 1/8/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "Disclaimer.h"

#import "UIButton+Addons.h"

@interface Disclaimer ()

@property (weak, nonatomic) IBOutlet UITextView *dislaimerText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation Disclaimer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSError *error;
    NSString *strFileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                   pathForResource: @"Disclaimer" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
    if(!error) {  //Handle error
        self.dislaimerText.text = strFileContent;
    }
    
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
    NSLog(@"Dismis,...");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
