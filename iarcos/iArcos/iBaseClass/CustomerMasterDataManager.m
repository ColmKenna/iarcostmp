//
//  CustomerMasterDataManager.m
//  iArcos
//
//  Created by David Kilmartin on 08/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterDataManager.h"
#import "UtilitiesArcosSplitViewController.h"
#import "CustomerGroupViewController.h"
#import "GenericMasterTemplateViewController.h"
#import "ArcosOrderRestoreUtils.h"

@implementation CustomerMasterDataManager
@synthesize displayList = _displayList;
@synthesize utilitiesArcosSplitViewController = _utilitiesArcosSplitViewController;
@synthesize mapViewController = _mapViewController;
@synthesize mapNavigationController = _mapNavigationController;
@synthesize locationArcosStackedViewController = _locationArcosStackedViewController;
@synthesize contactArcosStackedViewController = _contactArcosStackedViewController;
@synthesize savedOrderSplitViewController = _savedOrderSplitViewController;
@synthesize reporterMainViewController = _reporterMainViewController;
@synthesize reporterNavigationController = _reporterNavigationController;
@synthesize customerWeeklyMainWrapperModalViewController = _customerWeeklyMainWrapperModalViewController;
@synthesize customerWeeklyMainModalViewController = _customerWeeklyMainModalViewController;
@synthesize customerWeeklyMainNavigationController = _customerWeeklyMainNavigationController;
@synthesize dashboardText = _dashboardText;
@synthesize presenterText = _presenterText;
//@synthesize mainNewPresenterViewController = _mainNewPresenterViewController;
//@synthesize mainNewPresenterNavigationController = _mainNewPresenterNavigationController;
@synthesize mainPresenterTableViewController = _mainPresenterTableViewController;
@synthesize mainPresenterNavigationController = _mainPresenterNavigationController;
@synthesize utilitiesText = _utilitiesText;
@synthesize templateDashboardViewController = _templateDashboardViewController;
@synthesize dashboardMainTemplateTableViewController = _dashboardMainTemplateTableViewController;
@synthesize dashboardMainTemplateNavigationController = _dashboardMainTemplateNavigationController;
@synthesize weeklyMainTemplateViewController = _weeklyMainTemplateViewController;
@synthesize weeklyMainTemplateNavigationController = _weeklyMainTemplateNavigationController;
@synthesize targetTableViewController = _targetTableViewController;
@synthesize targetNavigationController = _targetNavigationController;
@synthesize targetText = _targetText;
@synthesize meetingMainTemplateViewController = _meetingMainTemplateViewController;
@synthesize meetingNavigationController = _meetingNavigationController;
@synthesize meetingText = _meetingText;

- (id)init{
    self = [super init];
    if (self != nil) {
        self.dashboardText = @"Dashboard";
        self.presenterText = @"Presenter";
        self.targetText = @"Target";
        self.meetingText = @"Meeting";
//        self.mainNewPresenterViewController = [[[NewPresenterViewController alloc] initWithNibName:@"NewPresenterViewController" bundle:nil] autorelease];
//        self.mainNewPresenterViewController.parentPresenterRequestSource = PresenterRequestSourceMainMenu;
//        self.mainNewPresenterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.mainNewPresenterViewController] autorelease];
        self.mainPresenterTableViewController = [[[MainPresenterTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.mainPresenterTableViewController.parentMainPresenterRequestSource = PresenterRequestSourceMainMenu;
        [self.mainPresenterTableViewController.mainPresenterDataManager retrieveMainPresenterDataList];
        UIViewController* resultViewController = nil;
        if ([self.mainPresenterTableViewController.mainPresenterDataManager.displayList count] == 1) {
            NSMutableArray* subsetDisplayList = [self.mainPresenterTableViewController.mainPresenterDataManager.displayList objectAtIndex:0];
            if ([subsetDisplayList count] == 1) {
                NSDictionary* mainPresenterCellDict = [subsetDisplayList objectAtIndex:0];
                resultViewController = [self.mainPresenterTableViewController retrieveNewPresenterViewControllerResult:mainPresenterCellDict];
            }
        }
        if (resultViewController == nil) {
            resultViewController = self.mainPresenterTableViewController;
        }
        self.mainPresenterNavigationController = [[[UINavigationController alloc] initWithRootViewController:resultViewController] autorelease];
        self.templateDashboardViewController = [[[TemplateDashboardViewController alloc] initWithNibName:@"TemplateDashboardViewController" bundle:nil] autorelease];
        self.utilitiesText = @"Utilities";
        self.utilitiesArcosSplitViewController = [[[UtilitiesArcosSplitViewController alloc] initWithNibName:@"ArcosSplitViewController" bundle:nil] autorelease];
        
        GenericMasterTemplateViewController* locationGenericMasterTemplateViewController = [self createGenericMasterTemplateViewController:CustomerGroupRequestSourceMaster];
        UINavigationController* locationNavigationController = (UINavigationController*)locationGenericMasterTemplateViewController.masterViewController;
        CustomerGroupViewController* locationCustomerGroupViewController = (CustomerGroupViewController*)[locationNavigationController.viewControllers objectAtIndex:0];
        NSMutableDictionary* allDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:-1]  forKey:@"MasterLocationIUR"];
        [allDict setObject:@"All" forKey:@"MasterName"];
        NSNumber* aMasterIUR = [allDict objectForKey:@"MasterLocationIUR"];
        NSMutableArray* outlets = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:aMasterIUR withResultType:NSDictionaryResultType];
        locationCustomerGroupViewController.myCustomerListingViewController.title = [allDict objectForKey:@"MasterName"];
        [locationCustomerGroupViewController.myCustomerListingViewController resetCustomer:outlets];
        ArcosOrderRestoreUtils* arcosOrderRestoreUtils = [[ArcosOrderRestoreUtils alloc] init];
        locationCustomerGroupViewController.myCustomerListingViewController.arcosOrderRestoreUtils = arcosOrderRestoreUtils;
        [arcosOrderRestoreUtils release];
        if ([arcosOrderRestoreUtils orderRestorePlistExistent]) {
            [arcosOrderRestoreUtils loadExistingOrderline];
            locationCustomerGroupViewController.myCustomerListingViewController.restoredLocationIndexPath = [locationCustomerGroupViewController.myCustomerListingViewController getCustomerIndexWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        }
        UINavigationController* customerListingNavigationController = [[UINavigationController alloc] initWithRootViewController:locationCustomerGroupViewController.myCustomerListingViewController];
        
        self.locationArcosStackedViewController = [[[ArcosStackedViewController alloc] initWithRootNavigationController:customerListingNavigationController] autorelease];
        
        [customerListingNavigationController release];
        
        
        [self.locationArcosStackedViewController pushMasterViewController:locationGenericMasterTemplateViewController];
        
        GenericMasterTemplateViewController* contactGenericMasterTemplateViewController = [self createGenericMasterTemplateViewController:CustomerGroupRequestSourceContact];
        UINavigationController* contactNavigationController = (UINavigationController*)contactGenericMasterTemplateViewController.masterViewController;
        CustomerGroupViewController* contactCustomerGroupViewController = (CustomerGroupViewController*)[contactNavigationController.viewControllers objectAtIndex:0];
        UINavigationController* myContactDetailNavigationController = [[UINavigationController alloc] initWithRootViewController:contactCustomerGroupViewController.myContactDetailViewController];
        NSMutableDictionary* contactAllDict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:-1]  forKey:@"DescrDetailIUR"];
        [contactAllDict setObject:@"All" forKey:@"MasterName"];
        NSMutableArray* contactLocationObjectList = [contactCustomerGroupViewController contactDataGenerator:contactAllDict];
        
        contactCustomerGroupViewController.myContactDetailViewController.title = [contactAllDict objectForKey:@"MasterName"];
        [contactCustomerGroupViewController.myContactDetailViewController resetCustomer:contactLocationObjectList];
        self.contactArcosStackedViewController = [[[ArcosStackedViewController alloc] initWithRootNavigationController:myContactDetailNavigationController] autorelease];
        [myContactDetailNavigationController release];
        
        
        [self.contactArcosStackedViewController pushMasterViewController:contactGenericMasterTemplateViewController];
        
        
        self.mapViewController = [[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil] autorelease];
        self.mapNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.mapViewController] autorelease];
        self.savedOrderSplitViewController = [[[SavedOrderSplitViewController alloc] initWithNibName:@"ArcosSplitViewController" bundle:nil] autorelease];
        self.reporterMainViewController = [[[ReporterMainViewController alloc] initWithNibName:@"ReporterMainViewController" bundle:nil] autorelease];
        self.reporterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.reporterMainViewController] autorelease];

//        self.customerWeeklyMainModalViewController = [[[CustomerWeeklyMainModalViewController alloc]initWithNibName:@"CustomerWeeklyMainModalViewController" bundle:nil] autorelease];
//        self.customerWeeklyMainNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.customerWeeklyMainModalViewController] autorelease];
        self.weeklyMainTemplateViewController = [[[WeeklyMainTemplateViewController alloc] initWithNibName:@"WeeklyMainTemplateViewController" bundle:nil] autorelease];
        self.weeklyMainTemplateNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.weeklyMainTemplateViewController] autorelease];
        
//        self.dashboardMainTemplateTableViewController = [[[DashboardMainTemplateTableViewController alloc] initWithNibName:@"DashboardMainTemplateTableViewController" bundle:nil] autorelease];
//        self.dashboardMainTemplateNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.dashboardMainTemplateTableViewController] autorelease];
        self.targetTableViewController = [[[TargetTableViewController alloc] initWithNibName:@"TargetTableViewController" bundle:nil] autorelease];
        self.targetNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.targetTableViewController] autorelease];
        self.meetingMainTemplateViewController = [[[MeetingMainTemplateViewController alloc] initWithNibName:@"MeetingMainTemplateViewController" bundle:nil] autorelease];
        self.meetingMainTemplateViewController.actionType = self.meetingMainTemplateViewController.createActionType;
//        self.meetingMainTemplateViewController.actionType = @"";
        self.meetingNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.meetingMainTemplateViewController] autorelease];
        
//        NSMutableDictionary* dashboardCellData = [self createItemCellData:self.dashboardText imageFile:@"Dashboard.png" myCustomController:self.templateDashboardViewController];
        NSMutableDictionary* locatorCellData = [self createItemCellData:@"Locator" imageFile:@"MapIcon.png" myCustomController:self.mapNavigationController];
        NSMutableDictionary* customerCellData = [self createItemCellData:[[GlobalSharedClass shared] customerText] imageFile:@"customer_info.png" myCustomController:self.locationArcosStackedViewController];
        NSMutableDictionary* contactCellData = [self createItemCellData:[[GlobalSharedClass shared] contactText] imageFile:@"CustomerIcon.png" myCustomController:self.contactArcosStackedViewController];
        
        NSMutableDictionary* reporterCellData = [self createItemCellData:@"Reporter" imageFile:@"Reporter.png" myCustomController:self.reporterNavigationController];
        NSMutableDictionary* listingsCellData = [self createItemCellData:[[GlobalSharedClass shared] listingsText] imageFile:@"SavedOrder.png" myCustomController:self.savedOrderSplitViewController];
        NSMutableDictionary* weeklyCellData = [self createItemCellData:@"Weekly" imageFile:@"Calendar.png" myCustomController:self.weeklyMainTemplateNavigationController];
        
        NSMutableDictionary* utilitiesCellData = [self createItemCellData:self.utilitiesText imageFile:@"Utilities.png" myCustomController:self.utilitiesArcosSplitViewController];
        NSMutableDictionary* presenterCellData = [self createItemCellData:self.presenterText imageFile:@"PresenterIcon.png" myCustomController:self.mainPresenterNavigationController];
//        NSMutableDictionary* dashboardMainTemplateCellData = [self createItemCellData:self.dashboardText imageFile:@"Dashboard.png" myCustomController:self.dashboardMainTemplateNavigationController];
        NSMutableDictionary* targetCellData = [self createItemCellData:self.targetText imageFile:@"Target.png" myCustomController:self.targetNavigationController];
        NSMutableDictionary* meetingCellData = [self createItemCellData:self.meetingText imageFile:@"Meeting.png" myCustomController:self.meetingNavigationController];
        
        
        //dashboardMainTemplateCellData,
        //dashboardCellData,
        self.displayList = [NSMutableArray arrayWithObjects:locatorCellData, customerCellData, contactCellData, reporterCellData, listingsCellData, weeklyCellData, utilitiesCellData, nil];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTargetFlag]) {
            [self.displayList addObject:targetCellData];
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showMeetingFlag]) {
            [self.displayList addObject:meetingCellData];
        }
        [self.displayList addObject:presenterCellData];
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.utilitiesArcosSplitViewController = nil;
    self.mapViewController = nil;
    self.mapNavigationController = nil;
    self.locationArcosStackedViewController = nil;
    self.contactArcosStackedViewController = nil;
    self.savedOrderSplitViewController = nil;
    self.reporterMainViewController = nil;
    self.reporterNavigationController = nil;
    self.customerWeeklyMainWrapperModalViewController = nil;
    self.dashboardText = nil;
    self.presenterText = nil;
//    self.mainNewPresenterViewController = nil;
//    self.mainNewPresenterNavigationController = nil;
    self.mainPresenterTableViewController = nil;
    self.mainPresenterNavigationController = nil;
    self.templateDashboardViewController = nil;
    self.dashboardMainTemplateTableViewController = nil;
    self.dashboardMainTemplateNavigationController = nil;
    self.weeklyMainTemplateViewController = nil;
    self.weeklyMainTemplateNavigationController = nil;
    self.targetTableViewController = nil;
    self.targetNavigationController = nil;
    
    [super dealloc];
}

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [cellDict setObject:title forKey:@"Title"];
    [cellDict setObject:imageFile forKey:@"ImageFile"];
    return cellDict;
}

- (NSMutableDictionary*)createItemCellData:(NSString*)title imageFile:(NSString*)imageFile myCustomController:(UIViewController*)aViewController {
    NSMutableDictionary* cellDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [cellDict setObject:title forKey:@"Title"];
    [cellDict setObject:imageFile forKey:@"ImageFile"];
    [cellDict setObject:aViewController forKey:@"MyCustomController"];
    return cellDict;
}

- (GenericMasterTemplateViewController*)createGenericMasterTemplateViewController:(CustomerGroupRequestSource)aRequestSource {
    GenericMasterTemplateViewController* genericMasterTemplateViewController = [[[GenericMasterTemplateViewController alloc] initWithNibName:@"GenericMasterTemplateViewController" bundle:nil] autorelease];
    CustomerGroupViewController* customerGroupViewController = [[CustomerGroupViewController alloc] initWithStyle:UITableViewStylePlain requestSource:aRequestSource];
//    customerGroupViewController.requestSource = aRequestSource;
    UINavigationController* customerGroupNavigationController = [[UINavigationController alloc] initWithRootViewController:customerGroupViewController];
    
    genericMasterTemplateViewController.masterViewController = customerGroupNavigationController;
    [customerGroupViewController release];
    [customerGroupNavigationController release];
    return genericMasterTemplateViewController;
}

- (int)retrieveIndexByTitle:(NSString*)title {
    int index = 0;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* tmpCellDataDict = [self.displayList objectAtIndex:i];
        if ([title isEqualToString:[tmpCellDataDict objectForKey:@"Title"]]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSString*)retrieveTitleByIndex:(int)anIndex {
    NSString* title = @"";
    @try {
        NSMutableDictionary* tmpCellDataDict = [self.displayList objectAtIndex:anIndex];
        title = [tmpCellDataDict objectForKey:@"Title"];
    }
    @catch (NSException *exception) {
        
    }
    return title;
}

@end
