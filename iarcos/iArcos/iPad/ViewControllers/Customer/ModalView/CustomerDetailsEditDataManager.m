//
//  CustomerDetailsEditDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 03/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsEditDataManager.h"

@implementation CustomerDetailsEditDataManager

- (id)init {
    self = [super init];
    if (self != nil) {
        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String",@"Access Times", @"IUR", @"Buying Group",@"System.Boolean", nil];
    }
    return self;
}

- (NSMutableArray*)buyingGroupLocationListWithLocationIUR:(NSNumber*)aLocationIUR {
    NSMutableArray* locLocLinkList = [self locLocLinkWithLocationIUR:aLocationIUR];
    NSMutableArray* locLocLinkFromLocationList = [NSMutableArray arrayWithCapacity:[locLocLinkList count]];
    
    NSMutableDictionary* tmpLocationIURDict = [NSMutableDictionary dictionaryWithCapacity:[locLocLinkList count]];
    for (NSDictionary* aLocLocLink in locLocLinkList) {
        [tmpLocationIURDict setObject:[NSNull null] forKey:[aLocLocLink objectForKey:@"FromLocationIUR"]];
    }
    NSMutableArray* fromLocationIURList = [NSMutableArray arrayWithArray:[tmpLocationIURDict allKeys]];
    NSMutableArray* fromLocationObjectArray = [[ArcosCoreData sharedArcosCoreData] locationsWithIURList:fromLocationIURList];
    NSMutableDictionary* fromLocationDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[fromLocationObjectArray count]];
    if ([fromLocationObjectArray count] > 0) {
        for (NSDictionary* aFromLocationDict in fromLocationObjectArray) {
            [fromLocationDictHashMap setObject:aFromLocationDict forKey:[aFromLocationDict objectForKey:@"LocationIUR"]];
        }
        //finish data preparation
        for (NSDictionary* aLocLocLinkDict in locLocLinkList) {
            NSNumber* locLocLinkIUR = [aLocLocLinkDict objectForKey:@"IUR"];
            NSNumber* fromLocationIUR = [aLocLocLinkDict objectForKey:@"FromLocationIUR"];
            NSDictionary* fromLocationDict = [fromLocationDictHashMap objectForKey:fromLocationIUR];
            if (fromLocationDict == nil) {
                continue;
            }
            NSMutableDictionary* locLocLinkFromLocationDict = [NSMutableDictionary dictionaryWithDictionary:fromLocationDict];
            [locLocLinkFromLocationDict setObject:[NSNumber numberWithInt:[locLocLinkIUR intValue]] forKey:@"LocLocLinkIUR"];
            [locLocLinkFromLocationList addObject:locLocLinkFromLocationDict];
        }
    }
    
    return locLocLinkFromLocationList;
}

- (NSMutableArray*)locLocLinkWithLocationIUR:(NSNumber*)aLocationIUR {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"LocationIUR = %@ and LinkType = 9", aLocationIUR];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"LocationIUR",nil];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"LocLocLink" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    
    return objectsArray;
}

@end
