//
//  CustomerDetailsWrapperModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsWrapperModalViewController.h"

@implementation CustomerDetailsWrapperModalViewController
@synthesize myDelegate = _myDelegate;
@synthesize delegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize customiseContentView;
@synthesize customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize locationIUR = _locationIUR;
@synthesize navgationBarTitle = _navgationBarTitle;
@synthesize actionType = _actionType;
@synthesize actionDelegate = _actionDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.delegate != nil) { self.delegate = nil; }           
    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }    
    if (self.customiseContentView != nil) { self.customiseContentView = nil;}          
    if (self.customiseScrollContentView != nil) { self.customiseScrollContentView = nil; }         
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }         
    if (self.locationIUR != nil) { self.locationIUR = nil; }          
    if (self.navgationBarTitle != nil) { self.navgationBarTitle = nil; }
    if (self.actionType != nil) { self.actionType = nil; }
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.customiseContentView = nil;
    self.customiseScrollContentView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CustomerDetailsModalViewController* cdmvc =[[CustomerDetailsModalViewController alloc]initWithNibName:@"CustomerDetailsModalViewController" bundle:nil];
    cdmvc.actionType = self.actionType;
    cdmvc.myDelegate = self;
    cdmvc.delegate = self;
    cdmvc.refreshDelegate = self;
    cdmvc.actionDelegate = self;
//    cdmvc.title = [NSString stringWithFormat:@"Details for %@", [aCustDict objectForKey:@"Name"]]; 
    cdmvc.title = self.navgationBarTitle;
    cdmvc.locationIUR = self.locationIUR;        
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdmvc] autorelease];
    [cdmvc release];  
    [self addChildViewController:self.globalNavigationController];
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;
    [self.globalNavigationController didMoveToParentViewController:self];
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
    [self.globalNavigationController willMoveToParentViewController:nil];
    [[self.customiseContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.globalNavigationController removeFromParentViewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didDismissModalView {
    [self.delegate didDismissModalView];
}

- (void)refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

- (void)refreshParentContentByEdit {
    [self.refreshDelegate refreshParentContentByEdit];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

@end
