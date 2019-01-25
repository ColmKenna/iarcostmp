//
//  SaveRecordDescrDetailUpdateCenter.m
//  iArcos
//
//  Created by David Kilmartin on 29/04/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "SaveRecordDescrDetailUpdateCenter.h"
@interface SaveRecordDescrDetailUpdateCenter ()
- (void)retrieveExistingDescrDetailDict:(NSArray*)aRecordList;

@end

@implementation SaveRecordDescrDetailUpdateCenter

- (id)initWithRecordList:(NSArray*)aRecordList{
    self = [super initWithRecordList:aRecordList];
    if (self != nil) {
        self.recordList = aRecordList;
        
        self.expectedFieldCount = 15;
        [self retrieveExistingDescrDetailDict:aRecordList];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)loadObjectWithFieldList:(NSArray*)aFieldList{
    [[ArcosCoreData sharedArcosCoreData]LoadDescrDetailWithFieldList:aFieldList existingDescrDetailDict:self.existingObjectDict];
}

- (void)commitObjectRecord {
    [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext];
    [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
}

- (void)retrieveExistingDescrDetailDict:(NSArray*)aRecordList {
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithCapacity:[aRecordList count]];
    for (int i = 0; i < [aRecordList count]; i++) {
        NSString* rowStr = [aRecordList objectAtIndex:i];
        NSArray* fieldList = [rowStr componentsSeparatedByString:self.delimiter];
        if ([fieldList count] == self.expectedFieldCount) {
            NSNumber* descrDetailIUR = [ArcosUtils convertStringToNumber:[fieldList objectAtIndex:0]];
            [descrDetailIURList addObject:descrDetailIUR];
        }
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrDetailIUR in %@", descrDetailIURList];
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithContext:[ArcosCoreData sharedArcosCoreData].importManagedObjectContext withEntity:@"DescrDetail" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    self.existingObjectDict = [NSMutableDictionary dictionaryWithCapacity:[objectArray count]];
    for (DescrDetail* aDescrDetail in objectArray) {
        [self.existingObjectDict setObject:aDescrDetail forKey:aDescrDetail.DescrDetailIUR];
    }
}

@end
