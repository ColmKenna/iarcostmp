//
//  CustomerContactLinkHeaderViewController.m
//  Arcos
//
//  Created by David Kilmartin on 02/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "CustomerContactLinkHeaderViewController.h"

@implementation CustomerContactLinkHeaderViewController
@synthesize linkHeaderRequestSource = _linkHeaderRequestSource;
@synthesize linkText = _linkText;
@synthesize addLinkButton = _addLinkButton;
@synthesize linkTextValue = _linkTextValue;
@synthesize locationList = _locationList;
@synthesize locationPopover = _locationPopover;
@synthesize linkHeaderViewControllerDelegate = _linkHeaderViewControllerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.linkText != nil) { self.linkText = nil; }
    if (self.addLinkButton != nil) { self.addLinkButton = nil; }
    if (self.linkTextValue != nil) { self.linkTextValue = nil; }
    if (self.locationList != nil) { self.locationList = nil; }    
    if (self.locationPopover != nil) { self.locationPopover = nil; }        
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self processDisplayList];
    
    self.linkText.text = self.linkTextValue;
    
    
    
}

- (void)processDisplayList {
    if (self.linkHeaderRequestSource == CustomerContactLinkHeaderRequestLocation) {
        NSNumber* needInactiveRecord = [SettingManager DisplayInactiveRecord];
        NSPredicate* predicate = nil;
        if (![needInactiveRecord boolValue]) {
            predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'LT' and Active = 1 and DescrDetailCode = [c] %@", @"BUGR"];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode = 'LT' and DescrDetailCode = [c] %@", @"BUGR"];
        }
        
        NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"DescrDetail" withPropertiesToFetch:nil  withPredicate:predicate withSortDescNames:nil withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
        if ([objectsArray count] > 0) {
            NSDictionary* descrDetailDict = [objectsArray objectAtIndex:0];
            NSNumber* descrDetailIUR = [descrDetailDict objectForKey:@"DescrDetailIUR"];
            NSPredicate* locationPredicate = nil;
            if (![needInactiveRecord boolValue]) {
                locationPredicate = [NSPredicate predicateWithFormat:@"LTiur = %@ and Active = 1", descrDetailIUR];
            }else{
                locationPredicate = [NSPredicate predicateWithFormat:@"LTiur = %@", descrDetailIUR];
            }
            NSArray* sortDescNames = [NSArray arrayWithObjects:@"Name",nil];
            NSMutableArray* locationObjectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Location" withPropertiesToFetch:nil  withPredicate:locationPredicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:nil];
            self.locationList = locationObjectsArray;
        } else {
            self.locationList = objectsArray;
        }
    } else {
        self.locationList = [[ArcosCoreData sharedArcosCoreData]outletsWithMasterIUR:[NSNumber numberWithInt:-1] withResultType:NSDictionaryResultType];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (IBAction)addLinkPressed:(id)sender {
    if (self.locationPopover != nil) {
        self.locationPopover = nil;
    }
    
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = YES;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];    
    self.locationPopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];    
    self.locationPopover.popoverContentSize = CGSizeMake(700, 700);    
    [self.locationPopover presentPopoverFromRect:self.addLinkButton.bounds inView:self.addLinkButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [CSLTVC resetCustomer:self.locationList];
    [CSLTVC release];
    CSLTVC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
}

#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    if (self.locationPopover != nil && [self.locationPopover isPopoverVisible]) {
        [self.locationPopover dismissPopoverAnimated:YES];
    }    
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    [self.linkHeaderViewControllerDelegate didSelectCustomerSelectionListingRecord:aCustDict];
//    [self didDismissSelectionPopover];
}

@end
