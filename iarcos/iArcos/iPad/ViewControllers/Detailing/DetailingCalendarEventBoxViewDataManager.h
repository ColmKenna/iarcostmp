//
//  DetailingCalendarEventBoxViewDataManager.h
//  iArcos
//
//  Created by Richard on 26/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface DetailingCalendarEventBoxViewDataManager : NSObject {
    NSDate* _journeyDateData;
    NSDate* _calendarDateData;
    NSMutableDictionary* _originalEventDataDict;
    NSString* _acctNotSignInMsg;
    NSMutableArray* _listingDisplayList;
    NSString* _suggestedAppointmentText;
    NSString* _nextAppointmentText;
}

@property(nonatomic,retain) NSDate* journeyDateData;
@property(nonatomic,retain) NSDate* calendarDateData;
@property(nonatomic,retain) NSMutableDictionary* originalEventDataDict;
@property(nonatomic,retain) NSString* acctNotSignInMsg;
@property(nonatomic,retain) NSMutableArray* listingDisplayList;
@property(nonatomic,retain) NSString* suggestedAppointmentText;
@property(nonatomic,retain) NSString* nextAppointmentText;

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate locationName:(NSString*)aLocationName;
- (NSMutableDictionary*)retrieveEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR;
- (NSMutableDictionary*)retrieveEditEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR;
- (NSMutableDictionary*)populateCalendarEventEntryWithData:(NSDictionary*)aDataDict;

@end

