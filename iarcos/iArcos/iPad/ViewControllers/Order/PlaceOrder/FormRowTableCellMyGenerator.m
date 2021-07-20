//
//  FormRowTableCellMyGenerator.m
//  iArcos
//
//  Created by Richard on 20/07/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "FormRowTableCellMyGenerator.h"

@implementation FormRowTableCellMyGenerator

- (OrderProductTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    NSString* CellIdentifier = @"IdMyStandardOrderPadTableViewCell";
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
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 3) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

@end
