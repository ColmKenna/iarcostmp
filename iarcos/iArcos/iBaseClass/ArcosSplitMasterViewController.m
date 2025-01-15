//
//  ArcosSplitMasterViewController.m
//  iArcos
//
//  Created by David Kilmartin on 09/10/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ArcosSplitMasterViewController.h"
#import "GlobalSharedClass.h"
#import "ArcosUtils.h"
#import "ArcosSplitViewController.h"

@interface ArcosSplitMasterViewController ()

@end

@implementation ArcosSplitMasterViewController
@synthesize masterViewController = _masterViewController;
@synthesize splitDividerUILabel = _splitDividerUILabel;
@synthesize dividerWidth = _dividerWidth;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.splitDividerUILabel = [[[StackedSplitDividerUILabel alloc] init] autorelease];
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.view];
    [self.masterViewController didMoveToParentViewController:self];
    //[self.view addSubview:self.splitDividerUILabel];
    self.dividerWidth = 2.0f;
    UITapGestureRecognizer* singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture)];
    singleTap1.delegate = self;
    [self.view addGestureRecognizer:singleTap1];
    [singleTap1 release];
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
}

- (void)dealloc {
    [self.masterViewController willMoveToParentViewController:nil];
    [self.masterViewController.view removeFromSuperview];
    [self.masterViewController removeFromParentViewController];
    //[self.splitDividerUILabel removeFromSuperview];
    self.masterViewController = nil;
    self.splitDividerUILabel = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self.masterViewController.view];
    return ![self.masterViewController.view hitTest:touchPoint withEvent:nil];
}

- (void)handleSingleTapGesture {
    ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController;
    [arcosSplitViewController leftMoveMasterViewController];
}

- (void)handlePan:(UIPanGestureRecognizer*)pgr {
    CGPoint velocity = [pgr velocityInView:pgr.view];
    if (pgr.state == UIGestureRecognizerStateBegan) {
        
    }
    if (pgr.state == UIGestureRecognizerStateChanged) {
        if (velocity.x < 0) {
            ArcosSplitViewController* arcosSplitViewController = (ArcosSplitViewController*)self.parentViewController;
            [arcosSplitViewController processMoveMasterViewController:velocity];
        }
        [pgr setTranslation:CGPointZero inView:self.view];
    }
    if (pgr.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutMySubviews];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutMySubviews];
}

- (void)layoutMySubviews {
    CGRect viewBounds = self.view.bounds;
    float diff = 0.0f;
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        diff = 1.0f;
    }
    float masterWidth = 320.0 - [[GlobalSharedClass shared] mainMasterWidth];
    self.masterViewController.view.frame = CGRectMake(0, 0, masterWidth-diff, viewBounds.size.height);
    self.splitDividerUILabel.frame = CGRectMake(masterWidth-diff, 0, self.dividerWidth, viewBounds.size.height);
}


@end
