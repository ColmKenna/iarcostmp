//
//  CustomerMasterViewController.m
//  iArcos
//
//  Created by David Kilmartin on 08/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerMasterViewController.h"

@interface CustomerMasterViewController ()

- (void)myLayoutSubviews;

@end

@implementation CustomerMasterViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize subMenuDelegate = _subMenuDelegate;
@synthesize topTableView = _topTableView;
@synthesize dividerLabel = _dividerLabel;
@synthesize baseScrollContentView = _baseScrollContentView;
@synthesize baseTableContentView = _baseTableContentView;
@synthesize customerMasterDataManager = _customerMasterDataManager;
@synthesize subMenuTableViewController = _subMenuTableViewController;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize myHeaderButton = _myHeaderButton;
@synthesize myHeaderView = _myHeaderView;
@synthesize selectedSubMenuTableViewController = _selectedSubMenuTableViewController;
@synthesize subMenuPlaceHolderTableViewController = _subMenuPlaceHolderTableViewController;
@synthesize subMenuListingTableViewController = _subMenuListingTableViewController;
@synthesize scanApiHelper = _scanApiHelper;
@synthesize scanApiTimer = _scanApiTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.customerMasterDataManager = [[[CustomerMasterDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.topTableView = nil;
    self.dividerLabel = nil;
    self.baseScrollContentView = nil;
    self.baseTableContentView = nil;
    self.customerMasterDataManager = nil;
    [self.subMenuTableViewController willMoveToParentViewController:nil];
    [self.subMenuTableViewController.view removeFromSuperview];
    [self.subMenuTableViewController removeFromParentViewController];
    self.subMenuTableViewController = nil;
    self.currentIndexPath = nil;
    [self.myHeaderView removeFromSuperview];
    self.myHeaderButton = nil;
    self.myHeaderView = nil;
    self.selectedSubMenuTableViewController = nil;
    self.subMenuPlaceHolderTableViewController = nil;
    self.subMenuListingTableViewController = nil;
    [self.scanApiHelper setDelegate:nil];
    self.scanApiHelper = nil;
    [self.scanApiTimer invalidate];
    self.scanApiTimer = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBar.hidden = YES;
    
    self.title = @"";
    self.subMenuPlaceHolderTableViewController = [[[SubMenuPlaceHolderTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [self addChildViewController:self.subMenuPlaceHolderTableViewController];
    [self.view addSubview:self.subMenuPlaceHolderTableViewController.view];
    [self.subMenuPlaceHolderTableViewController didMoveToParentViewController:self];
    self.selectedSubMenuTableViewController = self.subMenuPlaceHolderTableViewController;
    int customerIndex = [self.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    self.currentIndexPath = [NSIndexPath indexPathForRow:customerIndex inSection:0];
    UIImage* companyImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:[NSNumber numberWithInt:1]];
    if (companyImage == nil) {
        companyImage = [UIImage imageNamed:[GlobalSharedClass shared].appImageName];
    }
    
    [self.myHeaderButton setBackgroundImage:companyImage forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.myHeaderView];
    [self createScanApiRelevantObject];
}

- (void)createScanApiRelevantObject {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag] && self.scanApiHelper == nil) {
        self.scanApiHelper = [[[ScanApiHelper alloc]init] autorelease];
        [self.scanApiHelper setDelegate:self];
        [self.scanApiHelper open];
        self.scanApiTimer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(onScanTimer:) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isNotFirstLoaded) {
        self.isNotFirstLoaded = YES;
        [self selectCustomerMasterTopViewWithIndexPath:self.currentIndexPath];
        
    }
    [self myLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [self myLayoutSubviews];
//    if (self.currentIndexPath != nil) {
//        [self.topTableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//    }

}

- (void)selectCustomerMasterTopViewWithIndexPath:(NSIndexPath*)anIndexPath {
    self.currentIndexPath = anIndexPath;
    NSMutableDictionary* cellData = [self.customerMasterDataManager.displayList objectAtIndex:anIndexPath.row];
    [self didSelectTableRow:anIndexPath myCustomController:[cellData objectForKey:@"MyCustomController"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self myLayoutSubviews];
}

#pragma mark - Table view data source
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.myHeaderView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 44;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 59;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedSubMenuTableViewController != self.subMenuPlaceHolderTableViewController) {
        return [self.customerMasterDataManager.displayList count] - 1;
    }
    return [self.customerMasterDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IdCustomerMasterTopTabBarItemTableCell";
    CustomerMasterTopTabBarItemTableCell *cell=(CustomerMasterTopTabBarItemTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerMasterTabBarItemTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerMasterTopTabBarItemTableCell class]] && [[(CustomerMasterTopTabBarItemTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerMasterTopTabBarItemTableCell *) nibItem;
                cell.actionDelegate = self;
                break;
            }
        }
	}
    cell.indexPath = indexPath;
//    cell.tabItemTitleLabel.text = [self.customerMasterDataManager.displayList objectAtIndex:indexPath.row];
//    cell.fileName = self.customerMasterDataManager.imageFileList
    NSMutableDictionary* cellData = [self.customerMasterDataManager.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData currentIndexPath:self.currentIndexPath];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark CustomerMasterViewControllerDelegate
- (void)didSelectTableRow:(NSIndexPath*)anIndexPath myCustomController:(UIViewController *)aViewController {
    NSString* tabTitle = [self.customerMasterDataManager retrieveTitleByIndex:[ArcosUtils convertNSIntegerToInt:anIndexPath.row]];
    if ([tabTitle isEqualToString:self.customerMasterDataManager.presenterText] && self.selectedSubMenuTableViewController != self.subMenuPlaceHolderTableViewController) {
        return;
    }
    self.currentIndexPath = anIndexPath;
    for (int i = 0; i < [self.customerMasterDataManager.displayList count]; i++) {
        NSIndexPath* tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CustomerMasterTabBarItemTableCell* itemTableCell = (CustomerMasterTabBarItemTableCell*)[self.topTableView cellForRowAtIndexPath:tmpIndexPath];
        if ([anIndexPath isEqual:tmpIndexPath]) {
            [itemTableCell selectedImageProcessor];
        } else {
            [itemTableCell unSelectedImageProcessor];
        }
    }
    [self.actionDelegate didSelectTableRow:anIndexPath myCustomController:aViewController];
    
    if (![tabTitle isEqualToString:[GlobalSharedClass shared].customerText] && ![tabTitle isEqualToString:[GlobalSharedClass shared].contactText]) {
        [self processSubMenuBySelf];
    } else {
        if ([self isCustomerBaseCellSelected] && [GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
            [self showSubMenuByCustomerListing];
        } else {
            [self processSubMenuBySelf];
        }
    }
}

- (void)myLayoutSubviews {
    CGRect subMenuRect = CGRectMake(0, self.dividerLabel.frame.origin.y + 1, self.view.bounds.size.width, self.view.bounds.size.height - self.dividerLabel.frame.origin.y);
    self.selectedSubMenuTableViewController.view.frame = subMenuRect;
}

- (void)showSubMenuByCustomerListing {
//    [self.topTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.selectedSubMenuTableViewController willMoveToParentViewController:nil];
    [self.selectedSubMenuTableViewController.view removeFromSuperview];
    [self.selectedSubMenuTableViewController removeFromParentViewController];
    if (self.subMenuListingTableViewController == nil) {
        self.subMenuListingTableViewController = [[[SubMenuListingTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    }
    self.subMenuListingTableViewController.subMenuDelegate = self;
    [self addChildViewController:self.subMenuListingTableViewController];
    [self.view addSubview:self.subMenuListingTableViewController.view];
    [self.subMenuListingTableViewController didMoveToParentViewController:self];
    self.selectedSubMenuTableViewController = self.subMenuListingTableViewController;
    [self myLayoutSubviews];
    [self.topTableView reloadData];
}

- (void)processSubMenuByCustomerListing:(NSMutableDictionary*)aCellData reqSourceName:(NSString*)reqSourceName{
//    NSLog(@"aCellData: %@", aCellData);
    [self showSubMenuByCustomerListing];
    self.subMenuListingTableViewController.requestSourceName = reqSourceName;
    self.subMenuListingTableViewController.subMenuListingDataManager.locationCellData = [NSMutableDictionary dictionaryWithDictionary:aCellData];
    [self.subMenuListingTableViewController.subMenuListingDataManager locationStatusProcessor:[aCellData objectForKey:@"lsiur"]];
}

- (void)processSubMenuBySelf {
    [self.selectedSubMenuTableViewController willMoveToParentViewController:nil];
    [self.selectedSubMenuTableViewController.view removeFromSuperview];
    [self.selectedSubMenuTableViewController removeFromParentViewController];
    
    [self addChildViewController:self.subMenuPlaceHolderTableViewController];
    [self.view addSubview:self.subMenuPlaceHolderTableViewController.view];
    [self.subMenuPlaceHolderTableViewController didMoveToParentViewController:self];
    self.selectedSubMenuTableViewController = self.subMenuPlaceHolderTableViewController;
    [self myLayoutSubviews];
    [self.topTableView reloadData];
}

#pragma mark SubMenuTableViewControllerDelegate
- (void)didSelectSubMenuListingRow:(NSIndexPath*)anIndexPath viewController:(UIViewController *)aViewController {
    [self.subMenuDelegate didSelectSubMenuListingRow:anIndexPath viewController:aViewController];
}

- (BOOL)isCustomerBaseCellSelected {
    NSMutableDictionary* cellData = [self.customerMasterDataManager.displayList objectAtIndex:self.currentIndexPath.row];
    ArcosStackedViewController* tmpLocationArcosStackedViewController = [cellData objectForKey:@"MyCustomController"];
    UINavigationController* tmpNavigationController = [tmpLocationArcosStackedViewController.rcsViewControllers objectAtIndex:0];
    CustomerBaseDetailViewController* customerBaseDetailViewController = (CustomerBaseDetailViewController*)tmpNavigationController.viewControllers.firstObject;
    return customerBaseDetailViewController.currentIndexPath != nil;
}
- (NSMutableDictionary*)selectedCustomerBaseCellData {
    NSMutableDictionary* cellData = [self.customerMasterDataManager.displayList objectAtIndex:self.currentIndexPath.row];
    ArcosStackedViewController* tmpLocationArcosStackedViewController = [cellData objectForKey:@"MyCustomController"];
    UINavigationController* tmpNavigationController = [tmpLocationArcosStackedViewController.rcsViewControllers objectAtIndex:0];
    CustomerBaseDetailViewController* customerBaseDetailViewController = (CustomerBaseDetailViewController*)tmpNavigationController.viewControllers.firstObject;
    return [customerBaseDetailViewController getSelectedCellData];
}

- (NSMutableDictionary*)retrieveSelectedCustomerBaseCellData {
    return [self selectedCustomerBaseCellData];
}

- (void)onScanTimer:(NSTimer*)theTimer {
    if (theTimer == self.scanApiTimer) {
        [self.scanApiHelper doScanApiReceive];
    }
}

/**
 * called each time a device connects to the host
 * @param result contains the result of the connection
 * @param newDevice contains the device information
 */
-(void)onDeviceArrival:(SKTRESULT)result device:(DeviceInfo*)deviceInfo {
    
}

/**
 * called each time a device disconnect from the host
 * @param deviceRemoved contains the device information
 */
-(void) onDeviceRemoval:(DeviceInfo*) deviceRemoved {
    
}

/**
 * called each time ScanAPI is reporting an error
 * @param result contains the error code
 */
-(void) onError:(SKTRESULT) result {
    [ArcosUtils showMsg:[NSString stringWithFormat:@"Scanner is reporting an error:%ld",result] delegate:nil];
}

/**
 * called when ScanAPI initialization has been completed
 * @param result contains the initialization result
 */
-(void) onScanApiInitializeComplete:(SKTRESULT) result {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(SKTSUCCESS(result)){
        
    } else {
        [ArcosUtils showMsg:[NSString stringWithFormat:@"Error initializing Scanner:%ld",result] delegate:nil];
    }
}

/**
 * called when ScanAPI has been terminated. This will be
 * the last message received from ScanAPI
 */
-(void) onScanApiTerminated {
    
}

/**
 * called when an error occurs during the retrieval
 * of a ScanObject from ScanAPI.
 * @param result contains the retrieval error code
 */
-(void) onErrorRetrievingScanObject:(SKTRESULT) result {
    [ArcosUtils showMsg:[NSString stringWithFormat:@"Error retrieving Barcode:%ld", result] delegate:nil];
}

/**
 * called each time ScanAPI receives decoded data from scanner
 * @param result is ESKT_NOERROR when decodedData contains actual
 * decoded data. The result can be set to ESKT_CANCEL when the
 * end-user cancels a SoftScan operation
 * @param deviceInfo contains the device information from which
 * the data has been decoded
 * @param decodedData contains the decoded data information
 */
-(void) onDecodedDataResult:(long) result device:(DeviceInfo*) device decodedData:(id<ISktScanDecodedData>) decodedData {
    NSString* barcode = [NSString stringWithUTF8String:(const char *)[decodedData getData]];
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[ArcosUtils convertNilToEmpty:barcode] forKey:@"BarCode"];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"BarCodeNotification" object:nil userInfo:userInfo];
}

// THIS IS THE PREVIOUS onDecodedData THAT WE KEEP FOR BACKWARD
// COMPATIBILITY BUT THE BEST IS TO USE onDecodedDataResult THAT
// PROVIDES A RESULT FIELD THAT COULD BE SET TO ESKT_CANCEL WHEN
// THE END-USER CANCELS A SOFTSCAN OPERATION
/**
 * called each time ScanAPI receives decoded data from scanner
 * @param deviceInfo contains the device information from which
 * the data has been decoded
 * @param decodedData contains the decoded data information
 */
-(void) onDecodedData:(DeviceInfo*) device decodedData:(id<ISktScanDecodedData>) decodedData {
    
}

@end
