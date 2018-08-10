//
//  NetByBroker.m
//  Ciptadana
//
//  Created by Reyhan on 10/24/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NetByBroker.h"

#import "NetByBrokerTable.h"
#import "Util.h"
#import "PDKeychainBindings.h"
#import "TableAlert.h"

@interface NetByBroker()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (weak, nonatomic) IBOutlet UILabel *brokerCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brokerNameLabel;
@property (strong, nonatomic) NetByBrokerTable *table;
@property (retain, nonatomic) NSMutableArray *summaries;
@property (assign, nonatomic) BOOL refreshRequest;
@property (assign, nonatomic) BOOL newRequest;
@property (assign, nonatomic) BOOL unsubsribe;
@property (strong, nonatomic) NSTimer *refreshTimer;
@property (weak, nonatomic) IBOutlet UIButton *rgButton;
@property (weak, nonatomic) IBOutlet UIButton *ngButton;
@property (weak, nonatomic) IBOutlet UIButton *tnButton;
@property (weak,nonatomic) IBOutlet UISwitch *switchReguler;
@property (weak, nonatomic) IBOutlet UISwitch *switchNego;
@property (weak, nonatomic) IBOutlet UISwitch *switchCash;

@property (assign, nonatomic) BOOL checkedRegular;
@property (assign, nonatomic) BOOL checkedNego;
@property (assign, nonatomic) BOOL checkedCash;

@end


@implementation NetByBroker

- (void)viewWillDisappear:(BOOL)animated
{
    //    NSLog(@"Sequeunce 1 ");
    if(self.unsubsribe) {
        [[MarketFeed sharedInstance ] unsubscribe:RecordTypeStockNetbuysell];
        
        if (self.refreshTimer) {
            [self.refreshTimer invalidate];
            self.refreshTimer = nil;
        }
    }
    //    else {
    //        self.view.alpha = 0;
    //    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Sequeunce 2 =  %d",animated);
    self.unsubsribe = YES;
    if(self.brokerCode) {
        KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataByCode:self.brokerCode];
        if(data) {
            [[MarketFeed sharedInstance] subscribe:RecordTypeBrokerNetbuysell status:RequestSubscribe code:data.code];
            
            self.brokerCodeLabel.text = data.code;
            self.brokerNameLabel.text = data.name;
            
            self.brokerCodeLabel.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
            self.brokerNameLabel.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
            
            if(![self.table refreshBroker:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash]) {
                self.newRequest = YES;
            }
        }
    }
    
    [self reCallbackGrid];
    [self performSelector:@selector(callback) withObject:nil];
    
}

- (void)viewWillAppearAction
{
    //    NSLog(@"Sequeunce 2 ");
    self.unsubsribe = YES;
    if(self.brokerCode) {
        KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataByCode:self.brokerCode];
        if(data) {
            [[MarketFeed sharedInstance] subscribe:RecordTypeBrokerNetbuysell status:RequestSubscribe code:data.code];
            
            self.brokerCodeLabel.text = data.code;
            self.brokerNameLabel.text = data.name;
            
            self.brokerCodeLabel.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
            self.brokerNameLabel.textColor = data.type == InvestorTypeD ? BLACK : MAGENTA;
            
            if(![self.table refreshBroker:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash]) {
                self.newRequest = YES;
            }
        }
    }
    
    [self performSelector:@selector(callback) withObject:nil];
}

- (void)viewDidLoad
{
    //    NSLog(@"Sequeunce 3 ");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // swipe menu
    if(self.revealViewController) {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.table = [[NetByBrokerTable alloc] initWithGridView:self.gridView];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSort) userInfo:nil repeats:YES];
    
    self.brokerCodeLabel.text = @"";
    self.brokerNameLabel.text = @"";
    
    
    self.brokerCodeLabel.font = FONT_TITLE_BOLD_LABEL;
    self.brokerNameLabel.font = FONT_TITLE_BOLD_LABEL;
    
    self.checkedRegular = true;
    self.checkedNego = true;
    self.checkedCash = true;
    
    //    UISwitch *switchReguler = [[UISwitch alloc] init];
    self.switchReguler.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [self.switchReguler addTarget:self action:@selector(setStateReguler:) forControlEvents:UIControlEventValueChanged];
    
    self.switchNego.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [self.switchNego addTarget:self action:@selector(setStateNego:) forControlEvents:UIControlEventValueChanged];
    
    self.switchCash.transform = CGAffineTransformMakeScale(0.50, 0.50);
    [self.switchCash addTarget:self action:@selector(setStateCash:) forControlEvents:UIControlEventValueChanged];
    
    
    //    [checkBoxRegular addTarget:self action:@selector(actionCheckBoxRegular) forControlEvents:UIControlEventTouchUpInside];
    //    [checkBoxRegular setBackgroundImage:nil forState:UIControlStateNormal];
    //    [checkBoxRegular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    checkBoxRegular.backgroundColor = [UIColor blackColor];
    
    //    [checkBoxNego addTarget:self action:@selector(actionCheckBoxNego) forControlEvents:UIControlEventTouchUpInside];
    //    [checkBoxNego setBackgroundImage:nil forState:UIControlStateNormal];
    //    [checkBoxNego setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    checkBoxNego.backgroundColor = [UIColor blackColor];
    //
    //    [checkBoxCash addTarget:self action:@selector(actionCheckBoxCash) forControlEvents:UIControlEventTouchUpInside];
    //    [checkBoxCash setBackgroundImage:nil forState:UIControlStateNormal];
    //    [checkBoxCash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    checkBoxCash.backgroundColor = [UIColor blackColor];
    
}

- (void)setStateReguler:(id)sender
{
    BOOL state = [sender isOn];
    if(state == YES)
        self.checkedRegular = true;
    else if(state == NO)
        self.checkedRegular = false;
    
    [self performSelector:@selector(viewWillAppearAction) withObject:nil];
}

- (void)setStateNego:(id)sender
{
    BOOL state = [sender isOn];
    if(state == YES)
        self.checkedNego = true;
    else if(state == NO)
        self.checkedNego = false;
    
    [self performSelector:@selector(viewWillAppearAction) withObject:nil];
}

- (void)setStateCash:(id)sender
{
    BOOL state = [sender isOn];
    if(state == YES)
        self.checkedCash = true;
    else if(state == NO)
        self.checkedCash = false;
    
    [self performSelector:@selector(viewWillAppearAction) withObject:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSLog(@"Sequeunce 7 ");
    self.unsubsribe = NO;
}

#pragma mark - private

- (void)autoSort
{
    //    NSLog(@"Sequeunce 8 ");
    if(self.refreshRequest) {
        self.refreshRequest = NO;
        NSLog(@"auto-sort");
        KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataByCode:self.brokerCode];
        if(data)
            [self.table refreshBroker:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash];
    }
    
    self.view.alpha = 100;
}

#pragma mark - protected

- (void)callback
{
    //    NSLog(@"Sequeunce 9 ");
    //__weak typeof(self) theSelf = self;
    id recordCallback =  ^void(KiRecord *record, NSString *message, BOOL ok) {
        if(ok && record) {
            if(record.recordType == RecordTypeKiIndices) {
                [self updateIndices:record];
            }
            else if(record.recordType == RecordTypeBrokerNetbuysell) {
                //[self updateNetbuysell:record.brokerNetbuysell];
                self.view.alpha = 100;
                if(self.brokerCode) {
                    self.refreshRequest = YES;
                    KiBrokerData *data = [[MarketData sharedInstance] getBrokerDataByCode:self.brokerCode];
                    [self.table updateNetbuysell:record.brokerNetbuysell brokerData:data];
                    
                    if(self.newRequest) {
                        self.newRequest = !self.newRequest;
                        [self.table newNetbuysell:nil brokerData:nil];
                    }
                }
            }
        }
    };
    
    [MarketFeed sharedInstance].callback = recordCallback;
}



- (void)reCallbackGrid
{
    HKKScrollableGridCallback callback = ^void(NSInteger index, id object) {
        NSMutableArray *result = [NSMutableArray array];
        result = [self.table getArrayTransaction:index];
        
        //        for(int i=0;i<[result count];i++){
        //            NSLog(@"index recallbackGrid %d = %@",i,[result objectAtIndex:i]);
        //        }
        
        NSArray *cells = [NSArray arrayWithObjects: @"Broker",[NSString stringWithFormat:@": %@",[result objectAtIndex:0]],
                          @"Name",[NSString stringWithFormat:@": %@",[result objectAtIndex:1]],
                          @"TVal",[NSString stringWithFormat:@": %@",[result objectAtIndex:2]],
                          @"TLot",[NSString stringWithFormat:@": %@",[result objectAtIndex:3]],
                          @"NVal",[NSString stringWithFormat:@": %@",[result objectAtIndex:4]],
                          @"NLot",[NSString stringWithFormat:@": %@",[result objectAtIndex:5]],
                          @"TFreq",[NSString stringWithFormat:@": %@",[result objectAtIndex:6]],
                          nil];
        
        NSArray *cellsColor = [NSArray arrayWithObjects:[result objectAtIndex:7],[result objectAtIndex:8],nil];
        
        MLTableAlert *alert = [TableAlert alertConfirmationOKOnlyWithColor:cells titleAlert:[NSString stringWithFormat:@"NET B/S Broker %@",self.brokerCodeLabel.text] okOnClick:nil cellsColor:cellsColor ];
        [alert setHeight:300.f];
        [alert showWithColor:WHITE];
    };
    self.gridView.callback = callback;
}

@end
