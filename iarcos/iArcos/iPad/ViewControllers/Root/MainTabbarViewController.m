//
//  MainTabbarViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "MainTabbarViewController.h"

@implementation MainTabbarViewController

@synthesize  myCustomerViewController=_myCustomerViewController;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize auxNavigationController = _auxNavigationController;
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
    self.auxNavigationController = nil;
    [myCustomerViewController release];
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
    self.selectedIndex = 1;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) {
        return;
    }
    [UIApplication sharedApplication].delegate.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
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

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSArray* subviewsList = [self.view subviews];
    for (UIView* subview in subviewsList) {
        if(self.auxNavigationController != nil && [self.auxNavigationController.view isEqual:subview]) {
            [self.auxNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
            break;
        }
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSArray* subviewsList = [self.view subviews];
        for (UIView* subview in subviewsList) {
            if(self.auxNavigationController != nil && [self.auxNavigationController.view isEqual:subview]) {
                [self.auxNavigationController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                break;
            }
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

@end
