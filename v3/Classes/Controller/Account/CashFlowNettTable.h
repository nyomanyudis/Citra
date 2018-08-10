//
//  CashFlowNettTable.h
//  Ciptadana
//
//  Created by Reyhan on 11/15/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"

@interface CashFlowNettTable : NSObject

- (id)initWithTable:(UITableView *)table;
- (void)updateCashFlow:(CashFlow *)cash;

@end
