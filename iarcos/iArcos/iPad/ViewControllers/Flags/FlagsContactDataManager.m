//
//  FlagsContactDataManager.m
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactDataManager.h"

@implementation FlagsContactDataManager

- (NSMutableArray*)retrieveContactListWithLocationDict:(NSMutableDictionary*)aLocationDict {
    NSMutableArray* resultContactList = [NSMutableArray array];
    //get the conloclink base on the location iur
    NSNumber* auxLocationIUR = [aLocationDict objectForKey:@"LocationIUR"];
    NSMutableArray* conloclinks=[[ArcosCoreData sharedArcosCoreData] conlocLinksWithLocationIUR:auxLocationIUR];
    
    //loop through the conloclinks and find the contacts associate with it
    NSMutableArray* contactIURList = [NSMutableArray arrayWithCapacity:[conloclinks count]];
    for (NSDictionary* aDict in conloclinks) {
        NSNumber* contactIUR=[aDict objectForKey:@"ContactIUR"];
        [contactIURList addObject:contactIUR];
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIURList:contactIURList];
    for (int i = 0; i < [contactList count]; i++) {
        NSDictionary* contactDict = [contactList objectAtIndex:i];
        NSMutableDictionary* resultContactDict = [NSMutableDictionary dictionaryWithDictionary:contactDict];
        NSString* surname = [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Surname"]];
        NSString* forename = [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Forename"]];
        NSString* name = [NSString stringWithFormat:@"%@ %@",[NSString stringWithString:forename],[NSString stringWithString:surname]];
        if (surname.length == 0) {
            surname = @" ";
        }
        
        [resultContactDict setObject:name forKey:@"Name"];
        [resultContactDict setObject:name forKey:@"SortKey"];
        [resultContactDict setObject:surname forKey:@"Surname"];
        [resultContactDict setObject:[NSString stringWithFormat:@"%@", [aLocationDict objectForKey:@"Name"]] forKey:@"LocationName"];
        [resultContactList addObject:resultContactDict];
    }
    if ([resultContactList count] > 0) {
        NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Surname" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
        [resultContactList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    }
    return resultContactList;
}

@end
