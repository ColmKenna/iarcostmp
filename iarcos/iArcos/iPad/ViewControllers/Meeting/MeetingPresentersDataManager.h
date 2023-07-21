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
#import "ArcosCoreData.h"
#import "MeetingPresentersCompositeObject.h"

@interface MeetingPresentersDataManager : MeetingBaseDataManager {
    NSMutableArray* _displayList;
    NSMutableArray* _originalPresentationsDisplayList;
    NSMutableDictionary* _presentationsHashMap;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* originalPresentationsDisplayList;
@property (nonatomic, retain) NSMutableDictionary* presentationsHashMap;

- (void)dataMeetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath;
- (void)createBasicPresentationsDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload;
- (void)resetBranchData;
- (BOOL)meetingPresenterParentHasShownChildProcessor:(int)aLocationIUR;

@end

