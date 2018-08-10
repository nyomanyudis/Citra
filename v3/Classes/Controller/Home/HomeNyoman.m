//
//  HomeNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 6/22/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "HomeNyoman.h"

@interface HomeNyoman ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation HomeNyoman

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // swipe menu
//    if(self.revealViewController) {
//        [self.sidebarButton setTarget:self.revealViewController];
//        [self.sidebarButton setAction:@selector(revealToggle:)];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }

    // Do any additional setup after loading the view.
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

@end
