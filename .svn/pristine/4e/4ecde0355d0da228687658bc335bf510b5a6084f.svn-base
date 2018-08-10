//
//  ConstractOrder.m
//  Ciptadana
//
//  Created by Reyhan on 10/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "ConstractOrder.h"




// Header
//static NSString *_SOH                   = @"\\u0001";
//static NSString *_ETX                   = @"\\u0003";
static NSString *_messSeparator         = @"0001";
static NSString *_messBody              = @"0003";
static NSString *_messTypeCode          = @"1035=";
static NSString *_messUsername          = @"1049=";
static NSString *_messUserType          = @"1050=";
static NSString *_messAppSource         = @"1142=";
static NSString *_messSendingTime       = @"1052=";

// Body
static NSString *_messAccount 		= @"1001=";
static NSString *_messHandInst      = @"1021=";
static NSString *_messSymbol 		= @"1055=";
static NSString *_messSymbolSfx 	= @"1065=";
static NSString *_messSide          = @"1054=";
static NSString *_messOrderQty      = @"1038=";
static NSString *_messPrice 		= @"1044=";
static NSString *_messTimeInForce	= @"1059=";
static NSString *_messExpireDate	= @"1432=";
static NSString *_messComplianceId	= @"1376=";
static NSString *_messClientcode	= @"50001=";
static NSString *_messSettDate		= @"1064=";

// Body Amend
static NSString *_messJatsId		= @"1037=";
static NSString *_messOrigClordId	= @"1041=";

// Body Nego
static NSString *_messTextNegoDeal	= @"1058=";

// Body GTC
static NSString *_messOrigGTC		= @"50002=";



@interface ConstractOrder()

+ (NSString*)createHeaderOrder:(NSString*)username op:(NSMutableDictionary*)op;
+ (NSString*)createMessageOrder:(NSMutableDictionary*)op;
+ (NSString*)createTrailerOrder:(NSMutableDictionary*)op;
@end

@implementation ConstractOrder

#pragma public
+ (NSString*)generatedOrderParamIntegrasi:(NSString *)username order:(NSMutableDictionary*)op
{
    NSString *OrdParam = @"";
    
    @try {
        
        // New = D, Amend = G, Cancel = F
        OrdParam = [ConstractOrder createHeaderOrder:username op:op];
        OrdParam = [NSString stringWithFormat:@"%@%@", OrdParam, [ConstractOrder createMessageOrder:op]];
        OrdParam = [NSString stringWithFormat:@"%@%@", OrdParam, [ConstractOrder createTrailerOrder:op]];
        
        
//        KIEQ~1008=FIX.1.0-KI;
//        1035=G;
//        1049=adiretail4;
//        1050=RS;
//        1142=0;
//        1052=2013110403:20:56;
//        1109=kitr1003;
//        1037=468385271;
//        1041=KI0100000000124;
//        1001=I;
//        1021=1;
//        1055=WEHA;
//        1065=0RG;
//        1054=1;
//        1038=19;
//        1044=201;
//        1059=0;
//        1432=20131105;
//        1376=5751575;
//        0001=1401104102875;
//        0002=null;
//        50005=0;
//        50009=-1;
//        0
        
    }
    @catch (NSException *e) {
        NSLog(@"generatedOrderParamIntegrasi exception %@", e);
    }
    
    return OrdParam;
}

+ (NSString *)composeMsgNew:(NSDictionary *)op
{
 
    NSString *submitOrder = @"";
    
    unichar soh = 0x0001;
    unichar etx = 0x0003;
    
    // Header
    submitOrder = [NSString stringWithFormat:@"%@%C", [self beginingString], soh];
    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_MSGTYPE, [op objectForKey:O_MSGTYPE], soh];
    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERCOMPID, [op objectForKey:O_SENDERCOMPID], soh];
    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERSUBID, [op objectForKey:O_SENDERSUBID], soh];
    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERAPPID, [op objectForKey:O_SENDERAPPID], soh];
    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDINGTIME, [op objectForKey:O_SENDINGTIME], etx];
    
    // Body
    NSArray *allKeys = op.allKeys;
    for (NSString *key in allKeys) {
        if(![key isEqualToString:O_MSGTYPE] &&
           ![key isEqualToString:O_SENDERCOMPID] &&
           ![key isEqualToString:O_SENDERSUBID] &&
           ![key isEqualToString:O_SENDERAPPID] &&
           ![key isEqualToString:O_SENDINGTIME]) {
            
            submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, key, [op objectForKey:key], soh];
        }
    }
    
    // Tail
    submitOrder = [NSString stringWithFormat:@"%@%C", submitOrder, etx];
    
    return submitOrder;
}

//+ (NSString *)composeMsgNew:(NSDictionary *)op
//{
//    NSString *submitOrder = @"";
//    
////    char soh = [self SOH];
////    char etx = [self ETX];
////    NSString *soh = @"\\u0001";
////    NSString *etx = @"\\u0003";
//    
//    unichar soh = 0x0001;
//    unichar etx = 0x0003;
//    
//    // Header
//    submitOrder = [NSString stringWithFormat:@"%@%C", [self beginingString], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_MSGTYPE, [op objectForKey:O_MSGTYPE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERCOMPID, [op objectForKey:O_SENDERCOMPID], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERSUBID, [op objectForKey:O_SENDERSUBID], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDERAPPID, [op objectForKey:O_SENDERAPPID], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SENDINGTIME, [op objectForKey:O_SENDINGTIME], etx];
//    
//    // Body
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_ACCOUNT, [op objectForKey:O_ACCOUNT], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_HANDLINST, [op objectForKey:O_HANDLINST], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SYMBOL, [op objectForKey:O_SYMBOL], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SYMBOLSFX, [op objectForKey:O_SYMBOLSFX], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_SIDE, [op objectForKey:O_SIDE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_ORDERQTY, [op objectForKey:O_ORDERQTY], soh];
//
////    // Added for order split by client request
////    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_QTYSPLITTER, [op objectForKey:O_QTYSPLITTER], soh];
////    
////    // Added for order scheduled time
////    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_CLORDEXECTIME, [op objectForKey:O_CLORDEXECTIME], soh];
//    
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_PRICE, [op objectForKey:O_PRICE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_TIMEINFORCE, [op objectForKey:O_TIMEINFORCE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_EXPIREDATE, [op objectForKey:O_EXPIREDATE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_COMPLIANCEID, [op objectForKey:O_COMPLIANCEID], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_CLIENTCODE, [op objectForKey:O_CLIENTCODE], soh];
//    submitOrder = [NSString stringWithFormat:@"%@%@%@%C", submitOrder, O_BULKID, [op objectForKey:O_BULKID], soh];
//    
//    // Tail
//    submitOrder = [NSString stringWithFormat:@"%@%C", submitOrder, etx];
//
//    return submitOrder;
//}





#pragma private;

+ (NSString*)beginingString
{
    return @"KIEQ~1008=FIX.1.0-KI";
}

//+ (char)SOH
//{
//    return '\\u0001';
//}
//
//+ (char)ETX
//{
//    return '\\u0003';
//}

+ (NSString*)createHeaderOrder:(NSString*)username op:(NSMutableDictionary*)op
{
    NSString *OrdParam = @"";
    
    @try {
        
//        char _SOH = '\x0001';
//        NSString *s = [NSString stringWithFormat:@"%c", _SOH];
        
        NSString *messBegin 		= @"KIEQ~1008=FIX.1.0-KI";
        NSString *messType  		= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messTypeCode, [op objectForKey:@"msgType"]];
        NSString *messUser  		= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messUsername, username];
        NSString *messUserType      = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messUserType, [op objectForKey:@"userType"]];
        NSString *messAppSource 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messAppSource, [op objectForKey:@"appSource"]];
        NSString *messSendingTime 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messSendingTime, [op objectForKey:@"sendingTime"]];
        
        OrdParam = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", messBegin, messType, messUser, messUserType, messAppSource, messSendingTime, _messBody];
        
    }
    @catch (NSException *e) {
        NSLog(@"createHeaderOrder exception %@", e);
    }
    
    return OrdParam;
}

+ (NSString*)createMessageOrder:(NSMutableDictionary*)op
{
    NSString *OrdParam = @"";
    
    @try {
        
        NSString * messAccount		= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messAccount, [op objectForKey:@"account"]];
        NSString * messHandInst  	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messHandInst, [op objectForKey:@"handInst"]];
        NSString * messSymbol	 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messSymbol, [op objectForKey:@"symbol"]];
        NSString * messSymbolSfx 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messSymbolSfx, [op objectForKey:@"symbolSfx"]];
        NSString * messSide 		= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messSide, [op objectForKey:@"side"]];
        NSString * messOrderQty	 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messOrderQty, [op objectForKey:@"orderQty"]];
        NSString * messPrice	 	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messPrice, [op objectForKey:@"price"]];
        NSString * messTimeInForce	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messTimeInForce, [op objectForKey:@"timeInForce"]];
        NSString * messExpireDate	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messExpireDate, [op objectForKey:@"expireDate"]];
        NSString * messComplianceId	= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messComplianceId, [op objectForKey:@"complianceId"]];
        NSString * messClientcode   = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messClientcode, [op objectForKey:@"clientcode"]];
        NSString * messGTC 			= [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messOrigGTC, [op objectForKey:@"origGTC"]];
        
        // Amend
        NSString * messOrigClordId 	= @"";
        NSString * messJatsId		= @"";
        
        if(![@""isEqualToString:[op objectForKey:@"origClordId"]])
            messOrigClordId = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messOrigClordId, [op objectForKey:@"origClordId"]];
        if(![@""isEqualToString:[op objectForKey:@"JATSID"]])
            messJatsId = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messJatsId, [op objectForKey:@"JATSID"]];
        
        // Nego
        NSString * messSettDate 	= @"";
        NSString * messTextNegoDeal = @"";
        if([@"3"isEqualToString:[op objectForKey:@"handInst"]]) {
            
            messTimeInForce = @"";
            messExpireDate  = @"";
        }
        
        if(![@""isEqualToString:[op objectForKey:@"textNegoDeal"]]) {
            messTextNegoDeal = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messTextNegoDeal, [op objectForKey:@"textNegoDeal"]];            messSettDate = [NSString stringWithFormat:@"%@%@%@", _messSeparator, _messSettDate, [op objectForKey:@"settlementDate"]];
        }
        
        // Construct Body Order Message
        OrdParam = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", messOrigClordId, messJatsId, messAccount, messHandInst, messSymbol, messSymbolSfx, messSide, messOrderQty, messPrice, messTextNegoDeal, messSettDate, messTimeInForce, messExpireDate, messComplianceId, messClientcode, messGTC, _messBody];
        
        
    }
    @catch (NSException *e) {
        NSLog(@"createMessageOrder exception %@", e);
    }
    
    return OrdParam;
}

+ (NSString*)createTrailerOrder:(NSMutableDictionary*)op
{
    return @"0";
}

@end
