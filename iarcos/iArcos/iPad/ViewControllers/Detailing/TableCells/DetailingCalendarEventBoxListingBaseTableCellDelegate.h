//
//  DetailingCalendarEventBoxListingBaseTableCellDelegate.h
//  iArcos
//
//  Created by Richard on 15/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DetailingCalendarEventBoxListingBaseTableCellDelegate <NSObject>


- (NSNumber*)retrieveDetailingCalendarEventBoxListingTableCellLocationIUR;
- (NSNumber*)retrieveDetailingCalendarEventBoxListingTableCellLocationIURWithEventDict:(NSDictionary*)anEventDict;
- (void)doubleTapBodyLabelWithIndexPath:(NSIndexPath*)anIndexPath;

@optional
- (void)doubleTapBodyLabelForPopOutWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)longInputForPopOutFinishedWithIndexPath:(NSIndexPath*)anIndexPath;
- (NSDictionary*)retrieveLocationDictWithLocationIUR:(NSNumber*)aLocationIUR;

@end


