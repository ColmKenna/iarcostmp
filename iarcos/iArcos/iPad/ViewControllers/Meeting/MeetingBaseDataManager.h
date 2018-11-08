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
- (NSMutableDictionary*)createStringCellWithFieldName:(NSString*)aFieldName;
- (NSMutableDictionary*)createLocationCellWithFieldName:(NSString*)aFieldName;
- (NSMutableDictionary*)createEmployeeCellWithFieldName:(NSString*)aFieldName;
- (NSMutableDictionary*)createTextViewCellWithFieldName:(NSString*)aFieldName;
- (NSMutableDictionary*)createIURCellWithFieldName:(NSString*)aFieldName;

@end

