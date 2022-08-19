//
//  ArcosCoreDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 20/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "ArcosGenericReturnObjectWithImage.h"
#import "ArcosUtils.h"
#import "DescrDetail.h"
#import "Location.h"
#import "Price.h"
#import "Contact.h"
#import "ConLocLink.h"
#import "Image.h"
#import "FormRow.h"
#import "Response.h"
#import "ArcosResponseBO.h"
#import "LocLocLink.h"
#import "ArcosValidator.h"
#import "LocationProductMAT.h"
#import "OrderLine.h"
#import "Promotion.h"
#import "ArcosOrderHeaderBO.h"
#import "OrderHeader.h"
#import "ArcosOrderLineBO.h"
#import "Package.h"

@interface ArcosCoreDataManager : NSObject

-(Product*)populateProductWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject product:(Product*)Product;
-(Product*)populateProductWithFieldList:(NSArray*)aFieldList product:(Product*)Product;
-(LocationProductMAT*)populateLocationProductMATWithFieldList:(NSArray*)aFieldList locationProductMAT:(LocationProductMAT*)anLocationProductMAT levelIUR:(NSNumber*)aLevelIUR;
-(DescrDetail*)populateDescrDetailWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject descrDetail:(DescrDetail*)DescrDetail;
-(DescrDetail*)populateDescrDetailWithFieldList:(NSArray*)aFieldList descrDetail:(DescrDetail*)DescrDetail;
-(Package*)populatePackageWithFieldList:(NSArray*)aFieldList package:(Package*)Package;
-(Location*)populateLocationWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject location:(Location*)Location;
-(Location*)populateLocationWithFieldList:(NSArray*)aFieldList location:(Location*)Location;
-(Price*)populatePriceWithFieldList:(NSArray*)aFieldList price:(Price*)Price;
-(Promotion*)populatePromotionWithFieldList:(NSArray*)aFieldList promotion:(Promotion*)aPromotion;
-(Contact*)populateContactWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject contact:(Contact*)Contact;
-(ConLocLink*)populateConLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject conLocLink:(ConLocLink*)ConLocLink;
-(Image*)populateImageWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject image:(Image*)Image;
-(FormRow*)populateFormRowWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject formRow:(FormRow*)FormRow;
-(void)populateResponseWithDataDict:(NSMutableDictionary*)aQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR response:(Response*)aResponse;
-(void)populateResponseWithSoapOB:(ArcosResponseBO*)anObject response:(Response*)aResponse;
-(void)populateLocLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject locLocLink:(LocLocLink*)aLocLocLink;
-(void)populateLocLocLinkWithFieldList:(NSArray*)aFieldList locLocLink:(LocLocLink*)anLocLocLink;
- (void)populateOrderWithSoapOB:(ArcosOrderHeaderBO*)anObject orderHeader:(OrderHeader*)OrderHeader;
- (NSMutableDictionary*)createOrderLineWithManagedOrderLine:(OrderLine*)anOrderLine;
- (NSMutableArray*)processPriceProductList:(NSMutableArray*)aProductList priceHashMap:(NSMutableDictionary*)aPriceHashMap bonusDealHashMap:(NSMutableDictionary*)aBonusDealHashMap;
- (NSMutableArray*)processPriceProductList:(NSMutableArray*)aProductList priceHashMap:(NSMutableDictionary*)aPriceHashMap;
- (NSMutableArray*)processMasterPriceProductList:(NSMutableArray*)aProductList masterPriceHashMap:(NSMutableDictionary*)aMasterPriceHashMap masterBonusDealHashMap:(NSMutableDictionary*)aMasterBonusDealHashMap;
- (NSMutableArray*)processPriceOverrideWithProductList:(NSMutableArray*)aProductList priceOverride:(int)aPriceOverride;
- (NSMutableArray*)processCUiurWithProductList:(NSMutableArray*)aProductList;
- (NSMutableArray*)processBonusDealProductList:(NSMutableArray*)aProductList bonusDealHashMap:(NSMutableDictionary*)aBonusDealHashMap;
- (NSMutableArray*)processMasterBonusDealProductList:(NSMutableArray*)aProductList masterBonusDealHashMap:(NSMutableDictionary*)aMasterBonusDealHashMap;
- (NSPredicate*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode;
- (NSPredicate*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode checkActive:(BOOL)aCheckFlag;
- (NSMutableArray*)convertDescrDetailDictList:(NSMutableArray*)aDescrDetailDictList;


@end
