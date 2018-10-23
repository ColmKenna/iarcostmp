//
//  DashboardPromotionTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 09/12/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "DashboardPromotionTableViewController.h"

@interface DashboardPromotionTableViewController ()

@end

@implementation DashboardPromotionTableViewController
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize displayList = _displayList;
@synthesize myHeaderView = _myHeaderView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSString* sqlStatement = @"SELECT ProductCode,Description,OrderPadDetails,ProductSize,BonusMinimum,BonusRequired,BonusGiven,IUR FROM iPADStockOnPromotion Order by OrderPadDetails,Description";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* promotionCellIdentifier = @"IdDashboardPromotionTableViewCell";
    
    DashboardPromotionTableViewCell* cell = (DashboardPromotionTableViewCell*) [tableView dequeueReusableCellWithIdentifier:promotionCellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"DashboardPromotionTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[DashboardPromotionTableViewCell class]] && [[(DashboardPromotionTableViewCell*)nibItem reuseIdentifier] isEqualToString:promotionCellIdentifier]) {
                cell = (DashboardPromotionTableViewCell*) nibItem;
            }
        }
    }
    
    // Configure the cell...
    ArcosGenericClass* promotionArcosGenericClass = [self.displayList objectAtIndex:indexPath.row];
    cell.productCodeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field1]];
    cell.descLabel.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@",[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field3], [ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field2]]];
    cell.productSizeLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field4]];
    cell.bonusMinimumLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field5]];
    cell.bonusRequiredLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field6]];
    cell.bonusGivenLabel.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:promotionArcosGenericClass.Field7]];
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.presentViewDelegate = self;
    ArcosGenericClass* promotionArcosGenericClass = [self.displayList objectAtIndex:indexPath.row];
    pdvc.productIUR = [ArcosUtils convertStringToNumber:promotionArcosGenericClass.Field8];
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
