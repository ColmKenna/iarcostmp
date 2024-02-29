//
//  ArcosCalendarEventEntryDetailTableViewControllerDelegate.h
//  iArcos
//
//  Created by Richard on 30/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ArcosCalendarEventEntryDetailTableViewControllerDelegate <NSObject>


//- (void)refreshCalendarTableViewController;
- (void)deleteButtonPressedDelegate;
- (UITableView*)retrieveEventTableView;
- (UIViewController*)retrieveArcosCalendarEventEntryDetailTemplateViewController;
- (void)refreshTableRightHandSideBarWithDate:(NSDate*)aDate;
- (void)retrieveOneDayCalendarEventEntriesWithDate:(NSDate*)aStartDate;

@end

