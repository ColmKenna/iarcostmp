//
//  DetailingCalendarEventBoxListingDataManager.h
//  iArcos
//
//  Created by Richard on 07/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosUtils.h"
#import "DetailingCalendarEventBoxListingTableCellFactory.h"
#import "DetailingCalendarEventBoxListingDataManagerDelegate.h"

@interface DetailingCalendarEventBoxListingDataManager : NSObject <UITableViewDelegate, UITableViewDataSource, DetailingCalendarEventBoxListingBaseTableCellDelegate> {
    id<DetailingCalendarEventBoxListingDataManagerDelegate> _actionDelegate;
    NSMutableArray* _displayList;
    NSMutableArray* _dateList;
    NSMutableDictionary* _hourHashMap;
    DetailingCalendarEventBoxListingTableCellFactory* _cellFactory;
    NSNumber* _bodyCellType;
    NSNumber* _bodyTemplateCellType;
    NSNumber* _headerCellType;
    NSNumber* _headerForPopOutType;
    NSNumber* _bodyForPopOutCellType;
}

@property (nonatomic, assign) id<DetailingCalendarEventBoxListingDataManagerDelegate> actionDelegate;
@property (nonatomic, retain) NSMutableArray* displayList;
@property (nonatomic, retain) NSMutableArray* dateList;
@property (nonatomic, retain) NSMutableDictionary* hourHashMap;
@property (nonatomic, retain) DetailingCalendarEventBoxListingTableCellFactory* cellFactory;
@property (nonatomic, retain) NSNumber* bodyCellType;
@property (nonatomic, retain) NSNumber* bodyTemplateCellType;
@property (nonatomic, retain) NSNumber* headerCellType;
@property (nonatomic, retain) NSNumber* headerForPopOutType;
@property (nonatomic, retain) NSNumber* bodyForPopOutCellType;

- (void)createBasicDataWithDataList:(NSMutableArray*)aDataList headerCellType:(NSNumber*)aHeaderCellType;
- (void)createBasicDataForTemplateWithDataList:(NSMutableArray*)aDataList headerCellType:(NSNumber*)aHeaderCellType;

@end

