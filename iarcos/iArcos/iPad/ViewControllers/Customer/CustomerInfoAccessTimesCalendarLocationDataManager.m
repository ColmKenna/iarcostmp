//
//  CustomerInfoAccessTimesCalendarLocationDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/10/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccessTimesCalendarLocationDataManager.h"

@implementation CustomerInfoAccessTimesCalendarLocationDataManager



- (void)updateResultWithNumber:(NSNumber*)aNumber iur:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [anIUR intValue]];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        Location* auxLocation = [objectList objectAtIndex:0];
        auxLocation.Competitor2 = aNumber;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

- (void)saveAccessTimesToDB:(NSString*)anAccessTimes iur:(NSNumber*)anIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %d", [anIUR intValue]];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:nil withResulType:NSManagedObjectResultType needDistinct:NO ascending:nil];
    if ([objectList count] > 0) {
        Location* auxLocation = [objectList objectAtIndex:0];
        auxLocation.accessTimes = anAccessTimes;
        [[ArcosCoreData sharedArcosCoreData] saveContext:[ArcosCoreData sharedArcosCoreData].fetchManagedObjectContext];
    }
}

@end
