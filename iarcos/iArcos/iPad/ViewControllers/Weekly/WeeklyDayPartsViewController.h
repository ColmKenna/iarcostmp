//
//  WeeklyDayPartsViewController.h
//  iArcos
//
//  Created by David Kilmartin on 21/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableWidgetViewController.h"
#import "WeeklyDayPartsDataManager.h"
#import "WeeklyMainTemplateDataManager.h"
#import <QuartzCore/QuartzCore.h>

@interface WeeklyDayPartsViewController : UIViewController <WidgetViewControllerDelegate> {
    WeeklyMainTemplateDataManager* _weeklyMainTemplateDataManager;
    UILabel* _headingDesc;
    UIView* _headingTemplateAM;
    UIView* _headingChildTemplateAM;
    UIButton* _headingButtonAM;
    UILabel* _headingAM;
    UILabel* _headingSpace;
    
    UIView* _headingTemplatePM;
    UIView* _headingChildTemplatePM;
    UIButton* _headingButtonPM;
    UILabel* _headingPM;
    UIView* _headingView;
    
    UIView* _weekdayTemplateView;
    
    UILabel* _mondayDesc;
    UILabel* _mondayAM;
    UILabel* _mondaySpace;
    UILabel* _mondayPM;
    UIView* _mondayView;
    UIView* _mondayTemplateView;
    
    UILabel* _tuesdayDesc;
    UILabel* _tuesdayAM;
    UILabel* _tuesdaySpace;
    UILabel* _tuesdayPM;
    UIView* _tuesdayView;
    UIView* _tuesdayTemplateView;
    
    UILabel* _wednesdayDesc;
    UILabel* _wednesdayAM;
    UILabel* _wednesdaySpace;
    UILabel* _wednesdayPM;
    UIView* _wednesdayView;
    UIView* _wednesdayTemplateView;
    
    UILabel* _thursdayDesc;
    UILabel* _thursdayAM;
    UILabel* _thursdaySpace;
    UILabel* _thursdayPM;
    UIView* _thursdayView;
    UIView* _thursdayTemplateView;
    
    UILabel* _fridayDesc;
    UILabel* _fridayAM;
    UILabel* _fridaySpace;
    UILabel* _fridayPM;
    UIView* _fridayView;
    UIView* _fridayTemplateView;
    
    UILabel* _saturdayDesc;
    UILabel* _saturdayAM;
    UILabel* _saturdaySpace;
    UILabel* _saturdayPM;
    UIView* _saturdayView;
    UIView* _saturdayTemplateView;
    
    UILabel* _sundayDesc;
    UILabel* _sundayAM;
    UILabel* _sundaySpace;
    UILabel* _sundayPM;
    UIView* _sundayView;
    UIView* _sundayTemplateView;
    
    UILabel* _footerThisWeekHeading;
    UILabel* _footerHeadingSpace;
    UILabel* _footerMonthToDateHeading;
    UILabel* _footerOnTerritoryDesc;
    UILabel* _footerOnTerritoryThisWeekFigure;
    UILabel* _footerOnTerritorySpace;
    UILabel* _footerOnTerritoryMonthToDateFigure;
    UILabel* _footerOffTerritoryDesc;
    UILabel* _footerOffTerritoryThisWeekFigure;
    UILabel* _footerOffTerritorySpace;
    UILabel* _footerOffTerritoryMonthToDateFigure;
    
    UIView* _footerView;
    
    UILabel* _currentLabel;
    NSMutableArray* _labelList;
    NSMutableArray* _viewList;
    WeeklyDayPartsDataManager* _weeklyDayPartsDataManager;
    NSMutableArray* _weeklyDayPartsLabelDictList;
}

@property(nonatomic, retain) WeeklyMainTemplateDataManager* weeklyMainTemplateDataManager;
@property(nonatomic, retain) IBOutlet UILabel* headingDesc;
@property(nonatomic, retain) IBOutlet UIView* headingTemplateAM;
@property(nonatomic, retain) IBOutlet UIView* headingChildTemplateAM;
@property(nonatomic, retain) IBOutlet UIButton* headingButtonAM;
@property(nonatomic, retain) IBOutlet UILabel* headingAM;
@property(nonatomic, retain) IBOutlet UILabel* headingSpace;
@property(nonatomic, retain) IBOutlet UIView* headingTemplatePM;
@property(nonatomic, retain) IBOutlet UIView* headingChildTemplatePM;
@property(nonatomic, retain) IBOutlet UIButton* headingButtonPM;
@property(nonatomic, retain) IBOutlet UILabel* headingPM;
@property(nonatomic, retain) IBOutlet UIView* headingView;

@property(nonatomic, retain) IBOutlet UIView* weekdayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* mondayDesc;
@property(nonatomic, retain) IBOutlet UILabel* mondayAM;
@property(nonatomic, retain) IBOutlet UILabel* mondaySpace;
@property(nonatomic, retain) IBOutlet UILabel* mondayPM;
@property(nonatomic, retain) IBOutlet UIView* mondayView;
@property(nonatomic, retain) IBOutlet UIView* mondayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* tuesdayDesc;
@property(nonatomic, retain) IBOutlet UILabel* tuesdayAM;
@property(nonatomic, retain) IBOutlet UILabel* tuesdaySpace;
@property(nonatomic, retain) IBOutlet UILabel* tuesdayPM;
@property(nonatomic, retain) IBOutlet UIView* tuesdayView;
@property(nonatomic, retain) IBOutlet UIView* tuesdayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* wednesdayDesc;
@property(nonatomic, retain) IBOutlet UILabel* wednesdayAM;
@property(nonatomic, retain) IBOutlet UILabel* wednesdaySpace;
@property(nonatomic, retain) IBOutlet UILabel* wednesdayPM;
@property(nonatomic, retain) IBOutlet UIView* wednesdayView;
@property(nonatomic, retain) IBOutlet UIView* wednesdayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* thursdayDesc;
@property(nonatomic, retain) IBOutlet UILabel* thursdayAM;
@property(nonatomic, retain) IBOutlet UILabel* thursdaySpace;
@property(nonatomic, retain) IBOutlet UILabel* thursdayPM;
@property(nonatomic, retain) IBOutlet UIView* thursdayView;
@property(nonatomic, retain) IBOutlet UIView* thursdayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* fridayDesc;
@property(nonatomic, retain) IBOutlet UILabel* fridayAM;
@property(nonatomic, retain) IBOutlet UILabel* fridaySpace;
@property(nonatomic, retain) IBOutlet UILabel* fridayPM;
@property(nonatomic, retain) IBOutlet UIView* fridayView;
@property(nonatomic, retain) IBOutlet UIView* fridayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* saturdayDesc;
@property(nonatomic, retain) IBOutlet UILabel* saturdayAM;
@property(nonatomic, retain) IBOutlet UILabel* saturdaySpace;
@property(nonatomic, retain) IBOutlet UILabel* saturdayPM;
@property(nonatomic, retain) IBOutlet UIView* saturdayView;
@property(nonatomic, retain) IBOutlet UIView* saturdayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* sundayDesc;
@property(nonatomic, retain) IBOutlet UILabel* sundayAM;
@property(nonatomic, retain) IBOutlet UILabel* sundaySpace;
@property(nonatomic, retain) IBOutlet UILabel* sundayPM;
@property(nonatomic, retain) IBOutlet UIView* sundayView;
@property(nonatomic, retain) IBOutlet UIView* sundayTemplateView;

@property(nonatomic, retain) IBOutlet UILabel* footerThisWeekHeading;
@property(nonatomic, retain) IBOutlet UILabel* footerHeadingSpace;
@property(nonatomic, retain) IBOutlet UILabel* footerMonthToDateHeading;
@property(nonatomic, retain) IBOutlet UILabel* footerOnTerritoryDesc;
@property(nonatomic, retain) IBOutlet UILabel* footerOnTerritoryThisWeekFigure;
@property(nonatomic, retain) IBOutlet UILabel* footerOnTerritorySpace;
@property(nonatomic, retain) IBOutlet UILabel* footerOnTerritoryMonthToDateFigure;
@property(nonatomic, retain) IBOutlet UILabel* footerOffTerritoryDesc;
@property(nonatomic, retain) IBOutlet UILabel* footerOffTerritoryThisWeekFigure;
@property(nonatomic, retain) IBOutlet UILabel* footerOffTerritorySpace;
@property(nonatomic, retain) IBOutlet UILabel* footerOffTerritoryMonthToDateFigure;
@property(nonatomic, retain) IBOutlet UIView* footerView;

@property(nonatomic, retain) UILabel* currentLabel;
@property(nonatomic, retain) NSMutableArray* labelList;
@property(nonatomic, retain) NSMutableArray* viewList;
@property(nonatomic, retain) WeeklyDayPartsDataManager* weeklyDayPartsDataManager;
@property(nonatomic, retain) NSMutableArray* weeklyDayPartsLabelDictList;

- (void)reloadDayPartsData;
- (void)reloadDayPartsDescAndTag;

@end
