//
//  ReporterCsvViewController.m
//  iArcos
//
//  Created by Richard on 10/06/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "ReporterCsvViewController.h"

@interface ReporterCsvViewController ()

@end

@implementation ReporterCsvViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize customiseScrollView = _customiseScrollView;
@synthesize myRootViewController = _myRootViewController;
@synthesize reporterCsvDataManager = _reporterCsvDataManager;
@synthesize customiseTableHeaderView = _customiseTableHeaderView;
@synthesize customiseTableView = _customiseTableView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.reporterCsvDataManager = [[[ReporterCsvDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    if (@available(iOS 11.0, *)) {
        self.customiseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.myRootViewController = [ArcosUtils getRootView];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    self.arcosCustomiseAnimation = [[[ArcosCustomiseAnimation alloc] init] autorelease];
    self.arcosCustomiseAnimation.delegate = self;
}

- (void)dealloc {
    self.customiseScrollView = nil;
    self.myRootViewController = nil;
    self.reporterCsvDataManager = nil;
    self.customiseTableHeaderView = nil;
    self.customiseTableView = nil;
    self.globalNavigationController = nil;
    self.arcosCustomiseAnimation = nil;
    
    [super dealloc];
}

- (void)backButtonPressed {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    float landscapeWidth = 0.0;
    landscapeWidth = (self.myRootViewController.view.bounds.size.width > self.myRootViewController.view.bounds.size.height) ? self.myRootViewController.view.bounds.size.width : self.myRootViewController.view.bounds.size.height;
    int attrNameListCount = 0;
    int tmpAttrNameListCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.reporterCsvDataManager.attrNameList count]] - 1;
    if (tmpAttrNameListCount > 0) {
        attrNameListCount = tmpAttrNameListCount;
    }
    float totalCellWidth = self.reporterCsvDataManager.cellWidth * attrNameListCount;
    float customiseWidth = self.customiseScrollView.frame.size.width > totalCellWidth ? self.customiseScrollView.frame.size.width : totalCellWidth;
    if (customiseWidth < landscapeWidth) {
        customiseWidth = landscapeWidth;
    }
    self.customiseScrollView.contentSize = CGSizeMake(customiseWidth, self.view.frame.size.height);
    
    self.customiseTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, customiseWidth, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
    SEL cellLayoutMarginsFollowReadableWidthSelector = NSSelectorFromString(@"setCellLayoutMarginsFollowReadableWidth:");
    if ([self.customiseTableView respondsToSelector:cellLayoutMarginsFollowReadableWidthSelector]) {
//        self.customiseTableView.cellLayoutMarginsFollowReadableWidth = NO;
        BOOL myBoolValue = NO;
        NSMethodSignature* signature = [[self.customiseTableView class] instanceMethodSignatureForSelector:cellLayoutMarginsFollowReadableWidthSelector];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self.customiseTableView];
        [invocation setSelector:cellLayoutMarginsFollowReadableWidthSelector];
        [invocation setArgument:&myBoolValue atIndex:2];
        [invocation invoke];
    }
    self.customiseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.customiseTableView.delegate = self;
    self.customiseTableView.dataSource = self;
    
    [self.customiseScrollView addSubview:self.customiseTableView];
    self.customiseTableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customiseScrollView.contentSize.width, self.reporterCsvDataManager.cellHeight)] autorelease];
    self.customiseTableHeaderView.backgroundColor = [UIColor darkGrayColor];
    for (int i = 0; i < [self.reporterCsvDataManager.attrNameList count]; i++) {
        CGFloat xOrigin = i * self.reporterCsvDataManager.cellWidth;
        LeftRightInsetUILabel* headerLabel = [[LeftRightInsetUILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, self.reporterCsvDataManager.cellWidth, self.reporterCsvDataManager.cellHeight)];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.text = [self.reporterCsvDataManager.attrNameList objectAtIndex:i];
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.customiseTableHeaderView addSubview:headerLabel];
        [headerLabel release];
    }
    self.customiseScrollView.pagingEnabled = YES;
    self.customiseScrollView.directionalLockEnabled = NO;    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[self.customiseTableHeaderView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.customiseTableView removeFromSuperview];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.customiseTableHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.reporterCsvDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    GenericUITableTableCell* cell = [[[GenericUITableTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    NSArray* cellDataList = [self.reporterCsvDataManager.displayList objectAtIndex:indexPath.row];
    cell.frame = CGRectMake(0, 0, self.customiseScrollView.contentSize.width, 44);
    for (int i = 0; i < [cellDataList count] - 1; i++) {
        CGFloat xOrigin = i * self.reporterCsvDataManager.cellWidth;
        LeftRightInsetUILabel* cellLabel = [[LeftRightInsetUILabel alloc] initWithFrame:CGRectMake(xOrigin, 11, self.reporterCsvDataManager.cellWidth, 21)];
        cellLabel.textAlignment = NSTextAlignmentLeft;
        cellLabel.text = [ArcosUtils trim:[cellDataList objectAtIndex:i]];
        [cellLabel setTextColor:[UIColor blackColor]];
        [cellLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [cell addSubview:cellLabel];
        [cell.cellLabelList addObject:cellLabel];
        [cellLabel release];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReporterCsvDetailTableViewController* rctdvc = [[ReporterCsvDetailTableViewController alloc] initWithNibName:@"ReporterCsvDetailTableViewController" bundle:nil];
    rctdvc.title = [NSString stringWithFormat:@"%@ Details", [ArcosUtils convertNilToEmpty:self.title]];
    rctdvc.attrNameList = self.reporterCsvDataManager.attrNameList;
    rctdvc.bodyFieldList = [self.reporterCsvDataManager.displayList objectAtIndex:indexPath.row];
    rctdvc.animateDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:rctdvc] autorelease];
    
    [rctdvc release];
    [self.customiseTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.arcosCustomiseAnimation addPushViewAnimation:self.myRootViewController withController:self.globalNavigationController];
}

#pragma mark - SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.arcosCustomiseAnimation dismissPushViewAnimation:self.myRootViewController withController:self.globalNavigationController];
}

#pragma mark - ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

- (void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

@end
