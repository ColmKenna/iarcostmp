//
//  CustomerJourneyDetailTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 28/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailTableCellGenerator.h"

@implementation CustomerJourneyDetailTableCellGenerator

- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerJourneyDetailTableViewCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerJourneyDetailTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;
            }
        }
    }
    return cell;
}

@end
