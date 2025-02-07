//
//  CustomerContactDetailCallTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 03/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailCallTableCellGenerator.h"

@implementation CustomerContactDetailCallTableCellGenerator

- (CustomerContactDetailTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerContactDetailCallTableCell";
    CustomerContactDetailTableCell* cell = (CustomerContactDetailTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerContactDetailCallTableCell" owner:self options:nil];
        
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
