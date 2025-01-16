//
//  ArcosCalendarEventEntryDetailListingDataManagerDelegate.h
//  iArcos
//
//  Created by Richard on 22/02/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarEventEntryDetailListingDataManagerDelegate <NSObject>


- (NSNumber*)retrieveEventEntryDetailListingLocationIUR;

@optional
- (void)doubleTapEventEntryDetailListingWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)longInputEventEntryDetailListingFinishedWithIndexPath:(NSIndexPath*)anIndexPath;

@end


