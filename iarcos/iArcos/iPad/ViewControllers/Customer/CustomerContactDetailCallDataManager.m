//
//  CustomerContactDetailCallDataManager.m
//  iArcos
//
//  Created by Richard on 03/02/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailCallDataManager.h"

@implementation CustomerContactDetailCallDataManager

- (void)callHeaderProcessorWithContactIURList:(NSMutableArray*)aContactIURList {
    self.callHeaderHashMap = [NSMutableDictionary dictionary];

    if ([aContactIURList count] == 0) {
        return;
    }
    NSPredicate* predicateOrder = [NSPredicate predicateWithFormat:@"ContactIUR in %@ and NumberOflines <= 0", aContactIURList];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"EnteredDate",nil];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"OrderHeader" withPropertiesToFetch:nil  withPredicate:predicateOrder withSortDescNames:sortDescNames withResulType:NSManagedObjectResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectList count] == 0) {
        return;
    }
    for (int i = 0; i < [objectList count]; i++) {
        OrderHeader* tmpOrderHeader = [objectList objectAtIndex:i];
        if ([self.callHeaderHashMap objectForKey:tmpOrderHeader.ContactIUR] == nil) {
            [self.callHeaderHashMap setObject:tmpOrderHeader forKey:tmpOrderHeader.ContactIUR];
        }
    }
}

@end
