//
//  CustomerListingViewController.h
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSharedClass.h"
//#import "CustomerInfoViewController.h"
#import "CustomerInfoTableViewController.h"
#import "CustomerBaseDetailViewController.h"
#import "CustomerNewsTaskWrapperViewController.h"
#import "ArcosSystemCodesUtils.h"
#import "StoreNewsDateDataManager.h"
#import "ArcosOrderRestoreUtils.h"
#import "CustomerListingTableCell.h"
#import "ArcosMailWrapperViewController.h"

@interface CustomerListingViewController : CustomerBaseDetailViewController<UIPopoverControllerDelegate, UISplitViewControllerDelegate,UISearchBarDelegate,UINavigationBarDelegate, ModelViewDelegate, GenericRefreshParentContentDelegate,CustomisePresentViewControllerDelegate,CheckLocationIURTemplateDelegate,GetDataGenericDelegate,MFMailComposeViewControllerDelegate,ArcosMailTableViewControllerDelegate> {
    NSMutableArray* myCustomers;
    NSMutableArray* customerNames;
    CustomerInfoTableViewController* myCustomerInfoViewController;
    UIPopoverController* groupPopover;
    
    NSMutableArray* sortKeys;
    NSMutableDictionary* _customerSections;
    
    IBOutlet UISearchBar* mySearchBar;
    NSMutableArray *tableData;//will be storing data that will be displayed in table
    NSMutableArray *searchedData;//will be storing data matching with the search string
    BOOL searching;
    BOOL letUserSelectRow;
    BOOL needIndexView;
    
    //hold the bar button
//    UIBarButtonItem* myBarButtonItem;
    
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    NSNumber* _showLocationCode;
    ConnectivityCheck* connectivityCheck;
    StoreNewsDateDataManager* _storeNewsDateDataManager;
    CheckLocationIURTemplateProcessor* _checkLocationIURTemplateProcessor;
    ArcosOrderRestoreUtils* _arcosOrderRestoreUtils;
    NSIndexPath* _restoredLocationIndexPath;
    BOOL _isNotFirstLoaded;
    CallGenericServices* _callGenericServices;
    CustomerTypesDataManager* _customerTypesDataManager;
    NSString* _myArcosAdminEmail;
}
@property (nonatomic, retain) IBOutlet UISearchBar *mySearchBar;

@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,retain) NSMutableArray *searchedData;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) NSNumber* showLocationCode;
@property (nonatomic, retain) StoreNewsDateDataManager* storeNewsDateDataManager;
@property (nonatomic, retain) CheckLocationIURTemplateProcessor* checkLocationIURTemplateProcessor;
@property (nonatomic, retain) ArcosOrderRestoreUtils* arcosOrderRestoreUtils;
@property (nonatomic, retain) NSIndexPath* restoredLocationIndexPath;
@property (nonatomic, assign) BOOL isNotFirstLoaded;
@property (nonatomic, retain) CallGenericServices* callGenericServices;
@property (nonatomic, retain) CustomerTypesDataManager* customerTypesDataManager;
@property (nonatomic, retain) NSString* myArcosAdminEmail;


//-(void)resetCustomer:(NSMutableArray*)customers;
-(void)resetList:(NSMutableArray*)aList;
-(void)sortCustomers:(NSMutableArray*)customers;
-(NSMutableDictionary*)objectFromName:(NSString*)name;
-(NSMutableArray*)objectsFromName:(NSString*)name;
- (NSIndexPath*)getCustomerIndexWithLocationIUR:(NSNumber*)aLocationIUR;
- (void)selectLocationWithIndexPath:(NSIndexPath*)anIndexPath;

@end
