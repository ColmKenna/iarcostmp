//
//  CustomerGroupDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 09/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupDataManager.h"
@interface CustomerGroupDataManager ()

@end

@implementation CustomerGroupDataManager
//@synthesize contactDisplayList = _contactDisplayList;
//@synthesize contactCurrentIndexPath = _contactCurrentIndexPath;
@synthesize displayList = _displayList;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize contactTypeDescrTypeCode = _contactTypeDescrTypeCode;
@synthesize masterLocationDescrTypeCode = _masterLocationDescrTypeCode;
@synthesize locationTypesDescrTypeCode = _locationTypesDescrTypeCode;
@synthesize accessTimesDescrTypeCode = _accessTimesDescrTypeCode;
@synthesize accessTimesTitle = _accessTimesTitle;
@synthesize hourMinuteNoColonFormat = _hourMinuteNoColonFormat;
@synthesize notSeenTitle = _notSeenTitle;
@synthesize notSeenDescrTypeCode = _notSeenDescrTypeCode;
@synthesize answeredNumber = _answeredNumber;
@synthesize notSeenDateKey = _notSeenDateKey;
@synthesize locationTypesTitle = _locationTypesTitle;
@synthesize wholesalerCodeTitle = _wholesalerCodeTitle;
@synthesize wholesalerCodeDescrTypeCode = _wholesalerCodeDescrTypeCode;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.contactTypeDescrTypeCode = @"CO";
        self.masterLocationDescrTypeCode = @"MasterLocation";
        self.locationTypesDescrTypeCode = @"LT";
        self.accessTimesDescrTypeCode = @"accessTimes";
        self.accessTimesTitle = @"Access Times";
        self.hourMinuteNoColonFormat = @"HHmm";
        self.notSeenTitle = @"Not Seen";
        self.notSeenDescrTypeCode = @"notSeen";
        self.answeredNumber = 999;
        self.notSeenDateKey = @"notSeenDate";
        self.locationTypesTitle = @"Location Types";
        self.wholesalerCodeTitle = @"Wholesaler Code";
        self.wholesalerCodeDescrTypeCode = @"wholesalerCode";
    }
    return self;
}

- (void)dealloc {
//    self.contactDisplayList = nil;
//    self.contactCurrentIndexPath = nil;
    self.displayList = nil;
    self.currentIndexPath = nil;
    self.contactTypeDescrTypeCode = nil;
    self.masterLocationDescrTypeCode = nil;
    self.locationTypesDescrTypeCode = nil;
    self.accessTimesDescrTypeCode = nil;
    self.accessTimesTitle = nil;
    self.hourMinuteNoColonFormat = nil;
    self.notSeenTitle = nil;
    self.notSeenDescrTypeCode = nil;
    self.notSeenDateKey = nil;
    self.locationTypesTitle = nil;
    self.wholesalerCodeTitle = nil;
    self.wholesalerCodeDescrTypeCode = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createInitialAnswer {
    NSArray* keys = [NSArray arrayWithObjects:@"Detail", @"DescrDetailIUR", @"Active", nil];
    NSArray* objs = [NSArray arrayWithObjects:[GlobalSharedClass shared].unassignedText, [NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
    return [NSMutableDictionary dictionaryWithObjects:objs forKeys:keys];
}


- (void)inputFinishedWithData:(id)aData indexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* tmpDataDict = [self.displayList objectAtIndex:anIndexPath.row];
    [tmpDataDict setObject:aData forKey:@"Answer"];
}

//- (void)resetContactDataList {
//    for (NSMutableDictionary* aContactDataDict in self.contactDisplayList) {
//        [aContactDataDict setObject:[self createInitialAnswer] forKey:@"Answer"];
//    }
//}

//- (NSMutableArray*)retrieveContactApplyPredicateList {
//    NSMutableArray* predicateList = [NSMutableArray array];
//    for (NSMutableDictionary* aContactDataDict in self.displayList) {
//        NSMutableDictionary* anAnswer = [aContactDataDict objectForKey:@"Answer"];
//        NSNumber* aDescrDetailIUR = [anAnswer objectForKey:@"DescrDetailIUR"];
//        if ([aDescrDetailIUR intValue] != 0) {
//            [predicateList addObject:[NSPredicate predicateWithFormat:@"%K = %@", [aContactDataDict objectForKey:@"FieldName"], aDescrDetailIUR]];
//        }
//    }
//    NSNumber* displayInactiveRecordFlag = [SettingManager DisplayInactiveRecord];
//    if (![displayInactiveRecordFlag boolValue]) {
//        [predicateList addObject:[NSPredicate predicateWithFormat:@"Active = 1"]];
//    }
//    return predicateList;
//}

- (NSMutableArray*)applyButtonPressed {
//    NSMutableArray* predicateList = [self retrieveContactApplyPredicateList];
//    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
//    NSMutableArray* contactLocationObjectList = [[ArcosCoreData sharedArcosCoreData] contactLocationWithPredicate:predicate];
//    [self sortContactLocationResultList:contactLocationObjectList];
//    return contactLocationObjectList;
    return nil;
}

- (void)sortContactLocationResultList:(NSMutableArray*)aResultList {
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Surname" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [aResultList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    NSMutableDictionary* currentContactLocationObject = nil;
    if ([aResultList count] > 1) {
        currentContactLocationObject = [aResultList objectAtIndex:0];
        for (int i = 1; i < [aResultList count]; i++) {
            NSMutableDictionary* nextContactLocationObject = [aResultList objectAtIndex:i];
            if ([[currentContactLocationObject objectForKey:@"ContactIUR"] isEqualToNumber:[nextContactLocationObject objectForKey:@"ContactIUR"]]) {
                [currentContactLocationObject setObject:[NSNumber numberWithInt:1] forKey:@"SameContactIUR"];
                [nextContactLocationObject setObject:[NSNumber numberWithInt:1] forKey:@"SameContactIUR"];
            } else {
                currentContactLocationObject = nextContactLocationObject;
            }
        }
    }
}

- (void)createDataList {
    
}

- (void)resetDataList {
    for (NSMutableDictionary* aDataDict in self.displayList) {
        [aDataDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    }
}

/*
 * CellType 4:Wholesaler Code 3:buying group 2:not seen 1:accessTimes 0:default type
 */
- (NSMutableDictionary*)createAccessTimesDict {
    NSMutableDictionary* resultAccessTimesDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [resultAccessTimesDict setObject:[NSNumber numberWithInt:1] forKey:@"CellType"];
    [resultAccessTimesDict setObject:self.accessTimesTitle forKey:@"Title"];
    [resultAccessTimesDict setObject:self.accessTimesTitle forKey:@"Details"];
    [resultAccessTimesDict setObject:self.accessTimesDescrTypeCode forKey:@"DescrTypeCode"];
    [resultAccessTimesDict setObject:@"accessTimes" forKey:@"FieldName"];
    [resultAccessTimesDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    return resultAccessTimesDict;
}

- (NSMutableDictionary*)processAccessTimesResult:(NSMutableDictionary *)aWeekDayDict startTime:(NSDate *)aStartTime endTime:(NSDate *)anEndTime {
    NSMutableDictionary* myAnswerDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [myAnswerDict setObject:[NSNumber numberWithInt:999] forKey:@"DescrDetailIUR"];
    [myAnswerDict setObject:[NSNumber numberWithInt:1] forKey:@"Active"];
    NSString* myDetail = [NSString stringWithFormat:@"%@ From %@ To %@", [aWeekDayDict objectForKey:@"Title"], [ArcosUtils stringFromDate:aStartTime format:[GlobalSharedClass shared].hourMinuteFormat], [ArcosUtils stringFromDate:anEndTime format:[GlobalSharedClass shared].hourMinuteFormat]];
    [myAnswerDict setObject:myDetail forKey:@"Detail"];
    [myAnswerDict setObject:aWeekDayDict forKey:@"WeekDay"];
    [myAnswerDict setObject:aStartTime forKey:@"StartTime"];
    [myAnswerDict setObject:anEndTime forKey:@"EndTime"];
    
    return myAnswerDict;
}

- (NSPredicate*)retrieveAccessTimesPredicateWithDict:(NSMutableDictionary *)anAccessTimeAnswerDict {
    NSMutableDictionary* myWeekDayDict = [anAccessTimeAnswerDict objectForKey:@"WeekDay"];
    NSDate* myStartTime = [anAccessTimeAnswerDict objectForKey:@"StartTime"];
    NSDate* myEndTime = [anAccessTimeAnswerDict objectForKey:@"EndTime"];
    NSTimeInterval myTimeInterval = [myEndTime timeIntervalSinceDate:myStartTime];
    int slotCount = myTimeInterval / 15 / 60;
    NSMutableArray* timeSlotList = [NSMutableArray arrayWithCapacity:slotCount];
    NSMutableArray* timeSlotPredicateList = [NSMutableArray arrayWithCapacity:slotCount];
    NSString* timePrefix = [NSString stringWithFormat:@"A%@", [myWeekDayDict objectForKey:@"FieldValue"]];
    [timeSlotList addObject:[NSString stringWithFormat:@"%@%@", timePrefix, [ArcosUtils stringFromDate:myStartTime format:self.hourMinuteNoColonFormat]]];
    for (int i = 1; i < slotCount; i++) {
        NSDate* tmpDate = [ArcosUtils addMinutes:i * 15 date:myStartTime];
        [timeSlotList addObject:[NSString stringWithFormat:@"%@%@", timePrefix, [ArcosUtils stringFromDate:tmpDate format:self.hourMinuteNoColonFormat]]];
    }
    for (NSString* aTimeSlot in timeSlotList) {
        [timeSlotPredicateList addObject:[NSPredicate predicateWithFormat:@"accessTimes CONTAINS[c] %@", aTimeSlot]];
    }
    
    return [NSCompoundPredicate orPredicateWithSubpredicates:timeSlotPredicateList];
}

- (NSMutableDictionary*)createNotSeenDict {
    NSMutableDictionary* resultAccessTimesDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [resultAccessTimesDict setObject:[NSNumber numberWithInt:2] forKey:@"CellType"];
    [resultAccessTimesDict setObject:self.notSeenTitle forKey:@"Title"];
    [resultAccessTimesDict setObject:self.notSeenTitle forKey:@"Details"];
    [resultAccessTimesDict setObject:self.notSeenDescrTypeCode forKey:@"DescrTypeCode"];
//    [resultAccessTimesDict setObject:@"accessTimes" forKey:@"FieldName"];
    [resultAccessTimesDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    return resultAccessTimesDict;    
}

- (NSMutableDictionary*)processNotSeenResult:(id)aData {
    NSMutableDictionary* myAnswerDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [myAnswerDict setObject:[NSNumber numberWithInt:self.answeredNumber] forKey:@"DescrDetailIUR"];    
    [myAnswerDict setObject:[ArcosUtils stringFromDate:aData format:[GlobalSharedClass shared].dateFormat] forKey:@"Detail"];
    [myAnswerDict setObject:aData forKey:self.notSeenDateKey];
    
    return myAnswerDict;
}

- (NSMutableDictionary*)processWholesalerCodeResult:(NSString*)aData {
    NSMutableDictionary* myAnswerDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [myAnswerDict setObject:[NSNumber numberWithInt:self.answeredNumber] forKey:@"DescrDetailIUR"];
    [myAnswerDict setObject:[ArcosUtils convertNilToEmpty:aData] forKey:@"Detail"];
    
    return myAnswerDict;
}

- (NSMutableDictionary*)retrieveCellDataWithDescrTypeCode:(NSString*)aDescrTypeCode {
    NSMutableDictionary* resultCellData = nil;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpResultCellData = [self.displayList objectAtIndex:i];
        if ([aDescrTypeCode isEqualToString:[tmpResultCellData objectForKey:@"DescrTypeCode"]]) {
            resultCellData = tmpResultCellData;
            break;
        }
    }
    return resultCellData;
}

- (NSMutableArray*)filterWithNotSeenCondition:(NSMutableDictionary*)aNotSeenDataDict resultList:(NSMutableArray*)aResultList fieldName:(NSString*)aFieldName {
    NSMutableDictionary* answerDict = [aNotSeenDataDict objectForKey:@"Answer"];
    if ([[answerDict objectForKey:@"DescrDetailIUR"] intValue] != self.answeredNumber) return aResultList;
    if ([aResultList count] == 0) return aResultList;
    NSDate* notSeenDefinedDate = [answerDict objectForKey:self.notSeenDateKey];
    notSeenDefinedDate = [ArcosUtils beginOfDay:notSeenDefinedDate];
    NSMutableArray* entityIURList = [NSMutableArray arrayWithCapacity:[aResultList count]];
    for (int i = 0; i < [aResultList count]; i++) {
        NSDictionary* entityDict = [aResultList objectAtIndex:i];
        [entityIURList addObject:[entityDict objectForKey:aFieldName]];
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K in %@ AND EnteredDate >= %@ ", aFieldName, entityIURList, notSeenDefinedDate];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* entityIUROrderHeaderHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectList count]];
    for (int i = 0; i < [objectList count]; i++) {
        NSDictionary* auxOrderHeaderDict = [objectList objectAtIndex:i];
        NSNumber* auxEntityIUR = [auxOrderHeaderDict objectForKey:aFieldName];
        [entityIUROrderHeaderHashMap setObject:auxEntityIUR forKey:auxEntityIUR];
    }
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[aResultList count]] - 1; i >= 0; i--) {
        NSDictionary* auxEntityDict = [aResultList objectAtIndex:i];
        NSNumber* auxEntityIUR = [auxEntityDict objectForKey:aFieldName];
        if ([entityIUROrderHeaderHashMap objectForKey:auxEntityIUR] != nil) {
            [aResultList removeObjectAtIndex:i];
        }
    }    
    return aResultList;
}

- (void)filterWithWholesalerCodeCondition:(NSMutableDictionary*)aWholesalerCodeDict resultList:(NSMutableArray*)aResultList {
    NSMutableDictionary* answerDict = [aWholesalerCodeDict objectForKey:@"Answer"];
    if ([[answerDict objectForKey:@"DescrDetailIUR"] intValue] != self.answeredNumber) return;
    if ([aResultList count] == 0) return;
    NSString* auxWholesalerCode = [answerDict objectForKey:@"Detail"];
    if ([auxWholesalerCode isEqualToString:@""]) return;
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[aResultList count]];
    for (int i = 0; i < [aResultList count]; i++) {
        NSDictionary* auxLocationDict = [aResultList objectAtIndex:i];
        [locationIURList addObject:[auxLocationDict objectForKey:@"LocationIUR"]];
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@ and CustomerCode CONTAINS[c] %@", locationIURList, auxWholesalerCode];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    NSMutableDictionary* resultLocationIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[objectList count]];
    for (int i = 0; i < [objectList count]; i++) {
        NSDictionary* auxLocLocLinkDict = [objectList objectAtIndex:i];
        NSNumber* auxLocationIUR = [auxLocLocLinkDict objectForKey:@"LocationIUR"];
        [resultLocationIURHashMap setObject:auxLocationIUR forKey:auxLocationIUR];
    }
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[aResultList count]] - 1; i >= 0; i--) {
        NSDictionary* auxEntityDict = [aResultList objectAtIndex:i];
        NSNumber* auxLocationIUR = [auxEntityDict objectForKey:@"LocationIUR"];
        if ([resultLocationIURHashMap objectForKey:auxLocationIUR] == nil) {
            [aResultList removeObjectAtIndex:i];
        }
    }
}

- (NSMutableDictionary*)processBuyingGroupResult:(NSMutableDictionary*)aResultDict {
    NSMutableDictionary* auxAnswerDict = [NSMutableDictionary dictionaryWithDictionary:aResultDict];
    [auxAnswerDict setObject:[NSNumber numberWithInt:self.answeredNumber] forKey:@"DescrDetailIUR"];
    [auxAnswerDict setObject:[ArcosUtils convertNilToEmpty:[aResultDict objectForKey:@"Name"]] forKey:@"Detail"];
    return auxAnswerDict;
}

- (NSMutableDictionary*)createLocationTypesDict {
    NSMutableDictionary* resultLocationTypesDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [resultLocationTypesDict setObject:[NSNumber numberWithInt:0] forKey:@"CellType"];
    [resultLocationTypesDict setObject:self.locationTypesTitle forKey:@"Title"];
    [resultLocationTypesDict setObject:self.locationTypesTitle forKey:@"Details"];
    [resultLocationTypesDict setObject:self.locationTypesDescrTypeCode forKey:@"DescrTypeCode"];
    [resultLocationTypesDict setObject:@"LTiur" forKey:@"FieldName"];
    [resultLocationTypesDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    return resultLocationTypesDict;
}

- (NSMutableDictionary*)createWholesalerCodeDict {
    NSMutableDictionary* resultWholesalerCodeDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [resultWholesalerCodeDict setObject:[NSNumber numberWithInt:4] forKey:@"CellType"];
    [resultWholesalerCodeDict setObject:self.wholesalerCodeTitle forKey:@"Title"];
    [resultWholesalerCodeDict setObject:self.wholesalerCodeTitle forKey:@"Details"];
    [resultWholesalerCodeDict setObject:self.wholesalerCodeDescrTypeCode forKey:@"DescrTypeCode"];
    [resultWholesalerCodeDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    return resultWholesalerCodeDict;
}

@end
