//
//  DBLite.m
//  Ciptadana
//
//  Created by Reyhan on 6/10/14.
//  Copyright (c) 2014 Reyhan. All rights reserved.
//

#import "DBLite.h"
#import "NSString+StringAdditions.h"
#import "NSMutableArray+Extensions.h"
#import "NSDate+DateUltimate.h"

#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"

#define chgprcnt(chg, prev) chg * 100 / prev

static DBLite *dbLite;

@interface DBLite()

@property (nonatomic) sqlite3 *myDatabase;
@property (nonatomic) NSString *databasePath;
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

- (void)setupDBLite;
- (void)initVariable;
- (BOOL)isNeedUpdate;

@end


@implementation DBLite

+ (DBLite *)sharedInstance
{
    if (nil ==dbLite) {
        dbLite = [[DBLite alloc] init];
        [dbLite initVariable];
        [dbLite setupDBLite];
        
        @try {
            [dbLite printStockData];
            [dbLite printBrokerData];
            [dbLite printIndicesData];
            [dbLite printRegionalIndicesData];
            [dbLite printCurrencyData];
            
        }
        @catch (NSException *exception) {
            NSLog(@"%s ***exception %@", __PRETTY_FUNCTION__, exception);
        }
    }
    
    return dbLite;
}


#pragma mark
#pragma private method
- (void) initVariable
{
    dbLite.stockDictionaryById = [NSMutableDictionary dictionary];
    dbLite.stockDictionaryByStock = [NSMutableDictionary dictionary];
    dbLite.brokerDictionaryById = [NSMutableDictionary dictionary];
    dbLite.brokerDictionaryByCode = [NSMutableDictionary dictionary];
    dbLite.indicesDataDictionary = [NSMutableDictionary dictionary];
    dbLite.regIndicesDataDictionary = [NSMutableDictionary dictionary];
    dbLite.currencyDataDictionary = [NSMutableDictionary dictionary];
    
    dbLite.stockSummaryDictionaryById = [NSMutableDictionary dictionary];
    dbLite.stockSummaryDictionaryByStock = [NSMutableDictionary dictionary];
    
    dbLite.brokerSummaryDictionaryById = [NSMutableDictionary dictionary];
    dbLite.brokerSummaryDictionaryByCode = [NSMutableDictionary dictionary];
    
    dbLite.indicesDictionary = [NSMutableDictionary dictionary];
    dbLite.regionalIndicesDictionary = [NSMutableDictionary dictionary];
    dbLite.futureDictionary = [NSMutableDictionary dictionary];
    dbLite.currencyDictionary = [NSMutableDictionary dictionary];
    
    dbLite.fdValue = [[FDValue alloc] init];
}

- (void)setupDBLite
{
    
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    // Build the path to the database file
    dbLite.databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:DBLITE_NAME]];
    //NSLog(@"%s DB PATH: %@", __PRETTY_FUNCTION__, dbLite.databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: dbLite.databasePath ] == NO) {
        const char *dbpath = [dbLite.databasePath UTF8String];
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            char *errMsg;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"db.sql"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
            {
                NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sql"];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
            }
            
            //Load from File
            NSString *content = [[NSString alloc] initWithContentsOfFile:myPathDocs encoding:NSUTF8StringEncoding error:NULL];
            
            const char *sql_stmt = [content UTF8String];
            
            if (sqlite3_exec(_myDatabase, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"%s Failed to create table", __PRETTY_FUNCTION__);
                
            } else {
                //NSLog(@"%s Success in creating table", __PRETTY_FUNCTION__);
            }
            
            sqlite3_close(_myDatabase);
            
        } else {
            NSLog(@"%s Failed to open/create database", __PRETTY_FUNCTION__);
        }
    }
}

- (BOOL)isNeedUpdate
{
    return YES;
}


#pragma mark
#pragma public method

- (BOOL)shouldUpdateDB
{
    
    return YES;
    
    NSDate *date = nil;
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT \"lastupdate_db\" FROM \"prop_tbl\" LIMIT 1";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *dateString = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                
                //NSLog(@"%s LASATUPDATE %@", __PRETTY_FUNCTION__, dateString);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:DATE_FORMAT];
                
                date = [formatter dateFromString:dateString];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    
    if (nil != date) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = DATE_FORMAT;
        
        // current date
        NSString *date0 = [formatter stringFromDate:[NSDate date]];
        int year0 = [[date0 substringWithRange:NSMakeRange(0, 4)] intValue];
        int month0 = [[date0 substringWithRange:NSMakeRange(5, 2)] intValue];
        int day0 = [[date0 substringWithRange:NSMakeRange(8, 2)] intValue];
        
        // last date
        NSString *date1 = [formatter stringFromDate:date];
        int year1 = [[date1 substringWithRange:NSMakeRange(0, 4)] intValue];
        int month1 = [[date1 substringWithRange:NSMakeRange(5, 2)] intValue];
        int day1 = [[date1 substringWithRange:NSMakeRange(8, 2)] intValue];
        
        if (year1 < year0) return YES;
        if (month1 < month0) return YES;
        if (day1 < day0) return YES;//if (day1 >= day0) return NO;
        
        return NO;
    }

    return YES;
}

- (void)updateLastDB
{
    //UPDATE prop_tbl SET lastupdate_db='adfaff'
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DATE_FORMAT];
    
    NSDate *date = [NSDate date];
    NSString *stringDate = [formatter stringFromDate:date];
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE \"prop_tbl\" SET lastupdate_db='%@'", stringDate];
        
        const char *insert_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"%s Success in update last db", __PRETTY_FUNCTION__);
        } else {
            NSLog(@"%s Failed to update last db", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (KiStockData *)getStockDataById:(int32_t)uid
{
    return [dbLite.stockDictionaryById objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiStockData *)getStockDataByStock:(NSString *)code
{
    return [dbLite.stockDictionaryByStock objectForKey:code];
}

- (NSArray *)getStringStockData
{
    static NSArray *sortedStockData = nil;
    
    if (nil == sortedStockData) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        sortedStockData = [dbLite.stockDictionaryByStock.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    return sortedStockData;
}

- (void)storeStockData:(NSArray *)arrayStockData
{
    NSString *string = @"";
    for (KiStockData *s in arrayStockData) {
        [dbLite.stockDictionaryById setObject:s forKey:[NSNumber numberWithInt:s.id]];
        [dbLite.stockDictionaryByStock setObject:s forKey:s.code];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@', %i, '%@' UNION", s.id, s.code, s.name, s.clientType, s.color]];
    }
    
    // remove last 'UNION' word
    NSRange range= [string rangeOfString: @" UNION" options: NSBackwardsSearch];
    if (range.location > 0) {
        string = [string substringToIndex: range.location];
        
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"REPLACE INTO \"stockdata_tbl\" %@", string];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
//                NSLog(@"%s Success in store stock data", __PRETTY_FUNCTION__);
            } else {
                NSLog(@"%s Failed to store stock data", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
}

- (void)printStockData
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"stockdata_tbl\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
//                /*id*/    NSString *str0 = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//                /*code*/  NSString *str1 = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//                /*name*/  NSString *str2 = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//                /*type*/  NSString *str3 = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
//                /*color*/ NSString *str4 = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//                
//                NSLog(@"stock data: id=%@, code=%@, %@, %@, %@", str0, str1, str2, str3, str4);

                KiStockData_Builder *builder = [KiStockData builder];
                builder.id = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] intValue];
                builder.code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];;
                builder.name = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];;
                builder.clientType = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] intValue];
                builder.color = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
                
                KiStockData *stockData = [builder build];
                [dbLite.stockDictionaryById setObject:stockData forKey:[NSNumber numberWithInt:stockData.id]];
                [dbLite.stockDictionaryByStock setObject:stockData forKey:stockData.code];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
}

- (KiBrokerData *)getBrokerDataById:(int32_t)uid
{
    return [dbLite.brokerDictionaryById objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiBrokerData *)getBrokerDataByCode:(NSString *)code
{
    return [dbLite.brokerDictionaryByCode objectForKey:code];
}

- (void)storeBrokerData:(NSArray *)arrayBrokerData
{
    NSString *string = @"";
    for (KiBrokerData *b in arrayBrokerData) {
        [dbLite.brokerDictionaryById setObject:b forKey:[NSNumber numberWithInt:b.id]];
        [dbLite.brokerDictionaryByCode setObject:b forKey:b.code];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@', %u, '%u' UNION", b.id, b.code, b.name, b.status, b.type]];
    }
    
    // remove last 'UNION' word
    NSRange range= [string rangeOfString: @" UNION" options: NSBackwardsSearch];
    if (range.location > 0) {
        string = [string substringToIndex: range.location];
        
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"REPLACE INTO \"brokerdata_tbl\" %@", string];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
//                NSLog(@"%s Success in store broker data", __PRETTY_FUNCTION__);
            } else {
                NSLog(@"%s Failed to store broker data", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
}

- (void)printBrokerData
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"brokerdata_tbl\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                KiBrokerData_Builder *builder = [KiBrokerData builder];
                builder.id = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] intValue];
                builder.code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                builder.name = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                builder.status = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding] intValue];
                builder.type = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding] intValue];
                
                KiBrokerData *brokerData = [builder build];
                [dbLite.brokerDictionaryById setObject:brokerData forKey:[NSNumber numberWithInt:brokerData.id]];
                [dbLite.brokerDictionaryByCode setObject:brokerData forKey:brokerData.code];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
}

- (KiIndicesData *)getIndicesData:(uint32_t)uid
{
    return [dbLite.indicesDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (NSArray *)getIndicesDatas
{
    return dbLite.indicesDataDictionary.allValues;
}

- (void)storeIndicesData:(NSArray *)arrayIndicesData
{
    NSString *string = @"";
    for (KiIndicesData *i in arrayIndicesData) {
        [dbLite.indicesDataDictionary setObject:i forKey:[NSNumber numberWithInt:i.id]];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@' UNION", i.id, i.code]];
    }
    
    // remove last 'UNION' word
    NSRange range= [string rangeOfString: @" UNION" options: NSBackwardsSearch];
    if (range.location > 0) {
        string = [string substringToIndex: range.location];
        
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"REPLACE INTO \"indicesdata_tbl\" %@", string];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            } else {
                NSLog(@"%s Failed to store indices data", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
}

- (void)printIndicesData
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"indicesdata_tbl\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                KiIndicesData_Builder *builder = [KiIndicesData builder];
                builder.id = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] intValue];
                builder.code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                
                KiIndicesData *indicesData = [builder build];
                [dbLite.indicesDataDictionary setObject:indicesData forKey:[NSNumber numberWithInt:indicesData.id]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
}

- (KiCurrencyData *)getCurrencyData:(uint32_t)uid
{
    return [dbLite.currencyDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (void)storeCurrencyData:(NSArray *)arrayCurrencyData
{
    NSString *string = @"";
    for (KiCurrencyData *c in arrayCurrencyData) {
        [dbLite.currencyDataDictionary setObject:c forKey:[NSNumber numberWithInt:c.id]];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@' UNION", c.id, c.code, c.name]];
    }
    
    // remove last 'UNION' word
    NSRange range= [string rangeOfString: @" UNION" options: NSBackwardsSearch];
    if (range.location > 0) {
        string = [string substringToIndex: range.location];
        
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"REPLACE INTO \"currencydata_tbl\" %@", string];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            } else {
                NSLog(@"%s Failed to store currency data", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
}

- (void)printCurrencyData
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"currencydata_tbl\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                KiCurrencyData_Builder *builder = [KiCurrencyData builder];
                builder.id = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] intValue];
                builder.code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                builder.name = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                
                KiCurrencyData *currencyData = [builder build];
                [dbLite.currencyDataDictionary setObject:currencyData forKey:[NSNumber numberWithInt:currencyData.id]];
                
//                NSLog(@"currency data %i - %@ - %@", currencyData.id, currencyData.code, currencyData.name);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
}

- (KiRegionalIndicesData *)getRegionalIndicesDataById:(uint32_t)uid
{
    return [dbLite.regIndicesDataDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndicesData *)getRegionalIndicesDataByCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in dbLite.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return d;
        }
    }
    
    return  nil;
}

- (NSArray *)getRegionalIndicesData
{
    return dbLite.regIndicesDataDictionary.allValues;
}

- (void)storeRegionalIndicesData:(NSArray *)arrayRegionalIndicesData
{
    NSString *string = @"";
    for (KiRegionalIndicesData *r in arrayRegionalIndicesData) {
        [dbLite.currencyDataDictionary setObject:r forKey:[NSNumber numberWithInt:r.id]];
        
        string = [NSString stringWithFormat:@"%@ %@", string, [NSString stringWithFormat:@"SELECT %i, '%@', '%@', '%@' UNION", r.id, r.code, r.name, r.fullname]];
    }
    
    // remove last 'UNION' word
    NSRange range= [string rangeOfString: @" UNION" options: NSBackwardsSearch];
    if (range.location > 0) {
        string = [string substringToIndex: range.location];
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"REPLACE INTO \"regionalindicesdata_tbl\" %@", string];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            } else {
                NSLog(@"%s Failed to store currency data", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
}

- (void)printRegionalIndicesData
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"regionalindicesdata_tbl\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                KiRegionalIndicesData_Builder *builder = [KiRegionalIndicesData builder];
                builder.id = [[NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding] intValue];
                builder.code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                builder.name = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
                builder.fullname = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
                
                KiRegionalIndicesData *regIndicesData = [builder build];
                [dbLite.regIndicesDataDictionary setObject:regIndicesData forKey:[NSNumber numberWithInt:regIndicesData.id]];
                
//                NSLog(@"regional indices data %i - %@ - %@ - %@", regIndicesData.id, regIndicesData.code, regIndicesData.name, regIndicesData.fullname);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
}

- (BOOL)storeForeignDomesticStock:(NSString *)code
{
    BOOL status = NO;
    if (nil != code) {
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            //INSERT INTO "main"."fd_tbl" ("id") VALUES ('ISAT'), ('TLKM')
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO \"fd_tbl\" VALUES ('%@')", code.uppercaseString];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                if (nil == dbLite.foreignDomesticDictionary)
                    dbLite.foreignDomesticDictionary = [NSMutableDictionary dictionary];
        
                [dbLite.foreignDomesticDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
                
                status = YES;
            } else {
                NSLog(@"%s Failed to store foreign domestic stock %@", __PRETTY_FUNCTION__, code);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
    
    return status;
}

- (void)removeForeignDomesticStock:(NSString *)code
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        //DELETE FROM "main"."fd_tbl" WHERE "id" = 'adfaf'
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM \"fd_tbl\" WHERE \"id\" = '%@'", code.uppercaseString];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            if (nil != dbLite.foreignDomesticDictionary)
                [dbLite.foreignDomesticDictionary removeObjectForKey:code.uppercaseString];
            
        } else {
            NSLog(@"%s Failed to delete foreign domestic stock %@", __PRETTY_FUNCTION__, code);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (NSMutableDictionary *)getForeignDomesticDictionary
{
    return dbLite.foreignDomesticDictionary;
}

- (NSArray *)getForeignDomesticArray
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    NSMutableArray *mutable = [NSMutableArray array];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"fd_tbl\" ORDER BY `id` ASC";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (nil == dbLite.foreignDomesticDictionary)
                dbLite.foreignDomesticDictionary = [NSMutableDictionary dictionary];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                
                [dbLite.foreignDomesticDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
                [mutable addObject:code];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    
//    if (mutable.count > 0) {
//        return [mutable sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
//    }
    
    return mutable;
}

- (BOOL)storeWatchlistStock:(NSString *)code
{
    BOOL status = NO;
    if (nil != code) {
        
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO \"watchlist_tbl\" VALUES ('%@')", code.uppercaseString];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                if (nil == dbLite.watchlistDictionary)
                    dbLite.watchlistDictionary = [NSMutableDictionary dictionary];
                
                [dbLite.watchlistDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
                
                status = YES;
            } else {
                NSLog(@"%s Failed to store watchlist stock %@", __PRETTY_FUNCTION__, code);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }
    }
    
    return status;
}

- (void)removeWatchlistStock:(NSString *)code
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM \"watchlist_tbl\" WHERE \"id\" = '%@'", code.uppercaseString];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, delete_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            
            if (nil != dbLite.watchlistDictionary)
                [dbLite.watchlistDictionary removeObjectForKey:code.uppercaseString];
            
        } else {
            NSLog(@"%s Failed to delete watchlist stock %@", __PRETTY_FUNCTION__, code);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (NSArray *)getWatchlistArray
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    NSMutableArray *mutable = [NSMutableArray array];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"watchlist_tbl\" ORDER BY `id` ASC";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
            if (nil == dbLite.watchlistDictionary)
                dbLite.watchlistDictionary = [NSMutableDictionary dictionary];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                
                [dbLite.watchlistDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
                [mutable addObject:code];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    
    return mutable;
}

- (KiStockSummary *)getStockSummaryById:(uint32_t)uid
{
    return [dbLite getStockSummaryById:uid andBoard:BoardRg];
}

- (KiStockSummary *)getStockSummaryById:(uint32_t)uid andBoard:(Board)board
{
    return [dbLite.stockSummaryDictionaryById objectForKey:[NSString stringWithFormat:@"code:%i,board:%u", uid, board]];
}

- (KiStockSummary *)getStockSummaryByStock:(NSString *)code
{
    return [dbLite getStockSummaryByStock:code andBoard:BoardRg];
}

- (KiStockSummary *)getStockSummaryByStock:(NSString *)code andBoard:(Board)board
{
    return [dbLite.stockSummaryDictionaryByStock objectForKey:[NSString stringWithFormat:@"code:%@,board:%u", code, board]];
}

- (NSArray *)getStockSummaries
{
    return dbLite.stockSummaryDictionaryById.allValues;
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
        
//        if(s.stockSummary.board == BoardTn) {
//            NSLog(@"CODE NUMBER Tn: %i", s.codeId);
//        } else if(s.stockSummary.board == BoardNg) {
//            NSLog(@"CODE NUMBER Ng: %i", s.codeId);
//        }
        
//        //dev only
//        if(s.codeId == 1810) {
//            NSLog(@"## CODE: UNTR-R");
//        }
        
        KiStockSummary *tmp_s = [dbLite getStockSummaryById:s.codeId andBoard:s.stockSummary.board];
        if (nil != tmp_s) {
            dbLite.fdValue.d_buyvalue -= tmp_s.stockSummary.tradedValue - tmp_s.foreignValBought;
            dbLite.fdValue.d_sellvalue -= tmp_s.stockSummary.tradedValue - tmp_s.foreignValSold;
            dbLite.fdValue.f_buyvalue -= tmp_s.foreignValBought;
            dbLite.fdValue.f_sellvalue -= tmp_s.foreignValSold;
        }
        
        dbLite.fdValue.d_buyvalue += s.stockSummary.tradedValue - s.foreignValBought;
        dbLite.fdValue.d_sellvalue += s.stockSummary.tradedValue - s.foreignValSold;
        dbLite.fdValue.f_buyvalue += s.foreignValBought;
        dbLite.fdValue.f_sellvalue += s.foreignValSold;

        
        KiStockData *data = [dbLite getStockDataById:s.codeId];
        [dbLite.stockSummaryDictionaryById setObject:s forKey:[NSString stringWithFormat:@"code:%i,board:%u", s.codeId, s.stockSummary.board]];
        [dbLite.stockSummaryDictionaryByStock setObject:s forKey:[NSString stringWithFormat:@"code:%@,board:%u", data.code, s.stockSummary.board]];
    }
}

- (Transaction *)getBrokerSummaryById:(uint32_t)uid
{
    return [dbLite getBrokerSummaryById:uid andBoard:BoardRg];
}

- (Transaction *)getBrokerSummaryById:(uint32_t)uid andBoard:(Board)board
{
    return [dbLite.brokerSummaryDictionaryById objectForKey:[NSString stringWithFormat:@"code:%i,board:%u", uid, board]];
}

- (Transaction *)getBrokerSummaryByCode:(NSString *)code
{
    return [dbLite getBrokerSummaryByCode:code andBoard:BoardRg];
}

- (Transaction *)getBrokerSummaryByCode:(NSString *)code andBoard:(Board)board
{
    return [dbLite.brokerSummaryDictionaryByCode objectForKey:[NSString stringWithFormat:@"code:%@,board:%u", code, board]];
}

- (NSArray *)getBrokerSummaries
{
    return dbLite.brokerSummaryDictionaryById.allValues;
}

- (NSArray *)getBrokerSummariesByTVal:(NSArray *)arrayBrokerSummary
{
    if (nil == arrayBrokerSummary) return [NSArray array];
    
    NSArray *sortedSource = [arrayBrokerSummary sortedArrayUsingComparator:^(Transaction *a, Transaction *b) {
        float atval = 0;
        float btval = 0;
        
        float aValRG = 0, aValTN = 0, aValNG = 0;
        float bValRG = 0, bValTN = 0, bValNG = 0;
        
        Transaction *aRG = [dbLite getBrokerSummaryById:a.codeId andBoard:BoardRg];
        Transaction *aTN = [dbLite getBrokerSummaryById:a.codeId andBoard:BoardTn];
        Transaction *aNG = [dbLite getBrokerSummaryById:a.codeId andBoard:BoardNg];
        if(nil != aRG) {
            aValRG = aRG.buy.value + aRG.sell.value;
        }
        if(nil != aTN) {
            aValTN = aTN.buy.value + aTN.sell.value;
        }
        if(nil != aNG) {
            aValNG = aNG.buy.value + aNG.sell.value;
        }
        
        Transaction *bRG = [dbLite getBrokerSummaryById:b.codeId andBoard:BoardRg];
        Transaction *bTN = [dbLite getBrokerSummaryById:b.codeId andBoard:BoardTn];
        Transaction *bNG = [dbLite getBrokerSummaryById:b.codeId andBoard:BoardNg];
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
        KiBrokerData *b = [dbLite getBrokerDataById:t.codeId];
        [dbLite.brokerSummaryDictionaryById setObject:t forKey:[NSString stringWithFormat:@"code:%i,board:%u", t.codeId, t.board]];
        [dbLite.brokerSummaryDictionaryByCode setObject:t forKey:[NSString stringWithFormat:@"code:%@,board:%u", b.code, t.board]];
    }
}


- (KiIndices *)getIndicesById:(uint32_t)uid
{
    return [dbLite.indicesDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiIndices *)getIndicesCode:(NSString *)code
{
    if (nil != dbLite.indicesDataDictionary)
        for (KiIndicesData *d in dbLite.indicesDataDictionary.allValues) {
            if ([d.code isEqualToString:code]) {
                return  [dbLite getIndicesById:d.id];
            }
        }
    
    return nil;
}

- (NSArray *)getIndices
{
    return dbLite.indicesDictionary.allValues;
}

- (void)storeIndices:(NSArray *)arrayIndices
{
    for (KiIndices *i in arrayIndices) {
        [dbLite.indicesDictionary setObject:i forKey:[NSNumber numberWithInt:i.codeId]];
    }
}

- (KiRegionalIndices *)getRegionalIndicesById:(uint32_t)uid
{
    return [dbLite.regionalIndicesDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndices *)getRegionalIndicesCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in dbLite.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return [dbLite getRegionalIndicesById:d.id];
        }
    }
    
    return nil;
}

- (NSArray *)getRegionalIndices
{
    return dbLite.regionalIndicesDictionary.allValues;
}

- (void)storeRegionalIndices:(NSArray *)arrayRegionalIndices
{
    for (KiRegionalIndices *ri in arrayRegionalIndices) {
        [dbLite.regionalIndicesDictionary setObject:ri forKey:[NSNumber numberWithInt:ri.codeId]];
    }
}


- (KiRegionalIndices *)getFutureById:(uint32_t)uid
{
    return [dbLite.futureDictionary objectForKey:[NSNumber numberWithInt:uid]];
}

- (KiRegionalIndices *)getFutureCode:(NSString *)code
{
    for (KiRegionalIndicesData *d in dbLite.regIndicesDataDictionary.allValues) {
        if ([d.code isEqualToString:code]) {
            return [dbLite getFutureById:d.id];
        }
    }
    return nil;
}

- (NSArray *)getFutures
{
    return dbLite.futureDictionary.allValues;
}

- (void)storeFuture:(NSArray *)arrayFuture
{
    for (KiRegionalIndices *ri in arrayFuture) {
        [dbLite.futureDictionary setObject:ri forKey:[NSNumber numberWithInt:ri.codeId]];
    }
}


- (KiCurrency *)getCurrency:(uint32_t)uid against:(uint32_t)uidAgainst
{
    return [dbLite.currencyDictionary objectForKey:[NSString stringWithFormat:@"currCode:%i,currAgainst:%i", uid, uidAgainst]];
}

- (NSArray *)getCurrencies
{
    return dbLite.currencyDictionary.allValues;
}

- (void)storeCurrency:(NSArray *)arrayCurrency
{
    for (KiCurrency *c in arrayCurrency) {
        [dbLite.currencyDictionary setObject:c forKey:[NSString stringWithFormat:@"currCode:%i,currAgainst:%i", c.currCode, c.currAgainst]];
    }
}

- (void)storeUserid:(NSString *)userid
{   
    if (nil != userid) {
        sqlite3_stmt *statement;
        const char *dbpath = [dbLite.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
            
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE \"prop_tbl\" SET userid='%@'", userid];
            
            const char *stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(_myDatabase, stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
            }
            else {
                NSLog(@"%s Failed to store update userid", __PRETTY_FUNCTION__);
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_myDatabase);
        }

    }

}

- (NSString *)restoreUserid
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT \"userid\" FROM \"prop_tbl\" LIMIT 1";
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSString *userid = nil;
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                userid = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
        
        return userid;
    }
    
    return nil;
}

- (void)clearDictionary
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    
//    dbLite.fdValue.f_buyvalue = 0;
//    dbLite.fdValue.f_sellvalue = 0;
//    dbLite.fdValue.d_buyvalue = 0;
//    dbLite.fdValue.f_sellvalue = 0;
    dbLite.fdValue = nil;
    dbLite.fdValue = [[FDValue alloc] init];
    
    if (nil != dbLite.stockSummaryDictionaryById) {
        [dbLite.stockSummaryDictionaryById removeAllObjects];
    }
    
    if (nil != dbLite.stockSummaryDictionaryByStock) {
        [dbLite.stockSummaryDictionaryByStock removeAllObjects];
    }
    
    if (nil != dbLite.brokerSummaryDictionaryById) {
        [dbLite.brokerSummaryDictionaryById removeAllObjects];
    }
    
    if (nil != dbLite.brokerSummaryDictionaryByCode) {
        [dbLite.brokerSummaryDictionaryByCode removeAllObjects];
    }
    
    if (nil != dbLite.indicesDictionary) {
        [dbLite.indicesDictionary removeAllObjects];
    }
    
    if (nil != dbLite.regionalIndicesDictionary) {
        [dbLite.regionalIndicesDictionary removeAllObjects];
    }
    
    if (nil != dbLite.futureDictionary) {
        [dbLite.futureDictionary removeAllObjects];
    }
    
    if (nil != dbLite.currencyDictionary) {
        [dbLite.currencyDictionary removeAllObjects];
    }
}

- (void)readSetting
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT * FROM \"tbl_setting\" LIMIT 1";
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSString *res = nil;
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                res = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                dbLite.popupReceiveStatus = [res isEqualToString:@"1"] ? YES : NO;
                
                res = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
                dbLite.popupOrderStatus = [res isEqualToString:@"1"] ? YES : NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
        
    }
}

- (void)showPopupOrderStatus:(BOOL)status
{
    dbLite.popupOrderStatus = status;
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE \"tbl_setting\" SET popup_order_status=%@", status ? @"1" : @"0"];
        
        const char *insert_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"%s Success in update last db", __PRETTY_FUNCTION__);
        } else {
            NSLog(@"%s Failed to update popup order status", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (void)showPopupReceiveStatus:(BOOL)status
{
    dbLite.popupReceiveStatus = status;
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE \"tbl_setting\" SET popup_receive=%@", status ? @"1" : @"0"];
        
        const char *insert_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"%s Success in update last db", __PRETTY_FUNCTION__);
        } else {
            NSLog(@"%s Failed to update popup recieve", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}


- (void)insertLastDate
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        //        NSString *insertSQL = @"INSERT INTO \"tbl_date\" SET \"last_date\" = CURRENT_DATE;";
        //
        //        const char *insert_stmt = [insertSQL UTF8String];
        //        sqlite3_prepare_v2(_sqlite, insert_stmt, -1, &statement, NULL);
        //        if (sqlite3_step(statement) == SQLITE_DONE) {
        //        } else {
        //            NSLog(@"%s Failed to store insert last date", __PRETTY_FUNCTION__);
        //        }
        
        NSString *insertSQL = @"INSERT INTO \"tbl_date\" VALUES ( CURRENT_DATE )";
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
        } else {
            NSLog(@"%s Failed to store insert last date", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (void)updateLastDate
{
    //UPDATE \"tbl_date\" set \"last_date\" = CURRENT_DATE
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *updateSQL = @"UPDATE \"tbl_date\" set \"last_date\" = CURRENT_DATE";
        
        const char *insert_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"%s Success in update last db", __PRETTY_FUNCTION__);
        } else {
            NSLog(@"%s Failed to update last db", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}


#pragma mark
#pragma public method
- (void)emptyLog
{
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *emptySql = @"DELETE FROM tbl_log";
        
        const char *empty_stmt = [emptySql UTF8String];
        sqlite3_prepare_v2(_myDatabase, empty_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            //NSLog(@"%s Success in update last db", __PRETTY_FUNCTION__);
        } else {
            NSLog(@"%s Failed to delete(empty) db", __PRETTY_FUNCTION__);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
}

- (void)log:(NSString *)log
{
    NSLog(@"LOG:: %@", log);
    
//    if(log != nil) {
//        sqlite3_stmt *statement;
//        const char *dbpath = [dbLite.databasePath UTF8String];
//        
//        if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
//            
//            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO \"tbl_log\" (\"log_date\", \"log_string\") VALUES (CURRENT_TIME, '%@') ", log];
//            
//            const char *insert_stmt = [insertSQL UTF8String];
//            sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
//            uint32_t sqlStatus = sqlite3_step(statement);
//            if (sqlStatus == SQLITE_DONE) {
//                
//            } else {
//                NSLog(@"%s Failed to store log %@", __PRETTY_FUNCTION__, log);
//            }
//            
//            sqlite3_finalize(statement);
//            sqlite3_close(_myDatabase);
//        }
//    }
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO \"tbl_log\" (\"log_date\", \"log_string\") VALUES (CURRENT_TIME, '%@') ", log];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_myDatabase, insert_stmt, -1, &statement, NULL);
        uint32_t sqlStatus = sqlite3_step(statement);
        if (sqlStatus == SQLITE_DONE) {
            
        } else {
            NSLog(@"%s Failed to store log %@", __PRETTY_FUNCTION__, log);
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(_myDatabase);
    }
    
}

- (NSMutableArray *)log
{
    NSMutableArray *array = [NSMutableArray array];
//    sqlite3_stmt *statement;
//    const char *dbpath = [dbLite.databasePath UTF8String];
//    
//    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
//        NSString *querySQL = @"SELECT * FROM \"tbl_log\" ";
//        
//        const char *query_stmt = [querySQL UTF8String];
//        
//        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
//            uint32_t sqlStatus = sqlite3_step(statement);
//            if (sqlStatus == SQLITE_ROW) {
//                
//                LogValue *log = [[LogValue alloc] init];
//                log.date = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//                log.log = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//                
//                NSLog(@"STORAGE:: %@", log);
//                
//                [array addObject:log];
//            }
//            sqlite3_finalize(statement);
//        }
//        sqlite3_close(_myDatabase);
//    }
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        //NSString *querySQL = @"SELECT * FROM \"watchlist_tbl\" ORDER BY `id` ASC";
        NSString *querySQL = @"SELECT * FROM \"tbl_log\"";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            
//            if (nil == dbLite.watchlistDictionary)
//                dbLite.watchlistDictionary = [NSMutableDictionary dictionary];
            
            uint32_t sqlStatus = sqlite3_step(statement);
            while (sqlStatus == SQLITE_ROW) {
                
                NSString *code = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                NSLog(@"code: %@", code);
//                [dbLite.watchlistDictionary setObject:code.uppercaseString forKey:code.uppercaseString];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    
    return array;
}

#define DATE_FORMAT2 @"yyyy-MM-dd"

- (BOOL)shouldUpdate
{
    NSDate *date = nil;
    
    sqlite3_stmt *statement;
    const char *dbpath = [dbLite.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_myDatabase) == SQLITE_OK) {
        NSString *querySQL = @"SELECT last_date FROM \"tbl_date\" LIMIT 1";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_myDatabase, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *dateString = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
                
                //NSLog(@"%s LASATUPDATE %@", __PRETTY_FUNCTION__, dateString);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:DATE_FORMAT2];
                
                date = [formatter dateFromString:dateString];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_myDatabase);
    }
    
    if(date == nil) {
        [self insertLastDate];
    }
    else {
        NSDate *current = [NSDate date];
        if([current isLaterThan:date]) {
            [self emptyLog];
        }
    }
    
    return YES;
}


@end

@implementation LogValue

@end



@implementation FDValue

@end
