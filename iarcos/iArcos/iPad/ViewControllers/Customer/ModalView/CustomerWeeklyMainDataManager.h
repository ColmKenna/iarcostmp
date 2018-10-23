//
//  CustomerWeeklyMainDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosGenericClass.h"
#import "ArcosUtils.h"

@interface CustomerWeeklyMainDataManager : NSObject {
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableArray* _sectionTitleList;
    NSMutableArray* _fieldNameList;
    NSMutableArray* _fieldValueList;
    BOOL _isNewRecord;
    NSMutableArray* _updatedFieldNameList;
    NSMutableArray* _updatedFieldValueList;
    NSNumber* _iur;
    NSMutableArray* _dbFieldNameList;
    NSMutableArray* _attachmentFileNameList;
    NSMutableArray* _attachmentFileContentList;
        
}

@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableArray* fieldNameList;
@property(nonatomic, retain) NSMutableArray* fieldValueList;
@property(nonatomic, assign) BOOL isNewRecord;
@property(nonatomic, retain) NSMutableArray* updatedFieldNameList;
@property(nonatomic, retain) NSMutableArray* updatedFieldValueList;
@property(nonatomic, retain) NSNumber* iur;
@property(nonatomic, retain) NSMutableArray* dbFieldNameList;
@property(nonatomic, retain) NSMutableArray* attachmentFileNameList;
@property(nonatomic, retain) NSMutableArray* attachmentFileContentList;

-(id)initWithSectionTitleDictList:(NSMutableArray*)aSectionTitleDictList;
-(NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
-(void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath;
-(void)prepareForCreateWeeklyRecord;
-(void)processRawData:(NSMutableArray*)aDataList;
-(void)createBasicData;
-(void)getChangedDataList;
-(BOOL)checkValidation;
-(void)reinitiateAttachmentAuxiObject;

@end
