//
//  AbstractViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/26/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.pb.h"
#import "AgentFeed.h"

@interface AbstractViewController : UIViewController

@property (assign, nonatomic) float ihsgPrice;
@property (assign, nonatomic) float ihsgChg;
@property (assign, nonatomic) float ihsgChgp;

//- (void)resubscribe;
//- (void)unsubscribeIhsg;
- (UIButton *)backTabButton;
- (UIButton *)homeTabButton;

- (void)updateIndicesIHSG:(NSArray *)arrayIndices;

- (void)setPreviouseController:(UIViewController *)ctrl;
- (UIViewController *)previouseController;

- (void)tapGestureRecognizer;


UILabel* labelOnTable(CGRect frame);
UILabel* labelOnTableWithLabel(NSString *label, CGRect frame);

@end
