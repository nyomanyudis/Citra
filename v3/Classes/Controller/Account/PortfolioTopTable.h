//
//  PortfolioTopTable.h
//  Ciptadana
//
//  Created by Reyhan on 11/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"

@interface PortfolioTopTable : NSObject

- (id)initWithTable:(UITableView *)table;
- (void)updateCustomerPosition:(CustomerPosition *)customer;

@end
