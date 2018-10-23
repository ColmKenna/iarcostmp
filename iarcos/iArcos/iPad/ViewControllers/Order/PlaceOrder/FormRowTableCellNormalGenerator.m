//
//  FormRowTableCellNormalGenerator.m
//  iArcos
//
//  Created by David Kilmartin on 26/09/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "FormRowTableCellNormalGenerator.h"

@implementation FormRowTableCellNormalGenerator

- (OrderProductTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    NSString* CellIdentifier = @"OrderProductTableCell";
    OrderProductTableCell* cell = (OrderProductTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[OrderProductTableCell class]] && [[(OrderProductTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (OrderProductTableCell *) nibItem;
                break;
            }
        }        
    }
    return cell;
}

- (UIView*)generateTableHeaderView {
    UIView* resultView = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"StandardOrderPadTableViewCell" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 1) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

@end
