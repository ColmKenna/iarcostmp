//
//  MeetingPresentersDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 11/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingPresentersDataManager.h"

@implementation MeetingPresentersDataManager
@synthesize displayList = _displayList;

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    if (anArcosMeetingWithDetailsDownload == nil) return;
    if ([anArcosMeetingWithDetailsDownload.Presenters count] == 0) return;
    self.displayList = anArcosMeetingWithDetailsDownload.Presenters;
}

- (void)dealloc {
    self.displayList = nil;
    
    [super dealloc];
}

- (void)dataMeetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath {
    ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [self.displayList objectAtIndex:anIndexPath.row];
    auxArcosPresenterForMeeting.Shown = aLinkToMeetingFlag;
}

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [self.displayList objectAtIndex:i];
        [anArcosMeetingWithDetailsDownload.Presenters addObject:auxArcosPresenterForMeeting];
    }
}

@end
