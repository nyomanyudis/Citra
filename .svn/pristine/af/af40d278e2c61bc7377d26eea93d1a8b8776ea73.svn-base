//
//  UIDropList.h
//  GCDExample
//
//  Created by Reyhan on 9/11/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UIDropListDelegate <NSObject>

@required
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index;

@end

@interface UIDropList : UIButton

@property (nonatomic, assign) id<UIDropListDelegate> dropDelegate;

- (void)arrayList:(NSArray *)list;
- (void)arrayList:(NSArray *)list withTitleCallback:(BOOL)b;
- (void)showRightIcon:(BOOL)b;
- (void)closeDropList;
- (NSInteger)selectedIndex;
- (uint32_t)currActiveIndex;

@end
