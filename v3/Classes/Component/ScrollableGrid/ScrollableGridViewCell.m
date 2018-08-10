//
//  ScrollableGridCellView.m
//  Ciptadanav3
//
//  Created by Reyhan on 9/19/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "ScrollableGridViewCell.h"


@interface ScrollableGridViewCell ()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation ScrollableGridViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fixedLabelInit.frame = self.fixedView.bounds;
    self.scrollableAreaViewInit.frame = self.scrolledContentView.bounds;
}

- (UILabel *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        self.fixedLabel = [self createLabel:CGRectMake(5, 0, 70, 28) withLabel:@" LEFT"];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
        self.fixedLabel.backgroundColor = [UIColor clearColor];
        [self.fixedView addSubview:self.fixedLabel];
    }
    return self.fixedLabel;
}

- (UIView*)scrollableAreaViewInit
{
    if (self.scrollableAreaView == nil) {
        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
        
        CGFloat x = 0;// (x * 60) + (3 * x ++)
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-1" andTag:1]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-2" andTag:2]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-3" andTag:3]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-4" andTag:4]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-5" andTag:5]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-6" andTag:6]];x++;
//        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), (36-28)/2, 60, 28) withLabel:@"Label-7" andTag:7]];
        
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-1" andTag:1]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-2" andTag:2]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-3" andTag:3]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-4" andTag:4]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-5" andTag:5]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-6" andTag:6]];x++;
        [self.scrollableAreaView addSubview:[self createLabel:CGRectMake((x * 60) + (3 * x), 0, 70, 32) withLabel:@"Label-7" andTag:7]];
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
    }
    return self.scrollableAreaView;
}

- (UILabel*)createLabel:(CGRect)rect withLabel:(NSString*)label
{
    return [self createLabel:rect withLabel:label andTag:0];
}

- (UILabel*)createLabel:(CGRect)rect withLabel:(NSString*)label andTag:(NSInteger)tag
{
    UILabel* uilabel = [[UILabel alloc] initWithFrame:rect];
    uilabel.text = label;
    uilabel.tag = tag;
    return uilabel;
}

@end
