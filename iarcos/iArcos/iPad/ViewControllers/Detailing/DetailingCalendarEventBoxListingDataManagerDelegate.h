//
//  DetailingCalendarEventBoxListingDataManagerDelegate.h
//  iArcos
//
//  Created by Richard on 15/03/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DetailingCalendarEventBoxListingDataManagerDelegate <NSObject>

- (NSNumber*)retrieveDetailingCalendarEventBoxListingDataManagerLocationIUR;
- (NSNumber*)retrieveDetailingCalendarEventBoxListingLocationIURWithEventDict:(NSDictionary*)anEventDict;
- (void)doubleTapListingBodyLabelWithIndexPath:(NSIndexPath*)anIndexPath;

@end

