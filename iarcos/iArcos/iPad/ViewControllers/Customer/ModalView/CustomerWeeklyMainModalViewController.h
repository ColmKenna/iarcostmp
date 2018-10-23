//
//  CustomerWeeklyMainModalViewController.h
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ModelViewDelegate.h"
#import "ArcosUtils.h"
//#import "SettingManager.h"
//#import "ArcosCoreData.h"
#import "CustomerWeeklyMainTableCell.h"
//#import "CallGenericServices.h"
//#import "ConnectivityCheck.h"
//#import "CustomerWeeklyMainDataManager.h"
//#import "GenericTextViewInputTableCellDelegate.h"
//#import "WidgetFactory.h"
//#import "ArcosEmailValidator.h"
//#import "CustomerWeeklyEmailProcessCenter.h"
//@class ArcosRootViewController;
//#import "ArcosMailWrapperViewController.h"
#import "WeeklyMainTemplateDataManager.h"

//typedef enum {
//    WeeklyInputRequestSourceDefault = 0,
//    WeeklyInputRequestSourceDashboard
//} WeeklyInputRequestSource;

@interface CustomerWeeklyMainModalViewController : UITableViewController<GenericTextViewInputTableCellDelegate> {
    WeeklyMainTemplateDataManager* _weeklyMainTemplateDataManager;
//    id<ModelViewDelegate> delegate;
//    NSString* _dateFormat;
//    NSDate* _currentSundayDate;
//    NSNumber* _employeeIUR;
//    NSString* _employeeName;
//    NSMutableArray* _sectionTitleDictList;
//    CallGenericServices* callGenericServices;
//    ConnectivityCheck* connectivityCheck;
//    CustomerWeeklyMainDataManager* _customerWeeklyMainDataManager;
    IBOutlet UITableView* weeklyTableList;
//    ArcosCreateRecordObject* arcosCreateRecordObject;
//    int rowPointer;
//    NSDate* _highestAllowedSundayDate;
//    NSNumber* _dayOfWeekend;
//    NSDate* _currentWeekendDate;
//    NSDate* _highestAllowedWeekendDate;
    
//    NSMutableArray* _employeeDetailList;
//    NSDictionary* _employeeDict;
//    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
//    NSString* _parentContentString;
//    UIBarButtonItem* employeeButton;
//    UINavigationController* _globalNavigationController;
//    ArcosRootViewController* _rootView;
//    MFMailComposeViewController* _mailComposeViewController;
//    CustomerWeeklyEmailProcessCenter* _customerWeeklyEmailProcessCenter;
//    UIBarButtonItem* _cameraRollButton;
//    UIPopoverController* _cameraRollPopover;
//    WeeklyInputRequestSource _weeklyInputRequestSource;
}

@property(nonatomic, retain) WeeklyMainTemplateDataManager* weeklyMainTemplateDataManager;
//@property(nonatomic, assign) id<ModelViewDelegate> delegate;
//@property(nonatomic, retain) NSString* dateFormat;
//@property(nonatomic, retain) NSDate* currentSundayDate;
//@property(nonatomic, retain) NSNumber* employeeIUR;
//@property(nonatomic, retain) NSString* employeeName;
//@property(nonatomic, retain) NSMutableArray* sectionTitleDictList;
//@property(nonatomic, retain) CustomerWeeklyMainDataManager* customerWeeklyMainDataManager;
@property(nonatomic, retain) IBOutlet UITableView* weeklyTableList;
//@property(nonatomic, retain) NSDate* highestAllowedSundayDate;
//@property(nonatomic, retain) NSNumber* dayOfWeekend;
//@property(nonatomic, retain) NSDate* currentWeekendDate;
//@property(nonatomic, retain) NSDate* highestAllowedWeekendDate;
//@property(nonatomic, retain) NSMutableArray* employeeDetailList;
//@property(nonatomic, retain) NSDictionary* employeeDict;
//@property(nonatomic,retain) WidgetFactory* factory;
//@property(nonatomic,retain) UIPopoverController* thePopover;
//@property(nonatomic,retain) NSString* parentContentString;
//@property (nonatomic, retain) UINavigationController* globalNavigationController;
//@property (nonatomic, retain) ArcosRootViewController* rootView;
//@property(nonatomic,retain) MFMailComposeViewController* mailComposeViewController;
//@property(nonatomic,retain) CustomerWeeklyEmailProcessCenter* customerWeeklyEmailProcessCenter;
//@property(nonatomic,retain) UIBarButtonItem* cameraRollButton;
//@property(nonatomic,retain) UIPopoverController* cameraRollPopover;
//@property(nonatomic, assign) WeeklyInputRequestSource weeklyInputRequestSource;

//-(void)queryWeeklyRecord:(NSDate*)aCurrentWeekendDate;
//-(void)createWeeklyRecord;
//-(void)updateWeeklyRecord;
//-(NSNumber*)getDayOfWeekend;
//-(NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend;
//-(NSDate*)prevWeekend:(NSDate*)aCurrentWeekendDate;
//-(NSDate*)nextWeekend:(NSDate*)aCurrentWeekendDate;

@end
