//
//  CustomerCalendarListTableViewController.h
//  iArcos
//
//  Created by Richard on 04/04/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerBaseDetailViewController.h"
#import "MBProgressHUD.h"
#import "CustomerCalendarListDataManager.h"
#import "ArcosConstantsDataManager.h"
#import "CustomerCalendarListTableViewCell.h"
#import "CustomerInfoTableViewController.h"
#import "CustomerCalendarListHeaderView.h"
#import "ArcosNoBgSegmentedControl.h"
#import "DetailingCalendarEventBoxViewDataManager.h"
@class ArcosRootViewController;
#import "UtilitiesMailDataManager.h"
#import "CustomerCalendarListCallDataManager.h"
#import "CustomerCalendarListTableCellGenerator.h"
#import "CustomerCalendarListCallTableCellGenerator.h"

@interface CustomerCalendarListTableViewController : CustomerBaseDetailViewController <CheckLocationIURTemplateDelegate, GenericRefreshParentContentDelegate, ModalPresentViewControllerDelegate, ArcosCalendarEventEntryDetailTemplateViewControllerDelegate>{
    MBProgressHUD* _HUD;
    CustomerCalendarListDataManager* _customerCalendarListDataManager;
    ArcosNoBgSegmentedControl* _mySegmentedControl;
    CheckLocationIURTemplateProcessor* _checkLocationIURTemplateProcessor;
    CustomerCalendarListHeaderView* _customerCalendarListHeaderView;
    DetailingCalendarEventBoxViewDataManager* _detailingCalendarEventBoxViewDataManager;
    CustomerJourneyDataManager* _customerJourneyDataManager;
    CalendarUtilityDataManager* _calendarUtilityDataManager;
    ArcosRootViewController* _arcosRootViewController;
    UINavigationController* _globalNavigationController;
    UtilitiesMailDataManager* _utilitiesMailDataManager;
    CustomerCalendarListCallDataManager* _customerCalendarListCallDataManager;
    id<CustomerListingTableCellGeneratorDelegate> _customerListingTableCellGeneratorDelegate;
}

@property(nonatomic,retain) MBProgressHUD* HUD;
@property(nonatomic,retain) CustomerCalendarListDataManager* customerCalendarListDataManager;
@property(nonatomic,retain) ArcosNoBgSegmentedControl* mySegmentedControl;
@property (nonatomic, retain) CheckLocationIURTemplateProcessor* checkLocationIURTemplateProcessor;
@property (nonatomic, retain) IBOutlet CustomerCalendarListHeaderView* customerCalendarListHeaderView;
@property (nonatomic, retain) DetailingCalendarEventBoxViewDataManager* detailingCalendarEventBoxViewDataManager;
@property(nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
@property(nonatomic, retain) CalendarUtilityDataManager* calendarUtilityDataManager;
@property (nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UtilitiesMailDataManager* utilitiesMailDataManager;
@property (nonatomic, retain) CustomerCalendarListCallDataManager* customerCalendarListCallDataManager;
@property (nonatomic, retain) id<CustomerListingTableCellGeneratorDelegate> customerListingTableCellGeneratorDelegate;

@end

