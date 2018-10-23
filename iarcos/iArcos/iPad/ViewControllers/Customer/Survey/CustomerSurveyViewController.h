//
//  CustomerSurveyViewController.h
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSurveyDataManager.h"
#import "CustomerSurveyTableCellFactory.h"
#import "ArcosCoreData.h"
#import "CustomerSurveySlideTableView.h"
#import "ArcosUtils.h"
#import "CustomerSurveySlideTableCell.h"
#import "CustomerSurveyListTableCell.h"
#import "ArcosValidator.h"
#import "DatePickerWidgetViewController.h"
@class ArcosRootViewController;
#import "CustomerSurveyPreviewPhotoViewController.h"
#import "CustomerSurveySectionHeader.h"

@interface CustomerSurveyViewController : UITableViewController<CustomerSurveyTypesTableCellDelegate, CustomerSurveySlideDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomisePresentViewControllerDelegate, CustomerSurveyPreviewPhotoDelegate,UITableViewDataSource, UITableViewDelegate> {
    CustomerSurveyDataManager* _customerSurveyDataManager;
    CustomerSurveyTableCellFactory* cellFactory;
    IBOutlet UITableView* surveyListView; 
    UIPopoverController* tablecellPopover;
    CustomerSurveySlideTableView* csstv;
    NSNumber* locationIUR;
    NSString* _locationName;
    ArcosRootViewController* _arcosRootViewController;
    UINavigationController* _globalNavigationController;
    BOOL _isFirstLoadedFlag;
}

@property(nonatomic, retain) CustomerSurveyDataManager* customerSurveyDataManager;
@property(nonatomic, retain) CustomerSurveyTableCellFactory* cellFactory;
@property (nonatomic,retain) IBOutlet UITableView* surveyListView;
@property (nonatomic,retain) NSNumber* locationIUR;
@property (nonatomic,retain) CustomerSurveySlideTableView* csstv;
@property (nonatomic,retain) NSString* locationName;
@property (nonatomic,retain) ArcosRootViewController* arcosRootViewController;
@property (nonatomic,retain) UINavigationController* globalNavigationController;
@property (nonatomic,assign) BOOL isFirstLoadedFlag;

-(BOOL)validateResponses;
-(BOOL)validateActiveQuestions;
-(void)savePressed:(id)sender;


@end
