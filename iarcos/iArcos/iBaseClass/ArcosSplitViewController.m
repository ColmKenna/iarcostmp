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

- (void) growUtilitiesOptions {
    
    [self     resizeMasterViewToWidth:250];
}
- (void) shrinkUtilitiesOptions {
    
    [self	 resizeMasterViewToWidth:100];
    
/*    CGRect viewBounds = self.view.bounds;
    CGFloat masterWidth = 350.0 - [[GlobalSharedClass shared] mainMasterWidth];
    
    // Update master view controller frame
    self.arcosSplitMasterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);

    // Update detail view controller frame
    if (self.rcsViewControllers.count > 1) {
        UIViewController *detailViewController = [self.rcsViewControllers objectAtIndex:1];
        detailViewController.view.frame = CGRectMake(masterWidth, 0, viewBounds.size.width - masterWidth, viewBounds.size.height);
    }

    // Update utils view controller frame
    if (self.rcsViewControllers.count > 0) {
        UIViewController *utilsViewController = [self.rcsViewControllers objectAtIndex:0];
        utilsViewController.view.clipsToBounds = NO;
        utilsViewController.view.frame = CGRectMake(120, 0, 200, viewBounds.size.height);
        
       // [self.view bringSubviewToFront:utilsViewController];
    }

    // Update hidden master view controller frame
    CGFloat hiddenMasterWidth = 50; // Consider using shared configuration if needed
    self.arcosSplitMasterViewController.view.frame = CGRectMake(-hiddenMasterWidth - self.dividerWidth, 0, 200, viewBounds.size.height);
 */
    
//self.arcosSplitMasterViewController.
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

// Method to resize the master view to a specific width
- (void)resizeMasterViewToWidth:(CGFloat)desiredWidth {
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat minWidth = 50.0;   // Minimum width for the master view
    CGFloat maxWidth = screenWidth * 0.9;  // Maximum width (90% of screen width)
    CGFloat currentMasterWidth = self.arcosSplitMasterViewController.view.frame.size.width;
       NSLog(@"Current Master Width: %f", currentMasterWidth);

    // Clamp the desired width to be within the min and max bounds
    CGFloat newMasterWidth = MIN(MAX(desiredWidth, minWidth), maxWidth);

    // Update the frame of the master view
    self.arcosSplitMasterViewController.view.frame = CGRectMake(0, 0, newMasterWidth, self.view.bounds.size.height);

    // Update the frame of the detail view
    UIViewController *detailViewController = [self.rcsViewControllers objectAtIndex:1];
    detailViewController.view.frame = CGRectMake(newMasterWidth, 0, screenWidth - newMasterWidth, self.view.bounds.size.height);

    // Update the split divider label (if used)
    self.arcosSplitMasterViewController.splitDividerUILabel.frame = CGRectMake(newMasterWidth, 0, self.dividerWidth, self.view.bounds.size.height);

    // Ensure the layout is updated
    //[self.arcosSplitMasterViewController layoutMySubviews];
}

// Method to resize the master view based on a percentage of the screen width
- (void)resizeMasterViewToPercentage	:(CGFloat)percentage {
    CGFloat clampedPercentage = MIN(MAX(percentage, 0.0), 1.0);
    CGFloat screenWidth = self.view.bounds.size.width;
    CGFloat desiredWidth = screenWidth * clampedPercentage;

    // Use the existing method to resize with the calculated width
    [self resizeMasterViewToWidth:desiredWidth];
}



@end
