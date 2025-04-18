//
//  MeetingMainTableCellFactory.m
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTableCellFactory.h"

@implementation MeetingMainTableCellFactory
@synthesize datetimeTableCellId = _datetimeTableCellId;
@synthesize stringTableCellId = _stringTableCellId;
@synthesize locationTableCellId = _locationTableCellId;
@synthesize employeeTableCellId = _employeeTableCellId;
@synthesize textViewTableCellId = _textViewTableCellId;
@synthesize iurTableCellId = _iurTableCellId;
@synthesize booleanTableCellId = _booleanTableCellId;
@synthesize attendeesEmployeesTableCellId = _attendeesEmployeesTableCellId;
@synthesize attendeesContactsTableCellId = _attendeesContactsTableCellId;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.datetimeTableCellId = @"IdMeetingDateTimeTableViewCell";
        self.stringTableCellId = @"IdMeetingStringTableViewCell";
        self.locationTableCellId = @"IdMeetingLocationTableViewCell";
        self.employeeTableCellId = @"IdMeetingEmployeeTableViewCell";
        self.textViewTableCellId = @"IdMeetingTextViewTableViewCell";
        self.iurTableCellId = @"IdMeetingIURTableViewCell";
        self.booleanTableCellId = @"IdMeetingBooleanTableViewCell";
        self.attendeesEmployeesTableCellId = @"IdMeetingAttendeesEmployeesTableViewCell";
        self.attendeesContactsTableCellId = @"IdMeetingAttendeesContactsTableViewCell";
    }
    return self;
}

- (void)dealloc {
    self.datetimeTableCellId = nil;
    self.stringTableCellId = nil;
    self.locationTableCellId = nil;
    self.employeeTableCellId = nil;
    self.textViewTableCellId = nil;
    self.iurTableCellId = nil;
    self.booleanTableCellId = nil;
    self.attendeesEmployeesTableCellId = nil;
    self.attendeesContactsTableCellId = nil;
    
    [super dealloc];
}

- (MeetingBaseTableViewCell*)createMeetingBaseTableCellWithData:(NSMutableDictionary*)aData {
    return [self getCellWithIdentifier:[self identifierWithData:aData]];
}

- (MeetingBaseTableViewCell*)createMeetingBaseTableCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
    return [self getCellWithIdentifier:[self identifierWithArcosAttendeeWithDetails:anArcosAttendeeWithDetails]];
}

- (MeetingBaseTableViewCell*)getCellWithIdentifier:(NSString*)anIdendifier {
    MeetingBaseTableViewCell* cell = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingMainTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[MeetingBaseTableViewCell class]] && [[(MeetingBaseTableViewCell*)nibItem reuseIdentifier] isEqualToString:anIdendifier]) {
            cell = (MeetingBaseTableViewCell*)nibItem;
            break;
        }
    }
    return cell;
}

- (NSString*)identifierWithData:(NSMutableDictionary*)aData {
    NSNumber* cellType = [aData objectForKey:@"CellType"];
    NSString* auxIdentifier = nil;
    switch ([cellType intValue]) {
        case 1:
            auxIdentifier = self.datetimeTableCellId;
            break;
        case 2:
            auxIdentifier = self.stringTableCellId;
            break;
        case 3:
            auxIdentifier = self.locationTableCellId;
            break;
        case 4:
            auxIdentifier = self.employeeTableCellId;
            break;
        case 5:
            auxIdentifier = self.textViewTableCellId;
            break;
        case 6:
            auxIdentifier = self.iurTableCellId;
            break;
        case 7:
            auxIdentifier = self.booleanTableCellId;
            break;
        case 8:
            auxIdentifier = self.attendeesEmployeesTableCellId;
            break;
        case 9:
            auxIdentifier = self.attendeesContactsTableCellId;
            break;
            
        default:
            auxIdentifier = self.stringTableCellId;
            break;
    }
    return auxIdentifier;
}

- (NSString*)identifierWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails {
    NSString* auxIdentifier = nil;
    if (anArcosAttendeeWithDetails.EmployeeIUR != 0 && anArcosAttendeeWithDetails.ContactIUR == 0) {
        auxIdentifier = self.attendeesEmployeesTableCellId;
    }
    if (anArcosAttendeeWithDetails.EmployeeIUR == 0 && anArcosAttendeeWithDetails.ContactIUR != 0) {
        auxIdentifier = self.attendeesContactsTableCellId;
    }
    
    return auxIdentifier;
}


@end
