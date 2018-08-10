//
//  Scroll1View.m
//  Ciptadana
//
//  Created by Reyhan on 9/24/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Scroll1View.h"
#import "ImageResources.h"
#import "DisclaimerViewController.h"
#import "AppDelegate.h"
#import "UIView+DropShadow.h"
#import "WebControllerViewController.h"

@interface Scroll1View()

@property (strong, nonatomic) UITableView *tablechooser;
@property (strong, nonatomic) UIView *popchooser;
@property (strong, nonatomic) NSString *webTitle;

@end

@implementation Scroll1View

@synthesize ihsgImageView;
@synthesize ihsgPriceLabel;
@synthesize ihsgChgLabel;
@synthesize ihsgChgpLabel;

@synthesize valLabel;
@synthesize volLabel;
@synthesize freqLabel;

@synthesize currencyLabel;
@synthesize currencyPriceLabel;
@synthesize currencyChgLabel;
@synthesize currencyChgpLabel;
@synthesize currencyImageView;
@synthesize disclaimerButton, contactButton, joinUsButton;
@synthesize tablechooser, popchooser;
@synthesize webTitle;

@synthesize bg1, bg2;

- (id)initWithParent:(ViewController*)parent
{
    if(self = [super init]) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        webTitle = [NSString stringWithFormat:@"CITRA %@", version];
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"Scroll1View" owner:self options:nil] objectAtIndex:0];
        
        bg1.backgroundColor = [UIColor colorWithPatternImage:separatorImage()];
        bg2.backgroundColor = [UIColor colorWithPatternImage:separatorImage()];
        
        bg1.layer.borderColor = [[UIColor whiteColor] CGColor];
        bg2.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        bg1.layer.borderWidth = .35f;
        bg2.layer.borderWidth = .35f;
        
        bg1.layer.cornerRadius = 7.25f;
        bg2.layer.cornerRadius = 7.25f;
        
        [disclaimerButton addTarget:self action:@selector(disclaimerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [contactButton addTarget:self action:@selector(contactButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [joinUsButton addTarget:self action:@selector(joinUsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //popup button
        UIButton *individuBtn = [self makeHyperlinkBtn:@"Nasabah Baru" frame:CGRectMake(10, 4, 130, 14)];
        //UIButton *institutionallBtn = [self makeHyperlinkBtn:@"Institutional" frame:CGRectMake(10, 4 + 17 + 5, 130, 14)];
        UIButton *nasabahTerdaftarBtn = [self makeHyperlinkBtn:@"Nasabah Terdaftar" frame:CGRectMake(10, 4 + 17 + 5, 130, 14)];
        //UIButton *nasabahTerdaftarBtn = [self makeHyperlinkBtn:@"Nasabah Terdaftar" frame:CGRectMake(10, 4 + 34 + 10, 130, 14)];
        
        [individuBtn addTarget:self action:@selector(individuBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        //[institutionallBtn addTarget:self action:@selector(institutionallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [nasabahTerdaftarBtn addTarget:self action:@selector(nasabahTerdaftarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        popchooser = [[UIView alloc] initWithFrame:CGRectMake(joinUsButton.frame.origin.x, joinUsButton.frame.origin.y-42, 140.0f, 50.0f)];
        popchooser.backgroundColor = white;
        popchooser.layer.cornerRadius = 10.f;
        
        [popchooser addDropShadow:[UIColor whiteColor] withOffset:CGSizeMake(2, 2) radius:.3f opacity:.15];
        [popchooser addSubview:individuBtn];
        //[popchooser addSubview:institutionallBtn];
        [popchooser addSubview:nasabahTerdaftarBtn];
        
        
    }
    
    return self;
}

- (UIButton *)makeHyperlinkBtn:(NSString*)title frame:(CGRect)frame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString *atrribute=[[NSMutableAttributedString alloc]initWithString:title];
    [atrribute addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:1]
                  range:(NSRange){0,[atrribute length]}];
    
    button.frame = frame;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setAttributedTitle:atrribute forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button.titleLabel setTextColor:[UIColor blueColor]];
    return  button;
}

- (void)disclaimerButtonClicked
{
    DisclaimerViewController *vc = [[DisclaimerViewController alloc] initWithNibName:@"DisclaimerViewController" bundle:[NSBundle mainBundle]];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
//    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentModalViewController:vc animated:YES];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:vc animated:YES completion:nil];
    
}

- (void)contactButtonClicked
{
    DisclaimerViewController *vc = [[DisclaimerViewController alloc] initWithNibName:@"DisclaimerViewController" bundle:[NSBundle mainBundle]];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:vc animated:YES completion:nil];
    
    vc.titleBarItem.title = @"Contact Us";
    vc.textarea.text = @"PT CIPTADANA SECURITIES\n\nPlaza ASIA (d/h. ABDA)\nOffice Park Unit 2\nJl. Jend. Sudirman kav. 59\nJakarta 12190, Indonesia\nT +62 21 2557 4800\nF +62 21 2557 4900\nE customerservice@ciptadana.com\nwww.ciptadana.com";
}

- (void)joinUsButtonClicked
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ciptadana-securities.com/online-registration-individual/new"]];
    [self showPopup];
}

- (void)individuBtnClicked
{
    [self hidePopup];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ciptadana-securities.com/online-registration-individual/new"]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    webTitle = [NSString stringWithFormat:@"CITRA %@", version];
    NSString *url = @"http://ciptadana-securities.com/online-registration-individual/new";
    WebControllerViewController *vc = [[WebControllerViewController alloc] initWithNibName:@"WebControllerViewController" bundle:[NSBundle mainBundle] title:webTitle uri:url];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:vc animated:YES completion:nil];
}

- (void)institutionallBtnClicked
{
    [self hidePopup];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ciptadana-securities.com/online-registration-institutional/new"]];
    NSString *url = @"http://ciptadana-securities.com/online-registration-institutional/new";
    WebControllerViewController *vc = [[WebControllerViewController alloc] initWithNibName:@"WebControllerViewController" bundle:[NSBundle mainBundle] title:webTitle uri:url];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:vc animated:YES completion:nil];
}

- (void)nasabahTerdaftarBtnClicked
{
    [self hidePopup];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://citramobile.ciptadana.com/citra/existing"]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    webTitle = [NSString stringWithFormat:@"CITRA %@", version];
    NSString *url = @"http://citramobile.ciptadana.com/citra/existing";
    WebControllerViewController *vc = [[WebControllerViewController alloc] initWithNibName:@"WebControllerViewController" bundle:[NSBundle mainBundle] title:webTitle uri:url];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController presentViewController:vc animated:YES completion:nil];
}

- (void)showPopup
{
    if(![popchooser superview]) {
        [self addSubview:popchooser];
        popchooser.transform = CGAffineTransformMakeScale(1.3, 1.3);
        popchooser.alpha = 0;
        
        [UIView animateWithDuration:.20 animations:^{
            popchooser.alpha = 1;
            popchooser.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
}

- (void)hidePopup
{
    [UIView animateWithDuration:.15 animations:^{
        popchooser.transform = CGAffineTransformMakeScale(1.3, 1.3);
        popchooser.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [popchooser removeFromSuperview];
        }
    }];
}

#pragma mark
#pragma touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([popchooser superview]) {
        [self hidePopup];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([popchooser superview]) {
        [self hidePopup];
    }
}
    

@end
