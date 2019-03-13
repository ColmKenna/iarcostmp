//
//  MeetingPresentersDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 11/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetingBaseDataManager.h"
#import "ArcosMeetingWithDetails.h"
#import "ArcosPresenterForMeeting.h"

@interface MeetingPresentersDataManager : MeetingBaseDataManager {
    NSMutableArray* _displayList;
}

@property(nonatomic, retain) NSMutableArray* displayList;

- (void)dataMeetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath;

@end

