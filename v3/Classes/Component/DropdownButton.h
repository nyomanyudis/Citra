//
//  DropdownButton.h
//  Ciptadanav3
//
//  Created by Reyhan on 7/28/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DropdownCallback)(NSInteger index, NSString *string);

@class TableDropdown;

@interface DropdownButton : UIButton

@property (retain, nonatomic) NSArray *items;

- (void)buttonTapped:(id)button;
- (void)setDropdownCallback:(DropdownCallback)callback;
- (NSInteger)selectionIndex;

@end

@interface TableDropdown : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DropdownCallback callback;

- (id)initWithFrame:(DropdownButton *)button;

@end