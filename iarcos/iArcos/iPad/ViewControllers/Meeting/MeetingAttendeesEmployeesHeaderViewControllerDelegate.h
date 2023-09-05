//
//  MeetingAttendeesEmployeesHeaderViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 24/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttendeesEmployeesHeaderViewControllerDelegate <NSObject>

- (void)meetingAttendeesEmployeesOperationDone:(NSMutableArray*)selectedEmployeeList;
- (UIViewController*)retrieveMeetingAttendeesEmployeesParentViewController;

@end

