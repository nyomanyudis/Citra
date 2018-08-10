//
//  SystemAlert.h
//  Ciptadana
//
//  Created by Reyhan on 10/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SIAlertView.h"

@interface SystemAlert : NSObject

+ (SIAlertView *)alertSuccess:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertError:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertAlert:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertCaution:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertInformation:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertOKOnly:(NSString *)title andMessage:(NSString *)message handler:(SIAlertViewHandler)handler;
+ (SIAlertView *)alertOKCancel:(NSString *)title andMessage:(NSString *)message handlerOk:(SIAlertViewHandler)handlerOk handlerCancel:(SIAlertViewHandler)handlerCancel;


+ (SIAlertView *)alert:(NSString *)title message:(NSString *)message handler:(SIAlertViewHandler)handler button:(NSString *)buttonTitle;

@end
