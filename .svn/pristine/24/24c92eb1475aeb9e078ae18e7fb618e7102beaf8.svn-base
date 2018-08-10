//
//  UIDropList.m
//  GCDExample
//
//  Created by Reyhan on 9/11/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "UIDropList.h"
#import "REMenu.h"
#import "ImageResources.h"

@interface UIDropList()

@property (strong, nonatomic) REMenu *menu;
@property (strong, nonatomic) NSArray *array;
@property (assign, nonatomic) NSInteger currIndex;
@property (assign, nonatomic) uint32_t activeIndex;

- (void)initMenu;
- (void)uiInit;

@end


//static UIImage *normalImage;
//static UIImage *highligtedImage;
static UIImage *icon;



@implementation UIDropList
{
    BOOL touched;
    BOOL showIcon;
    CGRect menuRect;
    CGRect originRect;
    
    BOOL moved;
}

@synthesize dropDelegate;
@synthesize menu, currIndex, activeIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self uiInit];
        [self initMenu];
        currIndex = 0;
        activeIndex = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    if (self) {
        [self uiInit];
        [self initMenu];
        currIndex = 0;
        activeIndex = 0;
    }
    
    return self;
}


- (void)showRightIcon:(BOOL)b
{
    showIcon = b;
    
    if(!b) {
        [self setImage:nil forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateHighlighted];
        
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width - icon.size.width - 5, 0, 0)];
        //[self setTitleEdgeInsets:UIEdgeInsetsMake(0, -1*icon.size.width + 5, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }
}

- (NSInteger)selectedIndex
{
    return currIndex;
}

- (uint32_t)currActiveIndex
{
    return activeIndex;
}

- (void)arrayList:(NSArray *)list
{
    [self arrayList:list withTitleCallback:YES];
}

- (void)arrayList:(NSArray *)list withTitleCallback:(BOOL)b
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    int n = 0;
    for (NSString *s in list) {
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:[NSString stringWithFormat:@" %@", s]
                                                     subtitle:nil
                                                        image:nil
                                             highlightedImage:nil
                                                       action:^(REMenuItem *item) {
                                                           
                                                           if(b) {
                                                               [self setTitle:item.title forState:UIControlStateNormal];
                                                           }
                                                           
                                                           activeIndex = n;
                                                           
                                                           if(nil != dropDelegate)
                                                               [dropDelegate onDripClicked:self title:item.title index:n];
                                                           
                                                           currIndex = n;
                                                       }];
        n ++;
        [mutableArray addObject:item];
    }
    
    self.array = nil;
    self.array = [NSArray arrayWithArray:mutableArray];//[[NSArray alloc] initWithArray:mutableArray];
//    self.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    self.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
    self.
    menu.items = self.array;
    
    menuRect = self.frame;
    menuRect.origin.y += menuRect.size.height;
    menuRect.size.height = (menu.items.count + 1) * 25;
    menuRect.size.width = self.frame.size.width * .95;
    menuRect.origin.x = self.frame.origin.x + (self.frame.size.width * .05) / 2;
    
}

- (void)closeDropList
{
    if (menu.isOpen)
        [menu close];
}

- (void)uiInit
{
    touched = NO;
    showIcon = YES;
    moved = NO;
        
    if(nil == icon)
        icon = [UIImage imageNamed:@"REArrow"];
    
    [self setBackgroundImage:[ImageResources imageBlackButton] forState:UIControlStateNormal];
    [self setBackgroundImage:[ImageResources imageBlackButtonHighlighted] forState:UIControlStateHighlighted];
    
    if(showIcon) {
        [self setImage:icon forState:UIControlStateNormal];
        [self setImage:icon forState:UIControlStateHighlighted];
        
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.width - icon.size.width - 5, 0, 0)];
        //[self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -1*icon.size.width + 5, 0, 0)];
    }
    else {
        
    }
    
    //[self.titleLabel setFont:[UIFont fontWithName:@"MarkerFelt-Thin" size:15.0]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [self addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initMenu
{
    
    currIndex = 0;
    activeIndex = 0;
    
    REMenuItem *item = [[REMenuItem alloc] initWithTitle:@""
                                                 subtitle:nil
                                                    image:nil
                                         highlightedImage:nil
                                                   action:^(REMenuItem *item) {
                                                       //NSLog(@"Item: %@", item);
                                                   }];
    
    menu = [[REMenu alloc] initWithItems:@[item]];

    menu.cornerRadius = 4;
    menu.shadowRadius = 4;
    menu.animationDuration = .2;
    menu.shadowColor = [UIColor blackColor];
    menu.shadowOffset = CGSizeMake(0, 1);
    menu.shadowOpacity = 1;
    menu.imageOffset = CGSizeMake(5, -1);
    menu.waitUntilAnimationIsComplete = NO;
    menu.bounce = YES;
    menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    menu.itemHeight = 25;
    //menu.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
    menu.font = [UIFont systemFontOfSize:15.0];
    menu.textAlignment = NSTextAlignmentLeft;
    menu.textColor =[UIColor whiteColor];
    
    originRect = self.frame;
    
    menuRect = self.frame;
    menuRect.origin.y += menuRect.size.height;
    menuRect.size.height = (menu.items.count + 1) * 25;
    menuRect.size.width = self.frame.size.width * .95;
    //frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
    menuRect.origin.x = self.frame.origin.x + (self.frame.size.width * .05) / 2;
    
}

- (void)doAction
{
    touched = NO;
    
    if (menu.isOpen)
        return [menu close];
    
    [menu showFromRect:menuRect inView:[self superview]];
}

- (void)onTouchDown:(id)sender
{
    touched = YES;
}

- (void)onTouchUpInside:(id)sender
{
    if(touched)
        [self doAction];
}

- (void)onTouchUpOutside:(id)sender
{
    NSLog(@"touch outside");
}

CGRect screenFrameForCurrentOrientation()
{
    //return [self screenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    return screenFrameForOrientation([UIApplication sharedApplication].statusBarOrientation);
}

CGRect screenFrameForOrientation(UIInterfaceOrientation orientation)
{
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden){
        CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}


@end
