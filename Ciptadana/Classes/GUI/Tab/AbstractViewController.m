//
//  AbstractViewController.m
//  Ciptadana
//
//  Created by Reyhan on 9/26/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "Protocol.pb.h"
#import "AppDelegate.h"
#import "ImageResources.h"
#import "UIButton+Customized.h"

//#import "TransitionDelegate.h"


#define image_up [ImageResources imageStockUp]
#define image_down [ImageResources imageStockDown]


@interface AbstractViewController ()

@property (assign, nonatomic) UIViewController *prevController;
@property (retain, nonatomic) UILabel *ihsgLabel;
@property (retain, nonatomic) UILabel *priceLabel;
@property (retain, nonatomic) UILabel *chgLabel;
@property (retain, nonatomic) UILabel *chgpLabel;
@property (retain, nonatomic) UIImageView *imageView;

@property NSNumberFormatter *formatter3comma;


//@property (strong, nonatomic) TransitionDelegate *transitionController;

@end

@implementation AbstractViewController

@synthesize ihsgLabel, priceLabel, chgLabel,chgpLabel, imageView;
@synthesize prevController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.transitionController = [[TransitionDelegate alloc] init];
//        self.transitioningDelegate = self.transitionController;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[AgentFeed sharedInstance] agentSelector:nil withObject:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _formatter3comma = [[NSNumberFormatter alloc] init];
    [_formatter3comma setNumberStyle:NSNumberFormatterDecimalStyle];
    [_formatter3comma setMaximumFractionDigits:3];
    [_formatter3comma setMinimumFractionDigits:3];
    [_formatter3comma setRoundingMode:NSNumberFormatterRoundDown];
    [_formatter3comma setDecimalSeparator:@"."];
    [_formatter3comma setGroupingSeparator:@","];
    [_formatter3comma setAllowsFloats:YES];
    
    uint y = 20;
    ihsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 44 + y, 42, 21)];
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 44 + y, 77, 21)];
    chgLabel = [[UILabel alloc] initWithFrame:CGRectMake(188, 44 + y, 60, 21)];
    chgpLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 44 + y, 60, 21)];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(149, 45 + y, 20, 20)];
    
    ihsgLabel.text = @"IHSG";
    
    KiIndices *indices = [[DBLite sharedInstance] getIndicesCode:@"COMPOSITE"];
    if (nil != indices)
        [self updateIndicesIHSG:@[indices]];
    
    chgLabel.adjustsFontSizeToFitWidth = YES;
    
    ihsgLabel.font = [UIFont systemFontOfSize:17];
    priceLabel.font = [UIFont systemFontOfSize:14];
    chgLabel.font = [UIFont systemFontOfSize:14];
    chgpLabel.font = [UIFont systemFontOfSize:14];
    
    priceLabel.textAlignment = NSTextAlignmentRight;
    chgLabel.textAlignment = NSTextAlignmentRight;
    chgpLabel.textAlignment = NSTextAlignmentRight;
    
    ihsgLabel.textColor = white;
    priceLabel.textColor = white;
    chgpLabel.textColor = white;
    chgpLabel.textColor = white;
    
    ihsgLabel.backgroundColor = black;
    priceLabel.backgroundColor = black;
    chgpLabel.backgroundColor = black;
    chgLabel.backgroundColor = black;
    
    [self.view addSubview:ihsgLabel];
    [self.view addSubview:priceLabel];
    [self.view addSubview:imageView];
    [self.view addSubview:chgLabel];
    [self.view addSubview:chgpLabel];
}

- (void)tapGestureRecognizer
{
    // Dismiss the keyboard when the user taps outside of a text field
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (UIButton *)backTabButton
{
    UIImage *image = [ImageResources imageBack];
    
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 15, image.size.height + 5)];
    buttonAction.frame = CGRectMake(0, 0, image.size.width + 15, image.size.height + 5);
    
    [buttonAction setImage:image forState:UIControlStateNormal];
    [buttonAction setImage:image forState:UIControlStateHighlighted];
    
    
    return buttonAction;
}

- (UIButton *)homeTabButton
{
    UIImage *image = [ImageResources imageHome];
    
    UIButton *buttonAction = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 5, image.size.height + 5)];
    buttonAction.frame = CGRectMake(0, 0, image.size.width + 5, image.size.height + 5);
    
    [buttonAction setImage:image forState:UIControlStateNormal];
    [buttonAction setImage:image forState:UIControlStateHighlighted];
    

    return buttonAction;
}

- (void)setPreviouseController:(UIViewController *)ctrl
{
    prevController = ctrl;
}

- (UIViewController *)previouseController
{
    return prevController;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self unsubscribeIhsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateIndicesIHSG:(NSArray *)arrayIndices
{
//    if (nil != [DBLite sharedInstance].getStockSummaries && [DBLite sharedInstance].getStockSummaries.count > 0 && nil != arrayIndices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (KiIndices *indices in arrayIndices) {
                KiIndicesData *data = [[DBLite sharedInstance] getIndicesData:indices.codeId];
                if ([data.code isEqualToString:@"COMPOSITE"]) {
                    float chg = chg(indices.indices.previous, indices.indices.ohlc.close);
                    float chgp = chgprcnt(chg, indices.indices.previous);
                    
                    self.ihsgPrice = indices.indices.ohlc.close;
                    self.ihsgChg = chg;
                    self.ihsgChgp = chgp;
                    
                    priceLabel.text = [self.formatter3comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgPrice]];
                    chgLabel.text = [self.formatter3comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChg]];
                    chgpLabel.text = [NSString stringWithFormat:@"%@%%",[self.formatter3comma stringFromNumber:[NSNumber numberWithFloat:self.ihsgChgp]]];
                    
                    imageView.image = chg > 0 ? image_up : chg < 0 ? image_down : nil;
                    priceLabel.textColor = chg == 0 ? yellow : chg > 0 ?  GREEN : red;
                    chgLabel.textColor = chg == 0 ? yellow : chg > 0 ? GREEN : red;
                    chgpLabel.textColor = chg == 0 ? yellow : chg > 0 ? GREEN : red;
                    
                    return;
                }
            }
            
        });
//    }
}



UILabel* labelOnTable(CGRect frame)
{
    return labelOnTableWithLabel(@"", frame);
}

UILabel* labelOnTableWithLabel(NSString *l, CGRect frame)
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentRight;
    
    label.text = l;
    label.textColor = white;
    label.backgroundColor = black;
    label.font = [UIFont systemFontOfSize:12];
    
    return label;
}

@end
