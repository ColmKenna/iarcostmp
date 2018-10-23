//
//  MATFormRowsTableCellGeneratorDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 05/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MATFormRowsTableCell.h"
#import "MATFormRowsTableHeaderView.h"

@protocol MATFormRowsTableCellGeneratorDelegate <NSObject>

- (MATFormRowsTableCell*)generateTableCellWithTableView:(UITableView*)aTableView;
- (UIView*)generateTableHeaderView;

@end
