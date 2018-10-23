//
//  QueryOrderMemoDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 30/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericReturnObject.h"
#import "PropertyUtils.h"
#import "ArcosCreateRecordObject.h"
#import "ArcosCoreData.h"
#import "ArcosValidator.h"

@interface QueryOrderMemoDataManager : NSObject {
    NSMutableArray* _fieldNameList;
    NSMutableArray* _displayList;
    NSMutableDictionary* _constantFieldTypeDict;
    NSMutableArray* _seqFieldTypeList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableDictionary* _constantFieldTypeTranslateDict;
    NSMutableDictionary* _ruleoutFieldNameDict;
    NSMutableArray* _activeSeqFieldTypeList;
    
    NSMutableArray* _changedDataList;
    NSMutableArray* _createdFieldNameList;
    NSMutableArray* _createdFieldValueList;
    
    ArcosCreateRecordObject* _arcosCreateRecordObject;
    
    NSString* _changedFieldName;
    NSString* _changedActualContent;
    int _rowPointer;
    NSNumber* _contactIUR;
    
    NSString* _issueClosedField;
    BOOL _isIssueClosedChanged;
    BOOL _issueClosedActualValue;
    NSString* _taskCompletionDateString;
    NSString* _defaultCompletionDateString;
    
    NSString* _tmpTaskChangedFieldName;
    NSString* _tmpTaskChangedActualContent;
}

@property(nonatomic,retain) NSMutableArray* fieldNameList;
@property(nonatomic,retain) NSMutableArray* displayList;
@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeDict;
@property(nonatomic,retain) NSMutableArray* seqFieldTypeList;
@property(nonatomic,retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic,retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic,retain) NSMutableDictionary* constantFieldTypeTranslateDict;
@property(nonatomic,retain) NSMutableDictionary* ruleoutFieldNameDict;
@property(nonatomic,retain) NSMutableArray* activeSeqFieldTypeList;
@property(nonatomic,retain) NSMutableArray* changedDataList;
@property(nonatomic,retain) NSMutableArray* createdFieldNameList;
@property(nonatomic,retain) NSMutableArray* createdFieldValueList;
@property(nonatomic,retain) ArcosCreateRecordObject* arcosCreateRecordObject;
@property(nonatomic,retain) NSString* changedFieldName;
@property(nonatomic,retain) NSString* changedActualContent;
@property(nonatomic,assign) int rowPointer;
@property (nonatomic,retain) NSNumber* contactIUR;

@property(nonatomic,retain) NSString* issueClosedField;
@property(nonatomic,assign) BOOL isIssueClosedChanged;
@property(nonatomic,assign) BOOL issueClosedActualValue;
@property(nonatomic,retain) NSString* taskCompletionDateString;
@property(nonatomic,retain) NSString* defaultCompletionDateString;

@property(nonatomic,retain) NSString* tmpTaskChangedFieldName;
@property(nonatomic,retain) NSString* tmpTaskChangedActualContent;

-(void)processRawData:(ArcosGenericReturnObject*)result actionType:(NSString*)anActionType;
-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;
-(NSMutableArray*)getChangedDataList;
-(void)prepareToCreateRecord;
-(NSString*)fieldNameWithIndex:(int)anIndex;
-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath;
-(void)processContactIURFromTask;
-(void)processMemoTypeByDefault;
-(void)processIssueClosed;
-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList;

@end
