//
//  DashboardVanStocksViewController.m
//  iArcos
//
//  Created by David Kilmartin on 12/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "DashboardVanStocksViewController.h"
#import "ArcosRootViewController.h"

@interface DashboardVanStocksViewController ()

@end

@implementation DashboardVanStocksViewController
@synthesize dashboardVanStocksHeaderView = _dashboardVanStocksHeaderView;
@synthesize callGenericServices = _callGenericServices;
@synthesize dashboardVanStocksDataManager = _dashboardVanStocksDataManager;
@synthesize updateVanStockButton = _updateVanStockButton;
@synthesize progressBar = _progressBar;
@synthesize vanStockTableView = _vanStockTableView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize saveRecordTimer = _saveRecordTimer;
@synthesize mainCellSeparator = _mainCellSeparator;
@synthesize orderButton = _orderButton;
//@synthesize inputPopover = _inputPopover;
//@synthesize dvsdtvc = _dvsdtvc;
@synthesize dvsdvc = _dvsdvc;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.dashboardVanStocksDataManager = [[[DashboardVanStocksDataManager alloc] init] autorelease];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
//    self.dvsdtvc = [[[DashboardVanStocksDetailTableViewController alloc] initWithNibName:@"DashboardVanStocksDetailTableViewController" bundle:nil] autorelease];
//    self.dvsdtvc.presentDelegate = self;
    /*
    self.dvsdvc = [[[DashboardVanStocksDetailViewController alloc] init] autorelease];
    self.dvsdvc.presentDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.dvsdvc] autorelease];
    self.inputPopover = [[[UIPopoverController alloc] initWithContentViewController:self.globalNavigationController] autorelease];
    self.inputPopover.popoverContentSize = self.dvsdvc.view.frame.size;
    */
}

- (void)dealloc {
    self.dashboardVanStocksHeaderView = nil;
    self.callGenericServices = nil;
    self.dashboardVanStocksDataManager = nil;
    self.updateVanStockButton = nil;
    self.progressBar = nil;
    self.vanStockTableView = nil;    
    self.rootView = nil;
    self.saveRecordTimer = nil;
    self.mainCellSeparator = nil;
    self.orderButton = nil;
//    self.dvsdtvc = nil;
    self.dvsdvc = nil;
    self.globalNavigationController = nil;
//    self.inputPopover = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{    
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if ([self.inputPopover isPopoverVisible]) {
//        [self.inputPopover dismissPopoverAnimated:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dashboardVanStocksDataManager retrieveStockOnOrderProducts];
    [self.vanStockTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dashboardVanStocksDataManager.displayList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.dashboardVanStocksHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* vanStockCellIdentifier = @"IdDashboardVanStocksTableViewCell";
    
    DashboardVanStocksTableViewCell* cell = (DashboardVanStocksTableViewCell*) [tableView dequeueReusableCellWithIdentifier:vanStockCellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardVanStocksTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardVanStocksTableViewCell class]] && [[(DashboardVanStocksTableViewCell*)nibItem reuseIdentifier] isEqualToString:vanStockCellIdentifier]) {
                cell = (DashboardVanStocksTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    NSDictionary* vanStocksDict = [self.dashboardVanStocksDataManager.displayList objectAtIndex:indexPath.row];
    cell.productCodeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[vanStocksDict objectForKey:@"ProductCode"]]];
    cell.descLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[vanStocksDict objectForKey:@"Description"]]];
    cell.productSizeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[vanStocksDict objectForKey:@"Productsize"]]];
    cell.stockOnOrderLabel.text = [ArcosUtils convertNumberToIntString:[vanStocksDict objectForKey:@"StockonOrder"]];
    cell.stockOnHandLabel.text = [ArcosUtils convertNumberToIntString:[vanStocksDict objectForKey:@"StockonHand"]];
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    /*
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.presentViewDelegate = self;
    NSDictionary* vanStocksDict = [self.dashboardVanStocksDataManager.displayList objectAtIndex:indexPath.row];
    pdvc.productIUR = [vanStocksDict objectForKey:@"ProductIUR"];
    pdvc.locationIUR = [NSNumber numberWithInt:0];
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:pdvc] autorelease];
    [pdvc release];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
    */    
    self.dvsdvc = [[[DashboardVanStocksDetailViewController alloc] init] autorelease];
    self.dvsdvc.presentDelegate = self;
    self.dvsdvc.cellData = [self.dashboardVanStocksDataManager.displayList objectAtIndex:indexPath.row];    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.dvsdvc] autorelease];
//    self.inputPopover = [[[UIPopoverController alloc] initWithContentViewController:self.globalNavigationController] autorelease];
//    self.inputPopover.delegate = self;
//    self.inputPopover.popoverContentSize = self.dvsdvc.view.frame.size;
//    CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height, 1, 1);
//    self.dvsdtvc.cellData = [self.dashboardVanStocksDataManager.displayList objectAtIndex:indexPath.row];
    
    
//    [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
//    [UIView animateWithDuration:0.3f animations:^{
//        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
//        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
//    } completion:^(BOOL finished){
//        [self.globalNavigationController willMoveToParentViewController:nil];
//        [self.globalNavigationController.view removeFromSuperview];
//        [self.globalNavigationController removeFromParentViewController];
//        self.globalNavigationController = nil;
//    }];
}

- (void)prepareData {
    [self.dashboardVanStocksDataManager resetVanStockData];
    [self.dashboardVanStocksDataManager retrieveExistingObjectDict];
    self.dashboardVanStocksDataManager.vanSalesFormDetailDict = [self.dashboardVanStocksDataManager retrieveVanSalesFormDetail];
    [self.dashboardVanStocksDataManager removeVanSalesFormRow];
}

- (void)setGenericGetFromResourcesResult:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result != nil) {
        BOOL saveFileFlag = NO;
        NSData* myNSData = [[NSData alloc] initWithBase64EncodedString:result options:0];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon documentsPath], [self.dashboardVanStocksDataManager retrieveFileName]];
        saveFileFlag = [myNSData writeToFile:filePath atomically:YES];
        [myNSData release];
        if (saveFileFlag) {            
            NSString* fileContents = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            NSArray* rowList = [fileContents componentsSeparatedByString:[GlobalSharedClass shared].rowDelimiter];
            [self.dashboardVanStocksDataManager processRawData:rowList];
            [fileContents release];          
            [FileCommon removeFileAtPath:filePath];
            if ([self.dashboardVanStocksDataManager.vanStockDictList count] > 0) {
                void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                    [self.updateVanStockButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    self.updateVanStockButton.enabled = NO;
                    [self.progressBar setProgress:0.0];
                    self.dashboardVanStocksDataManager.rowPointer = 0;
                    self.dashboardVanStocksDataManager.isSaveRecordLoadingFinished = YES;
                    [self prepareData];                    
                    self.saveRecordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkObjectList) userInfo:nil repeats:YES];
                };
                void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                    
                };
                [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Update Van Stocks for %@", self.dashboardVanStocksDataManager.firstDate] title:@"" delegate:nil target:self tag:0 lBtnText:@"YES" rBtnText:@"NO" lBtnHandler:yesActionHandler rBtnHandler:noActionHandler];
            } else {
                [self prepareData];
                self.dashboardVanStocksDataManager.existingObjectList = nil;
                self.dashboardVanStocksDataManager.existingObjectDict = nil;
                [self.dashboardVanStocksDataManager retrieveStockOnOrderProducts];
                [self.vanStockTableView reloadData];
                [ArcosUtils showDialogBox:@"No data found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
            }            
        } else {
            [ArcosUtils showDialogBox:@"Unable to save the file on the iPad." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        }
    } else {
    }  
    
}

- (IBAction)updateVanStockButtonPressed:(id)sender {
    [self.callGenericServices genericGetFromResourcesWithFileName:[self.dashboardVanStocksDataManager retrieveFileName] action:@selector(setGenericGetFromResourcesResult:) target:self];
}

- (void)checkObjectList {
    if (self.dashboardVanStocksDataManager.isSaveRecordLoadingFinished) {
        if (self.dashboardVanStocksDataManager.rowPointer >= [self.dashboardVanStocksDataManager.vanStockDictList count]) {
            self.dashboardVanStocksDataManager.existingObjectList = nil;
            self.dashboardVanStocksDataManager.existingObjectDict = nil;
            [[ArcosCoreData sharedArcosCoreData].importManagedObjectContext reset];
            [self.dashboardVanStocksDataManager retrieveStockOnOrderProducts];            
            [self.vanStockTableView reloadData];
            [self.updateVanStockButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            self.updateVanStockButton.enabled = YES;
            [self.saveRecordTimer invalidate];
            self.saveRecordTimer = nil;
            [ArcosUtils showDialogBox:@"Download has Completed" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        } else {
            self.dashboardVanStocksDataManager.isSaveRecordLoadingFinished = NO;            
            [self.dashboardVanStocksDataManager loadObjectWithDict:[self.dashboardVanStocksDataManager.vanStockDictList objectAtIndex:self.dashboardVanStocksDataManager.rowPointer]];
            self.dashboardVanStocksDataManager.rowPointer++;
            [self updateSaveRecordProgressBar:self.dashboardVanStocksDataManager.rowPointer * 1.0f / [self.dashboardVanStocksDataManager.vanStockDictList count]];
            self.dashboardVanStocksDataManager.isSaveRecordLoadingFinished = YES;
        }
    }
}

- (void)updateSaveRecordProgressBar:(float)aValue {
    [self.progressBar setProgress:aValue];
}

- (IBAction)orderButtonPressed:(id)sender {
    void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        BOOL resultFlag = [self.dashboardVanStocksDataManager orderButtonPressed:self];
        if (resultFlag) {
            [ArcosUtils showDialogBox:@"Order has been generated" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                int itemIndex = [self.rootView.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[[GlobalSharedClass shared] listingsText]];
                self.rootView.customerMasterViewController.currentIndexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
                [self.rootView.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:self.rootView.customerMasterViewController.currentIndexPath];
            }];
        }        
    };
    void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to generate replenish order"] title:@"" delegate:nil target:self tag:0 lBtnText:@"YES" rBtnText:@"NO" lBtnHandler:yesActionHandler rBtnHandler:noActionHandler];
}

#pragma mark DashboardVanStocksDetailTableViewControllerDelegate
- (void)didDismissDashboardVanStocksDetailTableViewController {
    [self.dashboardVanStocksDataManager retrieveStockOnOrderProducts];
    [self.vanStockTableView reloadData];
//    [self.inputPopover dismissPopoverAnimated:YES];
    self.dvsdvc.presentDelegate = nil;
    self.dvsdvc = nil;
    self.globalNavigationController = nil;
//    self.inputPopover.delegate = nil;
//    self.inputPopover = nil;
}

#pragma mark UIPopoverControllerDelegate
/*
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {    
    self.dvsdvc.presentDelegate = nil;
    self.dvsdvc = nil;
    self.globalNavigationController = nil;
    self.inputPopover.delegate = nil;
    self.inputPopover = nil;
}*/


@end
