//
//  CustomerMasterViewController.h
//  iArcos
//
//  Created by David Kilmartin on 08/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerMasterDataManager.h"
#import "CustomerMasterViewControllerDelegate.h"
#import "HorizontalDividerUILabel.h"
#import "CustomerMasterTopTabBarItemTableCell.h"
#import "SubMenuPlaceHolderTableViewController.h"
#import "SubMenuListingTableViewController.h"
#import "ArcosConfigDataManager.h"
#import "ScanApiHelper.h"

@interface CustomerMasterViewController : UIViewController <SubMenuTableViewControllerDelegate, CustomerMasterViewControllerDelegate, ScanApiHelperDelegate> {
    id<CustomerMasterViewControllerDelegate> _actionDelegate;
    id<SubMenuTableViewControllerDelegate> _subMenuDelegate;
    UITableView* _topTableView;
    HorizontalDividerUILabel* _dividerLabel;
    UIScrollView* _baseScrollContentView;
    UITableView* _baseTableContentView;
    CustomerMasterDataManager* _customerMasterDataManager;
    SubMenuTableViewController* _subMenuTableViewController;
    NSIndexPath* _currentIndexPath;
    BOOL _isNotFirstLoaded;
    UIButton* _myHeaderButton;
    UIView* _myHeaderView;
    SubMenuTableViewController* _selectedSubMenuTableViewController;
    SubMenuTableViewController* _subMenuPlaceHolderTableViewController;
    SubMenuListingTableViewController* _subMenuListingTableViewController;
    ScanApiHelper* _scanApiHelper;
    NSTimer* _scanApiTimer;
}

@property(nonatomic,assign) id<CustomerMasterViewControllerDelegate> actionDelegate;
@property(nonatomic,assign) id<SubMenuTableViewControllerDelegate> subMenuDelegate;
@property(nonatomic, retain) IBOutlet UITableView* topTableView;
@property(nonatomic, retain) IBOutlet HorizontalDividerUILabel* dividerLabel;
@property(nonatomic, retain) IBOutlet UIScrollView* baseScrollContentView;
@property(nonatomic, retain) IBOutlet UITableView* baseTableContentView;
@property(nonatomic, retain) CustomerMasterDataManager* customerMasterDataManager;
@property(nonatomic, retain) SubMenuTableViewController* subMenuTableViewController;
@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic,assign) BOOL isNotFirstLoaded;
@property(nonatomic, retain) IBOutlet UIButton* myHeaderButton;
@property(nonatomic, retain) IBOutlet UIView* myHeaderView;
@property(nonatomic, retain) SubMenuTableViewController* selectedSubMenuTableViewController;
@property(nonatomic, retain) SubMenuTableViewController* subMenuPlaceHolderTableViewController;
@property(nonatomic, retain) SubMenuListingTableViewController* subMenuListingTableViewController;
@property (nonatomic,retain) ScanApiHelper* scanApiHelper;
@property (nonatomic,assign) NSTimer* scanApiTimer;


- (void)showSubMenuByCustomerListing;
- (void)processSubMenuByCustomerListing:(NSMutableDictionary*)aCellData reqSourceName:(NSString*)reqSourceName;
- (void)processSubMenuBySelf;
- (void)selectCustomerMasterTopViewWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)createScanApiRelevantObject;

@end
