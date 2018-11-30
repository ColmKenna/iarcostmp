//
//  MeetingBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingCellKeyDefinition.h"

@interface MeetingBaseDataManager : NSObject {
    MeetingCellKeyDefinition* _meetingCellKeyDefinition;
    NSMutableDictionary* _headOfficeDataObjectDict;
}

@property(nonatomic, retain) MeetingCellKeyDefinition* meetingCellKeyDefinition;
@property(nonatomic, retain) NSMutableDictionary* headOfficeDataObjectDict;

- (void)createBasicData;
- (NSMutableDictionary*)createDefaultIURDict;
- (NSMutableDictionary*)createDefaultEmployeeDict;
- (NSMutableDictionary*)createStringCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createLocationCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createEmployeeCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createTextViewCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (NSMutableDictionary*)createIURCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData descrTypeCode:(NSString*)aDescrTypeCode;
- (NSMutableDictionary*)createBooleanCellWithFieldName:(NSString*)aFieldName cellKey:(NSString*)aCellKey fieldData:(id)aFieldData;
- (void)dataMeetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)displayListHeadOfficeAdaptor;

@end

