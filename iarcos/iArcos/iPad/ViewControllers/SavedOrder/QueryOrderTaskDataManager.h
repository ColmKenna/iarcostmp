//
//  QueryOrderTaskDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 27/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericReturnObject.h"
#import "PropertyUtils.h"
#import "ArcosCreateRecordObject.h"
#import "ArcosValidator.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"

@interface QueryOrderTaskDataManager : NSObject {
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
    NSString* _issueClosedField;
    BOOL _isIssueClosedChanged;
    BOOL _issueClosedActualValue;
    NSString* _completionDateString;
    NSString* _defaultCompletionDateString;
    NSString* _createMemoDetails;
    NSNumber* _contactIUR;
    
    //memos section
    NSMutableArray* _memoDisplayList;
    BOOL _isMemoDetailShowed;
    NSMutableArray* _heightList;
    
    NSMutableArray* _specialIURFieldNameList;
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
@property(nonatomic,retain) NSString* issueClosedField;
@property(nonatomic,assign) BOOL isIssueClosedChanged;
@property(nonatomic,assign) BOOL issueClosedActualValue;
@property(nonatomic,retain) NSString* completionDateString;
@property(nonatomic,retain) NSString* defaultCompletionDateString;
@property(nonatomic,retain) NSString* createMemoDetails;
@property(nonatomic,retain) NSNumber* contactIUR;

@property(nonatomic,retain) NSMutableArray* memoDisplayList;
@property(nonatomic,assign) BOOL isMemoDetailShowed;
@property(nonatomic,retain) NSMutableArray* heightList;

@property(nonatomic,retain) NSMutableArray* specialIURFieldNameList;

-(void)processRawData:(ArcosGenericReturnObject*)result actionType:(NSString*)anActionType;
-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)updateChangedData:(id)aContentString actualContent:(id)anActualContent withIndexPath:(NSIndexPath*)anIndexPath;
-(NSMutableArray*)getChangedDataList;
-(void)prepareToCreateRecord;
-(NSString*)fieldNameWithIndex:(int)anIndex;
-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath;
-(BOOL)checkAllowedStringField:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList;
-(NSString*)getActualValueWithFieldName:(NSString*)aFieldName cellDictList:(NSMutableArray*)aCellDictList;
-(void)processContactIURFromHomePage;

@end
