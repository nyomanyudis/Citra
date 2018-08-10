//
//  LoadingSceneCapitalCalendar.m
//  Ciptadana
//
//  Created by Reyhan on 4/13/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "LoadingSceneCapitalCalendar.h"

@interface LoadingSceneCapitalCalendar ()

@end

@implementation LoadingSceneCapitalCalendar

@synthesize buttonLoading;
@synthesize spriteLoading;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(keepChanging)];
    [buttonLoading addTarget:self action:@selector(getDataURL) forControlEvents:UIControlEventTouchUpInside];
    [buttonLoading sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keepChanging
{
    NSArray *imageNames = @[@"sprite1", @"sprite2", @"sprite3",
                            @"sprite4", @"sprite5", @"sprite6",
                            @"sprite7", @"sprite8", @"sprite9"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    self.spriteLoading.animationRepeatCount = 0;
    self.spriteLoading.animationImages = images;
    self.spriteLoading.animationDuration = 0.25*9;
    
    [self.spriteLoading startAnimating];
    
}

- (void) getDataURL {
    NSLog(@"get Data URL");
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
