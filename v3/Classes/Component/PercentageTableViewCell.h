//
//  PercentageTableViewCell.h
//  Ciptadanav3
//
//  Created by Reyhan on 8/10/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeUITableViewCell.h"

@interface PercentageTableViewCell : ThemeUITableViewCell

- (id)initWithLabels:(NSArray *)labels;
- (id)initWithLabels:(NSArray *)labels andWidth:(NSArray *)widths;

- (void)createLabel:(NSArray *)labels;
- (void)createLabel:(NSArray *)labels andWidth:(NSArray *)widths;

@end
