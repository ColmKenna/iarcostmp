//
//  ActivateTemplateViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/04/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ActivateTemplateViewController.h"

@interface ActivateTemplateViewController ()

@end

@implementation ActivateTemplateViewController
@synthesize presentDelegate = _presentDelegate;
@synthesize baseScrollContentView = _baseScrollContentView;
@synthesize baseTableContentView = _baseTableContentView;
//@synthesize baseImageView = _baseImageView;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize activateLocalViewController = _activateLocalViewController;
@synthesize activateEnterpriseViewController = _activateEnterpriseViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [self.globalNavigationController willMoveToParentViewController:nil];
    [self.globalNavigationController.view removeFromSuperview];
    [self.globalNavigationController removeFromParentViewController];
    [[self.baseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.baseScrollContentView != nil) { self.baseScrollContentView = nil; }
    
    if (self.baseTableContentView != nil) { self.baseTableContentView = nil; }
//    self.baseImageView = nil;
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.activateLocalViewController != nil) { self.activateLocalViewController = nil; }
    if (self.activateEnterpriseViewController != nil) { self.activateEnterpriseViewController = nil; }
    
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    [[self.baseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.isNotFirstLoaded = YES;
    self.activateLocalViewController = [[[ActivateLocalViewController alloc] init] autorelease];
    self.activateLocalViewController.presentDelegate = self;
    self.activateLocalViewController.actionDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.activateLocalViewController] autorelease];
    [self addChildViewController:self.globalNavigationController];
    self.globalNavigationController.view.frame = self.baseTableContentView.frame;
    [self.baseTableContentView addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSArray* subviewsList = [self.baseTableContentView subviews];
//    for (UIView* subview in subviewsList) {
//        if(self.globalNavigationController != nil && [self.globalNavigationController.view isEqual:subview]) {
//            [self.globalNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//            break;
//        }
//    }
//}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self.presentDelegate didDismissPresentView];
}

#pragma mark ActivateLocalActionDelegate
- (void)useEnterpriseEditionDelegate {
    self.activateEnterpriseViewController = [[[ActivateEnterpriseViewController alloc] init] autorelease];
    self.activateEnterpriseViewController.actionDelegate = self;
    self.activateEnterpriseViewController.presentDelegate = self;
    [self.globalNavigationController willMoveToParentViewController:nil];
    [self.globalNavigationController removeFromParentViewController];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.activateEnterpriseViewController] autorelease];
    self.globalNavigationController.view.frame = self.baseTableContentView.frame;
    [self addChildViewController:self.globalNavigationController];
    [self.baseTableContentView addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self];
    NSUInteger subviewLength = [self.baseTableContentView.subviews count];
    [UIView transitionFromView:[self.baseTableContentView.subviews objectAtIndex:subviewLength - 2]
                        toView:[self.baseTableContentView.subviews objectAtIndex:subviewLength - 1]
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        
                    }
     ];
}

#pragma mark ActivateEnterpriseActionDelegate
- (void)backActionDelegate {
    [self.globalNavigationController willMoveToParentViewController:nil];
    [self.globalNavigationController removeFromParentViewController];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.activateLocalViewController] autorelease];
    self.globalNavigationController.view.frame = self.baseTableContentView.frame;
    [self addChildViewController:self.globalNavigationController];
    [self.baseTableContentView addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self];
    NSUInteger subviewLength = [self.baseTableContentView.subviews count];
    [UIView transitionFromView:[self.baseTableContentView.subviews objectAtIndex:subviewLength - 2]
                        toView:[self.baseTableContentView.subviews objectAtIndex:subviewLength - 1]
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                    }
     ];
}

@end
