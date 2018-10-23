//
//  DashboardVanStocksDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingManager.h"
#import "ArcosCoreData.h"


@interface DashboardVanStocksDataManager : NSObject {
    NSString* _fileName;
    NSMutableArray* _displayList;
    NSString* _commaDelimiter;
    NSMutableArray* _vanStockDictList;
    int _expectedFieldCount;
    NSString* _firstDate;
    NSMutableDictionary* _existingObjectDict;
    NSMutableArray* _existingObjectList;
    int _rowPointer;
    BOOL _isSaveRecordLoadingFinished;
    NSMutableArray* _productCodeList;
    NSString* _formDetails;
    NSDictionary* _vanSalesFormDetailDict;
}

@property(nonatomic, retain) NSString* fileName;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* commaDelimiter;
@property(nonatomic, retain) NSMutableArray* vanStockDictList;
@property(nonatomic, assign) int expectedFieldCount;
@property(nonatomic, retain) NSString* firstDate;
@property(nonatomic, retain) NSMutableDictionary* existingObjectDict;
@property(nonatomic, retain) NSMutableArray* existingObjectList;
@property(nonatomic,assign) int rowPointer;
@property(nonatomic,assign) BOOL isSaveRecordLoadingFinished;
@property(nonatomic, retain) NSMutableArray* productCodeList;
@property(nonatomic, retain) NSString* formDetails;
@property(nonatomic, retain) NSDictionary* vanSalesFormDetailDict;

- (NSString*)retrieveFileName;
- (void)retrieveStockOnOrderProducts;
- (NSMutableDictionary*)createVanStockDictWithFieldList:(NSArray*)aFieldList;
- (void)processRawData:(NSArray*)aRecordList;
- (void)loadObjectWithDict:(NSMutableDictionary*)aDict;
- (void)resetVanStockData;
- (void)retrieveExistingObjectDict;
- (BOOL)orderButtonPressed:(UIViewController*)aTarget;
- (NSMutableArray*)retrieveIdealProductList;
- (NSMutableArray*)retrieveLocationWithLocationCode:(NSString*)aLocationCode;
- (NSMutableArray*)retrieveDescrDetailWithDescrTypeCode:(NSString*)aDescrTypeCode descrDetailCode:(NSString*)aDescrDetailCode;
- (NSString*)retrieveLocationCodeWithEmployeeIUR:(NSNumber*)anEmployeeIUR;
- (NSDictionary*)retrieveVanSalesFormDetail;
- (void)removeVanSalesFormRow;

@end
