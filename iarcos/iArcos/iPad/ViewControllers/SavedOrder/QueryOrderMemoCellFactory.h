//
//  QueryOrderMemoCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderMemoCellFactory : NSObject

+(id)factory;
-(QueryOrderTMBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data;
-(QueryOrderTMBaseTableCell*)createMemoIURTableCell;
-(QueryOrderTMBaseTableCell*)createMemoStringTableCell;
-(QueryOrderTMBaseTableCell*)createMemoBooleanTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;

@end
