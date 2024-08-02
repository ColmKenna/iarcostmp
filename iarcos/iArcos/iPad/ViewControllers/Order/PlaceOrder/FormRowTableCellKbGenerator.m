//
//  FormRowTableCellKbGenerator.m
//  iArcos
//
//  Created by Richard on 21/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "FormRowTableCellKbGenerator.h"

@implementation FormRowTableCellKbGenerator

- (OrderProductTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdStandardOrderPadKbTableViewCell";
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
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 1) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

@end
