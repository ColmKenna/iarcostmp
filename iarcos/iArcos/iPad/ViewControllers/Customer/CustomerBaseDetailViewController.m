//
//  CustomerBaseDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerBaseDetailViewController.h"
#import "GenericMasterTemplateViewController.h"
#import "CustomerGroupViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosConfigDataManager.h"
#import "ArcosRootViewController.h"

@interface CustomerBaseDetailViewController () {
    CustomerGroupViewController* _customerGroupViewController;
    UINavigationController* _customerGroupNavigationController;
    GenericMasterTemplateViewController* _genericMasterTemplateViewController;
    BOOL _intersectFlag;
    BOOL _isNotFinishedAnimation;
}

@property(nonatomic, retain) CustomerGroupViewController* customerGroupViewController;
@property(nonatomic, retain) UINavigationController* customerGroupNavigationController;
@property(nonatomic, retain) GenericMasterTemplateViewController* genericMasterTemplateViewController;
@property(nonatomic, assign) BOOL intersectFlag;
@property(nonatomic, assign) BOOL isNotFinishedAnimation;

- (void)layoutMySubviews;

@end

@implementation CustomerBaseDetailViewController
@synthesize myBarButtonItem;
@synthesize navigationDelegate = _navigationDelegate;
@synthesize customerGroupViewController = _customerGroupViewController;
@synthesize customerGroupNavigationController = _customerGroupNavigationController;
@synthesize genericMasterTemplateViewController = _genericMasterTemplateViewController;
@synthesize intersectFlag = _intersectFlag;
@synthesize isNotFinishedAnimation = _isNotFinishedAnimation;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize requestSourceName = _requestSourceName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.myBarButtonItem != nil) { self.myBarButtonItem = nil; }
    if (self.navigationDelegate != nil) { self.navigationDelegate = nil; }
    self.customerGroupViewController = nil;
    self.customerGroupNavigationController = nil;
    if (self.genericMasterTemplateViewController != nil) {
        [self.genericMasterTemplateViewController willMoveToParentViewController:nil];
        [self.genericMasterTemplateViewController.view removeFromSuperview];
        [self.genericMasterTemplateViewController removeFromParentViewController];
        self.genericMasterTemplateViewController = nil;
    }
    self.currentIndexPath = nil;
    self.requestSourceName = nil;
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithObjects:filterButton, nil];
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    [filterButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)filterPressed:(id)sender {
    ArcosStackedViewController* arcosStackedViewController = (ArcosStackedViewController*)self.parentViewController.parentViewController;
    
    [arcosStackedViewController processMoveMasterViewController:CGPointMake(1.0, 0)];
}

#pragma mark GenericMasterTemplateDelegate
- (void)processMoveMasterViewController:(CGPoint)velocity {
    if (!self.intersectFlag && !self.isNotFinishedAnimation && velocity.x > 0) {
        [self rightMoveMasterViewController];
    }
    if (self.intersectFlag && !self.isNotFinishedAnimation && velocity.x < 0) {
        [self leftMoveMasterViewController];
    }
}

- (void)rightMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.parentViewController.parentViewController.view.bounds;
    float masterWidth = viewBounds.size.width;
    self.genericMasterTemplateViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.genericMasterTemplateViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
        [self.genericMasterTemplateViewController layoutMySubviews];
    } completion:^(BOOL finished){
        self.isNotFinishedAnimation = NO;
        self.intersectFlag = YES;
    }];
}

- (void)leftMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.parentViewController.parentViewController.view.bounds;
    float masterWidth = self.parentViewController.parentViewController.view.bounds.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.genericMasterTemplateViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    } completion:^(BOOL finished){
        self.genericMasterTemplateViewController.view.frame = CGRectMake(-masterWidth, 0, 320.0, viewBounds.size.height);
        self.isNotFinishedAnimation = NO;
        self.intersectFlag = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutMySubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
}

#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.myBarButtonItem=barButtonItem;
    self.navigationItem.leftBarButtonItem=barButtonItem;
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem=nil;
}

- (void)layoutMySubviews {
    if (self.genericMasterTemplateViewController == nil) return;
    CGRect viewBounds = self.parentViewController.parentViewController.view.bounds;
    float masterWidth = self.parentViewController.parentViewController.view.bounds.size.width;
    if (self.intersectFlag) {
        self.genericMasterTemplateViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
    } else {
        self.genericMasterTemplateViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    }
}

-(NSMutableDictionary*)getSelectedCellData {
    return nil;
}

-(void)resetCurrentOrderAndWholesaler:(NSNumber*)locationIUR {
    //clear all orders
    [[OrderSharedClass sharedOrderSharedClass]clearCurrentOrder];
    [FileCommon removeFileAtPath:[FileCommon orderRestorePlistPath]];
    //reset the wholesaller of shared order class
    [[OrderSharedClass sharedOrderSharedClass]resetTheWholesellerWithLocation:locationIUR];
    [[OrderSharedClass sharedOrderSharedClass]refreshCurrentOrderDate];
}

-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    return nil;
}

-(void)resetCustomer:(NSMutableArray*)customers {

}

- (void)configWholesalerLogo {
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showWholesalerLogoFlag]) return;
    NSMutableDictionary* wholesalerDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"wholesaler"];
    NSNumber* imageIUR = [wholesalerDict objectForKey:@"ImageIUR"];
    UIImage* wholesalerImage = nil;
    if ([imageIUR intValue] > 0) {
        wholesalerImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:imageIUR];
    }
    if (wholesalerImage == nil) {
        wholesalerImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:1]];
        if (wholesalerImage == nil) {
            wholesalerImage = [UIImage imageNamed:[GlobalSharedClass shared].appImageName];
        }
    }
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController.myHeaderButton setBackgroundImage:wholesalerImage forState:UIControlStateNormal];
}

- (void)syncCustomerContactViewController {
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    int itemIndex = [arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].contactText];
    NSMutableDictionary* contactTabBarCellDict = [arcosRootViewController.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
    ArcosStackedViewController* contactArcosStackedViewController = [contactTabBarCellDict objectForKey:@"MyCustomController"];
    NSArray* tmpControllerList = contactArcosStackedViewController.rcsViewControllers;
    if ([tmpControllerList count] < 2) return;
    UINavigationController* customerInfoNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:1];
    CustomerInfoTableViewController* citvc = [customerInfoNavigationController.viewControllers objectAtIndex:0];
    if ([[GlobalSharedClass shared].currentSelectedLocationIUR isEqualToNumber:citvc.custIUR]) return;
    UINavigationController* auxGroupNavigationController = (UINavigationController*)contactArcosStackedViewController.myMasterViewController.masterViewController;
    CustomerGroupViewController* groupViewController = [auxGroupNavigationController.viewControllers objectAtIndex:0];
    [groupViewController resetButtonPressed:nil];
}

@end
