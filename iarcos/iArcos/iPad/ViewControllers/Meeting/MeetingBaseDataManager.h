//
//  MeetingBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingCellKeyDefinition.h"
#import "ArcosMeetingBO.h"
#import "ArcosUtils.h"
#import "ArcosMeetingWithDetails.h"
#import "ArcosMeetingWithDetailsDownload.h"
#import "ArcosMeetingWithDetailsUpload.h"

@interface MeetingBaseDataManager : NSObject {
    MeetingCellKeyDefinition* _meetingCellKeyDefinition;
    NSMutableDictionary* _headOfficeDataObjectDict;
}

@property(nonatomic, retain) MeetingCellKeyDefinition* meetingCellKeyDefinition;
@property(nonatomic, retain) NSMutableDictionary* headOfficeDataObjectDict;

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload;
- (NSMutableDictionary*)createDefaultIURDict;
- (NSMutableDictionary*)createDefaultIURDictWithIUR:(NSNumber*)anIUR title:(NSString*)aTitle;
- (NSMutableDictionary*)createDefaultEmployeeDict;
- (NSMutableDictionary*)createDefaultEmployeeDictWithIUR:(NSNumber*)anIUR title:(NSString*)aTitle;
- (NSMutableDictionary*)createStringCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createLocationCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createEmployeeCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createTextViewCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createIURCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData descrTypeCode:(NSString*)aDescrTypeCode;
- (NSMutableDictionary*)createBooleanCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)displayListHeadOfficeAdaptor;
- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload;

@end

