//
//  CustomerInfoAccessTimesCalendarTableViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 24/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomerInfoAccessTimesCalendarTableViewControllerDelegate <NSObject>

- (void)refreshLocationInfoFromAccessTimesCalendar;
@optional
- (void)closeCalendarPopoverViewController;

@end
