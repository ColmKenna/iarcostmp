//
//  OrderDetailBaseDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 26/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface OrderDetailBaseDataManager : NSObject {
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSString* _titleKey;
}

@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSString* titleKey;

- (void)createLocationSectionData;
- (void)createContactSectionData;
- (void)createOrderDetailsSectionData;
- (void)createOrderMemoSectionData;
- (void)createCallMemoSectionData;
- (void)createPrintSectionData;
- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType;
//- (void)createCallDrillDownSectionData;
- (NSMutableDictionary*)createDateLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType;
- (NSMutableDictionary*)createReadLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)createWriteCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType fieldData:(NSMutableDictionary*)aFieldData;
- (NSMutableDictionary*)createTextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)createDeliveryInstructions1TextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)createTextViewCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)createDrillDownCellDataWithFieldNameLabel:(NSString*)aFieldNameLabel orderHeaderType:(NSNumber*)anOrderHeaderType;
- (NSMutableDictionary*)createNumberTextFieldCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSString*)aFieldData;
- (NSMutableDictionary*)createDateHourMinLabelCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel writeType:(NSNumber*)aWriteType;
- (NSMutableDictionary*)createFormTypeCellDataWithCellKey:(NSString*)aCellKey fieldNameLabel:(NSString*)aFieldNameLabel fieldData:(NSMutableDictionary*)aFieldData;
- (NSString*)employeeName:(NSNumber*)anEmployeeIUR;
- (NSMutableDictionary*)addTitleToDict:(NSString*)aCellKey titleKey:(NSString*)aTitleKey;
- (void)createAllSectionData;

@end
