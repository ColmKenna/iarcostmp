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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.flagsLocationTableViewController = [[[FlagsLocationTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsLocationTableViewController.selectionDelegate = self;
        self.flagsLocationTableViewController.hideAllButtonFlag = YES;
        NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
        [self.flagsLocationTableViewController resetCustomer:locationList];
        self.flagsLocationNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsLocationTableViewController] autorelease];
        self.flagsContactTableViewController = [[[FlagsContactTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsContactTableViewController.actionDelegate = self;
        self.flagsContactNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsContactTableViewController] autorelease];
        self.flagsSelectedContactTableViewController = [[[FlagsSelectedContactTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.flagsSelectedContactTableViewController.actionDelegate = self;
        self.flagsSelectedContactNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.flagsSelectedContactTableViewController] autorelease];
        
        self.layoutDict = @{@"AuxFlagsLocation" : self.flagsLocationNavigationController.view, @"AuxFlagsContact" : self.flagsContactNavigationController.view, @"AuxFlagsSelectedContact" : self.flagsSelectedContactNavigationController.view};
        self.flagsMainTemplateDataManager = [[[FlagsMainTemplateDataManager alloc] init] autorelease];
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
    
    self.flagsLocationTableViewController = nil;
    self.flagsLocationNavigationController = nil;
    self.flagsContactTableViewController = nil;
    self.flagsContactNavigationController = nil;
    self.flagsSelectedContactTableViewController = nil;
    self.flagsSelectedContactNavigationController = nil;
    self.layoutDict = nil;
    self.flagsMainTemplateDataManager = nil;
    
    [super dealloc];
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


#pragma mark - FlagsContactTableViewControllerDelegate
- (void)didSelectFlagsContactRecord:(NSMutableDictionary*)aContactDict {
    [self.flagsMainTemplateDataManager saveContactToOrderCart:aContactDict];
    NSMutableArray* selectedContactList = [self.flagsMainTemplateDataManager retrieveSelectedContactListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedContactList];
}
- (NSMutableDictionary*)retrieveContactParentOrderCart {
    return self.flagsMainTemplateDataManager.contactOrderCart;
}

#pragma mark - FlagsSelectedContactTableViewControllerDelegate
- (void)didSelectFlagsSelectedContactRecord:(NSMutableDictionary*)aContactDict {
    [self.flagsMainTemplateDataManager saveContactToOrderCart:aContactDict];
    NSMutableArray* selectedContactList = [self.flagsMainTemplateDataManager retrieveSelectedContactListProcessor];
    [self.flagsSelectedContactTableViewController resetSelectedContact:selectedContactList];
    [self.flagsContactTableViewController refreshContactList];
}

@end
