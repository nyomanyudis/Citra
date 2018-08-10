//
//  ShortCutMenuView.m
//  Ciptadana
//
//  Created by Reyhan on 6/22/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "ShortCutMenuView.h"
#import "GrandController.h"

#define arrowgreen [UIImage imageNamed:@"arrowgreen"]
#define menu [NSMutableArray arrayWithObjects:@"Running Trade", @"Stock Watch", @"My Watch List", @"Net B/S By Stock", @"Regional Summary", @"Buy", @"Sell",nil]

@interface  ShortCutMenuView()

@end

@implementation ShortCutMenuView

- (id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        CGFloat btnFrameX = 0.0;
        CGFloat Width = 100.0;
        CGFloat Height = 25.0;
        UILabel *button;
        for (NSString *text in menu) {
        
            
            button = [[UILabel alloc]initWithFrame:CGRectMake(btnFrameX, 0, Width, Height)];
            button.text = text;
            button.font = [UIFont fontWithName:@"Rajdhani-Bold" size:10];
            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgnormal"]];
        
            button.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonClicked:)];
            [button addGestureRecognizer:tapGesture];
            button.textAlignment = NSTextAlignmentCenter;
        //        [tapGesture release];
        //        button.frame = CGRectMake(btnFrameX, 0, Width, Height);
        
        
            [self addSubview:button];
        
        btnFrameX = btnFrameX + Width ;
    }
    
    CGSize contentSize = self.frame.size;
    contentSize.width = btnFrameX ;
    contentSize.height = Height;
    self.contentSize = contentSize;
    
    self.bounces = NO;
    self.scrollsToTop = NO;
    }
    
    return self;
}

-(void) setUpScrollViewMenu
{
    
    
    
    
}

- (void) buttonClicked: (id)button
{
    NSString *storyBoard = @"";
    
    UIGestureRecognizer *rec = (UIGestureRecognizer *)button;
    id hitLabel = [self hitTest:[rec locationInView:self] withEvent:UIEventTypeTouches];
    if ([hitLabel isKindOfClass:[UILabel class]]) {
        NSString *label = ((UILabel *)hitLabel).text;
        if([label isEqualToString: @"Running Trade"]){
            storyBoard = @"runningtradeIdentity";
        }
        else if([label isEqualToString: @"Stock Watch"]){
            storyBoard = @"stockwatchIdentity";
        }
        else if([label isEqualToString: @"Net B/S By Stock"]){
            storyBoard = @"netStockIdentity";
        }
        else if([label isEqualToString: @"Regional Summary"]){
            storyBoard = @"regionalSummaryIdentity";
        }
        else if([label isEqualToString: @"My Watch List"]){
            storyBoard = @"watchlistIdentity";
        }
        else if([label isEqualToString: @"Buy"]){
            storyBoard = @"buyStockIdentity";
        }
        else if([label isEqualToString: @"Sell"]){
            storyBoard = @"sellStockIdentity";
        }
        
    }

    
//    SWRevealViewController *revealController = self.revealViewController;
//    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Citra" bundle:nil];
//    GrandController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:storyBoard];
//    if(vc)
//        // Pass any objects to the view controller here, like...
//        [revealController pushFrontViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
