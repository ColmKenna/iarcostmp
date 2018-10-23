//
//  BranchLeafMiscUtils.h
//  Arcos
//
//  Created by David Kilmartin on 23/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface BranchLeafMiscUtils : NSObject

- (NSMutableDictionary*)getImageWithImageIUR:(NSNumber*)anImageIUR;
- (NSMutableArray*)getFormRowList:aBranchLxCodeContent branchLxCode:aBranchLxCode leafLxCodeContent:anLeafLxCodeContent leafLxCode:anLeafLxCode;

@end
