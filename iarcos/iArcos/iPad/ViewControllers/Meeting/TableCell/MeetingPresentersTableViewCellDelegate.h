//
//  MeetingPresentersTableViewCellDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 13/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MeetingPresentersTableViewCellDelegate <NSObject>

- (void)meetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath*)anIndexPath;

@end

