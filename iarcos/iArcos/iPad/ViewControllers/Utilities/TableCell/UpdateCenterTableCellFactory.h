//
//  UpdateCenterTableCellFactory.h
//  Arcos
//
//  Created by David Kilmartin on 04/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilitiesUpdateCenterDataTableCell.h"

@interface UpdateCenterTableCellFactory : NSObject

+(id)factory;
-(UtilitiesUpdateCenterDataTableCell*)createUpdateCenterCellWithData:(NSMutableDictionary*)aCellData;
-(UtilitiesUpdateCenterDataTableCell*)createUpdateCenterDataTableCell;
@end
