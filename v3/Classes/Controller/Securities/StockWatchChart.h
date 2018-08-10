//
//  StockWatchChart.h
//  Ciptadana
//
//  Created by Reyhan on 10/30/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"

@interface StockWatchChart : NSObject

- (id)initWithStock:(KiStockData *)data rect:(CGRect)frame;
- (void)updateStock:(KiStockData *)data;
- (UIView *)chartView;
//- (void)showLatestHistory:(KiStockData *)data;
- (void)updateChart:(KiStockData *)data lines:(NSArray *)lines colors:(NSArray *)colors;

@end
