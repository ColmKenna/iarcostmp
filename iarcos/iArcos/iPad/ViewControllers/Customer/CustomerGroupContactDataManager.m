//
//  CustomerGroupContactDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 12/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupContactDataManager.h"
@interface CustomerGroupContactDataManager()
- (NSMutableDictionary*)createContactTypeDict;
- (NSMutableArray*)retrieveContactProfileList;
- (NSMutableArray*)retrieveContactApplyPredicateList;
@end

@implementation CustomerGroupContactDataManager

- (NSMutableDictionary*)createContactTypeDict {
    NSMutableDictionary* resultContactTypeDict = [NSMutableDictionary dictionary];
    [resultContactTypeDict setObject:[NSNumber numberWithInt:0] forKey:@"CellType"];
    NSDictionary* contactTypeDict = [[ArcosCoreData sharedArcosCoreData] descrTypeAllRecordsWithTypeCode:@"CO"];
    if (contactTypeDict != nil) {
        resultContactTypeDict = [NSMutableDictionary dictionaryWithDictionary:contactTypeDict];
        [resultContactTypeDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[resultContactTypeDict objectForKey:@"Details"]]] forKey:@"Title"];
    } else {
        [resultContactTypeDict setObject:@"Contact Types" forKey:@"Title"];
        [resultContactTypeDict setObject:@"Contact Types" forKey:@"Details"];
        [resultContactTypeDict setObject:@"CO" forKey:@"DescrTypeCode"];
    }
    [resultContactTypeDict setObject:@"COiur" forKey:@"FieldName"];
    [resultContactTypeDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    
    return resultContactTypeDict;
}

- (NSMutableArray*)retrieveContactProfileList {
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode in %@ AND Active = 1", descrTypeCodeList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Details", nil];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSMutableArray* contactProfileList = [[[NSMutableArray alloc] initWithCapacity:[objectList count]] autorelease];
    for (int i = 0; i < [objectList count]; i++) {
        NSMutableDictionary* auxDict = [NSMutableDictionary dictionaryWithDictionary:[objectList objectAtIndex:i]];
        [auxDict setObject:[NSNumber numberWithInt:0] forKey:@"CellType"];
        [auxDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[auxDict objectForKey:@"Details"]]] forKey:@"Title"];
        [auxDict setObject:[NSString stringWithFormat:@"cP%@", [auxDict objectForKey:@"DescrTypeCode"]] forKey:@"FieldName"];
        [auxDict setObject:[self createInitialAnswer] forKey:@"Answer"];
        [contactProfileList addObject:auxDict];
    }
    
    return contactProfileList;
}

- (void)createDataList {
    NSMutableDictionary* tmpContactTypeDict = [self createContactTypeDict];
    NSMutableDictionary* tmpLocationTypesDict = [self createLocationTypesDict];
    NSMutableArray* contactProfileList = [self retrieveContactProfileList];
    NSMutableDictionary* tmpAccessTimesDict = [self createAccessTimesDict];
    NSMutableDictionary* tmpNotSeenDict = [self createNotSeenDict];
    self.displayList = [NSMutableArray arrayWithCapacity:([contactProfileList count] + 4)];
    [self.displayList addObject:tmpContactTypeDict];
    [self.displayList addObject:tmpLocationTypesDict];
    [self.displayList addObjectsFromArray:contactProfileList];
    [self.displayList addObject:tmpAccessTimesDict];
    [self.displayList addObject:tmpNotSeenDict];
}

- (NSMutableArray*)applyButtonPressed {
    NSMutableArray* predicateList = [self retrieveContactApplyPredicateList];
    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    NSMutableArray* contactLocationObjectList = [[ArcosCoreData sharedArcosCoreData] contactLocationWithPredicate:predicate];
    [self sortContactLocationResultList:contactLocationObjectList];
    NSMutableDictionary* notSeenDataDict = [self retrieveCellDataWithDescrTypeCode:self.notSeenDescrTypeCode];
    [self filterWithNotSeenCondition:notSeenDataDict resultList:contactLocationObjectList fieldName:@"ContactIUR"];
    NSMutableDictionary* locationTypesDataDict = [self retrieveCellDataWithDescrTypeCode:self.locationTypesDescrTypeCode];
    [self filterWithLocationTypeCondition:locationTypesDataDict resultList:contactLocationObjectList];
    return contactLocationObjectList;
}

- (NSMutableArray*)retrieveContactApplyPredicateList {
    NSMutableArray* predicateList = [NSMutableArray array];
    for (NSMutableDictionary* aContactDataDict in self.displayList) {
        NSMutableDictionary* anAnswer = [aContactDataDict objectForKey:@"Answer"];
        NSNumber* aDescrDetailIUR = [anAnswer objectForKey:@"DescrDetailIUR"];
        if ([aDescrDetailIUR intValue] != 0) {
            if ([[aContactDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.locationTypesDescrTypeCode]) {
                continue;
            }
            if ([[aContactDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.accessTimesDescrTypeCode]) {
                [predicateList addObject:[self retrieveAccessTimesPredicateWithDict:anAnswer]];
                continue;
            }
            if ([[aContactDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.notSeenDescrTypeCode]) {
                continue;
            }
            [predicateList addObject:[NSPredicate predicateWithFormat:@"%K = %@", [aContactDataDict objectForKey:@"FieldName"], aDescrDetailIUR]];
        }
    }
    NSNumber* displayInactiveRecordFlag = [SettingManager DisplayInactiveRecord];
    if (![displayInactiveRecordFlag boolValue]) {
        [predicateList addObject:[NSPredicate predicateWithFormat:@"Active = 1"]];
    }
    return predicateList;
}

- (NSMutableArray*)filterWithLocationTypeCondition:(NSMutableDictionary*)aLocationTypeDataDict resultList:(NSMutableArray*)aResultList {
    NSMutableDictionary* anAnswer = [aLocationTypeDataDict objectForKey:@"Answer"];
    NSNumber* aDescrDetailIUR = [anAnswer objectForKey:@"DescrDetailIUR"];
    if ([aDescrDetailIUR intValue] == 0) return aResultList;
    for (int i = [ArcosUtils convertNSUIntegerToUnsignedInt:[aResultList count]] - 1; i >= 0; i--) {
        NSDictionary* auxEntityDict = [aResultList objectAtIndex:i];
        NSNumber* auxLTiur = [auxEntityDict objectForKey:@"LTiur"];
        if ([auxLTiur intValue] != [aDescrDetailIUR intValue]) {
            [aResultList removeObjectAtIndex:i];
        }
    }
    return aResultList;
}

@end
