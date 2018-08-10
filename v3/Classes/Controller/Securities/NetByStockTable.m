//
//  NetByStockTable.m
//  Ciptadana
//
//  Created by Reyhan on 11/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NetByStockTable.h"

#import "NetByBrokerTable.h"

#import "SysAdmin.h"
#import "MarketData.h"
#import "ObjectBuilder.h"
#import "Util.h"
#import "NSString+Addons.h"

#define IDENTIFIER @"GridIdentifier"
#define IDENTIFIER_GRID @"kHKKScrollableGridTableCellViewScrollOffsetChanged"
#define IDENTIFIER_NOTIFICATION @"kNotificationUserInfoContentOffset"

static NSMutableDictionary * dictionaryStock;//untuk ngumpulin broker yg udh di query
static NSMutableDictionary * dictionaryTransactionStock;

@interface NetByStockTable() <HKKScrollableGridViewDataSource, HKKScrollableGridViewDelegate>

@property (strong, nonatomic) HKKScrollableGridView *scrollGrid;
@property (strong, nonatomic) NetByStockCell *gridHeader;
@property (strong, nonatomic) NSMutableArray *arrayTransaction;
@property (strong, nonatomic) NSMutableArray *indexarrayTransaction;


@property (assign, nonatomic) BOOL checkedRegular;
@property (assign, nonatomic) BOOL checkedNego;
@property (assign, nonatomic) BOOL checkedCash;

@end

@implementation NetByStockTable

#pragma public

- (id)initWithGridView:(HKKScrollableGridView *)gridView
{
    self = [super init];
    if(self) {
        self.scrollGrid = gridView;
        
        self.scrollGrid.dataSource = self;
        self.scrollGrid.delegate = self;
        self.scrollGrid.verticalBounce = YES;
        //self.gridView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0f];
        self.scrollGrid.backgroundColor = [UIColor clearColor];
        [self.scrollGrid registerClassForGridCellView:[NetByStockCell class] reuseIdentifier:IDENTIFIER];
        
        if(!dictionaryTransactionStock)
            dictionaryTransactionStock = [NSMutableDictionary dictionary];
        
        if(!dictionaryStock)
            dictionaryStock = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)newNetbuysell:(NetBuySell *)nbs stockData:(KiStockData *)data
{
    //[self updateNetbuysell:nbs brokerData:data];
    //[self.scrollGrid reloadData];
    [self refreshStock:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash];
}

- (void)updateNetbuysell:(NetBuySell *)nbs stockData:(KiStockData *)data
{
    //KiBrokerData *bk = [[MarketData sharedInstance] getBrokerDataById:nbs.codeId];
    
    BOOL same = NO;
    if (data.id == nbs.codeId)
        same = YES;
    
    NSMutableDictionary *dictionary = [dictionaryStock objectForKey:data.code];
    if(!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        [dictionaryStock setObject:dictionary forKey:data.code];
    }
    
    for (Transaction *t in nbs.transaction) {
        
        id key = [NSString stringWithFormat:@"%i-%u", t.codeId, nbs.board];
        Transaction3 *trx2 = [dictionaryTransactionStock objectForKey:key];
        
        if (nil == trx2) {
            trx2 = [[Transaction3 alloc] initWithTransaction:t andBoard:nbs.board];
            
            if (same)
                [dictionaryTransactionStock setObject:trx2 forKey:key];
        }
        else {
            trx2.tvalue = t.buy.value + t.sell.value;
            trx2.nvalue = t.buy.value - t.sell.value;
            trx2.tlot = t.buy.volume + t.sell.volume;
            trx2.nlot = t.buy.volume - t.sell.volume;
        }
        
        if (nil != trx2) {
            [dictionary setObject:trx2 forKey:key];
        }
    }
}

- (BOOL)refreshStock:(KiStockData *)data checkedRegular:(BOOL)checkedRegular checkedNego:(BOOL)checkedNego checkedCash:(BOOL)checkedCash
{
//    NSLog(@"checked Regular = %d",checkedRegular);
//    NSLog(@"checked Regular = %d",checkedNego);
//    NSLog(@"checked Regular = %d",checkedCash);
    
    self.checkedRegular = checkedRegular;
    self.checkedNego = checkedNego;
    self.checkedCash = checkedCash;
    
    NSLog(@"NetByStock Reguler = %d Nego = %d Cash = %d",self.checkedRegular,self.checkedNego,self.checkedCash);
    
    
    NSMutableDictionary *dictionary = [dictionaryStock objectForKey:data.code];
    if(dictionary) {
        [dictionaryTransactionStock removeAllObjects];
        dictionaryTransactionStock = nil;
        dictionaryTransactionStock = [NSMutableDictionary dictionaryWithObjects:dictionary.allValues forKeys:dictionary.allKeys];
        
        [self filterArrayTransaction];
        
        return YES;
    }
    else {
        [self.arrayTransaction removeAllObjects];
        [self.scrollGrid reloadData];
        [self filterArrayTransaction];
    }
    
    return NO;
}

#pragma mark HKKScrollableGridViewDelegate & HKKScrollableGridViewDataSource
- (NSUInteger)numberOfRowInScrollableGridView:(HKKScrollableGridView *)gridView
{
    if(self.arrayTransaction){
        return self.arrayTransaction.count;
    }
    return 0;
}

#define chg(close, prev) close - prev
#define chgprcnt(chg, prev) chg * 100 / prev

- (HKKScrollableGridTableCellView *)scrollableGridView:(HKKScrollableGridView *)gridView viewForRowIndex:(NSUInteger)rowIndex;
{
    NetByStockCell *cellView = (NetByStockCell *)[gridView dequeueReusableViewForRowIndex:rowIndex reuseIdentifier:IDENTIFIER];
    
    cellView.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
    cellView.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    cellView.callback = gridView.callback;
    
    cellView.index = rowIndex;
    
    if(rowIndex %2 == 0){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f0f0f0"];
    }
    else if(rowIndex % 2 == 1){
        cellView.backgroundColor = [ObjectBuilder colorWithHexString:@"f8f8f8"];
    }
    
    Transaction3 *t = [self.arrayTransaction objectAtIndex:rowIndex];
    KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataById:t.codeId];
    
    UILabel* label = cellView.fixedLabelInit;
    label.text = [NSString stringWithFormat:@"    %@", data.code];
    label.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
    
    
    
    UIView* scrollAreaView = cellView.scrollableAreaViewInit;
    for(int n = 1; n <= 5; n ++) {
        UILabel *label = [scrollAreaView viewWithTag:n];
        label.font = FONT_TITLE_LABEL_CELL;
        
        int32_t lotSize = [[SysAdmin sharedInstance] sysAdminData].lotSize;
        if(lotSize <= 0) lotSize = 100;
        
        if(n == 1){
            label.text = [self currencySimplyfy:t.tvalue];
            [label setFrame:CGRectMake(0, -3, 60, 28)];
        }
        else if(n == 2){
            label.text = [NSString localizedStringWithFormat:@"%.2lld", t.tlot/lotSize];
            [label setFrame:CGRectMake(60, -3, 60, 28) ];
        }
        else if(n == 3){
            label.text = [self currencySimplyfy:t.nvalue];
            [label setFrame:CGRectMake(125, -3, 60, 28)];
        }
        else if(n == 4){
            label.text = [NSString localizedStringWithFormat:@"%.2lld", t.nlot/lotSize];
            [label setFrame:CGRectMake(175, -3, 60, 28)];
        }
//        else if(n == 5) label.text = [NSString localizedStringWithFormat:@"%.2lld", t.tfreq];
        
        label.text = [label.text replacingWithPattern:@"-" withTemplate:@"" error:nil];
        
        if(t.nlot > 0)
            label.textColor = GREEN;
        else if(t.nlot < 0)
            label.textColor = RED;
        else
            label.textColor = YELLOW;
    }
    
//    [cellView ]
//    [checkBoxRegular addTarget:self action:@selector(actionCheckBoxRegular) forControlEvents:UIControlEventTouchUpInside];
    
    return cellView;
}

- (NSString *)currencySimplyfy:(double)currency
{
    if(fabs(currency) > 1000000000)
        return [NSString localizedStringWithFormat:@"%.2fB", (currency / 1000000000)];
    else if(fabs(currency) > 1000000)
        return [NSString localizedStringWithFormat:@"%.2fM", (currency / 1000000)];
    else if(fabs(currency) > 1000)
        return [NSString localizedStringWithFormat:@"%.2fK", (currency / 1000)];
    
    return [NSString localizedStringWithFormat:@"%.2f", currency];
}

- (CGFloat)widthOfFixedAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 60.0f;
}

- (CGFloat)widthOfScrollableAreaForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 275.f;
}

- (HKKScrollableGridTableCellView *)viewForHeaderForScrollableGridView:(HKKScrollableGridView *)gridView
{
    return self.gridHeaderViewInit;
}

- (CGFloat)heightForHeaderViewOfScrollableGridView:(HKKScrollableGridView *)gridView
{
    return 28.0f;
}
- (CGFloat)scrollableGridView:(HKKScrollableGridView *)gridView heightForRowIndex:(NSUInteger)rowIndex
{
    return 20.0f;
}
- (NetByStockCell *)gridHeaderViewInit
{
    if (self.gridHeader == nil) {
        self.gridHeader = [[NetByStockCell alloc] init];
    }
    return self.gridHeader;
}

#pragma mark - private

- (void)filterArrayTransaction
{
    
    NSInteger count = 0;
    if(dictionaryTransactionStock) {
        
        self.arrayTransaction = nil;
        self.arrayTransaction = [NSMutableArray array];
        
        
        for(Transaction3 *t2 in dictionaryTransactionStock.allValues) {
            
            Transaction3 *tmpT2 = [[Transaction3 alloc] init];
            tmpT2.codeId = t2.codeId;
            tmpT2.tlot = t2.tlot;
            tmpT2.tvalue = t2.tvalue;
            tmpT2.nlot = t2.nlot;
            tmpT2.nvalue = t2.nvalue;
            tmpT2.board = t2.board;
            tmpT2.tfreq = t2.tfreq;
            
           
            if( (self.checkedRegular && tmpT2.board == BoardRg) || (self.checkedNego && tmpT2.board == BoardNg) || (self.checkedCash && tmpT2.board == BoardTn) ){
                [self.arrayTransaction addObject:tmpT2];
            }
            
            [self sortByBroker:true];
            
            count ++;
           
        }
        
        [self SummarizeRegulerNegoCash];
        [self.scrollGrid reloadData];
    }
}

- (NSMutableArray *) getArrayTransaction:(NSInteger) index{
   Transaction3 *t =  [_arrayTransaction objectAtIndex:index];
   KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataById:t.codeId];
    
    data.type == InvestorTypeD ? BLACK : MAGENTA;
    
    int32_t lotSize = [[SysAdmin sharedInstance] sysAdminData].lotSize;
    if(lotSize <= 0) lotSize = 100;
    
//    else if(n == 2) label.text = [NSString localizedStringWithFormat:@"%.2lld", t.tlot/lotSize];
//    else if(n == 3) label.text = [self currencySimplyfy:t.nvalue];
//    else if(n == 4) label.text = [NSString localizedStringWithFormat:@"%.2lld", t.nlot/lotSize];
//    else if(n == 5) label.text = [NSString localizedStringWithFormat:@"%.2lld", t.tfreq];
    UIColor *colorNVal;
    if(t.nlot > 0)
        colorNVal = GREEN;
    else if(t.nlot < 0)
        colorNVal = RED;
    else
        colorNVal = YELLOW;
    
   
   NSMutableArray *result = [NSMutableArray array];
   [result addObject:data.code];
   [result addObject:data.name];
   [result addObject:[self currencySimplyfy:t.tvalue]];
   [result addObject:[NSString localizedStringWithFormat:@"%.2lld", t.tlot/lotSize]];
   [result addObject:[self currencySimplyfy:t.nvalue]];
   [result addObject:[NSString localizedStringWithFormat:@"%.2lld", t.nlot/lotSize]];
   [result addObject:[NSString localizedStringWithFormat:@"%.2lld", t.tfreq]];
   [result addObject:data.type == InvestorTypeD ? BLACK : MAGENTA];
   [result addObject:colorNVal];
    
    return result;
}

- (void) SummarizeRegulerNegoCash
{
    int total = [self.arrayTransaction count]-1;
    for(int i=0;i<total;i++){
        Transaction3 *tmpT1 = [[Transaction3 alloc] init];
        Transaction3 *tmpT2 = [[Transaction3 alloc] init];
        
        tmpT1 = [self.arrayTransaction objectAtIndex:i];
        tmpT2 = [self.arrayTransaction objectAtIndex:i+1];
        
        KiBrokerData *data1 = [[MarketData sharedInstance] getBrokerDataById:tmpT1.codeId];
        KiBrokerData *data2 = [[MarketData sharedInstance] getBrokerDataById:tmpT2.codeId];
        
        if([data1.code isEqualToString:data2.code]){
            tmpT1.tvalue += tmpT2.tvalue;
            tmpT1.tlot += tmpT2.tlot;
            tmpT1.nvalue += tmpT2.nvalue;
            tmpT1.nlot += tmpT2.nlot;
            
            [self.arrayTransaction replaceObjectAtIndex:i withObject:tmpT1];
            [self.arrayTransaction removeObjectAtIndex:i+1];
            total --;
        }
        
    }
}

- (void)sortByBroker:(BOOL)ascending
{
    if(nil != self.arrayTransaction) {
        NSArray *arraySource = [self.arrayTransaction subarrayWithRange:NSMakeRange(0, self.arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction3 *a, Transaction3 *b) {
                
//                KiStockData *d1 = [[MarketData sharedInstance] getStockDataById:a.codeId];
//                KiStockData *d2 = [[MarketData sharedInstance] getStockDataById:b.codeId];
                
                KiBrokerData *d1 = [[MarketData sharedInstance] getBrokerDataById:a.codeId];
                KiBrokerData *d2 = [[MarketData sharedInstance] getBrokerDataById:b.codeId];
                
               
                if(!ascending) {
                    NSComparisonResult result =  [d1.code compare:d2.code];
                    if (result == (NSComparisonResult)NSOrderedDescending) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if (result == (NSComparisonResult)NSOrderedAscending) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                
                
                return ([d1.code compare:d2.code]);
            }];
            
            [self.arrayTransaction removeAllObjects];
            [self.arrayTransaction addObjectsFromArray:arraySort];
            //[self.scrollGrid reloadData];
        }
    }
}

- (void)sortByTval:(BOOL)ascending
{
    if(nil != self.arrayTransaction) {
        NSArray *arraySource = [self.arrayTransaction subarrayWithRange:NSMakeRange(0, self.arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction3 *a, Transaction3 *b) {
                
                if(ascending) {
                    if((a.tvalue) > (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tvalue) < (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.tvalue) < (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tvalue) > (b.tvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [self.arrayTransaction removeAllObjects];
            [self.arrayTransaction addObjectsFromArray:arraySort];
            //[self.scrollGrid reloadData];
        }
        
        
    }
}

- (void)sortByTlot:(BOOL)ascending
{
    if(nil != self.arrayTransaction) {
        NSArray *arraySource = [self.arrayTransaction subarrayWithRange:NSMakeRange(0, self.arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction3 *a, Transaction3 *b) {
                
                if(ascending) {
                    if((a.tlot) > (b.tlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tlot) < (b.tlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.tlot) < (b.tlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.tlot) > (b.tlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [self.arrayTransaction removeAllObjects];
            [self.arrayTransaction addObjectsFromArray:arraySort];
            //[self.scrollGrid reloadData];
        }
        
        
    }
}

- (void)sortByNval:(BOOL)ascending
{
    if(nil != self.arrayTransaction) {
        NSArray *arraySource = [self.arrayTransaction subarrayWithRange:NSMakeRange(0, self.arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction3 *a, Transaction3 *b) {
                
                if(ascending) {
                    if((a.nvalue) > (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nvalue) < (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                else {
                    if((a.nvalue) < (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nvalue) > (b.nvalue)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [self.arrayTransaction removeAllObjects];
            [self.arrayTransaction addObjectsFromArray:arraySort];
            //[self.scrollGrid reloadData];
        }
        
    }
    
}

- (void)sortByNlot:(BOOL)ascending
{
    if(nil != self.arrayTransaction) {
        NSArray *arraySource = [self.arrayTransaction subarrayWithRange:NSMakeRange(0, self.arrayTransaction.count)];
        if(arraySource.count > 1) {
            NSArray *arraySort = [arraySource sortedArrayUsingComparator:^(Transaction3 *a, Transaction3 *b) {
                
                if(ascending) {
                    if((a.nlot) > (b.nlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nlot) < (b.nlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                }
                else {
                    if((a.nlot) < (b.nlot)) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }
                    else if((a.nlot) > (b.nlot)) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    
                }
                
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            [self.arrayTransaction removeAllObjects];
            [self.arrayTransaction addObjectsFromArray:arraySort];
            //[self.scrollGrid reloadData];
        }
        
        
    }    
}

@end


@interface NetByStockCell()

@property (nonatomic, strong) UILabel* fixedLabel;
@property (nonatomic, readwrite) UIView* scrollableAreaView;

@end

@implementation NetByStockCell

- (id)init
{
    self  = [super init];
    if(self) {
        self.kHKKScrollableOffsetChanged = IDENTIFIER_GRID;
        self.kNotifiticationUserInfoContentOffset = IDENTIFIER_NOTIFICATION;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.fixedLabelInit.frame = self.fixedView.bounds;
    self.scrollableAreaViewInit.frame = self.scrolledContentView.bounds;
    
}

- (UILabel *)fixedLabelInit
{
    if (self.fixedLabel == nil) {
        self.fixedLabel = [ObjectBuilder createGridHeaderLabel:CGRectMake(0, 0, 100, 28) withLabel:@"   BROKER" andTag:0];
        self.fixedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.fixedLabel.textAlignment = NSTextAlignmentLeft;
        self.fixedLabel.adjustsFontSizeToFitWidth = YES;
        //self.fixedLabel.backgroundColor = [UIColor lightGrayColor];
        self.fixedLabel.backgroundColor = [UIColor clearColor];
        [self.fixedView addSubview:self.fixedLabel];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.fixedView addGestureRecognizer:singleFingerTap];
    }
    return self.fixedLabel;
}

- (UIView*)scrollableAreaViewInit
{
    if (self.scrollableAreaView == nil) {
        //self.scrollAreaView = [[UILabel alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView = [[UIView alloc] initWithFrame:self.scrolledContentView.bounds];
        self.scrollableAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollableAreaView.backgroundColor = [UIColor clearColor];
        
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(0, 0, 60, 28) withLabel:@"T Val" andTag:1]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(60, 0, 60, 28) withLabel:@"T Lot" andTag:2]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(125, 0, 60, 28) withLabel:@"N Val" andTag:3]];
        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(175, 0, 60, 28) withLabel:@"N Lot" andTag:4]];
//        [self.scrollableAreaView addSubview:[ObjectBuilder createGridLabel:CGRectMake(200, 0, 60, 28) withLabel:@"T Freq" andTag:5]];
        
        ((UILabel*)[self.scrollableAreaView viewWithTag:1]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:2]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:3]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:4]).textAlignment = NSTextAlignmentRight;
        ((UILabel*)[self.scrollableAreaView viewWithTag:5]).textAlignment = NSTextAlignmentRight;
        
        [self.scrolledContentView addSubview:self.scrollableAreaView];
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        
        [self.scrolledContentView addGestureRecognizer:singleFingerTap];

    }
    return self.scrollableAreaView;
}

- (void) handleSingleTap: (UITapGestureRecognizer *) recognizer
{
    if(self.callback){
        self.callback(self.index,self.summary);
    }
    NSLog(@"Tap");
}

@end