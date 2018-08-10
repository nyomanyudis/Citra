//
//  AddForeignDomestic.m
//  Ciptadana
//
//  Created by Reyhan on 10/23/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "AddForeignDomestic.h"

#import "AddWatchlistCell.h"

#import "StockSuggestionField.h"
#import "JsonProperties.h"
#import "PDKeychainBindings.h"

@interface AddForeignDomestic() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet StockSuggestionField *suggestionField;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (retain, nonatomic) NSMutableArray *stocks;

@end

@implementation AddForeignDomestic

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [JsonProperties setForeignDomestic:self.stocks];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    // Do any additional setup after loading the view.
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.stocks = [NSMutableArray arrayWithArray:[JsonProperties getForeignDomestic]];
    
    [self stockFieldCallback];
}

#pragma  mark - private

- (void)stockFieldCallback
{
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        stock = [stock uppercaseString];
        if(![self stockFounded:stock]) {
            [self.stocks addObject:stock];
            [self.table reloadData];
            
            [self performSegueWithIdentifier:@"unwindToFDNetBS" sender:self];
        }
    };
    
    self.suggestionField.callback = stockCallback;
}

- (BOOL)stockFounded:(NSString *)stock
{
    if(self.stocks) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",stock]; // if you need case sensitive search avoid '[c]' in the predicate
        
        NSArray *results = [self.stocks filteredArrayUsingPredicate:predicate];
        
        if(results.count > 0)
            return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.stocks)
        return  self.stocks.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWatchlistCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
    
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddWatchlistCell" owner:self options:nil] objectAtIndex:0];
    
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:[self.stocks objectAtIndex:indexPath.row]];
    if(data) {
        cell.stock.text = data.code;
        cell.name.text = data.name;
        
        cell.stock.textColor = UIColorFromRGB(stringToHexa(data.color));
        cell.name.textColor = UIColorFromRGB(stringToHexa(data.color));
    }
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your editAction here
//        NSLog(@"Clona");
//    }];
//    editAction.backgroundColor = [UIColor clearColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        StockSummary *tmp = [self.stocks objectAtIndex:indexPath.row];
        [self.stocks removeObject:tmp];
        [self.table reloadData];
    }];
    deleteAction.backgroundColor = [UIColor clearColor];
    //return @[deleteAction,editAction];
    return @[deleteAction];
}

@end
