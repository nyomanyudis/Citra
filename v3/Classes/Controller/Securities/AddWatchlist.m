//
//  AddWatchlist.m
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "AddWatchlist.h"

#import "AddWatchlistCell.h"
#import "UIButton+Addons.h"

#import "StockSuggestionField.h"
#import "JsonProperties.h"
#import "PDKeychainBindings.h"

@interface AddWatchlist () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet StockSuggestionField *stockField;
@property (weak, nonatomic) IBOutlet UITableView *watchlistTable;
@property (retain, nonatomic) NSMutableArray *watchlist;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation AddWatchlist

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [JsonProperties setWatchlist:self.watchlist];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    [bindings setObject:[NSString stringWithFormat:@"%@Identity",self.restorationIdentifier] forKey:@"storyBoardIdentify"];
    // Do any additional setup after loading the view.
    
    self.watchlistTable.delegate = self;
    self.watchlistTable.dataSource = self;
    self.watchlist = [NSMutableArray arrayWithArray:[JsonProperties getWatchlistStock]];
    
    [self stockFieldCallback];
    
    [self.stockField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma  mark - private

- (void)stockFieldCallback
{
    UIImage *imageLeft = [UIImage imageNamed:@"left"];
    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
    [btn setImage:imageLeft forState:UIControlStateNormal];
    [btn clearBackground];
    
    [self.backButton setCustomView:btn];
    
    [btn addTarget:self action:@selector(backSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    StockSuggestionCallback stockCallback = ^void(NSString* stock) {
        stock = [stock uppercaseString];
        if(![self stockFounded:stock]) {
            [self.watchlist addObject:stock];
            [self.watchlistTable reloadData];
            
            [self performSegueWithIdentifier:@"unwindToWatchlist" sender:self];

        }
    };
    
    self.stockField.callback = stockCallback;
}

- (IBAction)backSelector:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    // swipe menu
//    if(self.revealViewController) {
//        [self.revealViewController popoverPresentationController];
//    }
    
    [self performSegueWithIdentifier:@"unwindToWatchlist" sender:self];
}

- (BOOL)stockFounded:(NSString *)stock
{
    if(self.watchlist) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",stock]; // if you need case sensitive search avoid '[c]' in the predicate
        
        NSArray *results = [self.watchlist filteredArrayUsingPredicate:predicate];
        
        if(results.count > 0)
            return YES;
    }
    return NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.watchlist)
        return  self.watchlist.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddWatchlistCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
    
    if(!cell)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddWatchlistCell" owner:self options:nil] objectAtIndex:0];
    
    KiStockData *data = [[MarketData sharedInstance] getStockDataByStock:[self.watchlist objectAtIndex:indexPath.row]];
    if(data) {
        cell.stock.text = data.code;
        cell.name.text = data.name;
        
        cell.stock.textColor = UIColorFromRGB(stringToHexa(data.color));
        cell.name.textColor = UIColorFromRGB(stringToHexa(data.color));
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //if (editingStyle == UITableViewCellEditingStyleDelete) {
//    
//    NSLog(@"adfafd");
//    //        static NSString *cellIdentifier = @"Cell";
//    //
//    //        AddWatchlistCell *cell = (AddWatchlistCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    //
//    ////        AddWatchlistCell *cell;// = (WatchlistCell *)[tableView dequeueReusableCellWithIdentifier:IDENTIFIER forIndexPath:indexPath];
//    //
//    //        if(!cell)
//    //            cell = [[[NSBundle mainBundle] loadNibNamed:@"AddWatchlistCell" owner:self options:nil] objectAtIndex:0];
//    //}
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Clona" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//        //insert your editAction here
//        NSLog(@"Clona");
//    }];
//    editAction.backgroundColor = [UIColor clearColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        StockSummary *tmp = [self.watchlist objectAtIndex:indexPath.row];
        [self.watchlist removeObject:tmp];
        [self.watchlistTable reloadData];
    }];
    deleteAction.backgroundColor = [UIColor clearColor];
    //return @[deleteAction,editAction];
    return @[deleteAction];
}

@end
