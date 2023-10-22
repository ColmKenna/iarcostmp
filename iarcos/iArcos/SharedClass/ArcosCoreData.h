//
//  ArcosCoreData.h
//  Arcos
//
//  Created by David Kilmartin on 28/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import <CoreData/CoreData.h>
#import "JSON.h"
#import "Location.h"
#import "Price.h"
#import "LocationUM.h"
#import "Product.h"
#import "DescrDetail.h"
#import "OrderLine.h"
#import "OrderHeader.h"
#import "FormRow.h"
#import "FormColumn.h"
#import "FormDetail.h"
#import "Image.h"
#import "DescrType.h"
#import "Contact.h"
#import "ConLocLink.h"
#import "Presenter.h"
#import "ArcosService.h"
#import "Image.h"
#import "Memo.h"
#import "Call.h"
#import "Setting.h"
#import "SettingManager.h"

#import "ArcosCallTran.h"
#import "ArcosArrayOfCallTran.h"
#import "CallTran.h"
#import "Employee.h"
#import "Config.h"
#import "PropertyUtils.h"
#import "Survey.h"
#import "Journey.h"
#import "Question.h"
#import "Response.h"
#import "ArcosUtils.h"
#import "ArcosCoreDataManager.h"
#import "Collected.h"
#import "ProductFormRowConverter.h"
#import "ArcosDescriptionTrManager.h"
#import "LocationProductMAT.h"
#import "ArcosConfigDataManager.h"
#import "ArcosStockonHandUtils.h"
#import "Promotion.h"

typedef enum {
    PresenterFileTypeAudio = 800,
    PresenterFileTypeIamge,
    PresenterFileTypePdf,
    PresenterFileTypeTxt,
    PresenterFileTypeVideo,
    PresenterFileTypeWeb,
    PresenterFileTypeWord,
    PresenterFileTypeUnknown
} PresenterFileType;

@interface ArcosCoreData : NSObject<NSFetchedResultsControllerDelegate> {
    NSManagedObjectContext *addManagedObjectContext;
    NSManagedObjectContext *fetchManagedObjectContext;
    NSManagedObjectContext *deleteManagedObjectContext;
    NSManagedObjectContext *editManagedObjectContext;
    NSManagedObjectContext *importManagedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    ArcosCoreDataManager* _arcosCoreDataManager;
    ArcosDescriptionTrManager* _arcosDescriptionTrManager;
}
+ (ArcosCoreData *)sharedArcosCoreData;
-(id)init;

@property (nonatomic, retain, readonly) NSManagedObjectContext *addManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *fetchManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *deleteManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *editManagedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *importManagedObjectContext;
@property (nonatomic, retain, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) ArcosCoreDataManager* arcosCoreDataManager;
@property (nonatomic, retain) ArcosDescriptionTrManager* arcosDescriptionTrManager;

- (void)saveContext:(NSManagedObjectContext*)context;
- (NSURL *)applicationDocumentsDirectory;
- (NSFetchedResultsController *)FRCWithEntityName:(NSString*)entityName withPredicate:(NSPredicate*)aPredicate  withSortDescNames:(NSArray*)sortDescNames withSectionNameKeyPath:(NSString*)sectionName;
- (NSMutableArray*)fetchRecordsWithEntity:(NSString*)entityName withPropertiesToFetch:(NSArray*)properties withPredicate:(NSPredicate*)aPredicate withSortDescNames:(NSArray*)sortDescNames withResulType:(NSFetchRequestResultType)resultType needDistinct:(BOOL)distinct ascending:(NSNumber*)isAscending;
- (NSMutableArray*)fetchRecordsWithContext:(NSManagedObjectContext*)context withEntity:(NSString*)entityName withPropertiesToFetch:(NSArray*)properties withPredicate:(NSPredicate*)aPredicate withSortDescNames:(NSArray*)sortDescNames withResulType:(NSFetchRequestResultType)resultType needDistinct:(BOOL)distinct ascending:(NSNumber*)isAscending;

//core data operations

- (NSMutableArray*)allLocations;
- (NSMutableArray*)locationGroups;
- (NSMutableArray*)locationTypes;
- (NSMutableArray*)locationContactTypes;
- (NSMutableArray*)locationFromGeoBoundBox:(CGRect)boundBox;
- (NSString*)locationNameWithIUR:(NSNumber*)anIUR;
- (Location*)locationMAWithIUR:(NSNumber*)anIUR;
- (NSMutableArray*)locationWithIUR:(NSNumber*)anIUR;
- (NSMutableArray*)locationWithIURWithoutCheck:(NSNumber *)anIUR;
- (NSMutableArray*)locationsWithIURList:(NSMutableArray*)anIURList;
- (UIImage*)thumbWithIUR:(NSNumber*)anIUR;
- (UIImage*)thumbWithDescIUR:(NSNumber*)anIUR;
- (NSMutableArray*)outletsWithMasterIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType;
- (NSMutableArray*)outletsWithLTIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType;
- (NSMutableArray*)retrieveLocationWithPredicate:(NSPredicate*)aPredicate;
- (BOOL)isGroupForIUR:(NSNumber*)anIUR;
- (void)updateLocationWithFieldName:(NSString*)aFieldName withActualContent:(id)anActualContent withLocationIUR:(NSNumber*)aLocationIUR;
- (void)locationWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR;
//LocLocLink
- (NSMutableArray*)getLocLocLink:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR;
// presenter data
- (NSMutableDictionary*)productsWithPresentDoc;
- (NSMutableDictionary*)fileTypes;
- (NSMutableArray*)productWithIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType;
- (NSMutableArray*)productWithL5Code:(NSString*)code;
- (NSMutableArray*)filesWithTypeIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType;
- (NSMutableArray*)filesWithProductIUR:(NSNumber*)anIUR withResultType:(NSFetchRequestResultType)resultType;
- (NSMutableDictionary*)productL5Group;
- (NSMutableArray*)l5GroupWithTypeCode:(NSString*)typeCode;
- (NSMutableArray*)filesWithGroupType:(NSString*)typeCode;
- (NSMutableArray*)presenterProducts;
- (NSMutableArray*)presenterProductsActiveOnly:(BOOL)aFlag;
- (NSMutableArray*)activeProductWithL5Code:(NSString*)anL5Code;
- (NSMutableArray*)activeProductWithLxCode:(NSString*)anLxCode orderLevel:(NSNumber*)anOrderLevel;
- (NSMutableArray*)activeProductWithL5CodeList:(NSArray*)anL5CodeList;
- (NSNumber*)countActiveProductWithL5Code:(NSString*)anL5Code;
- (NSMutableArray*)activeProductWithL3Code:(NSString*)anL3Code l5Code:(NSString*)anL5Code;
- (NSMutableArray*)activeProduct:(NSString*)aBranchLxCodeContent branchLxCode:(NSString*)aBranchLxCode leafLxCodeContent:(NSString*)anLeafLxCodeContent leafLxCode:(NSString*)anLeafLxCode;

//new presenter data
- (NSMutableArray*)presenterParentProducts:(NSNumber*)locationParentIUR;
- (NSMutableArray*)presenterChildrenWithParentIUR:(NSNumber*)parentIUR;
- (NSDictionary*)presenterWithIUR:(NSNumber*)anIUR;
- (NSMutableArray*)presenterWithIURList:(NSMutableArray*)anIURList;
//order data
- (NSNumber*)orderWithOrderNumber:(int)anOrderNumber;
- (NSMutableArray*)allOrdersWithSortKey:(NSString*)aKey withLocationIUR:(NSNumber*)anIUR;
- (NSMutableArray*)allOrderLinesWithOrderNumber:(NSNumber*)aNumber withSortKey:(NSString*)aKey locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (NSMutableArray*)ordersWithDataRangeStart:(NSDate*)startDate withEndDate:(NSDate*)endDate;
- (NSMutableArray*)retrievePendingOnlyOrders;
- (NSNumber*)countCallsWithDataRangeStart:(NSDate*)aStartDate withEndDate:(NSDate*)anEndDate;
- (NSMutableArray*)ordersWithLocationIUR:(NSNumber*)aLocationIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate;
//- (NSMutableArray*)ordersWithCustomerIUR:(NSNumber*)anIUR;
//- (NSMutableArray*)callsWithCustomerIUR:(NSNumber*)anIUR;
- (NSMutableArray*)lastOrderWithOrderNumber:(NSNumber*)anIUR;
- (NSMutableArray*)allOrderToday;
- (NSMutableArray*)allOrderWeek;
- (NSMutableArray*)allOrderThisMonth;
- (NSMutableArray*)allOrderThisYear;
- (NSMutableDictionary*)orderTotalValues;
- (NSMutableDictionary*)orderForms;
- (NSMutableDictionary*)selectionWithOrderIUR:(NSNumber*)anIUR;
- (NSMutableArray*)selectionWithFormIUR:(NSNumber*)anIUR;
- (NSMutableArray*)formDetail;
- (NSMutableArray*)formDetailWithoutAll;
- (NSDictionary*)formDetailWithFormIUR:(NSNumber*)aFormIUR;
- (NSDictionary*)formDetailWithFormType:(NSString*)aFormType;
- (BOOL)deleteFormDetailWithFormIUR:(NSNumber*)aFormIUR;

- (NSMutableDictionary*)formRowWithDividerIUR:(NSNumber*)anIUR withFormIUR:(NSNumber*)formIUR;
- (NSMutableArray*)dividerFormRowsWithDividerIUR:(NSNumber*)anIUR formIUR:(NSNumber*)aFormIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (NSMutableArray*)formRowWithDividerIURSortByNatureOrder:(NSNumber*)anIUR withFormIUR:(NSNumber*)formIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (NSDictionary*)formRowWithFormIUR:(NSNumber*)aFormIUR productIUR:(NSNumber*)aProductIUR;
- (NSMutableArray*)formRowWithFormIUR:(NSNumber*)aFormIUR dividerRecordIUR:(NSNumber*)anDividerRecordIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;
- (NSMutableArray*)formRowProductProcessCenter:(NSMutableArray*)anObjectArray locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR orderFormDetails:(NSString*)anOrderFormDetails;
- (BOOL)deleteFormRowWithFormIUR:(NSNumber*)aFormIUR;

- (void)saveGeoLocationWithLocationIUR:(NSNumber*)anIUR withLat:(NSNumber*)lat withLon:(NSNumber*)lon;
- (NSMutableDictionary*)createFormRowWithProductIUR:(NSNumber*)anIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR orderFormDetails:(NSString*)anOrderFormDetails;
- (BOOL)updateOrderLine:(NSMutableDictionary*)orderLine;
- (BOOL)deleteOrderLineWithOrderNumber:(NSNumber*)orderNumber withLineNumber:(NSNumber*)lineNumber;
- (BOOL)deleteOrderLine:(NSMutableDictionary*)orderLine;
- (BOOL)deleteOrderLinesWithOrderNumber:(NSNumber*)orderNumber;
- (BOOL)deleteOrderHeader:(NSMutableDictionary*)orderNumber;
- (BOOL)deleteOrderHeaderWithOrderNumber:(NSNumber*)orderHeader;
- (BOOL)saveOrderLineWithOrderNumber:(NSNumber*)anOrderNumber withOrderlines:(NSMutableDictionary*)anOrderLinesDict;
- (OrderLine*)createOrderLineWithOrderHeader:(OrderHeader*)anOrderHeader orderLine:(NSMutableDictionary*)anOrderLine lineNumber:(int)aLineNumber context:(NSManagedObjectContext*)aContext;
- (OrderHeader*)orderHeaderWithOrderNumber:(NSNumber*)orderNumber;
- (NSMutableDictionary*)editingOrderHeaderWithOrderNumber:(NSNumber*)orderNumber;
- (BOOL)saveOrderHeader:(NSMutableDictionary*)orderHeader;
- (BOOL)updateOrderHeaderTotalGoods:(NSNumber*)totalGoods withOrderNumber:(NSNumber*)orderNumber totalVat:(NSNumber*)aTotalVat;
//send order
- (BOOL)saveSentOrderWithOrderHeaderBO:(ArcosOrderHeaderBO*)orderHeaderBO;
//- (BOOL)updateOrderLineForOrderHeaderBO:(ArcosOrderHeaderBO*)orderHeaderBO;
- (void)changeOrderHeaderIurWithOrderNumber:(NSNumber*)orderNumber WithValue:(NSNumber*)value;
//check out data
- (NSMutableArray*)orderWholeSalers;
- (NSMutableArray*)orderStatus;
- (NSMutableArray*)orderTypes;
- (NSMutableArray*)callTypes;
- (NSMutableArray*)orderContactsWithLocationIUR:(NSNumber*)anIUR;
- (NSUInteger)locationContactsWithLocationIUR:(NSNumber*)anIUR;
- (NSMutableArray*)contactWithIUR:(NSNumber*)anIUR;
- (NSMutableArray*)contactWithIURList:(NSMutableArray*)anIURList;
- (NSMutableArray*)conlocLinksWithLocationIUR:(NSNumber*)anIUR;
- (NSMutableArray*)conlocLinksWithContactIUR:(NSNumber*)anIUR;
- (NSMutableArray*)conlocLinksWithContactIURList:(NSMutableArray*)anIURList;
- (BOOL)deleteConLocLinkWithIUR:(NSNumber*)anIUR;
- (NSMutableDictionary*)theLastOrderWithLocationIUR:(NSNumber*)anIUR;
- (OrderHeader*)theLastOrderHeaderWithLocationIUR:(NSNumber*)anIUR;
//descrDetail data
- (NSDictionary*)descriptionWithIUR:(NSNumber*)anIUR;
- (NSDictionary*)descriptionWithIURActive:(NSNumber*)anIUR;
- (NSDictionary*)descriptionWithIUR:(NSNumber *)anIUR needActive:(BOOL)active;
- (NSMutableArray*)descriptionWithIURList:(NSMutableArray*)anIURList;
- (NSMutableArray*)descriptionWithIURList:(NSMutableArray*)anIURList needActive:(BOOL)active;
- (NSDictionary*)descrTypeWithTypeCode:(NSString*)aCode;
- (NSDictionary*)descrTypeAllRecordsWithTypeCode:(NSString*)aCode;
- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString*)aDescrCodeType;
- (NSMutableArray*)descrDetailWithPredicate:(NSPredicate*)aPredicate sortByArray:(NSArray*)anSortArray;
- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString *)aDescrTypeCode;
- (void)updateDescrDetailWithFieldName:(NSString*)aFieldName fieldValue:(id)aFieldValue descrTypeCode:(NSString*)aDescrTypeCode descrDetailIUR:(NSNumber*)aDescrDetailIUR;
- (void)createDescrDetailWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList descrTypeCode:(NSString*)aDescrTypeCode;
- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode;
- (NSMutableArray*)descrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode checkActive:(BOOL)aCheckFlag;
- (NSMutableArray*)descrDetailWithL5CodeList:(NSArray*)aL5CodeList descrTypeCode:(NSString*)aDescrTypeCode active:(int)anActive;
- (NSMutableArray*)descrDetailWithDescrDetailIUR:(NSNumber*)aDescrDetailIUR;
- (NSNumber*)countDescrDetailWithDescrCodeType:(NSString *)aDescrCodeType parentCode:(NSString*)aParentCode;
- (NSMutableArray*)descrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode;
- (NSMutableArray*)descrDetailAllFieldsWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode;
- (NSMutableArray*)descrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCodeList:(NSMutableArray*)aDescrDetailCodeList;

//descrtype
- (NSMutableArray*)allDescrType;

//save the order
-(BOOL)saveOrder:(NSMutableDictionary*)anOrder;
-(BOOL)saveCall:(NSMutableDictionary*)aCall;

//setting
-(NSMutableDictionary*)getSetting;
-(void)loadDefaultSetting;
-(void)updateNextOrderNumber;
-(NSMutableArray*)settingSelectionWithType:(NSString*)type;
-(NSMutableArray*)settingOrderForms;
-(NSMutableDictionary*)formWithIUR:(NSNumber*)anIUR;

//detailing
-(NSMutableArray*)detailingQA;
-(NSMutableArray*)detailingQAWithSubDescrDetailCode:(NSString*)aSubDescrDetailCode;
-(NSMutableArray*)detailingQAProduct;
-(NSMutableArray*)detailingQADescCheckFlag:(BOOL)aCheckFlag subDescrDetailCode:(NSString*)aSubDescrDetailCode;
-(NSMutableArray*)detailingSamples;
-(NSMutableArray*)batchsWithProductIUR:(NSNumber*)anIUR;
-(NSMutableArray*)detailingRNG;


//employee
-(NSDictionary*)employeeWithIUR:(NSNumber*)anIUR;
-(NSMutableArray*)employeeWithIURList:(NSMutableArray*)anIURList;
-(NSMutableArray*)allEmployee;
-(void)editEmployeeWithIUR:(NSNumber*)anIUR journeyStartDate:(NSDate*)aDate;

//contact
-(void)contactWithDataList:(NSMutableArray*)aFieldValueList contactIUR:(NSNumber*)aContactIUR titleTypeIUR:(NSNumber*)aTitleTypeIUR contactTypeIUR:(NSNumber*)aContactTypeIUR locationIUR:(NSNumber*)aLocationIUR;
-(void)conLocLinkWithIUR:(NSNumber*)anIUR contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR;
- (void)updateContactWithFieldName:(NSString*)aFieldName withActualContent:(id)anActualContent withContactIUR:(NSNumber*)aContactIUR;
- (void)contactWithFieldNameList:(NSMutableArray*)aFieldNameList fieldValueList:(NSMutableArray*)aFieldValueList iur:(NSNumber*)anIUR;
- (NSMutableArray*)contactLocationWithCOIUR:(NSNumber*)aCOIUR;
- (NSMutableArray*)contactLocationWithPredicate:(NSPredicate*)aPredicate;
- (NSMutableDictionary*)compositeContactWithIUR:(NSNumber*)anIUR;

//config
-(NSDictionary*)configWithIUR:(NSNumber*)anIUR;
//survey
-(NSMutableArray*)allSurvey;
-(NSMutableArray*)questionWithSurveyIUR:(NSNumber*)anIUR;
-(void)insertResponseWithDataList:(NSMutableDictionary*)aQuestionDict originalDataDict:(NSMutableDictionary*)anOriginalQuestionDict contactIUR:(NSNumber*)aContactIUR locationIUR:(NSNumber*)aLocationIUR unsendOnly:(BOOL)anUnsendOnlyFlag;
-(NSDictionary*)responseWithLocationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR surveyIUR:(NSNumber*)aSurveyIUR questionIUR:(NSNumber*)aQuestionIUR;
-(NSMutableArray*)responseWithLocationIUR:(NSNumber*)aLocationIUR surveyIUR:(NSNumber*)aSurveyIUR contactIUR:(NSNumber*)aContactIUR questionIURList:(NSMutableArray*)aQuestionIURList unsendOnly:(BOOL)anUnsendOnlyFlag;
//Journey
-(NSMutableArray*)allJourney;
-(NSMutableArray*)journeyWithWeekNumber:(NSNumber*)aWeekNumber dayNumber:(NSNumber*)aDayNumber;
-(NSDictionary*)getLocationWithIUR:(NSNumber*)aLocationIUR;
-(NSMutableArray*)getLocationsWithPredicate:(NSPredicate*)aPredicate;
//Memo
-(void)insertMemoWithData:(ArcosGenericClass*)arcosGenericClass;

//update table to server
-(NSArray*)allLocationWithNewGeo;
-(NSArray*)allNewResponse;
-(void)updateResponseWithBO:(ArcosResponseBO*)anObject;

//Tables
-(NSArray*)allEntities;
-(NSNumber*)entityRecordQuantity:(NSString*)anEntity;
-(NSMutableArray*)entityContent:(NSString*)anEntity;

//Product data
-(NSMutableArray*)productWithDescriptionKeyword:(NSString*)aKeyword;
-(NSMutableArray*)productWithProductCodeKeyword:(NSString*)aKeyword;
-(NSNumber*)productQtyWithProductIUR:(int)aProductIUR;
//-(Product*)populateProductWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject product:(Product*)Product;
- (void)createActiveProduct;
- (NSNumber*)activeProductNumber;
- (NSMutableArray*)productWithL3Code:(NSString*)aL3Code;
- (NSMutableArray*)productWithL3CodeList:(NSArray *)aL3CodeList;
- (NSMutableArray*)productWithBranchCodeList:(NSArray *)aBranchCodeList branchLxCode:(NSString*)aBranchLxCode leafLxCode:(NSString*)anLeafLxCode;
- (NSMutableArray*)productWithProductIURList:(NSMutableArray*)aProductIURList;
- (NSMutableArray*)productWithIURList:(NSMutableArray*)anIURList withResultType:(NSFetchRequestResultType)aResultType;
//Price data
- (NSMutableDictionary*)retrievePriceWithLocationIUR:(NSNumber*)aLocationIUR productIURList:(NSMutableArray*)aProductIURList;
- (NSMutableDictionary*)retrieveBonusDealWithLocationIUR:(NSNumber*)aLocationIUR productIURList:(NSMutableArray*)aProductIURList;

//Collected data
- (BOOL)deleteCollectedWithLocationIUR:(NSNumber*)aLocationIUR comments:(NSString*)aComments;
- (void)insertCollectedWithLocationIUR:(NSNumber*)aLocationIUR comments:(NSString*)aComments iUR:(NSNumber*)anIUR date:(NSDate*)aDate;
//Package data
- (NSMutableDictionary*)retrieveDefaultPackageWithLocationIUR:(NSNumber*)aLocationIUR;
- (NSMutableDictionary*)retrievePackageWithIUR:(NSNumber*)aPackageIUR;
//Contact Flag
- (NSMutableArray*)retrieveContactFlagData;

//testing and loading jason data functions
- (void)clearTables;
- (void)clearTableWithName:(NSString*)aName;
- (void)clearAllTables;
- (void)updatePresenterWithIUR:(NSNumber*)anIUR;
//load data from soap object
- (void)LoadDescriptionWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
- (void)LoadDescrDetailWithFieldList:(NSArray*)aFieldList existingDescrDetailDict:(NSMutableDictionary*)anExistingDescrDetailDict;
- (void)LoadProductWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
- (void)LoadProductWithFieldList:(NSArray*)aFieldList existentProductDict:(NSMutableDictionary*)anExistentProductDict;
- (void)loadLocationProductMATWithFieldList:(NSArray*)aFieldList existingLocationProductMATDict:(NSMutableDictionary*)anExistingLocationProductMATDict levelIUR:(NSNumber*)aLevelIUR;
- (void)LoadPackageWithFieldList:(NSArray*)aFieldList existingPackageDict:(NSMutableDictionary*)anExistingPackageDict;
- (BOOL)LoadLocationWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
- (void)LoadLocationWithFieldList:(NSArray*)aFieldList existingLocationDict:(NSMutableDictionary*)anExistingLocationDict;
- (void)LoadPriceWithFieldList:(NSArray*)aFieldList existingPriceDict:(NSMutableDictionary*)anExistingPriceDict existingPromotionDict:(NSMutableDictionary*)anExistingPromotionDict;
-(void)loadLocLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
- (void)loadLocLocLinkWithFieldList:(NSArray*)aFieldList existingLocLocLinkDict:(NSMutableDictionary*)anExistingLocLocLinkDict;
-(void)loadFormDetailsWithSoapOB:(ArcosFormDetailBO*)anObject;
-(void)loadFormRowWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
-(void)loadWholeSalerWithSoapOB:(ArcosWholeSalerBO*)anObject;
-(void)loadDescriptionTypeWithSoapOB:(ArcosDescrTypeBO*)anObject;
-(void)loadContactWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
-(void)loadConLocLinkWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
-(void)loadPresenterWithSoapOB:(ArcosPresenter*)anObject;
-(void)loadImageWithSoapOB:(ArcosGenericReturnObjectWithImage*)anObject;
-(void)loadEmployeeWithSoapOB:(ArcosEmployeeBO*)anObject;
-(void)loadConfigWithSoapOB:(ArcosConfig*)anObject;
-(void)loadOrderWithSoapOB:(ArcosOrderHeaderBO*)anObject;
-(void)loadCallWithSoapOB:(ArcosCallBO*)anObject;
-(void)loadResponseWithSoapOB:(ArcosResponseBO*)anObject;
-(void)loadSurveyWithSoapOB:(ArcosSurveyBO*)anObject;
-(void)loadJourneyWithSoapOB:(ArcosJourneyBO*)anObject;
//usefull utilitiese
-(NSString*)fullAddressWith:(NSMutableDictionary*)aLocation;
- (NSMutableArray*)processEntryPriceProductList:(NSMutableArray*)aProductList productIURList:(NSMutableArray*)aProductIURList locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR;

//Generic method
-(NSNumber*)recordQtyWithEntityName:(NSString*)anEntityName predicate:(NSPredicate*)aPredicate;
-(void)executeTransaction;

@end
