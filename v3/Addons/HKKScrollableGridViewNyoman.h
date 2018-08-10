//
//  HKKScrollableGridViewNyoman.h
//  Ciptadana
//
//  Created by Reyhan on 5/31/18.
//  Copyright © 2018 Reyhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKKScrollableGridTableCellViewNyoman : UIView
    @property (nonatomic, strong) UIView *fixedView;            ///< A base view for fixed area which is placed in front of the cell view.
    @property (nonatomic, strong) UIView *scrolledContentView;  ///< A base view for scrollable area followed by fixedView.

    @property (nonatomic, readonly) BOOL isScrollable;          ///< check if cell view is able to scroll it's scrolledContentView or not.

    - (void)didUpdateScrollOffset:(CGPoint)offset;        ///< overridable. when a scrollView's contentOffset is changed, the method is called. // ??

    @property (nonatomic, strong) NSString *kHKKScrollableOffsetChanged; // ??
    @property (nonatomic, strong) NSString *kNotifiticationUserInfoContentOffset; // ??

    // helper methods
    - (void)makeScrollableContentViewBeEmpty;       // make a scrollable view being empty.
    - (void)makeFixedViewBeEmpty;                   // make a fixed view being empty.
    
@end

@interface HKKScrollableGridViewNyoman : UIView
    @property (nonatomic, assign) BOOL verticalBounce;
    @property (nonatomic, strong) UITableView *mainTable;

@end
