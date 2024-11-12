//
//  CustomerCalendarListTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 07/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerCalendarListTableCellGenerator.h"

@implementation CustomerCalendarListTableCellGenerator

- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString *CellIdentifier = @"IdCustomerCalendarListTableViewCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerCalendarListTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;
            }
        }
    }
    return cell;
}

@end
