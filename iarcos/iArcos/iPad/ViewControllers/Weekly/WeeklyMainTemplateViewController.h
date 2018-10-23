//
//  WeeklyMainTemplateViewController.h
//  iArcos
//
//  Created by David Kilmartin on 21/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "CustomerWeeklyMainModalViewController.h"
#import "WeeklyDayPartsViewController.h"
#import "WeeklyMainTemplateDataManager.h"
@class ArcosRootViewController;
#import "WeeklyMainEmailProcessCenter.h"
#import "CallGenericServices.h"
#import "ArcosMailWrapperViewController.h"

@interface WeeklyMainTemplateViewController : UIViewController <WidgetViewControllerDelegate, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GetDataGenericDelegate, ArcosMailTableViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
//    UIView* _childTemplateView;
    CustomerWeeklyMainModalViewController* _cwmmvc;
    WeeklyDayPartsViewController* _weeklyDayPartsViewController;
    NSDictionary* _layoutDict;
    WeeklyMainTemplateDataManager* _weeklyMainTemplateDataManager;
    UIBarButtonItem* _employeeButton;
    UIBarButtonItem* _cameraRollButton;
    TableWidgetViewController* _employeeTableWidgetViewController;
    UIImagePickerController* _cameraRollImagePickerController;
    CallGenericServices* _callGenericServices;
    UINavigationController* _globalNavigationController;
    ArcosRootViewController* _arcosRootViewController;
    WeeklyMainEmailProcessCenter* _weeklyMainEmailProcessCenter;
    MFMailComposeViewController* _mailComposeViewController;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
//@property(nonatomic, retain) IBOutlet UIView* childTemplateView;
@property(nonatomic, retain) CustomerWeeklyMainModalViewController* cwmmvc;
@property(nonatomic, retain) WeeklyDayPartsViewController* weeklyDayPartsViewController;
@property(nonatomic, retain) NSDictionary* layoutDict;
@property(nonatomic, retain) WeeklyMainTemplateDataManager* weeklyMainTemplateDataManager;
@property(nonatomic, retain) UIBarButtonItem* employeeButton;
@property(nonatomic, retain) UIBarButtonItem* cameraRollButton;
@property(nonatomic, retain) TableWidgetViewController* employeeTableWidgetViewController;
@property(nonatomic, retain) UIImagePickerController* cameraRollImagePickerController;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, retain) WeeklyMainEmailProcessCenter* weeklyMainEmailProcessCenter;
@property(nonatomic, retain) MFMailComposeViewController* mailComposeViewController;

@end
