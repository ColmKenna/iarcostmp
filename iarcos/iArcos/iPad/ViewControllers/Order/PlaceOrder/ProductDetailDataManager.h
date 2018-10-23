//
//  ProductDetailDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosCoreData.h"

@interface ProductDetailDataManager : NSObject {
    NSMutableArray* _displayList;
    NSMutableArray* _levelDisplayList;
    NSMutableArray* _stockDisplayList;
    NSMutableArray* _priceDisplayList;
    NSMutableArray* _codeDisplayList;
    NSString* _productCode;
    NSNumber* _productIUR;
    NSString* _productDescription;
    NSString* _bonusTitle;
    NSString* _miscTitle;
    NSString* _detailsTitle;
    NSNumber* _productImageIUR;
    BOOL _useLocalImageFlag;
    NSMutableDictionary* _formRowDict;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSMutableArray* levelDisplayList;
@property(nonatomic, retain) NSMutableArray* stockDisplayList;
@property(nonatomic, retain) NSMutableArray* priceDisplayList; 
@property(nonatomic, retain) NSMutableArray* codeDisplayList; 
@property(nonatomic, retain) NSString* productCode;
@property(nonatomic, retain) NSNumber* productIUR;
@property(nonatomic, retain) NSString* productDescription;
@property(nonatomic, retain) NSString* bonusTitle;
@property(nonatomic, retain) NSString* miscTitle;
@property(nonatomic, retain) NSString* detailsTitle;
@property(nonatomic, retain) NSNumber* productImageIUR;
@property(nonatomic, assign) BOOL useLocalImageFlag;
@property(nonatomic, retain) NSMutableDictionary* formRowDict;

- (void)processRawData:(ArcosGenericClass*)arcosGenericClass;
- (NSMutableDictionary*)cellDataDict:(NSString*)aTitle value:(NSString*)aValue;
- (void)processProductLocationRawData:(NSMutableArray*)aDataList;

@end
