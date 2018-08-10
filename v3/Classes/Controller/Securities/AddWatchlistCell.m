//
//  AddWatchlistCell.m
//  Ciptadana
//
//  Created by Reyhan on 10/17/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "AddWatchlistCell.h"

#import "Util.h"

@implementation AddWatchlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stock.text = @"";
    self.name.text = @"";
    
    self.stock.font = [FONT_TITLE_LABEL_CELL fontWithSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
