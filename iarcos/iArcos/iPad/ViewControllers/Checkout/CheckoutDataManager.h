//
//  CheckoutDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"

@interface CheckoutDataManager : NSObject {
    NSIndexPath* _currentIndexPath;
    NSMutableArray* _topxList;
    BOOL _isNotFirstTimeCustomerMsg;
    int _topxNumber;
    int _flaggedProductsNumber;
    BOOL _isNotFirstTimeCompanyMsg;
}

@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) NSMutableArray* topxList;
@property(nonatomic, assign) BOOL isNotFirstTimeCustomerMsg;
@property(nonatomic, assign) int topxNumber;
@property(nonatomic, assign) int flaggedProductsNumber;
@property(nonatomic, assign) BOOL isNotFirstTimeCompanyMsg;

- (NSNumber*)getCurrentLocationIUR;
- (NSMutableArray*)getAccountNoList:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR;
- (NSMutableDictionary*)getAcctNoMiscDataDict:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR;
- (NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword;
- (void)retrieveTopxListWithLocationIUR:(NSNumber*)aLocationIUR;
- (NSMutableArray*)processLocationProductMATDataWithLocationIUR:(NSNumber*)aLocationIUR topx:(int)aTopxNum;
- (void)removeTopxElementWithDataDict:(NSMutableDictionary*)aDataDict;
- (void)retrieveTopCompanyProducts;
- (BOOL)checkScannedProductInTopxList:(NSMutableDictionary*)aProductDict;

@end
