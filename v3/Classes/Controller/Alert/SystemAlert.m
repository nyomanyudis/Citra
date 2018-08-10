//
//  SystemAlert.m
//  Ciptadana
//
//  Created by Reyhan on 10/4/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "SystemAlert.h"

@implementation SystemAlert

+ (SIAlertView *)alertSuccess:(NSString *)message handler:(SIAlertViewHandler)handler
{
    return [self alertOKOnly:@"Succeed" message:message handler:handler];
}

+ (SIAlertView *)alertError:(NSString *)message handler:(SIAlertViewHandler)handler
{
    return [self alertOKOnly:@"Error" message:message handler:handler];
}

+ (SIAlertView *)alertAlert:(NSString *)message handler:(SIAlertViewHandler)handler
{
    return [self alertOKOnly:@"Alert" message:message handler:handler];
}

+ (SIAlertView *)alertCaution:(NSString *)message handler:(SIAlertViewHandler)handler
{
    return [self alertOKOnly:@"Caution" message:message handler:handler];
}

+ (SIAlertView *)alertInformation:(NSString *)message handler:(SIAlertViewHandler)handler
{
    return [self alertOKOnly:@"Information" message:message handler:handler];
}

+ (SIAlertView *)alertOKOnly:(NSString *)title message:(NSString *)message handler:(SIAlertViewHandler)handler
{
    SIAlertView *alertView = [self alertWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:handler];
    
    return alertView;

}

+ (SIAlertView *)alertOKCancel:(NSString *)title andMessage:(NSString *)message handlerOk:(SIAlertViewHandler)handlerOk handlerCancel:(SIAlertViewHandler)handlerCancel
{
    SIAlertView *alertView = [self alertWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:handlerOk];
    [alertView addButtonWithTitle:@"CANCEL"
                             type:SIAlertViewButtonTypeDefault
                          handler:handlerCancel];
    
    return alertView;
}

+ (SIAlertView *)alert:(NSString *)title message:(NSString *)message handler:(SIAlertViewHandler)handler button:(NSString *)buttonTitle
{
    SIAlertView *alertView = [self alertWithTitle:title andMessage:message];
    [alertView addButtonWithTitle:buttonTitle
                             type:SIAlertViewButtonTypeDefault
                          handler:handler];
    return alertView;
}

+ (SIAlertView *)alertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    
//    [alertView addButtonWithTitle:@"Button1"
//                             type:SIAlertViewButtonTypeDefault
//                          handler:^(SIAlertView *alert) {
//                              NSLog(@"Button1 Clicked");
//                          }];
//    [alertView addButtonWithTitle:@"Button2"
//                             type:SIAlertViewButtonTypeDestructive
//                          handler:^(SIAlertView *alert) {
//                              NSLog(@"Button2 Clicked");
//                          }];
    //    [alertView addButtonWithTitle:@"Button3"
    //                             type:SIAlertViewButtonTypeCancel
    //                          handler:^(SIAlertView *alert) {
    //                              NSLog(@"Button3 Clicked");
    //                          }];
    
//    alertView.willShowHandler = ^(SIAlertView *alertView) {
//        //NSLog(@"1.%@, willShowHandler", alertView);
//    };
//    alertView.didShowHandler = ^(SIAlertView *alertView) {
//        //NSLog(@"2.%@, didShowHandler", alertView);
//    };
//    alertView.willDismissHandler = ^(SIAlertView *alertView) {
//        //NSLog(@"3.%@, willDismissHandler", alertView);
//    };
//    alertView.didDismissHandler = ^(SIAlertView *alertView) {
//        //NSLog(@"4.%@, didDismissHandler", alertView);
//    };
//    
    alertView.transitionStyle = SIAlertViewTransitionStyleFade;
    
    return alertView;
}

@end
