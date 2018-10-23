//
//  QueryOrderTemplateSplitViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTemplateSplitViewController.h"
#import "MainTabbarViewController.h"
#import "ArcosRootViewController.h"

@interface QueryOrderTemplateSplitViewController ()
- (void)layoutSubviews;
- (CGRect)getCorrelativeRootViewRect;
@end

@implementation QueryOrderTemplateSplitViewController
@synthesize splitDividerLabel = _splitDividerLabel;
@synthesize queryOrderMasterTableViewController = _queryOrderMasterTableViewController;
@synthesize queryOrderDetailTableViewController = _queryOrderDetailTableViewController;
@synthesize masterWidth = _masterWidth;
@synthesize detailWidth = _detailWidth;
@synthesize dividerWidth = _dividerWidth;
@synthesize masterNavigationController = _masterNavigationController;
@synthesize detailNavigationController = _detailNavigationController;
@synthesize queryOrderSource = _queryOrderSource;
@synthesize refreshRequestSource = _refreshRequestSource;
@synthesize animateDelegate = _animateDelegate;
@synthesize masterTableview = _masterTableview;
@synthesize HUD = _HUD;
@synthesize myRootViewController = _myRootViewController;
@synthesize locationIUR = _locationIUR;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.queryOrderMasterTableViewController = [[[QueryOrderMasterTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.queryOrderDetailTableViewController = [[[QueryOrderDetailTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.queryOrderSource == QueryOrderHomePage) {
        [ArcosUtils configEdgesForExtendedLayout:self];
    }
    self.detailWidth = 352.0f;
    self.dividerWidth = 2.0f;
    
    self.queryOrderMasterTableViewController.myParentNavigationControllerView = self.navigationController.view;
    self.queryOrderMasterTableViewController.queryOrderSource = self.queryOrderSource;
    self.queryOrderMasterTableViewController.refreshRequestSource = self.refreshRequestSource;
    self.queryOrderMasterTableViewController.animateDelegate = self;   
    self.queryOrderMasterTableViewController.delegate = self;
    self.queryOrderMasterTableViewController.locationIUR = self.locationIUR;
    self.masterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.queryOrderMasterTableViewController] autorelease];
    
    self.queryOrderDetailTableViewController.myParentNavigationControllerView = self.navigationController.view;
    self.queryOrderDetailTableViewController.delegate = self;
    self.detailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.queryOrderDetailTableViewController] autorelease];
    self.splitDividerLabel = [[[SplitDividerUILabel alloc] init] autorelease];
    self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    
    [self addChildViewController:self.masterNavigationController];
    [self.view addSubview:self.masterNavigationController.view];
    [self.masterNavigationController didMoveToParentViewController:self];
    [self.view addSubview:self.splitDividerLabel];
    [self addChildViewController:self.detailNavigationController];
    [self.view addSubview:self.detailNavigationController.view];
    [self.detailNavigationController didMoveToParentViewController:self];
}

- (void)dealloc {
    [self.masterNavigationController willMoveToParentViewController:nil];
    [self.masterNavigationController.view removeFromSuperview];
    [self.masterNavigationController removeFromParentViewController];
    [self.splitDividerLabel removeFromSuperview];
    [self.detailNavigationController willMoveToParentViewController:nil];
    [self.detailNavigationController.view removeFromSuperview];
    [self.detailNavigationController removeFromParentViewController];
    self.splitDividerLabel = nil;
    self.queryOrderMasterTableViewController.delegate = nil;
    self.queryOrderMasterTableViewController = nil;
    self.queryOrderDetailTableViewController.delegate = nil;
    self.queryOrderDetailTableViewController = nil;
    self.masterNavigationController = nil;
    self.detailNavigationController = nil;
    self.masterTableview = nil;
    self.HUD = nil;
    self.myRootViewController = nil;
    self.locationIUR = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.queryOrderSource == QueryOrderHomePage) {
        self.detailWidth = self.view.bounds.size.width / 2.0;
    }
    [self layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.HUD removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.isNotFirstLoaded) return;
//    self.isNotFirstLoaded = YES;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    float yOrigin = self.view.bounds.origin.y;
    float heightDiff = 0;
    if (self.queryOrderSource == QueryOrderHomePage) {
        yOrigin = 0.0f;
        heightDiff = 0.0f;
    }
//    self.masterWidth = self.view.frame.size.width / 2.0;
    self.masterWidth = self.view.frame.size.width - self.detailWidth;
//    NSLog(@"masterWidth:%f",self.masterWidth);
    float diff = 0.0f;
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        diff = 1.0f;
    }
    float positionDiff = 0.0f;
    if ([ArcosUtils systemMajorVersion] >= 11) {
        positionDiff = 1.0f;
    }
    
    float tableViewHeight = self.view.bounds.size.height - heightDiff;
    self.masterNavigationController.view.frame = CGRectMake(0, yOrigin, self.masterWidth-diff, tableViewHeight);
    self.splitDividerLabel.frame = CGRectMake(self.masterWidth-diff, yOrigin, self.dividerWidth, tableViewHeight);
    self.detailNavigationController.view.frame = CGRectMake(self.masterWidth + positionDiff, yOrigin, self.detailWidth - positionDiff, tableViewHeight);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutSubviews];
    NSArray* subviewsList = [self.view subviews];
    for (UIView* subview in subviewsList) {
        if (self.masterNavigationController != nil && [self.masterNavigationController.view isEqual:subview]) {
            [self.queryOrderMasterTableViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
            break;
        }
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self layoutSubviews];
}
/*
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    NSLog(@"abc viewWillTransition");
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self layoutSubviews];
        NSArray* subviewsList = [self.view subviews];
        for (UIView* subview in subviewsList) {
            if (self.masterNavigationController != nil && [self.masterNavigationController.view isEqual:subview]) {
                [self.queryOrderMasterTableViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
                break;
            }
        }
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

#pragma mark QueryOrderMasterTableViewControllerDelegate
- (void)selectQueryOrderMasterRecord:(NSNumber*)taskIUR {
//    [self showLoadingView];
    [self.queryOrderDetailTableViewController loadDataForTableView:taskIUR];
//    [self hideLoadingView];
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideLoadingView) userInfo:nil repeats:NO];
}

//- (CGRect)getParentFrameFromChild {
//    NSLog(@"navigationController frame: %@", NSStringFromCGRect(self.navigationController.view.frame));
//    NSLog(@"getRootView frame: %@", NSStringFromCGRect([ArcosUtils getRootView].view.frame));
//    
//    return [ArcosUtils getRootView].view.frame;
//}

- (NSMutableArray*)getQueryOrderDetailDataList {
    return self.queryOrderDetailTableViewController.displayList;
}

- (void)clearDetailTableCellList {
    self.queryOrderDetailTableViewController.displayList = [NSMutableArray arrayWithCapacity:0];
    [self.queryOrderDetailTableViewController.tableView reloadData];
}

#pragma mark SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)showLoadingView {    
//    [self.HUD show:YES];
}

- (void)hideLoadingView {
//    [self.HUD hide:YES];
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
    //    [itemsArray insertObject:barButtonItem atIndex:0];
    //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
    //    [itemsArray release];
    /*
     [self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
     */
    self.navigationItem.leftBarButtonItem=nil;
    
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    //    NSMutableArray *itemsArray = [self.navigationController.toolbar.items mutableCopy];
    //    [itemsArray removeObject:barButtonItem];
    //    [self.navigationController.toolbar setItems:itemsArray animated:NO];
    //    [itemsArray release];
    //self.navigationItem.leftBarButtonItem=nil;
    /*
     [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
     */
    self.navigationItem.leftBarButtonItem=nil;
    
}

- (CGRect)getCorrelativeRootViewRect {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        return CGRectMake(self.myRootViewController.view.frame.origin.x, self.myRootViewController.view.frame.origin.y, self.myRootViewController.view.frame.size.height, self.myRootViewController.view.frame.size.width);
    } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return CGRectMake(self.myRootViewController.view.frame.origin.x, self.myRootViewController.view.frame.origin.y, self.myRootViewController.view.frame.size.width, self.myRootViewController.view.frame.size.height);
    }
    return self.myRootViewController.view.frame;
}

#pragma mark QueryOrderDetailTableViewControllerDelegate
- (NSIndexPath*)getMasterTaskSelectedRow {
    return [self.queryOrderMasterTableViewController.tableView indexPathForSelectedRow];
}

- (NSNumber*)getMasterTaskLocationIUR {
    ArcosGenericClass* cellData = [self.queryOrderMasterTableViewController.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field2]];
}

- (NSNumber*)getMasterTaskIUR {
    ArcosGenericClass* cellData = [self.queryOrderMasterTableViewController.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field1]];
}

- (NSNumber*)getMasterTaskContactIUR {
    ArcosGenericClass* cellData = [self.queryOrderMasterTableViewController.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field8]];
}

- (NSString*)getMasterTaskCompletionDate {
    ArcosGenericClass* cellData = [self.queryOrderMasterTableViewController.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [cellData Field9];
}

- (void)refreshMasterContentByMemoCreate:(NSIndexPath*)anIndexPath {
    self.queryOrderMasterTableViewController.refreshRequestSource = RefreshRequestEdit;
//    [self.queryOrderMasterTableViewController loadDataByRequestSource];
    [self.queryOrderMasterTableViewController refreshParentContentByEdit];
}

- (void)inheritEditFinishedWithData:(id)contentString fieldName:(NSString *)fieldName forIndexpath:(NSIndexPath *)theIndexpath {
    [self.queryOrderMasterTableViewController editFinishedWithData:contentString fieldName:fieldName forIndexpath:theIndexpath];
}

@end
