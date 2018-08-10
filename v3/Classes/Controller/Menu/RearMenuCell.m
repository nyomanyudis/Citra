//
//  RearMenuCell.m
//  Ciptadana
//
//  Created by Reyhan on 10/9/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "RearMenuCell.h"

@interface RearMenuCell()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *lefticon;

@end

@implementation RearMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public

- (void)setTitle:(NSString*)title
{
    self.label.text = title;
}

- (void)setIcon:(UIImage *)icon
{
    self.lefticon.image = icon;
}

@end
