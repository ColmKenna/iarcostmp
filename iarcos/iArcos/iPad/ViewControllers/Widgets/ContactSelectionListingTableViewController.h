//
//  ContactSelectionListingTableViewController.h
//  iArcos
//
//  Created by David Kilmartin on 25/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerGroupDataManager.h"
#import "CustomerSelectionListingTableViewController.h"
#import "CustomerContactWrapperModalViewController.h"
#import "ArcosMailWrapperViewController.h"

@protocol ContactSelectionListingTableViewControllerDelegate <NSObject>
- (void)didDismissContactSelectionPopover;
- (void)didSelectContactSelectionListing:(NSMutableArray*)aContactList;
- (NSMutableArray*)retrieveContactLocationObjectList;
@end

@interface ContactSelectionListingTableViewController : UITableViewController <UISearchBarDelegate, CustomerSelectionListingDelegate, CustomisePresentViewControllerDelegate, GenericRefreshParentContentDelegate, GetDataGenericDelegate, ArcosMailTableViewControllerDelegate, MFMailComposeViewControllerDelegate>{
    id<ContactSelectionListingTableViewControllerDelegate> _actionDelegate;
    NSMutableArray* _originalContactList;
    NSMutableArray* _myContactList;
    NSMutableArray* _tableData;//will be storing data that will be displayed in table
    NSMutableArray* _searchedData;//will be storing data matching with the search string
    NSMutableArray* _customerNames;
    NSMutableArray* _sortKeys;
    NSMutableDictionary* _customerSections;
    BOOL _needIndexView;
    UISearchBar* _mySearchBar;
    UIBarButtonItem* _locationButton;
    NSNumber* _selectedLocationIUR;
    NSMutableDictionary* _selectedLocationDict;
    BOOL _popoverOpenFlag;
    UINavigationController* _globalNavigationController;
    UIViewController* _rootView;
    CustomerContactTypesDataManager* _customerContactTypesDataManager;
    ArcosGenericReturnObject* _contactGenericReturnObject;
    NSString* _myArcosAdminEmail;
    NSString* _emailActionType;
    NSNumber* _emailContactIUR;
    CallGenericServices* _callGenericServices;
}

@property(nonatomic,assign) id<ContactSelectionListingTableViewControllerDelegate> actionDelegate;
@property(nonatomic,retain) NSMutableArray* originalContactList;
@property(nonatomic,retain) NSMutableArray* myContactList;
//@property(nonatomic,retain) NSMutableArray* myCustomers;
@property(nonatomic,retain) NSMutableArray* tableData;
@property(nonatomic,retain) NSMutableArray* searchedData;
@property(nonatomic,retain) NSMutableArray* customerNames;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property(nonatomic,retain) NSMutableDictionary* customerSections;
@property(nonatomic,assign) BOOL needIndexView;
@property(nonatomic,retain) IBOutlet UISearchBar* mySearchBar;
@property(nonatomic,retain) UIBarButtonItem* locationButton;
@property(nonatomic,retain) NSNumber* selectedLocationIUR;
@property(nonatomic,retain) NSMutableDictionary* selectedLocationDict;
@property(nonatomic, assign) BOOL popoverOpenFlag;
@property (nonatomic, retain) UINavigationController* globalNavigationController;
@property (nonatomic, retain) UIViewController* rootView;
@property (nonatomic, retain) CustomerContactTypesDataManager* customerContactTypesDataManager;
@property (nonatomic, retain) ArcosGenericReturnObject* contactGenericReturnObject;
@property (nonatomic, retain) NSString* myArcosAdminEmail;
@property (nonatomic, retain) NSString* emailActionType;
@property (nonatomic, retain) NSNumber* emailContactIUR;
@property (nonatomic, retain) CallGenericServices* callGenericServices;

- (void)resetContact:(NSMutableArray*)aContactList;

@end

