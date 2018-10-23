//
//  CustomerDetailsEditDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 03/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerDetailsActionBaseDataManager.h"
#import "ArcosCoreData.h"

@interface CustomerDetailsEditDataManager : CustomerDetailsActionBaseDataManager

- (NSMutableArray*)locLocLinkWithLocationIUR:(NSNumber*)aLocationIUR;

@end
