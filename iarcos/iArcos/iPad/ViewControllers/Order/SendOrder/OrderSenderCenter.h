//
//  OrderSenderCenter.h
//  Arcos
//
//  Created by David Kilmartin on 12/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderSender.h"
#import "LocalNewItemsUpdateCenter.h"

@protocol OrderSenderCenterDelegate 
-(void)sendingStatus:(BOOL)isSuccess withReason:(NSString*)reason forOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber*)newOrderNumber;
-(void)Error1003:(NSError*)error forOrderNumber:(NSNumber*)orderNumber;
-(void)ServerFaultWithOrderNumber:(NSNumber*)orderNumber;
-(void)timeOutForOrderNumber:(NSNumber*)orderNumber;
-(void)allOrdersDone:(NSNumber*)totalOrderSent;
-(void)orderSenderStartLocalNewItemsSending:(NSString *)anItemName;
-(void)orderSenderErrorOccurredLocalNewItemsSending:(NSString *)anErrorMsg;
@end

@interface OrderSenderCenter : NSObject <OrderSenderDelegate, LocalNewItemsUpdateCenterDelegate> {
    NSMutableArray* ordersQueue;
    NSNumber* currentOrderNumber;
    
    BOOL isCenterBusy;
    int succesOrder;
    
    //delegate
    id<OrderSenderCenterDelegate>delegate;
    LocalNewItemsUpdateCenter* _localNewItemsUpdateCenter;
}
@property(nonatomic,assign)    id<OrderSenderCenterDelegate>delegate;
@property(nonatomic,retain) NSMutableArray* ordersQueue;
@property(nonatomic,retain) NSNumber* currentOrderNumber;
@property(nonatomic,retain) LocalNewItemsUpdateCenter* localNewItemsUpdateCenter;

+(id)center;

-(void)addSender:(OrderSender*)sender;
-(void)addSenderWithOrderNumber:(NSNumber*)orderNumber;
-(void)removeSenderWithOrderNumber:(NSNumber*)orderNumber;
-(void)startSend;
-(void)stopSend;
-(void)abandonAll;
-(BOOL)isOrderInTheQueue:(NSNumber*)orderNumber;
@end
