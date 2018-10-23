//
//  AccountNumberWrapperViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "AccountNumberWrapperViewController.h"

@interface AccountNumberWrapperViewController ()

@end

@implementation AccountNumberWrapperViewController
@synthesize refreshDelegate = _refreshDelegate;
@synthesize customiseContentView = _customiseContentView;
@synthesize customiseScrollContentView = _customiseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize locationIUR = _locationIUR;
@synthesize fromLocationIUR = _fromLocationIUR;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.customiseContentView = nil;
    self.customiseScrollContentView = nil;
    self.globalNavigationController = nil;
    self.locationIUR = nil;
    self.fromLocationIUR = nil;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    AccountNumberTableViewController* antvc =[[AccountNumberTableViewController alloc]initWithNibName:@"AccountNumberTableViewController" bundle:nil];
    antvc.delegate = self;
    antvc.refreshDelegate = self;
    antvc.locationIUR = self.locationIUR;
    antvc.fromLocationIUR = self.fromLocationIUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:antvc] autorelease];
    [antvc release];
    [self addChildViewController:self.globalNavigationController];
    [self.customiseContentView addSubview:self.globalNavigationController.view];
    self.globalNavigationController.view.frame = self.customiseContentView.frame;
    [self.globalNavigationController didMoveToParentViewController:self];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.globalNavigationController willMoveToParentViewController:nil];
    [[self.customiseContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.globalNavigationController removeFromParentViewController];
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


#pragma mark ModelViewDelegate
-(void)didDismissModalView {
    [self.delegate didDismissModalView];
}
#pragma mark GenericRefreshParentContentDelegate
-(void)refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

-(void)refreshParentContentWithData:(NSMutableDictionary *)aDataDict {
    [self.refreshDelegate refreshParentContentWithData:aDataDict];
}

@end
