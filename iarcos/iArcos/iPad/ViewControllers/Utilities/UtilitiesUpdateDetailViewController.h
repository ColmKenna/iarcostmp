//
//  UtilitiesUpdateDetailViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilitiesDetailViewController.h"
#import "UpdateCenter.h"
#import "Reachability.h"
#import "ConnectivityCheck.h"
#import "UtilitiesOrderDateRangePicker.h"
#import "UtilitiesCallDateRangePicker.h"
#import "UtilitiesUpdateDetailDataManager.h"
#import "UpdateCenterTableCellFactory.h"
#import "TwoDatePickerWidgetViewController.h"
#import "DownloadFunctionTableViewCell.h"
#import "UploadFunctionTableViewCell.h"
#import "UploadProcessCenter.h"
#import "UpdateStatusFunctionTableViewCell.h"
@interface UtilitiesUpdateDetailViewController : UtilitiesDetailViewController <UpdateCenterDelegate,ConnectivityDelegate, UtilitiesOrderDateRangePickerDelegate, UtilitiesUpdateCenterDataTableCellDelegate, UtilitiesCallDateRangePickerDelegate,TwoDatePickerWidgetDelegate, DownloadFunctionTableViewCellDelegate, UploadFunctionTableViewCellDelegate, UploadWebServiceProcessorDelegate>{
    UITableViewCell* updateStatusCell;
    DownloadFunctionTableViewCell* downloadTableCell;
    UploadFunctionTableViewCell* uploadTableCell;
    UpdateStatusFunctionTableViewCell* updateStatusTableCell;
//    UILabel* _reloadHiddenLabel;
//    UILabel* _statusTitleLabel;
    
    IBOutlet UIButton* updateButton;
//    IBOutlet UIButton* updateAllButton;
    UIButton* _currentUpdateButton;
    
//    NSMutableArray* tableCells;
    NSMutableDictionary* switches;
    
    //update center
    UpdateCenter* updateCenter;
    
    //selectors
    NSMutableArray* selectors;
    
    //update status
//    IBOutlet UIActivityIndicatorView* indicator;
//    IBOutlet UIProgressView* branchProgressBar;
//    IBOutlet UIProgressView* progressBar;
    int progressTotalSegements;
    float progressValue;
//    IBOutlet UILabel* updateStatus;
    NSTimer* uiUpdateTimer;
    
    //debug variable
    BOOL needVPNCheck;
    UIAlertView* alert;
    
    //connectivity check
    ConnectivityCheck* connectivityCheck;
    
//    NSMutableArray* _downloadTableCells;
    UIPopoverController* _datePickerPopover;
    UIPopoverController* _callDatePickerPopover;
    UIPopoverController* _responsePickerPopover;
    UtilitiesUpdateDetailDataManager* _utilitiesUpdateDetailDataManager;
    UpdateCenterTableCellFactory* _updateCenterTableCellFactory;
    UploadProcessCenter* _uploadProcessCenter;
}
@property(nonatomic,retain) IBOutlet UITableViewCell* updateStatusCell;
@property(nonatomic,retain) IBOutlet DownloadFunctionTableViewCell* downloadTableCell;
@property(nonatomic,retain) IBOutlet UploadFunctionTableViewCell* uploadTableCell;
@property(nonatomic,retain) IBOutlet UpdateStatusFunctionTableViewCell* updateStatusTableCell;
//@property(nonatomic,retain)  IBOutlet UILabel* reloadHiddenLabel;
//@property(nonatomic,retain)  IBOutlet UILabel* statusTitleLabel;

@property(nonatomic,retain) IBOutlet UIButton* updateButton;
@property(nonatomic,retain) UIButton* currentUpdateButton;
//@property(nonatomic,retain) IBOutlet UIButton* updateAllButton;
//@property(nonatomic,retain) NSMutableArray* tableCells;
@property(nonatomic,retain) NSMutableDictionary* switches;

@property(nonatomic,retain)     UpdateCenter* updateCenter;
@property(nonatomic,retain) NSMutableArray* selectors;

//update status
//@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* indicator;
//@property(nonatomic,retain)IBOutlet UIProgressView* branchProgressBar;
//@property(nonatomic,retain)IBOutlet UIProgressView* progressBar;
//@property(nonatomic,retain)IBOutlet UILabel* updateStatus;
@property (nonatomic,retain) UIAlertView* alert;

//@property(nonatomic,retain) NSMutableArray* downloadTableCells;
@property(nonatomic,retain) UIPopoverController* datePickerPopover;
@property(nonatomic,retain) UIPopoverController* callDatePickerPopover;
@property(nonatomic,retain) UIPopoverController* responsePickerPopover;
@property(nonatomic,retain) UtilitiesUpdateDetailDataManager* utilitiesUpdateDetailDataManager;
@property(nonatomic,retain) UpdateCenterTableCellFactory* updateCenterTableCellFactory;
@property(nonatomic,retain) UploadProcessCenter* uploadProcessCenter;

//-(IBAction)reloadSelectedTables:(id)sender;
//-(IBAction)reloadAllTables:(id)sender;
//-(IBAction)updateTableSwitchValueChange:(id)sender;

-(void)disableUpdateButtons:(BOOL)needDisable;
-(void)checkConnection;
-(void)buildUpdateCenterSelectorList;
- (void)buildUploadSelectorList;
@end
