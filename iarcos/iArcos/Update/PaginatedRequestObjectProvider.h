//
//  PaginatedRequestObjectProvider.h
//  Arcos
//
//  Created by David Kilmartin on 20/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "PaginatedRequestObject.h"
#import "UtilitiesUpdateDetailDataManager.h"
#import "ArcosConfigDataManager.h"

@interface PaginatedRequestObjectProvider : NSObject {
    PaginatedRequestObject* _productPaginatedRequestField;
    PaginatedRequestObject* _pricePaginatedRequestField;
    PaginatedRequestObject* _descrDetailsPaginatedRequestField;
    PaginatedRequestObject* _locationPaginatedRequestField;
    PaginatedRequestObject* _locLocLinkPaginatedRequestField;
    PaginatedRequestObject* _contactPaginatedRequestField;
    PaginatedRequestObject* _conLocLinkPaginatedRequestField;
    PaginatedRequestObject* _imagePaginatedRequestField;
    UtilitiesUpdateDetailDataManager* _utilitiesUpdateDetailDataManager;
    PaginatedRequestObject* _formRowPaginatedRequestField;
    PaginatedRequestObject* _locationProductMATPaginatedRequestField;
    PaginatedRequestObject* _packagePaginatedRequestField;
}

@property(nonatomic, retain) PaginatedRequestObject* productPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* pricePaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* descrDetailsPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* locationPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* locLocLinkPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* contactPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* conLocLinkPaginatedRequestField; 
@property(nonatomic, retain) PaginatedRequestObject* imagePaginatedRequestField;
@property(nonatomic, assign) UtilitiesUpdateDetailDataManager* utilitiesUpdateDetailDataManager;
@property(nonatomic, retain) PaginatedRequestObject* formRowPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* locationProductMATPaginatedRequestField;
@property(nonatomic, retain) PaginatedRequestObject* packagePaginatedRequestField;

- (PaginatedRequestObject*)descrDetailsRequestObject;
- (PaginatedRequestObject*)productRequestObject;
- (PaginatedRequestObject*)priceRequestObject;
- (PaginatedRequestObject*)locationRequestObject;
- (PaginatedRequestObject*)locLocLinkRequestObject;
- (PaginatedRequestObject*)contactRequestObject;
- (PaginatedRequestObject*)conLocLinkRequestObject;
- (PaginatedRequestObject*)imageRequestObject;
- (NSMutableDictionary*)getUpdateCenterDataDict:(NSString*)aSelectorName;
- (PaginatedRequestObject*)formRowRequestObject;
- (PaginatedRequestObject*)locationProductMATRequestObject;
- (PaginatedRequestObject*)packageRequestObject:(NSString*)aLocationIURList;

@end
