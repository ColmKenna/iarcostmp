//
//  MeetingAttendeesContactsHeaderViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import "MeetingAttendeesContactsHeaderViewController.h"

@interface MeetingAttendeesContactsHeaderViewController ()

@end

@implementation MeetingAttendeesContactsHeaderViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize addButton = _addButton;
@synthesize customerGroupDataManager = _customerGroupDataManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.customerGroupDataManager = [[[CustomerGroupDataManager alloc] init] autorelease];
    
}

- (void)dealloc {
    self.addButton = nil;
    self.customerGroupDataManager = nil;
    
    [super dealloc];
}

- (IBAction)addButtonPressed:(id)sender {
    NSMutableArray* contactLocationObjectList = [[ArcosCoreData sharedArcosCoreData] contactLocationWithCOIUR:[NSNumber numberWithInt:-1]];
    [self.customerGroupDataManager sortContactLocationResultList:contactLocationObjectList];
    ContactSelectionListingTableViewController* contactSelectionListingTableViewController = [[ContactSelectionListingTableViewController alloc] initWithNibName:@"ContactSelectionListingTableViewController" bundle:nil];
    contactSelectionListingTableViewController.actionDelegate = self;
    [contactSelectionListingTableViewController resetContact:contactLocationObjectList];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:contactSelectionListingTableViewController];
    tmpNavigationController.preferredContentSize = CGSizeMake(700.0f, 700.0f);
    tmpNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    tmpNavigationController.popoverPresentationController.sourceView = self.addButton;
    
    [[self.actionDelegate retrieveParentViewController] presentViewController:tmpNavigationController animated:YES completion:nil];
    [tmpNavigationController release];
    [contactSelectionListingTableViewController release];
}

#pragma mark ContactSelectionListingTableViewControllerDelegate
- (void)didDismissContactSelectionPopover {
    [[self.actionDelegate retrieveParentViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectContactSelectionListing:(NSMutableArray*)aContactList {
    [self.actionDelegate meetingAttendeesDidSelectContactSelectionListing:aContactList];
}

@end
