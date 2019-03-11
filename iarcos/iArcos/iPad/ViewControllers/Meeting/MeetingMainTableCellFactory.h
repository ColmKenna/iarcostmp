//
//  MeetingMainTableCellFactory.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseTableViewCell.h"
#import "ArcosAttendeeWithDetails.h"

@interface MeetingMainTableCellFactory : NSObject {
    NSString* _datetimeTableCellId;
    NSString* _stringTableCellId;
    NSString* _locationTableCellId;
    NSString* _employeeTableCellId;
    NSString* _textViewTableCellId;
    NSString* _iurTableCellId;
    NSString* _booleanTableCellId;
    NSString* _attendeesEmployeesTableCellId;
    NSString* _attendeesContactsTableCellId;
}

@property(nonatomic, retain) NSString* datetimeTableCellId;
@property(nonatomic, retain) NSString* stringTableCellId;
@property(nonatomic, retain) NSString* locationTableCellId;
@property(nonatomic, retain) NSString* employeeTableCellId;
@property(nonatomic, retain) NSString* textViewTableCellId;
@property(nonatomic, retain) NSString* iurTableCellId;
@property(nonatomic, retain) NSString* booleanTableCellId;
@property(nonatomic, retain) NSString* attendeesEmployeesTableCellId;
@property(nonatomic, retain) NSString* attendeesContactsTableCellId;

- (MeetingBaseTableViewCell*)createMeetingBaseTableCellWithData:(NSMutableDictionary*)aData;
- (MeetingBaseTableViewCell*)createMeetingBaseTableCellWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails;
- (NSString*)identifierWithData:(NSMutableDictionary*)aData;
- (NSString*)identifierWithArcosAttendeeWithDetails:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails;

@end

