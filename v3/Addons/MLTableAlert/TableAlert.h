//
//  TableAlert.h
//  Ciptadana
//
//  Created by Reyhan on 12/15/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLTableAlert.h"

@interface TableAlert : NSObject

+ (MLTableAlert *)alertConfirmationOKOnly:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok;
+ (MLTableAlert *)alertConfirmationOKOnlyWithColor:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok cellsColor:(NSArray *) cellsColor;
+ (MLTableAlert *)alertConfirmationOKCancel:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel;
+ (MLTableAlert *)alertConfirmation:(NSArray *)cells titleAlert:(NSString *)title okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel cellsColor:(NSArray *) cellsColor;
+ (MLTableAlert *)alertConfirmation:(NSArray *)cells titleAlert:(NSString *)title okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel otherOnClick:(MLTableAlertOkButtonOnClick)other cellsColor:(NSArray *) cellsColor ;

@end
