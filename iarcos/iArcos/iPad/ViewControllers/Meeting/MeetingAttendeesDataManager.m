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
@synthesize otherTitle = _otherTitle;
@synthesize sectionTitleList = _sectionTitleList;
@synthesize groupedDataDict = _groupedDataDict;
@synthesize currentSelectedDeleteIndexPath = _currentSelectedDeleteIndexPath;
@synthesize currentSelectedCellData = _currentSelectedCellData;
@synthesize currentSelectedArcosAttendeeWithDetails = _currentSelectedArcosAttendeeWithDetails;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.emptyTitle = @"";
        self.employeeTitle = @"Employees";
        self.contactTitle = @"Contacts";
        self.otherTitle = @"Others";
        self.sectionTitleList = [NSMutableArray arrayWithObjects:self.emptyTitle, self.employeeTitle, self.contactTitle, self.otherTitle, nil];
    }
    return self;
}

- (void)dealloc {
    self.emptyTitle = nil;
    self.employeeTitle = nil;
    self.contactTitle = nil;
    self.otherTitle = nil;
    self.sectionTitleList = nil;
    self.groupedDataDict = nil;
    self.currentSelectedDeleteIndexPath = nil;
    self.currentSelectedCellData = nil;
    self.currentSelectedArcosAttendeeWithDetails = nil;
    
    [super dealloc];
}

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    self.groupedDataDict = [NSMutableDictionary dictionaryWithCapacity:4];
    NSMutableArray* emptyDisplayList = [NSMutableArray arrayWithCapacity:0];
    [self.groupedDataDict setObject:emptyDisplayList forKey:self.emptyTitle];
    NSMutableArray* employeeDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:employeeDisplayList forKey:self.employeeTitle];
    NSMutableArray* contactDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:contactDisplayList forKey:self.contactTitle];
    NSMutableArray* otherDisplayList = [NSMutableArray array];
    [self.groupedDataDict setObject:otherDisplayList forKey:self.otherTitle];
    if (anArcosMeetingWithDetailsDownload == nil) return;
    if ([anArcosMeetingWithDetailsDownload.Attendees count] == 0) return;
    for (int i = 0; i < [anArcosMeetingWithDetailsDownload.Attendees count]; i++) {
        ArcosAttendeeWithDetails* tmpArcosAttendeeWithDetails = [anArcosMeetingWithDetailsDownload.Attendees objectAtIndex:i];
        if (tmpArcosAttendeeWithDetails.EmployeeIUR != 0 && tmpArcosAttendeeWithDetails.ContactIUR == 0) {
//            [employeeDisplayList addObject:[self employeeAdaptorWithAttendee:tmpArcosAttendeeWithDetails]];
            [employeeDisplayList addObject:tmpArcosAttendeeWithDetails];
        }
        if (tmpArcosAttendeeWithDetails.EmployeeIUR == 0 && tmpArcosAttendeeWithDetails.ContactIUR != 0) {
//            [contactDisplayList addObject:[self contactAdaptorWithAttendee:tmpArcosAttendeeWithDetails]];
            [contactDisplayList addObject:tmpArcosAttendeeWithDetails];
        }
        if (tmpArcosAttendeeWithDetails.EmployeeIUR == 0 && tmpArcosAttendeeWithDetails.ContactIUR == 0) {
            [otherDisplayList addObject:tmpArcosAttendeeWithDetails];
        }
    }
    NSSortDescriptor* foreNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [employeeDisplayList sortUsingDescriptors:[NSArray arrayWithObjects:foreNameDescriptor,nil]];
    NSSortDescriptor* nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [contactDisplayList sortUsingDescriptors:[NSArray arrayWithObjects:nameDescriptor,nil]];
}

- (ArcosAttendeeWithDetails*)cellDataWithIndexPath:(NSIndexPath*)anIndexPath {
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

- (ArcosAttendeeWithDetails*)attendeeAdaptorWithEmployee:(NSMutableDictionary*)anEmployeeDict {
    ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [[[ArcosAttendeeWithDetails alloc] init] autorelease];
    arcosAttendeeWithDetails.IUR = 0;
    arcosAttendeeWithDetails.MeetingIUR = 0;
    arcosAttendeeWithDetails.ContactIUR = 0;
    arcosAttendeeWithDetails.ContactName = @"";
    arcosAttendeeWithDetails.EmployeeIUR = [[anEmployeeDict objectForKey:@"IUR"] intValue];
    arcosAttendeeWithDetails.EmployeeName = [ArcosUtils convertNilToEmpty:[anEmployeeDict objectForKey:@"Title"]];
    arcosAttendeeWithDetails.Name = [ArcosUtils convertNilToEmpty:[anEmployeeDict objectForKey:@"Title"]];
    arcosAttendeeWithDetails.Organisation = @"";
    arcosAttendeeWithDetails.Address1 = @"";
    arcosAttendeeWithDetails.Address2 = @"";
    arcosAttendeeWithDetails.Address3 = @"";
    arcosAttendeeWithDetails.Address4 = @"";
    arcosAttendeeWithDetails.Address5 = @"";
    arcosAttendeeWithDetails.Confirmed = NO;
    arcosAttendeeWithDetails.Attended = NO;
    arcosAttendeeWithDetails.Informed = NO;
    arcosAttendeeWithDetails.Email = @"";
    arcosAttendeeWithDetails.COiur = 0;
    
    return arcosAttendeeWithDetails;
}

- (ArcosAttendeeWithDetails*)attendeeAdaptorWithContact:(NSMutableDictionary*)aContactDict {
    ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [[[ArcosAttendeeWithDetails alloc] init] autorelease];
    arcosAttendeeWithDetails.IUR = 0;
    arcosAttendeeWithDetails.MeetingIUR = 0;
    arcosAttendeeWithDetails.ContactIUR = [[aContactDict objectForKey:@"ContactIUR"] intValue];
    arcosAttendeeWithDetails.ContactName = [ArcosUtils convertNilToEmpty:[aContactDict objectForKey:@"Name"]];
    arcosAttendeeWithDetails.EmployeeIUR = 0;
    arcosAttendeeWithDetails.EmployeeName = @"";
    arcosAttendeeWithDetails.Name = [ArcosUtils convertNilToEmpty:[aContactDict objectForKey:@"Name"]];
    arcosAttendeeWithDetails.Organisation = @"";
    arcosAttendeeWithDetails.Address1 = @"";
    arcosAttendeeWithDetails.Address2 = @"";
    arcosAttendeeWithDetails.Address3 = @"";
    arcosAttendeeWithDetails.Address4 = @"";
    arcosAttendeeWithDetails.Address5 = @"";
    arcosAttendeeWithDetails.Confirmed = NO;
    arcosAttendeeWithDetails.Attended = NO;
    arcosAttendeeWithDetails.Informed = NO;
    arcosAttendeeWithDetails.Email = @"";
    arcosAttendeeWithDetails.COiur = 0;
    
    return arcosAttendeeWithDetails;
}

- (ArcosAttendeeWithDetails*)attendeeOtherAdaptorWithName:(NSString*)aName organisation:(NSString*)anOrganisation {
    ArcosAttendeeWithDetails* arcosAttendeeWithDetails = [[[ArcosAttendeeWithDetails alloc] init] autorelease];
    arcosAttendeeWithDetails.IUR = 0;
    arcosAttendeeWithDetails.MeetingIUR = 0;
    arcosAttendeeWithDetails.ContactIUR = 0;
    arcosAttendeeWithDetails.ContactName = @"";
    arcosAttendeeWithDetails.EmployeeIUR = 0;
    arcosAttendeeWithDetails.EmployeeName = @"";
    arcosAttendeeWithDetails.Name = [ArcosUtils convertNilToEmpty:aName];
    arcosAttendeeWithDetails.Organisation = [ArcosUtils convertNilToEmpty:anOrganisation];;
    arcosAttendeeWithDetails.Address1 = @"";
    arcosAttendeeWithDetails.Address2 = @"";
    arcosAttendeeWithDetails.Address3 = @"";
    arcosAttendeeWithDetails.Address4 = @"";
    arcosAttendeeWithDetails.Address5 = @"";
    arcosAttendeeWithDetails.Confirmed = NO;
    arcosAttendeeWithDetails.Attended = NO;
    arcosAttendeeWithDetails.Informed = NO;
    arcosAttendeeWithDetails.Email = @"";
    arcosAttendeeWithDetails.COiur = 0;
    
    return arcosAttendeeWithDetails;
}

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    for (int i = 0; i < [self.sectionTitleList count]; i++) {
        NSString* tmpSectionTitle = [self.sectionTitleList objectAtIndex:i];
        NSMutableArray* tmpDisplayList = [self.groupedDataDict objectForKey:tmpSectionTitle];
        for (int j = 0; j < [tmpDisplayList count]; j++) {
            ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [tmpDisplayList objectAtIndex:j];
            if (auxArcosAttendeeWithDetails.EmployeeIUR == 0 && auxArcosAttendeeWithDetails.ContactIUR == 0) {
                auxArcosAttendeeWithDetails.Name = [ArcosUtils wrapStringByCDATA:[ArcosUtils convertNilToEmpty:auxArcosAttendeeWithDetails.Name]];
                auxArcosAttendeeWithDetails.Organisation = [ArcosUtils wrapStringByCDATA:[ArcosUtils convertNilToEmpty:auxArcosAttendeeWithDetails.Organisation]];
            }
            if (auxArcosAttendeeWithDetails.COiur == -999) {
                auxArcosAttendeeWithDetails.Name = @"DELETE";
            }
            [anArcosMeetingWithDetailsDownload.Attendees addObject:auxArcosAttendeeWithDetails];
        }
    }
}

- (void)dataMeetingAttendeesInformedFlag:(BOOL)anInformedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [self cellDataWithIndexPath:anIndexPath];
    auxArcosAttendeeWithDetails.Informed = anInformedFlag;
}

- (void)dataMeetingAttendeesConfirmedFlag:(BOOL)aConfirmedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [self cellDataWithIndexPath:anIndexPath];
    auxArcosAttendeeWithDetails.Confirmed = aConfirmedFlag;
}

- (void)dataMeetingAttendeesAttendedFlag:(BOOL)anAttendedFlag atIndexPath:(NSIndexPath *)anIndexPath {
    ArcosAttendeeWithDetails* auxArcosAttendeeWithDetails = [self cellDataWithIndexPath:anIndexPath];
    auxArcosAttendeeWithDetails.Attended = anAttendedFlag;
}

@end
