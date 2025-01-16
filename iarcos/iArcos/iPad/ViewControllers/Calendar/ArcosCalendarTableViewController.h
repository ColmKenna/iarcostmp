//
//  ArcosCalendarTableViewController.h
//  iArcos
//
//  Created by Richard on 15/03/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosCalendarTableDataManager.h"
#import "ArcosCalendarTableViewCell.h"
#import "ArcosCalendarTableHeaderView.h"
@class ArcosRootViewController;
#import "MBProgressHUD.h"
#import "ArcosCalendarEventEntryDetailTableViewController.h"
#import "ArcosService.h"
#import "ArcosCalendarEventEntryDetailTemplateViewController.h"
#import "CustomerJourneyDataManager.h"
#import "CalendarUtilityDataManager.h"
#import "DetailingCalendarEventBoxViewDataManager.h"

@interface ArcosCalendarTableViewController : UIViewController <ArcosCalendarTableViewCellDelegate, ModalPresentViewControllerDelegate, ArcosCalendarEventEntryDetailTemplateViewControllerDelegate, ArcosCalendarCellBaseTableViewDataManagerDelegate, UITableViewDelegate, UITableViewDataSource, ArcosCalendarEventEntryDetailListingDataManagerDelegate>{
    ArcosCalendarTableDataManager* _arcosCalendarTableDataManager;
    ArcosCalendarTableHeaderView* _arcosCalendarTableHeaderView;
    ArcosRootViewController* _arcosRootViewController;
    MBProgressHUD* _HUD;
    ArcosService* _arcosService;
    CustomerJourneyDataManager* _customerJourneyDataManager;
    UINavigationController* _globalNavigationController;
    UtilitiesMailDataManager* _utilitiesMailDataManager;
    UITableView* _myTableView;
    UIView* _listingTemplateView;
    UILabel* _listingTitleLabel;
    UITableView* _listingTableView;
    ArcosCalendarEventEntryDetailListingDataManager* _arcosCalendarEventEntryDetailListingDataManager;
    CalendarUtilityDataManager* _calendarUtilityDataManager;
    DetailingCalendarEventBoxViewDataManager* _detailingCalendarEventBoxViewDataManager;
}

@property(nonatomic, retain) ArcosCalendarTableDataManager* arcosCalendarTableDataManager;
@property(nonatomic, retain) IBOutlet ArcosCalendarTableHeaderView* arcosCalendarTableHeaderView;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) ArcosService* arcosService;
@property(nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UtilitiesMailDataManager* utilitiesMailDataManager;
@property(nonatomic, retain) IBOutlet UITableView* myTableView;
@property(nonatomic, retain) IBOutlet UIView* listingTemplateView;
@property(nonatomic, retain) IBOutlet UILabel* listingTitleLabel;
@property(nonatomic, retain) IBOutlet UITableView* listingTableView;
@property(nonatomic, retain) ArcosCalendarEventEntryDetailListingDataManager* arcosCalendarEventEntryDetailListingDataManager;
@property(nonatomic, retain) CalendarUtilityDataManager* calendarUtilityDataManager;
@property(nonatomic, retain) DetailingCalendarEventBoxViewDataManager* detailingCalendarEventBoxViewDataManager;

@end


