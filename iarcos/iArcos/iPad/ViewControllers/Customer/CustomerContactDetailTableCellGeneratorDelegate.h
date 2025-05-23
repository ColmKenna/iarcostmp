//
//  CustomerContactDetailTableCellGeneratorDelegate.h
//  iArcos
//
//  Created by Richard on 03/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerContactDetailTableCell.h"


@protocol CustomerContactDetailTableCellGeneratorDelegate <NSObject>

- (CustomerContactDetailTableCell*)generateTableCellWithTableView:(UITableView*)aTableView;

@end

