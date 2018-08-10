//
//  GroupButton.m
//  Ciptadana
//
//  Created by Reyhan on 5/23/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "GroupButton.h"

@implementation GroupButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor greenColor];
//        [self setFrame:CGRectMake(0, 0, 240, 32)];
        NSLog(@"frame width1 = %f",self.frame.size.width);
        NSLog(@"frame height1 = %f",self.frame.size.height);
    }
    return self;
}



-(void) addButton:(NSArray *)labelButton
{
    NSLog(@"frame width3 = %f",self.frame.size.width);
    NSLog(@"frame height3 = %f",self.frame.size.height);
    for(int i=0;i<[labelButton count];i++){
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width,self.frame.size.height)];
        [button setTitle:[labelButton objectAtIndex:i] forState:UIControlStateNormal];
        
        [self addSubview:button];
    }
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if(self = [super initWithCoder:aDecoder]) {
//        self.backgroundColor = [UIColor clearColor];
//        
//        //        CGRect rect = self.superview.frame;
//        //        self.frame = CGRectMake(0, 0, rect.size.width, 30);
//        
//        //        self = [self initializeSubviews];
//    }
//    
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
