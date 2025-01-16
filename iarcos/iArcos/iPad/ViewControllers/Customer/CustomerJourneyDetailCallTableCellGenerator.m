//
//  CustomerJourneyDetailCallTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 28/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailCallTableCellGenerator.h"

@implementation CustomerJourneyDetailCallTableCellGenerator

- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerJourneyDetailCallTableViewCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerJourneyDetailCallTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;
            }
        }
    }
    return cell;
}

@end
