//
//  ArcosCalendarEventEntryDetailListingDataManager.h
//  iArcos
//
//  Created by Richard on 02/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "ArcosCalendarEventEntryDetailListingTableViewCell.h"
#import "GlobalSharedClass.h"
#import "ArcosCalendarEventEntryDetailListingDataManagerDelegate.h"
#import "DetailingCalendarEventBoxListingDataManager.h"

@interface ArcosCalendarEventEntryDetailListingDataManager : NSObject <UITableViewDelegate, UITableViewDataSource, DetailingCalendarEventBoxListingDataManagerDelegate> {
    id<ArcosCalendarEventEntryDetailListingDataManagerDelegate> _actionDelegate;
    NSMutableArray* _journeyDictList;
    NSMutableArray* _eventDictList;
    NSMutableArray* _displayList;
    NSString* _barTitleContent;
    BOOL _hideEditButtonFlag;
    DetailingCalendarEventBoxListingDataManager* _detailingCalendarEventBoxListingDataManager;
}

@property(nonatomic, assign) id<ArcosCalendarEventEntryDetailListingDataManagerDelegate> actionDelegate;
@property(nonatomic, retain) NSMutableArray* journeyDictList;
@property(nonatomic, retain) NSMutableArray* eventDictList;
@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) NSString* barTitleContent;
@property(nonatomic, assign) BOOL hideEditButtonFlag;
@property(nonatomic, retain) DetailingCalendarEventBoxListingDataManager* detailingCalendarEventBoxListingDataManager;

- (void)processDataListWithDateFormatText:(NSString*)aDateFormatText;
- (NSString*)retrieveCalendarURIWithStartDate:(NSString*)aStartDate endDate:(NSString*)anEndDate;
- (void)createTemplateListingDisplayListWithEventList:(NSArray*)anEventList;

@end

