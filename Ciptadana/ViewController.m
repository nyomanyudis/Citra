//
//  ViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "ViewController.h"
#import "ImageResources.h"
#import "ChannelViewController.h"
#import "AppDelegate.h"
#import "UIColor+ColorStyle.h"
#import "Setting.h"

#import "Scroll1View.h"
#import "TabViewController.h"
#import "RegionalSummaryViewController.h"
#import "NewsViewController.h"
#import "LoggerViewController.h"
#import "LoginMiViewController.h"
#import "EntryCashWithdrawController.h"
#import "DepositWithdrawController.h"
#import "FirstChangeController.h"

#import "UIBAlertView.h"

#import "AgentFeed.h"
#import "HTTPAsync.h"

#import <QuartzCore/QuartzCore.h>

#import "Calendar.h"


#define CHOICES @[@"Indices", @"Regional Indices", @"Future"]
//#define NEWS_URL @"http://core.ciptadana.com/ciptami/news/webservice/idxnews?psv=1&date="

#define MAXBROKER 20
#define CODE_1 @"DJIA"
#define CODE_2 @"SNI"


@interface ViewController () <UIDropListDelegate, ChannelViewControllerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextViewDelegate>
{
    __weak IBOutlet UIBarButtonItem *citraBarItem;
}

@property (strong, nonatomic) UITableView *topstock;
//@property (strong, nonatomic) UITableView *toploser;
@property (strong, nonatomic) UITableView *topbroker;
@property (strong, nonatomic) Scroll1View *view1;

@property (nonatomic) NSTimer *sortScheduler;
@property (nonatomic) NSTimer *bannerScheduler;
@property (nonatomic) NSTimer *shiftCurrencyScheduler;

@property (strong, nonatomic) UIDropList *topstokDroplist;
@property (strong, nonatomic) NSArray *topStockByHttp;
//@property (strong, nonatomic) NSArray *topLoserByHttp;
@property (strong, nonatomic) NSArray *topBrokerByHttp;
@property (strong, nonatomic) NSString *baseURL;
//@property (strong, nonatomic) NSMutableDictionary *indicesDictionary;
//@property (strong, nonatomic) NSMutableDictionary *regionalDictionary;
//@property (strong, nonatomic) NSMutableDictionary *futureDictionary;
@property (assign, nonatomic) NSInteger httpIndexReq;
@property (strong, nonatomic) NSArray *currencyArray;
@property (strong, nonatomic) NSTimer *httpSysAdminTimer;

@property (strong, nonatomic) UIHomeTopStockCell *topstockHeaderCell;
@property (strong, nonatomic) UIHomeTopBrokerCell *topbrokerHeaderCell;

@property (strong, nonatomic) UITextView *hiddenText;

@property NSNumberFormatter *formatter2comma;

@end


@implementation ViewController
{
    KiIndices *indicesIhsg;
    NSMutableDictionary *dictionary;//drop list
    NSArray *arrayTopStock;
    NSArray *arrayTopLoser;
    NSArray *arrayBroker;
    
    float lo;//stock lowest change
    
//    int low_chg;
//    int low_tval;
    int tag;
    
//    BOOL isDisconnected;
}

@synthesize iconBarItem, actionBarItem;
@synthesize leftPriceLabel, rightPriceLabel;
@synthesize leftImageView, rightImageView;
@synthesize leftButton, rightButton;
@synthesize leftCodeLabel, rightCodeLabel;
@synthesize leftValueLabel, rightValueLabel;
@synthesize leftValuePersenLabel, rightValuePersenLabel;
@synthesize pagecontrol, scrollview;
@synthesize topstockHeaderCell, topbrokerHeaderCell;

@synthesize topstock, topbroker, view1, topstokDroplist;


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (nil != self.sortScheduler) {
        [self.sortScheduler invalidate];
        self.sortScheduler = nil;
    }
    
    if (nil != self.shiftCurrencyScheduler) {
        [self.shiftCurrencyScheduler invalidate];
        self.shiftCurrencyScheduler = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    RegionalSummaryPacket *p1 = [self packet:0];
//    RegionalSummaryPacket *p2 = [self packet:1];
//    
//    if(nil != p1 && nil != p2) {
//        if([p1.code isEqualToString:CODE_1] && [p2.code isEqualToString:CODE_2]) {
//            if(nil == self.bannerScheduler)
//                self.bannerScheduler = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(refreshDefaultRegional) userInfo:nil repeats:YES];
//        }
//    }
    
    if (nil == self.sortScheduler)
        self.sortScheduler = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scheduler) userInfo:nil repeats:YES];
    
    if ([AgentTrade sharedInstance].loginMI) {
        //NSLog(@"##LOGIN STATE");
        [[AgentFeed sharedInstance] agentHomeSelector:@selector(AgentFeedCallback:) withObject:self];
        if(nil == self.shiftCurrencyScheduler)
            self.shiftCurrencyScheduler = [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(shiftCurrency) userInfo:nil repeats:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonImage = [ImageResources imageCiptadana];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonCiptadanaClicked:) forControlEvents:UIControlEventTouchUpInside];
    [iconBarItem setCustomView:button];
    
    buttonImage = [ImageResources imageHome];
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)];
    [buttonAction setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [buttonAction addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [actionBarItem setCustomView:buttonAction];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSLog(@"=====major version: %@", majorVersion);
//    NSLog(@"=====minor version: %@", minorVersion);
    
    citraBarItem.title = [NSString stringWithFormat:@"CITRA %@", version];
    
    [leftButton arrayList:CHOICES withTitleCallback:NO];
    leftButton.dropDelegate = self;
    leftButton.tag = 0;
    
    [rightButton arrayList:CHOICES withTitleCallback:NO];
    rightButton.dropDelegate = self;
    rightButton.tag = 1;
    
    CGRect frame1 = scrollview.frame;
    frame1.origin.x = frame1.size.width;
    CGRect frame2 = frame1;
    frame2.origin.x += frame1.size.width;
//    CGRect frame3 = frame2;
//    frame3.origin.x += frame2.size.width;
    
    topstokDroplist = [[UIDropList alloc] initWithFrame:CGRectMake(20, 0, 280, 30)];
    [topstokDroplist arrayList:@[@" Top Gainer", @" Top Loser", @" Top Value", @" Most Active"]];
    [topstokDroplist showRightIcon:YES];
    [topstokDroplist setTitle:@" Top Gainer" forState:UIControlStateNormal];
    [topstokDroplist setDropDelegate:self];
    
    topstock = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    topstock.backgroundColor = [UIColor blackColor];
    topstock.rowHeight = 24;
    topstock.sectionHeaderHeight = 24;
    topstock.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    topstock.delegate = self;
    topstock.dataSource = self;
    topstock.frame = CGRectMake(0, topstokDroplist.frame.size.height + 5, topstock.frame.size.width, scrollview.frame.size.height-15);
    
//    toploser = [[UITableView alloc] initWithFrame:frame2 style:UITableViewStylePlain];
//    toploser.backgroundColor = [UIColor blackColor];
//    toploser.rowHeight = 24;
//    toploser.sectionHeaderHeight = 24;
//    toploser.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
//    toploser.delegate = self;
//    toploser.dataSource = self;
    
    UIView *tab2 = [[UIView alloc] initWithFrame:self.view.frame];
    [tab2 addSubview:topstokDroplist];
    [tab2 addSubview:topstock];
    [tab2 setUserInteractionEnabled:YES];
    [tab2 setFrame:CGRectMake(frame1.origin.x, frame1.origin.y, tab2.frame.size.width, tab2.frame.size.height)];
    
    topbroker = [[UITableView alloc] initWithFrame:frame2 style:UITableViewStylePlain];
    topbroker.backgroundColor = [UIColor blackColor];
    topbroker.rowHeight = 24;
    topbroker.sectionHeaderHeight = 24;
    topbroker.separatorColor = [UIColor colorWithPatternImage:separatorImage()];
    topbroker.delegate = self;
    topbroker.dataSource = self;
    
    view1 = [[Scroll1View alloc] initWithParent:self];
    
    RegionalSummaryPacket *p1 = [[RegionalSummaryPacket alloc] initWithPacket:CODE_1 price:0 chg:0 chgp:0 channel:ChanelClear]; //left
    RegionalSummaryPacket *p2 = [[RegionalSummaryPacket alloc] initWithPacket:CODE_2 price:0 chg:0 chgp:0 channel:ChanelClear]; //right
    
    [p1 initLabel:leftCodeLabel price:leftPriceLabel chg:leftValueLabel chgp:leftValuePersenLabel img:leftImageView droplist:leftButton];
    [p2 initLabel:rightCodeLabel price:rightPriceLabel chg:rightValueLabel chgp:rightValuePersenLabel img:rightImageView droplist:rightButton];
    
    p1.channel = ChannelRegionalIndices;
    p2.channel = ChannelRegionalIndices;
    
    //NSLog(@"## TAG 0 %d, TAG 1 %d", (int)p1.droplist.tag, (int)p2.droplist.tag);
    
    dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:p1 forKey:[NSNumber numberWithInt:(int)p1.droplist.tag]];
    [dictionary setObject:p2 forKey:[NSNumber numberWithInt:(int)p2.droplist.tag]];
    
    [scrollview addSubview:view1];
    [scrollview addSubview:tab2];
//    [scrollview addSubview:toploser];
    [scrollview addSubview:topbroker];
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * pagecontrol.numberOfPages, scrollview.frame.size.height);
    scrollview.delegate = self;
    
    self.formatter2comma = [[NSNumberFormatter alloc] init];
    [self.formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [self.formatter2comma setMaximumFractionDigits:2];
    [self.formatter2comma setMinimumFractionDigits:2];
    [self.formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [self.formatter2comma setDecimalSeparator:@"."];
    [self.formatter2comma setGroupingSeparator:@","];
    [self.formatter2comma setAllowsFloats:YES];
    
//    [[AgentFeed createAgentMarketInstance] startAgent];
//    [[AgentFeed sharedInstance] startAgent];
    [[AgentFeed sharedInstance] agentHomeSelector:@selector(AgentFeedCallback:) withObject:self];
    
    if (nil == self.sortScheduler)
        self.sortScheduler = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scheduler) userInfo:nil repeats:YES];

    if(nil == self.bannerScheduler)
        self.bannerScheduler = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshDefaultRegional) userInfo:nil repeats:YES];
    
//    if(nil == self.shiftCurrencyScheduler)
//        self.shiftCurrencyScheduler = [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(shiftCurrency) userInfo:nil repeats:YES];
    
    [self httpSysAdmin];
    
    self.hiddenText = [[UITextView alloc] init];
    self.hiddenText.hidden = YES;
    self.hiddenText.delegate = self;
    [self.view addSubview:self.hiddenText];
}

- (void)startCallback
{
    [[AgentFeed sharedInstance] agentHomeSelector:@selector(AgentFeedCallback:) withObject:self];
}

- (void)scheduler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([AgentTrade sharedInstance].loginMI) {
            
            DBLite *db = [DBLite sharedInstance];
            //arrayTopStock = [db getStockSummaryByChgPercent:db.getStockSummaries];
            arrayTopLoser = [db getStockSummaryByChgPercentNegasi:db.getStockSummaries];
            arrayBroker = [db getBrokerSummariesByTVal:db.getBrokerSummaries];
            
            if(0 == topstokDroplist.selectedIndex)
                arrayTopStock = [db getStockSummaryByChgPercent:db.getStockSummaries];
            else if(1 == topstokDroplist.selectedIndex)
                arrayTopStock = [db getStockSummaryByChgPercentNegasi:db.getStockSummaries];
            else if(2 == topstokDroplist.selectedIndex)
                arrayTopStock = [db getStockSummaryByValue:db.getStockSummaries];
            else if(3 == topstokDroplist.selectedIndex)
                arrayTopStock = [db getStockSummaryByFrequency:db.getStockSummaries];
            
            self.topStockByHttp = nil;
//            self.topLoserByHttp = nil;
            self.topBrokerByHttp = nil;
            
            [topstock reloadData];
//            [toploser reloadData];
            [topbroker reloadData];
        }
    });
}

- (KiIndices *)indicesIhsg
{
    return indicesIhsg;
}

//UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextView *)textField {
    [textField resignFirstResponder];
    NSLog(@"1. isinya adalah: %@", textField.text);
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        NSLog(@"2. isinya adalah: %@", textView.text);
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}
//end-

- (IBAction)citraAction:(id)sender
{
    NSLog(@"-CITRA begin-");
    
    self.hiddenText.text = @"";
    
    if(self.hiddenText.hidden)
        [self.hiddenText becomeFirstResponder];
    else
        [self.hiddenText resignFirstResponder];
    
    self.hiddenText.hidden = !self.hiddenText.hidden;
    
    NSLog(@"-CITRA end-");
}

- (void)buttonCiptadanaClicked:(id)sender
{
    LoggerViewController *c = [[LoggerViewController alloc] init];
    [self presentViewController:c animated:YES completion:nil];
}

- (void)actionButtonClicked:(id)sender
{
    
//    LoginData *accountMi = [(AppDelegate *)[[UIApplication sharedApplication] delegate] accountMi];
    LoginData *accountMi = [AgentTrade sharedInstance].loginDataFeed;
    if([AgentTrade sharedInstance].forceChange) {
        FirstChangeController *vc = [[FirstChangeController alloc] initWithNibName:@"FirstChangeController" bundle:[NSBundle mainBundle]];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else if(nil == accountMi) {
//        BOOL b =[AgentTrade sharedInstance].forceChange;
//        if([AgentTrade sharedInstance].forceChange) {
//            FirstChangeController *vc = [[FirstChangeController alloc] initWithNibName:@"FirstChangeController" bundle:[NSBundle mainBundle]];
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
//            [self presentViewController:vc animated:YES completion:nil];
//        }
//        else {
        AppDelegate *delegate = ((AppDelegate *)[[UIApplication sharedApplication] delegate]);
        if(delegate.userid != nil && delegate.passwd != nil && delegate.stringDate != nil && [delegate.stringDate isEqualToString:[Calendar currentStringDate]]) {
            LoginMiViewController *vc = [[LoginMiViewController alloc] initWithNibName:@"LoginMiViewController" bundle:[NSBundle mainBundle]];
//            UIView *top = [[UIView alloc] initWithFrame:vc.view.frame];
//            top.backgroundColor = [UIColor blackColor];
//            [vc.view addSubview:top];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
            [self presentViewController:vc animated:YES completion:nil];
            
            [vc autoLoginWithUserid:delegate.userid andPasswd:delegate.passwd];
        }
        else {
            LoginMiViewController *vc = [[LoginMiViewController alloc] initWithNibName:@"LoginMiViewController" bundle:[NSBundle mainBundle]];
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
            [self presentViewController:vc animated:YES completion:nil];
        }
//        }
    }
    else {
        TabViewController *c = [[TabViewController alloc] initWithNibName:@"TabViewController" bundle:[NSBundle mainBundle]];
        [self presentViewController:c animated:YES completion:nil];
    }
    
//    EntryCashWithdrawController *c = [[EntryCashWithdrawController alloc] initWithNibName:@"EntryCashWithdrawController" bundle:[NSBundle mainBundle]];
//    c.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    c.modalPresentationStyle = UIModalPresentationCurrentContext;//UIModalPresentationFormSheet;
//    [self presentViewController:c animated:YES completion:nil];
    
//    DepositWithdrawController *c = [[DepositWithdrawController alloc] initWithNibName:@"DepositWithdrawController" bundle:[NSBundle mainBundle]];
//    c.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    c.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentViewController:c animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    [self setLeftImageView:nil];
    [self setLeftCodeLabel:nil];
    [self setLeftValueLabel:nil];
    [self setLeftValuePersenLabel:nil];
    [self setRightBarButtonItem:nil];
    [self setLeftButton:nil];
    [self setRightButton:nil];
    [self setScrollview:nil];
    [self setPagecontrol:nil];
    [self setLeftPriceLabel:nil];
    [self setRightPriceLabel:nil];
    [self setIconBarItem:nil];
    [self setActionBarItem:nil];
    citraBarItem = nil;
    [super viewDidUnload];
}

- (void)shiftCurrency
{
    static uint32_t currIdx = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
        if ([AgentTrade sharedInstance].loginMI) {
            MarketSummary *market = [AgentFeed sharedInstance].marketSummary;
            
            float total_val = 0;
            float total_vol = 0;
            float total_freq = 0;
            
            if (nil != market.stockNg) {
                total_val = market.stockNg.value;
                total_vol = market.stockNg.volume;
                total_freq = market.stockNg.frequency;
            }
            
            if (nil != market.stockTn) {
                total_val += market.stockTn.value;
                total_vol += market.stockTn.volume;
                total_freq += market.stockTn.frequency;
            }
            
            if (nil != market.stockRg) {
                total_val += market.stockRg.value;
                total_vol += market.stockRg.volume;
                total_freq += market.stockRg.frequency;
            }
            
            view1.valLabel.text = currencyRoundedWithFloat(total_val);
            view1.volLabel.text = currencyRoundedWithFloat(total_vol);
            view1.freqLabel.text = currencyRoundedWithFloat(total_freq);
            
            if (nil != [DBLite sharedInstance].getCurrencies && NULL != [DBLite sharedInstance].getCurrencies) {
                if (currIdx >= [DBLite sharedInstance].getCurrencies.count)
                    currIdx = 0;
                
                @try {
                    KiCurrency *currency = [[DBLite sharedInstance].getCurrencies objectAtIndex:currIdx];
                    KiCurrencyData *currCode = [[DBLite sharedInstance] getCurrencyData:currency.currCode];
                    KiCurrencyData *currAgainst = [[DBLite sharedInstance] getCurrencyData:currency.currAgainst];
                    
                    currIdx ++;
                    
                    if(nil != currCode.code && nil != currAgainst.code) {
                        NSString *label = [NSString stringWithFormat:@"%@-%@", currCode.code, currAgainst.code];
                        
                        float chg = currency.last - currency.prev;
                        float chgp = chgprcnt(chg, currency.prev);
                        float price = [[NSString stringWithFormat:@"%.2f", currency.last] floatValue];
                        
                        [self updateCurrency:label chg:chg chgp:chgp price:price];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"%s: %@", __PRETTY_FUNCTION__, exception);
                }
                
            }
        }
        else {
            //Currency
            //key - close - chg - chgPct
            
            if (nil != self.currencyArray && self.currencyArray.count > 0) {
                if (currIdx >= self.currencyArray.count)
                    currIdx = 0;
                
                NSArray *fields = [self.currencyArray objectAtIndex:currIdx++];
                
                float chg = [[[fields objectAtIndex:2] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
                float chgp = [[[fields objectAtIndex:3] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
                float price = [[[fields objectAtIndex:1] stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
                
                [self updateCurrency:[fields objectAtIndex:0] chg:chg chgp:chgp price:price];
            }
        }
        
        
    });
}

- (void)updateCurrency:(NSString *)label chg:(float)chg chgp:(float)chgp price:(float)price
{
    view1.currencyLabel.text = label;
    view1.currencyChgLabel.text = [NSString stringWithFormat:@"%.2f%%  %.2f", chgp, chg];
//    view1.currencyChgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
    view1.currencyPriceLabel.text = currencyString([NSNumber numberWithFloat:price]);
    
    if(chg > 0) {
        view1.currencyImageView.image = [ImageResources imageStockUp];
        view1.currencyChgLabel.textColor = GREEN;
//        view1.currencyChgpLabel.textColor = GREEN;
        view1.currencyPriceLabel.textColor = GREEN;
    }
    else if(chg < 0) {
        view1.currencyImageView.image = [ImageResources imageStockDown];
        view1.currencyChgLabel.textColor = red;
//        view1.currencyChgpLabel.textColor = red;
        view1.currencyPriceLabel.textColor = red;
    }
    else {
        view1.currencyImageView.image = nil;
        view1.currencyChgLabel.textColor = yellow;
//        view1.currencyChgpLabel.textColor = yellow;
        view1.currencyPriceLabel.textColor = yellow;
    }
}

- (void)refreshDefaultRegional
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RegionalSummaryPacket *p1 = [self packet:0];
        RegionalSummaryPacket *p2 = [self packet:1];
        
        if(nil != p1 && nil != p2) {
            KiRegionalIndicesData *d = [[DBLite sharedInstance] getRegionalIndicesDataByCode:CODE_1];
            if ([CODE_1 isEqualToString:p1.code] && [p1.code isEqualToString:d.code]) {
                
                KiRegionalIndices *i = [[DBLite sharedInstance] getRegionalIndicesById:d.id];
                
                float chg = i.previous - i.ohlc.close;
                float chgp = chgprcnt(chg, i.previous);
                
                float price = [[NSString stringWithFormat:@"%.2f", i.previous] floatValue];
                
                p1.code = @"";
                p1.nameLabel.text = d.name;
                p1.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                p1.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                p1.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                
                
                [self packetColor:p1 change:chg];
            }
            
            d = [[DBLite sharedInstance] getRegionalIndicesDataByCode:CODE_2];
            if([CODE_2 isEqualToString:p2.code] && [p2.code isEqualToString:d.code]) {
                
                KiRegionalIndices *i = [[DBLite sharedInstance] getRegionalIndicesById:d.id];
                
                float chg = i.previous - i.ohlc.close;;//chg(i.ohlc.close, i.previous);
                float chgp = chgprcnt(chg, i.previous);
                
                float price = [[NSString stringWithFormat:@"%.2f", i.previous] floatValue];
                
                p2.code = @"";
                p2.nameLabel.text = d.name;
                p2.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                p2.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                p2.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                
                [self packetColor:p2 change:chg];
            }
            
            if(![CODE_1 isEqualToString:p1.code] && ![CODE_2 isEqualToString:p2.code]) {
                [self.bannerScheduler invalidate];
                self.bannerScheduler = nil;
            }
        }
    });
}

- (NSString*)formatter2Comma:(float)value
{
    if (value > 1000000000L || value < -1000000000L) {
        return [NSString stringWithFormat:@"%@B", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(value / 1000000000.0f)]]];
    }
    else if (value > 100000L || value < -100000L) {
        return [NSString stringWithFormat:@"%@M", [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:(value / 100000.0f)]]];
    }
    else {
        return [_formatter2comma stringFromNumber:[NSNumber numberWithFloat:value]];
    }
}


- (RegionalSummaryPacket *)packet:(NSInteger)t
{   
    return  [dictionary objectForKey:[NSNumber numberWithInt:(int)t]];
}

- (void)clearPacket:(RegionalSummaryPacket*)p
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    [p.droplist showRightIcon:YES];
    p.code = @"";
    p.nameLabel.text = @"";
    p.priceLabel.text = @"";
    p.chgLabel.text = @"";
    p.chgpLabel.text = @"";
    p.imageView.image = nil;
    p.channel = ChanelClear;
}

- (void)packetColor:(RegionalSummaryPacket*)p change:(float)chg
{
    if(chg > 0) {
        p.priceLabel.textColor = GREEN;
        p.chgLabel.textColor = GREEN;
        p.chgpLabel.textColor = GREEN;
        p.imageView.image = [ImageResources imageStockUp];
    }
    else if(chg < 0) {
        p.priceLabel.textColor = red;
        p.chgLabel.textColor = red;
        p.chgpLabel.textColor = red;
        p.imageView.image = [ImageResources imageStockDown];
    }
    else {
        p.priceLabel.textColor = yellow;
        p.chgLabel.textColor = yellow;
        p.chgpLabel.textColor = yellow;
        p.imageView.image = nil;
    }
    
    [p.droplist showRightIcon:NO];
}

#pragma mark
#pragma ChannelViewControllerDelegate

- (void)onHttpChannelIndices:(NSArray *)fields
{
    //Indices
    //time - IdxCode - IdxLast - IdxOpen - IdxHighest - IdxLowest - IdxPrev - IdxChg - IdxChgPct
    RegionalSummaryPacket *p = [self packet:tag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    float chg = [[fields objectAtIndex:7] floatValue];
    float chgp = [[fields objectAtIndex:8] floatValue];
    float price = [[fields objectAtIndex:2] floatValue];
    NSString *code  = [[fields objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([@"COMPOSITE" isEqualToString:code])
        code = @"IHSG";
    
    p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
    p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
    p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
    
    [self packetColor:p change:chg];
    
    p.channel = ChannelIndices;
    p.nameLabel.text = code;
    [p.droplist showRightIcon:NO];
    
    [dictionary setObject:p forKey:[NSNumber numberWithInt:tag]];
}

- (void)onHttpChannelRegional:(NSArray *)fields
{
    //Regional
    //key - name - close - chg - chgPct
    
    RegionalSummaryPacket *p = [self packet:tag];
    
    p.code = [fields objectAtIndex:0];
    p.nameLabel.text = [fields objectAtIndex:0];
    
    
    NSString *priceString = [fields objectAtIndex:2];
    priceString = [priceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    float chg = [[fields objectAtIndex:3] floatValue];
    float chgp = [[fields objectAtIndex:4] floatValue];
    float close = [priceString floatValue];//[[fields objectAtIndex:2] floatValue];
    
    //p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
    p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:close + chg]];
    p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
    p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
    
    [self packetColor:p change:chg];
    
    p.channel = ChannelRegionalIndices;
    p.nameLabel.text = [fields objectAtIndex:1];
    [p.droplist showRightIcon:NO];
    
    [dictionary setObject:p forKey:[NSNumber numberWithInt:tag]];
}

- (void)onHttpChannelFuture:(NSArray *)fields
{
    //Futures
    //key - name - close - chg - chgPct
    
    RegionalSummaryPacket *p = [self packet:tag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    float chg = [[fields objectAtIndex:3] floatValue];
    float chgp = [[fields objectAtIndex:4] floatValue];
//    float price = [[fields objectAtIndex:2] floatValue];
    
    p.priceLabel.text = [fields objectAtIndex:2];//[self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
    p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
    p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
    
    [self packetColor:p change:chg];
    
    p.channel = ChannelFuture;
    p.nameLabel.text = [fields objectAtIndex:1];
    [p.droplist showRightIcon:NO];
    
    [dictionary setObject:p forKey:[NSNumber numberWithInt:tag]];
}


- (void)onChannelCurrency:(KiCurrency *)currency
{
}

- (void)onChannelIndicesData:(KiIndicesData *)kiIndicesData
{
    RegionalSummaryPacket *p = [self packet:tag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    NSString *code = kiIndicesData.code;
    if([code isEqualToString:@"COMPOSITE"]) {
        code = @"IHSG";
    }
    KiIndices *kiIndices = [[DBLite sharedInstance] getIndicesById:kiIndicesData.id];
    if(nil != kiIndices) {
        
        float chg = chg(kiIndices.indices.previous, kiIndices.indices.ohlc.close);
        float chgp = chgprcnt(chg, kiIndices.indices.previous);
        
        float price = [[NSString stringWithFormat:@"%.2f", kiIndices.indices.ohlc.close] floatValue];
        
        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];//currencyString([NSNumber numberWithFloat:price]);
        p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
        p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
        
        [self packetColor:p change:chg];
    }
    
    p.channel = ChannelIndices;
    p.nameLabel.text = code;
    [p.droplist showRightIcon:NO];
}

- (void)onChannelIndices:(KiIndices *)indices
{
    NSLog(@"Home onChannleIndices");
}

- (void)onChannelRegionalIndices:(KiRegionalIndices *)indices
{
    NSLog(@"Home onChannelRegionalIndices:");
}

- (void)onChannelRegionalIndicesData:(KiRegionalIndicesData *)indices
{
    RegionalSummaryPacket *p = [self packet:tag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    KiRegionalIndices *kiRegionalIndices = [[DBLite sharedInstance] getRegionalIndicesById:indices.id];
    if(nil != kiRegionalIndices) {
        float chg = kiRegionalIndices.previous - kiRegionalIndices.ohlc.close;
        float chgp = chgprcnt(chg, kiRegionalIndices.previous);
        
        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:kiRegionalIndices.previous]];//currencyString([NSNumber numberWithFloat:kiRegionalIndices.previous]);
        p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];//currencyStringFromInt(chg);
        p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
        
        [self packetColor:p change:chg];
        
    }
    
    p.channel = ChannelRegionalIndices;
    p.nameLabel.text = indices.name;
    [p.droplist showRightIcon:NO];
}

- (void)onChannelFuture:(KiFuture*)future
{
    RegionalSummaryPacket *p = [self packet:tag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    KiRegionalIndicesData *data = [[DBLite sharedInstance] getRegionalIndicesDataById:future.codeId];
    if(nil != data) {
        float chg = future.ohlc.close - future.previous;
        float chgp = chgprcnt(chg, future.previous);
        
        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:future.ohlc.close]];//currencyString([NSNumber numberWithFloat:future.ohlc.close]);
        p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];//currencyStringFromInt(chg);
        p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
        
        [self packetColor:p change:chg];
    }
    
    p.channel = ChannelFuture;
    p.nameLabel.text = data.fullname;
    [p.droplist showRightIcon:NO];
}


#pragma mark
#pragma UIDropList Delegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    
    if(dropList == topstokDroplist) {
        if(2 == index) {
            topstockHeaderCell.chgLabel.text = @"";
            topstockHeaderCell.chgpLabel.text = @"TVal";
        }
        else if(3 == index) {
            topstockHeaderCell.chgLabel.text = @"";
            topstockHeaderCell.chgpLabel.text = @"TFreq";
        }
        else {
            topstockHeaderCell.chgLabel.text = @"Chg";
            topstockHeaderCell.chgpLabel.text = @"%";
        }
        
        if (![AgentTrade sharedInstance].loginMI) {
            self.topStockByHttp = nil;
            self.topStockByHttp = [NSArray array];
            [self.topstock reloadData];
            
            [self performSelector:@selector(httpTopStock:) withObject:NO afterDelay:1];
            
        }
        else {
            [self performSelector:@selector(onChangeTopStock) withObject:nil afterDelay:1];
        }
    }
    else {
        UIDropList *dl = dropList;
        tag = (int)dl.tag;
        
        if(ChannelIndices == index) {
            
            ChannelViewController *currencyController;
            if(nil == currencyController) {
                currencyController = [[ChannelViewController alloc] initWithNibName:@"ChannelViewController" bundle:[NSBundle mainBundle]];
                [currencyController subchannel:ChannelIndices];
                
                currencyController.delegate = self;
            }
            
            [self presentViewController:currencyController animated:YES completion:nil];
        }
        
        else if(ChannelRegionalIndices == index) {
            
            ChannelViewController *currencyController;
            if(nil == currencyController) {
                currencyController = [[ChannelViewController alloc] initWithNibName:@"ChannelViewController" bundle:[NSBundle mainBundle]];
                [currencyController subchannel:ChannelRegionalIndices];
                
                currencyController.delegate = self;
            }
            
            [self presentViewController:currencyController animated:YES completion:nil];
        }
        
        else if(ChannelFuture == index) {
            
            ChannelViewController *currencyController;
            if(nil == currencyController) {
                currencyController = [[ChannelViewController alloc] initWithNibName:@"ChannelViewController" bundle:[NSBundle mainBundle]];
                [currencyController subchannel:ChannelFuture];
                
                currencyController.delegate = self;
            }
            
            [self presentViewController:currencyController animated:YES completion:nil];
        }
        
        else if(ChanelClear == index) {
            [self clearPacket:[self packet:tag]];
        }
    }
}

-(void)onChangeTopStock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        DBLite *db = [DBLite sharedInstance];
        if(0 == topstokDroplist.selectedIndex)
        arrayTopStock = [db getStockSummaryByChgPercent:db.getStockSummaries];
        else if(1 == topstokDroplist.selectedIndex)
            arrayTopStock = [db getStockSummaryByChgPercentNegasi:db.getStockSummaries];
        else if(2 == topstokDroplist.selectedIndex)
            arrayTopStock = [db getStockSummaryByValue:db.getStockSummaries];
        else if(3 == topstokDroplist.selectedIndex)
            arrayTopStock = [db getStockSummaryByFrequency:db.getStockSummaries];
        [self.topstock reloadData];
    });
}

- (void)AgentFeedCallback:(KiRecord*)record
{
    if (RecordTypeKiIndices == record.recordType) {
        [self updateIndices:record.indices];
    }
    else if(RecordTypeKiRegionalIndices == record.recordType) {
        [self updateRegionalIndices:record.regionalIndices];
    }
    else if(RecordTypeFutures == record.recordType) {
        [self updateFutures:record.future];
    }
}


- (void)updateIndices:(NSArray *)arrayIndices
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:3];
        [formatter setMinimumFractionDigits:3];
        [formatter setRoundingMode:NSNumberFormatterRoundDown];
        [formatter setDecimalSeparator:@"."];
        [formatter setGroupingSeparator:@","];
        [formatter setAllowsFloats:YES];
        
        for(KiIndices *i in arrayIndices) {
            KiIndicesData *data = [[DBLite sharedInstance] getIndicesData:i.codeId];
            if(nil != data) {
                if([data.code isEqualToString:@"COMPOSITE"]) {
                    
                    indicesIhsg = i;
                    
                    float chg = chg(i.indices.previous, i.indices.ohlc.close);
                    float chgp = chgprcnt(chg, i.indices.previous);
                    
                    view1.ihsgPriceLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:i.indices.ohlc.close]];
                    view1.ihsgChgLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:chg]];
                    view1.ihsgChgpLabel.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                    
                    if(chg > 0) {
                        view1.ihsgImageView.image = [ImageResources imageStockUp];
                        view1.ihsgPriceLabel.textColor = GREEN;
                        view1.ihsgChgLabel.textColor = GREEN;
                        view1.ihsgChgpLabel.textColor = GREEN;
                    }
                    else if(chg < 0) {
                        view1.ihsgPriceLabel.textColor = red;
                        view1.ihsgChgLabel.textColor = red;
                        view1.ihsgChgpLabel.textColor = red;
                        view1.ihsgImageView.image = [ImageResources imageStockDown];
                    }
                    else {
                        view1.ihsgPriceLabel.textColor = yellow;
                        view1.ihsgChgLabel.textColor = yellow;
                        view1.ihsgChgpLabel.textColor = yellow;
                        view1.ihsgImageView.image = [ImageResources imageStockUp];
                    }
                    
                    break;
                }
            }
        }
        
        NSArray *allKeys = dictionary.allKeys;
        for(NSObject *k in allKeys) {
            if (nil != k) {
                RegionalSummaryPacket *p = [dictionary objectForKey:k];
                if(ChannelIndices == p.channel) {
                    for(KiIndices *i in arrayIndices) {
                        KiIndicesData *d = [[DBLite sharedInstance] getIndicesData:i.codeId];
                        
                        NSString *code = d.code;
                        if([code isEqualToString:@"COMPOSITE"])
                            code = @"IHSG";
                        
                        if([code isEqualToString:p.nameLabel.text]) {
                            float chg = i.indices.ohlc.close - i.indices.previous;//chg(i.indices.ohlc.close, i.indices.previous);
                            float chgp = chgprcnt(chg, i.indices.previous);
                            
                            float price = [[NSString stringWithFormat:@"%.2f", i.indices.ohlc.close] floatValue];
                            
                            p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];//currencyString([NSNumber numberWithFloat:price]);
                            p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
                            p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
                            
                            [self packetColor:p change:chg];
                            
                            break;
                        }
                    }
                }
            }
        }
    });
}

- (void)updateRegionalIndices:(NSArray *)arrayKi
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *allKeys = dictionary.allKeys;
        for(NSObject *k in allKeys) {
            if (nil != k) {
                RegionalSummaryPacket *p = [dictionary objectForKey:k];
                
                if(ChannelRegionalIndices == p.channel) {
                    for(KiRegionalIndices *i in arrayKi) {
                        KiRegionalIndicesData *d = [[DBLite sharedInstance] getRegionalIndicesDataById:i.codeId];
                        
                        if(([CODE_2 isEqualToString:p.code] && [p.code isEqualToString:d.code]) ||
                           ([CODE_1 isEqualToString:p.code] && [p.code isEqualToString:d.code])) {
                            
                            float chg = i.previous - i.ohlc.close;;
                            float chgp = chgprcnt(chg, i.previous);
                            
                            float price = [[NSString stringWithFormat:@"%.2f", i.previous] floatValue];
                            
                            p.nameLabel.text = d.name;
                            p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];//currencyString([NSNumber numberWithFloat:price]);
                            p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
                            p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
                            
                            [self packetColor:p change:chg];
                            
                            break;
                        }
                        else if([d.name isEqualToString:p.nameLabel.text]) {
                            float chg = i.previous - i.ohlc.close;//chg(i.ohlc.close, i.previous);
                            float chgp = chgprcnt(chg, i.previous);
                            
                            float price = [[NSString stringWithFormat:@"%.2f", i.previous] floatValue];
                            
                            p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];//currencyString([NSNumber numberWithFloat:price]);
                            p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
                            p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
                            
                            [self packetColor:p change:chg];
                            
                            break;
                        }
                    }
                }
            }
            
        }
        
    });
}

- (void)updateFutures:(NSArray *)arrayFuture
{
    NSArray *futures = arrayFuture;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *packets = dictionary.allValues;
        for(RegionalSummaryPacket *p in packets) {
            if(nil != p && ChannelFuture == p.channel) {
                for(KiFuture *f in futures) {
                    
                    KiRegionalIndicesData *data = [[DBLite sharedInstance] getRegionalIndicesDataById:f.codeId];
                    
                    if([data.fullname isEqualToString:p.nameLabel.text]) {
                        float chg = f.ohlc.close - f.previous;
                        float chgp = chgprcnt(chg, f.previous);
                        
                        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:f.ohlc.close]];//currencyString([NSNumber numberWithFloat:f.ohlc.close]);
                        p.chgLabel.text = [NSString stringWithFormat:@"%.2f", chg];
                        p.chgpLabel.text = [NSString stringWithFormat:@"%.2f%%", chgp];
                        
                        [self packetColor:p change:chg];
                        
                        break;
                    }
                }
            }
        }
    });
    
    futures = nil;
}




#pragma mark
#pragma UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == scrollview) {
        CGFloat pagewidth = scrollview.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pagewidth / 2) / pagewidth) + 1;
        pagecontrol.currentPage = page;
    }
}

#pragma mark
#pragma UITableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == topstock && nil != self.topStockByHttp) {
        return self.topStockByHttp.count > 20 ? 20 : self.topStockByHttp.count;
    }
//    else if(tableView == toploser && nil != self.topLoserByHttp) {
//        return self.topLoserByHttp.count > 20 ? 20 : self.topLoserByHttp.count;
//    }
    else if(tableView == topbroker && nil != self.topBrokerByHttp) {
        return self.topBrokerByHttp.count > 20 ? 20 : self.topBrokerByHttp.count;
    }
    else if(tableView == topstock && nil != arrayTopStock) {
        return arrayTopStock.count > 20 ? 20 : arrayTopStock.count;
    }
//    else if(tableView == toploser && nil != arrayTopLoser) {
//        return arrayTopLoser.count > 20 ? 20 : arrayTopLoser.count;
//    }
    else if(tableView == topbroker && nil != arrayBroker) {
        return arrayBroker.count > 20 ? 20 : arrayBroker.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == topstock && nil != self.topStockByHttp) {
        NSArray *parse = [self.topStockByHttp objectAtIndex:indexPath.row];
        
        UIHomeTopStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeTopStockCell"];
        
        if(nil == cell) {
            cell = [[UIHomeTopStockCell alloc] init];
        }
        
        float chg = [[parse objectAtIndex:6] floatValue];
        
        //Stock
        if (topstokDroplist.selectedIndex == 2){
            cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithFloat:[[parse objectAtIndex:10] floatValue]]);
            cell.chgpLabel.text = @"";
            cell.chgpLabel.hidden = YES;
        }
        else if (topstokDroplist.selectedIndex  == 3){
            cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithFloat:[[parse objectAtIndex:11] floatValue]]);
            cell.chgLabel.hidden = NO;
            cell.chgpLabel.text = @"";
        }
        else {
            cell.chgLabel.frame = CGRectMake(190, 0, 60, 20);
            cell.chgpLabel.frame = CGRectMake(260, 0, 60, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithFloat:chg]);
            cell.chgpLabel.text = [NSString stringWithFormat:@"%.2f", [[parse objectAtIndex:7] floatValue]];
            cell.chgpLabel.hidden = NO;
        }
        cell.stockLabel.text = [parse objectAtIndex:3];
        cell.noLabel.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1 ];
        cell.lastLabel.text = currencyString([NSNumber numberWithFloat:[[parse objectAtIndex:5] floatValue]]);
        
        if(chg > 0) {
            cell.lastLabel.textColor = GREEN;
            cell.chgLabel.textColor = GREEN;
            cell.chgpLabel.textColor = GREEN;
        }
        else if(chg < 0) {
            cell.lastLabel.textColor = red;
            cell.chgLabel.textColor = red;
            cell.chgpLabel.textColor = red;
        }
        else {
            cell.lastLabel.textColor = yellow;
            cell.chgLabel.textColor = yellow;
            cell.chgpLabel.textColor = yellow;
        }
        
        return cell;
    }
    else if (tableView == topbroker && nil != self.topBrokerByHttp) {
        NSArray *parse = [self.topBrokerByHttp objectAtIndex:indexPath.row];
        
        NSString *code = [parse objectAtIndex:0];
        code = [code stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        UIHomeTopBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeTopStockCell2"];
        
        
        //Broker
        //code - name - totVolume - totVolumeLot - totValue - totFreq
        
        if(nil == cell) {
            cell = [[UIHomeTopBrokerCell alloc] init];
        }
        
        float val = [[parse objectAtIndex:4] floatValue];
        float vol = [[parse objectAtIndex:2] floatValue];
        float freq = [[parse objectAtIndex:5] floatValue];
        
        cell.noLabel.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1 ];
        cell.brokerLabel.text = code;
        cell.tvalLabel.text = currencyRoundedWithFloatWithFormat(val, self.formatter2comma);
        cell.tvolLabel.text = currencyRoundedWithFloatWithFormat(vol, self.formatter2comma);
        //cell.tfreqLabel.text = currencyRoundedWithFloatWithFormat(freq, self.formatter2comma);
        cell.tfreqLabel.text = currencyRoundedWithFloat(freq);
        
        return cell;
    }
    else if(tableView == topstock && nil != arrayTopStock) {
        UIHomeTopStockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeTopStockCell"];
        
        if(nil == cell) {
            cell = [[UIHomeTopStockCell alloc] init];
        }
        
        KiStockSummary *p = [arrayTopStock objectAtIndex:indexPath.row];
        KiStockData *data = [[DBLite sharedInstance] getStockDataById:p.codeId];
        
        float chg = p.stockSummary.change;
        float chgp = 0;
        if(p.stockSummary.ohlc.close > 0)
            chgp = chgprcnt(chg, p.stockSummary.previousPrice);
        
//        cell.noLabel.text = [NSString stringWithFormat:@"%i", indexPath.row + 1 ];
//        cell.stockLabel.text = [NSString stringWithFormat:@"%@", data.code];
//        cell.lastLabel.text = currencyStringFromInt(p.stockSummary.ohlc.close);
//        cell.chgLabel.text = currencyString([NSNumber numberWithFloat:chg]);//[NSString stringWithFormat:@"%.2f", chg];
//        cell.chgpLabel.text = [NSString stringWithFormat:@"%.2f", chgp];
//        
        cell.stockLabel.textColor = [UIColor colorWithHexString:data.color];
        cell.noLabel.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1 ];
        cell.stockLabel.text = [NSString stringWithFormat:@"%@", data.code];
        cell.lastLabel.text = currencyStringFromInt(p.stockSummary.ohlc.close);
        
        if (topstokDroplist.selectedIndex == 2){
            cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithLongLong:p.stockSummary.tradedValue]);
            cell.chgpLabel.text = @"";
            cell.chgpLabel.hidden = YES;
        }
        else if (topstokDroplist.selectedIndex == 3){
            cell.chgLabel.frame = CGRectMake(190, 0, 125, 20);
            cell.chgpLabel.frame = CGRectMake(265, 0, 1, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithInt:p.stockSummary.tradedFrequency]);
            cell.chgpLabel.text = @"";
            cell.chgpLabel.hidden = NO;
        }
        else {
            cell.chgLabel.frame = CGRectMake(190, 0, 60, 20);
            cell.chgpLabel.frame = CGRectMake(260, 0, 60, 20);
            cell.chgLabel.text = currencyString([NSNumber numberWithFloat:chg]);
            cell.chgpLabel.text = [NSString stringWithFormat:@"%.2f", chgp];
            cell.chgpLabel.hidden = NO;
        }
        
        if(chg > 0) {
            cell.lastLabel.textColor = GREEN;
            cell.chgLabel.textColor = GREEN;
            cell.chgpLabel.textColor = GREEN;
        }
        else if(chg < 0) {
            cell.lastLabel.textColor = red;
            cell.chgLabel.textColor = red;
            cell.chgpLabel.textColor = red;
        }
        else {
            cell.lastLabel.textColor = yellow;
            cell.chgLabel.textColor = yellow;
            cell.chgpLabel.textColor = yellow;
        }
        
        return cell;
    }
    else if (tableView == topbroker && arrayBroker != nil) {
        UIHomeTopBrokerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeTopStockCell2"];
        
        if(nil == cell) {
            cell = [[UIHomeTopBrokerCell alloc] init];
        }
        
        Transaction *t = [arrayBroker objectAtIndex:indexPath.row];
        KiBrokerData *data = [[DBLite sharedInstance] getBrokerDataById:t.codeId];
        
        Transaction *rg = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardRg];
        Transaction *ng = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardNg];
        Transaction *tn = [[DBLite sharedInstance] getBrokerSummaryById:t.codeId andBoard:BoardTn];
        
        float tval = 0, tvol = 0, tfreq = 0;
        
        if (nil != rg) {
            tval += rg.buy.value + rg.sell.value;
        }
        if (nil != ng) {
            tval += ng.buy.value + ng.sell.value;
        }
        if (nil != rg) {
            tval += tn.buy.value + tn.sell.value;
        }
        
        if (nil != rg) {
            tvol += rg.buy.volume + rg.sell.volume;
        }
        if (nil != ng) {
            tvol += ng.buy.volume + ng.sell.volume;
        }
        if (nil != tn) {
            tvol += tn.buy.volume + tn.sell.volume;
        }
        
        if (nil != rg) {
            tfreq += rg.buy.frequency + rg.sell.frequency;
        }
        if (nil != ng) {
            tfreq += ng.buy.frequency + ng.sell.frequency;
        }
        if (nil != tn) {
            tfreq += tn.buy.frequency + tn.sell.frequency;
        }

        
        cell.noLabel.text = [NSString stringWithFormat:@"%i", (int)indexPath.row + 1 ];
        cell.brokerLabel.text = data.code;
        cell.tvalLabel.text = currencyRoundedWithFloatWithFormat(tval, self.formatter2comma);
        cell.tvolLabel.text = currencyRoundedWithFloatWithFormat(tvol, self.formatter2comma);
        cell.tfreqLabel.text = currencyString([NSNumber numberWithFloat:tfreq]);//currencyRoundedWithFloat(broker.tfreq);
        
        cell.brokerLabel.textColor = data.type == InvestorTypeD ? white : magenta;
        cell.tvalLabel.textColor = data.type == InvestorTypeD ? white : magenta;
        cell.tvolLabel.textColor = data.type == InvestorTypeD ? white : magenta;
        cell.tfreqLabel.textColor = data.type == InvestorTypeD ? white : magenta;

        return cell;
    }
    
    return  nil;
}

static UIImage *bgTitanium;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == topstock) {
        if(nil == topstockHeaderCell)
            topstockHeaderCell = [[UIHomeTopStockCell alloc] init];
        
        return topstockHeaderCell;
    }
    else if(tableView == topbroker) {
        if (nil == topbrokerHeaderCell)
            topbrokerHeaderCell = [[UIHomeTopBrokerCell alloc] init];
        return topbrokerHeaderCell;
    }
    
    return nil;
}


#pragma mark
#pragma HTTP

- (void)httpStop
{
    if (nil != self.httpSysAdminTimer) {
        NSLog(@"%s HTTP STOP", __PRETTY_FUNCTION__);
        [self.httpSysAdminTimer invalidate];
        self.httpSysAdminTimer = nil;
    }
}

- (void)httpSysAdmin
{
    //NSLog(@"%s REQUEST SYSADMIN", __PRETTY_FUNCTION__);
    if (![AgentTrade sharedInstance].loginMI) {
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                self.httpIndexReq = 0;
                self.baseURL = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSLog(@"HTTP BASE URL: %@", self.baseURL);
                
                [self performSelector:@selector(httpAllRequest) withObject:nil afterDelay:1];
            }
            else {
                [self performSelector:@selector(httpSysAdmin) withObject:nil afterDelay:1];
            }
        };
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *udid = [defaults objectForKey:@"userIdentifier"];
        
        //NSLog(@"UDID: %@", udid);
        
        NSString *uri = [NSString stringWithFormat:@"%@%@", URL_HTTP_SYSADMIN, udid];
        //NSLog(@"URI UDID: %@", uri);
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:uri];
    }
}

- (void)httpAllRequest
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        if (self.httpIndexReq > 6) {
            self.httpIndexReq = 0;
        }
        
        if (0 == self.httpIndexReq) {
            [self httpMarketSummary];
        }
        else if (1 == self.httpIndexReq) {
            [self httpCurrency];
        }
        else if (2 == self.httpIndexReq) {
            [self httpIndices];
        }
        else if (3 == self.httpIndexReq) {
            [self httpTopStock];
        }
//        else if (4 == self.httpIndexReq) {
//            [self httpTopLoser];
//        }
        else if (4 == self.httpIndexReq) {
            [self httpTopBroker];
        }
        else if (5 == self.httpIndexReq) {
            [self httpRegional];
        }
        else if (6 == self.httpIndexReq) {
            [self httpFuture];
        }
        
    }
}

- (void)httpNext
{
//    if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0) {
    if ([AgentTrade sharedInstance].loginMI) {
        //NSLog(@"##HTTP STOP");
        self.topStockByHttp = nil;
//        self.topLoserByHttp = nil;
        self.topBrokerByHttp = nil;
        self.regionalDictionary = nil;
        self.indicesDictionary = nil;
        self.futureDictionary = nil;
        
        [self httpStop];
    }
    else {
        self.httpIndexReq ++;
        [self performSelector:@selector(httpAllRequest) withObject:nil afterDelay:1];
    }
    
    if(nil == self.shiftCurrencyScheduler)
        self.shiftCurrencyScheduler = [NSTimer scheduledTimerWithTimeInterval:5.5 target:self selector:@selector(shiftCurrency) userInfo:nil repeats:YES];
    

}

- (void)httpMarketSummary
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Summary
                    //volume - value - freq
                    
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    
                    for (NSString *row in parse) {
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        if (3 == fields.count) {
                            float vol = [[fields objectAtIndex:0] floatValue];
                            float val = [[fields objectAtIndex:1] floatValue];
                            float freq = [[fields objectAtIndex:2] floatValue];
                            
                            view1.valLabel.text = currencyRoundedWithFloat(val);
                            view1.volLabel.text = currencyRoundedWithFloat(vol);
                            view1.freqLabel.text = currencyRoundedWithFloat(freq);
                        }
                    }

                });
                
                
                [self httpNext];
            }
            else if(nil != error && ![AgentTrade sharedInstance].loginMI) {
                [self performSelector:@selector(httpMarketSummary) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_SUMMARY) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpCurrency
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    
                    //Currency
                    //key - close - chg - chgPct
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSString *row in parse) {
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        if (4 == fields.count) {
                            [array addObject:@[
                                               [[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                               [[fields objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                               [[fields objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                               [[fields objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                               ]];
                        }
                    }
                    
                    self.currencyArray = nil;
                    self.currencyArray = [NSArray arrayWithArray:array];
                    
                });
                
                
                [self httpNext];
            }
            else if(nil != error) {
                [self performSelector:@selector(httpCurrency) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_CURRENCY) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpIndices
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:3];
        [formatter setMinimumFractionDigits:3];
        [formatter setRoundingMode:NSNumberFormatterRoundDown];
        [formatter setDecimalSeparator:@"."];
        [formatter setGroupingSeparator:@","];
        [formatter setAllowsFloats:YES];
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Indices
                    //time - IdxCode - IdxLast - IdxOpen - IdxHighest - IdxLowest - IdxPrev - IdxChg - IdxChgPct
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    
                    for (NSString *row in parse) {
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        if (9 == fields.count) {
                            
                            NSString *code = [[fields objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            NSArray *temp = @[[[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              code,
                                              [[fields objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:5] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:7] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                              ];
                            
                            if (nil == self.indicesDictionary)
                                self.indicesDictionary = [NSMutableDictionary dictionary];
                            
                            [self.indicesDictionary setObject:temp forKey:code];
                            
                            if ([@"COMPOSITE" isEqual:code]) {
                                
                                float chg = [[fields objectAtIndex:7] floatValue];
                                float chgp = [[fields objectAtIndex:8] floatValue];
                                
                                view1.ihsgPriceLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[fields objectAtIndex:2] doubleValue]]];
                                view1.ihsgChgLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:chg]];
                                view1.ihsgChgpLabel.text = [NSString stringWithFormat:@"%@%%", [formatter stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                                
                                if(chg > 0) {
                                    view1.ihsgImageView.image = [ImageResources imageStockUp];
                                    view1.ihsgPriceLabel.textColor = GREEN;
                                    view1.ihsgChgLabel.textColor = GREEN;
                                    view1.ihsgChgpLabel.textColor = GREEN;
                                }
                                else if(chg < 0) {
                                    view1.ihsgPriceLabel.textColor = red;
                                    view1.ihsgChgLabel.textColor = red;
                                    view1.ihsgChgpLabel.textColor = red;
                                    view1.ihsgImageView.image = [ImageResources imageStockDown];
                                }
                                else {
                                    view1.ihsgPriceLabel.textColor = yellow;
                                    view1.ihsgChgLabel.textColor = yellow;
                                    view1.ihsgChgpLabel.textColor = yellow;
                                    view1.ihsgImageView.image = [ImageResources imageStockUp];
                                }
                            }
                        }
                    }
                    
                    for(int n = 0; n < 2; n ++) {
                        RegionalSummaryPacket *p = [self packet:n];
                        
                        if (ChannelIndices == p.channel) {
                            
                            NSString *code = p.nameLabel.text;
                            if ([code isEqual:@"IHSG"])
                                code = @"COMPOSITE";
                            
                            //Indices
                            //time - IdxCode - IdxLast - IdxOpen - IdxHighest - IdxLowest - IdxPrev - IdxChg - IdxChgPct
                            NSArray *fields = [self.indicesDictionary objectForKey:code];
                            if (nil != fields) {
                                tag = n;
                                [self onHttpChannelIndices:fields];
                            }
                        }
                    }
                });
                
                [self httpNext];
                
            }
            else if(nil != error) {
                [self performSelector:@selector(httpIndices) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_INDICES) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpRegional
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    for (NSString *row in parse) {
                        //Regional
                        //code - name - close - chg - chgPct
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        
                        if (5 == fields.count) {
                        
                            NSString *code = [[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSString *name = [[fields objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            NSArray *temp = @[code,
                                              name,
                                              [[fields objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                              ];
                            
                            if (nil == self.regionalDictionary)
                                self.regionalDictionary = [NSMutableDictionary dictionary];
                            
                            //NSLog(@"## STORE CODE %@", code);
                            [self.regionalDictionary setObject:temp forKey:code];
                        }
                        
                    }
                    
                    for(int n = 0; n < 2; n ++) {
                        RegionalSummaryPacket *p = [self packet:n];
                        
                        if (ChannelRegionalIndices == p.channel) {
                            
                            NSString *code = p.code;
                            
                            if (0 == n && (nil == code || [@"" isEqualToString:code])) {
                                p.code = CODE_1;
                                code = CODE_1;
                            }
                            else if(1 == n && (nil == code || [@"" isEqualToString:code])) {
                                p.code = CODE_2;
                                code = CODE_2;
                            }
                            
                            NSArray *fields = [self.regionalDictionary objectForKey:code];
                            //NSLog(@"## REGIONAL CODE |%@|, FIELD %@", code, fields);
                            if (nil != fields) {
                                tag = n;
                                [self onHttpChannelRegional:fields];
                            }
                        }
                    }
                });
                
                [self httpNext];
            }
            else if(nil != error) {
                [self performSelector:@selector(httpRegional) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_REGIONAL_INDICES) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpFuture
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    for (NSString *row in parse) {
                        //Futures
                        //code - name - close - chg - chgPct
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        
                        if (5 == fields.count) {
//                            NSString *code = [[fields objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
                            NSString *name = [[fields objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            
                            NSArray *temp = @[[[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              name,//[[fields objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
                                              [[fields objectAtIndex:4] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                              ];
                            
                            if (nil == self.futureDictionary)
                                self.futureDictionary = [NSMutableDictionary dictionary];
                            
                            [self.futureDictionary setObject:temp forKey:name];
                        }
                        
                    }
                    
                    for(int n = 0; n < 2; n ++) {
                        RegionalSummaryPacket *p = [self packet:n];
                        
                        if (ChannelFuture == p.channel) {
                            
                            NSString *name = p.nameLabel.text;
                            
                            NSArray *fields = [self.futureDictionary objectForKey:name];
                            if (nil != fields) {
                                tag = n;
                                [self onHttpChannelFuture:fields];
                            }
                        }
                    }
                });
                
//                [self performSelector:@selector(httpNext) withObject:nil afterDelay:HTTP_INTERVAL];
                
                if (nil == self.httpSysAdminTimer)
                    self.httpSysAdminTimer = [NSTimer scheduledTimerWithTimeInterval:HTTP_INTERVAL target:self selector:@selector(httpNext) userInfo:nil repeats:YES];
            }
            else if(nil != error) {
                [self performSelector:@selector(httpFuture) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_FUTURE) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpTopBroker
{
    if (nil != self.baseURL) {
        //NSLog(@"%s", __PRETTY_FUNCTION__);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Broker
                    //code - name - totVolume - totVolumeLot - totValue - totFreq
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSString *row in parse) {
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        if (6 == fields.count) {
                            [array addObject:fields];
                        }
                    }
                    
                    if (nil != array) {
                        self.topBrokerByHttp = nil;
                        self.topBrokerByHttp = [NSArray arrayWithArray:array];
                        
                        [topbroker reloadData];
                    }
                });
                
                [self httpNext];
            }
            else if(nil != error) {
                [self performSelector:@selector(httpTopBroker) withObject:nil afterDelay:1];
            }
        };
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, URL_SUB_TOPBROKER) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

- (void)httpTopStock
{
    [self httpTopStock:YES];
}

- (void)httpTopStock:(BOOL)next
{
    if (nil != self.baseURL) {
        //NSLog(@"%s %i", __PRETTY_FUNCTION__, next);
        
        HTTPCallback callback = ^(NSString *result, NSError *error) {
            if (nil != result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //Stock
                    //time - level - sector - stockcode - stockname - lastPrice - chg - chgPct - totVolume - totVolumeLot - totValue - totFreq
                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
                    
                    NSString *time;
                    NSInteger last = 0;
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (NSString *row in parse) {
                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
                        if (12 == fields.count) {
                            NSString *time0 = [[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            NSInteger current = [[time0 stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
                            
                            if (current > last) {
                                last = current;
                                time = time0;
                            }
                            
                            [array addObject:fields];
                        }
                    }
                    
                    if (nil != array) {
                        self.topStockByHttp = nil;
                        self.topStockByHttp = [NSArray arrayWithArray:array];
                        
                        [topstock reloadData];
                        
                        if (nil == time)
                            time = @"NO DATA";
                        
                        CGFloat width = 150;
                        CGFloat height = 40;
                        UIView *popup = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width) / 2, self.view.frame.size.height - 2 * height, width, height)];
                        popup.backgroundColor = [UIColor lightGrayColor];
                        popup.layer.cornerRadius = 8;
                        popup.layer.borderColor = [UIColor whiteColor].CGColor;
                        popup.layer.borderWidth = 1.0f;
                        
                        CGFloat labelWidth = width - 10;
                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((width - labelWidth) / 2, 5, width - 10, height - 10)];
                        [label setFont:[UIFont systemFontOfSize:12]];
                        label.text = [NSString stringWithFormat:@"Last update: %@", time];
                        label.textColor = [UIColor darkTextColor];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.adjustsFontSizeToFitWidth = YES;
                        [popup addSubview:label];
                        
                        popup.alpha = 0;
                        [self.view addSubview:popup];
                        
                        [UIView animateWithDuration:.25
                                         animations:^{
                                             popup.alpha = 100;
                                         }
                                         completion:^(BOOL finished) {
                                             [UIView animateWithDuration:3
                                                              animations:^{
                                                                  popup.alpha = 0;
                                                              }
                                                              completion:^(BOOL finished) {
                                                                  [popup removeFromSuperview];
                                                              }];
                                         }];
                    }
                });
                
                if(next) [self httpNext];
            }
            else if(nil != error) {
                [self performSelector:@selector(httpTopStock) withObject:nil afterDelay:1];
            }
        };
        
        NSString *urlRequest = URL_SUB_TOPSTOCK;
        if(1 == topstokDroplist.selectedIndex)
            urlRequest = URL_SUB_TOPLOSER;
        else if(2 == topstokDroplist.selectedIndex)
            urlRequest = URL_SUB_TOPVALUE;
        else if(3 == topstokDroplist.selectedIndex)
            urlRequest = URL_SUB_TOPACTIVE;
        
        HTTPAsync *http = [[HTTPAsync alloc] init];
        [http callback:callback];
        [http requestURL:[CONCAT(self.baseURL, urlRequest) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}

//- (void)httpTopLoser
//{
//    if (nil != self.baseURL) {
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//        
//        HTTPCallback callback = ^(NSString *result, NSError *error) {
//            if (nil != result) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    //Stock
//                    //time - level - sector - stockcode - stockname - lastPrice - chg - chgPct - totVolume - totVolumeLot - totValue - totFreq
//                    NSArray *parse = [result componentsSeparatedByString:@"\n"];
//                    
//                    NSString *time;
//                    NSInteger last = 0;
//                    
//                    NSMutableArray *array = [NSMutableArray array];
//                    for (NSString *row in parse) {
//                        NSArray *fields = [row componentsSeparatedByString:@"\t"];
//                        if (12 == fields.count) {
//                            NSString *time0 = [[fields objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                            NSInteger current = [[time0 stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
//                            
//                            if (current > last) {
//                                last = current;
//                                time = time0;
//                            }
//                            
//                            [array addObject:fields];
//                        }
//                    }
//                    
//                    if (nil != array) {
//                        self.topLoserByHttp = nil;
//                        self.topLoserByHttp = [NSArray arrayWithArray:array];
//
//                        [toploser reloadData];
//                        
//                        if (nil == time)
//                            time = @"NO DATA";
//                        
//                        CGFloat width = 150;
//                        CGFloat height = 40;
//                        UIView *popup = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - width) / 2, self.view.frame.size.height - 2 * height, width, height)];
//                        popup.backgroundColor = [UIColor lightGrayColor];
//                        popup.layer.cornerRadius = 8;
//                        popup.layer.borderColor = [UIColor whiteColor].CGColor;
//                        popup.layer.borderWidth = 1.0f;
//                        
//                        CGFloat labelWidth = width - 10;
//                        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((width - labelWidth) / 2, 5, width - 10, height - 10)];
//                        [label setFont:[UIFont systemFontOfSize:12]];
//                        label.text = [NSString stringWithFormat:@"Last update: %@", time];
//                        label.textColor = [UIColor darkTextColor];
//                        label.textAlignment = NSTextAlignmentCenter;
//                        label.adjustsFontSizeToFitWidth = YES;
//                        [popup addSubview:label];
//                        
//                        popup.alpha = 0;
//                        [self.view addSubview:popup];
//                        
//                        [UIView animateWithDuration:.25
//                                         animations:^{
//                                             popup.alpha = 100;
//                                         }
//                                         completion:^(BOOL finished) {
//                                             [UIView animateWithDuration:3
//                                                              animations:^{
//                                                                  popup.alpha = 0;
//                                                              }
//                                                              completion:^(BOOL finished) {
//                                                                  [popup removeFromSuperview];
//                                                              }];
//                                         }];
//                    }
//                });
//                
//                [self httpNext];
//            }
//            else if(nil != error) {
//                [self performSelector:@selector(httpTopLoser) withObject:nil afterDelay:1];
//            }
//        };
//        
//        HTTPAsync *http = [[HTTPAsync alloc] init];
//        [http callback:callback];
//        [http requestURL:[CONCAT(self.baseURL, URL_SUB_TOPLOSER) stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
//    }
//}

@end





@implementation UIHomeTopBrokerCell

- (id)init
{
    if(self = [super init]) {
        _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 25, 20)];
        _brokerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 90, 20)];
        _tvalLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 80, 20)];
        _tvolLabel = [[UILabel alloc] initWithFrame:CGRectMake(185, 0, 70, 20)];
        _tfreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 20)];
        
        _noLabel.text = @"No";
        _brokerLabel.text = @"Broker";
        _tvalLabel.text = @"TVal";
        _tvolLabel.text = @"TVol";
        _tfreqLabel.text = @"TFreq";
        
        _noLabel.font = [UIFont systemFontOfSize:16];
        _brokerLabel.font = [UIFont systemFontOfSize:16];
        _tvalLabel.font = [UIFont systemFontOfSize:16];
        _tvolLabel.font = [UIFont systemFontOfSize:16];
        _tfreqLabel.font = [UIFont systemFontOfSize:16];
        
        _noLabel.textColor = white;
        _brokerLabel.textColor = white;
        _tvalLabel.textColor = white;
        _tvolLabel.textColor = white;
        _tfreqLabel.textColor = white;
        
        _noLabel.backgroundColor = black;
        _brokerLabel.backgroundColor = black;
        _tvalLabel.backgroundColor = black;
        _tvolLabel.backgroundColor = black;
        _tfreqLabel.backgroundColor = black;
        self.backgroundColor = black;
        
        _tvalLabel.textAlignment = NSTextAlignmentRight;
        _tvolLabel.textAlignment = NSTextAlignmentRight;
        _tfreqLabel.textAlignment = NSTextAlignmentRight;
        
        _tvalLabel.adjustsFontSizeToFitWidth = YES;
        _tvolLabel.adjustsFontSizeToFitWidth = YES;
        _tfreqLabel.adjustsFontSizeToFitWidth = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:_noLabel];
        [self addSubview:_brokerLabel];
        [self addSubview:_tvalLabel];
        [self addSubview:_tvolLabel];
        [self addSubview:_tfreqLabel];
    }
    
    return self;
}

@end


@implementation UIHomeTopStockCell

@synthesize noLabel, stockLabel, lastLabel, chgLabel, chgpLabel;

- (id)init
{
    if(self = [super init]) {
        noLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 25, 20)];
        stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 80, 20)];
        lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 0, 67, 20)];
        chgLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 0, 60, 20)];
        chgpLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 0, 60, 20)];
        
        noLabel.text = @"No";
        stockLabel.text = @"Stock";
        lastLabel.text = @"Last";
        chgLabel.text = @"Chg";
        chgpLabel.text = @"%";
        
        noLabel.font = [UIFont systemFontOfSize:16];
        stockLabel.font = [UIFont systemFontOfSize:16];
        lastLabel.font = [UIFont systemFontOfSize:16];
        chgLabel.font = [UIFont systemFontOfSize:16];
        chgpLabel.font = [UIFont systemFontOfSize:16];

        noLabel.textColor = white;
        stockLabel.textColor = white;
        lastLabel.textColor = white;
        chgLabel.textColor = white;
        chgpLabel.textColor = white;
        
        noLabel.backgroundColor = black;
        stockLabel.backgroundColor = black;
        lastLabel.backgroundColor = black;
        chgLabel.backgroundColor = black;
        chgpLabel.backgroundColor = black;
        self.backgroundColor = black;
        
        //noLabel.textAlignment = NSTextAlignmentRight;
        //stockLabel.textAlignment = NSTextAlignmentRight;
        lastLabel.textAlignment = NSTextAlignmentRight;
        chgLabel.textAlignment = NSTextAlignmentRight;
        chgpLabel.textAlignment = NSTextAlignmentRight;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lastLabel.adjustsFontSizeToFitWidth = YES;
        chgLabel.adjustsFontSizeToFitWidth = YES;
        chgpLabel.adjustsFontSizeToFitWidth = YES;
        
        [self addSubview:noLabel];
        [self addSubview:stockLabel];
        [self addSubview:lastLabel];
        [self addSubview:chgLabel];
        [self addSubview:chgpLabel];
    }
    
    return self;
}

@end


@implementation BrokerSummary

@synthesize tval, tvol, tfreq;

- (id)initWithTransaction:(Transaction *)t
{
    self = [super init];
    
    tval = t.buy.value + t.sell.value;
    tvol = t.buy.volume + t.sell.volume;
    tfreq = t.buy.frequency + t.sell.frequency;
    
    return self;
}

@end
