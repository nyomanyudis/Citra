//
//  HKKScrollableGridViewNyoman.m
//  Ciptadana
//
//  Created by Reyhan on 5/31/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import "HKKScrollableGridViewNyoman.h"

static NSString * const kHKKScrollableGridTableCellViewScrollOffsetChanged = @"kHKKScrollableGridTableCellViewScrollOffsetChanged";
static NSString * const kNotificationUserInfoContentOffset = @"kNotificationUserInfoContentOffset";

#pragma mark -
#pragma mark - HKKScrollableGridTableCellView Implementations
#pragma mark -

@interface HKKScrollableGridTableCellViewNyoman ()
    @property (nonatomic, strong) UIScrollView *scrollView;
    @property (nonatomic, readonly) NSLayoutConstraint *fixedWidthConstraint; // ??

    @property (nonatomic, assign) CGPoint lastpoint; // ??
@end

@implementation HKKScrollableGridTableCellViewNyoman

- (instancetype)initWithFrame:(CGRect)frame // UIView overriding function 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder // UIView overriding function ??
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)dealloc // UIView overriding function ??
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didUpdateScrollOffset:(CGPoint)offset // UIView overriding function , overridable. when a scrollView's contentOffset is changed, the method is called ??
{
    self.lastpoint = offset;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context // UIView overriding function ??
{
    //NSLog(@"observeValueForKeyPath");
    CGPoint old = [[change objectForKey:@"old"] CGPointValue];
    CGPoint new = [[change objectForKey:@"new"] CGPointValue];
    
    if (CGPointEqualToPoint(old, new) == NO) {
        
        //[self didUpdateScrollOffset:_scrollView.contentOffset];
        NSValue *offset = [NSValue valueWithCGPoint:_scrollView.contentOffset];
        [[NSNotificationCenter defaultCenter] postNotificationName:self.kHKKScrollableOffsetChanged
                                                            object:self
                                                          userInfo:@{self.kNotifiticationUserInfoContentOffset:offset}];
    }
}

- (void)contentOffsetDidChanged:(NSNotification *)noti // custom function ??
{
    //NSLog(@"contentOffsetDidChanged");
    NSDictionary *userInfo = noti.userInfo;
    NSValue *value = [userInfo objectForKey:self.kNotifiticationUserInfoContentOffset];
    if (value) {
        CGPoint newPoint = [value CGPointValue];
        if (CGPointEqualToPoint(_scrollView.contentOffset, newPoint) == NO) {
            _scrollView.contentOffset = newPoint;
        }
    }
}

- (void)initView // custom function ??
{
    _fixedView = [UIView new];
    _scrollView = [UIScrollView new];
    _scrolledContentView = [UIView new];
    //    _fixedView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //    _scrolledContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _scrollView.bounces = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _fixedView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    //    _scrolledContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _fixedView.backgroundColor = [UIColor clearColor];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrolledContentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_scrollView];
    [self addSubview:_fixedView];
    [_scrollView addSubview:_scrolledContentView];
    
    //    _scrollView.contentOffset = self.lastpoint;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_fixedView]-0-[_scrollView]-0-|"
                                                                 options:NSLayoutFormatAlignAllBaseline
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_fixedView, _scrollView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fixedView]-0-|"
                                                                 options:NSLayoutFormatAlignAllBaseline
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_fixedView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|"
                                                                 options:NSLayoutFormatAlignAllBaseline
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_scrollView)]];
    
    _fixedWidthConstraint = [NSLayoutConstraint constraintWithItem:_fixedView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0f
                                                          constant:0.0f];
    [self addConstraint:_fixedWidthConstraint];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentOffsetDidChanged:)
                                                 name:self.kHKKScrollableOffsetChanged
                                               object:nil];
}

- (BOOL)isScrollable
{
    return _scrollView.frame.size.width < _scrollView.contentSize.width;
}

- (void)makeScrollableContentViewBeEmpty
{
    [_scrolledContentView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
}

- (void)makeFixedViewBeEmpty
{
    [_fixedView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
}





@end

@implementation HKKScrollableGridViewNyoman

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
