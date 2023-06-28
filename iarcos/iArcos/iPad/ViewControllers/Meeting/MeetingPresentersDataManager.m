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
@synthesize originalPresentationsDisplayList = _originalPresentationsDisplayList;
@synthesize presentationsHashMap = _presentationsHashMap;

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    if (anArcosMeetingWithDetailsDownload == nil) return;
    if ([anArcosMeetingWithDetailsDownload.Presenters count] == 0) return;
    [self createBasicPresentationsDataWithReturnObject:anArcosMeetingWithDetailsDownload];
    self.displayList = [NSMutableArray arrayWithArray:self.originalPresentationsDisplayList];
//    self.displayList = anArcosMeetingWithDetailsDownload.Presenters;
}

- (void)dealloc {
    self.displayList = nil;
    self.originalPresentationsDisplayList = nil;
    self.presentationsHashMap = nil;
    
    [super dealloc];
}

- (void)dataMeetingPresentersLinkToMeeting:(BOOL)aLinkToMeetingFlag atIndexPath:(NSIndexPath *)anIndexPath {
//    ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [self.displayList objectAtIndex:anIndexPath.row];
    MeetingPresentersCompositeObject* auxMeetingPresentersCompositeObject = [self.displayList objectAtIndex:anIndexPath.row];
    auxMeetingPresentersCompositeObject.presenterData.Shown = aLinkToMeetingFlag;
}

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
//    for (int i = 0; i < [self.displayList count]; i++) {
//        ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [self.displayList objectAtIndex:i];
//        [anArcosMeetingWithDetailsDownload.Presenters addObject:auxArcosPresenterForMeeting];
//    }
    for (int i = 0; i < [self.originalPresentationsDisplayList count]; i++) {
        MeetingPresentersCompositeObject* auxMeetingPresentersCompositeObject = [self.originalPresentationsDisplayList objectAtIndex:i];
        NSMutableArray* subPresenterDataList = [self.presentationsHashMap objectForKey:[NSNumber numberWithInt:auxMeetingPresentersCompositeObject.presenterData.Locationiur]];
        for (int j = 0; j < [subPresenterDataList count]; j++) {
            ArcosPresenterForMeeting* auxArcosPresenterForMeeting = [subPresenterDataList objectAtIndex:j];
            [anArcosMeetingWithDetailsDownload.Presenters addObject:auxArcosPresenterForMeeting];
        }
    }
}

- (NSMutableArray*)retrievePresenterParentData {
    NSArray* properties = [NSArray arrayWithObjects:@"DescrDetailIUR", @"Detail", @"Active", nil];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'PP' and Active = 1"];
    NSArray* sortArray = [NSArray arrayWithObjects:@"ProfileOrder", nil];
    return [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:properties  withPredicate:predicate withSortDescNames:sortArray withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
}

- (void)createBasicPresentationsDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    self.originalPresentationsDisplayList = [NSMutableArray array];
    NSMutableArray* tmpPresenterParentDataList = [self retrievePresenterParentData];
    self.presentationsHashMap = [NSMutableDictionary dictionaryWithCapacity:[tmpPresenterParentDataList count]];
    NSSortDescriptor* locationiurDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"DisplaySequence" ascending:YES selector:@selector(compare:)] autorelease];
    [anArcosMeetingWithDetailsDownload.Presenters sortUsingDescriptors:[NSArray arrayWithObjects:locationiurDescriptor,nil]];
    
    for (int i = 0; i < [anArcosMeetingWithDetailsDownload.Presenters count]; i++) {
        ArcosPresenterForMeeting* resArcosPresenterForMeeting = [anArcosMeetingWithDetailsDownload.Presenters objectAtIndex:i];
        if (!resArcosPresenterForMeeting.Active) continue;
        NSNumber* tmpLocationIUR = [NSNumber numberWithInt:resArcosPresenterForMeeting.Locationiur];
        NSMutableArray* subPresenterDataList = [self.presentationsHashMap objectForKey:tmpLocationIUR];
        if (subPresenterDataList == nil) {
            subPresenterDataList = [NSMutableArray array];
            [self.presentationsHashMap setObject:subPresenterDataList forKey:tmpLocationIUR];
        }
        [subPresenterDataList addObject:resArcosPresenterForMeeting];
    }
    for (int i = 0; i < [tmpPresenterParentDataList count]; i++) {
        NSDictionary* tmpDescrDetailDict = [tmpPresenterParentDataList objectAtIndex:i];
        NSNumber* tmpDescrDetailIUR = [ArcosUtils convertNilToZero:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
        if ([[self.presentationsHashMap objectForKey:tmpDescrDetailIUR] count] > 0) {
            ArcosPresenterForMeeting* tmpArcosPresenterForMeeting = [self convertDictToCustomObjectWithData:tmpDescrDetailDict];
            MeetingPresentersCompositeObject* tmpMeetingPresentersCompositeObject = [[MeetingPresentersCompositeObject alloc] initHeaderWithData:tmpArcosPresenterForMeeting];
            [self.originalPresentationsDisplayList addObject:tmpMeetingPresentersCompositeObject];
            [tmpMeetingPresentersCompositeObject release];
        }
    }
}

- (ArcosPresenterForMeeting*)convertDictToCustomObjectWithData:(NSDictionary*)aDict {
    ArcosPresenterForMeeting* arcosPresenterForMeeting = [[[ArcosPresenterForMeeting alloc] init] autorelease];
    arcosPresenterForMeeting.Locationiur = [[aDict objectForKey:@"DescrDetailIUR"] intValue];
    arcosPresenterForMeeting.Title = [aDict objectForKey:@"Detail"];
    return arcosPresenterForMeeting;
}

- (void)resetBranchData {
    for (int i = 0; i < [self.originalPresentationsDisplayList count]; i++) {
        MeetingPresentersCompositeObject* tmpBranchDict = [self.originalPresentationsDisplayList objectAtIndex:i];
        tmpBranchDict.openFlag = [NSNumber numberWithBool:NO];
    }
}

@end
