//
//  TableViewCell.m
//  UUChartView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "TableViewCell.h"
#import "UUChart.h"

@interface TableViewCell ()<UUChartDataSource>
{
    UUChart *chartView;
}
@end

@implementation TableViewCell


- (id)initWithStock:(CGRect)frame
{
    NSLog(@"Nyoman 1");
    self = [super init];
    if(self) {
        if (chartView) {
            [chartView removeFromSuperview];
            chartView = nil;
        }
        
        chartView = [[UUChart alloc]initWithFrame:CGRectMake(10, 10, frame.size.width, frame.size.height)
                                       dataSource:self
                                            style:UUChartStyleLine];
        
        [chartView initView:frame];

    }
    return self;
}


- (UIView *)getView
{
    return chartView.getView;
}

// untuk menambilkan teks di sumbu x
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<num; i++) {
        NSString * str = [NSString stringWithFormat:@"X-%d",i];
        [xTitles addObject:str];
    }
    return xTitles;
}

// untuk menentukkan jumlah teks dalam sumbu x
#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return [self getXTitles:12];
}

// untuk data yang ada di graph
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    NSArray *ary = @[@"22",@"44",@"15",@"40",@"42",@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
    
    return @[ary];
}

#pragma mark - @optional
//颜色数组
// untuk buat color di graphnya
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor green],[UUColor red],[UUColor brown]];
}
//显示数值范围
// range untuk sumbu y
- (CGRange)chartRange:(UUChart *)chart
{
    return CGRangeMake(100, 10);

}

#pragma mark 折线图专享功能

//标记数值区域
// untuk membrikkan abu abu di char untuk range tertentu
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{
    return CGRangeMake(25, 75);
    
//    return CGRangeZero;
}

//判断显示横线条
// untuk menentukan apa garisnya mau vertical atau horizontal, YES untuk horizontal , NO untuk vertical
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
//
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
//    return path.row == 2;
    return YES;
}
@end
