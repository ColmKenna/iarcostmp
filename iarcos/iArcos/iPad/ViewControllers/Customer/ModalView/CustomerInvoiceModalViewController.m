//
//  CustomerInvoiceModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerInvoiceModalViewController.h"
#import "ArcosStackedViewController.h"
@interface CustomerInvoiceModalViewController()
-(void)clearGlobalNavigationController;
- (void)processSqlStatementByType:(int)aType;
@end

@implementation CustomerInvoiceModalViewController

//@synthesize animateDelegate = _animateDelegate;
@synthesize tableHeader;
@synthesize displayList;
@synthesize locationIUR;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{    
    self.tableHeader = nil;
    self.displayList = nil;    
    self.locationIUR = nil;
//    [activityIndicator release];
    callGenericServices.delegate = nil;
    [callGenericServices release];
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; } 
    if (self.rootView != nil) { self.rootView = nil; }
    [arcosCustomiseAnimation release];
    if (connectivityCheck != nil) { [connectivityCheck release]; }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(closePressed:)];
//    [self.navigationItem setLeftBarButtonItem:closeButton];
//    [closeButton release];
    
//    UIBarButtonItem *totalsButton = [[UIBarButtonItem alloc] initWithTitle:@"Totals" style:UIBarButtonItemStyleBordered target:self action:@selector(totalsPressed:)];
//    [self.navigationItem setLeftBarButtonItem:totalsButton];
//    [totalsButton release];    
    UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(pressAllButton:)];
    [self.navigationItem setRightBarButtonItem:allButton];
    [allButton release];
    

    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
//    [activityIndicator startAnimating];
    
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    arcosCustomiseAnimation.delegate = self;
    //set the notification
/**    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    //init a connectivity check
    connectivityCheck = [[ConnectivityCheck alloc]init];
    [connectivityCheck statusLog];
*/
    [self processSqlStatementByType:0];
}

- (void)pressAllButton:(id)sender {
    [self.rcsStackedController popToNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    self.displayList = nil;
    [self processSqlStatementByType:1];
}

//0: remote , 1: all
- (void)processSqlStatementByType:(int)aType {
    NSString* prevDateSqlStatement = @" and DATEDIFF(mm, dbo.InvoiceHeader.InvDate, GETDATE()) between 0 and ";
    NSString* dateSqlStatement = @"";
    NSString* employeeSqlStatement = @"";
    if (aType == 0) {
        NSNumber* rightRangeNumber = [ArcosDateRangeProcessor retrieveRightRangeNumberWithCode:@"[REIN-"];
        dateSqlStatement = [NSString stringWithFormat:@"%@ %d ", prevDateSqlStatement,[rightRangeNumber intValue]];
    }
    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
        int employeeIur = [[SettingManager employeeIUR] intValue];
        employeeSqlStatement = [NSString stringWithFormat:@" AND dbo.InvoiceHeader.EmployeeIUR = %d", employeeIur];
    }
    NSString* prefixSqlStatement = @"SELECT TOP (100) PERCENT dbo.InvoiceHeader.IUR, CONVERT(VARCHAR(10),dbo.InvoiceHeader.InvDate,103) AS Date, dbo.InvoiceHeader.Reference, ISNULL(dbo.Employee.Forename + ' ' + dbo.Employee.Surname, '  ') AS Employee, dbo.InvoiceHeader.TotalGoods, Location_1.Name AS Wholesaler, dbo.DescrDetail.Details, dbo.InvoiceHeader.EmployeeIUR, dbo.InvoiceHeader.LocationIUR FROM dbo.InvoiceHeader INNER JOIN dbo.Employee ON dbo.InvoiceHeader.EmployeeIUR = dbo.Employee.IUR INNER JOIN dbo.Location ON dbo.InvoiceHeader.LocationIUR = dbo.Location.IUR INNER JOIN dbo.Location AS Location_1 ON dbo.InvoiceHeader.WholesaleIUR = Location_1.IUR INNER JOIN dbo.DescrDetail ON dbo.InvoiceHeader.ITiur = dbo.DescrDetail.IUR LEFT OUTER JOIN dbo.InvoiceLine ON dbo.InvoiceHeader.Reference = dbo.InvoiceLine.Reference";
    
    NSString* suffixSqlStatement = @"GROUP BY dbo.InvoiceHeader.IUR, dbo.InvoiceHeader.InvDate, ISNULL(dbo.Employee.Forename + ' ' + dbo.Employee.Surname, '  '), dbo.InvoiceHeader.TotalGoods, dbo.InvoiceHeader.Reference, Location_1.Name, dbo.DescrDetail.Details, dbo.InvoiceHeader.EmployeeIUR, dbo.InvoiceHeader.LocationIUR ORDER BY dbo.InvoiceHeader.InvDate DESC";
//    NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,CONVERT(VARCHAR(10),Date,103),Reference,Wholesaler, TotalGoods,Details,Employee from invoices where LocationIUR = %@ %@ order by date desc", self.locationIUR, dateSqlStatement];
    NSString* sqlStatement = [NSString stringWithFormat:@"%@ where dbo.InvoiceHeader.LocationIUR = %@ %@ %@ %@", prefixSqlStatement, self.locationIUR, employeeSqlStatement, dateSqlStatement, suffixSqlStatement];
    [callGenericServices getData: sqlStatement];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableHeader = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
//    // custom view for header. will be adjusted to default or specified header height
//    return tableHeader;
//    
//}

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
    // Return the number of rows in the section.
    if (self.displayList != nil) {
        return [self.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    NSString *CellIdentifier = @"IdCustomerIarcosInvoiceTableCell";
    
    CustomerIarcosInvoiceTableCell *cell=(CustomerIarcosInvoiceTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerIarcosInvoiceTableCell" owner:self options:nil];
       
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerIarcosInvoiceTableCell class]] && [[(CustomerIarcosInvoiceTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerIarcosInvoiceTableCell *) nibItem;
                
                //cell.delegate=self;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                
                [singleTap release];

                
            }
        }
	}        
    
    // Configure the cell...
    
    
//    cell.text = [self.displayList objectAtIndex:indexPath.row];
    
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
//    cell.IUR = [cellData Field1];
    cell.dateLabel.text = [ArcosUtils convertDatetimeToDate:[cellData Field2]];
    cell.referenceLabel.text = [cellData Field3];
    NSNumber* valueNumber = [ArcosUtils convertStringToFloatNumber:[cellData Field5]];
    if ([valueNumber floatValue] < 0) {
        [self configCellObjectColor:[UIColor redColor] inCell:cell];
    } else {
        [self configCellObjectColor:[UIColor blackColor] inCell:cell];
    }
    cell.wholesalerLabel.text = [cellData Field6];
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f",[valueNumber floatValue]];
    cell.typeLabel.text = [cellData Field7];
    cell.employeeLabel.text = [cellData Field4];
    
    return cell;
}

- (void)configCellObjectColor:(UIColor*)aColor inCell:(CustomerIarcosInvoiceTableCell*)aCell {
    aCell.wholesalerLabel.textColor = aColor;
    aCell.valueLabel.textColor = aColor;
    aCell.typeLabel.textColor = aColor;
    aCell.employeeLabel.textColor = aColor;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(void)closePressed:(id)sender {
    NSLog(@"closePressed is pressed");
//    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)totalsPressed:(id)sender {
//    return;
    NSLog(@"totalsPressed is pressed");
    
//    CustomerGenericLoadingModalViewController* cglmvc
//    = [[CustomerGenericLoadingModalViewController alloc]initWithNibName:@"CustomerGenericLoadingModalViewController" bundle:nil];
//    cglmvc.delegate = self;
//    cglmvc.view.center = self.view.center;
//    
//    cglmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.0f];
//    [cglmvc setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [cglmvc setModalPresentationStyle:UIModalPresentationPageSheet];
//    //[self presentModalViewController:cglmvc animated:YES];
//    [self.view addSubview:cglmvc.view];
//    
//    [cglmvc release];
//    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [self presentModalViewController:cglmvc animated:YES];
//    [cglmvc release];
}


-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
//    NSLog(@"handleSingleTapGesture");
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:sender tableview:self.tableView];
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:swipedIndexPath.row];
//        NSLog(@"invoice iur is %@", cellData.Field1);
        
        CustomerIarcosInvoiceDetailsTableViewController* CIIDTV = [[CustomerIarcosInvoiceDetailsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        CIIDTV.customerIarcosInvoiceDetailsDataManager.invoiceIUR = [ArcosUtils convertStringToNumber:cellData.Field1];
        CIIDTV.locationIUR = self.locationIUR;
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CIIDTV];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [CIIDTV release];
        [tmpNavigationController release];
    }
}

#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer invoice");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];        
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        
    }
//    [activityIndicator stopAnimating];
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

- (void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

//connectivity notification back
/*
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSLog(@"enter into the check connection.");
        [check stop];        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,CONVERT(VARCHAR(10),Date,103),Reference,Wholesaler, TotalGoods,Details from invoices where LocationIUR = %@ order by date desc", self.locationIUR];
        [callGenericServices getData: sqlStatement];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}
*/

@end
