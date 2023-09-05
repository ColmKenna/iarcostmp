//
//  OrderHeaderTotalGraphViewController.h
//  Arcos
//
//  Created by David Kilmartin on 30/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "ModelViewDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CPTGraphHostingViewWithTouchEvent.h"
#import "ArcosUtils.h"
#import "ArcosCoreData.h"
#import "OrderHeaderTotalSetTargetViewController.h"
#import "OrderHeaderTotalGraphDataManager.h"
#import "OrderHeaderTotalGraphValueDataManager.h"
#import "OrderHeaderTotalGraphCountDataManager.h"
#import "PresentViewControllerDelegate.h"

@interface OrderHeaderTotalGraphViewController : UIViewController<CPTPlotSpaceDelegate,CPTPlotDataSource,CPTScatterPlotDelegate,CPTBarPlotDelegate,OrderHeaderTotalSetTargetDelegate> {
    id<ModelViewDelegate> _delegate;
    id<PresentViewControllerDelegate> _presentDelegate;
    UIView* allChartView;
    CPTGraphHostingView* weekLineChartView;
    CPTGraphHostingViewWithTouchEvent* monthPieChartView;
    CPTGraphHostingView* yearBarChartView;
    UIView* allTableView;
    CPTGraphHostingView* weekTableChartView;
    CPTGraphHostingView* monthTableChartView;
    CPTGraphHostingView* yearTableChartView;
    
    CPTScatterPlot* weekLineChart;
    CPTPieChart* monthPieChart;
    CPTBarPlot* yearBarChart;
    
    NSMutableDictionary* _theData;    
    UIScrollView* weekTableScrollView;
    UIScrollView* monthTableScrollView;
    UIScrollView* yearTableScrollView;
    
    UILabel* weekTarget;
    UILabel* monthTarget;
    UILabel* yearTarget;
    UILabel* weekActual;
    UILabel* monthActual;
    UILabel* yearActual;
    UILabel* weekDiff;
    UILabel* monthDiff;
    UILabel* yearDiff;
    UILabel* weekAchieved;
    UILabel* monthAchieved;
    UILabel* yearAchieved;
    UILabel* weekDayLeft;
    UILabel* monthDayLeft;
    UILabel* yearDayLeft;
    UILabel* weekRequired;
    UILabel* monthRequired;
    UILabel* yearRequired;
    
    UILabel* weekTargetTitleLabel;
    UILabel* monthTargetTitleLabel;
    UILabel* yearTargetTitleLabel;
    UILabel* weekActualTitleLabel;
    UILabel* monthActualTitleLabel;
    UILabel* yearActualTitleLabel;
    UILabel* weekDiffTitleLabel;
    UILabel* monthDiffTitleLabel;
    UILabel* yearDiffTitleLabel;
    UILabel* weekAchievedTitleLabel;
    UILabel* monthAchievedTitleLabel;
    UILabel* yearAchievedTitleLabel;
    UILabel* weekDayLeftTitleLabel;
    UILabel* monthDayLeftTitleLabel;
    UILabel* yearDayLeftTitleLabel;
    UILabel* weekRequiredTitleLabeld;
    UILabel* yearRequiredTitleLabel;
    
    CPTPlotSpaceAnnotation* symbolTextAnnotation;
    CPTPlotSpaceAnnotation* yearlySymbolTextAnnotation;
    
//    UIPopoverController* _targetPopoverController;
    OrderHeaderTotalSetTargetViewController* _ohtstvc;
    UIBarButtonItem* _setTargetButton;
    
    SettingManager* _settingManager;
    OrderHeaderTotalGraphDataManager* _dataManager;
    ExtendedSettingManager* _extendedSettingManager;
}

@property(nonatomic, assign) id<ModelViewDelegate> delegate;
@property(nonatomic, assign) id<PresentViewControllerDelegate> presentDelegate;
@property(nonatomic, retain) IBOutlet UIView* allChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* weekLineChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingViewWithTouchEvent* monthPieChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* yearBarChartView;
@property(nonatomic, retain) IBOutlet UIView* allTableView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* weekTableChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* monthTableChartView;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView* yearTableChartView;
@property(nonatomic, retain) CPTScatterPlot* weekLineChart;
@property(nonatomic, retain) CPTPieChart* monthPieChart;
@property(nonatomic, retain) CPTBarPlot* yearBarChart;
@property(nonatomic, retain) NSMutableDictionary* theData;
@property(nonatomic, retain) IBOutlet UIScrollView* weekTableScrollView;
@property(nonatomic, retain) IBOutlet UIScrollView* monthTableScrollView;
@property(nonatomic, retain) IBOutlet UIScrollView* yearTableScrollView;
@property(nonatomic, retain) IBOutlet UILabel* weekTarget;
@property(nonatomic, retain) IBOutlet UILabel* monthTarget;
@property(nonatomic, retain) IBOutlet UILabel* yearTarget;
@property(nonatomic, retain) IBOutlet UILabel* weekActual;
@property(nonatomic, retain) IBOutlet UILabel* monthActual;
@property(nonatomic, retain) IBOutlet UILabel* yearActual;
@property(nonatomic, retain) IBOutlet UILabel* weekDiff;
@property(nonatomic, retain) IBOutlet UILabel* monthDiff;
@property(nonatomic, retain) IBOutlet UILabel* yearDiff;
@property(nonatomic, retain) IBOutlet UILabel* weekAchieved;
@property(nonatomic, retain) IBOutlet UILabel* monthAchieved;
@property(nonatomic, retain) IBOutlet UILabel* yearAchieved;
@property(nonatomic, retain) IBOutlet UILabel* weekDayLeft;
@property(nonatomic, retain) IBOutlet UILabel* monthDayLeft;
@property(nonatomic, retain) IBOutlet UILabel* yearDayLeft;
@property(nonatomic, retain) IBOutlet UILabel* weekRequired;
@property(nonatomic, retain) IBOutlet UILabel* monthRequired;
@property(nonatomic, retain) IBOutlet UILabel* yearRequired;

@property(nonatomic, retain) IBOutlet UILabel* weekTargetTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthTargetTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearTargetTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* weekActualTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthActualTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearActualTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* weekDiffTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthDiffTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearDiffTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* weekAchievedTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthAchievedTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearAchievedTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* weekDayLeftTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthDayLeftTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearDayLeftTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* weekRequiredTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* monthRequiredTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* yearRequiredTitleLabel;

//@property(nonatomic, retain) UIPopoverController* targetPopoverController;
@property(nonatomic, retain) OrderHeaderTotalSetTargetViewController* ohtstvc;
@property(nonatomic, retain) UIBarButtonItem* setTargetButton;
@property(nonatomic, retain) SettingManager* settingManager;
@property(nonatomic, retain) OrderHeaderTotalGraphDataManager* dataManager;
@property(nonatomic, retain) ExtendedSettingManager* extendedSettingManager;

- (void)constructPieChart:(CPTGraphHostingView*)aGraphHostingView pieChart:(CPTPieChart*)aPieChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle;
- (void)constructTableChartWithType:(CPTGraphHostingView*)aCPTGraphHostingView title:(NSString*)aTitle;
- (void)resetDisplayLayout:(UIInterfaceOrientation)orientation;
- (void)constructOHLCLineChart:(CPTGraphHostingView*)aGraphHostingView lineChart:(CPTScatterPlot*)aLineChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle;
- (void)constructBarChart:(CPTGraphHostingView*)aGraphHostingView barChart:(CPTBarPlot*)aBarChart identifier:(NSString*)anIdentifier title:(NSString*)aTitle;
- (CPTMutableTextStyle*)textStyleWithFontSize:(float)aFontSize;
- (void)drawInitialTableChart:(CPTGraphHostingView*)aGraphHostingView scrollView:(UIScrollView*)aScrollView;
- (void)makeScrollViewScrollable:(UIScrollView*)aScrollView;
- (void)calculateDaysLeft:(NSDate*)aStartDate endDate:(NSDate*)anEndDate percentage:(float)aPercentage difference:(float)aDifference dayLeftLabel:(UILabel*)aDayLeftLabel requiredLabel:(UILabel*)aRequiredLabel;
- (void)setDifferenceLabelColor:(UILabel*)aDiffLabel diffValue:(float)aDiffValue;
- (void)createBasicAnalysisData;
- (void)createDataManagerCorrespondingly;
@end
