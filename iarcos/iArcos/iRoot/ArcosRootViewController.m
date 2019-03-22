//
//  RootViewController.m
//  iArcos
//
//  Created by David Kilmartin on 07/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ArcosRootViewController.h"
#import "UtilitiesArcosSplitViewController.h"
#import "SubMenuPlaceHolderTableViewController.h"
#import "ActivateLocalViewController.h"
#import "ActivateTemplateViewController.h"

@interface ArcosRootViewController ()

- (void)preProcessSelectedRightViewController;

@end

@implementation ArcosRootViewController
@synthesize dividerLabel = _dividerLabel;
@synthesize masterWidth = _masterWidth;
@synthesize isMasterViewNotShowing = _isMasterViewNotShowing;
@synthesize dividerWidth = _dividerWidth;
@synthesize customerMasterViewController = _customerMasterViewController;
@synthesize masterNavigationController = _masterNavigationController;

@synthesize selectedRightViewController = _selectedRightViewController;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
    for (int i = 0; i < [self.childViewControllers count]; i++) {
        UIViewController* tmpViewController = [self.childViewControllers objectAtIndex:i];
        [tmpViewController willMoveToParentViewController:nil];
        [tmpViewController.view removeFromSuperview];
        [tmpViewController removeFromParentViewController];
    }
//    [self.masterNavigationController willMoveToParentViewController:nil];
//    [self.masterNavigationController.view removeFromSuperview];
//    [self.masterNavigationController removeFromParentViewController];
    [self.dividerLabel removeFromSuperview];
//    [self.selectedRightViewController willMoveToParentViewController:nil];
//    [self.selectedRightViewController.view removeFromSuperview];
//    [self.selectedRightViewController removeFromParentViewController];
    self.dividerLabel = nil;
    [self.customerMasterViewController.scanApiTimer invalidate];
    self.customerMasterViewController.scanApiTimer = nil;
    self.customerMasterViewController = nil;
    self.masterNavigationController = nil;
    self.selectedRightViewController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [FileCommon removeAllFileUnderFolder:@"meeting"];
    self.masterWidth = [GlobalSharedClass shared].mainMasterWidth;   //56.0f;
    self.isMasterViewNotShowing = NO;
    self.dividerWidth = 2.0f;
    self.customerMasterViewController = [[[CustomerMasterViewController alloc] initWithNibName:@"CustomerMasterViewController" bundle:nil] autorelease];
    self.customerMasterViewController.actionDelegate = self;
    self.customerMasterViewController.subMenuDelegate = self;
    self.masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.customerMasterViewController] autorelease];
    
    self.dividerLabel = [[[SplitDividerUILabel alloc] init] autorelease];
    
    
    [self addChildViewController:self.masterNavigationController];
    [self.view addSubview:self.masterNavigationController.view];
    [self.view addSubview:self.dividerLabel];
    [self.masterNavigationController didMoveToParentViewController:self];
    
    [self layoutSubviews];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].delegate.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self layoutSubviews];
    if (self.isNotFirstLoaded) {
        return;
    }
    self.isNotFirstLoaded = YES;
    NSNumber* configRecordQuantity = [[ArcosCoreData sharedArcosCoreData] entityRecordQuantity:@"Config"];
    ActivateAppStatusManager* appStatusManager = [ActivateAppStatusManager appStatusInstance];
    if ([configRecordQuantity intValue] == 0 && [appStatusManager getAppStatus].intValue == 0) {
        ActivateTemplateViewController* activateTemplateViewController = [[ActivateTemplateViewController alloc] init];
        activateTemplateViewController.presentDelegate = self;
        [self presentViewController:activateTemplateViewController animated:NO completion:nil];
        [activateTemplateViewController release];
    } else if([configRecordQuantity intValue] != 0 && [appStatusManager getAppStatus].intValue == 0) {//existing
        [appStatusManager saveActivateAppStatus];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    CGRect masterRect, detailRect, dividerRect;
    float diff = 0.0f;
    if ([ArcosUtils systemVersionGreaterThanSeven]) {
        diff = 1.0f;
    }
    float positionDiff = 0.0f;
    if ([ArcosUtils systemMajorVersion] >= 11) {
        positionDiff = 1.0f;
    }
    masterRect = CGRectMake(0, 0, self.masterWidth - self.dividerWidth + 1.0f + diff, self.view.bounds.size.height);
    dividerRect = CGRectMake(self.masterWidth - self.dividerWidth + 1.0 + diff, 0, self.dividerWidth, self.view.bounds.size.height);
    detailRect = CGRectMake(self.masterWidth + positionDiff, 0, self.view.bounds.size.width - self.masterWidth - positionDiff, self.view.bounds.size.height);
    self.masterNavigationController.view.frame = masterRect;
    self.dividerLabel.frame = dividerRect;
    self.selectedRightViewController.view.frame = detailRect;
//    self.rightSelectedNavigationViewController.view.frame = detailRect;
}

#pragma mark CustomerMasterViewControllerDelegate
- (void)didSelectTableRow:(NSIndexPath*)anIndexPath myCustomController:(UIViewController *)aViewController{
    [self preProcessSelectedRightViewController];
    [self addChildViewController:aViewController];
    [self.view addSubview:aViewController.view];
    self.selectedRightViewController = aViewController;
    [self layoutSubviews];
    [self.selectedRightViewController didMoveToParentViewController:self];
}

- (void)preProcessSelectedRightViewController {
    [self.selectedRightViewController willMoveToParentViewController:nil];
    [self.selectedRightViewController.view removeFromSuperview];
    [self.selectedRightViewController removeFromParentViewController];
}

//#pragma mark CustomerListingViewControllerDelegate
//- (void)didSelectListingRowToControlSubMenu:(NSMutableDictionary*)aCellData {
//    [self.customerMasterViewController processSubMenuByCustomerListing:aCellData];
//}

#pragma mark SubMenuTableViewControllerDelegate
- (void)didSelectSubMenuListingRow:(NSIndexPath*)anIndexPath viewController:(UIViewController *)aViewController {
    [self preProcessSelectedRightViewController];
    [self addChildViewController:aViewController];
    [self.view addSubview:aViewController.view];    
    self.selectedRightViewController = aViewController;
    [self layoutSubviews];
    [aViewController didMoveToParentViewController:self];
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
