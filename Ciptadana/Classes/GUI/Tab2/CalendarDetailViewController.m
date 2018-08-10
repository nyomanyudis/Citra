//
//  CalendarDetailViewController.m
//  Ciptadana
//
//  Created by Reyhan on 2/5/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import "ImageResources.h"


@interface CalendarDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation CalendarDetailViewController


- (void)backBarItemClicked:(id)s
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (id)initWithArray:(NSArray *)array
{
    if(self = [super initWithNibName:@"CalendarDetailViewController" bundle:[NSBundle mainBundle]]) {
        _array = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [self backTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    
    [_backBarItem setCustomView:backButton];
    
    if (nil != _array) {
        @try {
            
            NSArray *array = [_array objectAtIndex:0];
            NSString *dateStr = [array objectAtIndex:0];
            
            // Convert string to Date
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMdd"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            
            // Convert Date to string
            [dateFormat setDateFormat:@"EEEE MMMM d, YYYY"];
            dateStr = [dateFormat stringFromDate:date];
            
            _dateLabel.text = dateStr;
            
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setDateLabel:nil];
    [self setTableview:nil];
    [super viewDidUnload];
}



#pragma mark
#pragma UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(nil != _array)
        return _array.count;
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDetailCell *cell = [[CalendarDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarDetailCell"];
    
    NSArray *array = [_array objectAtIndex:indexPath.row];
    NSString *text = [array objectAtIndex:3];
    if(nil != cell)
        cell = [[CalendarDetailCell alloc] init];
    
    CGSize constraint = CGSizeMake(212, 20000.f);
    
    //CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.typeLabel.text = [NSString stringWithFormat:@"%@, %@", [array objectAtIndex:1], [array objectAtIndex:2]];
    cell.newsLabel.text = text;
    cell.newsLabel.frame = CGRectMake(105, 2, 212, MAX(size.height, 30));

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [_array objectAtIndex:indexPath.row];
    NSString *text = [array objectAtIndex:3];
    
    CGSize constraint = CGSizeMake(214, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 30.0f);
    
    return height + 4;

}

@end




@implementation CalendarDetailCell

- (id)init
{
    if(self = [super init]) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 100, 30)];
        //_typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //_typeLabel.minimumFontSize = 12;
        _typeLabel.minimumScaleFactor = 12;
        //_typeLabel.numberOfLines = 0;
        _typeLabel.font = [UIFont systemFontOfSize:12];
        _typeLabel.tag = 1;
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.backgroundColor = [UIColor blackColor];
        _typeLabel.adjustsFontSizeToFitWidth = YES;
        
        _newsLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 2, 212, 30)];
        _newsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //_newsLabel.minimumFontSize = 14;
        _newsLabel.minimumScaleFactor = 14;
        _newsLabel.numberOfLines = 0;
        _newsLabel.font = [UIFont systemFontOfSize:14];
        _newsLabel.tag = 2;
        _newsLabel.textColor = [UIColor whiteColor];
        _newsLabel.backgroundColor = [UIColor blackColor];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_typeLabel];
        [self addSubview:_newsLabel];
    }
    
    return self;
}

@end