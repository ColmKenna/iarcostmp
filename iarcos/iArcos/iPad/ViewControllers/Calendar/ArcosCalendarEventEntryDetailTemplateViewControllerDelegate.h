//
//  ArcosCalendarEventEntryDetailTemplateViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 01/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarEventEntryDetailTemplateViewControllerDelegate <NSObject>

- (void)refreshCalendarTableViewController;
- (NSString*)retrieveLocationUriTemplateDelegate;
- (NSNumber*)retrieveLocationIURTemplateDelegate;

@end

