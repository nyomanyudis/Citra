//
//  ConstractOrder.h
//  Ciptadana
//
//  Created by Reyhan on 10/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSInteger K_ENTRYBUY         = 0;
static NSInteger K_ENTRYSELL        = (1);
static NSInteger K_GETOP            = (2);
static NSInteger K_AMEND            = (9003);
static NSInteger K_AMENDORDER       = (9005);
static NSInteger K_WITHDRAW 		= (9004);
static NSInteger K_WITHDRAWORDER	= (9006);
static NSInteger K_SUBMITGTC	 	= (9007);
static NSInteger K_RENEW		 	= (9008);
static NSInteger K_RENEWORDER       = (9009);

static NSInteger K_CLOSE_VIEW       = (9999);

//MESSAGE HEADER
static NSString *O_BEGINSTRING      = @"1008=";  	//FIX.1.0-KI
static NSString *O_MSGTYPE          = @"1035=";  	//Depend on message to be sent
static NSString *O_SENDERCOMPID     = @"1049=";  	//User Id
static NSString *O_SENDERSUBID      = @"1050=";  	//F or S or C or D F=Floor manager S=Sales C=Client/Retail D=Dealer
static NSString *O_SENDERAPPID      = @"1142=";  	//D or M D=Desktop M=Mobile
static NSString *O_SENDINGTIME      = @"1052=";  	//Time (yyyyMMddhh:mm:ss)

//MESSAGE BODY
static NSString *O_ACCOUNT          = @"1001="; 	//A or I or S or F A=Asing I=Indonesia
static NSString *O_HANDLINST		= @"1021="; 	//1 or 2 1=Normal Order 2=Advertisement Order
static NSString *O_SYMBOL			= @"1055=";  	//Stock symbol
static NSString *O_SYMBOLSFX		= @"1065=";  	//0RG or 0TN or 0NG 0RG=Regular 0TN=Tunai 0NG=Negosiasi
static NSString *O_SIDE             = @"1054=";  	//1 or 2 or 5 or M 1=buy 2=sell 5=sell short M=margin
static NSString *O_TEXT             = @"1058=";
static NSString *O_ORDERQTY         = @"1038=";  	//Order quantity Normal Order in LOT, Advertisement Order in SHARE
static NSString *O_PRICE			= @"1044=";  	//Order price
static NSString *O_TIMEINFORCE      = @"1059=";  	//0 or S or 1 or 6 0=day S=session 1=GTC 6=GTD
static NSString *O_FUTSETTDATE      = @"1064=";
static NSString *O_CLIENTID         = @"1109=";
static NSString *O_EXPIREDATE		= @"1432=";  	//Date (yyyyMMdd) If TimeInForce=6
static NSString *O_COMPLIANCEID     = @"1376=";	//Compliance id Trading-ID contains 6 digit alpha numeric of SID (from 8th digit
                                                            //to 13th digit). SID is provided by Indonesian Central Securities Depository (KSEI)
static NSString *O_CLIENTCODE		= @"50001=";
static NSString *O_ORIGGTCID		= @"50002=";
static NSString *O_CPARTY			= @"50003=";
static NSString *O_QTYSPLITTER      = @"50004=";
static NSString *O_CLORDEXECTIME	= @"50005=";
static NSString *O_CLORDBATCHID     = @"50006=";
static NSString *O_CLSETTLEMENT     = @"50007=";
static NSString *O_NGREASON         = @"50008=";
static NSString *O_BULKID			= @"50009=";

static NSString *O_OBTID			= @"70001=";
static NSString *O_BATCH_TIME		= @"70002=";
static NSString *F_BULK_DETAIL      = @"70003="; 	//USING ONLY IN CLIENT APPLICATION

//MESSAGE BODY: NEGDEAL ORDER
static NSString *O_IOIID			= @"1023="; 	//NG Order: order number to be confirmed

//MESSAGE BODY: ADDITION for AMEND or CANCEL ORDER
static NSString *O_ORDERID          = @"1037=";  	//JATS Order Number
static NSString *O_ORIGCLORDID      = @"1041=";  	//ClOrdId of the previous order


@interface ConstractOrder : NSObject

+ (NSString*)generatedOrderParamIntegrasi:(NSString*)username order:(NSMutableDictionary*)op;
+ (NSString*)composeMsgNew:(NSDictionary*)op;

@end

