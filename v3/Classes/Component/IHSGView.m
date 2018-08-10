//
//  IHSGView.m
//  Ciptadanav3
//
//  Created by Reyhan on 8/1/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "IHSGView.h"

@implementation IHSGView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        
//        CGRect rect = self.superview.frame;
//        self.frame = CGRectMake(0, 0, rect.size.width, 30);
        
//        self = [self initializeSubviews];
    }
    
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    //NSString *nibClass = NSStringFromClass([self class]);
//    if(self.subviews.count > 0) {
//        // loading xib
//        return self;
//    }
//    else {
//        // loading storyboard
//        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
//                                              owner:nil
//                                            options:nil] objectAtIndex:0];
//    }
    
    NSString *nibClass = NSStringFromClass([self class]);
    id me = [[[NSBundle mainBundle] loadNibNamed:nibClass
                                          owner:nil
                                        options:nil] objectAtIndex:0];
    
    ((UIView *) me).backgroundColor = [UIColor clearColor];
    CGRect rect = self.superview.frame;
    ((UIView *) me).frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width, 30);
    
    return me;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark private
- (id)initializeSubviews
{
    NSString *nibClass = NSStringFromClass([self class]);
    id view =   [[[NSBundle mainBundle] loadNibNamed:nibClass owner:self options:nil] objectAtIndex:0];
    
    return view;
}

@end
