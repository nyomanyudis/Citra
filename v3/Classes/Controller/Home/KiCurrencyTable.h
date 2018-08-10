//
//  KiCurrencyTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HKKScrollableGridView.h"

@class CurrGridViewCell;


@interface KiCurrencyTable : NSObject

- (id)initWithGridView:(HKKScrollableGridView *)gridView;
- (void)updateCurrencies:(NSArray *)currencies;

@end


@interface CurrGridViewCell : HKKScrollableGridTableCellView

@property (nonatomic, strong) UILabel* fixedLabelInit;
@property (nonatomic, strong) UIView* scrollableAreaViewInit;
@property (nonatomic, copy) HKKScrollableGridCallback callback;

- (id)init;

@end
