//
//  SaveRecordLocationUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 30/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordLocationUpdateCenter.h"
@interface SaveRecordLocationUpdateCenter ()
- (void)retrieveExistingLocationDict:(NSArray*)aRecordList;

@end

@implementation SaveRecordLocationUpdateCenter
- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 46;
        [self retrieveExistingLocationDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData] LoadLocationWithFieldList:aFieldList existingLocationDict:self.existingObjectDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingLocationDict:(NSArray*)aRecordList {
    NSMutableArray* locationIURList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* locationIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [locationIURList addObject:locationIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR in %@", locationIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (Location* anLocation in objectArray) {
        [self.existingObjectDict setObject:anLocation forKey:anLocation.LocationIUR];
    }
}

@end
