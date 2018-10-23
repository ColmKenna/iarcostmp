//
//  CustomerInfoAccessTimesCalendarDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarDataManager.h"
@interface CustomerInfoAccessTimesCalendarDataManager()

- (NSDate*)configDateWithHour:(int)aHourQty date:(NSDate*)aDate;
- (NSMutableDictionary*)createAccessTimesCalendarDict:(NSDate*)aDate;
- (void)createBasicData;

@end

@implementation CustomerInfoAccessTimesCalendarDataManager
@synthesize groupDataDict = _groupDataDict;
@synthesize sectionList = _sectionList;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;
@synthesize recordDataDict = _recordDataDict;
@synthesize gridCount = _gridCount;
@synthesize availableCode = _availableCode;
@synthesize blockCode = _blockCode;
@synthesize tableName = _tableName;
@synthesize locationTableName = _locationTableName;
@synthesize contactTableName = _contactTableName;
@synthesize iURName = _iURName;
@synthesize baseDataManager = _baseDataManager;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.gridCount = 7;
        self.availableCode = @"A";
        self.blockCode = @"B";
        self.locationTableName = @"Location";
        self.contactTableName = @"Contact";
        NSDate* myDate = [NSDate date];
        self.beginDate = [self configDateWithHour:8 date:myDate];
        self.endDate = [self configDateWithHour:20 date:myDate];
        
        [self createBasicData];
    }
    return self;
}

- (void)createBasicData {
    self.sectionList = [NSMutableArray array];
    self.groupDataDict = [NSMutableDictionary dictionary];
    NSDate* auxStartDate = self.beginDate;
    [self.sectionList addObject:[self createAccessTimesCalendarDict:auxStartDate]];
    while ([auxStartDate compare:self.endDate] == NSOrderedAscending) {
        auxStartDate = [ArcosUtils addMinutes:15 date:auxStartDate];
        [self.sectionList addObject:[self createAccessTimesCalendarDict:auxStartDate]];
    }
    for (int i = 0; i < [self.sectionList count]; i++) {
        NSMutableDictionary* calendarDict = [self.sectionList objectAtIndex:i];
        NSMutableArray* auxDisplayList = [NSMutableArray arrayWithCapacity:self.gridCount];
        for (int j = 0; j < self.gridCount; j++) {
            [auxDisplayList addObject:[NSNumber numberWithInt:0]];
        }
        [self.groupDataDict setObject:auxDisplayList forKey:[calendarDict objectForKey:@"AccessTime"]];
    }
//    NSLog(@"groupDataDict: %@", self.groupDataDict);
}

- (void)dealloc {
    self.groupDataDict = nil;
    self.sectionList = nil;
    self.beginDate = nil;
    self.endDate = nil;
    self.recordDataDict = nil;
    self.tableName = nil;
    self.locationTableName = nil;
    self.contactTableName = nil;
    self.iURName = nil;
    self.baseDataManager = nil;
    
    [super dealloc];
}

- (NSDate*)configDateWithHour:(int)aHourQty date:(NSDate*)aDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents* dateComponents = [gregorian components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:aDate];
    [dateComponents setHour:aHourQty];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    [dateComponents setNanosecond:0];
    return [gregorian dateFromComponents:dateComponents];
}

- (NSMutableDictionary*)createAccessTimesCalendarDict:(NSDate*)aDate {
    NSMutableDictionary* tmpCalendarDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [tmpCalendarDict setObject:aDate forKey:@"Date"];
    [tmpCalendarDict setObject:[ArcosUtils stringFromDate:aDate format:[GlobalSharedClass shared].hourMinuteFormat] forKey:@"Time"];
    [tmpCalendarDict setObject:[ArcosUtils stringFromDate:aDate format:@"HHmm"] forKey:@"AccessTime"];
    
    return tmpCalendarDict;
}

- (void)updateInputWithIndexPath:(NSIndexPath *)anIndexPath labelIndex:(int)aLabelIndex colorType:(NSNumber *)aColorType {
    NSMutableDictionary* sectionData = [self.sectionList objectAtIndex:anIndexPath.row];
    NSMutableArray* auxDisplayList = [self.groupDataDict objectForKey:[sectionData objectForKey:@"AccessTime"]];
    [auxDisplayList replaceObjectAtIndex:aLabelIndex withObject:aColorType];
}

- (void)processRawDataWithAccessTimes:(NSString*)anAccessTimes code:(NSString*)aCode {
    self.tableName = aCode;
    if ([aCode isEqualToString:self.locationTableName]) {
        self.iURName = @"LocationIUR";
        self.baseDataManager = [[[CustomerInfoAccessTimesCalendarLocationDataManager alloc] init] autorelease];
    }
    if ([aCode isEqualToString:self.contactTableName]) {
        self.iURName = @"IUR";
        self.baseDataManager = [[[CustomerInfoAccessTimesCalendarContactDataManager alloc] init] autorelease];
    }
    int length = [ArcosUtils convertNSUIntegerToUnsignedInt:[anAccessTimes length]];
    int myIndex = 0;
    int mySpan = 6;
    @try {
        while ((myIndex + mySpan) <= length) {
            NSString* accessTimeUnit = [anAccessTimes substringWithRange:NSMakeRange(myIndex, mySpan)];
            NSString* codeTypeChar = [[accessTimeUnit substringWithRange:NSMakeRange(0, 1)] uppercaseString];
            NSString* weekDayChar = [accessTimeUnit substringWithRange:NSMakeRange(1, 1)];
            NSString* accessTimeString = [accessTimeUnit substringFromIndex:2];
            myIndex = myIndex + mySpan;
            NSMutableArray* tmpDisplayList = [self.groupDataDict objectForKey:accessTimeString];
            NSNumber* codeTypeNumber = [NSNumber numberWithInt:0];
            if ([codeTypeChar isEqualToString:self.availableCode]) {
                codeTypeNumber = [NSNumber numberWithInt:1];
            }
            if ([codeTypeChar isEqualToString:self.blockCode]) {
                codeTypeNumber = [NSNumber numberWithInt:2];
            }
            int weekDayInteger = [[ArcosUtils convertStringToNumber:weekDayChar] intValue];
            if (weekDayInteger >= 0 && weekDayInteger <= 6) {
                [tmpDisplayList replaceObjectAtIndex:weekDayInteger withObject:codeTypeNumber];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    } @finally {
        
    }
}

- (NSString*)saveButtonPressed {
    NSMutableArray* accessTimesList = [NSMutableArray array];
    for (int i = 0; i < self.gridCount; i++) {
        for (int j = 0; j < [self.sectionList count]; j++) {
            NSMutableDictionary* auxSectionData = [self.sectionList objectAtIndex:j];
            NSString* auxAccessTime = [auxSectionData objectForKey:@"AccessTime"];
            NSMutableArray* codeTypeNumberList = [self.groupDataDict objectForKey:auxAccessTime];
            NSNumber* codeTypeNumber = [codeTypeNumberList objectAtIndex:i];
            NSString* accessCode = @"";
            switch ([codeTypeNumber intValue]) {
                case 1: {
                    accessCode = self.availableCode;
                }
                    break;
                case 2: {
                    accessCode = self.blockCode;
                }
                    break;
                    
                default:
                    break;
            }
            if (![accessCode isEqualToString:@""]) {
                [accessTimesList addObject:[NSString stringWithFormat:@"%@%d%@", accessCode, i, auxAccessTime]];
            }
        }
    }
    NSString* auxAccessTimes = [accessTimesList componentsJoinedByString:@""];
    
    return auxAccessTimes;
}

//- (void)saveAccessTimesToDB:(NSString*)anAccessTimes iur:(NSNumber *)anIUR {
//    [self.baseDataManager saveAccessTimesToDB:anAccessTimes iur:anIUR];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [[self.locationDict objectForKey:@"LocationIUR"] intValue]];
//    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    if ([objectList count] > 0) {
//        Location* auxLocation = [objectList objectAtIndex:0];
//        auxLocation.accessTimes = anAccessTimes;
//        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
//    }
//}

//- (void)updateResultWithNumber:(NSNumber*)aNumber iur:(NSNumber *)anIUR {
//    [self.baseDataManager updateResultWithNumber:aNumber iur:anIUR];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [[self.locationDict objectForKey:@"LocationIUR"] intValue]];
//    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
//    if ([objectList count] > 0) {
//        Location* auxLocation = [objectList objectAtIndex:0];
//        auxLocation.Competitor2 = aNumber;
//        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
//    }
//}

@end
