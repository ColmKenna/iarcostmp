//
//  DetailingCalendarEventBoxViewController.h
//  iArcos
//
//  Created by Richard on 25/01/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailingCalendarEventBoxViewControllerDelegate.h"
#import "ArcosCoreData.h"
#import "DetailingCalendarEventBoxViewDataManager.h"
#import "MBProgressHUD.h"
#import "ArcosConstantsDataManager.h"
#import "WidgetFactory.h"
#import "ArcosCalendarEventEntryDetailListingTableViewCell.h"
#import "ArcosCalendarEventEntryDetailTemplateViewController.h"
#import "DetailingCalendarEventBoxListingDataManager.h"
@class ArcosRootViewController;

@interface DetailingCalendarEventBoxViewController : UIViewController <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource, ModalPresentViewControllerDelegate, ArcosCalendarEventEntryDetailTemplateViewControllerDelegate, DetailingCalendarEventBoxListingDataManagerDelegate> {
    id<DetailingCalendarEventBoxViewControllerDelegate> _actionDelegate;
    UIView* _templateView;
    UIView* _auxBodyBackgroundView;
    UIView* _auxFooterBackgroundView;
    UILabel* _journeyDateDesc;
    UILabel* _journeyDateValue;
    UILabel* _nextAppointmentDesc;
    UILabel* _nextAppointmentValue;
    UILabel* _calendarDateDesc;
    UILabel* _calendarDateValue;
    UIDatePicker* _calendarDatePicker;
    
    UIBarButtonItem* _myBarButtonItem;
    UINavigationItem* _myNavigationItem;
    UINavigationBar* _myNavigationBar;
    
    UIView* _listingView;
    UINavigationBar* _listingNavigationBar;
    UITableView* _listingTableView;
    
    DetailingCalendarEventBoxViewDataManager* _detailingCalendarEventBoxViewDataManager;
    MBProgressHUD* _HUD;
    WidgetFactory* _widgetFactory;
    WidgetViewController* _globalWidgetViewController;
    UIBarButtonItem* _addEventBarButtonItem;
    UIButton* _updateButton;
    UIButton* _cancelButton;
    DetailingCalendarEventBoxListingDataManager* _detailingCalendarEventBoxListingDataManager;
    ArcosRootViewController* _arcosRootViewController;
    UINavigationController* _globalNavigationController;
    UIButton* _imageButton;
}

@property(nonatomic, assign) id<DetailingCalendarEventBoxViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UIView* auxBodyBackgroundView;
@property(nonatomic, retain) IBOutlet UIView* auxFooterBackgroundView;
@property(nonatomic, retain) IBOutlet UILabel* journeyDateDesc;
@property(nonatomic, retain) IBOutlet UILabel* journeyDateValue;
@property(nonatomic, retain) IBOutlet UILabel* nextAppointmentDesc;
@property(nonatomic, retain) IBOutlet UILabel* nextAppointmentValue;
@property(nonatomic, retain) IBOutlet UILabel* calendarDateDesc;
@property(nonatomic, retain) IBOutlet UILabel* calendarDateValue;
@property(nonatomic, retain) IBOutlet UIDatePicker* calendarDatePicker;

@property(nonatomic,retain) IBOutlet UIBarButtonItem* myBarButtonItem;
@property(nonatomic,retain) IBOutlet UINavigationItem* myNavigationItem;
@property(nonatomic,retain) IBOutlet UINavigationBar* myNavigationBar;

@property(nonatomic,retain) IBOutlet UIView* listingView;
@property(nonatomic,retain) IBOutlet UINavigationBar* listingNavigationBar;
@property(nonatomic,retain) IBOutlet UITableView* listingTableView;

@property(nonatomic,retain) DetailingCalendarEventBoxViewDataManager* detailingCalendarEventBoxViewDataManager;
@property(nonatomic,retain) MBProgressHUD* HUD;
@property(nonatomic,retain) WidgetFactory* widgetFactory;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic,retain) IBOutlet UIBarButtonItem* addEventBarButtonItem;
@property(nonatomic,retain) IBOutlet UIButton* updateButton;
@property(nonatomic,retain) IBOutlet UIButton* cancelButton;
@property (nonatomic, retain) DetailingCalendarEventBoxListingDataManager* detailingCalendarEventBoxListingDataManager;
@property (nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) IBOutlet UIButton* imageButton;

- (IBAction)saveToCalendarButtonPressed;
- (IBAction)dateComponentPicked:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end


