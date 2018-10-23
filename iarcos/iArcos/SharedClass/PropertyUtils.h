//
//  PropertyUtils.h
//  Arcos
//
//  Created by David Kilmartin on 12/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "ArcosUtils.h"

@interface PropertyUtils : NSObject

+ (NSDictionary *)classPropsFor:(Class)klass;

+ (void)updateRecord:(id)tableNameObj fieldName:(NSString*)aFieldName fieldValue:(NSString*)aFieldValue propDict:(NSDictionary*)aPropsDict;


@end
