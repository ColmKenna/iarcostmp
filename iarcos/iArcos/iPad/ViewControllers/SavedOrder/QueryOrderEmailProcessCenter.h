//
//  QueryOrderEmailProcessCenter.h
//  Arcos
//
//  Created by David Kilmartin on 03/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"

@interface QueryOrderEmailProcessCenter : NSObject

-(NSString*)buildEmailMessageWithTaskObject:(ArcosGenericClass*)cellData memoDataList:(NSMutableArray*)memoList;

@end
