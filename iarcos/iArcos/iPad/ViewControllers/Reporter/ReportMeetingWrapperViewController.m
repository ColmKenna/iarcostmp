//
//  ReportMeetingWrapperViewController.m
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportMeetingWrapperViewController.h"

@interface ReportMeetingWrapperViewController ()

@end

@implementation ReportMeetingWrapperViewController
@synthesize myDelegate = _myDelegate;
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize customiseContentView = _customiseContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize iUR = _iUR;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.customiseScrollContentView = nil;
    self.customiseContentView = nil;
    self.globalNavigationController = nil;
    self.iUR = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    ReportMeetingTableViewController* rmtvc = [[ReportMeetingTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    rmtvc.myDelegate = self;
    rmtvc.iUR = self.iUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:rmtvc] autorelease];
    [rmtvc release];
    [self addChildViewController:self.globalNavigationController];
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;
    [self.globalNavigationController didMoveToParentViewController:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.globalNavigationController willMoveToParentViewController:nil];
    [[self.customiseContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.globalNavigationController removeFromParentViewController];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self.myDelegate didDismissCustomisePresentView];
}

@end
