//
//  BuyStockPutPrice.m
//  Ciptadana
//
//  Created by Reyhan on 12/11/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "BuyStockPutPrice.h"

#import "BBRealTimeCurrencyFormatter.h"
#import "HKKScrollableGridView.h"
#import "StockWatchLevel2V3.h"
#import "UITextField+Addons.h"
#import "SystemAlert.h"
#import "ConstractOrder.h"


@interface BuyStockPutPrice () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *lot;
@property (weak, nonatomic) IBOutlet UITextField *orderPower;
@property (weak, nonatomic) IBOutlet UITextField *cash;
@property (weak, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (weak, nonatomic) IBOutlet UIView *level2Grid;
@property (strong, nonatomic) StockWatchLevel2V3 *level2;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@property Float64 recOrderPower;

@end

@implementation BuyStockPutPrice

- (void)viewWillDisappear:(BOOL)animated
{
    [[MarketFeed sharedInstance] unsubscribe:RecordTypeLevel2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.client.text = @"";
    
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        self.client.text = c.name;
        [[MarketTrade sharedInstance] subscribe:RecordTypeGetOrderPower requestType:RequestGet clientcode:c.clientcode];
    }
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.level2 = [[StockWatchLevel2V3 alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, self.level2Grid.frame.size.height)];
    self.level2Grid.backgroundColor = [UIColor clearColor];
    [self.level2Grid addSubview:self.level2.scrollView];
    
    self.price.delegate = self;
    
    self.stock.text = self.stockCode;
    self.navTitle.title = self.stockCode;
    
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
    if(data) {
        self.stock.textColor = UIColorFromHex(data.color);
        
        [[MarketFeed sharedInstance] subscribe:RecordTypeLevel2 status:RequestSubscribe code:data.code];
        
        if(self.level2) {
            [self.level2 updateLevel2:[NSArray array] data:data];
        }
    }
 
    
    [self.price initRightButtonKeyboardToolbar:@"Next" target:self selector:@selector(nextLot:)];
    [self.lot initRightButtonKeyboardToolbar:@"BUY" target:self selector:@selector(nextBuy:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private

- (void)updateLevel2:(NSArray *)level2
{
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
    [self.level2 updateLevel2:level2 data:data];
}

- (void)nextLot:(id)sender
{
    [self.lot becomeFirstResponder];
}

- (void)nextBuy:(id)sender
{
    [self.lot resignFirstResponder];
 
    ClientList *c = [[MarketTrade sharedInstance].getClients objectAtIndex:0];
    if(c) {
        int lot = 0;
        int price = 0;
        int share = 0;
        
        double value = price * lot * share;
        
        KiStockData *marginStock = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
        
        @try {
            share = [SysAdmin sharedInstance].loginFeed.lotSize;
            if(share <= 0)
                share = 100;
            lot = [self.numberFormatter numberFromString:self.lot.text].intValue;
            price = [self.numberFormatter numberFromString:self.price.text].intValue;
            self.cash.text = [NSString localizedStringWithFormat:@"%lu", (long)(lot * price * share)];
            
        } @catch (NSException *exception) {
            
        }
        
        if(self.price.text.length == 0) {
            [self error:@"Price is empty"];
        }
        else if(self.lot.text.length == 0) {
            [self error:@"Lot is empty"];
        }
        else if (value > self.recOrderPower) {
            [self error:[NSString stringWithFormat:@"You have not enough The Orderpower to buy %@", self.stockCode]];
        }
        else if(c.isMargin && marginStock.clientType != 33) {
            [self error:[NSString stringWithFormat:@"%@ is restricted for margin client", self.stockCode]];
        }
        else {
            SIAlertViewHandler ok = ^(SIAlertView *alertView) {
                [self composeMsgNew:c side:@"1" stock:self.stockCode price:price qty:lot];
                
                [self.navigationController popViewControllerAnimated:YES];
            };
            
            [[SystemAlert alertOKCancel:@"Confirm?" andMessage:@"All data entered correct?" handlerOk:ok handlerCancel:nil] show];
        }
    }
    else {
        [self error:@"Client List Not Found!"];
    }
}

//1=buy 2=sell 5=sell short M=margin
- (void)composeMsgNew:(ClientList*)client side:(NSString*)side stock:(NSString*)code price:(int)price qty:(int)lot
{
    NSLog(@"Compose New Msg ==> Client = %@, Stock = %@, Price = %i, Lot = %i", client.name, code, price, lot);
    
    LoginData *account = [SysAdmin sharedInstance].loginFeed;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMddhh:mm:ss"];
    
    NSMutableDictionary *op = [NSMutableDictionary dictionary];
    // Header
    [op setObject:@"D" forKey:O_MSGTYPE];
    [op setObject:account.username forKey:O_SENDERCOMPID];
    [op setObject:account.usertype forKey:O_SENDERSUBID];
    [op setObject:@"1" forKey:O_SENDERAPPID];
    [op setObject:[dateFormat stringFromDate:date] forKey:O_SENDINGTIME];//yyyyMMddhh:mm:ss
    
    // Body
    [op setObject:@"I" forKey:O_ACCOUNT];
    [op setObject:@"1" forKey:O_HANDLINST];
    [op setObject:code forKey:O_SYMBOL];
    [op setObject:@"0RG" forKey:O_SYMBOLSFX];
    [op setObject:side forKey:O_SIDE];
    [op setObject:[NSString stringWithFormat:@"%i", lot] forKey:O_ORDERQTY];
    
    NSDate *addAHour = [date dateByAddingTimeInterval:60*60];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    
    [op setObject:[NSString stringWithFormat:@"%i", price] forKey:O_PRICE];
    [op setObject:@"0" forKey:O_TIMEINFORCE];
    [op setObject:[dateFormat stringFromDate:addAHour] forKey:O_EXPIREDATE];
    [op setObject:client.sid forKey:O_COMPLIANCEID];
    [op setObject:client.clientcode forKey:O_CLIENTCODE];
    [op setObject:@"-10" forKey:O_BULKID];
    
    //[self SubmitOrderCallback:op];
    
    [[MarketTrade sharedInstance] composeMsg:op composeMsg:YES];
}

- (void)error:(NSString *)message
{
    [[SystemAlert alertError:message handler:nil] show];
}

#pragma mark - protected

- (void)recordCallback:(KiRecord *)record message:(NSString *)message response:(BOOL)ok
{
    if(record.recordType == RecordTypeLevel2) {
        [self updateLevel2:record.level2];
    }
}

- (void)tradeCallback:(TradingMessage *)tm message:(NSString *)message response:(BOOL)ok
{
    if(ok && tm) {
        if(tm.recType == RecordTypeGetOrderPower) {
            self.recOrderPower =  tm.recOrderPower;
            self.orderPower.text = [NSString localizedStringWithFormat:@"%.2f", self.recOrderPower];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.keyboardType == UIKeyboardTypeNumberPad) {
        [BBRealTimeCurrencyFormatter textField:textField shouldChangeCharactersInRange:range replacementString:string includeCurrencySymbol:NO];
        return NO;
    }
    
    if(textField == self.price || textField == self.lot) {
        
        NSUInteger lot = 0;
        NSUInteger price = 0;
        int share = 0;
        
        @try {
            share = [SysAdmin sharedInstance].loginFeed.lotSize;
            if(share <= 0)
                share = 100;
            lot = [self.numberFormatter numberFromString:self.lot.text].integerValue;
            price = [self.numberFormatter numberFromString:self.price.text].integerValue;
            self.cash.text = [NSString localizedStringWithFormat:@"%lu", (lot * price * share)];
            
        } @catch (NSException *exception) {
            
        }
    }
    
    return YES;
}

@end
