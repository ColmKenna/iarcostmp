//
//  ArcosOrderRestoreUtils.h
//  iArcos
//
//  Created by David Kilmartin on 24/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCommon.h"

@interface ArcosOrderRestoreUtils : NSObject {
    NSMutableDictionary* _orderRestoreDict;
}

@property(nonatomic, retain) NSMutableDictionary* orderRestoreDict;

- (void)loadOrderlineWithDict:(NSMutableDictionary*)anOrderline;
- (void)loadExistingOrderline;
- (BOOL)orderRestorePlistExistent;
- (CompositeErrorResult*)removeOrderRestorePlist;

@end
