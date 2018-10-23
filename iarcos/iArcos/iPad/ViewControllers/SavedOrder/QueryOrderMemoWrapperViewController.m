//
//  QueryOrderMemoWrapperViewController.m
//  Arcos
//
//  Created by David Kilmartin on 28/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMemoWrapperViewController.h"

@interface QueryOrderMemoWrapperViewController ()

@end

@implementation QueryOrderMemoWrapperViewController
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize customiseContentView = _customiseContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myDelegate = _myDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize editDelegate = _editDelegate;
@synthesize navgationBarTitle = _navgationBarTitle;
@synthesize actionType = _actionType;
@synthesize IUR = _IUR;
@synthesize locationIUR = _locationIUR;
@synthesize taskIUR = _taskIUR;
@synthesize contactIUR = _contactIUR;
@synthesize memoEmployeeIUR = _memoEmployeeIUR;
@synthesize taskCompletionDate = _taskCompletionDate;
@synthesize taskCurrentIndexPath = _taskCurrentIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.customiseScrollContentView = nil;
    self.customiseContentView = nil;
    self.globalNavigationController = nil;
    self.navgationBarTitle = nil;
    self.actionType = nil;
    self.IUR = nil;
    self.locationIUR = nil;
    self.taskIUR = nil;
    self.contactIUR = nil;
    self.memoEmployeeIUR = nil;
    self.taskCompletionDate = nil;
    self.taskCurrentIndexPath = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    QueryOrderMemoTableViewController* qomtvc =[[QueryOrderMemoTableViewController alloc]initWithNibName:@"QueryOrderMemoTableViewController" bundle:nil];
    qomtvc.myDelegate = self;
    qomtvc.refreshDelegate = self;
    qomtvc.editDelegate = self;
    qomtvc.actionType = self.actionType;
    qomtvc.title = self.navgationBarTitle;
    qomtvc.IUR = self.IUR;
    qomtvc.locationIUR = self.locationIUR;
    qomtvc.taskIUR = self.taskIUR;
    qomtvc.contactIUR = self.contactIUR;
    qomtvc.memoEmployeeIUR = self.memoEmployeeIUR;
    qomtvc.taskCompletionDate = self.taskCompletionDate;
    qomtvc.taskCurrentIndexPath = self.taskCurrentIndexPath;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qomtvc] autorelease];
    [qomtvc release];
    [self addChildViewController:self.globalNavigationController];
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;
    [self.globalNavigationController didMoveToParentViewController:self];
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

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

- (void)refreshParentContentByCreate:(NSIndexPath*)anIndexPath; {
    [self.refreshDelegate refreshParentContentByCreate:anIndexPath];
}

#pragma mark EditOperationViewControllerDelegate
- (void)editFinishedWithData:(id)contentString fieldName:(NSString *)fieldName forIndexpath:(NSIndexPath *)theIndexpath {
    [self.editDelegate editFinishedWithData:contentString fieldName:fieldName forIndexpath:theIndexpath];
}

@end
