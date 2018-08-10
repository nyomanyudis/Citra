//
//  MarketData.h
//  Ciptadana
//
//  Created by Reyhan on 10/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Protocol.pb.h"

@class FDValue3;

@interface FDValue3 : NSObject

@property (nonatomic, assign) long double f_buyvalue;
@property (nonatomic, assign) long double f_sellvalue;
@property (nonatomic, assign) long double d_buyvalue;
@property (nonatomic, assign) long double d_sellvalue;

@end

@interface MarketData : NSObject

@property (nonatomic, strong) FDValue3 *fdValue;

+ (MarketData *)sharedInstance;

- (KiStockData *)getStockDataById:(int32_t)uid;
- (KiStockData *)getStockDataByStock:(NSString *)code;
- (NSArray *)getStringStockData;
- (void)storeStockData:(NSArray *)arrayStockData;
- (void)printStockData;

- (KiBrokerData *)getBrokerDataById:(int32_t)uid;
- (KiBrokerData *)getBrokerDataByCode:(NSString *)code;
- (void)storeBrokerData:(NSArray *)arrayBrokerData;
- (void)printBrokerData;

- (KiIndicesData *)getIndicesData:(uint32_t)uid;
- (NSArray *)getIndicesDatas;
- (void)storeIndicesData:(NSArray *)arrayIndicesData;
- (void)printIndicesData;

- (KiCurrencyData *)getCurrencyData:(uint32_t)uid;
- (void)storeCurrencyData:(NSArray *)arrayCurrencyData;
- (void)printCurrencyData;

- (KiRegionalIndicesData *)getRegionalIndicesDataById:(uint32_t)uid;
- (KiRegionalIndicesData *)getRegionalIndicesDataByCode:(NSString *)code;
- (NSArray *)getRegionalIndicesData;
- (void)storeRegionalIndicesData:(NSArray *)arrayRegionalIndicesData;
- (void)printRegionalIndicesData;

- (KiStockSummary *)getStockSummaryById:(uint32_t)uid;
- (KiStockSummary *)getStockSummaryById:(uint32_t)uid andBoard:(Board)board;
- (KiStockSummary *)getStockSummaryByStock:(NSString *)code;
- (KiStockSummary *)getStockSummaryByStock:(NSString *)code andBoard:(Board)board;
- (NSArray *)getStockSummaries;
- (NSArray *)getStockSummaryByChgPercent:(NSArray *)arrayStockSummary;
- (NSArray *)getStockSummaryByChgPercentNegasi:(NSArray *)arrayStockSummary;;
- (NSArray *)getStockSummaryByValue:(NSArray *)arrayStockSummary;;
- (NSArray *)getStockSummaryByFrequency:(NSArray *)arrayStockSummary;;
- (void)storeStockSummary:(NSArray *)arrayStockSummary;

- (Transaction *)getBrokerSummaryById:(uint32_t)uid;
- (Transaction *)getBrokerSummaryById:(uint32_t)uid andBoard:(Board)board;
- (Transaction *)getBrokerSummaryByCode:(NSString *)code;
- (Transaction *)getBrokerSummaryByCode:(NSString *)code andBoard:(Board)board;
- (NSArray *)getBrokerSummaries;
- (NSArray *)getBrokerSummariesByTVal:(NSArray *)arrayBrokerSummary;
- (void)storeBrokerSummary:(NSArray *)arrayBrokerSummary;
- (NSArray *)getStringBrokerData;

- (KiIndices *)getIndicesById:(uint32_t)uid;
- (KiIndices *)getIndicesCode:(NSString *)code;
- (NSArray *)getIndices;
- (void)storeIndices:(NSArray *)arrayIndices;

- (KiRegionalIndices *)getRegionalIndicesById:(uint32_t)uid;
- (KiRegionalIndices *)getRegionalIndicesCode:(NSString *)code;
- (NSArray *)getRegionalIndices;
- (void)storeRegionalIndices:(NSArray *)arrayRegionalIndices;

- (KiRegionalIndices *)getFutureById:(uint32_t)uid;
- (KiRegionalIndices *)getFutureCode:(NSString *)code;
- (NSArray *)getFutures;
- (void)storeFuture:(NSArray *)arrayFuture;

- (BOOL)storeForeignDomesticStock:(NSString *)code;
- (void)removeForeignDomesticStock:(NSString *)code;
- (NSMutableDictionary *)getForeignDomesticDictionary;
- (NSArray *)getForeignDomesticArray;

- (BOOL)storeWatchlistStock:(NSString *)code;
- (void)removeWatchlistStock:(NSString *)code;
- (NSArray *)getWatchlistArray;

- (KiCurrency *)getCurrency:(uint32_t)uid against:(uint32_t)uidAgainst;
- (NSArray *)getCurrencies;
- (void)storeCurrency:(NSArray *)arrayCurrency;

- (void)storeUserid:(NSString *)userid;
- (NSString *)restoreUserid;

- (void)clearDictionary;

- (void)emptyLog;
- (void)log:(NSString *)log;
- (BOOL)shouldUpdate;
- (NSMutableArray *)log;

@end
