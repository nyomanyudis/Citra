//
//  TableAlert.m
//  Ciptadana
//
//  Created by Reyhan on 12/15/17.
//  Copyright © 2017 Reyhan. All rights reserved.
//

#import "TableAlert.h"

#import "Util.h"

@implementation TableAlert

+ (MLTableAlert *)alertConfirmationOKOnly:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok
{
    return [TableAlert alertConfirmation:cells titleAlert:title okTitle:@"OK" cancelTitle:nil okOnClick:ok cancelOnClick:nil cellsColor:nil];
}

+ (MLTableAlert *)alertConfirmationOKOnlyWithColor:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok cellsColor:(NSArray *) cellsColor
{
    return [TableAlert alertConfirmation:cells titleAlert:title okTitle:@"OK" cancelTitle:nil okOnClick:ok cancelOnClick:nil cellsColor:cellsColor];
}

+ (MLTableAlert *)alertConfirmationOKCancel:(NSArray *)cells titleAlert:(NSString *)title okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel
{
    return [TableAlert alertConfirmation:cells titleAlert:title okTitle:@"OK" cancelTitle:@"CANCEL" okOnClick:ok cancelOnClick:cancel cellsColor:nil];
}

+ (MLTableAlert *)alertConfirmation:(NSArray *)cells titleAlert:(NSString *)title okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel cellsColor:(NSArray *) cellsColor
{
    
    return [TableAlert alertConfirmation:cells titleAlert:title okTitle:okTitle cancelTitle:cancelTitle otherTitle:nil okOnClick:ok cancelOnClick:cancel otherOnClick:nil cellsColor:cellsColor];
}

+ (MLTableAlert *)alertConfirmation:(NSArray *)cells titleAlert:(NSString *)title okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle okOnClick:(MLTableAlertOkButtonOnClick)ok cancelOnClick:(MLTableAlertOkButtonOnClick)cancel otherOnClick:(MLTableAlertOkButtonOnClick)other cellsColor:(NSArray *) cellsColor
{
    UITableViewCell* (^cell)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingCell" owner:self options:nil] objectAtIndex:2];
        
        NSString *label = [cells objectAtIndex:(2 * indexPath.row)];
        NSString *value = [cells objectAtIndex:(2 * indexPath.row + 1)];
        
        UILabel *label1 = [cell.contentView.subviews objectAtIndex:0];
        UILabel *label2 = [cell.contentView.subviews objectAtIndex:1];
        
        //hanya berlaku untuk menu NetByStock
        NSLog(@"Total color = %d",[cellsColor count]);
        if([cellsColor count]>0){
            if(indexPath.row == 0 || indexPath.row == 1){
                label2.textColor = [cellsColor objectAtIndex:0];
            }
            else if(indexPath.row == 4 || indexPath.row == 5){
                label2.textColor = [cellsColor objectAtIndex:1];
            }
        }
        
        label1.text = label;
        label2.text = value;
//        label1.textColor = [UIColor redColor];
        
        return  cell;
    };
    
    CGFloat (^cellHeight)(MLTableAlert *anAlert, NSIndexPath *indexPath) = ^CGFloat (MLTableAlert *anAlert, NSIndexPath *indexPath) {
        UITableViewCell *rowcell = cell(anAlert, indexPath);
        if([((UILabel*)[rowcell.contentView.subviews objectAtIndex:0]).text isEqualToString:@"Reason"])
            return UITableViewAutomaticDimension;
        return 23.f;
    };
    
    NSInteger (^row)(NSInteger section) = ^ NSInteger(NSInteger section) {
        if(cells)
            return cells.count / 2;
        return 0;
    };
    
    // create the alert
    MLTableAlert *alert;
    
    if(cancelTitle)
        alert = [MLTableAlert tableAlertWithTitle:title
                                cancelButtonTitle:okTitle
                                    okButtonTitle:cancelTitle
                                 otherButtonTitle:otherTitle
                                     numberOfRows:row
                                         andCells:cell
                                   andCellsHeight:cellHeight];
    else
        alert = [MLTableAlert tableAlertWithTitle:title
                                cancelButtonTitle:okTitle
                                     numberOfRows:row
                                         andCells:cell
                                   andCellsHeight:cellHeight];
    
    alert.okButtonOnClick = cancel;
    alert.cancelButtonOnClick = ok;
    alert.otherButtonOnClick = other;
    
    alert.table.allowsSelection = NO;
    alert.table.allowsSelectionDuringEditing = NO;
    alert.table.allowsMultipleSelection = NO;
    
    return alert;
}

@end
