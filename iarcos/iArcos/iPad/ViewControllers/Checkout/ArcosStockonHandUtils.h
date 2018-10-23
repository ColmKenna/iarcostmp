//
//  ArcosStockonHandUtils.h
//  iArcos
//
//  Created by David Kilmartin on 18/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcosStockonHandUtils : NSObject {
    
}


- (void)updateStockonHandWithOrderLines:(NSArray*)anOrderLineList actionType:(int)anActionType;
- (void)updateStockonHandWithOrderLine:(NSMutableDictionary*)anOrderLine priorOrderLineQty:(NSNumber*)aPriorOrderLineQty;

@end
