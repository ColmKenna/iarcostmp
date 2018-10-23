//
//  AccessTimesWidgetViewControllerDelegate.h
//  iArcos
//
//  Created by David Kilmartin on 15/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccessTimesWidgetViewControllerDelegate <NSObject>

- (void)accessTimesOperationDone:(NSMutableDictionary*)aWeekDayDict startTime:(NSDate*)aStartTime endTime:(NSDate*)anEndTime;

@end
