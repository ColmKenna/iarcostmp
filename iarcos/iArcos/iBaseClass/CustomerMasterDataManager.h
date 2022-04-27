//
//  CustomerMasterDataManager.h
//  iArcos
//
//  Created by David Kilmartin on 08/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UtilitiesArcosSplitViewController;
#import "CustomerListingViewController.h"
#import "CustomerContactDetailViewController.h"
#import "MapViewController.h"

#import "ArcosStackedViewController.h"
#import "SavedOrderSplitViewController.h"
#import "ReporterMainViewController.h"
#import "CustomerWeeklyMainWrapperModalViewController.h"
#import "CustomerWeeklyMainModalViewController.h"
//#import "NewPresenterViewController.h"
#import "TemplateDashboardViewController.h"
#import "MainPresenterTableViewController.h"
#import "DashboardMainTemplateTableViewController.h"
#import "WeeklyMainTemplateViewController.h"
#import "TargetTableViewController.h"
#import "MeetingMainTemplateViewController.h"
#import "ReporterGroupMainTableViewController.h"
#import "DashboardServerViewController.h"
#import "ArcosCalendarTableViewController.h"

@interface CustomerMasterDataManager : NSObject {
    NSMutableArray* _displayList;
    UtilitiesArcosSplitViewController* _utilitiesArcosSplitViewController;
    MapViewController* _mapViewController;
    UINavigationController* _mapNavigationController;
    ArcosStackedViewController* _locationArcosStackedViewController;
    ArcosStackedViewController* _contactArcosStackedViewController;
    SavedOrderSplitViewController* _savedOrderSplitViewController;
    ReporterMainViewController* _reporterMainViewController;
    ReporterGroupMainTableViewController* _reporterGroupMainTableViewController;
    UINavigationController* _reporterNavigationController;
    CustomerWeeklyMainWrapperModalViewController* _customerWeeklyMainWrapperModalViewController;
    CustomerWeeklyMainModalViewController* _customerWeeklyMainModalViewController;
    UINavigationController* _customerWeeklyMainNavigationController;
    NSString* _dashboardText;
    NSString* _presenterText;
//    NewPresenterViewController* _mainNewPresenterViewController;
//    UINavigationController* _mainNewPresenterNavigationController;
    MainPresenterTableViewController* _mainPresenterTableViewController;
    UINavigationController* _mainPresenterNavigationController;
    NSString* _utilitiesText;
    TemplateDashboardViewController* _templateDashboardViewController;
    DashboardMainTemplateTableViewController* _dashboardMainTemplateTableViewController;
    UINavigationController* _dashboardMainTemplateNavigationController;
    DashboardServerViewController* _dashboardServerViewController;
    UINavigationController* _dashboardServerNavigationController;
    WeeklyMainTemplateViewController* _weeklyMainTemplateViewController;
    UINavigationController* _weeklyMainTemplateNavigationController;
    TargetTableViewController* _targetTableViewController;
    UINavigationController* _targetNavigationController;
    NSString* _targetText;
    MeetingMainTemplateViewController* _meetingMainTemplateViewController;
    UINavigationController* _meetingNavigationController;
    NSString* _meetingText;
    ArcosCalendarTableViewController* _arcosCalendarTableViewController;
    UINavigationController* _calendarNavigationController;
    NSString* _calendarText;
}

@property(nonatomic, retain) NSMutableArray* displayList;
@property(nonatomic, retain) UtilitiesArcosSplitViewController* utilitiesArcosSplitViewController;
@property(nonatomic, retain) MapViewController* mapViewController;
@property(nonatomic, retain) UINavigationController* mapNavigationController;
@property(nonatomic, retain) ArcosStackedViewController* locationArcosStackedViewController;
@property(nonatomic, retain) ArcosStackedViewController* contactArcosStackedViewController;
@property(nonatomic, retain) SavedOrderSplitViewController* savedOrderSplitViewController;
@property(nonatomic, retain) ReporterMainViewController* reporterMainViewController;
@property(nonatomic, retain) ReporterGroupMainTableViewController* reporterGroupMainTableViewController;
@property(nonatomic, retain) UINavigationController* reporterNavigationController;
@property(nonatomic, retain) CustomerWeeklyMainWrapperModalViewController* customerWeeklyMainWrapperModalViewController;
@property(nonatomic, retain) CustomerWeeklyMainModalViewController* customerWeeklyMainModalViewController;
@property(nonatomic, retain) UINavigationController* customerWeeklyMainNavigationController;
@property(nonatomic, retain) NSString* dashboardText;
@property(nonatomic, retain) NSString* presenterText;
//@property(nonatomic, retain) NewPresenterViewController* mainNewPresenterViewController;
//@property(nonatomic, retain) UINavigationController* mainNewPresenterNavigationController;
@property(nonatomic, retain) MainPresenterTableViewController* mainPresenterTableViewController;
@property(nonatomic, retain) UINavigationController* mainPresenterNavigationController;
@property(nonatomic, retain) NSString* utilitiesText;
@property(nonatomic, retain) TemplateDashboardViewController* templateDashboardViewController;
@property(nonatomic, retain) DashboardMainTemplateTableViewController*  dashboardMainTemplateTableViewController;
@property(nonatomic, retain) UINavigationController* dashboardMainTemplateNavigationController;
@property(nonatomic, retain) DashboardServerViewController* dashboardServerViewController;
@property(nonatomic, retain) UINavigationController* dashboardServerNavigationController;
@property(nonatomic, retain) WeeklyMainTemplateViewController* weeklyMainTemplateViewController;
@property(nonatomic, retain) UINavigationController* weeklyMainTemplateNavigationController;
@property(nonatomic, retain) TargetTableViewController* targetTableViewController;
@property(nonatomic, retain) UINavigationController* targetNavigationController;
@property(nonatomic, retain) NSString* targetText;
@property(nonatomic, retain) MeetingMainTemplateViewController* meetingMainTemplateViewController;
@property(nonatomic, retain) UINavigationController* meetingNavigationController;
@property(nonatomic, retain) NSString* meetingText;
@property(nonatomic, retain) ArcosCalendarTableViewController* arcosCalendarTableViewController;
@property(nonatomic, retain) UINavigationController* calendarNavigationController;
@property(nonatomic, retain) NSString* calendarText;

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile;
- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomController:(UIViewController*)aViewController;
- (int)retrieveIndexByTitle:(NSString*)title;
- (NSString*)retrieveTitleByIndex:(int)anIndex;

@end
