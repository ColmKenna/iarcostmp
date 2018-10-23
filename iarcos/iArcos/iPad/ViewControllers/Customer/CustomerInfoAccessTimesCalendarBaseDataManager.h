//
//  CustomerInfoAccessTimesCalendarBaseDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 03/10/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcosCoreData.h"

@interface CustomerInfoAccessTimesCalendarBaseDataManager : NSObject

- (void)updateResultWithNumber:(NSNumber*)aNumber iur:(NSNumber*)anIUR;
- (void)saveAccessTimesToDB:(NSString*)anAccessTimes iur:(NSNumber*)anIUR;

@end
