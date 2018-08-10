//
//  OrderGrid.m
//  Ciptadana
//
//  Created by Reyhan on 12/13/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "OrderGrid.h"

#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "MarketFeed.h"


#define IDENTIFIER @"GridIdentifierOrders"
#define HKKScrollableOffsetChanged @"kHKKScrollableGridTableCellViewScrollOffsetChangedOrders"
#define NotifiticationUserInfoContentOffset @"kNotificationUserInfoContentOffsetOrders"



@interface OrderGrid() <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *gridView;
@property (strong, nonatomic) OrderGridViewCell *gridHeader;
@property (assign, nonatomic) BOOL ascending;

@property (strong, nonatomic) NSMutableArray *orders;
@property (strong,nonatomic) NSString *OrderType;
@property (strong,nonatomic) NSString *OrderStatus;
@property (strong,nonatomic) NSMutableArray *indexOrder;

@end

@implementation OrderGrid

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.gridView = gridView;
        
        //        self.currGrid.kHKKScrollableOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChangedCurr";
        //        self.currGrid.kNotifiticationUserInfoContentOffset = @"kNotificationUserInfoContentOffsetCurr";
        
        self.gridView.dataSource = self;
        self.gridView.delegate = self;
        self.gridView.verticalBounce = YES;
        self.gridView.backgroundColor = [UIColor clearColor];
        [self.gridView registerClassForGridCellView:[OrderGridViewCell class] reuseIdentifier:IDENTIFIER];
        //[self.gridView accessibilityScroll:UIAccessibilityScrollDirectionUp];
        
        self.orders = [NSMutableArray array];
    }
    return self;
}

- (void)updateTrades:(NSArray *)orders OrderType:(NSString *)OrderType OrderStatus:(NSString *)OrderStatus
{
    if(orders) {
        self.OrderType = OrderType;
        self.OrderStatus = OrderStatus;
        
        NSLog(@"PassingOrderType = %@ PassingOrderStatus = %@",self.OrderType,self.OrderStatus);
        self.orders = [OrderGrid sortOrderByCreatedTime:orders];
        [self.gridView reloadData];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - private

- (void)actionTapped:(id)sender
{
    UIButton *button = sender;
    NSLog(@"button tag: %ld", (long)button.tag);
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource

- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
//    NSInteger count = 0;
    if(self.orders){
        return self.orders.count;
//        for(int i=0;i<self.orders.count;i++){
//            TxOrder *order = [self.orders objectAtIndex:i];
//            NSString *OrderType = order.side == 1 ? @"Buy" : @"Sell";
//            
//            
//            if( ([order.orderStatus caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame  && [OrderType caseInsensitiveCompare:self.OrderType] == NSOrderedSame ) ||
//                ([@"All" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame  && [OrderType caseInsensitiveCompare:self.OrderType] == NSOrderedSame ) ||
//                ([order.orderStatus caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame  && [@"All" caseInsensitiveCompare:self.OrderType] == NSOrderedSame ) ||
//                ([@"All" caseInsensitiveCompare:self.OrderStatus] == NSOrderedSame  && [@"All" caseInsensitiveCompare:self.OrderType] == NSOrderedSame )){
//                [self.indexOrder addObject:i];
//                count ++;
//            }
//        }
//        return count;
    }
    
    return 0;
}

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    OrderGridViewCell *cellView = (OrderGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER;
    cellView.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
    cellView.callback = gridView.callback;
    
    NSUInteger index = self.orders.count - 1 - rowIndex;
    TxOrder *order = [self.orders objectAtIndex:index];
    
    
    cellView.order = order;
    
    UIView* fixedView = cellView.fixedLabelInit;
//    UIButton *button = [fixedView viewWithTag:1];
//    button.tag = rowIndex;
//    [button addTarget:self action:@selector(actionTapped:) forControlEvents:UIControlEventTouchDown];
    
    UILabel *label1 = [fixedView viewWithTag:9998];
    label1.text = order.createdTime;
    UILabel *label2 = [fixedView viewWithTag:9999];
    label2.text = order.securityCode;
    
    if (1 == order.side) {
        label1.textColor = GREEN;
        label2.textColor = GREEN;
    }
    else {
        label1.textColor = RED;
        label2.textColor = RED;
    }
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 5; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
        
        //if(n == 1)
        //    label.text = order.createdTime;
        if(n == 1)
            label.text = order.side == 1 ? @"B" : @"S";
        else if(n == 2)
            label.text = [NSString localizedStringWithFormat:@"%d", order.price];
        else if(n == 3)
            label.text = [NSString localizedStringWithFormat:@"%.0f", order.orderQty];
        else if(n == 4)
            label.text = [OrderGrid statusDescription:order.orderStatus];
        
        if (1 == order.side)
            label.textColor = GREEN;
        else
            label.textColor = RED;
    }
    
    return cellView;
}

- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 126.f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 290.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 32.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 28.0f;
}
- (OrderGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[OrderGridViewCell alloc] init];
        self.gridHeader.header = YES;
        [[self.gridHeader.fixedLabelInit viewWithTag:1] removeFromSuperview];
        
        UIView* fixedView = self.gridHeader.fixedLabelInit;
        
        UIView* scrollAreaView = self.gridHeader.scrollableAreaViewInit;
        
        UILabel *label2 = [fixedView viewWithTag:9999];
        UILabel *label1 = [scrollAreaView viewWithTag:1];
        UILabel *label4 = [scrollAreaView viewWithTag:4];
        
        UIButton *stock = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        stock.frame = label2.frame;
        [stock setBackgroundImage:nil forState:UIControlStateNormal];
        [stock setTitle:@"STOCK" forState:UIControlStateNormal];
        stock.titleLabel.font = label2.font;
        
        UIButton *side = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        side.frame = CGRectMake(label1.frame.origin.x, label1.frame.origin.y-2, label1.frame.size.width+10, label1.frame.size.height);
        [side setBackgroundImage:nil forState:UIControlStateNormal];
        [side setTitle:@"SIDE" forState:UIControlStateNormal];
        side.titleLabel.font = [label1.font fontWithSize:12.f];
        
        UIButton *status = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        status.frame = CGRectMake(label4.frame.origin.x, label4.frame.origin.y-2, label4.frame.size.width+10, label4.frame.size.height);
        [status setBackgroundImage:nil forState:UIControlStateNormal];
        [status setTitle:@"STATUS" forState:UIControlStateNormal];
        status.titleLabel.font = label1.font;
        
        [label2 removeFromSuperview];
        [label1 removeFromSuperview];
        [label4 removeFromSuperview];
        [fixedView addSubview:stock];
        [scrollAreaView addSubview:side];
        [scrollAreaView addSubview:status];
        
        [stock addTarget:self action:@selector(sortStock) forControlEvents:UIControlEventTouchDown];
        [side addTarget:self action:@selector(sortSide) forControlEvents:UIControlEventTouchDown];
        [status addTarget:self action:@selector(sortStatus) forControlEvents:UIControlEventTouchDown];
    }
    return self.gridHeader;
}

- (void)sortStock
{
    self.ascending = ~self.ascending;
    
    self.orders = [OrderGrid sortOrderByStock:self.orders ascending:self.ascending];
    [self.gridView reloadData];
    
}

- (void)sortSide
{
    self.ascending = ~self.ascending;
    
    self.orders = [OrderGrid sortOrderBySide:self.orders ascending:self.ascending];
    [self.gridView reloadData];
    
}

- (void)sortStatus
{
    self.ascending = ~self.ascending;
    
    self.orders = [OrderGrid sortOrderByStatus:self.orders ascending:self.ascending];
    [self.gridView reloadData];
    
}

#pragma mark - public static

+ (NSMutableArray *)sortOrderByCreatedTime:(NSArray *)source
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdTime" ascending:YES];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    return mutTmp;
}

+ (NSMutableArray *)sortOrderByStock:(NSArray *)source ascending:(BOOL)asc
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"securityCode" ascending:asc];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    return mutTmp;
}

+ (NSMutableArray *)sortOrderBySide:(NSArray *)source ascending:(BOOL)asc
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"side" ascending:asc];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    return mutTmp;
}

+ (NSMutableArray *)sortOrderByStatus:(NSArray *)source ascending:(BOOL)asc
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"orderStatus" ascending:asc];
    NSArray *tmp = [source sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    NSMutableArray *mutTmp = [NSMutableArray arrayWithArray:tmp];
    tmp = nil;
    
    return mutTmp;
}

+ (NSString*) statusDescription:(NSString*)status
{
    if(nil != status) {
        if([@"0" isEqualToString:status]) {
            return @"Open";
        }
        else if([@"1" isEqualToString:status]) {
            return @"Partially Match";
        }
        else if([@"2" isEqualToString:status]) {
            return @"Fully Match";
        }
        else if([@"3" isEqualToString:status]) {
            return @"Done for day";
        }
        else if([@"4" isEqualToString:status]) {
            return @"withdrawn";
        }
        else if([@"5" isEqualToString:status]) {
            return @"Amended";
        }
        else if([@"6" isEqualToString:status]) {
            return @"Pending Cancel";
        }
        else if([@"7" isEqualToString:status]) {
            return @"Stopped";
        }
        else if([@"8" isEqualToString:status]) {
            return @"Rejected";
        }
        else if([@"9" isEqualToString:status]) {
            return @"In Process";
        }
        else if([@"A" isEqualToString:status]) {
            return @"Pending New";
        }
        else if([@"B" isEqualToString:status]) {
            return @"Calculated";
        }
        else if([@"C" isEqualToString:status]) {
            return @"Expired";
        }
        else if([@"D" isEqualToString:status]) {
            return @"Accepted for Bidding";
        }
        else if([@"E" isEqualToString:status]) {
            return @"Pending Replace";
        }
        else if([@"KA" isEqualToString:status]) {
            return @"Preopening Not Submitted";
        }
        else if([@"KB" isEqualToString:status]) {
            return @"Preopening Submitted";
        }
        else if([@"KC" isEqualToString:status]) {
            return @"Pooling Not Submitted";
        }
        else if([@"KD" isEqualToString:status]) {
            return @"Pooling Submitted";
        }
        else if([@"kc" isEqualToString:status]) {
            return @"Pooling Cancel";
        }
        else if([@"r" isEqualToString:status]) {
            return @"Internal Reject";
            //return @"Rejected";
        }
        else if([@"W" isEqualToString:status]) {
            return @"Waiting Process";
        }
        else if([@"1x0001" isEqualToString:status]) {
            return @"Order Received By Server";
        }
    }
    
    return @"";
}

@end


@interface OrderGridViewCell()

@property (nonatomic, strong) UIView* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation OrderGridViewCell

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = HKKScrollableOffsetChanged;
        self.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fixedLabelInit.frame = self.fixedView.bounds;
    self.scrollableAreaViewInit.frame = self.scrolledContentView.bounds;
    
}

- (UIView *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 28)];
        //[view addSubview:[ObjectBuilder createGridButton:CGRectMake(0, 0, 70, 30) withLabel:@"ACTION" andTag:1]];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(4, 0, 60, 28) withLabel:@"TIME" andTag:9998]];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(68, 0, 60, 28) withLabel:@"STOCK" andTag:9999]];
        
//        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentCenter;
        
        self.fixedLabel = view;
        [self.fixedView addSubview:self.fixedLabel];
        
        //((UILabel*)[view viewWithTag:9999]).textAlignment = NSTextAlignmentRight;
        
        if(!self.isHeader) {
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            
            [self.fixedView addGestureRecognizer:singleFingerTap];
        }
    }
    return self.fixedLabel;
}

- (UIView*)scrollableAreaViewInit
{
    if (self.scrollableAreaView == nil) {
        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
        
        //[self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(4, 0, 60, 32) withLabel:@"TIME" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, 0, 30, 32) withLabel:@"SIDE" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(38, 0, 70, 32) withLabel:@"PRICE" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(96, 0, 35, 32) withLabel:@"LOT" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(109, 0, 120, 32) withLabel:@"STATUS" andTag:4]];
        
        //((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentCenter;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
        
        if(!self.isHeader) {
            UITapGestureRecognizer *singleFingerTap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(handleSingleTap:)];
            
            [self.scrolledContentView addGestureRecognizer:singleFingerTap];
        }
    }
    return self.scrollableAreaView;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"handle single tap: %@", self.order);
    
    if(self.callback) {
        self.callback(0, self.order);
    }

}

@end
