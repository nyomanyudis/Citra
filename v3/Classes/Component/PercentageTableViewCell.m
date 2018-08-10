//
//  PercentageTableViewCell.m
//  Ciptadanav3
//
//  Created by Reyhan on 8/10/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "PercentageTableViewCell.h"

#define padding 8
#define margin 3

@interface PercentageTableViewCell()

@property (assign, nonatomic) NSArray *labels;
@property (assign, nonatomic) NSArray *widths;

@end

@implementation PercentageTableViewCell

- (id)initWithLabels:(NSArray *)labels
{
    CGFloat width = self.superview.frame.size.width - (margin * 2);
    width = width / labels.count;
    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:labels.count];
    for(int n = 0; n < labels.count; n ++)
        [mutable addObject:[NSNumber numberWithFloat:width]];
    
    return [self initWithLabels:labels andWidth:[NSArray arrayWithArray:mutable]];
}

- (id)initWithLabels:(NSArray *)labels andWidth:(NSArray *)widths;
{
    if(self = [super init]) {
        self.labels = labels;
        self.widths = widths;
        
        //[self performSelector:@selector(createAllLabel) withObject:nil afterDelay:.1];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)createLabel:(NSArray *)labels
{
    CGFloat width = self.superview.frame.size.width - (margin * 2);
    width = width / labels.count;
    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:labels.count];
    for(int n = 0; n < labels.count; n ++)
        [mutable addObject:[NSNumber numberWithFloat:width]];
    
    [self createLabel:labels andWidth:[NSArray arrayWithArray:mutable]];
}

- (void)createLabel:(NSArray *)labels andWidth:(NSArray *)widths
{
    self.labels = labels;
    self.widths = widths;
}

#pragma private

- (void)createAllLabel
{
    NSArray *labels = self.labels;
    NSArray *widths = self.widths;
    for(int n = 0; n < labels.count; n ++) {
        UILabel *label = [self createLabelWithLabel:[labels objectAtIndex:n]
                                           andWidth:[(NSNumber *)[widths objectAtIndex:n] floatValue]
                                               andX:0 andY:0];
        [self addSubview:label];
    }

}

- (UILabel *)createLabelWithLabel:(NSString *)string andWidth:(CGFloat)width andX:(CGFloat)x andY:(CGFloat)y
{
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    
    return label;
}

@end
