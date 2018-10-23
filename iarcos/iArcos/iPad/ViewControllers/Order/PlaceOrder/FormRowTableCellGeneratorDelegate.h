//
//  FormRowTableCellGeneratorDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 26/09/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderProductTableCell.h"

@protocol FormRowTableCellGeneratorDelegate <NSObject>

- (OrderProductTableCell*)generateTableCellWithTableView:(UITableView*)aTableView;
- (UIView*)generateTableHeaderView;

@end
