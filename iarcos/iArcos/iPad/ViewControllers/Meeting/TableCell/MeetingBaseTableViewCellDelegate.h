//
//  MeetingBaseTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingBaseTableViewCellDelegate <NSObject>

- (NSMutableDictionary*)retrieveHeadOfficeDataObjectDict;
- (void)meetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
@optional
- (UIViewController*)retrieveMeetingMainViewController;
- (void)meetingAttendeeEmployeeSelectFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)meetingAttendeeContactSelectFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath;
- (void)updateMeetingLocationIUR:(NSNumber*)aLocationIUR;

@end

