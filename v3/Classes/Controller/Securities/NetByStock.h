//
//  NetByStock.h
//  Ciptadana
//
//  Created by Reyhan on 11/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "GrandController.h"

@interface NetByStock : GrandController

@property (strong, nonatomic) NSString *stockCode;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxRegular;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxNego;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxCash;
@end
