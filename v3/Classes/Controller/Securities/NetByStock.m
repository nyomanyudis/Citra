//
//  NetByStock.m
//  Ciptadana
//
//  Created by Reyhan on 11/2/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "NetByStock.h"

#import "HKKScrollableGridView.h"
#import "NetByStockTable.h"
#import "TableAlert.h"

@interface NetByStock()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet HKKScrollableGridView *gridView;
@property (weak, nonatomic) IBOutlet UISwitch *switchReguler;
@property (weak, nonatomic) IBOutlet UISwitch *switchNego;
@property (weak, nonatomic) IBOutlet UISwitch *switchCash;


@property (strong, nonatomic) NetByStockTable *table;
@property (retain, nonatomic) NSMutableArray *summaries;

@property (assign, nonatomic) BOOL refreshRequest;
@property (assign, nonatomic) BOOL newRequest;
@property (assign, nonatomic) BOOL unsubsribe;
@property (strong, nonatomic) NSTimer *refreshTimer;

@property (assign, nonatomic) BOOL checkedRegular;
@property (assign, nonatomic) BOOL checkedNego;
@property (assign, nonatomic) BOOL checkedCash;



@end

@implementation NetByStock

@synthesize checkBoxRegular;
@synthesize checkBoxNego;
@synthesize checkBoxCash;

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
    if(self.stockCode) {
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
        if(data) {
            [[MarketFeed sharedInstance] subscribe:RecordTypeStockNetbuysell status:RequestSubscribe code:data.code];
            
            self.codeLabel.text = data.code;
            self.nameLabel.text = data.name;
            
            self.codeLabel.textColor = UIColorFromHex(data.color);
            self.nameLabel.textColor = UIColorFromHex(data.color);
            
            if(![self.table refreshStock:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash]) {
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
    if(self.stockCode) {
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
        if(data) {
            [[MarketFeed sharedInstance] subscribe:RecordTypeStockNetbuysell status:RequestSubscribe code:data.code];
            
            self.codeLabel.text = data.code;
            self.nameLabel.text = data.name;
            
            self.codeLabel.textColor = UIColorFromHex(data.color);
            self.nameLabel.textColor = UIColorFromHex(data.color);
            
            if(![self.table refreshStock:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash]) {
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
    
    self.table = [[NetByStockTable alloc] initWithGridView:self.gridView];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoSort) userInfo:nil repeats:YES];
    
    self.codeLabel.text = @"";
    self.nameLabel.text = @"";
    
    
    self.codeLabel.font = FONT_TITLE_BOLD_LABEL;
    self.nameLabel.font = FONT_TITLE_BOLD_LABEL;
    
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

//- (void) actionCheckBoxRegular {
//    NSLog(@"Sequeunce 4 = %d",self.checkedRegular);
//    if(self.checkedRegular == true){
//        [checkBoxRegular setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        checkBoxRegular.backgroundColor = [UIColor lightGrayColor];
//        self.checkedRegular = false;
//    }
//    else if(self.checkedRegular == false){
//        [checkBoxRegular setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        checkBoxRegular.backgroundColor = [UIColor blackColor];
//        self.checkedRegular = true;
//    }
//    
//    
//    [self performSelector:@selector(viewWillAppearAction) withObject:nil];
//}

- (void) actionCheckBoxNego {
//    NSLog(@"Sequeunce 5 ");
    if(self.checkedNego == true){
        [checkBoxNego setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkBoxNego.backgroundColor = [UIColor lightGrayColor];
        self.checkedNego = false;
    }
    else if(self.checkedNego == false){
        [checkBoxNego setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkBoxNego.backgroundColor = [UIColor blackColor];
        self.checkedNego = true;
    }
    
    [self performSelector:@selector(viewWillAppearAction) withObject:nil];
}

- (void) actionCheckBoxCash {
//    NSLog(@"Sequeunce 6 ");
    if(self.checkedCash == true){
        [checkBoxCash setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        checkBoxCash.backgroundColor = [UIColor lightGrayColor];
        self.checkedCash = false;
    }
    else if(self.checkedCash == false){
        [checkBoxCash setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkBoxCash.backgroundColor = [UIColor blackColor];
        self.checkedCash = true;
    }
    
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
        KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
        if(data)
            [self.table refreshStock:data checkedRegular:self.checkedRegular checkedNego:self.checkedNego checkedCash:self.checkedCash];
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
            else if(record.recordType == RecordTypeStockNetbuysell) {
                //[self updateNetbuysell:record.brokerNetbuysell];
                self.view.alpha = 100;
                if(self.stockCode) {
                    self.refreshRequest = YES;
                    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:self.stockCode];
                    [self.table updateNetbuysell:record.stockNetbuysell stockData:data];
                    
                    if(self.newRequest) {
                        self.newRequest = !self.newRequest;
                        [self.table newNetbuysell:nil stockData:nil];
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
        
        MLTableAlert *alert = [TableAlert alertConfirmationOKOnlyWithColor:cells titleAlert:[NSString stringWithFormat:@"NET B/S Stock %@",self.codeLabel.text] okOnClick:nil cellsColor:cellsColor ];
        [alert setHeight:300.f];
        [alert showWithColor:WHITE];
    };
    self.gridView.callback = callback;
}

@end
