//
//  FormRowTableCellPrevNormalGenerator.m
//  iArcos
//
//  Created by Richard on 24/07/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FormRowTableCellPrevNormalGenerator.h"

@implementation FormRowTableCellPrevNormalGenerator

- (OrderProductTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    NSString* CellIdentifier = @"IdPrevNormalStandardOrderPadTableViewCell";
    OrderProductTableCell* cell = (OrderProductTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"StandardOrderPadTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[OrderProductTableCell class]] && [[(OrderProductTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (OrderProductTableCell *) nibItem;
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
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 6) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

@end
