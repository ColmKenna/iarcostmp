//
//  FlagsSelectedContactDataManager.m
//  iArcos
//
//  Created by Richard on 10/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsSelectedContactDataManager.h"

@implementation FlagsSelectedContactDataManager
@synthesize displayList = _displayList;
@synthesize contactFlagDictList = _contactFlagDictList;

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.contactFlagDictList = nil;
        
    [super dealloc];
}

- (NSMutableArray*)retrieveContactFlagData {
    /*
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='CF' and Active = 1"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"Detail",nil];
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR",@"Detail",nil];
    
    NSMutableArray* objectArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
    self.contactFlagDictList = [NSMutableArray arrayWithCapacity:[objectArray count]];
    for (NSDictionary* tmpDict in objectArray) {
        NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
        if ([tmpDict objectForKey:@"Detail"] == nil) {
            [resultDict setObject:@"Not Defined" forKey:@"Title"];
        }else{
            [resultDict setObject:[tmpDict objectForKey:@"Detail"] forKey:@"Title"];
        }
        [self.contactFlagDictList addObject:resultDict];
    }
    
    return self.contactFlagDictList;
     */
    self.contactFlagDictList = [[ArcosCoreData sharedArcosCoreData] retrieveContactFlagData];
    return self.contactFlagDictList;
}

@end
