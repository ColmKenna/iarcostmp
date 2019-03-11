//
//  MeetingAttendeesOthersHeaderViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 07/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingAttendeesOthersHeaderViewControllerDelegate <NSObject>

- (UIViewController*)retrieveParentViewController;
- (void)meetingAttendeesOthersWithName:(NSString*)aName organisation:(NSString*)anOrganisation;

@end

