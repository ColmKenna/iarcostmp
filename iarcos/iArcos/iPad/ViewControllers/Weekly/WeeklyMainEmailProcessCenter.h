//
//  WeeklyMainEmailProcessCenter.h
//  iArcos
//
//  Created by David Kilmartin on 29/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeeklyMainTemplateDataManager.h"

@interface WeeklyMainEmailProcessCenter : NSObject

- (NSString*)buildEmailMessageWithDataManager:(WeeklyMainTemplateDataManager*)aWeeklyMainTemplateDataManager;

@end
