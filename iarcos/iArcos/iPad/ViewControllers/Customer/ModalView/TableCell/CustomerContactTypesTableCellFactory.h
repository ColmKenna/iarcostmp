//
//  CustomerContactTypesTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerBaseTableCell.h"

@interface CustomerContactTypesTableCellFactory : NSObject {

}

+(id)factory;
-(CustomerBaseTableCell*)createCustomerContactBaseTableCellWithData:(NSMutableDictionary*)data;
-(CustomerBaseTableCell*)createCustomerContactIURTableCell;
-(CustomerBaseTableCell*)createCustomerContactStringTableCell;
-(CustomerBaseTableCell*)createCustomerContactBooleanTableCell;
-(NSString*)identifierWithData:(NSMutableDictionary*)data;
@end
