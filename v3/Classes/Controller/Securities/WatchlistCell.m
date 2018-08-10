//
//  WatchlistCell.m
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "WatchlistCell.h"

#import "Util.h"

@implementation WatchlistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.stock.font = [FONT_TITLE_BOLD_LABEL fontWithSize:14];
    self.price.font = [FONT_TITLE_LABEL_CELL fontWithSize:14];
    self.change.font = [FONT_TITLE_LABEL_CELL fontWithSize:14];
    self.changepct.font = [FONT_TITLE_LABEL_CELL fontWithSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didTransitionToState:(UITableViewCellStateMask)state
{
    [super didTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask)
    {
        
        UIView *deleteButton = [self deleteButtonSubview:self];
        deleteButton.backgroundColor = [UIColor magentaColor];
        if (deleteButton)
        {
            CGRect frame = deleteButton.frame;
            frame.origin.y = 4;
            frame.size.height = frame.size.height-8;
            /*
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
             {
             
             frame.size.height = 62; //vikram singh 2/1/2015
             frame.size.width = 80;
             
             }
             else
             {
             frame.size.height = 52; //vikram singh 2/1/2015
             frame.size.width = 80;
             
             }
             */
            deleteButton.frame = frame;
            
        }
    }
}

- (UIView *)deleteButtonSubview:(UIView *)view
{
    if ([NSStringFromClass([view class]) rangeOfString:@"Delete"].location != NSNotFound) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *deleteButton = [self deleteButtonSubview:subview];
        CGRect rect = deleteButton.frame;
        rect.size.width = 800.f;
        [deleteButton setBackgroundColor:[UIColor yellowColor]];
        if (deleteButton) {
            
            return deleteButton;
        }
    }
    return nil;
}

@end
