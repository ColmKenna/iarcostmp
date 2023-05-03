//
//  CustomerIarcosInvoiceDetailsTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 16/12/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosInvoiceDetailsTableViewController.h"
#import "ArcosStackedViewController.h"
#import "CustomerOrderDetailsModalViewController.h"

@interface CustomerIarcosInvoiceDetailsTableViewController ()

@end

@implementation CustomerIarcosInvoiceDetailsTableViewController
@synthesize customerInfoHeaderViewController = _customerInfoHeaderViewController;
@synthesize customerIarcosInvoiceDetailsDataManager = _customerIarcosInvoiceDetailsDataManager;
@synthesize callGenericServices = _callGenericServices;
@synthesize invoiceDetailsCellFactory = _invoiceDetailsCellFactory;
@synthesize locationIUR = _locationIUR;
@synthesize screenLoadedFlag = _screenLoadedFlag;
@synthesize globalNavigationController = _globalNavigationController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.customerInfoHeaderViewController = [[[CustomerInfoHeaderViewController alloc] initWithNibName:@"CustomerInfoHeaderViewController" bundle:nil] autorelease];
        self.customerIarcosInvoiceDetailsDataManager = [[[CustomerIarcosInvoiceDetailsDataManager alloc] init] autorelease];
        self.invoiceDetailsCellFactory = [CustomerIarcosInvoiceDetailsCellFactory factory];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
}

- (void)dealloc {
    [self.customerInfoHeaderViewController.view removeFromSuperview];
    self.customerInfoHeaderViewController = nil;
    self.customerIarcosInvoiceDetailsDataManager = nil;
    self.callGenericServices = nil;
    self.invoiceDetailsCellFactory = nil;
    self.locationIUR = nil;
    self.globalNavigationController = nil;
    
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.screenLoadedFlag) return;
    self.screenLoadedFlag = YES;
    [self.callGenericServices getRecord:@"Invoice" iur:[self.customerIarcosInvoiceDetailsDataManager.invoiceIUR intValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.customerIarcosInvoiceDetailsDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.customerIarcosInvoiceDetailsDataManager.sectionTitleList objectAtIndex:section];
    
    return [[self.customerIarcosInvoiceDetailsDataManager.groupedDataDict objectForKey:sectionTitle] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString* suffixString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", [ArcosUtils convertNilToEmpty:[self.customerIarcosInvoiceDetailsDataManager.replyResult Field3]], [ArcosUtils convertNilToEmpty:[self.customerIarcosInvoiceDetailsDataManager.replyResult Field4]], [ArcosUtils convertNilToEmpty:[self.customerIarcosInvoiceDetailsDataManager.replyResult Field5]], [ArcosUtils convertNilToEmpty:[self.customerIarcosInvoiceDetailsDataManager.replyResult Field6]], [ArcosUtils convertNilToEmpty:[self.customerIarcosInvoiceDetailsDataManager.replyResult Field7]]];
        self.customerInfoHeaderViewController.headerContentValue = [NSString stringWithFormat:@"%@", suffixString];
        return self.customerInfoHeaderViewController.view;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 160.0f;
    }
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* cellData = [self.customerIarcosInvoiceDetailsDataManager cellDataWithIndexPath:indexPath];
    OrderDetailBaseTableCell* cell = (OrderDetailBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.invoiceDetailsCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (OrderDetailBaseTableCell*)[self.invoiceDetailsCellFactory createOrderDetailBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.isNotEditable = YES;
    [cell configCellWithData:cellData];
    
    return cell;
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        [self.customerIarcosInvoiceDetailsDataManager loadInvoiceDetailsData:replyResult];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        
    }
}

#pragma mark OrderDetailTypesTableCellDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {

}
-(void)showOrderlineDetailsDelegate {
    OrderlinesIarcosTableViewController* oitvc = [[OrderlinesIarcosTableViewController alloc] initWithStyle:UITableViewStylePlain];
    oitvc.isCellEditable = NO;
    [oitvc resetTableDataWithData:self.customerIarcosInvoiceDetailsDataManager.orderlineDictList];
    oitvc.locationIUR = self.locationIUR;
    
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:oitvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [oitvc release];
    [tmpNavigationController release];
}

- (void)showOrderDetailViewController {
    if ([self.customerIarcosInvoiceDetailsDataManager.orderNumber isEqualToString:@""]) return;
    NSString* orderDetailsNibName = @"CustomerOrderDetailsModalViewController";
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        orderDetailsNibName = @"CustomerOrderDetailsGoodsVatModalViewController";
    }
    CustomerOrderDetailsModalViewController* codmvc=[[CustomerOrderDetailsModalViewController alloc]initWithNibName:orderDetailsNibName bundle:nil];
    codmvc.title = @"ORDER DETAILS";
    codmvc.animateDelegate = self;
    codmvc.orderIUR = self.customerIarcosInvoiceDetailsDataManager.orderHeaderIUR;
    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:codmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:self.globalNavigationController animated:YES completion:nil];
    [codmvc release];
}

#pragma mark - SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

@end
