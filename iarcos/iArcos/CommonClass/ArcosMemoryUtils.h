//
//  ArcosMemoryUtils.h
//  Arcos
//
//  Created by David Kilmartin on 14/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "HumanReadableDataSizeHelper.h"

@interface ArcosMemoryUtils : NSObject

- (void)print_free_memory;
- (NSMutableDictionary*)retrieveSystemMemory;

@end
