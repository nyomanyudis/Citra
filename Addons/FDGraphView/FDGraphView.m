//
//  FDGraphView.m
//  disegno
//
//  Created by Francesco Di Lorenzo on 14/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import "FDGraphView.h"

#define LINE_WIDTH 2
#define CIRCLE_WIDTH 4
#define PADDING 5

@interface FDGraphView()

@property (nonatomic, strong) NSNumber *maxDataPoint;
@property (nonatomic, strong) NSNumber *minDataPoint;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat circleWidth;

@end

@implementation FDGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // default values
        _edgeInsets = UIEdgeInsetsMake(PADDING, PADDING, PADDING, PADDING);
        _dataPointColor = [UIColor blackColor];
        _autoresizeToFitData = NO;
        _dataPointsXoffset = 100.0f;
        _lineWidth = LINE_WIDTH;
        _circleWidth = CIRCLE_WIDTH;
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (NSNumber *)maxDataPoint {
    if (_maxDataPoint) {
        return _maxDataPoint;
    } else {
        __block CGFloat max = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue > max)
                max = n.floatValue;
        }];
        return @(max);
    }
}

- (NSNumber *)minDataPoint {
    if (_minDataPoint) {
        return _minDataPoint;
    } else {
        __block CGFloat min = ((NSNumber *)self.dataPoints[0]).floatValue;
        [self.dataPoints enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop) {
            if (n.floatValue < min)
                min = n.floatValue;
        }];
        return @(min);
    }
}

- (CGFloat)widhtToFitData {
    CGFloat res = 0;
    
    if (self.dataPoints) {
        res += (self.dataPoints.count - 1)*self.dataPointsXoffset; // space occupied by data points
        res += (self.edgeInsets.left + self.edgeInsets.right) ; // lateral margins;
    }
    
    return res;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _lineWidth);
    
    // Calculate the points
    NSInteger count = self.dataPoints.count;
    
    CGFloat drawingWidth, drawingHeight, min, max;
    
    drawingWidth = rect.size.width - self.edgeInsets.left - self.edgeInsets.right;
    drawingHeight = rect.size.height - self.edgeInsets.top - self.edgeInsets.bottom;
    min = ((NSNumber *)[self minDataPoint]).floatValue;
    max = ((NSNumber *)[self maxDataPoint]).floatValue;
    
    CGFloat pointx, pointy;

    if (count > 1) {
        for (int i = 0; i < count; ++i) {
            CGFloat x, y, dataPointValue;
            
            dataPointValue = ((NSNumber *)self.dataPoints[i]).floatValue;
            
            x = self.edgeInsets.left + (drawingWidth/(count-1))*i;
            if (max != min)
                y = rect.size.height - ( self.edgeInsets.bottom + drawingHeight*( (dataPointValue - min) / (max - min) ) );
            else // the graph is a straight line
                y = rect.size.height/2;
            
            // DRAW THE GRAPH
            if (i > 0) {
                if (nil != _dataColors && _dataColors.count > i)
                    CGContextSetStrokeColorWithColor(context, ((UIColor *)_dataColors[i]).CGColor);
                else
                    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextMoveToPoint(context, pointx, pointy);
                CGContextAddLineToPoint(context, x, y);
                CGContextStrokePath(context);
                
//                // DRAW DATA POINTS
//                CGRect ellipseRect = CGRectMake(x - (_circleWidth / 2), y - (_circleWidth / 2), _circleWidth, _circleWidth);
//                CGContextAddEllipseInRect(context, ellipseRect);
//                CGContextSetLineWidth(context, _lineWidth);
//                
//                if (nil != _dataColors && _dataColors.count > i)
//                    [((UIColor *)_dataColors[i]) setStroke];
//                else
//                    [[UIColor whiteColor] setStroke];
//                
//                [self.dataPointColor setFill];
//                CGContextFillEllipseInRect(context, ellipseRect);
//                CGContextStrokeEllipseInRect(context, ellipseRect);
            }
            
            pointx = x;
            pointy = y;
        }
    }
//    else if (count == 1) {
//        // DRAW DATA POINTS
//        pointx = self.edgeInsets.left;
//        pointy = rect.size.height/2;
//        CGRect ellipseRect = CGRectMake(pointx - (_circleWidth / 2), pointy - (_circleWidth / 2), _circleWidth, _circleWidth);
//        CGContextAddEllipseInRect(context, ellipseRect);
//        CGContextSetLineWidth(context, _lineWidth);
//        [[UIColor whiteColor] setStroke];
//        [self.dataPointColor setFill];
//        CGContextFillEllipseInRect(context, ellipseRect);
//        CGContextStrokeEllipseInRect(context, ellipseRect);
//        
//    }
}

#pragma mark - Custom setters

- (void)changeFrameWidthTo:(CGFloat)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setDataPointsXoffset:(CGFloat)dataPointsXoffset {
    _dataPointsXoffset = dataPointsXoffset;
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
}

- (void)setAutoresizeToFitData:(BOOL)autoresizeToFitData {
    _autoresizeToFitData = autoresizeToFitData;
    
    CGFloat widthToFitData = [self widhtToFitData];
    if (widthToFitData > self.frame.size.width) {
        [self changeFrameWidthTo:widthToFitData];
    }
}

- (void)setDataPoints:(NSMutableArray *)dataPoints {
    _dataPoints = dataPoints;
    
    if (_dataPoints.count > 80) {
        _lineWidth = .5;
        _circleWidth = 2;
    }
    else if(_dataPoints.count > 60) {
        _lineWidth = 1;
        _circleWidth = 2.5;
    }
    else if(_dataPoints.count > 40) {
        _lineWidth = 1.5;
        _circleWidth = 3;
    }
    
    if (self.autoresizeToFitData) {
        CGFloat widthToFitData = [self widhtToFitData];
        if (widthToFitData > self.frame.size.width) {
            [self changeFrameWidthTo:widthToFitData];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)updateDataPoints:(NSArray *)points andColors:(NSArray *)colors
{
    
    if (nil == _dataPoints) _dataPoints = [NSMutableArray array];
    if (nil == _dataColors) _dataColors = [NSMutableArray array];
 
    [_dataPoints addObjectsFromArray:points];
    [_dataColors addObjectsFromArray:colors];
    
    if (_dataPoints.count > 80) {
        _lineWidth = .5;
        _circleWidth = 2;
    }
    else if(_dataPoints.count > 60) {
        _lineWidth = 1;
        _circleWidth = 2.5;
    }
    else if(_dataPoints.count > 40) {
        _lineWidth = 1.5;
        _circleWidth = 3;
    }
    
    [self setNeedsDisplay];
}

@end
