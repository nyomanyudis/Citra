//
//  CalendarDetailViewController.h
//  Ciptadana
//
//  Created by Reyhan on 2/5/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"

@interface CalendarDetailViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil array:(NSArray*)array;
- (id)initWithArray:(NSArray*)array;

@end


@interface CalendarDetailCell : UITableViewCell

@property UILabel *typeLabel;
@property UILabel *newsLabel;

@end
