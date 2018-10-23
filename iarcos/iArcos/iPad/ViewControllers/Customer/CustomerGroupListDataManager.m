//
//  CustomerGroupListDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 12/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerGroupListDataManager.h"
@interface CustomerGroupListDataManager()

- (NSMutableDictionary*)createMasterLocationDict;
- (NSMutableDictionary*)createLocationTypesDict;
- (NSMutableArray*)retrieveLocationProfileList;
- (NSMutableArray*)retrieveLocationApplyPredicateList;

@end

@implementation CustomerGroupListDataManager
@synthesize masterLocationTitle = _masterLocationTitle;
@synthesize locationTypesTitle = _locationTypesTitle;
@synthesize buyingGroupTitle = _buyingGroupTitle;
@synthesize buyingGroupDescrTypeCode = _buyingGroupDescrTypeCode;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.masterLocationTitle = @"Master Location";
        self.locationTypesTitle = @"Location Types";
        self.buyingGroupTitle = @"Buying Group";
        self.buyingGroupDescrTypeCode = @"buyingGroup";
    }
    return self;
}

- (void)dealloc {
    self.masterLocationTitle = nil;
    self.locationTypesTitle = nil;
    self.buyingGroupTitle = nil;
    self.buyingGroupDescrTypeCode = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createMasterLocationDict {
    NSMutableDictionary* resultMasterLocationDict = [NSMutableDictionary dictionaryWithCapacity:6];
    [resultMasterLocationDict setObject:[NSNumber numberWithInt:0] forKey:@"CellType"];
    [resultMasterLocationDict setObject:self.masterLocationTitle forKey:@"Title"];
    [resultMasterLocationDict setObject:self.masterLocationTitle forKey:@"Details"];
    [resultMasterLocationDict setObject:self.masterLocationDescrTypeCode forKey:@"DescrTypeCode"];
    [resultMasterLocationDict setObject:@"MasterLocationIUR" forKey:@"FieldName"];
    [resultMasterLocationDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    return resultMasterLocationDict;
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

- (NSMutableArray*)retrieveLocationProfileList {
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithObjects:@"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode in %@ AND Active = 1", descrTypeCodeList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Details", nil];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrType" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    NSMutableArray* locationProfileList = [[[NSMutableArray alloc] initWithCapacity:[objectList count]] autorelease];
    for (int i = 0; i < [objectList count]; i++) {
        NSMutableDictionary* auxDict = [NSMutableDictionary dictionaryWithDictionary:[objectList objectAtIndex:i]];
        [auxDict setObject:[NSNumber numberWithInt:0] forKey:@"CellType"];
        [auxDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[auxDict objectForKey:@"Details"]]] forKey:@"Title"];
        NSString* auxDescrTypeCode = [auxDict objectForKey:@"DescrTypeCode"];
        NSNumber* auxDescrTypeCodeNumber = [ArcosUtils convertStringToNumber:auxDescrTypeCode];
        int auxDescrTypeCodeInt = [auxDescrTypeCodeNumber intValue] - 20;
        NSString* resultDescrTypeCode = (auxDescrTypeCodeInt < 10) ? [NSString stringWithFormat:@"0%d", auxDescrTypeCodeInt] : [NSString stringWithFormat:@"%d", auxDescrTypeCodeInt];
        [auxDict setObject:[NSString stringWithFormat:@"lP%@", resultDescrTypeCode] forKey:@"FieldName"];
        [auxDict setObject:[self createInitialAnswer] forKey:@"Answer"];
        [locationProfileList addObject:auxDict];
    }
    
    return locationProfileList;
}

- (void)createDataList {
    NSMutableDictionary* tmpMasterLocationDict = [self createMasterLocationDict];
    NSMutableDictionary* tmpLocationTypesDict = [self createLocationTypesDict];
    NSMutableArray* locationProfileList = [self retrieveLocationProfileList];
    NSMutableDictionary* tmpAccessTimesDict = [self createAccessTimesDict];
    NSMutableDictionary* tmpNotSeenDict = [self createNotSeenDict];
    NSMutableDictionary* tmpBuyingGroupDict = [self createBuyingGroupDict];
    self.displayList = [NSMutableArray arrayWithCapacity:([locationProfileList count] + 4)];
    [self.displayList addObject:tmpMasterLocationDict];
    [self.displayList addObject:tmpLocationTypesDict];
    [self.displayList addObjectsFromArray:locationProfileList];
    [self.displayList addObject:tmpAccessTimesDict];
    [self.displayList addObject:tmpBuyingGroupDict];
    [self.displayList addObject:tmpNotSeenDict];
}

- (NSMutableArray*)applyButtonPressed {
    NSMutableArray* predicateList = [self retrieveLocationApplyPredicateList];
    NSPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateList];
    NSMutableArray* resultList = [[ArcosCoreData sharedArcosCoreData] retrieveLocationWithPredicate:predicate];
    NSMutableDictionary* notSeenDataDict = [self retrieveCellDataWithDescrTypeCode:self.notSeenDescrTypeCode];
    [self filterWithNotSeenCondition:notSeenDataDict resultList:resultList fieldName:@"LocationIUR"];
    NSMutableDictionary* buyingGroupDataDict = [self retrieveCellDataWithDescrTypeCode:self.buyingGroupDescrTypeCode];
    [self filterWithBuyingGroupCondition:buyingGroupDataDict resultList:resultList];
    return resultList;
}

- (void)filterWithBuyingGroupCondition:(NSMutableDictionary*)aBuyingGroupDict resultList:(NSMutableArray*)aResultList {
    NSMutableDictionary* answerDict = [aBuyingGroupDict objectForKey:@"Answer"];
    if ([[answerDict objectForKey:@"DescrDetailIUR"] intValue] != self.answeredNumber) return;
    NSNumber* auxFromLocationIUR = [answerDict objectForKey:@"LocationIUR"];
    NSMutableArray* locLocLinkDictList = [self retrieveLocLocLinkWithFromLocationIUR:auxFromLocationIUR];
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[locLocLinkDictList count]];
    for (int i = 0; i < [locLocLinkDictList count]; i++) {
        NSDictionary* auxLocLocLinkDict = [locLocLinkDictList objectAtIndex:i];
        [locationIURList addObject:[auxLocLocLinkDict objectForKey:@"LocationIUR"]];
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@", locationIURList];
    [aResultList filterUsingPredicate:predicate];
}

- (NSMutableArray*)retrieveLocationApplyPredicateList {
    NSMutableArray* predicateList = [NSMutableArray array];
    for (NSMutableDictionary* aLocationDataDict in self.displayList) {
        NSMutableDictionary* anAnswer = [aLocationDataDict objectForKey:@"Answer"];
        NSNumber* aDescrDetailIUR = [anAnswer objectForKey:@"DescrDetailIUR"];
        if ([aDescrDetailIUR intValue] != 0) {
            if ([[aLocationDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.accessTimesDescrTypeCode]) {
                [predicateList addObject:[self retrieveAccessTimesPredicateWithDict:anAnswer]];
                continue;
            }
            if ([[aLocationDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.notSeenDescrTypeCode]) {
                continue;
            }
            if ([[aLocationDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.buyingGroupDescrTypeCode]) {
                continue;
            }
            if ([aDescrDetailIUR intValue] == -1 && [[aLocationDataDict objectForKey:@"DescrTypeCode"] isEqualToString:self.masterLocationDescrTypeCode]) {
                aDescrDetailIUR = [NSNumber numberWithInt:0];//independent group
            }
            [predicateList addObject:[NSPredicate predicateWithFormat:@"%K = %@", [aLocationDataDict objectForKey:@"FieldName"], aDescrDetailIUR]];
        }
    }
    NSNumber* displayInactiveRecordFlag = [SettingManager DisplayInactiveRecord];
    if (![displayInactiveRecordFlag boolValue]) {
        [predicateList addObject:[NSPredicate predicateWithFormat:@"Active = 1"]];
    }
    return predicateList;
}

- (NSMutableDictionary*)createBuyingGroupDict {
    NSMutableDictionary* resultBuyingGroupDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [resultBuyingGroupDict setObject:[NSNumber numberWithInt:3] forKey:@"CellType"];
    [resultBuyingGroupDict setObject:self.buyingGroupTitle forKey:@"Title"];
    [resultBuyingGroupDict setObject:self.buyingGroupDescrTypeCode forKey:@"DescrTypeCode"];
    [resultBuyingGroupDict setObject:[self createInitialAnswer] forKey:@"Answer"];
    
    return resultBuyingGroupDict;
}

- (NSMutableArray*)retrieveLocLocLinkWithFromLocationIUR:(NSNumber*)aFromLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FromLocationIUR = %d", [aFromLocationIUR intValue]];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

@end
