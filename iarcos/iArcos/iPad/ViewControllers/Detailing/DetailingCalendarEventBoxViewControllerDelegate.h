//
//  DetailingCalendarEventBoxViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 25/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DetailingCalendarEventBoxViewControllerDelegate <NSObject>


- (NSString*)retrieveDetailingLocationName;
- (NSNumber*)retrieveDetailingLocationIUR;
- (NSNumber*)retrieveDetailingContactIUR;
- (NSString*)retrieveDetailingContactName;
- (void)didDismissViewProcessor;

@end

