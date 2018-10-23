//
//  OrderDetailCallEmailActionDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailEmailActionDelegate.h"
#import "CallEmailProcessCenter.h"

@interface OrderDetailCallEmailActionDataManager : NSObject <OrderDetailEmailActionDelegate>{
    NSMutableDictionary* _orderHeader;
    CallEmailProcessCenter* _callEmailProcessCenter;
}

@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) CallEmailProcessCenter* callEmailProcessCenter;

- (id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader;

@end
