//
//  ChartViewNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 5/21/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "ChartViewNyoman.h"
#import "TableViewCell.h"

@interface ChartViewNyoman ()

@property (weak, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) TableViewCell *ChartView;

@end

@implementation ChartViewNyoman

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *container2 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.container.frame.size.width, self.container.frame.size.height)];
//    container2.backgroundColor = [UIColor clearColor];
    
//    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 20, 15)];
//    countLabel.text = @"4";
    
//    [container2 addSubview:countLabel];
    
      self.ChartView = [[TableViewCell alloc] initWithStock:self.container.frame];
//      [self.ChartView configUI:self.container.frame];
//    self.container.backgroundColor = [UIColor clearColor];
//    
    [self.container addSubview:[self.ChartView getView]];
//    [self.container addSubview:container2];
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
