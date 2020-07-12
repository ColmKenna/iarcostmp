//
//  CustomerTypesDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 11/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericReturnObject.h"
#import "ArcosUtils.h"
#import "PropertyUtils.h"
#import "CustomerDetailsCreateDataManager.h"
#import "CustomerDetailsEditDataManager.h"
#import "ArcosCoreData.h"

@interface CustomerTypesDataManager : NSObject {
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableArray* _fieldNameList;
    NSMutableDictionary* _constantFieldTypeDict;
    NSMutableArray* _displayList;
    NSMutableDictionary* _auxFieldTypeDict;
    NSArray* _auxFieldTypeList;
    NSMutableArray* _changedDataList;
    NSMutableArray* _seqFieldTypeList;
    NSMutableDictionary* _constantFieldTypeTranslateDict;
    
    NSMutableArray* _createdFieldNameList;
    NSMutableArray* _createdFieldValueList;
    NSMutableArray* _orderedFieldTypeList;
    CustomerDetailsActionBaseDataManager* _customerDetailsActionBaseDataManager;
    NSString* _linksAlias;
    NSMutableArray* _linksLocationList;
    NSNumber* _locationIUR;
    NSNumber* _fromLocationIUR;
    BOOL _isTableViewEditable;
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
@property(nonatomic,retain) NSMutableDictionary* auxFieldTypeDict;
@property(nonatomic,retain) NSArray* auxFieldTypeList;
@property(nonatomic,retain) NSMutableArray* changedDataList;
@property(nonatomic,retain) NSMutableArray* seqFieldTypeList;
@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeTranslateDict;

@property(nonatomic,retain) NSMutableArray* createdFieldNameList;
@property(nonatomic,retain) NSMutableArray* createdFieldValueList;
@property(nonatomic,retain) NSMutableArray* orderedFieldTypeList;
@property(nonatomic,retain) CustomerDetailsActionBaseDataManager* customerDetailsActionBaseDataManager;
@property(nonatomic,retain) NSString* linksAlias;
@property(nonatomic,retain) NSMutableArray* linksLocationList;
@property(nonatomic,retain) NSNumber* locationIUR;
@property(nonatomic,retain) NSNumber* fromLocationIUR;
@property (nonatomic, assign) BOOL isTableViewEditable;
@property (nonatomic, assign) NSInteger currentLinkIndexPathRow;
@property(nonatomic,retain) NSString* accessTimesSectionTitle;
@property(nonatomic,retain) NSMutableDictionary* myCustDict;
@property(nonatomic,retain) NSNumber* employeeIUR;

-(void)processRawData:(ArcosGenericReturnObject*) result withNumOfFields:(int)numFields;
-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(NSMutableArray*)getChangedDataList;
-(NSString*)fieldNameWithIndex:(int)anIndex;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;

-(void)prepareToCreateNewLocation:(NSMutableArray*)aChangedDataArray;
-(void)createCustomerDetailsActionDataManager:(NSString*)anActionType;
-(void)getLinkData;
-(void)addLocLocLinkWithIUR:(NSNumber*)anIUR locationIUR:(NSNumber*)aLocationIUR fromLocationIUR:(NSNumber*)aFromLocationIUR;
-(BOOL)isLocationExistent:(NSMutableDictionary*)aCustDict;
-(BOOL)deleteLocLocLinkWithIUR:(NSNumber*)anIUR;
- (NSString*)buildEmailMessageBody;

@end
