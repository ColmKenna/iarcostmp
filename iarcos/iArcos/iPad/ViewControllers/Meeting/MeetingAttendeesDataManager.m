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
@synthesize currentSelectedDeleteIndexPath = _currentSelectedDeleteIndexPath;
@synthesize currentSelectedCellData = _currentSelectedCellData;

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
    self.currentSelectedDeleteIndexPath = nil;
    self.currentSelectedCellData = nil;
    
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
    if (anArcosMeetingWithDetails == nil) return;
    if ([anArcosMeetingWithDetails.Attendees count] == 0) return;
    for (int i = 0; i < [anArcosMeetingWithDetails.Attendees count]; i++) {
        ArcosAttendeeWithDetails* tmpArcosAttendeeWithDetails = [anArcosMeetingWithDetails.Attendees objectAtIndex:i];
        if (tmpArcosAttendeeWithDetails.EmployeeIUR != 0 && tmpArcosAttendeeWithDetails.ContactIUR == 0) {
            [employeeDisplayList addObject:[self employeeAdaptorWithAttendee:tmpArcosAttendeeWithDetails]];
        }
        if (tmpArcosAttendeeWithDetails.EmployeeIUR == 0 && tmpArcosAttendeeWithDetails.ContactIUR != 0) {
            [contactDisplayList addObject:[self contactAdaptorWithAttendee:tmpArcosAttendeeWithDetails]];
        }
    }
    NSSortDescriptor* foreNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"ForeName" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [employeeDisplayList sortUsingDescriptors:[NSArray arrayWithObjects:foreNameDescriptor,nil]];
    [self processAttendeesEmployeesCellDataDictList:employeeDisplayList];
    NSSortDescriptor* surnameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Surname" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [contactDisplayList sortUsingDescriptors:[NSArray arrayWithObjects:surnameDescriptor,nil]];
    [self processAttendeesContactsCellDataDictList:contactDisplayList];
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

- (void)processAttendeesContactsCellDataDictList:(NSMutableArray*)aCellDataDictList {
    for (int i = 0; i < [aCellDataDictList count]; i++) {
        NSMutableDictionary* aCellDataDict = [aCellDataDictList objectAtIndex:i];
        [aCellDataDict setObject:[NSNumber numberWithInt:9] forKey:@"CellType"];
    }
}

- (NSMutableDictionary*)employeeAdaptorWithAttendee:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
    NSMutableDictionary* auxEmployeeDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [auxEmployeeDict setObject:[NSNumber numberWithInt:anArcosAttendeeWithDetails.EmployeeIUR] forKey:@"IUR"];
    [auxEmployeeDict setObject:[ArcosUtils convertNilToEmpty:anArcosAttendeeWithDetails.Name] forKey:@"ForeName"];
    [auxEmployeeDict setObject:[ArcosUtils convertNilToEmpty:anArcosAttendeeWithDetails.Name] forKey:@"Title"];
    
    return auxEmployeeDict;
}

- (NSMutableDictionary*)contactAdaptorWithAttendee:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
    NSMutableDictionary* auxContactDict = [NSMutableDictionary dictionaryWithCapacity:5];
    [auxContactDict setObject:[NSNumber numberWithInt:anArcosAttendeeWithDetails.ContactIUR] forKey:@"ContactIUR"];
    [auxContactDict setObject:[ArcosUtils convertNilToEmpty:anArcosAttendeeWithDetails.Name] forKey:@"Surname"];
    [auxContactDict setObject:[ArcosUtils convertNilToEmpty:anArcosAttendeeWithDetails.Name] forKey:@"Name"];
    
    return auxContactDict;
}


@end
