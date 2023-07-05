//
//  ProductFormRowConverter.h
//  Arcos
//
//  Created by David Kilmartin on 09/01/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface ProductFormRowConverter : NSObject {
    
}

+ (NSMutableDictionary*)createFormRowWithProduct:(NSMutableDictionary*)product orderFormDetails:(NSString*)anOrderFormDetails;
+ (NSMutableDictionary*)createOrderPadFormRowWrapper:(NSMutableDictionary*)aStdFormRowDict formRow:(NSDictionary*)aRawFormRowDict;
+ (NSMutableDictionary*)createFormRowWithOrderLine:(NSMutableDictionary*)anOrderLine;
+ (NSMutableDictionary*)createBlankFormRowWithProductIUR:(NSNumber*)aProductIUR;
+ (BOOL)showSeparatorWithFormIUR:(NSNumber*)aFormIUR;
+ (BOOL)isSelectedWithFormRowDict:(NSMutableDictionary*)aFormRowDict;
+ (NSMutableDictionary*)convertToOrderProductDict:(NSMutableDictionary*)aDict;
+ (BOOL)showSeparatorWithFormType:(NSString*)aFormType;
+ (NSNumber*)calculateLineValue:(NSMutableDictionary*)aProductDetailDict;
+ (NSMutableDictionary*)createStandardOrderLine:(NSMutableDictionary*)tempDict product:(NSDictionary*)aProductDict;
+ (NSMutableArray*)convertManagedCalltranSet:(NSSet*)calltranSet;
+ (void)addProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict productDict:(NSDictionary*)aProductDict;
+ (void)addBlankProductInfoToDictionary:(NSMutableDictionary*)aLocationProductMatDict;
+ (void)resetFormRowFigureWithFormRowDict:(NSMutableDictionary*)aFormRowDict;

@end
