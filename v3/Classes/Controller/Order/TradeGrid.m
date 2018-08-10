//
//  TradeGrid.m
//  Ciptadana
//
//  Created by Reyhan on 12/14/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TradeGrid.h"
#import "OrderGrid.h"

#import "Protocol.pb.h"
#import "ObjectBuilder.h"
#import "Util.h"

#define IDENTIFIER @"GridIdentifierTrade"
#define HKKScrollableOffsetChanged @"kHKKScrollableGridTableCellViewScrollOffsetChangedTrade"
#define NotifiticationUserInfoContentOffset @"kNotificationUserInfoContentOffsetTrade"

@interface TradeGrid() <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *gridView;
@property (strong, nonatomic) TradeGridViewCell *gridHeader;

@property (strong, nonatomic) NSArray *orders;

@end

@implementation TradeGrid

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
        [self.gridView registerClassForGridCellView:[TradeGridViewCell class] reuseIdentifier:IDENTIFIER];
        //[self.gridView accessibilityScroll:UIAccessibilityScrollDirectionUp];
        
        self.orders = [NSMutableArray array];
    }
    return self;
}

- (void)updateTrades:(NSArray *)orders
{
    if(orders) {
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
    if(self.orders)
        return self.orders.count;
    return 0;
}

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    TradeGridViewCell *cellView = (TradeGridViewCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER;
    cellView.kNotifiticationUserInfoContentOffset = NotifiticationUserInfoContentOffset;
    cellView.callback = gridView.callback;
    
    NSUInteger index = self.orders.count - 1 - rowIndex;
    TxOrder *order = [self.orders objectAtIndex:index];
    
    cellView.order = order;
    
    UIView* fixedView = cellView.fixedLabelInit;
    
    UILabel *label1 = [fixedView viewWithTag:9998];
    label1.text = order.tradeTime;
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
            label.text = [NSString localizedStringWithFormat:@"%.0f", order.tradeQty];
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
    return 160.f;
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
- (TradeGridViewCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[TradeGridViewCell alloc] init];
        [[self.gridHeader.fixedLabelInit viewWithTag:1] removeFromSuperview];
    }
    return self.gridHeader;
}

@end


@interface TradeGridViewCell()

@property (nonatomic, strong) UIView* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation TradeGridViewCell

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
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 28)];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(4, 0, 100, 28) withLabel:@"TIME" andTag:9998]];
        [view addSubview:[ObjectBuilder createGridHeaderLabel:CGRectMake(88, 0, 60, 28) withLabel:@"STOCK" andTag:9999]];
        
        self.fixedLabel = view;
        [self.fixedView addSubview:self.fixedLabel];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.fixedView addGestureRecognizer:singleFingerTap];
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
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(8, 0, 70, 32) withLabel:@"PRICE" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(76, 0, 35, 32) withLabel:@"LOT" andTag:3]];
        //[self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(159, 0, 120, 32) withLabel:@"STATUS" andTag:4]];
        
        //((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentLeft;
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentCenter;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        //((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentLeft;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.scrolledContentView addGestureRecognizer:singleFingerTap];
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
