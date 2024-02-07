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

@interface DetailingCalendarEventBoxViewController : UIViewController <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    id<DetailingCalendarEventBoxViewControllerDelegate> _actionDelegate;
    UIView* _templateView;
    UILabel* _journeyDateDesc;
    UILabel* _journeyDateValue;
    UILabel* _calendarDateDesc;
    UILabel* _calendarDateValue;
    
    UIBarButtonItem* _myBarButtonItem;
    UINavigationItem* _myNavigationItem;
    UINavigationBar* _myNavigationBar;
    
    DetailingCalendarEventBoxViewDataManager* _detailingCalendarEventBoxViewDataManager;
    MBProgressHUD* _HUD;
    WidgetFactory* _widgetFactory;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, assign) id<DetailingCalendarEventBoxViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) IBOutlet UILabel* journeyDateDesc;
@property(nonatomic, retain) IBOutlet UILabel* journeyDateValue;
@property(nonatomic, retain) IBOutlet UILabel* calendarDateDesc;
@property(nonatomic, retain) IBOutlet UILabel* calendarDateValue;

@property(nonatomic,retain) IBOutlet UIBarButtonItem* myBarButtonItem;
@property(nonatomic,retain) IBOutlet UINavigationItem* myNavigationItem;
@property(nonatomic,retain) IBOutlet UINavigationBar* myNavigationBar;
@property(nonatomic,retain) DetailingCalendarEventBoxViewDataManager* detailingCalendarEventBoxViewDataManager;
@property(nonatomic,retain) MBProgressHUD* HUD;
@property(nonatomic,retain) WidgetFactory* widgetFactory;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;


- (IBAction)saveToCalendarButtonPressed;

@end


