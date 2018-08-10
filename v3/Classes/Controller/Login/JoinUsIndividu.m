//
//  JoinUsIndividu.m
//  Ciptadana
//
//  Created by Reyhan on 3/19/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "JoinUsIndividu.h"

#import "UIButton+Addons.h"

@interface JoinUsIndividu()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation JoinUsIndividu

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self performSelector:@selector(initPrivate) withObject:nil afterDelay:.01];
    [self performSelector:@selector(initPrivate)];
}

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
