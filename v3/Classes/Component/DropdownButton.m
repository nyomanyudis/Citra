//
//  DropdownButton.m
//  Ciptadanav3
//
//  Created by Reyhan on 7/28/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "DropdownButton.h"
#import "Util.h"

@interface DropdownButton()

@property (assign, nonatomic) BOOL shown;
@property (strong, nonatomic) TableDropdown *table;
@property (assign, nonatomic) NSInteger selection;

@end

@implementation DropdownButton

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        self.table = [[TableDropdown alloc] initWithFrame:self];
        self.table.layer.cornerRadius = 4.0f;
        self.table.layer.borderWidth = 0.75f;
        self.table.layer.masksToBounds = YES;
        self.table.layer.borderColor = COLOR_BORDER_DROPDOWN_BUTTON.CGColor;
        self.table.layer.shadowRadius = 5.0f;
        self.table.layer.shadowOpacity = 1.0f;
        self.table.layer.shadowOffset = CGSizeMake(-2.f, 0);//CGSizeMake(0.0f, 5.0f);
        self.table.layer.shadowColor = [UIColor blackColor].CGColor;
        self.table.layer.shadowRadius = 2.5;
        self.table.layer.shadowOpacity = 0.7;
        
        self.shown = NO;
        
        [self performSelector:@selector(changeSetup) withObject:nil afterDelay:0.1];
        //[self changeSetup];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *view = [super hitTest:point withEvent:event];
//    if(!view && self.shown) {
//        [self buttonTapped:self];
//    }
//    else if([view isKindOfClass:[DropdownButton class]] && ((DropdownButton *) view).shown) {
//        [((DropdownButton *)view) buttonTapped:nil];
//    }
//    else {
////        for(UIView *v in self.superview.subviews) {
////            //if([v isKindOfClass:[DropdownButton class]] && ((DropdownButton *) v).shown && self.shown)
////            if([v isKindOfClass:[DropdownButton class]] && ![v isEqual:self])
////                [((DropdownButton *) v) buttonTapped:nil];
////        }
//    }
//    return view;
//}

#pragma mark - private

- (void)changeSetup
{
    //[self.table setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"paven"]]];
    
    // create triangle
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect bounds = self.bounds;
    CGFloat size = -12.0;
    //CGFloat x = bounds.size.width * 1 - (size * 2) - 3;
    CGFloat x = bounds.size.width - 5;
    //CGFloat y = (bounds.size.height - 12)/1;
    CGFloat y = bounds.size.height - 8;
    [path moveToPoint:CGPointMake(x, y+size)];
    [path addLineToPoint:CGPointMake(x, y)];
    [path addLineToPoint:CGPointMake(x+size, y)];

    
    [path closePath];
    //[path applyTransform:CGAffineTransformMakeTranslation(CGRectGetMidX(bounds), CGRectGetMidY(bounds))];
    [path applyTransform:CGAffineTransformMakeTranslation(CGRectGetMinX(bounds), CGRectGetMinY(bounds))];
    shapeLayer.path = path.CGPath;
    
    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.fillColor = COLOR_ARROW.CGColor;
    
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - public

- (void)buttonTapped:(id)button
{
    self.shown = !self.shown;
    
    if(self.shown) {
        self.table.frame = CGRectMake(self.frame.origin.x+5, self.frame.origin.y+self.frame.size.height-10, self.frame.size.width-11, 1);
        [self.superview insertSubview:self.table belowSubview:self];
        [UIView animateWithDuration:.35
                         animations:^{
                             self.table.frame = CGRectMake(self.frame.origin.x+5, self.frame.origin.y+self.frame.size.height-10, self.frame.size.width-11, 150);
                         }
                         completion:^(BOOL finished) {
                         }];
    }
    else {
        [UIView animateWithDuration:.15
                         animations:^{
                             self.table.frame = CGRectMake(self.frame.origin.x+5, self.frame.origin.y+self.frame.size.height-10, self.frame.size.width-11, 170);
                         }
                         completion:^(BOOL finsihed) {
                             [UIView animateWithDuration:.2
                                              animations:^{
                                                  self.table.frame = CGRectMake(self.frame.origin.x+5, self.frame.origin.y+self.frame.size.height-10, self.frame.size.width-11, 1);
                                              }
                                              completion:^(BOOL finished) {
                                                  [self.table removeFromSuperview];
                                              }];
                         }];
    }
    
}

- (void)setDropdownCallback:(DropdownCallback)callback
{
    self.table.callback = callback;
}

- (NSInteger)selectionIndex
{
    return self.selection;
}

@end


@interface TableDropdown()

@property (strong, nonatomic) DropdownButton *button;
@property (retain, nonatomic) NSArray *items;

@end

@implementation TableDropdown

- (id)initWithFrame:(DropdownButton *)button
{
    if(self = [super initWithFrame:button.frame]) {
        self.delegate = self;
        self.dataSource = self;
        self.button = button;
    }
    
    return self;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.button setTitle:[self.button.items objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self.button buttonTapped:nil];
    self.button.selection = indexPath.row;
    
    if(self.callback) {
        self.callback(indexPath.row, [self.button.items objectAtIndex:indexPath.row]);
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"Total item adalah %d",self.button.items.count);
    if(self.button.items)
        return self.button.items.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tabledropdown";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    NSLog(@"items %d ini = %@",indexPath.row,[self.button.items objectAtIndex:indexPath.row]);
//    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:FONT_TITLE_LABEL_CELL];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [self.button.items objectAtIndex:indexPath.row];
        
//    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"baris ke-%d", (uint32_t)indexPath.row];
    
    return cell;
}

@end
