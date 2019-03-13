//
//  MeetingAttendeesTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 11/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol MeetingAttendeesTableViewCellDelegate <NSObject>

- (void)meetingAttendeeSelectFinishedWithData:(ArcosAttendeeWithDetails*)anArcosAttendeeWithDetails indexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttendeeRevertDeleteActionWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttendeesInformedFlag:(BOOL)anInformedFlag atIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttendeesConfirmedFlag:(BOOL)aConfirmedFlag atIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttendeesAttendedFlag:(BOOL)anAttendedFlag atIndexPath:(NSIndexPath*)anIndexPath;


@end


