//
//  SubMenuListingTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 05/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubMenuTableViewController.h"
#import "CustomerMasterTabBarItemTableCell.h"
#import "CustomerMasterBottomTabBarItemTableCell.h"
#import "NewOrderViewController.h"
#import "DetailingTableViewController.h"
#import "NewPresenterViewController.h"
#import "CustomerSurveyViewController.h"
#import "CoreLocationController.h"
#import "SubMenuListingDataManager.h"
#import "MainPresenterTableViewController.h"
#import "CustomerJourneyAppointmentViewController.h"

@interface SubMenuListingTableViewController : SubMenuTableViewController<SubMenuTableViewControllerDelegate, CoreLocationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ModalPresentViewControllerDelegate> {
    NewOrderViewController* _myNewOrderViewController;
    UINavigationController* _myNewOrderNavigationController;
    DetailingTableViewController* _detailingTableViewController;
    UINavigationController* _detailingTableNavigationController;
//    NewPresenterViewController* _myNewPresenterViewController;
//    UINavigationController* _myNewPresenterNavigationController;
    MainPresenterTableViewController* _mainPresenterTableViewController;
    UINavigationController* _mainPresenterNavigationController;
    CustomerSurveyViewController* _customerSurveyViewController;
    UINavigationController* _customerSurveyNavigationController;
    NSString* _orderTitle;
    NSString* _presenterTitle;
    NSString* _callTitle;
    NSString* _surveyTitle;
    NSString* _myCustomControllerTitle;
    NSString* _mapTitle;
    NSString* _photosTitle;
    NSString* _appointmentTitle;
    NSMutableDictionary* _ruleoutTitleDict;
    CoreLocationController* _CLController;
    SubMenuListingDataManager* _subMenuListingDataManager;
    BOOL _locationCoordinateCaptured;
    UIImagePickerController* _imagePicker;
}

@property(nonatomic, retain) NewOrderViewController* myNewOrderViewController;
@property(nonatomic, retain) UINavigationController* myNewOrderNavigationController;
@property(nonatomic, retain) DetailingTableViewController* detailingTableViewController;
@property(nonatomic, retain) UINavigationController* detailingTableNavigationController;
//@property(nonatomic, retain) NewPresenterViewController* myNewPresenterViewController;
//@property(nonatomic, retain) UINavigationController* myNewPresenterNavigationController;
@property(nonatomic, retain) MainPresenterTableViewController* mainPresenterTableViewController;
@property(nonatomic, retain) UINavigationController* mainPresenterNavigationController;
@property(nonatomic, retain) CustomerSurveyViewController* customerSurveyViewController;
@property(nonatomic, retain) UINavigationController* customerSurveyNavigationController;
@property(nonatomic, retain) NSString* orderTitle;
@property(nonatomic, retain) NSString* presenterTitle;
@property(nonatomic, retain) NSString* callTitle;
@property(nonatomic, retain) NSString* surveyTitle;
@property(nonatomic, retain) NSString* myCustomControllerTitle;
@property(nonatomic, retain) NSString* mapTitle;
@property(nonatomic, retain) NSString* photosTitle;
@property(nonatomic, retain) NSString* appointmentTitle;
@property(nonatomic, retain) NSMutableDictionary* ruleoutTitleDict;
@property(nonatomic, retain) CoreLocationController* CLController;
@property(nonatomic, retain) SubMenuListingDataManager* subMenuListingDataManager;
@property(nonatomic, assign) BOOL locationCoordinateCaptured;
@property(nonatomic, retain) UIImagePickerController* imagePicker;

@end
