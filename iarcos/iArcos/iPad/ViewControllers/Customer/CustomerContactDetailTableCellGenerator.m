//
//  CustomerContactDetailTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 03/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailTableCellGenerator.h"

@implementation CustomerContactDetailTableCellGenerator

- (CustomerContactDetailTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerContactDetailTableCell";
    CustomerContactDetailTableCell* cell = (CustomerContactDetailTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerContactDetailTableCell class]] && [[(CustomerContactDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerContactDetailTableCell*) nibItem;
                break;
            }
        }
    }
    return cell;
}

@end
