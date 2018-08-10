//
//  RegionalSummaryViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/30/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "UIDropList.h"
#import "ChannelViewController.h"

@interface RegionalSummaryViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;


@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIDropList *drop1;
@property (weak, nonatomic) IBOutlet UIDropList *drop2;
@property (weak, nonatomic) IBOutlet UIDropList *drop3;
@property (weak, nonatomic) IBOutlet UIDropList *drop4;
@property (weak, nonatomic) IBOutlet UIDropList *drop5;
@property (weak, nonatomic) IBOutlet UIDropList *drop6;
@property (weak, nonatomic) IBOutlet UIDropList *drop7;
@property (weak, nonatomic) IBOutlet UIDropList *drop8;
@property (weak, nonatomic) IBOutlet UIDropList *drop9;
@property (weak, nonatomic) IBOutlet UIDropList *drop10;

@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *name3;
@property (weak, nonatomic) IBOutlet UILabel *name4;
@property (weak, nonatomic) IBOutlet UILabel *name5;
@property (weak, nonatomic) IBOutlet UILabel *name6;
@property (weak, nonatomic) IBOutlet UILabel *name7;
@property (weak, nonatomic) IBOutlet UILabel *name8;
@property (weak, nonatomic) IBOutlet UILabel *name9;
@property (weak, nonatomic) IBOutlet UILabel *name10;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;
@property (weak, nonatomic) IBOutlet UIImageView *image7;
@property (weak, nonatomic) IBOutlet UIImageView *image8;
@property (weak, nonatomic) IBOutlet UIImageView *image9;
@property (weak, nonatomic) IBOutlet UIImageView *image10;

@property (weak, nonatomic) IBOutlet UILabel *price1;
@property (weak, nonatomic) IBOutlet UILabel *price2;
@property (weak, nonatomic) IBOutlet UILabel *price3;
@property (weak, nonatomic) IBOutlet UILabel *price4;
@property (weak, nonatomic) IBOutlet UILabel *price5;
@property (weak, nonatomic) IBOutlet UILabel *price6;
@property (weak, nonatomic) IBOutlet UILabel *price7;
@property (weak, nonatomic) IBOutlet UILabel *price8;
@property (weak, nonatomic) IBOutlet UILabel *price9;
@property (weak, nonatomic) IBOutlet UILabel *price10;

@property (weak, nonatomic) IBOutlet UILabel *chgp1;
@property (weak, nonatomic) IBOutlet UILabel *chgp2;
@property (weak, nonatomic) IBOutlet UILabel *chgp3;
@property (weak, nonatomic) IBOutlet UILabel *chgp4;
@property (weak, nonatomic) IBOutlet UILabel *chgp5;
@property (weak, nonatomic) IBOutlet UILabel *chgp6;
@property (weak, nonatomic) IBOutlet UILabel *chgp7;
@property (weak, nonatomic) IBOutlet UILabel *chgp8;
@property (weak, nonatomic) IBOutlet UILabel *chgp9;
@property (weak, nonatomic) IBOutlet UILabel *chgp10;

@property (weak, nonatomic) IBOutlet UILabel *chg1;
@property (weak, nonatomic) IBOutlet UILabel *chg2;
@property (weak, nonatomic) IBOutlet UILabel *chg3;
@property (weak, nonatomic) IBOutlet UILabel *chg4;
@property (weak, nonatomic) IBOutlet UILabel *chg5;
@property (weak, nonatomic) IBOutlet UILabel *chg6;
@property (weak, nonatomic) IBOutlet UILabel *chg7;
@property (weak, nonatomic) IBOutlet UILabel *chg8;
@property (weak, nonatomic) IBOutlet UILabel *chg9;
@property (weak, nonatomic) IBOutlet UILabel *chg10;

@end



@interface RegionalSummaryPacket : NSObject

@property (retain, nonatomic) NSString *code;
@property (assign, nonatomic) NSInteger price;
@property (assign, nonatomic) NSInteger chg;
@property (assign, nonatomic) NSInteger chgp;
@property (assign, nonatomic) SubChannel channel;

@property (weak, nonatomic) UIDropList *droplist;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *chgLabel;
@property (weak, nonatomic) UILabel *chgpLabel;

- (id)initWithPacket:(NSString*)name price:(NSInteger)price chg:(NSInteger)chg chgp:(NSInteger)chgp channel:(SubChannel)channel;
- (void)initLabel:(UILabel*)nameLabel price:(UILabel*)priceLabel chg:(UILabel*)chgLabel chgp:(UILabel*)chgpLabel img:(UIImageView*)imageView droplist:(UIDropList*)droplist;

@end