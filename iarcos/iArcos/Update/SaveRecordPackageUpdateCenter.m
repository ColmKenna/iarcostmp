//
//  SaveRecordPackageUpdateCenter.m
//  iArcos
//
//  Created by Richard on 18/07/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "SaveRecordPackageUpdateCenter.h"

@implementation SaveRecordPackageUpdateCenter

- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 13;
        [self retrieveExistingPackageDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData] LoadPackageWithFieldList:aFieldList existingPackageDict:self.existingObjectDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingPackageDict:(NSArray*)aRecordList {
    NSMutableArray* packageIURList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* packageIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [packageIURList addObject:packageIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"iUR in %@", packageIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"Package" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (Package* aPackage in objectArray) {
        [self.existingObjectDict setObject:aPackage forKey:aPackage.iUR];
    }
}

@end
