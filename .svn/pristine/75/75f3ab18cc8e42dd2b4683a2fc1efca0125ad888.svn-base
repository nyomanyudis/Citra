//
//  FDGraphView.h
//  disegno
//
//  Created by Francesco Di Lorenzo on 14/03/13.
//  Copyright (c) 2013 Francesco Di Lorenzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDGraphView : UIView

// Data
@property (nonatomic, strong) NSMutableArray *dataPoints;
@property (nonatomic, strong) NSMutableArray *dataColors;

// Style
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGFloat dataPointsXoffset;
// -- colors
@property (nonatomic, strong) UIColor *dataPointColor;

// Behaviour
@property (nonatomic) BOOL autoresizeToFitData;

- (void)updateDataPoints:(NSArray *)points andColors:(NSArray *)colors;

@end
