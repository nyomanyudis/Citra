//
//  KiWatchlistTable.h
//  Ciptadana
//
//  Created by Reyhan on 10/16/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KiWatchlistTable : NSObject

- (id)initWithTableView:(UITableView *)tableView;
- (void)newSummary:(NSMutableArray *)summaries;
- (void)updateSummary:(NSArray *)summaries;

@end
