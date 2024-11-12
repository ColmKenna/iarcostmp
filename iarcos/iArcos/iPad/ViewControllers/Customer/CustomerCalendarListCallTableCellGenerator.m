//
//  CustomerCalendarListCallTableCellGenerator.m
//  iArcos
//
//  Created by Richard on 07/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerCalendarListCallTableCellGenerator.h"

@implementation CustomerCalendarListCallTableCellGenerator

- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView {
    static NSString* CellIdentifier = @"IdCustomerCalendarListCallTableViewCell";
    
    CustomerListingTableCell* cell = (CustomerListingTableCell*) [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerCalendarListCallTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerListingTableCell class]] && [[(CustomerListingTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerListingTableCell *) nibItem;
            }
        }
    }
    return cell;
}

@end
