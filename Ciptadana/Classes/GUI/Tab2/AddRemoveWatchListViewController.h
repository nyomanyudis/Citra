//
//  AddRemoveWatchListViewController.h
//  Ciptadana
//
//  Created by Reyhan on 10/4/13.
//  Copyright (c) 2013 Reyhan. All rights reserved.
//

#import "AbstractViewController.h"
#import "Protocol.pb.h"



@protocol AddRemoveWatchListDelegate <NSObject>

@required
//- (void)appendStockCode:(NSString *)code;
//- (void)appendStock:(KiStockData *)kiStockData board:(Board)board;
//- (void)updateStock:(NSArray*)arrayStock;
//- (void)insertStock:(NSString *)code;
//- (void)deleteStock:(NSString *)code board:(Board)b;
- (void)updateStocks:(NSArray *)stocks;

@end


@interface AddRemoveWatchListViewController : AbstractViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *homeBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarItem;
@property (retain, nonatomic) IBOutlet UITextField *stockTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property (retain, nonatomic) AbstractViewController *watchListController;
@property (retain, nonatomic) id<AddRemoveWatchListDelegate> delegate;

- (void)watchListController:(AbstractViewController *)watchList;

@end




@interface AddRemoveStockCell : UITableViewCell

@property (retain, nonatomic) UILabel *codeLabel;
@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UIButton *checkButton;
@property (assign, nonatomic) Board board;

@property (retain, nonatomic) KiStockData *kiStockData;

@end