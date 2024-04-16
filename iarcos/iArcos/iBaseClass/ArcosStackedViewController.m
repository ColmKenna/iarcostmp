//
//  ArcosStackedViewController.m
//  iArcos
//
//  Created by David Kilmartin on 06/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "ArcosStackedViewController.h"
#import <objc/runtime.h>
#import "ArcosStackedGlobalVariable.h"
//#import "SplitDividerUILabel.h"
#import "StackedSplitDividerUILabel.h"
#import "GlobalSharedClass.h"
#import "GenericMasterTemplateViewController.h"

@interface ArcosStackedViewController () {
    float _subViewWidth;
    float _subViewHeight;
    float _dividerWidth;
    float _lastXAxis;
    int _panViewIndex;
    NSUInteger _topVisibleIndex;
    BOOL _intersectFlag;
    float _intersection;
    NSMutableArray* _rcsViewControllers;
    NSMutableArray* _dividerList;
    
    BOOL _masterIntersectFlag;
    BOOL _isNotFinishedAnimation;
}

@property(nonatomic, assign) float subViewWidth;
@property(nonatomic, assign) float subViewHeight;
@property(nonatomic, assign) float dividerWidth;
@property(nonatomic, assign) float lastXAxis;
@property(nonatomic, assign) int panViewIndex;
@property(nonatomic, assign) NSUInteger topVisibleIndex;
@property(nonatomic, assign) BOOL intersectFlag;
@property(nonatomic, assign) float intersection;
@property(nonatomic, retain) NSMutableArray* rcsViewControllers;
@property(nonatomic, retain) NSMutableArray* dividerList;
@property(nonatomic, assign) BOOL masterIntersectFlag;
@property(nonatomic, assign) BOOL isNotFinishedAnimation;

- (void)layoutMySubviews;
- (void)layoutMyLandscapeSubviews:(int)vTopVisibleIndex yOrigin:(float)yOrigin;
- (void)layoutMyPortraitSubviews:(int)vTopVisibleIndex yOrigin:(float)yOrigin;
- (int)indexOfPanView:(UIView*)panView;
- (void)handleOnePan:(CGPoint)translation;
- (void)handleMoreThanOnePan:(CGPoint)translation velocity:(CGPoint)velocity;

@end

@implementation ArcosStackedViewController
@synthesize rcsViewControllers = _rcsViewControllers;
@synthesize subViewWidth = _subViewWidth;
@synthesize subViewHeight = _subViewHeight;
@synthesize dividerWidth = _dividerWidth;
@synthesize lastXAxis = _lastXAxis;
@synthesize panViewIndex = _panViewIndex;
@synthesize topVisibleIndex = _topVisibleIndex;
@synthesize intersectFlag = _intersectFlag;
@synthesize intersection = _intersection;
@synthesize topVisibleNavigationController = _topVisibleNavigationController;
@synthesize dividerList = _dividerList;
@synthesize myMasterViewController = _myMasterViewController;
@synthesize masterIntersectFlag = _masterIntersectFlag;
@synthesize isNotFinishedAnimation = _isNotFinishedAnimation;
@synthesize myScrollView = _myScrollView;
@synthesize myTableView = _myTableView;
@synthesize positionDiff = _positionDiff;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootNavigationController:(UINavigationController *)rootNavigationController {
    self = [super initWithNibName:@"ArcosStackedViewController" bundle:nil];
    if (self) {
        // Custom initialization
        UIViewController* myArcosRootViewController = [ArcosUtils getRootView];
        float landscapeWidth = 0.0;
        float landscapeHeight = 0.0;
        landscapeWidth = (myArcosRootViewController.view.bounds.size.width > myArcosRootViewController.view.bounds.size.height) ? myArcosRootViewController.view.bounds.size.width : myArcosRootViewController.view.bounds.size.height;
        landscapeHeight = (myArcosRootViewController.view.bounds.size.width > myArcosRootViewController.view.bounds.size.height) ? myArcosRootViewController.view.bounds.size.height : myArcosRootViewController.view.bounds.size.width;
        self.subViewWidth = (landscapeWidth - [GlobalSharedClass shared].mainMasterWidth) / 2;
        self.dividerWidth = 1.0f;
        self.rcsViewControllers = [NSMutableArray array];
        self.dividerList = [NSMutableArray array];
        self.intersectFlag = NO;
        self.intersection = self.subViewWidth - (landscapeHeight - [GlobalSharedClass shared].mainMasterWidth - self.subViewWidth);
        self.topVisibleNavigationController = rootNavigationController;
        [_rcsViewControllers addObject:rootNavigationController];
        StackedSplitDividerUILabel* myDividerLabel = [[StackedSplitDividerUILabel alloc] init];
        [self.dividerList addObject:myDividerLabel];
        [myDividerLabel release];
        objc_setAssociatedObject(rootNavigationController.viewControllers.firstObject, kRCSAssociatedStackedControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
        UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [rootNavigationController.view addGestureRecognizer:panGestureRecognizer];
        [panGestureRecognizer release];
        self.positionDiff = 0;
        if ([ArcosUtils systemMajorVersion] >= 11) {
            self.positionDiff = 1;
        }
    }
    
    return self;
}

- (void)dealloc {
    for (int i = 0; i < [self.rcsViewControllers count]; i++) {
        UINavigationController* tmpUINavigationController = [_rcsViewControllers objectAtIndex:i];
        [tmpUINavigationController willMoveToParentViewController:nil];
        [tmpUINavigationController.view removeFromSuperview];
        [tmpUINavigationController removeFromParentViewController];
    }
    for (int i = 0; i < [self.dividerList count]; i++) {
        StackedSplitDividerUILabel* tmpStackedSplitDividerUILabel = [self.dividerList objectAtIndex:i];
        [tmpStackedSplitDividerUILabel removeFromSuperview];
    }
    
    self.rcsViewControllers = nil;
    self.topVisibleNavigationController = nil;
    self.dividerList = nil;
    self.myMasterViewController = nil;
    self.myTableView = nil;
    self.myScrollView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.myTableView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.myTableView.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    UIViewController* rootNavigationController = [_rcsViewControllers objectAtIndex:0];
    
    [self addChildViewController:rootNavigationController];
    StackedSplitDividerUILabel* rootDividerLabel = [self.dividerList objectAtIndex:0];
    [self.myTableView addSubview:rootDividerLabel];
    [self.myTableView addSubview:rootNavigationController.view];
    rootNavigationController.view.frame = CGRectMake(0, 0, self.subViewWidth, self.subViewHeight);
    rootDividerLabel.frame = CGRectMake(0, 0, self.dividerWidth, self.subViewHeight);
    [rootNavigationController didMoveToParentViewController:self];
    
    [self addChildViewController:self.myMasterViewController];
    [self.myTableView insertSubview:self.myMasterViewController.view aboveSubview:self.topVisibleNavigationController.view];
    [self.myMasterViewController didMoveToParentViewController:self];
    CGRect viewBounds = self.myTableView.bounds;
    float masterWidth = viewBounds.size.width;
    self.myMasterViewController.view.frame = CGRectMake(-masterWidth, 0, 320.0, viewBounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutMySubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutMySubviews];
}

- (void)layoutMySubviews {
    self.subViewHeight = self.myTableView.frame.size.height;
    float yOrigin = self.myTableView.bounds.origin.y;
    int tmpTopVisibleIndex = [self indexOfMyNavigationController:self.topVisibleNavigationController];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self layoutMyLandscapeSubviews:tmpTopVisibleIndex yOrigin:yOrigin];
    } else {
        [self layoutMyPortraitSubviews:tmpTopVisibleIndex yOrigin:yOrigin];
    }
}

- (void)layoutMyLandscapeSubviews:(int)vTopVisibleIndex yOrigin:(float)vYOrigin {
    
    for (int i = 0; i < [_rcsViewControllers count]; i++) {
        int times = 0;
        if (i != 0 && i >= vTopVisibleIndex) {
            times = i - vTopVisibleIndex + 1;
        }
//        int dividerIndex = i - 1;
        int dividerIndex = i;
        if (dividerIndex >= 0) {
            StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList objectAtIndex:dividerIndex];
            tmpDividerLabel.frame = CGRectMake(self.subViewWidth * times, vYOrigin, self.dividerWidth, self.subViewHeight);
        }
        UIViewController* tmpUIViewController = [_rcsViewControllers objectAtIndex:i]; 
        tmpUIViewController.view.frame = CGRectMake(self.subViewWidth * times + self.positionDiff, vYOrigin, self.subViewWidth - self.positionDiff, self.subViewHeight);
    }
}

- (void)layoutMyPortraitSubviews:(int)vTopVisibleIndex yOrigin:(float)vYOrigin {
    if (!self.intersectFlag) {
        [self layoutMyLandscapeSubviews:vTopVisibleIndex yOrigin:vYOrigin];
    } else {
        for (int i = 0; i < [_rcsViewControllers count]; i++) {
            int times = 0;
            if (i != 0 && i >= vTopVisibleIndex) {
                times = i - vTopVisibleIndex + 1;
            }
            float tmpXOrigin = self.subViewWidth * times - self.intersection;
            float xOrigin = tmpXOrigin > 0 ? tmpXOrigin : 0;
//            int dividerIndex = i - 1;
            int dividerIndex = i;
            if (dividerIndex >= 0) {
                StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList objectAtIndex:dividerIndex];
                tmpDividerLabel.frame = CGRectMake(xOrigin, vYOrigin, self.dividerWidth, self.subViewHeight);
            }
            UIViewController* tmpUIViewController = [_rcsViewControllers objectAtIndex:i];     
            tmpUIViewController.view.frame = CGRectMake(xOrigin + self.positionDiff, vYOrigin, self.subViewWidth - self.positionDiff, self.subViewHeight);
        }
    }
    CGRect masterRect = self.myMasterViewController.view.frame;
    self.myMasterViewController.view.frame = CGRectMake(masterRect.origin.x, masterRect.origin.y, masterRect.size.width, self.subViewHeight);
}

- (void)pushNavigationController:(UINavigationController *)navigationController fromNavigationController:(UINavigationController *)startNavigationController animated:(BOOL)animated {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    int index = [self indexOfMyNavigationController:startNavigationController];
    BOOL topVisibleFlag = [startNavigationController isEqual:self.topVisibleNavigationController];
    float animateTime = 0.3f;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (!topVisibleFlag) {
            animateTime = 0.0f;
        }
    } else {
        if (!topVisibleFlag && self.intersectFlag) {
            animateTime = 0.0f;
        }
    }
    
    for (NSUInteger i = [_rcsViewControllers count] - 1; i > index; i--) {
        UINavigationController* tmpUIViewController = [_rcsViewControllers lastObject];
        [tmpUIViewController willMoveToParentViewController:nil];
        [tmpUIViewController.view removeFromSuperview];
        [tmpUIViewController removeFromParentViewController];
        [_rcsViewControllers removeLastObject];
        StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList lastObject];
        [tmpDividerLabel removeFromSuperview];
        [self.dividerList removeLastObject];
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        self.intersectFlag = YES;
    }
    self.topVisibleNavigationController = navigationController;
    [_rcsViewControllers addObject:navigationController];
    [self addChildViewController:navigationController];
    StackedSplitDividerUILabel* myDividerLabel = [[StackedSplitDividerUILabel alloc] init];
    [self.dividerList addObject:myDividerLabel];
    [myDividerLabel release];
    navigationController.view.frame = CGRectMake(self.myTableView.frame.size.width+2, 0, self.subViewWidth, self.subViewHeight);
    myDividerLabel.frame = CGRectMake(self.myTableView.frame.size.width + 1, 0, self.dividerWidth, self.subViewHeight);
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        [self.myTableView addSubview:navigationController.view];
        [self.myTableView addSubview:myDividerLabel];
    } else {
        [self.myTableView addSubview:myDividerLabel];
        [self.myTableView addSubview:navigationController.view];
    }
    
    [navigationController didMoveToParentViewController:self];
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [navigationController.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
    [UIView animateWithDuration:animateTime animations:^{
        [self layoutMySubviews];
    } completion:nil];
    objc_setAssociatedObject(navigationController.viewControllers.firstObject, kRCSAssociatedStackedControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
}

- (int)indexOfMyNavigationController:(UINavigationController*)startNavigationController {
    int index = -1;
    for (int i = 0; i < [_rcsViewControllers count]; i++) {
        if ([[_rcsViewControllers objectAtIndex:i] isEqual:startNavigationController]) {
            index = i;
            break;
        }
    }
    return index;
}

- (int)indexOfPanView:(UIView*)panView {
    int index = 0;
    for (int i = 0; i < [_rcsViewControllers count]; i++) {
        UINavigationController* tmpNavigationController = [_rcsViewControllers objectAtIndex:i];
        if ([tmpNavigationController.view isEqual:panView]) {
            index = i;
            break;
        }
    }
    return index;
}

- (void)handlePan:(UIPanGestureRecognizer*)pgr {
    CGPoint velocity = [pgr velocityInView:pgr.view];
    if (pgr.state == UIGestureRecognizerStateBegan) {
        self.panViewIndex = [self indexOfPanView:pgr.view];
        self.topVisibleIndex = [self indexOfMyNavigationController:self.topVisibleNavigationController];
        CGPoint location = [pgr locationInView:self.myTableView];
        self.lastXAxis = location.x;
    }
    if (pgr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pgr translationInView:pgr.view];
        if ([_rcsViewControllers count] == 1) {
            [self handleOnePan:translation];
        } else if ([_rcsViewControllers count] > 1) {
            [self handleMoreThanOnePan:translation velocity:velocity];
        }
        [pgr setTranslation:CGPointZero inView:self.myTableView];
    }
    if (pgr.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [pgr locationInView:self.myTableView];
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            
            if ([_rcsViewControllers count] > 2) {
                if (location.x > self.lastXAxis && !self.intersectFlag) {
                    NSUInteger tmpTvId = self.topVisibleIndex - 1;
                    self.topVisibleIndex = tmpTvId > 1 ? tmpTvId : 1;
                    
                } else if (location.x < self.lastXAxis && self.intersectFlag){
                    NSUInteger tmpTvId = self.topVisibleIndex + 1;
                    self.topVisibleIndex = tmpTvId >= [_rcsViewControllers count] - 1 ? [_rcsViewControllers count] - 1 : tmpTvId;
                }
                self.topVisibleNavigationController = [_rcsViewControllers objectAtIndex:self.topVisibleIndex];
            }
            if (location.x < self.lastXAxis) {
                self.intersectFlag = YES;
            } else if (location.x > self.lastXAxis) {
                self.intersectFlag = NO;
            }
        } else {
            if ([_rcsViewControllers count] > 2) {
                if (location.x > self.lastXAxis) {
                    NSUInteger tmpTvId = self.topVisibleIndex - 1;
                    self.topVisibleIndex = tmpTvId > 1 ? tmpTvId : 1;
                    
                } else if (location.x < self.lastXAxis){
                    NSUInteger tmpTvId = self.topVisibleIndex + 1;
                    self.topVisibleIndex = tmpTvId >= [_rcsViewControllers count] - 1 ? [_rcsViewControllers count] - 1 : tmpTvId;
                }
                self.topVisibleNavigationController = [_rcsViewControllers objectAtIndex:self.topVisibleIndex];
            }
        }
        
        
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutMySubviews];
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)handleOnePan:(CGPoint)translation {
    UINavigationController* tmpNavigationController = (UINavigationController*)[_rcsViewControllers objectAtIndex:0];
    CGRect tmpNavFrame = tmpNavigationController.view.frame;
    tmpNavFrame.origin.x = tmpNavFrame.origin.x + translation.x;
    tmpNavigationController.view.frame = tmpNavFrame;
    StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList objectAtIndex:0];
    CGRect tmpDivFrame = tmpDividerLabel.frame;
    tmpDivFrame.origin.x = tmpDivFrame.origin.x + translation.x;
    tmpDividerLabel.frame = tmpDivFrame;
}

- (void)handleMoreThanOnePan:(CGPoint)translation velocity:(CGPoint)velocity{
    if (velocity.x > 0) {//right
        NSUInteger maxNavCount = [_rcsViewControllers count];
        NSUInteger maxDivCount = [self.dividerList count];
        for (int i = 0; i < maxNavCount; i++) {
            UINavigationController* tmpNavigationController = (UINavigationController*)[_rcsViewControllers objectAtIndex:i];
            CGRect tmpNavFrame = tmpNavigationController.view.frame;
            
            if (i < maxNavCount - 1) {
                
                UINavigationController* tmpNextNavController = (UINavigationController*)[_rcsViewControllers objectAtIndex:(i + 1)];
                float tmpNavOriginX = tmpNextNavController.view.frame.origin.x + translation.x - self.subViewWidth;
                tmpNavFrame.origin.x = (tmpNavOriginX > (0 + self.positionDiff)) ? tmpNavOriginX : (0 + self.positionDiff);
            } else {
                tmpNavFrame.origin.x = tmpNavFrame.origin.x + translation.x;
            }
            
            
            
            tmpNavigationController.view.frame = tmpNavFrame;
//            int dividerIndex = i - 1;
            int dividerIndex = i;
            if (dividerIndex >= 0) {
                StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList objectAtIndex:dividerIndex];
                CGRect tmpDivFrame = tmpDividerLabel.frame;
                if (dividerIndex < maxDivCount - 1) {
                    StackedSplitDividerUILabel* tmpNextDividerLabel = [self.dividerList objectAtIndex:(dividerIndex + 1)];
                    float tmpDivOriginX = tmpNextDividerLabel.frame.origin.x + translation.x - self.subViewWidth;
                    tmpDivFrame.origin.x = tmpDivOriginX > 0 ? tmpDivOriginX : 0;
                } else {
                    tmpDivFrame.origin.x = tmpDivFrame.origin.x + translation.x;
                }
                tmpDividerLabel.frame = tmpDivFrame;
            }
        }
    } else {
        for (int i = 0; i < [_rcsViewControllers count]; i++) {
            UINavigationController* tmpNavigationController = (UINavigationController*)[_rcsViewControllers objectAtIndex:i];
            CGRect tmpNavFrame = tmpNavigationController.view.frame;
            float tmpNavOriginX = tmpNavFrame.origin.x + translation.x;
            tmpNavFrame.origin.x = (tmpNavOriginX > (0 + self.positionDiff)) ? tmpNavOriginX : (0 + self.positionDiff);
            tmpNavigationController.view.frame = tmpNavFrame;
//            int dividerIndex = i - 1;
            int dividerIndex = i;
            if (dividerIndex >= 0) {
                StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList objectAtIndex:dividerIndex];
                CGRect tmpDivFrame = tmpDividerLabel.frame;
                float tmpDivOriginX = tmpDivFrame.origin.x + translation.x;
                tmpDivFrame.origin.x = tmpDivOriginX > 0 ? tmpDivOriginX : 0;
                tmpDividerLabel.frame = tmpDivFrame;
            }
        }
    }
}

- (void)popToRootNavigationController:(BOOL)animated {
    for (NSUInteger i = [_rcsViewControllers count] - 1; i > 0; i--) {
        UINavigationController* tmpUIViewController = [_rcsViewControllers lastObject];
        [tmpUIViewController willMoveToParentViewController:nil];
        [tmpUIViewController.view removeFromSuperview];
        [tmpUIViewController removeFromParentViewController];
        [_rcsViewControllers removeLastObject];
        StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList lastObject];
        [tmpDividerLabel removeFromSuperview];
        [self.dividerList removeLastObject];
    }
    self.topVisibleNavigationController = [_rcsViewControllers objectAtIndex:0];
    self.topVisibleIndex = 0;
    self.intersectFlag = NO;
}

- (void)popTopNavigationController:(BOOL)animated {
    UINavigationController* tmpUIViewController = [_rcsViewControllers lastObject];
    [tmpUIViewController willMoveToParentViewController:nil];
    [tmpUIViewController.view removeFromSuperview];
    [tmpUIViewController removeFromParentViewController];
    [_rcsViewControllers removeLastObject];
    StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList lastObject];
    [tmpDividerLabel removeFromSuperview];
    [self.dividerList removeLastObject];
    self.topVisibleNavigationController = [_rcsViewControllers lastObject];
//    self.intersectFlag = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutMySubviews];
    } completion:nil];
}

- (void)popToNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated {
    self.topVisibleNavigationController = navigationController;
    self.topVisibleIndex = [self indexOfMyNavigationController:navigationController];
    for (NSUInteger i = [_rcsViewControllers count] - 1; i > self.topVisibleIndex; i--) {
        UINavigationController* tmpUIViewController = [_rcsViewControllers lastObject];
        [tmpUIViewController willMoveToParentViewController:nil];
        [tmpUIViewController.view removeFromSuperview];
        [tmpUIViewController removeFromParentViewController];
        [_rcsViewControllers removeLastObject];
        StackedSplitDividerUILabel* tmpDividerLabel = [self.dividerList lastObject];
        [tmpDividerLabel removeFromSuperview];
        [self.dividerList removeLastObject];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutMySubviews];
    } completion:nil];
}

- (void)updateNavigationControllerContent:(UINavigationController *)navigationController viewController:(UIViewController*)viewController {
    navigationController.viewControllers = [NSArray arrayWithObject:viewController];
    objc_setAssociatedObject(navigationController.viewControllers.firstObject, kRCSAssociatedStackedControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
}

- (void)pushMasterViewController:(GenericMasterTemplateViewController *)viewController {
    self.myMasterViewController = viewController;
    self.myMasterViewController.myMoveDelegate = self;
    
}

- (void)processMoveMasterViewController:(CGPoint)velocity {
    if (!self.masterIntersectFlag && !self.isNotFinishedAnimation && velocity.x > 0) {
        [self rightMoveMasterViewController];
    }
    if (self.masterIntersectFlag && !self.isNotFinishedAnimation && velocity.x < 0) {
        [self leftMoveMasterViewController];
    }
}

- (void)rightMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.myTableView.bounds;
    float masterWidth = viewBounds.size.width;
    self.myMasterViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    self.myMasterViewController.view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.myMasterViewController.view.frame = CGRectMake(0, 0, masterWidth, viewBounds.size.height);
        [self.myMasterViewController layoutMySubviews];
    } completion:^(BOOL finished){
        self.isNotFinishedAnimation = NO;
        self.masterIntersectFlag = YES;
    }];
}

- (void)leftMoveMasterViewController {
    self.isNotFinishedAnimation = YES;
    CGRect viewBounds = self.myTableView.bounds;
    float masterWidth = self.myTableView.bounds.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        self.myMasterViewController.view.frame = CGRectMake(-masterWidth, 0, masterWidth, viewBounds.size.height);
    } completion:^(BOOL finished){
//        self.myMasterViewController.view.frame = CGRectMake(- 326.0 - [GlobalSharedClass shared].mainMasterWidth, 0, 320.0, viewBounds.size.height);
        self.myMasterViewController.view.hidden = YES;
        self.isNotFinishedAnimation = NO;
        self.masterIntersectFlag = NO;
    }];
}

- (UINavigationController*)previousNavControllerWithCurrentIndex:(int)currentIndex step:(int)stepNum {
    int destIndex = currentIndex - stepNum;
    if (destIndex < 0 || destIndex >= [self.rcsViewControllers count]) {
        return nil;
    }
    return [self.rcsViewControllers objectAtIndex:destIndex];
}

@end
