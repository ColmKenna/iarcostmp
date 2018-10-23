//
//  SaveRecordLocLocLinkUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 29/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordLocLocLinkUpdateCenter.h"
@interface SaveRecordLocLocLinkUpdateCenter ()
- (void)retrieveExistingLocLocLinkDict:(NSArray*)aRecordList;

@end

@implementation SaveRecordLocLocLinkUpdateCenter

- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 6;
        [self retrieveExistingLocLocLinkDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData] loadLocLocLinkWithFieldList:aFieldList existingLocLocLinkDict:self.existingObjectDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingLocLocLinkDict:(NSArray*)aRecordList {
    NSMutableArray* locLocLinkIURList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* locLocLinkIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [locLocLinkIURList addObject:locLocLinkIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR in %@", locLocLinkIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"LocLocLink" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (LocLocLink* anLocLocLink in objectArray) {
        [self.existingObjectDict setObject:anLocLocLink forKey:anLocLocLink.IUR];
    }
}

@end
