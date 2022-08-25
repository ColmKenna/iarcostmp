//
//  OrderLineDetailProductDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 25/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductFormRowConverter.h"

@interface OrderLineDetailProductDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _originalDisplayList;
    NSMutableDictionary* _orderLineOrderCart;
    NSMutableArray* _parentOrderLineList;
    NSNumber* _orderNumber;
    NSNumber* _formIUR;
    BOOL _standardOrderFormFlag;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* originalDisplayList;
@property(nonatomic, retain) NSMutableDictionary* orderLineOrderCart;
@property(nonatomic, retain) NSMutableArray* parentOrderLineList;
@property(nonatomic, retain) NSNumber* orderNumber;
@property(nonatomic, retain) NSNumber* formIUR;
@property(nonatomic, assign) BOOL standardOrderFormFlag;

- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword;
- (void)importExistentOrderLineToOrderCart:(NSMutableArray*)anOrderLineList;
- (NSMutableDictionary*)syncFormRowWithOrderCart:(NSMutableDictionary*)aFormRowDict;
- (void)saveOrderLineToOrderCart:(NSMutableDictionary*)anOrderLineDict;
- (BOOL)checkFormIURStandardFlag;
- (BOOL)showSeparatorWithFormIUR:(NSNumber*)aFormIUR;
- (void)retrieveStandardFormDataList:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;

@end
