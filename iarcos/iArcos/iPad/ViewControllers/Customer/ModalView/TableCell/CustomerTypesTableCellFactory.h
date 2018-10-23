//
//  CustomerTypesTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 10/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerBaseTableCell.h"


@interface CustomerTypesTableCellFactory : NSObject


+(id)factory;
-(CustomerBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data;
-(CustomerBaseTableCell*)createCustomerIURTableCell;
-(CustomerBaseTableCell*)createCustomerStringTableCell;
-(CustomerBaseTableCell*)createSwitchBooleanTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;

@end
