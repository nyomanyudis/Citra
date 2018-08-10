//
//  RegionalSummaryViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "RegionalSummaryViewController.h"
#import "ImageResources.h"
#import "AppDelegate.h"
#import "UIColor+ColorStyle.h"
#import "AgentFeed.h"

//#define CHOICES @[@"Currency", @"Indices", @"Regional Indices", @"Clear"]
#define CHOICES @[@"Indices", @"Regional Indices", @"Future"]
#define KEYS @[@"DROP1", @"DROP2", @"DROP3", @"DROP4", @"DROP5", @"DROP6", @"DROP7", @"DROP8", @"DROP9", @"DROP10"]
#define KEY @"DROP"


@interface RegionalSummaryViewController () <UIDropListDelegate, ChannelViewControllerDelegate>

@property NSNumberFormatter *formatter2comma;

@end

static NSDictionary *dictionary;

@implementation RegionalSummaryViewController
{
    //    NSDictionary *dictionary;
    NSArray *arraySummary;
    
    unsigned int dropTag;
    BOOL firstOpen;
}

@synthesize homeBarItem, backBarItem;
@synthesize drop1, drop2, drop3, drop4, drop5, drop6, drop7, drop8, drop9, drop10;
@synthesize scroll;

- (void)backBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:YES completion:^{
    }];

}

- (void)homeBarItemClicked:(id)s
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.previouseController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton *backButton = [self backTabButton];
    UIButton *homeButton = [self homeTabButton];
    [backButton addTarget:self action:@selector(backBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    [homeButton addTarget:self action:@selector(homeBarItemClicked:) forControlEvents:UIControlEventTouchDown];
    
    [backBarItem setCustomView:backButton];
    [homeBarItem setCustomView:homeButton];
    
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];
    
    _formatter2comma =  [[NSNumberFormatter alloc] init];
    [_formatter2comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [_formatter2comma setMaximumFractionDigits:2];
    [_formatter2comma setMinimumFractionDigits:2];
    [_formatter2comma setRoundingMode:NSNumberFormatterRoundDown];
    [_formatter2comma setDecimalSeparator:@"."];
    [_formatter2comma setGroupingSeparator:@","];
    [_formatter2comma setAllowsFloats:YES];
    
    firstOpen = YES;
    
    [drop1 arrayList:CHOICES withTitleCallback:NO];
    [drop2 arrayList:CHOICES withTitleCallback:NO];
    [drop3 arrayList:CHOICES withTitleCallback:NO];
    [drop4 arrayList:CHOICES withTitleCallback:NO];
    [drop5 arrayList:CHOICES withTitleCallback:NO];
    [drop6 arrayList:CHOICES withTitleCallback:NO];
    [drop7 arrayList:CHOICES withTitleCallback:NO];
    [drop8 arrayList:CHOICES withTitleCallback:NO];
    [drop9 arrayList:CHOICES withTitleCallback:NO];
    [drop10 arrayList:CHOICES withTitleCallback:NO];
    
    drop1.dropDelegate = self;
    drop2.dropDelegate = self;
    drop3.dropDelegate = self;
    drop4.dropDelegate = self;
    drop5.dropDelegate = self;
    drop6.dropDelegate = self;
    drop7.dropDelegate = self;
    drop8.dropDelegate = self;
    drop9.dropDelegate = self;
    drop10.dropDelegate = self;
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    RegionalSummaryPacket *p1 = [[RegionalSummaryPacket alloc] initWithPacket:@"DJIA" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p2 = [[RegionalSummaryPacket alloc] initWithPacket:@"COMPOSITE" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p3 = [[RegionalSummaryPacket alloc] initWithPacket:@"FTSE" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p4 = [[RegionalSummaryPacket alloc] initWithPacket:@"HSI" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p5 = [[RegionalSummaryPacket alloc] initWithPacket:@"CAC" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p6 = [[RegionalSummaryPacket alloc] initWithPacket:@"KSCI" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p7 = [[RegionalSummaryPacket alloc] initWithPacket:@"DAX" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p8 = [[RegionalSummaryPacket alloc] initWithPacket:@"SNI" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p9 = [[RegionalSummaryPacket alloc] initWithPacket:@"SPX" price:0 chg:0 chgp:0 channel:ChanelClear];
    RegionalSummaryPacket *p10 = [[RegionalSummaryPacket alloc] initWithPacket:@"KCOM" price:0 chg:0 chgp:0 channel:ChanelClear];
    [p1 initLabel:self.name1 price:self.price1 chg:self.chg1 chgp:self.chgp1 img:self.image1 droplist:self.drop1];
    [p2 initLabel:self.name2 price:self.price2 chg:self.chg2 chgp:self.chgp2 img:self.image2 droplist:self.drop2];
    [p3 initLabel:self.name3 price:self.price3 chg:self.chg3 chgp:self.chgp3 img:self.image3 droplist:self.drop3];
    [p4 initLabel:self.name4 price:self.price4 chg:self.chg4 chgp:self.chgp4 img:self.image4 droplist:self.drop4];
    [p5 initLabel:self.name5 price:self.price5 chg:self.chg5 chgp:self.chgp5 img:self.image5 droplist:self.drop5];
    [p6 initLabel:self.name6 price:self.price6 chg:self.chg6 chgp:self.chgp6 img:self.image6 droplist:self.drop6];
    [p7 initLabel:self.name7 price:self.price7 chg:self.chg7 chgp:self.chgp7 img:self.image7 droplist:self.drop7];
    [p8 initLabel:self.name8 price:self.price8 chg:self.chg8 chgp:self.chgp8 img:self.image8 droplist:self.drop8];
    [p9 initLabel:self.name9 price:self.price9 chg:self.chg9 chgp:self.chgp9 img:self.image9 droplist:self.drop9];
    [p10 initLabel:self.name10 price:self.price10 chg:self.chg10 chgp:self.chgp10 img:self.image10 droplist:self.drop10];
    
    p2.channel = ChannelIndices;
    p1.channel = ChannelRegionalIndices;
    p3.channel = ChannelRegionalIndices;
    p4.channel = ChannelRegionalIndices;
    p5.channel = ChannelRegionalIndices;
    p6.channel = ChannelRegionalIndices;
    p7.channel = ChannelRegionalIndices;
    p8.channel = ChannelRegionalIndices;
    p9.channel = ChannelRegionalIndices;
    p10.channel = ChannelRegionalIndices;
    
    arraySummary = [NSArray arrayWithObjects:p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, nil];
    
    dictionary = [NSDictionary dictionaryWithObjects:arraySummary forKeys:KEYS];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[AgentFeed sharedInstance] agentSelector:@selector(AgentFeedCallback:) withObject:self];

    if(firstOpen) {
        firstOpen = NO;

        RegionalSummaryPacket *p2 = [dictionary objectForKey:KEYS[1]];
        
        p2.nameLabel.text = @"IHSG";
        p2.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgPrice]];
        p2.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChg]];
        p2.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChgp]]];
        [self packetColor:p2 change:self.ihsgChg];
        
        for (RegionalSummaryPacket *p in dictionary.allValues) {
            if(p.channel == ChannelRegionalIndices) {
                [self regionalIndicesData:p code:p.code];
            }
        }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackBarItem:nil];
    [self setHomeBarItem:nil];
    [self setDrop1:nil];
    [self setScroll:nil];
    [super viewDidUnload];
}

#pragma mark
#pragma DataFeedAgentCallback
- (void)AgentFeedCallback:(KiRecord *)record
{
    if (RecordTypeKiIndices == record.recordType) {
        [self updateIndices:record.indices];
        [self updateIndicesIHSG:record.indices];
    }
    else if(RecordTypeKiRegionalIndices == record.recordType) {
        [self updateRegionalIndices:record.regionalIndices];
    }
    else if(RecordTypeFutures == record.recordType) {
        [self updateFutures:record.future];
    }
}

- (void)updateIndices:(NSArray *)arrayKi
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSString *k in KEYS) {
            RegionalSummaryPacket *p = [dictionary objectForKey:k];
            if(ChannelIndices == p.channel) {
                for(KiIndices *i in arrayKi) {
                    KiIndicesData *d = [[DBLite sharedInstance] getIndicesData:i.codeId];
                    
                    NSString *code = d.code;
                    if([code isEqualToString:@"COMPOSITE"])
                        code = @"IHSG";
                    
                    if([code isEqualToString:p.nameLabel.text] || [@"COMPOSITE" isEqualToString:p.code]) {
                        
                        float price = i.indices.ohlc.close;
                        float chg = price - i.indices.previous;
                        float chgp = chgprcnt(chg, i.indices.previous);
                        
                        p.nameLabel.text = code;
                        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                        p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                        p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                        
                        [self packetColor:p change:chg];
                        
                        break;
                    }
                }
            }
        }
    });
}

- (void)updateRegionalIndices:(NSArray *)arrayKi
{
    NSArray *sources = dictionary.allValues;
    dispatch_async(dispatch_get_main_queue(), ^{
        for(RegionalSummaryPacket *p in sources) {
            if(ChannelRegionalIndices == p.channel) {
                for(KiRegionalIndices *i in arrayKi) {
                    
                    
                    KiRegionalIndicesData *d = [[DBLite sharedInstance] getRegionalIndicesDataById:i.codeId];
                    
                    if ([d.name isEqualToString:@"Hang Seng"]) {
                        NSLog(@"%s \nlabel   : %@, \nlast    : %f, \nchange  : %f, \nchange%% : %f", __PRETTY_FUNCTION__, d.name, i.previous, i.previous - i.ohlc.close, ((i.previous - i.ohlc.close) * 100) / i.previous);
                    }
                    
                    if([d.name isEqualToString:p.nameLabel.text]) {
                        float price = i.previous;
                        float chg = price - i.ohlc.close;//chg(i.ohlc.close, i.previous);
                        float chgp = chgprcnt(chg, i.previous);
                        
                        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                        p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                        p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                        
                        [self packetColor:p change:chg];
                        
                        break;
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
            if(ChannelFuture == p.channel) {
                for(KiFuture *future in futures) {
                    
                    KiRegionalIndicesData *data = [[DBLite sharedInstance] getRegionalIndicesDataById:future.codeId];
                    
                    if([data.fullname isEqualToString:p.nameLabel.text]) {
                        float chg = future.ohlc.close - future.previous;
                        float chgp = chgprcnt(chg, future.previous);
                        
                        float price = [[NSString stringWithFormat:@"%.2f", future.previous] floatValue];
                        
                        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                        p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                        p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                        
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
#pragma UIDropListDelegate
- (void)onDripClicked:(id)dropList title:(NSString *)title index:(NSInteger)index
{
    
    UIDropList *dl = dropList;
    dropTag = (int)dl.tag;
    
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
}

- (RegionalSummaryPacket *)packet:(NSInteger)tag
{
    NSString *key = [NSString stringWithFormat:@"%@%i", KEY, (int)tag];
    return [dictionary objectForKey:key];
}

- (void)clearPacket:(RegionalSummaryPacket*)p
{
    p.code = @"";
    p.nameLabel.text = @"";
    p.priceLabel.text = @"";
    p.chgLabel.text = @"";
    p.chgpLabel.text = @"";
    p.imageView.image = nil;
    p.channel = ChanelClear;
    
    [p.droplist showRightIcon:YES];
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
- (void)onChannelCurrency:(KiCurrency *)currency
{
}

- (void)onChannelIndicesData:(KiIndicesData *)kiIndicesData
{
    RegionalSummaryPacket *p = [self packet:dropTag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    NSString *code = kiIndicesData.code;
    if([code isEqualToString:@"COMPOSITE"]) {
        code = @"IHSG";
        
        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgPrice]];
        p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChg]];
        p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChgp]]];

        [self packetColor:p change:self.ihsgChg];
    }
    else {
        KiIndices *kiIndices = [[DBLite sharedInstance] getIndicesById:kiIndicesData.id];
        if(nil != kiIndices) {
            float chg = chg(kiIndices.indices.previous, kiIndices.indices.ohlc.close);
            float chgp = chgprcnt(chg, kiIndices.indices.previous);
            float price = [[NSString stringWithFormat:@"%.2f", kiIndices.indices.ohlc.close] floatValue];
            
            p.code = @"";
            p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
            p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
            p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
            
            [self packetColor:p change:chg];
        }
    }
    
    p.channel = ChannelIndices;
    p.nameLabel.text = code;
    [p.droplist showRightIcon:NO];
}

- (void)onChannelIndices:(KiIndices *)indices
{
    NSLog(@"onChannelIndices:");
}

- (void)onChannelRegionalIndices:(KiRegionalIndices *)indices
{
    NSLog(@"onChannelRegionalIndices:");
}

- (void)onChannelFuture:(KiFuture*)future
{
    RegionalSummaryPacket *p = [self packet:dropTag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    KiRegionalIndicesData *data = [[DBLite sharedInstance] getRegionalIndicesDataById:future.codeId];
    if(nil != data) {
        float chg = future.ohlc.close - future.previous;
        float chgp = chgprcnt(chg, future.previous);
        
        p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:future.previous]];
        p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
        p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
        
        [self packetColor:p change:chg];
    }
    
    p.channel = ChannelFuture;
    p.nameLabel.text = data.fullname;
}

- (void)onChannelRegionalIndicesData:(KiRegionalIndicesData *)indices
{
    RegionalSummaryPacket *p = [self packet:dropTag];
    
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
   
    if(nil != p) {
        KiRegionalIndices *kiRegionalIndices = [[DBLite sharedInstance] getRegionalIndicesById:indices.id];
        if(nil != kiRegionalIndices) {
            float price = kiRegionalIndices.previous;
            float chg = price - kiRegionalIndices.ohlc.close;//chg(kiRegionalIndices.ohlc.close, kiRegionalIndices.previous);
            float chgp = chgprcnt(chg, kiRegionalIndices.previous);
            
            p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
            p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
            p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
            
            [self packetColor:p change:chg];
            
        }
        
        p.channel = ChannelRegionalIndices;
        p.nameLabel.text = indices.name;
    }
}

- (void)regionalIndicesData:(RegionalSummaryPacket *)p code:(NSString *)code
{   
    if(![@"" isEqualToString:p.nameLabel.text])
        [self clearPacket:p];
    
    for (KiRegionalIndicesData *data in [DBLite sharedInstance].getRegionalIndicesData) {
    
        if([data.code isEqualToString:code]) {
            KiRegionalIndices *kiRegionalIndices = [[DBLite sharedInstance] getRegionalIndicesById:data.id];
            if(nil != kiRegionalIndices) {
                float price = kiRegionalIndices.previous;
                float chg = price - kiRegionalIndices.ohlc.close;//chg(kiRegionalIndices.ohlc.close, kiRegionalIndices.previous);
                float chgp = chgprcnt(chg, kiRegionalIndices.previous);
                
                p.priceLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:price]];
                p.chgLabel.text = [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chg]];
                p.chgpLabel.text = [NSString stringWithFormat:@"%@%%", [self.formatter2comma stringFromNumber:[NSNumber numberWithFloat:chgp]]];
                
                [self packetColor:p change:chg];
                
            }
            
            p.channel = ChannelRegionalIndices;
            p.nameLabel.text = data.name;
            [p.droplist showRightIcon:NO];
            
            break;
        }
    }
}

- (void)onHttpChannelIndices:(NSArray *)fields{}
- (void)onHttpChannelRegional:(NSArray *)fields{}
- (void)onHttpChannelFuture:(NSArray *)fields{}

@end




@implementation RegionalSummaryPacket

//@synthesize name, price, chg, chgp;

- (id)initWithPacket:(NSString *)code price:(NSInteger)price chg:(NSInteger)chg chgp:(NSInteger)chgp channel:(SubChannel)channel
{
    if(self = [super init]) {
        NSLog(@"%s ## CODE %@", __PRETTY_FUNCTION__, code);
        self.code = code;
        self.price = price;
        self.chg = chg;
        self.chgp = chgp;
        self.channel = channel;
    }
    
    return self;
}

- (void)initLabel:(UILabel *)nameLabel price:(UILabel *)priceLabel chg:(UILabel *)chgLabel chgp:(UILabel *)chgpLabel img:(UIImageView *)imageView droplist:(UIDropList*)droplist
{
    self.nameLabel = nameLabel;
    self.priceLabel = priceLabel;
    self.chgLabel = chgLabel;
    self.chgpLabel = chgpLabel;
    self.imageView = imageView;
    self.droplist = droplist;
}

@end