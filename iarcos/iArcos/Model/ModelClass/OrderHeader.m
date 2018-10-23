//
//  OrderHeader.m
//  Arcos
//
//  Created by David Kilmartin on 26/10/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "OrderHeader.h"
#import "Call.h"
#import "CallTran.h"
#import "Memo.h"
#import "OrderLine.h"


@implementation OrderHeader
@dynamic enteredIUR;
@dynamic wholesalerCode;
@dynamic CallDuration;
@dynamic DeliveryInstructions2;
@dynamic Points;
@dynamic FormIUR;
@dynamic rowguid;
@dynamic CallIUR;
@dynamic IUR;
@dynamic ContactIUR;
@dynamic PromotionIUR;
@dynamic Longitude;
@dynamic OSiur;
@dynamic Latitude;
@dynamic OrderNumber;
@dynamic EnteredDate;
@dynamic OrderDate;
@dynamic TotalVat;
@dynamic LocationIUR;
@dynamic ExchangeRate;
@dynamic InvoiseRef;
@dynamic DocketIUR;
@dynamic WholesaleIUR;
@dynamic TotalGoods;
@dynamic TotalNetRevenue;
@dynamic PointsIUR;
@dynamic DSiur;
@dynamic TotalQty;
@dynamic TotalBonusValue;
@dynamic TotalBonus;
@dynamic LocationCode;
@dynamic DeliveryInstructions1;
@dynamic EmployeeIUR;
@dynamic TotalFOC;
@dynamic MemoIUR;
@dynamic PosteedIUR;
@dynamic DeliveryDate;
@dynamic OTiur;
@dynamic CustomerRef;
@dynamic NumberOflines;
@dynamic TotalTesters;
@dynamic CallCost;
@dynamic OrderHeaderIUR;
@dynamic orderlines;
@dynamic call;
@dynamic memo;
@dynamic calltrans;

- (void)addOrderlinesObject:(OrderLine *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderlines"] addObject:value];
    [self didChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeOrderlinesObject:(OrderLine *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"orderlines"] removeObject:value];
    [self didChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addOrderlines:(NSSet *)value {    
    [self willChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"orderlines"] unionSet:value];
    [self didChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeOrderlines:(NSSet *)value {
    [self willChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"orderlines"] minusSet:value];
    [self didChangeValueForKey:@"orderlines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}




- (void)addCalltransObject:(CallTran *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"calltrans"] addObject:value];
    [self didChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeCalltransObject:(CallTran *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"calltrans"] removeObject:value];
    [self didChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addCalltrans:(NSSet *)value {    
    [self willChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"calltrans"] unionSet:value];
    [self didChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeCalltrans:(NSSet *)value {
    [self willChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"calltrans"] minusSet:value];
    [self didChangeValueForKey:@"calltrans" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
