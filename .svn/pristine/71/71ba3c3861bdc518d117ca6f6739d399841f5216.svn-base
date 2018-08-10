//
//  ChannelViewController.h
//  Ciptadana
//
//  Created by Reyhan on 9/19/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocol.pb.h"

@protocol ChannelViewControllerDelegate <NSObject>

@required
- (void)onChannelCurrency:(KiCurrency *)currency;
- (void)onChannelIndicesData:(KiIndicesData *)indices;
- (void)onChannelIndices:(KiIndices*)indices;
- (void)onChannelRegionalIndices:(KiRegionalIndices *)indices;
- (void)onChannelRegionalIndicesData:(KiRegionalIndicesData *)indices;
- (void)onChannelFuture:(KiFuture*)future;

- (void)onHttpChannelIndices:(NSArray *)fields;
- (void)onHttpChannelRegional:(NSArray *)fields;
- (void)onHttpChannelFuture:(NSArray *)fields;

@end

@interface ChannelViewController : UIViewController

@property (nonatomic, retain) id<ChannelViewControllerDelegate> delegate;

- (IBAction)cancelClicked:(id)sender;
- (void)subchannel:(NSInteger) channel;

@end

typedef enum {
    //ChannelCurrency = 0,
    ChannelIndices = 0,
    ChannelRegionalIndices,
    ChannelFuture,
    ChanelClear
} SubChannel;





@interface ChannelCurrencyViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *noLabel;
@property (nonatomic, retain) UILabel *codeLabel;
@property (nonatomic, retain) UILabel *nameLabel;

@end



@interface ChannelIndicesViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *noLabel;
@property (nonatomic, retain) UILabel *codeLabel;
//@property (nonatomic, retain) UILabel *nameLabel;

@end



@interface ChannelRegionalIndicesViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *noLabel;
@property (nonatomic, retain) UILabel *codeLabel;
@property (nonatomic, retain) UILabel *nameLabel;

@end