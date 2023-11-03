//
//  FlagsMainTemplateViewController.m
//  iArcos
//
//  Created by Richard on 05/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsMainTemplateViewController.h"

@interface FlagsMainTemplateViewController ()

@end

@implementation FlagsMainTemplateViewController
@synthesize locationViewHolder = _locationViewHolder;
@synthesize contactViewHolder = _contactViewHolder;
@synthesize separatorFromContactViewHolder = _separatorFromContactViewHolder;
@synthesize selectedContactViewHolder = _selectedContactViewHolder;
@synthesize separatorFromSelectedContactViewHolder = _separatorFromSelectedContactViewHolder;

@synthesize flagsLocationTableViewController = _flagsLocationTableViewController;
@synthesize flagsLocationNavigationController = _flagsLocationNavigationController;
@synthesize flagsContactTableViewController = _flagsContactTableViewController;
@synthesize flagsContactNavigationController = _flagsContactNavigationController;
@synthesize flagsSelectedContactTableViewController = _flagsSelectedContactTableViewController;
@synthesize flagsSelectedContactNavigationController = _flagsSelectedContactNavigationController;
@synthesize layoutDict = _layoutDict;
@synthesize flagsMainTemplateDataManager = _flagsMainTemplateDataManager;
@synthesize HUD = _HUD;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.flagsMainTemplateDataManager = [[[FlagsMainTemplateDataManager alloc] init] autorelease];
        self.flagsLocationTableViewController = [[[FlagsLocationTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsLocationTableViewController.selectionDelegate = self;
        self.flagsLocationTableViewController.hideAllButtonFlag = YES;
        NSMutableArray* tmpLocationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
        NSMutableArray* locationList = [self.flagsMainTemplateDataManager dictMutableListWithData:tmpLocationList];
        [self.flagsLocationTableViewController resetCustomer:locationList];
        self.flagsLocationNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsLocationTableViewController] autorelease];
        self.flagsContactTableViewController = [[[FlagsContactTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsContactTableViewController.actionDelegate = self;
        self.flagsContactNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsContactTableViewController] autorelease];
        self.flagsSelectedContactTableViewController = [[[FlagsSelectedContactTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsSelectedContactTableViewController.actionDelegate = self;
        self.flagsSelectedContactNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsSelectedContactTableViewController] autorelease];
        
        self.layoutDict = @{@"AuxFlagsLocation" : self.flagsLocationNavigationController.view, @"AuxFlagsContact" : self.flagsContactNavigationController.view, @"AuxFlagsSelectedContact" : self.flagsSelectedContactNavigationController.view};
        
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        self.HUD.dimBackground = YES;
        [self.view addSubview:self.HUD];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addChildViewController:self.flagsLocationNavigationController];
    [self.locationViewHolder addSubview:self.flagsLocationNavigationController.view];
    [self.flagsLocationNavigationController didMoveToParentViewController:self];
    [self.flagsLocationNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.locationViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxFlagsLocation]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.locationViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxFlagsLocation]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    
    [self addChildViewController:self.flagsContactNavigationController];
    [self.contactViewHolder addSubview:self.flagsContactNavigationController.view];
    [self.flagsContactNavigationController didMoveToParentViewController:self];
    [self.flagsContactNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contactViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(1)-[AuxFlagsContact]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.contactViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxFlagsContact]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    
    [self addChildViewController:self.flagsSelectedContactNavigationController];
    [self.selectedContactViewHolder addSubview:self.flagsSelectedContactNavigationController.view];
    [self.flagsSelectedContactNavigationController didMoveToParentViewController:self];
    [self.flagsSelectedContactNavigationController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.selectedContactViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(1)-[AuxFlagsSelectedContact]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.selectedContactViewHolder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxFlagsSelectedContact]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
}

- (void)dealloc {
    self.locationViewHolder = nil;
    self.contactViewHolder = nil;
    self.separatorFromContactViewHolder = nil;
    self.selectedContactViewHolder = nil;
    self.separatorFromSelectedContactViewHolder = nil;
    
    [self.flagsLocationNavigationController willMoveToParentViewController:nil];
    [self.flagsLocationNavigationController.view removeFromSuperview];
    [self.flagsLocationNavigationController removeFromParentViewController];
    
    [self.flagsContactNavigationController willMoveToParentViewController:nil];
    [self.flagsContactNavigationController.view removeFromSuperview];
    [self.flagsContactNavigationController removeFromParentViewController];
    
    [self.flagsSelectedContactNavigationController willMoveToParentViewController:nil];
    [self.flagsSelectedContactNavigationController.view removeFromSuperview];
    [self.flagsSelectedContactNavigationController removeFromParentViewController];
    
    self.flagsLocationTableViewController = nil;
    self.flagsLocationNavigationController = nil;
    self.flagsContactTableViewController = nil;
    self.flagsContactNavigationController = nil;
    self.flagsSelectedContactTableViewController = nil;
    self.flagsSelectedContactNavigationController = nil;
    self.layoutDict = nil;
    self.flagsMainTemplateDataManager = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    
    [super dealloc];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.HUD.frame = self.view.bounds;
    }];
}

#pragma mark - FlagsLocationTableViewControllerDelegate
- (void)didSelectFlagsLocationRecord:(NSMutableDictionary*)aCustDict {
//    NSNumber* selectedLocationIUR = [aCustDict objectForKey:@"LocationIUR"];
    NSMutableArray* contactList = [self.flagsContactTableViewController.flagsContactDataManager retrieveContactListWithLocationDict:aCustDict];
    for (int i = 0; i < [contactList count]; i++) {
        NSMutableDictionary* contactDict = [contactList objectAtIndex:i];
        NSNumber* contactIUR = [contactDict objectForKey:@"IUR"];
        NSString* cartKey = [NSString stringWithFormat:@"%@", [contactIUR stringValue]];
        NSMutableDictionary* existingContactDict = [self.flagsMainTemplateDataManager.contactOrderCart objectForKey:cartKey];
        if (existingContactDict != nil) {
            [contactDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
        }
    }
    [self.flagsContactTableViewController resetContact:contactList];
}
- (int)retrieveFlagsLocationParentActionType {
    return self.flagsMainTemplateDataManager.actionType;
}

- (void)didSelectFlagsLocationRecordAndSaveToLocationOrderCart:(NSMutableDictionary*)aCustDict {
    [self.flagsMainTemplateDataManager saveLocationToOrderCart:aCustDict];
    NSMutableArray* selectedLocationList = [self.flagsMainTemplateDataManager retrieveSelectedLocationListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedLocationList];
}
- (NSMutableDictionary*)retrieveLocationParentOrderCart {
    return self.flagsMainTemplateDataManager.locationOrderCart;
}

#pragma mark - FlagsContactTableViewControllerDelegate
- (void)didSelectFlagsContactRecord:(NSMutableDictionary*)aContactDict {
    [self.flagsMainTemplateDataManager saveContactToOrderCart:aContactDict];
    NSMutableArray* selectedContactList = [self.flagsMainTemplateDataManager retrieveSelectedContactListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedContactList];
}
- (NSMutableDictionary*)retrieveContactParentOrderCart {
    return self.flagsMainTemplateDataManager.contactOrderCart;
}
- (void)locationBarButtonPressedProcessor {
    self.flagsMainTemplateDataManager.actionType = 1;
    [self.flagsMainTemplateDataManager defineConfigAsLocation];
    [self resetMainTemplateData];
    [self.flagsLocationTableViewController refreshLocationList];
}
- (void)contactBarButtonPressedProcessor {
    self.flagsMainTemplateDataManager.actionType = 0;
    [self.flagsMainTemplateDataManager defineConfigAsContact];
    [self resetMainTemplateData];
    if (self.flagsLocationTableViewController.flagsLocationDataManager.currentIndexPath != nil) {
        [self.flagsLocationTableViewController.tableView deselectRowAtIndexPath:self.flagsLocationTableViewController.flagsLocationDataManager.currentIndexPath animated:NO];
        self.flagsLocationTableViewController.flagsLocationDataManager.currentIndexPath = nil;
    }
}
- (void)resetMainTemplateData {
    [self.flagsMainTemplateDataManager.contactOrderCart removeAllObjects];
    [self.flagsMainTemplateDataManager.locationOrderCart removeAllObjects];
    [self.flagsSelectedContactTableViewController resetSelectedContact:[NSMutableArray array]];
}

#pragma mark - FlagsSelectedContactTableViewControllerDelegate
- (void)didSelectFlagsSelectedContactRecord:(NSMutableDictionary*)aContactDict {
    [self.flagsMainTemplateDataManager saveContactToOrderCart:aContactDict];
    NSMutableArray* selectedContactList = [self.flagsMainTemplateDataManager retrieveSelectedContactListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedContactList];
    [self.flagsContactTableViewController refreshContactList];
}

- (MBProgressHUD*)retrieveProgressHUDFromParentViewController {
    return self.HUD;
}

- (UIViewController*)retrieveSelectedContactParentViewController {
    return self;
}

- (int)retrieveFlagsSelectedContactParentActionType {
    return self.flagsMainTemplateDataManager.actionType;
}

- (NSNumber*)retrieveShowLocationCodeFlag {
    return self.flagsLocationTableViewController.showLocationCode;
}

- (void)didSelectFlagsSelectedLocationRecord:(NSMutableDictionary*)aLocationDict {
    [self.flagsMainTemplateDataManager saveLocationToOrderCart:aLocationDict];
    NSMutableArray* selectedLocationList = [self.flagsMainTemplateDataManager retrieveSelectedLocationListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedLocationList];
    [self.flagsLocationTableViewController refreshLocationList];
}

- (NSString*)retrieveFlagsSelectedContactParentFlagDescrTypeCode {
    return self.flagsMainTemplateDataManager.flagDescrTypeCode;
}

- (NSString*)retrieveFlagsSelectedContactParentActionTypeTitle {
    return self.flagsMainTemplateDataManager.actionTypeTitle;
}

- (NSString*)retrieveFlagsSelectedContactParentIURKeyText {
    return self.flagsMainTemplateDataManager.iURKeyText;
}

- (NSString*)retrieveFlagsSelectedContactParentAssignmentType {
    return self.flagsMainTemplateDataManager.assignmentType;
}

@end
