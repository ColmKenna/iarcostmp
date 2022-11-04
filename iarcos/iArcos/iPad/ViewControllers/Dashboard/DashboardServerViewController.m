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
    self.title = [NSString stringWithFormat:@"%@",self.dashboardServerDataManager.dashboardTitle];
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
    self.title = [NSString stringWithFormat:@"%@",self.dashboardServerDataManager.dashboardTitle];
    [FileCommon removeAllFileUnderFolder:self.dashboardServerDataManager.dashboardFolderName];
    self.dashboardServerDataManager.displayFileList = [NSMutableArray array];
//    self.dashboardServerDataManager.displayEmployeeNameList = [NSMutableArray array];
    self.dashboardServerDataManager.resourceLoadingFinishedFlag = YES;
    self.dashboardServerDataManager.currentPage = 0;
    self.myScrollView.contentOffset = CGPointZero;
//    [self.dashboardServerDataManager createDashboardFileList];
//    if ([self.dashboardServerDataManager.dashboardFileList count] == 0 || [self.dashboardServerDataManager.employeeDictList count] == 0) {
//        return;
//    }
    [self.HUD show:YES];
//    self.resourcesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkResourceList) userInfo:nil repeats:YES];
//    [self.arcosService Get_Download_Filenames:self action:@selector(backFromGet_Download_Filenames:) directory:self.dashboardServerDataManager.overviewsUKFolder];//self.dashboardServerDataManager.overviewsFolder
//    [self.arcosService Download_File:self action:@selector(backFromDownload_File:) directory:@"Overviews\\UK" fileName:@"Emp_Dashboard_5.pdf"];
    if (![ArcosSystemCodesUtils allDashOptionExistence]) {
        [self.dashboardServerDataManager createDashboardFileList];
        self.dashboardServerDataManager.currentDashFileDict = [self.dashboardServerDataManager.dashboardFileList objectAtIndex:0];
        [self.arcosService GetFromResources:self action:@selector(backFromGetFromResources:) FileNAme:[self.dashboardServerDataManager.currentDashFileDict objectForKey:@"FileName"]];
    } else {
        self.dashboardServerDataManager.rowPointer = 0;
        [self.arcosService Get_Download_Filenames:self action:@selector(backFromGet_Download_Filenames:) directory:self.dashboardServerDataManager.overviewsFolder];
    }
}

- (void)backFromGet_Download_Filenames:(id)aResult {
    BOOL successFlag = YES;
    if ([aResult isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anError localizedDescription]] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        successFlag = NO;
    } else if ([aResult isKindOfClass:[SoapFault class]]) {
        SoapFault* anSoapFault = (SoapFault*)aResult;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        successFlag = NO;
    } else {
        [self.dashboardServerDataManager processGet_Download_Filenames:aResult];
        if ([self.dashboardServerDataManager.dashboardFileList count] == 0) {
            [self.HUD hide:YES];
            return;
        }
        self.resourcesTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkResourceList) userInfo:nil repeats:YES];
    }
    if (!successFlag) {
        [self.HUD hide:YES];
    }
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
    if (self.dashboardServerDataManager.rowPointer >= [self.dashboardServerDataManager.dashboardFileList count]) {
        [self.HUD hide:YES];
        [self.resourcesTimer invalidate];
        self.resourcesTimer = nil;
        [self displayFileOnCanvas];
        [self alignSubviews];
    } else {
        self.dashboardServerDataManager.resourceLoadingFinishedFlag = NO;
//        self.dashboardServerDataManager.currentFileName = [NSString stringWithFormat:@"%@", [self.dashboardServerDataManager.dashboardFileList lastObject]];
//        [self.dashboardServerDataManager.dashboardFileList removeLastObject];
//        self.dashboardServerDataManager.currentEmployeeDict = [NSMutableDictionary dictionaryWithDictionary:[self.dashboardServerDataManager.employeeDictList lastObject]];
//        [self.dashboardServerDataManager.employeeDictList removeLastObject];
//        [self.arcosService GetFromResources:self action:@selector(backFromGetFromResources:) FileNAme:self.dashboardServerDataManager.currentFileName];
        self.dashboardServerDataManager.currentDashFileDict = [self.dashboardServerDataManager.dashboardFileList objectAtIndex:self.dashboardServerDataManager.rowPointer];
        [self.arcosService Download_File:self action:@selector(backFromDownload_File:) directory:[self.dashboardServerDataManager.currentDashFileDict objectForKey:@"Directory"] fileName:[self.dashboardServerDataManager.currentDashFileDict objectForKey:@"FileName"]];
    }
}

- (void)backFromDownload_File:(id)result {
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* anSoapFault = (SoapFault*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        [self.resourcesTimer invalidate];
        self.resourcesTimer = nil;
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
        [self.resourcesTimer invalidate];
        self.resourcesTimer = nil;
    } else {
        @try {
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            NSString* tmpFileDirectory = [self.dashboardServerDataManager.currentDashFileDict objectForKey:@"Directory"];
            NSString* resFileDirectory = [tmpFileDirectory stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            if (![resFileDirectory isEqualToString:@""]) {
                [FileCommon createIntermediateFolder:[NSString stringWithFormat:@"%@/%@", self.dashboardServerDataManager.dashboardFolderName, resFileDirectory]];
            }
            NSString* filePath = [self.dashboardServerDataManager retrieveFilePathWithFileDict:self.dashboardServerDataManager.currentDashFileDict];
            BOOL saveFileFlag = [myNSData writeToFile:filePath atomically:YES];
            if (saveFileFlag) {
                [self.dashboardServerDataManager.displayFileList addObject:[NSMutableDictionary dictionaryWithDictionary:self.dashboardServerDataManager.currentDashFileDict]];
//                [self.dashboardServerDataManager.displayEmployeeNameList addObject:[NSString stringWithFormat:@"%@", [self.dashboardServerDataManager.currentEmployeeDict objectForKey:@"Title"]]];
            }
        }
        @catch (NSException *exception) {
            [ArcosUtils showMsg:[exception reason] delegate:nil];
        }
    }
    self.dashboardServerDataManager.rowPointer++;
    self.dashboardServerDataManager.resourceLoadingFinishedFlag = YES;
}

- (void)backFromGetFromResources:(id)result {
    if ([result isKindOfClass:[SoapFault class]]) {
        SoapFault* anSoapFault = (SoapFault*)result;
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%@",[anSoapFault faultString]] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
//        [self.resourcesTimer invalidate];
//        self.resourcesTimer = nil;
    } else if ([result isKindOfClass:[NSError class]]) {
        NSError* anError = (NSError*)result;
        [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" delegate:nil target:self tag:0 handler:nil];
        [self.HUD hide:YES];
//        [self.resourcesTimer invalidate];
//        self.resourcesTimer = nil;
    } else {
        @try {
            NSData* myNSData = [[[NSData alloc] initWithBase64EncodedString:result options:0] autorelease];
            NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon dashboardPath], [self.dashboardServerDataManager.currentDashFileDict objectForKey:@"FileName"]];
            BOOL saveFileFlag = [myNSData writeToFile:filePath atomically:YES];
            if (saveFileFlag) {
                [self.dashboardServerDataManager.displayFileList addObject:[NSMutableDictionary dictionaryWithDictionary:self.dashboardServerDataManager.currentDashFileDict]];
                [self displayFileOnCanvas];
                [self alignSubviews];
//                [self.dashboardServerDataManager.displayEmployeeNameList addObject:[NSString stringWithFormat:@"%@", [self.dashboardServerDataManager.currentEmployeeDict objectForKey:@"Title"]]];
            }
        }
        @catch (NSException *exception) {
            [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
        [self.HUD hide:YES];
    }
}

- (void)displayFileOnCanvas {
    self.viewItemControllerList = [NSMutableArray arrayWithCapacity:[self.dashboardServerDataManager.displayFileList count]];
    for (int i = 0; i < [self.dashboardServerDataManager.displayFileList count]; i++) {
        GenericWebViewItemViewController* gwvivc = [[GenericWebViewItemViewController alloc] initWithNibName:@"GenericWebViewItemViewController" bundle:nil];
        [self.viewItemControllerList addObject:gwvivc];
        [self.myScrollView addSubview:gwvivc.view];
//        NSString* fileName = [self.dashboardServerDataManager.displayFileList objectAtIndex:i];
//        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon dashboardPath], fileName];
        NSMutableDictionary* tmpDashboardFileDict = [self.dashboardServerDataManager.displayFileList objectAtIndex:i];
        NSString* filePath = [self.dashboardServerDataManager retrieveFilePathWithFileDict:tmpDashboardFileDict];
        [gwvivc loadContentWithPath:filePath];
        [gwvivc didMoveToParentViewController:self];
        [gwvivc release];
    }
    [self showTitle];
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
    [self showTitle];
}

- (int)retrieveStatusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width;
}

- (void)showTitle {
    if ([self.dashboardServerDataManager.displayFileList count] <= 1) {
        self.title = [NSString stringWithFormat:@"%@",self.dashboardServerDataManager.dashboardTitle];
    }
    int myLength = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.dashboardServerDataManager.displayFileList count]] - 1;
    if ([self.dashboardServerDataManager.displayFileList count] > 1) {
        NSMutableDictionary* tmpDashboardFileDict = [self.dashboardServerDataManager.displayFileList objectAtIndex:self.dashboardServerDataManager.currentPage];
        NSString* tmpFileName = [tmpDashboardFileDict objectForKey:@"FileName"];
        if (self.dashboardServerDataManager.currentPage == 0) {
            self.title = [NSString stringWithFormat:@"%@ >", tmpFileName];
        } else if (self.dashboardServerDataManager.currentPage == myLength) {
            self.title = [NSString stringWithFormat:@"< %@", tmpFileName];
        } else {
            self.title = [NSString stringWithFormat:@"< %@ >", tmpFileName];
        }
    }
}

@end
