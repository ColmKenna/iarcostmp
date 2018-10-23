//
//  ReporterMainViewController.h
//  Arcos
//
//  Created by David Kilmartin on 06/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CallGenericServices.h"
#import "ArcosUtils.h"
#import "ReporterTableViewCell.h"
#import "ArcosCoreData.h"
#import "ArcosCustomiseAnimation.h"
#import "ReportGenericUITableViewController.h"
#import "ReportParser.h"
#import "ReportManager.h"
#import "ReportTableViewController.h"
#import "ReportExcelViewController.h"
#import "ReporterFileManager.h"
#import "ReporterExcelQLPreviewController.h"
#import "ReporterMainDataManager.h"
#import "ReporterTrackGraphViewController.h"
#import "ArcosSystemCodesUtils.h"

@interface ReporterMainViewController : UITableViewController <GetDataGenericDelegate,ReportManagerDelegate, ReporterFileDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, ArcosQLPreviewControllerDelegate, ReporterTableViewCellDelegate> {
    IBOutlet UITableView* reportListView;    
//    NSMutableArray* displayList;
    CallGenericServices* _callGenericServices;
    
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    ArcosCustomiseAnimation* arcosCustomiseAnimation;
    ReportGenericUITableViewController* _reportGenericUITableViewController;
    MBProgressHUD* _HUD;
    
    //report code
    NSString* _selectedReportCode;
    NSString* _reportTitle;
    
    BOOL isReportSet;
    ReportManager* _reportManager;
    ReporterFileManager* _reporterFileManager;
    ReporterExcelQLPreviewController* _reporterExcelQLPreviewController;
    
    NSDate* _startCalculateDate;
    NSDate* _endCalculateDate;
    ReporterMainDataManager* _reporterMainDataManager;
}

@property (nonatomic,retain)  IBOutlet UITableView* reportListView;
//@property (nonatomic,retain)  NSMutableArray* displayList;
@property (nonatomic,retain) CallGenericServices* callGenericServices;

@property(nonatomic, retain) UINavigationController* globalNavigationController;
@property(nonatomic, retain) UIViewController* rootView;
@property(nonatomic, retain) ReportGenericUITableViewController* reportGenericUITableViewController;
@property(nonatomic, retain) MBProgressHUD* HUD;
@property(nonatomic, retain) NSString* selectedReportCode;
@property(nonatomic, retain) NSString* reportTitle;
@property(nonatomic, retain) ReportManager* reportManager;
@property (nonatomic,retain) ReporterFileManager* reporterFileManager;
@property (nonatomic,retain) ReporterExcelQLPreviewController* reporterExcelQLPreviewController;
@property (nonatomic,retain) NSDate* startCalculateDate;
@property (nonatomic,retain) NSDate* endCalculateDate;
@property (nonatomic,retain) ReporterMainDataManager* reporterMainDataManager;

- (void) doParseReport:(NSNumber*)reportIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR;
- (void)drillDownToExcelView;

@end
