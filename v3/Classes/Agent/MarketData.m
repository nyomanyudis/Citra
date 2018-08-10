//
//  MarketData.m
//  Ciptadana
//
//  Created by Reyhan on 10/10/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NetByBrokerTable.h"

#import "MarketData.h"

#import "NSString+StringAdditions.h"
#import "NSMutableArray+Extensions.h"
#import "NSDate+DateUltimate.h"


#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"

#define chgprcnt(chg, prev) chg * 100 / prev

static MarketData *marketData;

@interface MarketData()

@property (nonatomic) NSMutableDictionary *stockDictionaryById;
@property (nonatomic) NSMutableDictionary *stockDictionaryByStock;
@property (nonatomic) NSMutableDictionary *brokerDictionaryById;
@property (nonatomic) NSMutableDictionary *brokerDictionaryByCode;
@property (nonatomic) NSMutableDictionary *indicesDataDictionary;
@property (nonatomic) NSMutableDictionary *regIndicesDataDictionary;
@property (nonatomic) NSMutableDictionary *currencyDataDictionary;

@property (nonatomic) NSMutableDictionary *stockSummaryDictionaryById;
@property (nonatomic) NSMutableDictionary *stockSummaryDictionaryByStock;

@property (nonatomic) NSMutableDictionary *brokerSummaryDictionaryById;
@property (nonatomic) NSMutableDictionary *brokerSummaryDictionaryByCode;

@property (nonatomic) NSMutableDictionary *indicesDictionary;
@property (nonatomic) NSMutableDictionary *regionalIndicesDictionary;
@property (nonatomic) NSMutableDictionary *futureDictionary;
@property (nonatomic) NSMutableDictionary *currencyDictionary;

@property (nonatomic) NSMutableDictionary *foreignDomesticDictionary;
@property (nonatomic) NSMutableDictionary *watchlistDictionary;

- (void)initVariable;

@end

@implementation MarketData

+ (MarketData *)sharedInstance
{
    if (nil ==marketData) {
        marketData = [[MarketData alloc] init];
        [marketData initVariable];
        
        @try {
            [marketData printStockData];
            [marketData printBrokerData];
            [marketData printIndicesData];
            [marketData printRegionalIndicesData];
            [marketData printCurrencyData];
            
        }
        @catch (NSException *exception) {
            NSLog(@"%s ***exception %@", __PRETTY_FUNCTION__, exception);
        }
    }
    
    return marketData;
}

#pragma mark
#pragma private method
- (void) initVariable
{
    marketData.stockDictionaryById = [NSMutableDictionary dictionary];
    marketData.stockDictionaryByStock = [NSMutableDictionary dictionary];
    marketData.brokerDictionaryById = [NSMutableDictionary dictionary];
    marketData.brokerDictionaryByCode = [NSMutableDictionary dictionary];
    marketData.indicesDataDictionary = [NSMutableDictionary dictionary];
    marketData.regIndicesDataDictionary = [NSMutableDictionary dictionary];
    marketData.currencyDataDictionary = [NSMutableDictionary dictionary];
    
    marketData.stockSummaryDictionaryById = [NSMutableDictionary dictionary];
    marketData.stockSummaryDictionaryByStock = [NSMutableDictionary dictionary];
    
    marketData.brokerSummaryDictionaryById = [NSMutableDictionary dictionary];
    marketData.brokerSummaryDictionaryByCode = [NSMutableDictionary dictionary];
    
    marketData.indicesDictionary = [NSMutableDictionary dictionary];
    marketData.regionalIndicesDictionary = [NSMutableDictionary dictionary];
    marketData.futureDictionary = [NSMutableDictionary dictionary];
    marketData.currencyDictionary = [NSMutableDictionary dictionary];
    
    marketData.fdValue = [[FDValue3 alloc] init];
}

#pragma mark
#pragma public method


- (KiStockData *)getStockDataById:(int32_t)uid
{
    return [marketData.stockDictionaryById objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiStockData *)getStockDataByStock:(NSString *)code
{
    return [marketData.stockDictionaryByStock objectForKey:code];
}

- (NSArray *)getStringStockData
{
    static NSArray *sortedStockData = nil;
    
    if (nil == sortedStockData) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        sortedStockData = [marketData.stockDictionaryByStock.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    return sortedStockData;
}

- (void)storeStockData:(NSArray *)arrayStockData
{
    NSString *string = @"";
    for (KiStockData *s in arrayStockData) {
        [marketData.stockDictionaryById setObject:s forKey:[NSNumber numberWithInt:s.id]];
        [marketData.stockDictionaryByStock setObject:s forKey:s.code];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@', %i, '%@' UNION", s.id, s.code, s.name, s.clientType, s.color]];
    }
}

- (void)printStockData
{

}

- (KiBrokerData *)getBrokerDataById:(int32_t)uid
{
    return [marketData.brokerDictionaryById objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiBrokerData *)getBrokerDataByCode:(NSString *)code
{
    return [marketData.brokerDictionaryByCode objectForKey:code];
}

- (void)storeBrokerData:(NSArray *)arrayBrokerData
{
    NSString *string = @"";
    for (KiBrokerData *b in arrayBrokerData) {
        [marketData.brokerDictionaryById setObject:b forKey:[NSNumber numberWithInt:b.id]];
        [marketData.brokerDictionaryByCode setObject:b forKey:b.code];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@', %u, '%u' UNION", b.id, b.code, b.name, b.status, b.type]];
    }
    
}

- (NSArray *)getStringBrokerData
{
    static NSArray *sortedStockData = nil;
    
    if (nil == sortedStockData) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        sortedStockData = [marketData.brokerDictionaryByCode.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    return sortedStockData;
}

- (void)printBrokerData
{
    
}

- (KiIndicesData *)getIndicesData:(uint32_t)uid
{
    return [marketData.indicesDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (NSArray *)getIndicesDatas
{
    return marketData.indicesDataDictionary.allValues;
}

- (void)storeIndicesData:(NSArray *)arrayIndicesData
{

    for (KiIndicesData *i in arrayIndicesData) {
        [marketData.indicesDataDictionary setObject:i forKey:[NSNumber numberWithInt:i.id]];
   
    }
}

- (void)printIndicesData
{
    
}

- (KiCurrencyData *)getCurrencyData:(uint32_t)uid
{
    return [marketData.currencyDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (void)storeCurrencyData:(NSArray *)arrayCurrencyData
{
    NSString *string = @"";
    for (KiCurrencyData *c in arrayCurrencyData) {
        [marketData.currencyDataDictionary setObject:c forKey:[NSNumber numberWithInt:c.id]];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@' UNION", c.id, c.code, c.name]];
    }
    
}

- (void)printCurrencyData
{
    
}

- (KiRegionalIndicesData *)getRegionalIndicesDataById:(uint32_t)uid
{
    return [marketData.regIndicesDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndicesData *)getRegionalIndicesDataByCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in marketData.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return d;
        }
    }
    
    return  nil;
}

- (NSArray *)getRegionalIndicesData
{
    return marketData.regIndicesDataDictionary.allValues;
}

- (void)storeRegionalIndicesData:(NSArray *)arrayRegionalIndicesData
{
    for (KiRegionalIndicesData *r in arrayRegionalIndicesData) {
        [marketData.regIndicesDataDictionary setObject:r forKey:[NSNumber numberWithInt:r.id]];
        
    }
    
}

- (void)printRegionalIndicesData
{
    
}

- (BOOL)storeForeignDomesticStock:(NSString *)code
{

    
                if (nil == marketData.foreignDomesticDictionary)
                    marketData.foreignDomesticDictionary = [NSMutableDictionary dictionary];
                
                [marketData.foreignDomesticDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
                

    
    return YES;
}

- (void)removeForeignDomesticStock:(NSString *)code
{

    
            if (nil != marketData.foreignDomesticDictionary)
                [marketData.foreignDomesticDictionary removeObjectForKey:code.uppercaseString];
    
}

- (NSMutableDictionary *)getForeignDomesticDictionary
{
    return marketData.foreignDomesticDictionary;
}

- (NSArray *)getForeignDomesticArray
{

    
    if (nil != marketData.foreignDomesticDictionary) {
        return [marketData.foreignDomesticDictionary allKeys];
    }
    
    return [NSArray array];
}

- (BOOL)storeWatchlistStock:(NSString *)code
{
    if (nil == marketData.watchlistDictionary)
        marketData.watchlistDictionary = [NSMutableDictionary dictionary];
    
    [marketData.watchlistDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
    return true;
}

- (void)removeWatchlistStock:(NSString *)code
{
    
            if (nil != marketData.watchlistDictionary)
                [marketData.watchlistDictionary removeObjectForKey:code.uppercaseString];
}

- (NSArray *)getWatchlistArray
{
    
    if (nil != marketData.watchlistDictionary) {
        return [marketData.watchlistDictionary allKeys];
    }
    return [NSArray array];
}

- (KiStockSummary *)getStockSummaryById:(uint32_t)uid
{
    return [marketData getStockSummaryById:uid andBoard:BoardRg];
}

- (KiStockSummary *)getStockSummaryById:(uint32_t)uid andBoard:(Board)board
{
    return [marketData.stockSummaryDictionaryById objectForKey:[NSString stringWithFormat:@"code:%i,board:%u", uid, board]];
}

- (KiStockSummary *)getStockSummaryByStock:(NSString *)code
{
    return [marketData getStockSummaryByStock:code andBoard:BoardRg];
}

- (KiStockSummary *)getStockSummaryByStock:(NSString *)code andBoard:(Board)board
{
    return [marketData.stockSummaryDictionaryByStock objectForKey:[NSString stringWithFormat:@"code:%@,board:%u", code, board]];
}

- (NSArray *)getStockSummaries
{
    return marketData.stockSummaryDictionaryById.allValues;
}

- (NSArray *)getStockSummaryByChgPercent:(NSArray *)arrayStockSummary
{
    if (nil == arrayStockSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayStockSummary sortedArrayUsingComparator:^(KiStockSummary *a, KiStockSummary *b) {
        float achgp = -999;
        float bchgp = -999;
        
        if(a.stockSummary.board == BoardRg && a.stockSummary.ohlc.close > 0)
            achgp = a.stockSummary.change * 100 / a.stockSummary.previousPrice;
        
        if(b.stockSummary.board == BoardRg && b.stockSummary.ohlc.close > 0)
            bchgp = b.stockSummary.change * 100 / b.stockSummary.previousPrice;
        
        if(achgp > bchgp)
            return (NSComparisonResult)NSOrderedAscending;
        else if(achgp < bchgp)
            return  (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    return sortedSource;
}

- (NSArray *)getStockSummaryByChgPercentNegasi:(NSArray *)arrayStockSummary;
{
    if(nil == arrayStockSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayStockSummary sortedArrayUsingComparator:^(KiStockSummary *a, KiStockSummary *b) {
        float achgp = 999;
        float bchgp = 999;
        
        if(a.stockSummary.board == BoardRg && a.stockSummary.ohlc.close > 0)
            achgp = chgprcnt(a.stockSummary.change, a.stockSummary.previousPrice);
        
        if(b.stockSummary.board == BoardRg && b.stockSummary.ohlc.close > 0)
            bchgp = chgprcnt(b.stockSummary.change, b.stockSummary.previousPrice);
        
        if(achgp < bchgp)
            return (NSComparisonResult)NSOrderedAscending;
        else if(achgp > bchgp)
            return  (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedSource;
}

- (NSArray *)getStockSummaryByValue:(NSArray *)arrayStockSummary;
{
    if(nil == arrayStockSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayStockSummary sortedArrayUsingComparator:^(KiStockSummary *a, KiStockSummary *b) {
        
        float aval = -999;
        float bval = -999;
        
        if(a.stockSummary.board == BoardRg)
            aval = a.stockSummary.tradedValue;
        if(b.stockSummary.board == BoardRg)
            bval = b.stockSummary.tradedValue;
        
        if(aval > bval)
            return (NSComparisonResult)NSOrderedAscending;
        else if(aval < bval)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedSource;
}

- (NSArray *)getStockSummaryByFrequency:(NSArray *)arrayStockSummary;
{
    if(nil == arrayStockSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayStockSummary sortedArrayUsingComparator:^(KiStockSummary *a, KiStockSummary *b) {
        
        float aval = -999;
        float bval = -999;
        
        if(a.stockSummary.board == BoardRg)
            aval = a.stockSummary.tradedFrequency;
        if(b.stockSummary.board == BoardRg)
            bval = b.stockSummary.tradedFrequency;
        
        if(aval > bval)
            return (NSComparisonResult)NSOrderedAscending;
        else if(aval < bval)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortedSource;
}

- (void)storeStockSummary:(NSArray *)arrayStockSummary
{
    for (KiStockSummary *s in arrayStockSummary) {
        
        KiStockSummary *tmp_s = [marketData getStockSummaryById:s.codeId andBoard:s.stockSummary.board];
        if (nil != tmp_s) {
            marketData.fdValue.d_buyvalue -= tmp_s.stockSummary.tradedValue - tmp_s.foreignValBought;
            marketData.fdValue.d_sellvalue -= tmp_s.stockSummary.tradedValue - tmp_s.foreignValSold;
            marketData.fdValue.f_buyvalue -= tmp_s.foreignValBought;
            marketData.fdValue.f_sellvalue -= tmp_s.foreignValSold;
        }
        
        marketData.fdValue.d_buyvalue += s.stockSummary.tradedValue - s.foreignValBought;
        marketData.fdValue.d_sellvalue += s.stockSummary.tradedValue - s.foreignValSold;
        marketData.fdValue.f_buyvalue += s.foreignValBought;
        marketData.fdValue.f_sellvalue += s.foreignValSold;
        
        
        KiStockData *data = [marketData getStockDataById:s.codeId];
        [marketData.stockSummaryDictionaryById setObject:s forKey:[NSString stringWithFormat:@"code:%i,board:%u", s.codeId, s.stockSummary.board]];
        [marketData.stockSummaryDictionaryByStock setObject:s forKey:[NSString stringWithFormat:@"code:%@,board:%u", data.code, s.stockSummary.board]];
    }
}

- (Transaction *)getBrokerSummaryById:(uint32_t)uid
{
    return [marketData getBrokerSummaryById:uid andBoard:BoardRg];
}

- (Transaction *)getBrokerSummaryById:(uint32_t)uid andBoard:(Board)board
{
    return [marketData.brokerSummaryDictionaryById objectForKey:[NSString stringWithFormat:@"code:%i,board:%u", uid, board]];
}

- (Transaction *)getBrokerSummaryByCode:(NSString *)code
{
    return [marketData getBrokerSummaryByCode:code andBoard:BoardRg];
}

- (Transaction *)getBrokerSummaryByCode:(NSString *)code andBoard:(Board)board
{
    return [marketData.brokerSummaryDictionaryByCode objectForKey:[NSString stringWithFormat:@"code:%@,board:%u", code, board]];
}

- (NSArray *)getBrokerSummaries
{
    return marketData.brokerSummaryDictionaryById.allValues;
}

- (NSArray *)getBrokerSummariesByTVal:(NSArray *)arrayBrokerSummary
{
    if (nil == arrayBrokerSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayBrokerSummary sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
        float atval = 0;
        float btval = 0;
        
        float aValRG = 0, aValTN = 0, aValNG = 0;
        float bValRG = 0, bValTN = 0, bValNG = 0;
        
        Transaction *aRG = [marketData getBrokerSummaryById:a.codeId andBoard:BoardRg];
        Transaction *aTN = [marketData getBrokerSummaryById:a.codeId andBoard:BoardTn];
        Transaction *aNG = [marketData getBrokerSummaryById:a.codeId andBoard:BoardNg];
        if(nil != aRG) {
            aValRG = aRG.buy.value + aRG.sell.value;
        }
        if(nil != aTN) {
            aValTN = aTN.buy.value + aTN.sell.value;
        }
        if(nil != aNG) {
            aValNG = aNG.buy.value + aNG.sell.value;
        }
        
        Transaction *bRG = [marketData getBrokerSummaryById:b.codeId andBoard:BoardRg];
        Transaction *bTN = [marketData getBrokerSummaryById:b.codeId andBoard:BoardTn];
        Transaction *bNG = [marketData getBrokerSummaryById:b.codeId andBoard:BoardNg];
        if(nil != bRG) {
            bValRG = bRG.buy.value + bRG.sell.value;
        }
        if(nil != bTN) {
            bValTN = bTN.buy.value + bTN.sell.value;
        }
        if(nil != bNG) {
            bValNG = bNG.buy.value + bNG.sell.value;
        }
        
        atval = aValRG + aValTN + aValNG;
        btval = bValRG + bValTN + bValNG;
        
        if(atval > btval)
            return (NSComparisonResult)NSOrderedAscending;
        else if(atval < btval)
            return  (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *mutable = [NSMutableArray array];
    
    if (sortedSource.count > 0) {
        [mutable addObject:[sortedSource objectAtIndex:0]];
        
        for (uint32_t i = 1; i < sortedSource.count; i ++) {
            Transaction *tx1 = [sortedSource objectAtIndex:i];
            Transaction *tx0 = [sortedSource objectAtIndex:(i - 1)];
            
            if (tx1.codeId != tx0.codeId) {
                [mutable addObject:[sortedSource objectAtIndex:i]];
            }
        }
    }
    
    
    return mutable;
}

- (void)storeBrokerSummary:(NSArray *)arrayBrokerSummary
{
    for (Transaction *t in arrayBrokerSummary) {
        KiBrokerData *b = [marketData getBrokerDataById:t.codeId];
        [marketData.brokerSummaryDictionaryById setObject:t forKey:[NSString stringWithFormat:@"code:%i,board:%u", t.codeId, t.board]];
        [marketData.brokerSummaryDictionaryByCode setObject:t forKey:[NSString stringWithFormat:@"code:%@,board:%u", b.code, t.board]];
    }
}


- (KiIndices *)getIndicesById:(uint32_t)uid
{
    return [marketData.indicesDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiIndices *)getIndicesCode:(NSString *)code
{
    if (nil != marketData.indicesDataDictionary)
        for (KiIndicesData *d in marketData.indicesDataDictionary.allValues) {
            if ([d.code isEqualToString:code]) {
                return  [marketData getIndicesById:d.id];
            }
        }
    
    return nil;
}

- (NSArray *)getIndices
{
    return marketData.indicesDictionary.allValues;
}

- (void)storeIndices:(NSArray *)arrayIndices
{
    for (KiIndices *i in arrayIndices) {
        [marketData.indicesDictionary setObject:i forKey:[NSNumber numberWithInt:i.codeId]];
    }
}

- (KiRegionalIndices *)getRegionalIndicesById:(uint32_t)uid
{
    return [marketData.regionalIndicesDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndices *)getRegionalIndicesCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in marketData.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return [marketData getRegionalIndicesById:d.id];
        }
    }
    
    return nil;
}

- (NSArray *)getRegionalIndices
{
    return marketData.regionalIndicesDictionary.allValues;
}

- (void)storeRegionalIndices:(NSArray *)arrayRegionalIndices
{
    for (KiRegionalIndices *ri in arrayRegionalIndices) {
        [marketData.regionalIndicesDictionary setObject:ri forKey:[NSNumber numberWithInt:ri.codeId]];
    }
}


- (KiRegionalIndices *)getFutureById:(uint32_t)uid
{
    return [marketData.futureDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndices *)getFutureCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in marketData.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return [marketData getFutureById:d.id];
        }
    }
    return nil;
}

- (NSArray *)getFutures
{
    return marketData.futureDictionary.allValues;
}

- (void)storeFuture:(NSArray *)arrayFuture
{
    for (KiRegionalIndices *ri in arrayFuture) {
        [marketData.futureDictionary setObject:ri forKey:[NSNumber numberWithInt:ri.codeId]];
    }
}


- (KiCurrency *)getCurrency:(uint32_t)uid against:(uint32_t)uidAgainst
{
    return [marketData.currencyDictionary objectForKey:[NSString stringWithFormat:@"currCode:%i,currAgainst:%i", uid, uidAgainst]];
}

- (NSArray *)getCurrencies
{
    return marketData.currencyDictionary.allValues;
}

- (void)storeCurrency:(NSArray *)arrayCurrency
{
    for (KiCurrency *c in arrayCurrency) {
        if(c.currAgainst >= 0 && c.currCode >=0) {
            [marketData.currencyDictionary setObject:c forKey:[NSString stringWithFormat:@"currCode:%i,currAgainst:%i", c.currCode, c.currAgainst]];
        }
    }
}

- (void)storeUserid:(NSString *)userid
{
    
}

- (NSString *)restoreUserid
{
    
    return nil;
}

- (void)clearDictionary
{
    
    marketData.fdValue = nil;
    marketData.fdValue = [[FDValue3 alloc] init];
    
    if (nil != marketData.stockSummaryDictionaryById) {
        [marketData.stockSummaryDictionaryById removeAllObjects];
    }
    
    if (nil != marketData.stockSummaryDictionaryByStock) {
        [marketData.stockSummaryDictionaryByStock removeAllObjects];
    }
    
    if (nil != marketData.brokerSummaryDictionaryById) {
        [marketData.brokerSummaryDictionaryById removeAllObjects];
    }
    
    if (nil != marketData.brokerSummaryDictionaryByCode) {
        [marketData.brokerSummaryDictionaryByCode removeAllObjects];
    }
    
    if (nil != marketData.indicesDictionary) {
        [marketData.indicesDictionary removeAllObjects];
    }
    
    if (nil != marketData.regionalIndicesDictionary) {
        [marketData.regionalIndicesDictionary removeAllObjects];
    }
    
    if (nil != marketData.futureDictionary) {
        [marketData.futureDictionary removeAllObjects];
    }
    
    if (nil != marketData.currencyDictionary) {
        [marketData.currencyDictionary removeAllObjects];
    }
}

- (void)readSetting
{
    
}

- (void)showPopupOrderStatus:(BOOL)status
{
    
}

- (void)showPopupReceiveStatus:(BOOL)status
{
    
}


- (void)insertLastDate
{
    
}

- (void)updateLastDate
{
    
}


#pragma mark
#pragma public method
- (void)emptyLog
{
    
}

- (void)log:(NSString *)log
{
    
}

- (NSMutableArray *)log
{
    return nil;
}

#define DATE_FORMAT2 @"yyyy-MM-dd"

- (BOOL)shouldUpdate
{
    return YES;
}

@end


@implementation FDValue3

@end

