//
//  CustomerInfoAccessTimesCalendarContactDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarContactDataManager.h"

@implementation CustomerInfoAccessTimesCalendarContactDataManager

- (void)updateResultWithNumber:(NSNumber*)aNumber iur:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [anIUR intValue]];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        Contact* auxContact = [objectList objectAtIndex:0];
        auxContact.cP20 = aNumber;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (void)saveAccessTimesToDB:(NSString*)anAccessTimes iur:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"IUR = %d", [anIUR intValue]];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Contact" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        Contact* auxContact = [objectList objectAtIndex:0];
        auxContact.accessTimes = anAccessTimes;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

@end
