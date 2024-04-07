//
//  CustomerGroupViewController.h
//  Arcos
//
//  Created by David Kilmartin on 22/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSharedClass.h"
#import "CustomerListingViewController.h"
#import "SubstitutableDetailViewController.h"
#import "CustomerJourneyDataManager.h"
#import "CustomerBaseDetailViewController.h"
#import "CustomerJourneyDetailViewController.h"
#import "CustomerContactDetailViewController.h"
#import "GenericPlainTableCell.h"
#import "GenericMasterTemplateDelegate.h"
#import "CustomerGroupDataManager.h"
#import "CustomerGroupContactTableViewCell.h"
#import "WidgetFactory.h"
#import "CustomerGroupListDataManager.h"
#import "CustomerGroupContactDataManager.h"
#import "CustomerGroupTableCellFactory.h"
#import "AccessTimesWidgetViewController.h"
#import "CustomerCalendarListTableViewController.h"
typedef enum {
    CustomerGroupRequestSourceMaster = 0,
    CustomerGroupRequestSourceContact
} CustomerGroupRequestSource;

@interface CustomerGroupViewController : UITableViewController<UISearchBarDelegate,UISplitViewControllerDelegate,WidgetFactoryDelegate, CustomerGroupContactTableViewCellDelegate, AccessTimesWidgetViewControllerDelegate, CustomerSelectionListingDelegate, UIPopoverPresentationControllerDelegate> {
    CustomerGroupRequestSource _requestSource;
    id<GenericMasterTemplateDelegate> _myMoveDelegate;
    CustomerGroupDataManager* _customerGroupDataManager;
    NSMutableDictionary* myGroups;
    NSMutableArray* groupName;
    CustomerListingViewController* myCustomerListingViewController;
    NSString* groupType;
    
    NSMutableArray* sortKeys;
    NSMutableDictionary* _groupSelections;
    
//    IBOutlet UISearchBar* searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    
    //navigation bar button
    UISplitViewController *splitViewController;
    
//    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;

    UISegmentedControl* _segmentBut;
    CustomerJourneyDataManager* _customerJourneyDataManager;
    //detail views
    CustomerBaseDetailViewController* _listingDetailViewController;
    CustomerBaseDetailViewController* _journeyDetailViewController;
    CustomerJourneyDetailViewController* _myJourneyDetailViewController;
    CustomerBaseDetailViewController* _contactDetailViewController;
    CustomerContactDetailViewController* _myContactDetailViewController;
    CustomerBaseDetailViewController* _auxDetailViewController;
    UIImage* _journeyDefaultImage;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSString* _listTypeText;
    NSString* _journeyTypeText;
    NSIndexPath* _auxJourneyIndexPath;
    CustomerGroupTableCellFactory* _tableCellFactory;
    AccessTimesWidgetViewController* _accessTimesWidgetViewController;
    NSString* _outlookTypeText;
    CustomerCalendarListTableViewController* _customerCalendarListTableViewController;
}
@property(nonatomic, assign) CustomerGroupRequestSource requestSource;
@property(nonatomic, assign) id<GenericMasterTemplateDelegate> myMoveDelegate;
@property (nonatomic, retain) CustomerGroupDataManager* customerGroupDataManager;
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
//@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

@property(nonatomic,retain) CustomerListingViewController* myCustomerListingViewController;
//@property(nonatomic,retain) IBOutlet UISearchBar* searchBar;
@property(nonatomic,retain) NSString* groupType;

@property(nonatomic,retain) NSMutableDictionary* myGroups;
@property(nonatomic,retain) NSMutableArray* groupName;
@property(nonatomic,retain) NSMutableDictionary* groupSelections;
@property(nonatomic,retain) NSMutableArray* sortKeys;
@property (nonatomic, retain) UISegmentedControl* segmentBut;
@property (nonatomic, retain) CustomerJourneyDataManager* customerJourneyDataManager;
@property (nonatomic, retain) CustomerBaseDetailViewController* listingDetailViewController;
@property (nonatomic, retain) CustomerBaseDetailViewController* journeyDetailViewController;
@property (nonatomic, retain) CustomerJourneyDetailViewController* myJourneyDetailViewController;
@property (nonatomic, retain) CustomerBaseDetailViewController* contactDetailViewController;
@property (nonatomic, retain) CustomerContactDetailViewController* myContactDetailViewController;
@property (nonatomic, retain) CustomerBaseDetailViewController* auxDetailViewController;
@property (nonatomic, retain) UIImage* journeyDefaultImage;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) NSString* listTypeText;
@property(nonatomic, retain) NSString* journeyTypeText;
@property(nonatomic, retain) NSIndexPath* auxJourneyIndexPath;
@property(nonatomic, retain) CustomerGroupTableCellFactory* tableCellFactory;
@property(nonatomic, retain) AccessTimesWidgetViewController* accessTimesWidgetViewController;
@property(nonatomic, retain) NSString* outlookTypeText;
@property(nonatomic, retain) CustomerCalendarListTableViewController* customerCalendarListTableViewController;

- (instancetype)initWithStyle:(UITableViewStyle)aStyle requestSource:(CustomerGroupRequestSource)aRequestSource;
-(void)showDetailViewController:(CustomerBaseDetailViewController*)baseDetailViewController;
- (int)getEmployeeSecurityLevel;
- (NSMutableArray*)contactDataGenerator:(NSMutableDictionary*)aDict;
- (void)resetButtonPressed:(id)sender;
- (void)processJourneyWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)tapJourneyButtonPartialProcessor;
- (void)processJourneyFromDateWheelsWithIndexPath:(NSIndexPath*)anIndexPath journeyIUR:(NSNumber*)aJourneyIUR;
- (void)processJourneyFromDateWheelsRemoveButtonWithIndexPath:(NSIndexPath*)anIndexPath;
@end
