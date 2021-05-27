//
//  DashboardServerViewController.m
//  iArcos
//
//  Created by Richard on 24/05/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import "DashboardServerViewController.h"
#import "ArcosRootViewController.h"

@interface DashboardServerViewController ()

@end

@implementation DashboardServerViewController
@synthesize dashboardServerDataManager = _dashboardServerDataManager;
@synthesize HUD = _HUD;
@synthesize resourcesTimer = _resourcesTimer;
@synthesize arcosService = _arcosService;
@synthesize viewItemControllerList = _viewItemControllerList;
@synthesize myScrollView = _myScrollView;
@synthesize arcosRootViewController = _arcosRootViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dashboardServerDataManager = [[[DashboardServerDataManager alloc] init] autorelease];
        self.arcosService = [ArcosService service];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
    self.HUD.dimBackground = YES;
    [self.navigationController.view addSubview:self.HUD];
    [FileCommon createFolder:self.dashboardServerDataManager.dashboardFolderName];
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];        
    if (@available(iOS 11.0, *)) {
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
     
    self.title = @"Dashboard";
}

- (void)dealloc {
    self.dashboardServerDataManager = nil;
    [self.HUD removeFromSuperview];
    self.HUD = nil;
    self.resourcesTimer = nil;
    self.arcosService = nil;
    for (int i = 0; i < [self.viewItemControllerList count]; i++) {
        UIViewController* myViewController = [self.viewItemControllerList objectAtIndex:i];
        [myViewController willMoveToParentViewController:nil];
        [myViewController.view removeFromSuperview];
        [myViewController removeFromParentViewController];
    }
    self.viewItemControllerList = nil;
    self.myScrollView = nil;
    self.arcosRootViewController = nil;
    
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.HUD != nil) {
        self.HUD.frame = self.navigationController.view.bounds;
    }
    [FileCommon removeAllFileUnderFolder:self.dashboardServerDataManager.dashboardFolderName];
    self.dashboardServerDataManager.displayFileList = [NSMutableArray array];
    self.dashboardServerDataManager.resourceLoadingFinishedFlag = YES;
    self.dashboardServerDataManager.currentPage = 0;
    self.myScrollView.contentOffset = CGPointZero;
    [self.dashboardServerDataManager createDashboardFileList];
    if ([self.dashboardServerDataManager.dashboardFileList count] == 0) {
        return;
    }
    [self.HUD show:YES];
    self.resourcesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkResourceList) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.resourcesTimer invalidate];
    self.resourcesTimer = nil;
    for (int i = 0; i < [self.viewItemControllerList count]; i++) {
        UIViewController* myViewController = [self.viewItemControllerList objectAtIndex:i];
        [myViewController willMoveToParentViewController:nil];
        [myViewController.view removeFromSuperview];
        [myViewController removeFromParentViewController];
    }
    self.viewItemControllerList = nil;
}

- (void)checkResourceList {
    if (!self.dashboardServerDataManager.resourceLoadingFinishedFlag) return;
    if ([self.dashboardServerDataManager.dashboardFileList count] <= 0) {
        [self.HUD hide:YES];
        [self.resourcesTimer invalidate];
        self.resourcesTimer = nil;
        [self displayFileOnCanvas];
        [self alignSubviews];
    } else {
        self.dashboardServerDataManager.resourceLoadingFinishedFlag = NO;
        self.dashboardServerDataManager.currentFileName = [NSString stringWithFormat:@"%@", [self.dashboardServerDataManager.dashboardFileList lastObject]];
        [self.dashboardServerDataManager.dashboardFileList removeLastObject];
        [self.arcosService GetFromResources:self action:@selector(backFromGetFromResources:) FileNAme:self.dashboardServerDataManager.currentFileName];
    }
}

- (void)backFromGetFromResources:(id)result {
    self.dashboardServerDataManager.resourceLoadingFinishedFlag = YES;
    if ([result isKindOfClass:[SoapFault class]]) {
        
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        [self.resourcesTimer invalidate];
        self.resourcesTimer = nil;
    } else {
        @try {
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon dashboardPath], self.dashboardServerDataManager.currentFileName];
            BOOL saveFileFlag = [myNSData writeToFile:filePath atomically:YES];
            if (saveFileFlag) {
                [self.dashboardServerDataManager.displayFileList addObject:[NSString stringWithFormat:@"%@", self.dashboardServerDataManager.currentFileName]];
            }
        }
        @catch (NSException *exception) {
            [ArcosUtils showMsg:[exception reason] delegate:nil];
        }
    }
}

- (void)displayFileOnCanvas {
    self.viewItemControllerList = [NSMutableArray arrayWithCapacity:[self.dashboardServerDataManager.displayFileList count]];
    for (int i = 0; i < [self.dashboardServerDataManager.displayFileList count]; i++) {
        GenericWebViewItemViewController* gwvivc = [[GenericWebViewItemViewController alloc] initWithNibName:@"GenericWebViewItemViewController" bundle:nil];
        [self.viewItemControllerList addObject:gwvivc];
        [self.myScrollView addSubview:gwvivc.view];
        NSString* fileName = [self.dashboardServerDataManager.displayFileList objectAtIndex:i];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon dashboardPath], fileName];
        [gwvivc loadContentWithPath:filePath];
        [gwvivc didMoveToParentViewController:self];
        [gwvivc release];
    }
}

- (void)alignSubviews {
    int statusBarHeight = [self retrieveStatusBarHeight];
    float tmpPageWidth = self.arcosRootViewController.selectedRightViewController.view.frame.size.width;
    float tmpPageHeight = self.arcosRootViewController.selectedRightViewController.view.frame.size.height - statusBarHeight - self.navigationController.navigationBar.frame.size.height;
    self.myScrollView.contentSize = CGSizeMake([self.viewItemControllerList count] * tmpPageWidth, tmpPageHeight);
    NSUInteger i = 0;
    for (UIViewController* myController in self.viewItemControllerList) {
        myController.view.frame = CGRectMake(i * tmpPageWidth, 0, tmpPageWidth, tmpPageHeight);
        i++;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
    self.myScrollView.contentOffset = CGPointMake(self.dashboardServerDataManager.currentPage * self.myScrollView.bounds.size.width, 0);
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self alignSubviews];
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)sender{
    
}
// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.dashboardServerDataManager.currentPage = self.myScrollView.contentOffset.x / self.myScrollView.bounds.size.width;
}

- (int)retrieveStatusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width;
}

@end
