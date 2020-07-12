//
//  CustomerContactTypesDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 26/06/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericReturnObject.h"
#import "ArcosUtils.h"
#import "PropertyUtils.h"
#import "ArcosCoreData.h"
#import "ArcosValidator.h"
#import "CustomerContactCreateDataManager.h"
#import "CustomerContactEditDataManager.h"

@interface CustomerContactTypesDataManager : NSObject {
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableArray* _fieldNameList;
    NSMutableDictionary* _constantFieldTypeDict;
    NSMutableArray* _displayList;
    NSMutableArray* _changedDataList;
    NSMutableArray* _seqFieldTypeList;
    NSMutableDictionary* _constantFieldTypeTranslateDict;
    NSMutableArray* _orderedFieldTypeList;
    
    NSMutableArray* _createdFieldNameList;
    NSMutableArray* _createdFieldValueList;
    
    NSMutableArray* _flagDisplayList;
    NSMutableArray* _originalFlagDisplayList;
    NSMutableArray* _flagChangedDataList;
    
    NSMutableArray* _checkFieldTypeConstantList;
    NSNumber* _iur;
    BOOL _isNewRecord;
    NSString* _actionType;
    NSMutableArray* _specialIURFieldNameList;
    
    BOOL _isTableViewEditable;
    CustomerContactActionBaseDataManager* _customerContactActionBaseDataManager;
    NSMutableArray* _linksLocationList;
    NSString* _flagsAlias;
    NSString* _linksAlias;
    NSNumber* _linkLocationIUR;
    NSInteger _currentLinkIndexPathRow;
    NSString* _accessTimesSectionTitle;
    NSMutableDictionary* _myCustDict;
    NSNumber* _employeeIUR;
}

@property(nonatomic,retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic,retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic,retain) NSMutableArray* fieldNameList;
@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeDict;
@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableArray* changedDataList;
@property(nonatomic,retain) NSMutableArray* seqFieldTypeList;
@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeTranslateDict;
@property(nonatomic,retain) NSMutableArray* orderedFieldTypeList;

@property(nonatomic,retain) NSMutableArray* createdFieldNameList;
@property(nonatomic,retain) NSMutableArray* createdFieldValueList;
@property(nonatomic,retain) NSMutableArray* flagDisplayList;
@property(nonatomic,retain) NSMutableArray* originalFlagDisplayList;
@property(nonatomic,retain) NSMutableArray* flagChangedDataList;
@property(nonatomic,retain) NSMutableArray* checkFieldTypeConstantList;
@property(nonatomic, retain) NSNumber* iur;
@property (nonatomic, assign) BOOL isNewRecord;
@property(nonatomic, retain) NSString* actionType;
@property(nonatomic, retain) NSMutableArray* specialIURFieldNameList;
@property (nonatomic, assign) BOOL isTableViewEditable;
@property(nonatomic, retain) CustomerContactActionBaseDataManager* customerContactActionBaseDataManager;
@property(nonatomic, retain) NSMutableArray* linksLocationList;
@property(nonatomic, retain) NSString* flagsAlias;
@property(nonatomic, retain) NSString* linksAlias;
@property(nonatomic, retain) NSNumber* linkLocationIUR;
@property(nonatomic, assign) NSInteger currentLinkIndexPathRow;
@property(nonatomic, retain) NSString* accessTimesSectionTitle;
@property(nonatomic, retain) NSMutableDictionary* myCustDict;
@property(nonatomic, retain) NSNumber* employeeIUR;

-(void)processRawData:(ArcosGenericReturnObject*)aContactResult flagData:(NSMutableArray*)anArrayOfFlagData;
-(void)createFlagBasicData;
-(void)processFlagRawData:(NSMutableArray*)anArrayOfData;
-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;
-(void)updateChangedData:(NSNumber*)aContactFlag indexPath:(NSIndexPath*)anIndexPath;
//-(BOOL)checkAllowedBeforeSubmit;
-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList;
-(BOOL)checkAllowedIURField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList;
-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList maxDigitNum:(int)aMaxDigitNum;
-(void)getFlagChangedDataList;
-(NSMutableArray*)getChangedDataList;
- (NSString*)fieldNameWithIndex:(int)anIndex;
-(void)prepareToCreateNewContact:(NSMutableArray*)aChangedDataArray;
-(NSMutableArray*)processSpecialIURFieldNameList:(NSMutableArray*)aChangedDataArray;
-(NSMutableArray*)processSpecialBooleanFieldNameList:(NSMutableArray*)aChangedDataArray;
-(void)createCustomerContactActionDataManager:(NSString*)anActionType;
-(void)getLinkData;
-(BOOL)isLocationExistent:(NSMutableDictionary*)aCustDict;
- (NSString*)buildEmailMessageBody;

@end
