//
//  StockWatchChart.m
//  Ciptadana
//
//  Created by Reyhan on 10/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "StockWatchChart.h"

#import "MarketFeed.h"
#import "MarketData.h"

#import "FDGraphView.h"
#import "Util.h"

static NSMutableDictionary *chartLines;

@interface StockWatchChart()

@property (strong, nonatomic) FDGraphView *graphView;
@property (strong, nonatomic) KiStockData *data;
//@property (retain, nonnull) NSMutableArray *lines;
//@property (retain, nonnull) NSMutableArray *colors;

@end

@implementation StockWatchChart

#pragma mark - public

- (id)initWithStock:(KiStockData *)data rect:(CGRect)frame
{
    self = [super init];
    if(self) {
        self.data = data;
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.graphView = [[FDGraphView alloc] initWithFrame:rect];
        self.graphView.backgroundColor = [UIColor clearColor];
        
//        self.lines = [NSMutableArray array];
//        self.colors = [NSMutableArray array];
        
        if(!chartLines)
            chartLines = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)updateStock:(KiStockData *)data
{
}

- (UIView*)chartView
{
    return self.graphView;
}

- (void)showLatestHistory:(KiStockData *)data
{
    NSArray *array = [chartLines objectForKey:data.code];
    
    if (array) {
        NSMutableArray *lines = [NSMutableArray array];
        NSMutableArray *colors = [NSMutableArray array];
        
        KiStockSummary *summary = [[MarketData sharedInstance] getStockSummaryById:data.id];
        int32_t previous = summary.stockSummary.previousPrice;
        
        for(NSNumber *n in array) {
            [lines addObject:n];
            
            if(previous < [n intValue]) [colors addObject:GREEN];
            else if(previous > [n intValue]) [colors addObject:RED];
            else [colors addObject:YELLOW];
        }
        
        if(lines && colors && lines.count > 0 && colors.count > 0)
            [self.graphView updateDataPoints:lines andColors:colors];
        
//        for (OHLC *ohlc in array) {
//            [points addObject:[NSNumber numberWithInt:ohlc.close]];
//            
//            if (summary.stockSummary.previousPrice < ohlc.close)
//                [colors addObject:GREEN];
//            else if(summary.stockSummary.previousPrice > ohlc.close)
//                [colors addObject:red];
//            else [colors addObject:yellow];
//        }
//        
//        [self.lineChart setDataColors:colors];
//        [self.lineChart setDataPoints:points];
    }
}

- (void)updateChart:(KiStockData *)data lines:(NSArray *)lines colors:(NSArray *)colors
{
    NSMutableArray *array = [chartLines objectForKey:data.code];
    
    if(!array) {
        array = [NSMutableArray array];
        [chartLines setObject:array forKey:data.code];
    }
    
    for(int i = 0;i<[lines count];i++){
        
    }
    
    [array addObjectsFromArray:lines];//close value
    
    if(self.data && self.data.id != data.id) {
        [self.graphView setDataColors:nil];
        [self.graphView setDataPoints:nil];
        
        [self showLatestHistory:data];
    }
    
    self.data = data;
 
    if(lines && colors && lines.count > 0 && colors.count > 0)
        [self.graphView updateDataPoints:lines andColors:colors];
}

@end
