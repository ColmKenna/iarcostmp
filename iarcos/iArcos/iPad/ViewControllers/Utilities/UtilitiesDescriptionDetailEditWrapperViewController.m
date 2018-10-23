//
//  UtilitiesDescriptionDetailEditWrapperViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionDetailEditWrapperViewController.h"

@implementation UtilitiesDescriptionDetailEditWrapperViewController
@synthesize myDelegate = _myDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize delegate = _delegate;
@synthesize navigationDelegate = _navigationDelegate;
@synthesize customiseContentView;
@synthesize customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize navgationBarTitle = _navgationBarTitle;
@synthesize tableCellData = _tableCellData;
@synthesize actionType = _actionType;
@synthesize descrTypeCode = _descrTypeCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
//    if (self.refreshDelegate != nil) { self.refreshDelegate = nil; }               
//    if (self.delegate != nil) { self.delegate = nil; }           
//    if (self.navigationDelegate != nil) { self.navigationDelegate = nil; }               
    if (self.customiseContentView != nil) { self.customiseContentView = nil;}
    if (self.customiseScrollContentView != nil) { self.customiseScrollContentView = nil; }         
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }                      
    if (self.navgationBarTitle != nil) { self.navgationBarTitle = nil; }
    if (self.tableCellData != nil) { self.tableCellData = nil; }
    if (self.actionType != nil) { self.actionType = nil; }
    if (self.descrTypeCode != nil) { self.descrTypeCode = nil; }    
        
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationDelegate hideNavigationBar];    
    [self.navigationController setNavigationBarHidden:YES animated:YES];    
    UtilitiesDescriptionDetailEditViewController* uddevc =[[UtilitiesDescriptionDetailEditViewController alloc]initWithNibName:@"UtilitiesDescriptionDetailEditViewController" bundle:nil];
    uddevc.myDelegate = self;
    uddevc.refreshDelegate = self;
    uddevc.delegate = self;
    uddevc.tableCellData = self.tableCellData; 
    NSLog(@"self.title is %@", self.title);
    uddevc.title = self.navgationBarTitle;
    uddevc.actionType = self.actionType;
    uddevc.descrTypecode = self.descrTypeCode;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:uddevc] autorelease];
    [uddevc release];  
    
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{    
    [super viewWillDisappear:animated];
    for (UIView* aView in [self.customiseContentView subviews]) {
        [aView removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
}

- (void)didDismissModalView {
    [self.delegate didDismissModalView];
}

- (void)refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}

@end
