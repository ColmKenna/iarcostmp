//
//  CustomerContactEditDataManager.m
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerContactEditDataManager.h"

@implementation CustomerContactEditDataManager

- (id)init {
    self = [super init];
    if (self != nil) {
        self.orderedFieldTypeList = [NSMutableArray arrayWithObjects:@"System.String", @"Access Times", @"IUR", @"Flags", @"Links", @"System.Boolean", nil];
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];   
}

- (NSMutableArray*)locLinkLocationListWithContactIUR:(NSNumber*)aContactIUR {
    NSMutableArray* conLocLinkList = [[ArcosCoreData sharedArcosCoreData] conlocLinksWithContactIUR:aContactIUR];
    NSMutableArray* locLinkLocationList = [NSMutableArray arrayWithCapacity:[conLocLinkList count]];
    
    NSMutableDictionary* tmpLocationIURDict = [NSMutableDictionary dictionaryWithCapacity:[conLocLinkList count]];
    for (NSDictionary* aConLocLink in conLocLinkList) {
        [tmpLocationIURDict setObject:[NSNull null] forKey:[aConLocLink objectForKey:@"LocationIUR"]];
    }
    NSMutableArray* locationIURList = [NSMutableArray arrayWithArray:[tmpLocationIURDict allKeys]];
    NSMutableArray* locationObjectArray = [[ArcosCoreData sharedArcosCoreData] locationsWithIURList:locationIURList];
    NSMutableDictionary* locationDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[locationObjectArray count]];
    if ([locationObjectArray count] > 0) {
        for (NSDictionary* aLocationDict in locationObjectArray) {
            [locationDictHashMap setObject:aLocationDict forKey:[aLocationDict objectForKey:@"LocationIUR"]];
        }
        //finish data preparation
        for (NSDictionary* aConlocLinkDict in conLocLinkList) {
            NSNumber* locLinkIUR = [aConlocLinkDict objectForKey:@"IUR"];
            NSNumber* locationIUR = [aConlocLinkDict objectForKey:@"LocationIUR"];
            NSDictionary* locationDict = [locationDictHashMap objectForKey:locationIUR];
            if (locationDict == nil) {
                continue;
            }                    
            NSMutableDictionary* locLinkLocationDict = [NSMutableDictionary dictionaryWithDictionary:locationDict];
            [locLinkLocationDict setObject:[NSNumber numberWithInt:[locLinkIUR intValue]] forKey:@"LocLinkIUR"];
                       
            [locLinkLocationList addObject:locLinkLocationDict]; 
        }        
    }   
    
    return locLinkLocationList;
}

@end
