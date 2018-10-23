//
//  CustomerInfoAccessTimesCalendarDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "ArcosCoreData.h"
#import "CustomerInfoAccessTimesCalendarLocationDataManager.h"
#import "CustomerInfoAccessTimesCalendarContactDataManager.h"

@interface CustomerInfoAccessTimesCalendarDataManager : NSObject {
    NSMutableDictionary* _groupDataDict;
    NSMutableArray* _sectionList;
    NSDate* _beginDate;
    NSDate* _endDate;
    NSMutableDictionary* _recordDataDict;
    int _gridCount;
    NSString* _availableCode;
    NSString* _blockCode;
    NSString* _tableName;
    NSString* _locationTableName;
    NSString* _contactTableName;
    NSString* _iURName;
    CustomerInfoAccessTimesCalendarBaseDataManager* _baseDataManager;
}

@property(nonatomic, retain) NSMutableDictionary* groupDataDict;
@property(nonatomic, retain) NSMutableArray* sectionList;
@property(nonatomic, retain) NSDate* beginDate;
@property(nonatomic, retain) NSDate* endDate;
@property(nonatomic, retain) NSMutableDictionary* recordDataDict;
@property(nonatomic, assign) int gridCount;
@property(nonatomic, retain) NSString* availableCode;
@property(nonatomic, retain) NSString* blockCode;
@property(nonatomic, retain) NSString* tableName;
@property(nonatomic, retain) NSString* locationTableName;
@property(nonatomic, retain) NSString* contactTableName;
@property(nonatomic, retain) NSString* iURName;
@property(nonatomic, retain) CustomerInfoAccessTimesCalendarBaseDataManager* baseDataManager;

- (void)updateInputWithIndexPath:(NSIndexPath *)anIndexPath labelIndex:(int)aLabelIndex colorType:(NSNumber *)aColorType;
- (void)processRawDataWithAccessTimes:(NSString*)anAccessTimes code:(NSString*)aCode;
- (NSString*)saveButtonPressed;
//- (void)updateResultWithNumber:(NSNumber*)aNumber;
//- (void)saveAccessTimesToDB:(NSString*)anAccessTimes;


@end
