//
//  MATFormRowsTableCellNormalGenerator.m
//  iArcos
//
//  Created by David Kilmartin on 05/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MATFormRowsTableCellNormalGenerator.h"

@implementation MATFormRowsTableCellNormalGenerator

- (MATFormRowsTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    NSString* CellIdentifier = @"IdLabelMATFormRowsTableCell";
    
    MATFormRowsTableCell* cell = (MATFormRowsTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MATFormRowsTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MATFormRowsTableCell class]] && [[(MATFormRowsTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (MATFormRowsTableCell *) nibItem;
                break;
            }
        }
    }
    return cell;
}

- (UIView*)generateTableHeaderView {
    UIView* resultView = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MATFormRowsTableCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 51) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

@end
