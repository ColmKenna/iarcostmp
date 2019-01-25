//
//  MeetingAttendeesDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesDataManager.h"

@implementation MeetingAttendeesDataManager
@synthesize emptyTitle = _emptyTitle;
@synthesize employeeTitle = _employeeTitle;
@synthesize contactTitle = _contactTitle;
//@synthesize otherTitle = _otherTitle;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.emptyTitle = @"";
        self.employeeTitle = @"Employees";
        self.contactTitle = @"Contacts";
        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.emptyTitle, self.employeeTitle, self.contactTitle, nil];
    }
    return self;
}

- (void)dealloc {
    self.emptyTitle = nil;
    self.employeeTitle = nil;
    self.contactTitle = nil;
//    self.otherTitle = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    
    [super dealloc];
}

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetails*)anArcosMeetingWithDetails {
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSMutableArray* emptyDisplayList = [NSMutableArray arrayWithCapacity:0];
    [self.groupedDataDict setObject:emptyDisplayList forKey:self.emptyTitle];
    NSMutableArray* employeeDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:employeeDisplayList forKey:self.employeeTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:contactDisplayList forKey:self.contactTitle];
    
}

- (NSMutableDictionary*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
    return [tmpDisplayList objectAtIndex:anIndexPath.row];
}

- (void)processAttendeesEmployeesCellDataDictList:(NSMutableArray*)aCellDataDictList {
    for (int i = 0; i < [aCellDataDictList count]; i++) {
        NSMutableDictionary* aCellDataDict = [aCellDataDictList objectAtIndex:i];
        [aCellDataDict setObject:[NSNumber numberWithInt:8] forKey:@"CellType"];
    }
}


@end
