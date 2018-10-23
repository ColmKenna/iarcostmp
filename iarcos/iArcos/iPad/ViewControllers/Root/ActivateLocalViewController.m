//
//  ActivateLocalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateLocalViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "CustomerGroupViewController.h"

@interface ActivateLocalViewController ()

@end

@implementation ActivateLocalViewController
@synthesize presentDelegate = _presentDelegate;
@synthesize actionDelegate = _actionDelegate;
@synthesize headerDescLabel = _headerDescLabel;
@synthesize localButton = _localButton;
@synthesize enterpriseButton = _enterpriseButton;
@synthesize statusLabel = _statusLabel;
@synthesize tableProgressView = _tableProgressView;
@synthesize myProgressView = _myProgressView;
@synthesize boardView = _boardView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize activateLocalDataManager = _activateLocalDataManager;
@synthesize activateAppStatusManager = _activateAppStatusManager;
@synthesize activateConfigurationDataManager = _activateConfigurationDataManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.headerDescLabel = nil;
    if (self.localButton != nil) { self.localButton = nil; }
    if (self.enterpriseButton != nil) { self.enterpriseButton = nil; }
    if (self.statusLabel != nil) { self.statusLabel = nil; }
    self.tableProgressView = nil;
    if (self.myProgressView != nil) { self.myProgressView = nil; }
    self.boardView = nil;
    self.backgroundImageView = nil;
    if (self.activateLocalDataManager != nil) { self.activateLocalDataManager = nil; }
    if (self.activateAppStatusManager != nil) { self.activateAppStatusManager = nil; }
    self.activateConfigurationDataManager = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.activateLocalDataManager = [[[ActivateLocalDataManager alloc] init] autorelease];
    self.activateLocalDataManager.updateDelegate = self;
    self.activateAppStatusManager = [ActivateAppStatusManager appStatusInstance];
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.activateConfigurationDataManager = [ActivateConfigurationDataManager configInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.boardView.center = self.view.center;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosLandscape.png"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosPortrait.png"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.boardView.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.boardView.center = self.view.center;
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosLandscape.png"];
    } else {
        self.backgroundImageView.image = [UIImage imageNamed:@"ArcosPortrait.png"];
    }
}

- (IBAction)useLocalData:(id)sender {
    self.backgroundImageView.alpha = 0.60;
    self.headerDescLabel.hidden = YES;
    self.localButton.hidden = YES;
    self.enterpriseButton.hidden = YES;
    self.statusLabel.hidden = NO;
    self.tableProgressView.hidden = NO;
    self.myProgressView.hidden = NO;
    [self.activateLocalDataManager importAllData];
    
}

- (IBAction)useEnterpriseEdition:(id)sender {
    [self.actionDelegate useEnterpriseEditionDelegate];
}

- (IBAction)exitAction:(id)sender {
    [self.presentDelegate didDismissPresentView];
}

#pragma mark ActivateProgressViewUpdateDelegate
- (void)startImportData:(NSString *)aSelectorName {
    [self.myProgressView setProgress:0.0 animated:NO];
    self.statusLabel.text = [NSString stringWithFormat:@"Importing %@ Data", aSelectorName];
}

- (void)activateProgressViewWithValue:(float)aProgressValue animated:(BOOL)flag {
    [self.myProgressView setProgress:aProgressValue animated:flag];
}

- (void)completeLoadingData:(NSString *)aSelectorName {
//    self.statusLabel.text = [NSString stringWithFormat:@"Complete importing %@ data", aSelectorName];
}

- (void)mainLoadingComplete {
    /*
    ArcosAppDelegate_iPad* delegate = [[UIApplication sharedApplication] delegate];
    
    UITabBarController* tabbar = (UITabBarController*) [ArcosUtils getRootView];
    
    UISplitViewController* myCustomerSplitViewController = (UISplitViewController*)[tabbar.viewControllers objectAtIndex:1];
    UINavigationController* navigationController = [myCustomerSplitViewController.viewControllers objectAtIndex:0];
    CustomerGroupViewController* groupViewController = [navigationController.viewControllers objectAtIndex:0];
    groupViewController.segmentBut.selectedSegmentIndex = 0;
    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged];
    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
    */
    [self.activateAppStatusManager loadDemoSettingFromBundle];
//    [self.activateAppStatusManager saveDemoAppStatus];
    [self.activateConfigurationDataManager createConfigurationPlist];
    [self.activateConfigurationDataManager presetConfigurationPlistForDemo];
    [self.presentDelegate didDismissPresentView];
}

- (void)activateTableProgressViewWithValue:(float)aProgressValue animated:(BOOL)flag {
    [self.tableProgressView setProgress:aProgressValue animated:flag];
}

@end
