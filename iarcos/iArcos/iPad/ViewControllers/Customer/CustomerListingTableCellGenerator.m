//
//  CustomerListingTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 30/10/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerListingTableCellGenerator.h"

@implementation CustomerListingTableCellGenerator


- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerListingTableCell";
    CustomerListingTableCell* cell = (CustomerListingTableCell*)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerListingTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell*) nibItem;
                break;
            }
        }
    }
    return cell;
}

@end
