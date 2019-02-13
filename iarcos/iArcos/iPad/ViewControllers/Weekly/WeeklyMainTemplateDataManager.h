//
//  WeeklyMainTemplateDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 22/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"
#import "ArcosDescriptionTrManager.h"

@interface WeeklyMainTemplateDataManager : NSObject {
    NSNumber* _employeeIUR;
    NSString* _employeeName;
    NSNumber* _dayOfWeekend;
    int _rowPointer;
    NSMutableArray* _employeeDetailList;
    NSDictionary* _employeeDict;
    NSDate* _currentWeekendDate;
    NSDate* _highestAllowedWeekendDate;
    NSMutableArray* _sectionTitleDictList;
    ArcosCreateRecordObject* _arcosCreateRecordObject;
    
    NSMutableArray* _sectionTitleList;
    NSMutableDictionary* _groupedDataDict;
    NSMutableDictionary* _originalGroupedDataDict;
    NSMutableArray* _dbFieldNameList;
    NSMutableArray* _attachmentFileNameList;
    NSMutableArray* _attachmentFileContentList;
    BOOL _isNewRecord;
    NSNumber* _iur;
    
    NSNumber* _mondayAmKey;
    NSNumber* _mondayPmKey;
    NSNumber* _tuesdayAmKey;
    NSNumber* _tuesdayPmKey;
    NSNumber* _wednesdayAmKey;
    NSNumber* _wednesdayPmKey;
    NSNumber* _thursdayAmKey;
    NSNumber* _thursdayPmKey;
    NSNumber* _fridayAmKey;
    NSNumber* _fridayPmKey;
    NSNumber* _saturdayAmKey;
    NSNumber* _saturdayPmKey;
    NSNumber* _sundayAmKey;
    NSNumber* _sundayPmKey;
    NSMutableArray* _daysOfWeekKeyList;
    ArcosDescriptionTrManager* _arcosDescriptionTrManager;
    NSMutableArray* _dayPartsDbFieldNameList;
    NSMutableDictionary* _dayPartsGroupedDataDict;
    NSMutableDictionary* _dayPartsOriginalGroupedDataDict;
    
    NSMutableArray* _fieldNameList;
    NSMutableArray* _fieldValueList;
    
    NSMutableArray* _dayPartsDictList;
    NSString* _dayPartsCode;
    NSString* _weekdayCode;
    NSString* _weekendCode;    
    NSString* _dayPartsTitle;
    
    NSMutableArray* _updatedFieldNameList;
    NSMutableArray* _updatedFieldValueList;
    
    NSMutableArray* _weekDayDescList;
    
    NSMutableArray* _dayPartsTagArrayList;
    
    NSMutableArray* _sortedWeekDayDescList;
    NSMutableArray* _sortedDayPartsTagArrayList;
}

@property(nonatomic, retain) NSNumber* employeeIUR;
@property(nonatomic, retain) NSString* employeeName;
@property(nonatomic, retain) NSNumber* dayOfWeekend;
@property(nonatomic, assign) int rowPointer;
@property(nonatomic, retain) NSMutableArray* employeeDetailList;
@property(nonatomic, retain) NSDictionary* employeeDict;
@property(nonatomic, retain) NSDate* currentWeekendDate;
@property(nonatomic, retain) NSDate* highestAllowedWeekendDate;
@property(nonatomic, retain) NSMutableArray* sectionTitleDictList;
@property(nonatomic, retain) ArcosCreateRecordObject* arcosCreateRecordObject;

@property(nonatomic, retain) NSMutableArray* sectionTitleList;
@property(nonatomic, retain) NSMutableDictionary* groupedDataDict;
@property(nonatomic, retain) NSMutableDictionary* originalGroupedDataDict;
@property(nonatomic, retain) NSMutableArray* dbFieldNameList;
@property(nonatomic, retain) NSMutableArray* attachmentFileNameList;
@property(nonatomic, retain) NSMutableArray* attachmentFileContentList;
@property(nonatomic, assign) BOOL isNewRecord;
@property(nonatomic, retain) NSNumber* iur;

@property(nonatomic, retain) NSNumber* mondayAmKey;
@property(nonatomic, retain) NSNumber* mondayPmKey;
@property(nonatomic, retain) NSNumber* tuesdayAmKey;
@property(nonatomic, retain) NSNumber* tuesdayPmKey;
@property(nonatomic, retain) NSNumber* wednesdayAmKey;
@property(nonatomic, retain) NSNumber* wednesdayPmKey;
@property(nonatomic, retain) NSNumber* thursdayAmKey;
@property(nonatomic, retain) NSNumber* thursdayPmKey;
@property(nonatomic, retain) NSNumber* fridayAmKey;
@property(nonatomic, retain) NSNumber* fridayPmKey;
@property(nonatomic, retain) NSNumber* saturdayAmKey;
@property(nonatomic, retain) NSNumber* saturdayPmKey;
@property(nonatomic, retain) NSNumber* sundayAmKey;
@property(nonatomic, retain) NSNumber* sundayPmKey;
@property(nonatomic, retain) NSMutableArray* daysOfWeekKeyList;
@property(nonatomic, retain) ArcosDescriptionTrManager* arcosDescriptionTrManager;
@property(nonatomic, retain) NSMutableArray* dayPartsDbFieldNameList;
@property(nonatomic, retain) NSMutableDictionary* dayPartsGroupedDataDict;
@property(nonatomic, retain) NSMutableDictionary* dayPartsOriginalGroupedDataDict;

@property(nonatomic, retain) NSMutableArray* fieldNameList;
@property(nonatomic, retain) NSMutableArray* fieldValueList;

@property(nonatomic, retain) NSMutableArray* dayPartsDictList;
@property(nonatomic, retain) NSString* dayPartsCode;
@property(nonatomic, retain) NSString* weekdayCode;
@property(nonatomic, retain) NSString* weekendCode;
@property(nonatomic, retain) NSString* dayPartsTitle;
@property(nonatomic, retain) NSMutableArray* updatedFieldNameList;
@property(nonatomic, retain) NSMutableArray* updatedFieldValueList;

@property(nonatomic, retain) NSMutableArray* weekDayDescList;

@property(nonatomic, retain) NSMutableArray* dayPartsTagArrayList;

@property(nonatomic, retain) NSMutableArray* sortedWeekDayDescList;
@property(nonatomic, retain) NSMutableArray* sortedDayPartsTagArrayList;

- (NSNumber*)getDayOfWeekend;
- (NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend;
- (NSMutableArray*)retrieveSectionTitleDictList;
- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)reinitiateAttachmentAuxiObject;
- (BOOL)checkValidation;
- (void)processRawData:(NSMutableArray*)aDataList;
- (void)createBasicData;
- (NSMutableDictionary*)createCompositeUnAssignedDescrDetailDict;
- (void)updateChangedData:(id)data withIndexPath:(NSIndexPath*)anIndexPath;
- (void)updateChangedData:(id)data withTag:(NSNumber*)aTagNumber;
- (void)prepareForCreateWeeklyRecord;
- (NSString*)retrieveDayPartsTitle;
- (NSMutableArray*)retrieveDayPartsDictList;
- (void)getChangedDataList;
- (void)assignDefaultDayPartsAfterBasicData;

@end
