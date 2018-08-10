//
//  OrderAmend.h
//  Ciptadana
//
//  Created by Reyhan on 12/21/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "GrandController.h"

#import "Protocol.pb.h"

@interface OrderAmend : GrandController

@property (strong, nonatomic) TxOrder *order;

@end
