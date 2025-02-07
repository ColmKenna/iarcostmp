//
//  CustomerContactDetailCallDataManager.h
//  iArcos
//
//  Created by Richard on 03/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerListingCallDataManager.h"

@interface CustomerContactDetailCallDataManager : CustomerListingCallDataManager

- (void)callHeaderProcessorWithContactIURList:(NSMutableArray*)aContactIURList;

@end


