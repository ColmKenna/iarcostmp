//
//  QueryOrderTaskWrapperViewController.m
//  Arcos
//
//  Created by David Kilmartin on 27/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskWrapperViewController.h"

@interface QueryOrderTaskWrapperViewController ()

@end

@implementation QueryOrderTaskWrapperViewController
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
@synthesize contactIUR = _contactIUR;
@synthesize processingIndexPath = _processingIndexPath;

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
    self.contactIUR = nil;
    self.processingIndexPath = nil;
    
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
    QueryOrderTaskTableViewController* qottvc =[[QueryOrderTaskTableViewController alloc]initWithNibName:@"QueryOrderTaskTableViewController" bundle:nil];
    qottvc.processingIndexPath = self.processingIndexPath;
    qottvc.myDelegate = self;
    qottvc.refreshDelegate = self;
    qottvc.editDelegate = self;
    qottvc.actionType = self.actionType;
    qottvc.title = self.navgationBarTitle;
    qottvc.IUR = self.IUR;
    qottvc.locationIUR = self.locationIUR;
    qottvc.contactIUR = self.contactIUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qottvc] autorelease];
    [qottvc release];
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

- (void)refreshParentContentByEdit {
    [self.refreshDelegate refreshParentContentByEdit];
}

- (void)refreshParentContentByEditType:(BOOL)aFlag closeActualValue:(BOOL)aCloseActualValue indexPath:(NSIndexPath *)anIndexPath {
    [self.refreshDelegate refreshParentContentByEditType:aFlag closeActualValue:aCloseActualValue  indexPath:anIndexPath];
}

#pragma mark EditOperationViewControllerDelegate
- (void)editFinishedWithData:(id)contentString fieldName:(NSString*)fieldName forIndexpath:(NSIndexPath*)theIndexpath {
    [self.editDelegate editFinishedWithData:contentString fieldName:fieldName forIndexpath:theIndexpath];
}

@end
