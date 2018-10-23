//
//  GetRecordGenericTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 20/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetRecordGenericBaseTableViewCell.h"

@interface GetRecordGenericTableCellFactory : NSObject

+ (instancetype)factory;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (GetRecordGenericBaseTableViewCell*)createGetRecordGenericBaseTableViewCellWithData:(NSMutableDictionary*)aData;

@end
