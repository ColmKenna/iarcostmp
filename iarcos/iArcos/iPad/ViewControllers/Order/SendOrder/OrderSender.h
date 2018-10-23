//
//  OrderSender.h
//  Arcos
//
//  Created by David Kilmartin on 01/09/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrderSenderDelegate 
-(void)sendingStatus:(BOOL)isSuccess withReason:(NSString*)reason forOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber*)newOrderNumber;
-(void)Error1003:(NSError*)error forOrderNumber:(NSNumber*)orderNumber;
-(void)ServerFaultWithOrderNumber:(NSNumber*)orderNumber;
@end

@interface OrderSender : NSObject {
    id<OrderSenderDelegate>delegate;
    NSNumber* theOrderNumber;
}
@property(nonatomic,assign)    id<OrderSenderDelegate>delegate;
@property(nonatomic,retain) NSNumber* theOrderNumber;

+(id)sender;
-(void)sendWithOrderNumber:(NSNumber*)orderNumber;
-(void)send;
@end
