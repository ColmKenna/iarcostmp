//
//  ArcosSplitViewController.m
//  iArcos
//
//  Created by David Kilmartin on 07/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ArcosSplitViewController.h"
#import "SplitDividerUILabel.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"
#import "ArcosSplitMasterViewController.h"

@interface ArcosSplitViewController () {
    float _dividerWidth;
    BOOL _intersectFlag;
    BOOL _isNotFinishedAnimation;
    ArcosSplitMasterViewController* _arcosSplitMasterViewController;
}
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, assign) BOOL intersectFlag;
@property(nonatomic, assign) BOOL isNotFinishedAnimation;
@property(nonatomic, retain) ArcosSplitMasterViewController* arcosSplitMasterViewController;

- (void)layoutMySubviews;
- (void)layoutLandscapeSubviews;
- (void)layoutPortraitSubviews;
@end

@implementation ArcosSplitViewController
@synthesize rcsViewControllers = _rcsViewControllers;
//@synthesize splitDividerUILabel = _splitDividerUILabel;
@synthesize dividerWidth = _dividerWidth;
@synthesize myScrollView = _myScrollView;
@synthesize myTableView = _myTableView;
@synthesize intersectFlag = _intersectFlag;
@synthesize isNotFinishedAnimation = _isNotFinishedAnimation;
@synthesize arcosSplitMasterViewController = _arcosSplitMasterViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.splitDividerUILabel = [[[SplitDividerUILabel alloc] init] autorelease];
    self.dividerWidth = 2.0f;
}

- (void)dealloc {
    self.rcsViewControllers = nil;
    self.myTableView = nil;
    self.myScrollView = nil;
    self.arcosSplitMasterViewController = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIViewController* detailViewController = [self.rcsViewControllers objectAtIndex:1];
    [self addChildViewController:detailViewController];
    [self.myTableView addSubview:detailViewController.view];
    [detailViewController didMoveToParentViewController:self];
    if (self.arcosSplitMasterViewController == nil) {
        self.arcosSplitMasterViewController = [[[ArcosSplitMasterViewController alloc] initWithNibName:@"ArcosSplitMasterViewController" bundle:nil] autorelease];
        UIViewController* masterViewController = [self.rcsViewControllers objectAtIndex:0];
        self.arcosSplitMasterViewController.masterViewController = masterViewController;
    }
    [self addChildViewController:self.arcosSplitMasterViewController];
    [self.myTableView addSubview:self.arcosSplitMasterViewController.view];
    [self.arcosSplitMasterViewController didMoveToParentViewController:self];
    
    [self layoutMySubviews];
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [detailViewController.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutMySubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    UIViewController* masterViewController = [self.rcsViewControllers objectAtIndex:0];
    [self.arcosSplitMasterViewController willMoveToParentViewController:nil];
    [self.arcosSplitMasterViewController.view removeFromSuperview];
    [self.arcosSplitMasterViewController removeFromParentViewController];
    UIViewController* detailViewController = [self.rcsViewControllers objectAtIndex:1];
    [detailViewController willMoveToParentViewController:nil];
    [detailViewController.view removeFromSuperview];
    [detailViewController removeFromParentViewController];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutMySubviews];
}

- (void)layoutMySubviews {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self layoutLandscapeSubviews];
    } else {
        [self layoutPortraitSubviews];
    }
}

- (void)layoutLandscapeSubviews {
    CGRect viewBounds = self.view.bounds;
//    float diff = 0.0f;
//    if (![ArcosUtils systemVersionGreaterThanSeven]) {
//        diff = 1.0f;
//    }
    float masterWidth = 320.0 - [[GlobalSharedClass shared] mainMasterWidth];
    self.arcosSplitMasterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
    UIViewController* detailViewController = [self.rcsViewControllers objectAtIndex:1];
    detailViewController.view.frame = CGRectMake(masterWidth, 0, viewBounds.size.width - masterWidth, viewBounds.size.height);
}

- (void)layoutPortraitSubviews {
    CGRect viewBounds = self.view.bounds;
    UIViewController* detailViewController = [self.rcsViewControllers objectAtIndex:1];
    detailViewController.view.frame = CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height);

    float masterWidth = self.view.bounds.size.width;
    float hiddenMasterWidth = 320.0 - [[GlobalSharedClass shared] mainMasterWidth];
    if (self.intersectFlag) {
        self.arcosSplitMasterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
    } else {
        self.arcosSplitMasterViewController.view.frame = CGRectMake(-hiddenMasterWidth-self.dividerWidth, 0, hiddenMasterWidth, viewBounds.size.height);
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)pgr {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        CGPoint velocity = [pgr velocityInView:pgr.view];
        if (pgr.state == UIGestureRecognizerStateBegan) {

        }
        if (pgr.state == UIGestureRecognizerStateChanged) {
            [self processMoveMasterViewController:velocity];
            
            [pgr setTranslation:CGPointZero inView:self.view];
        }
        if (pgr.state == UIGestureRecognizerStateEnded) {
            
        }
    }
}

- (void)rightMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.view.bounds;
    float masterWidth = self.view.bounds.size.width;
    self.arcosSplitMasterViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        float masterWidth = self.view.bounds.size.width;
        self.arcosSplitMasterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
        [self.arcosSplitMasterViewController layoutMySubviews];
    } completion:^(BOOL finished){
        self.isNotFinishedAnimation = NO;
        self.intersectFlag = YES;
    }];
}

- (void)leftMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.view.bounds;
    [UIView animateWithDuration:0.3 animations:^{
        float masterWidth = self.view.bounds.size.width;
        self.arcosSplitMasterViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    } completion:^(BOOL finished){
        float hiddenMasterWidth = 320.0 - [[GlobalSharedClass shared] mainMasterWidth];
        self.arcosSplitMasterViewController.view.frame = CGRectMake(-hiddenMasterWidth-self.dividerWidth, 0, hiddenMasterWidth, viewBounds.size.height);
        self.isNotFinishedAnimation = NO;
        self.intersectFlag = NO;
    }];
}

- (void)processMoveMasterViewController:(CGPoint)velocity {
    if (!self.intersectFlag && !self.isNotFinishedAnimation && velocity.x > 0) {
        [self rightMoveMasterViewController];
        
    }
    if (self.intersectFlag && !self.isNotFinishedAnimation && velocity.x < 0) {
        [self leftMoveMasterViewController];
        
    }
}

@end
