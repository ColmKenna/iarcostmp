//
//  UtilitiesMasterViewController.h
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewCommonMasterViewController.h"
#import "UtilitiesSettingDetailViewController.h"
#import "UtilitiesUpdateDetailViewController.h"
#import "UtilitiesTablesDetailViewController.h"
#import "UtilitiesPresenterDetailViewController.h"
#import "UtilitiesDescriptionViewController.h"
#import "UtilitiesMasterTableCell.h"
#import "ActivateAppStatusManager.h"
#import "ActivateEnterpriseViewController.h"
#import "ArcosSystemCodesUtils.h"
#import "CustomerNewsTaskWrapperViewController.h"
#import "StoreNewsDateDataManager.h"
#import "UtilitiesMemoryTableViewController.h"
#import "UtilitiesConfigurationTableViewController.h"

@interface UtilitiesMasterViewController : SplitViewCommonMasterViewController<UISplitViewControllerDelegate,UITableViewDataSource,UITableViewDelegate, ControllNavigationBarDelegate,PresentViewControllerDelegate,CustomisePresentViewControllerDelegate> {
    id<ControllNavigationBarDelegate> _navigationDelegate;
    IBOutlet UITableView* theTableView;
    
    //utilities array
    NSMutableArray* utilities;
    NSInteger currentSelectIndex;
    
    //detail views
    UtilitiesDetailViewController* updateDetailView;
    UtilitiesDetailViewController* settingDetailView;
    UtilitiesDetailViewController* tablesDetailView;
    UtilitiesDetailViewController* presenterDetailView;
    UtilitiesDetailViewController* descriptionDetailView;
    UtilitiesDetailViewController* memoryDetailView;
    UtilitiesDetailViewController* configurationDetailView;
    
    UtilitiesDetailViewController* _detailViewController;
    UINavigationController* _globalNavigationController;
    UIViewController* _myRootViewController;
    StoreNewsDateDataManager* _storeNewsDateDataManager;
}

@property(nonatomic,assign) id<ControllNavigationBarDelegate> navigationDelegate;
@property(nonatomic,retain)    IBOutlet UITableView* theTableView;
@property(nonatomic,retain)   NSMutableArray* utilities;

@property(nonatomic,retain)  UtilitiesDetailViewController* updateDetailView;
@property(nonatomic,retain)  UtilitiesDetailViewController* settingDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* tablesDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* presenterDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* descriptionDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* memoryDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* configurationDetailView;
@property(nonatomic,retain) UtilitiesDetailViewController* detailViewController;
@property(nonatomic,retain) UINavigationController* globalNavigationController;
@property(nonatomic,retain) UIViewController* myRootViewController;
@property(nonatomic,retain) StoreNewsDateDataManager* storeNewsDateDataManager;

- (NSMutableDictionary*)createMasterCellDataWithFilename:(NSString*) fileName title:(NSString*)title subTitle:(NSString*)subTitle;

@end
