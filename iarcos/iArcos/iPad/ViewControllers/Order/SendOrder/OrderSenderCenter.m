//
//  OrderSenderCenter.m
//  Arcos
//
//  Created by David Kilmartin on 12/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderSenderCenter.h"
#import "GlobalSharedClass.h"

@interface OrderSenderCenter (Private) 
-(void)popAndSendAnOrder;
@end

@implementation OrderSenderCenter
@synthesize delegate;
@synthesize ordersQueue;
@synthesize currentOrderNumber;
@synthesize localNewItemsUpdateCenter = _localNewItemsUpdateCenter;
-(id)init{
    self=[super init];
    if (self!=nil) {
        
        self.ordersQueue=[NSMutableArray array];
        isCenterBusy=NO;
        succesOrder=0;
    }
    return self;
}
+(id)center{
    return [[[OrderSenderCenter alloc]init]autorelease];
}
-(void)dealloc{
    for (int i = 0; i < [self.ordersQueue count]; i++) {
        OrderSender* tmpSender = [self.ordersQueue objectAtIndex:i];
        tmpSender.delegate = nil;
    }
    self.ordersQueue=nil;
    self.currentOrderNumber=nil;
    self.localNewItemsUpdateCenter = nil;
    
    [super dealloc];
}
-(void)addSender:(OrderSender*)sender{
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        
        if([self isOrderInTheQueue:sender.theOrderNumber])
            return;
    
        sender.delegate=self;
        [self.ordersQueue addObject:sender];
    }

}
-(void)addSenderWithOrderNumber:(NSNumber*)orderNumber{
    @synchronized(self.ordersQueue)
    {
        
        if([self isOrderInTheQueue:orderNumber])
            return;
        
        OrderSender* sender=[OrderSender sender];
        sender.delegate=self;
        sender.theOrderNumber=orderNumber;
        [self.ordersQueue addObject:sender];
        
    }
}
-(void)removeSenderWithOrderNumber:(NSNumber*)orderNumber{
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        
        OrderSender *toBeRemoved=nil;
        for (OrderSender* sender in self.ordersQueue) {
            if ([sender.theOrderNumber isEqualToNumber:orderNumber]) {
                toBeRemoved=sender;
                break;
            }
        }
        if (toBeRemoved!=nil) {
            [self.ordersQueue removeObject:toBeRemoved];
        }
    }
}
-(BOOL)isOrderInTheQueue:(NSNumber*)orderNumber{
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        if (orderNumber==nil) {
            return NO;
        }
        
        if ([self.ordersQueue count]<=0) {
            return NO;
        }
        
        for (OrderSender* sender in self.ordersQueue) {
            if ([sender.theOrderNumber isEqualToNumber:orderNumber]) {
                return YES;
            }
        }
    }
    return NO;
}
-(void)startSend{
    //set the service time out interval
    [GlobalSharedClass shared].serviceTimeoutInterval=60.0;
    
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        
        if (isCenterBusy) {
            return;
        }
//        if ([self.ordersQueue count]<=0) {
//            return;
//        }
        isCenterBusy=YES;
        [self popAndSendAnOrder];
        
    }

}
-(void)popAndSendAnOrder{
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        
        if ([self.ordersQueue count]<=0) {
//            [self stopSend];
//            [self.delegate allOrdersDone:[NSNumber numberWithInt:succesOrder]];
//            succesOrder=0;
            
            //update local new item (e.g. new location lat lon,new response)
//            [LocalNewItemsUpdateCenter updateAll];
            self.localNewItemsUpdateCenter = [[[LocalNewItemsUpdateCenter alloc] init] autorelease];
            self.localNewItemsUpdateCenter.localItemsDelegate = self;
//            [self.localNewItemsUpdateCenter updateAll];
            [self.localNewItemsUpdateCenter buildProcessSelectorList];
            if ([self.localNewItemsUpdateCenter.selectorList count] == 0) {
                [self.localNewItemsUpdateCenter.localItemsDelegate didFinishLocalNewItemsSending];
            } else {                
                [self.localNewItemsUpdateCenter startPerformSelectorList];
            }
            return;
        }
        
        OrderSender* sender=[self.ordersQueue lastObject];
        self.currentOrderNumber=sender.theOrderNumber;
        [sender send];
        
    }
}
-(void)stopSend{
    isCenterBusy=NO;
}
-(void)abandonAll{
    //synchronizly access the queue
    @synchronized(self.ordersQueue)
    {
        isCenterBusy=NO;
        [self.ordersQueue removeAllObjects];
    }
}

#pragma mark order sender delegate
-(void)sendingStatus:(BOOL)isSuccess withReason:(NSString*)reason forOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber *)newOrderNumber{
    if (isSuccess) {
        succesOrder++;
    }
    
    [self removeSenderWithOrderNumber:orderNumber];
    [self.delegate sendingStatus:isSuccess withReason:reason forOrderNumber:orderNumber withNewOrderNumber:newOrderNumber];
    [self popAndSendAnOrder];
}
//handle the error 1003
-(void)Error1003:(NSError*)error forOrderNumber:(NSNumber *)orderNumber{
    [self removeSenderWithOrderNumber:self.currentOrderNumber];
    [self.delegate Error1003:error forOrderNumber:orderNumber];
    [self popAndSendAnOrder];
}
-(void)ServerFaultWithOrderNumber:(NSNumber*)orderNumber{
    [self abandonAll];
    [self.delegate ServerFaultWithOrderNumber:orderNumber];
}
#pragma mark LocalNewItemsUpdateCenterDelegate
- (void)didFinishLocalNewItemsSending {
    [self stopSend];
    [self.delegate allOrdersDone:[NSNumber numberWithInt:succesOrder]];
    succesOrder=0;
}
- (void)startLocalNewItemsSending:(NSString *)anItemName {
    [self.delegate orderSenderStartLocalNewItemsSending:anItemName];
}
- (void)errorOccurredLocalNewItemsSending:(NSString *)anErrorMsg {
    [self.delegate orderSenderErrorOccurredLocalNewItemsSending:anErrorMsg];
}

@end
