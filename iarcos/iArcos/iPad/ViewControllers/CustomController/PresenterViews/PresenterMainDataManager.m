//
//  PresenterMainDataManager.m
//  iArcos
//
//  Created by Richard on 10/12/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "PresenterMainDataManager.h"

@implementation PresenterMainDataManager
@synthesize mainPresenterIUR = _mainPresenterIUR;
@synthesize emailAllAtCombinedPresenterFlag = _emailAllAtCombinedPresenterFlag;
@synthesize presenterIURForFlag = _presenterIURForFlag;
@synthesize flagChangedDataList = _flagChangedDataList;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.mainPresenterIUR = nil;
        self.presenterIURForFlag = nil;
    }
    
    return self;
}

- (void)dealloc {
    self.mainPresenterIUR = nil;
    self.presenterIURForFlag = nil;
    self.flagChangedDataList = nil;
    
    [super dealloc];
}

- (NSMutableArray*)retrieveDescrDetailForFlagWithPresenterIUR:(NSNumber*)aPresenterIUR {
    NSMutableArray* descrTypeCodeList = [NSMutableArray arrayWithObjects:@"CF", @"LF", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode in %@ and DescrDetailCode = %@ and Active = 1", descrTypeCodeList, [NSString stringWithFormat:@"%d", [aPresenterIUR intValue]]];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:YES ascending:nil];
    
    if ([objectArray count] >0 ) {
        return objectArray;
    } else {
        return [NSMutableArray array];
    }
}

- (void)retrieveFlagChangedDataListWithDescrDetailDictList:(NSMutableArray*)aDescrDetailDictList {
    self.flagChangedDataList = [NSMutableArray array];
    for (int i = 0; i < [aDescrDetailDictList count]; i++) {
        NSDictionary* aDescrDetailDict = [aDescrDetailDictList objectAtIndex:i];
        NSNumber* tmpDescrDetailIUR = [aDescrDetailDict objectForKey:@"DescrDetailIUR"];
        if ([[aDescrDetailDict objectForKey:@"DescrTypeCode"] isEqualToString:@"LF"]) {
            ArcosCreateRecordObject* arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
            NSMutableArray* fieldNames = [NSMutableArray arrayWithObjects:@"LocationIUR", @"ContactIUR", @"DescrDetailIUR", @"CreateDelete", nil];
            NSMutableArray* fieldValues = [NSMutableArray arrayWithCapacity:4];
            [fieldValues addObject:[[GlobalSharedClass shared].currentSelectedLocationIUR stringValue]];
            [fieldValues addObject:[[NSNumber numberWithInt:0] stringValue]];
            [fieldValues addObject:[tmpDescrDetailIUR stringValue]];
            [fieldValues addObject:@"S"];
            arcosCreateRecordObject.FieldNames = fieldNames;
            arcosCreateRecordObject.FieldValues = fieldValues;
            [self.flagChangedDataList addObject:arcosCreateRecordObject];
            [arcosCreateRecordObject release];
        }
        if ([[aDescrDetailDict objectForKey:@"DescrTypeCode"] isEqualToString:@"CF"] && [GlobalSharedClass shared].currentSelectedContactIUR != nil) {
            ArcosCreateRecordObject* arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
            NSMutableArray* fieldNames = [NSMutableArray arrayWithObjects:@"LocationIUR", @"ContactIUR", @"DescrDetailIUR", @"CreateDelete", nil];
            NSMutableArray* fieldValues = [NSMutableArray arrayWithCapacity:4];
            [fieldValues addObject:[[NSNumber numberWithInt:0] stringValue]];
            [fieldValues addObject:[[GlobalSharedClass shared].currentSelectedContactIUR stringValue]];
            [fieldValues addObject:[tmpDescrDetailIUR stringValue]];
            [fieldValues addObject:@"S"];
            arcosCreateRecordObject.FieldNames = fieldNames;
            arcosCreateRecordObject.FieldValues = fieldValues;
            [self.flagChangedDataList addObject:arcosCreateRecordObject];
            [arcosCreateRecordObject release];
        }
    }
}

@end
