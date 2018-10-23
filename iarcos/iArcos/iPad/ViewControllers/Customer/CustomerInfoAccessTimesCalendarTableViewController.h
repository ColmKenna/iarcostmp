//
//  CustomerInfoAccessTimesCalendarTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 19/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoAccessTimesCalendarHeaderView.h"
#import "GenericSelectionCancelDelegate.h"
#import "CustomerInfoAccessTimesCalendarDataManager.h"
#import "CustomerInfoAccessTimesCalendarTableViewCell.h"
#import "CustomerInfoAccessTimesCalendarTableViewControllerDelegate.h"
#import "CallGenericServices.h"
typedef enum {
    AccessTimesCalendarTypeDefault = 0,
    AccessTimesCalendarTypeHomePage
} AccessTimesCalendarType;

@interface CustomerInfoAccessTimesCalendarTableViewController : UITableViewController <CustomerInfoAccessTimesCalendarTableViewCellDelegate, GetDataGenericDelegate>{
    id<GenericSelectionCancelDelegate> _cancelDelegate;
    id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> _actionDelegate;
    CustomerInfoAccessTimesCalendarHeaderView* _calendarHeaderView;
    CustomerInfoAccessTimesCalendarDataManager* _calendarDataManager;
    CallGenericServices* _callGenericServices;
    AccessTimesCalendarType _accessTimesCalendarType;
}

@property(nonatomic, assign) id<GenericSelectionCancelDelegate> cancelDelegate;
@property(nonatomic, assign) id<CustomerInfoAccessTimesCalendarTableViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet CustomerInfoAccessTimesCalendarHeaderView* calendarHeaderView;
@property(nonatomic, retain) CustomerInfoAccessTimesCalendarDataManager* calendarDataManager;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, assign) AccessTimesCalendarType accessTimesCalendarType;

@end
