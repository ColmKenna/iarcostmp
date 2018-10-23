//
//  CustomerNewsTaskWrapperViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerNewsTaskWrapperViewController.h"

@interface CustomerNewsTaskWrapperViewController ()

@end

@implementation CustomerNewsTaskWrapperViewController
@synthesize myDelegate = _myDelegate;
@synthesize customiseContentView = _customiseContentView;
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)dealloc {
    self.customiseContentView = nil;
    self.customiseScrollContentView = nil;
    self.globalNavigationController = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    CustomerNewsTaskTableViewController* cnttvc = [[CustomerNewsTaskTableViewController alloc] initWithNibName:@"CustomerNewsTaskTableViewController" bundle:nil];
    cnttvc.myDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cnttvc] autorelease];
    [cnttvc release];
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

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}


@end
