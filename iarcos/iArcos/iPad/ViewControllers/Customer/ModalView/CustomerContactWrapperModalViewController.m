//
//  CustomerContactWrapperModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerContactWrapperModalViewController.h"

@implementation CustomerContactWrapperModalViewController
@synthesize myDelegate = _myDelegate;
@synthesize delegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize customiseContentView;
@synthesize customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize locationIUR = _locationIUR;
@synthesize navgationBarTitle = _navgationBarTitle;
@synthesize tableCellData = _tableCellData;
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
//    if (self.delegate != nil) { self.delegate = nil; }
//    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }  
    if (self.customiseContentView != nil) { self.customiseContentView = nil;}
    if (self.customiseScrollContentView != nil) { self.customiseScrollContentView = nil; }         
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }         
    if (self.locationIUR != nil) { self.locationIUR = nil; }          
    if (self.navgationBarTitle != nil) { self.navgationBarTitle = nil; }
    if (self.tableCellData != nil) { self.tableCellData = nil; }
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
    CustomerContactModalViewController* ccmvc =[[CustomerContactModalViewController alloc]initWithNibName:@"CustomerContactModalViewController" bundle:nil];
    ccmvc.myDelegate = self;
    ccmvc.delegate = self;
    ccmvc.refreshDelegate = self;
    ccmvc.tableCellData = self.tableCellData; 
    ccmvc.title = self.navgationBarTitle;
    ccmvc.locationIUR = self.locationIUR;
    ccmvc.actionType = self.actionType;
    ccmvc.actionDelegate = self;
    ccmvc.contactIUR = [self.tableCellData objectForKey:@"IUR"];
    if (![self.actionType isEqualToString:@"edit"]) {
        ccmvc.contactIUR = [NSNumber numberWithInt:0];
    }
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccmvc] autorelease];
    [ccmvc release];  
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

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {    
//    NSArray* subviewsList = [self.customiseContentView subviews];
//    for (UIView* subview in subviewsList) {
//        if(self.globalNavigationController != nil && [self.globalNavigationController.view isEqual:subview]) {
//            [self.globalNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//            break;
//        }
//    }
//}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}

- (void)didDismissModalView {
    [self.delegate didDismissModalView];
}

- (void)refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

- (void)refreshParentContentWithIUR:(NSNumber*)anIUR {
    [self.refreshDelegate refreshParentContentWithIUR:anIUR];
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self.actionDelegate refreshLocationInfoFromAccessTimesCalendar];
}

@end
