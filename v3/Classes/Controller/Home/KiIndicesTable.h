//
//  KiIndicesTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKKScrollableGridView.h"

@class IndiGridViewCell;


@interface KiIndicesTable : NSObject

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateIndices:(NSArray *)indices;

@end


@interface IndiGridViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (nonatomic, copy) HKKScrollableGridCallback callback;


- (id)init;

@end

