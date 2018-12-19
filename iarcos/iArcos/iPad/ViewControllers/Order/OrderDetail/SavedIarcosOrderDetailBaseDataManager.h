//
//  SavedIarcosOrderDetailBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface SavedIarcosOrderDetailBaseDataManager : NSObject {
    NSMutableDictionary* _orderHeader;
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSString* _titleKey;
    NSString* _contactSectionTitle;
    NSString* _orderSectionTitle;
    NSString* _memoSectionTitle;
    NSString* _printSectionTitle;
}

@property(nonatomic, retain) NSMutableDictionary* orderHeader;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSString* titleKey;
@property(nonatomic, retain) NSString* contactSectionTitle;
@property(nonatomic, retain) NSString* orderSectionTitle;
@property(nonatomic, retain) NSString* memoSectionTitle;
@property(nonatomic, retain) NSString* printSectionTitle;

- (void)createContactSectionData;
- (void)createOrderDetailsSectionData;
- (void)createOrderMemoSectionData;
- (void)createCallMemoSectionData;
- (void)createRemoteContactSectionData;
- (void)createRemoteOrderDetailsSectionData;
- (void)createRemoteOrderMemoSectionData;
- (void)createRemoteCallMemoSectionData;
- (void)createDrillDownSectionDataWithSectionTitle:(NSString*)aSectionTitle orderHeaderType:(NSNumber*)anOrderHeaderType;
- (void)createPrintSectionData;

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
