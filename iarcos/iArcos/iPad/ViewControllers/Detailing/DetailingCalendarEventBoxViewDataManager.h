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
#import "ArcosCoreData.h"

@interface DetailingCalendarEventBoxViewDataManager : NSObject {
    NSDate* _journeyDateData;
    NSDate* _nextAppointmentData;
    NSDate* _calendarDateData;
    NSMutableDictionary* _originalEventDataDict;
//    NSString* _acctNotSignInMsg;
    NSMutableArray* _listingDisplayList;
    NSMutableArray* _ownLocationDisplayList;
    NSString* _suggestedAppointmentText;
    NSString* _nextAppointmentText;
    BOOL _eventForCurrentLocationFoundFlag;
    BOOL _journeyForCurrentLocationFoundFlag;
    NSDate* _journeyDateForCurrentLocation;
    NSMutableArray* _templateListingDisplayList;
    NSMutableArray* _journeyDictList;
    NSMutableArray* _eventDictList;
    NSNumber* _bodyCellType;
    NSNumber* _bodyTemplateCellType;
}

@property(nonatomic,retain) NSDate* journeyDateData;
@property(nonatomic,retain) NSDate* nextAppointmentData;
@property(nonatomic,retain) NSDate* calendarDateData;
@property(nonatomic,retain) NSMutableDictionary* originalEventDataDict;
//@property(nonatomic,retain) NSString* acctNotSignInMsg;
@property(nonatomic,retain) NSMutableArray* listingDisplayList;
@property(nonatomic,retain) NSMutableArray* ownLocationDisplayList;
@property(nonatomic,retain) NSString* suggestedAppointmentText;
@property(nonatomic,retain) NSString* nextAppointmentText;
@property(nonatomic,assign) BOOL eventForCurrentLocationFoundFlag;
@property(nonatomic,assign) BOOL journeyForCurrentLocationFoundFlag;
@property(nonatomic,retain) NSDate* journeyDateForCurrentLocation;
@property(nonatomic,retain) NSMutableArray* templateListingDisplayList;
@property(nonatomic,retain) NSMutableArray* journeyDictList;
@property(nonatomic,retain) NSMutableArray* eventDictList;
@property(nonatomic,retain) NSNumber* bodyCellType;
@property(nonatomic,retain) NSNumber* bodyTemplateCellType;

- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate locationName:(NSString*)aLocationName;
- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate;
- (NSMutableDictionary*)retrieveEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR;
- (NSMutableDictionary*)retrieveEditEventDictWithLocationName:(NSString*)aLocationName contactName:(NSString*)aContactName locationIUR:(NSNumber*)aLocationIUR contactIUR:(NSNumber*)aContactIUR;
- (NSMutableDictionary*)populateCalendarEventEntryWithData:(NSDictionary*)aDataDict;
- (NSMutableDictionary*)createEditEventEntryDetailTemplateData:(NSDictionary*)aDataDict;
- (NSMutableArray*)retrieveTemplateListingDisplayListWithBodyCellType:(NSNumber*)aBodyCellType;
- (NSNumber*)retrieveLocationIURWithEventDict:(NSDictionary*)anEventDict;
- (BOOL)calculateJourneyDateWithLocationIUR:(NSNumber*)aLocationIUR;
- (NSDate*)retrieveNextFifteenMinutesWithDate:(NSDate*)aDate;

@end

