//
//  StandardView.m
//  Ciptadanav3
//
//  Created by Reyhan on 8/1/17.
//  Copyright © 2017 Ciptadana. All rights reserved.
//

#import "StandardView.h"
#import "Util.h"

#define chg(close, prev) prev - close
#define chgprcnt(chg, prev) chg * 100 / prev

#define arrowgreen [UIImage imageNamed:@"arrowgreen"]
#define arrowred [UIImage imageNamed:@"arrowred"]
#define arrowyellow [UIImage imageNamed:@"arrowyellow"]

@interface StandardView()

@property (strong, nonatomic) UILabel *ihsgTxt;
@property (strong, nonatomic) UILabel *chgTxt;
@property (strong, nonatomic) UILabel *chgpctTxt;
@property (strong, nonatomic) UILabel *priceTxt;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation StandardView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat wIhsg = 45.0f;
        CGFloat wChg = 80.0f;
        CGFloat wChgpct = 80.0f;
        CGFloat wPrice = 120.0f;
        CGFloat wImage = 16.0f;
        CGFloat hImage = 16.0f;
        //CGFloat wImage = arrowyellow.size.width;
        //CGFloat hImage = arrowyellow.size.height;
        CGFloat p = 5.0f;
        CGFloat h = 21.0f;
        self.ihsgTxt = [self createLabel:CGRectMake(p, p, wIhsg, h) withTitle:@"IHSG"];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(p + wIhsg + 10, 8, wImage, hImage)];
//        self.chgpctTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + 30, p, wChgpct, h) withTitle:@"+"];
//        self.chgTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + wChgpct + 10, p, wChg, h) withTitle:@""];
//        self.priceTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + wChgpct + wChg + 10, p, wPrice, h) withTitle:@""];
        
        self.priceTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + 30, p, wPrice, h) withTitle:@""];
        self.chgTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + wChgpct + 20, p, wChg, h) withTitle:@""];
        self.chgpctTxt = [self createLabel:CGRectMake(p + wImage + wIhsg + wChgpct + wChg + 10, p, wChgpct, h) withTitle:@"+"];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.image = arrowyellow;
        
        UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26, 1600, 1)];
        separatorView.image = [UIImage imageNamed:@"lineseparator"];
        
        [self addSubview:self.ihsgTxt];
        [self addSubview:self.imageView];
        [self addSubview:self.priceTxt];
        [self addSubview:self.chgTxt];
        [self addSubview:self.chgpctTxt];
        [self addSubview:separatorView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [self.ihsgTxt setFont:FONT_TITLE_DEFAULT_LABEL];
    [self.priceTxt setFont:FONT_TITLE_NUMERIC_LABEL];
    [self.chgTxt setFont:FONT_TITLE_NUMERIC_LABEL];
    [self.chgpctTxt setFont:FONT_TITLE_NUMERIC_LABEL];
    
    [self.ihsgTxt setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    [self.priceTxt setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    [self.chgTxt setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    [self.chgpctTxt setTextColor:COLOR_TITLE_DEFAULT_LABEL];
    
    
    [self.ihsgTxt setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [self.priceTxt setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [self.chgTxt setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
    [self.chgpctTxt setShadowColor:COLOR_TITLE_DEFAULT_LABEL_SHADOW];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma private method

- (UILabel *)createLabel:(CGRect)rect
{
    return [self createLabel:rect withTitle:@""];
}

- (UILabel *)createLabel:(CGRect)rect withTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = title;
    
    return label;
}

#pragma public

- (void)updateComposite:(KiIndices *)composite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        float chg = chg(composite.indices.previous, composite.indices.ohlc.close);
        float chgp = chgprcnt(chg, composite.indices.previous);
        
        [NSLocale localeWithLocaleIdentifier:@"en_GB"] ;
        self.chgTxt.text = [NSString stringWithFormat:@"(%.2f)", chg];
        self.chgpctTxt.text = [NSString stringWithFormat:@"%.2f%%", chgp];
        self.priceTxt.text = [NSString localizedStringWithFormat:@"%.2f", composite.indices.ohlc.close];
        
        if(chg > 0) {
            self.imageView.image = arrowgreen;
            //self.imageView.backgroundColor = GREEN;
            self.chgTxt.textColor = GREEN;
            self.chgpctTxt.textColor = GREEN;
            self.chgpctTxt.textColor = GREEN;
        }
        else if(chg < 0) {
            self.imageView.image = arrowred;
            //self.imageView.backgroundColor = RED;
            self.chgTxt.textColor = RED;
            self.chgpctTxt.textColor = RED;
            self.chgpctTxt.textColor = RED;
        }
        else {
            self.imageView.image = arrowyellow;
            //self.imageView.backgroundColor = YELLOW;
            self.chgTxt.textColor = YELLOW;
            self.chgpctTxt.textColor = YELLOW;
            self.chgpctTxt.textColor = YELLOW;
        }
    });
}
@end
