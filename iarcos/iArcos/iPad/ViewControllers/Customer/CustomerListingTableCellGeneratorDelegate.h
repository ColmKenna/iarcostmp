//
//  CustomerListingTableCellGeneratorDelegate.h
//  iArcos
//
//  Created by Richard on 30/10/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerListingTableCell.h"

@protocol CustomerListingTableCellGeneratorDelegate <NSObject>


- (CustomerListingTableCell*)generateTableCellWithTableView:(UITableView*)aTableView;

@end


