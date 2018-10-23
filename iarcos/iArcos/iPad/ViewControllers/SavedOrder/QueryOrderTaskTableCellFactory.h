//
//  QueryOrderTaskTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueryOrderTMBaseTableCell.h"

@interface QueryOrderTaskTableCellFactory : NSObject {
    
    
}

+(id)factory;
-(QueryOrderTMBaseTableCell*)createCustomerBaseTableCellWithData:(NSMutableDictionary*)data;
-(QueryOrderTMBaseTableCell*)createTaskIURTableCell;
-(QueryOrderTMBaseTableCell*)createTaskStringTableCell;
-(QueryOrderTMBaseTableCell*)createTaskBooleanTableCell;
-(QueryOrderTMBaseTableCell*)createTaskDateTableCell;
-(QueryOrderTMBaseTableCell*)createTaskByteTableCell;
-(QueryOrderTMBaseTableCell*)createTaskIntTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;

@end
