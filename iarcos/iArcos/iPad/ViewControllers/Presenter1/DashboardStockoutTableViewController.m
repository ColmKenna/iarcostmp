//
//  DashboardStockoutTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardStockoutTableViewController.h"

@interface DashboardStockoutTableViewController ()

@end

@implementation DashboardStockoutTableViewController
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize displayList = _displayList;
@synthesize myHeaderView = _myHeaderView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.rootView = [ArcosUtils getRootView];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
}

- (void)dealloc {
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.displayList = nil;
    self.myHeaderView = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    NSString* sqlStatement = @"SELECT ProductCode,Description,OrderPadDetails,ProductSize,StockOnOrder,StockDueDate,IUR FROM iPADStockOutList Order by OrderPadDetails,Description";
    [self.callGenericServices getData:sqlStatement];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.displayList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.myHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* stockoutCellIdentifier = @"IdDashboardStockoutTableViewCell";
    
    DashboardStockoutTableViewCell* cell = (DashboardStockoutTableViewCell*) [tableView dequeueReusableCellWithIdentifier:stockoutCellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardStockoutTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardStockoutTableViewCell class]] && [[(DashboardStockoutTableViewCell*)nibItem reuseIdentifier] isEqualToString:stockoutCellIdentifier]) {
                cell = (DashboardStockoutTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    ArcosGenericClass* stockoutArcosGenericClass = [self.displayList objectAtIndex:indexPath.row];
    cell.productCodeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field1]];
    cell.descLabel.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field3], [ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field2]]];
    cell.productSizeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field4]];
    cell.onOrderLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field5]];
    cell.dueDateLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:stockoutArcosGenericClass.Field6]];
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.presentViewDelegate = self;
    ArcosGenericClass* promotionArcosGenericClass = [self.displayList objectAtIndex:indexPath.row];
    pdvc.productIUR = [ArcosUtils convertStringToNumber:promotionArcosGenericClass.Field7];
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
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

#pragma mark GetDataGenericDelegate
- (void)setGetDataResult:(ArcosGenericReturnObject *)result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}


@end
