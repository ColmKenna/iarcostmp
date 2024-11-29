//
//  CustomerJourneyDataManager.h
//  Arcos
//
//  Created by David Kilmartin on 15/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerJourneyDataManager : NSObject {
    NSMutableArray* _groupName;
    NSMutableArray* _displayList;
    NSMutableArray* _sectionTitleList;
    NSMutableArray* _sectionTitleTextList;
    NSMutableDictionary* _locationListDict;
    NSMutableDictionary* _orderQtyListDict;
    NSMutableDictionary* _currentJourneyDict;
    
    NSMutableDictionary* _journeyDictHashMap;
}

@property (nonatomic, retain) NSMutableArray* groupName;
@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* sectionTitleList;
@property (nonatomic, retain) NSMutableArray* sectionTitleTextList;
@property (nonatomic, retain) NSMutableDictionary* locationListDict;
@property (nonatomic, retain) NSMutableDictionary* orderQtyListDict;
@property (nonatomic, retain) NSMutableDictionary* currentJourneyDict;
@property (nonatomic, retain) NSMutableDictionary* journeyDictHashMap;

- (void)processRawData:(NSMutableArray*)aJourneyList;
- (void)processRawDataProcessor:(NSMutableArray*)aJourneyList;
- (NSDate*)getJourneyStartDate;
- (NSMutableDictionary*)createAllJourneyDictObject;
- (void)getLocationsWithJourneyDict:(NSMutableDictionary*)aJourneyDict;
- (void)processJourneyData:(NSMutableDictionary*)aJourneyDict;
- (int)getIndexWithDate:(NSDate*)aDate;
- (int)getSectionIndexWithDate:(NSDate*)aDate;
- (void)dashboardProcessRawData:(NSMutableArray*)aJourneyList;
- (NSMutableDictionary*)retrieveCustomerWithIndexPath:(NSIndexPath*)anIndexPath;
- (NSNumber*)retrieveOrderQtyWithIndexPath:(NSIndexPath*)anIndexPath;

- (void)processCalendarJourneyData;
- (NSIndexPath*)retrieveIndexPathWithJourneyIUR:(NSNumber*)aJourneyIUR;
- (NSMutableArray*)retrieveLocationIURList;

@end
