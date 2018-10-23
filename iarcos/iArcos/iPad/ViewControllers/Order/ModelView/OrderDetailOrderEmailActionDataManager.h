//
//  OrderDetailOrderEmailActionDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 29/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetailEmailActionDelegate.h"
#import "OrderEmailProcessCenter.h"
#import "CheckoutPDFRenderer.h"

@interface OrderDetailOrderEmailActionDataManager : NSObject<OrderDetailEmailActionDelegate> {
    NSMutableDictionary* _orderHeader;
    OrderEmailProcessCenter* _orderEmailProcessCenter;
    BOOL _showSignatureFlag;
    UIImage* _signatureImage;
    CheckoutPDFRenderer* _checkoutPDFRenderer;
    NSString* _fileName;
    UIImage* _logoImage;
    UIFont* _orderLineFont;
    UIFont* _headerFont;
}

@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) OrderEmailProcessCenter* orderEmailProcessCenter;
@property(nonatomic, assign) BOOL showSignatureFlag;
@property(nonatomic, retain) UIImage* signatureImage;
@property(nonatomic, retain) CheckoutPDFRenderer* checkoutPDFRenderer;
@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, retain) UIImage* logoImage;
@property(nonatomic, retain) UIFont* orderLineFont;
@property(nonatomic, retain) UIFont* headerFont;

- (id)initWithOrderHeader:(NSMutableDictionary*)anOrderHeader;
- (NSArray*)retrieveCcRecipients;

@end
