//
//  WatchlistCell.h
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchlistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stock;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UILabel *changepct;
@property (weak, nonatomic) IBOutlet UIImageView *changepctImage;

@end
