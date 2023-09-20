//
//  CustomerTyvLyModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 15/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerTyvLyModalViewController.h"

@implementation CustomerTyvLyModalViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize tableHeader = _tableHeader;
@synthesize inStockTableHeader = _inStockTableHeader;
@synthesize tableHeader2;
@synthesize tableListView;
//@synthesize displayList;
@synthesize locationIUR;
@synthesize columnQty;
@synthesize customerTyvLyDataManager = _customerTyvLyDataManager;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    for (UIGestureRecognizer* recognizer in self.tableHeader.details.gestureRecognizers) {
        [self.tableHeader.details removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.tableHeader.tYTDValue.gestureRecognizers) {
        [self.tableHeader.tYTDValue removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.inStockTableHeader.details.gestureRecognizers) {
        [self.inStockTableHeader.details removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in self.inStockTableHeader.tYTDValue.gestureRecognizers) {
        [self.inStockTableHeader.tYTDValue removeGestureRecognizer:recognizer];
    }
    self.tableHeader = nil;
    self.inStockTableHeader = nil;
    self.tableHeader2 = nil;    
    self.tableListView = nil;
//    self.displayList = nil;    
    self.locationIUR = nil;
//    [activityIndicator release];
    callGenericServices.delegate = nil;
    [callGenericServices release];
    if (connectivityCheck != nil) { [connectivityCheck release]; }
    self.customerTyvLyDataManager = nil;
    [super dealloc];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    columnQty = 0;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
    self.customerTyvLyDataManager = [[[CustomerTyvLyDataManager alloc] init] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag]) {
        [self.customerTyvLyDataManager processTyvLyWithLocationIUR:self.locationIUR];
    } else {
        callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
        callGenericServices.delegate = self;       
        
        [callGenericServices getRecord:@"LocationSales" iur:[self.locationIUR intValue]];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableHeader = nil;
    self.tableHeader2 = nil;
    self.tableListView = nil;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    if ([self.customerTyvLyDataManager.databaseName isEqualToString:[GlobalSharedClass shared].pxDbName] && [[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag]) {
        [self configHeaderEventWithHeader:self.inStockTableHeader];
        return self.inStockTableHeader;
    }
    [self configHeaderEventWithHeader:self.tableHeader];
    if (self.columnQty == 15) {
        return self.tableHeader;
    }
    return self.tableHeader;
}

- (void)configHeaderEventWithHeader:(CustomerTyvLyTableViewHeader*)aHeader {
    for (UIGestureRecognizer* recognizer in aHeader.details.gestureRecognizers) {
        [aHeader.details removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTapDetails = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDetailsDoubleTapGesture:)];
    doubleTapDetails.numberOfTapsRequired = 2;
    [aHeader.details addGestureRecognizer:doubleTapDetails];
    [doubleTapDetails release];
    
    for (UIGestureRecognizer* recognizer in aHeader.tYTDValue.gestureRecognizers) {
        [aHeader.tYTDValue removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTapTYTDValue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderTYTDValueDoubleTapGesture:)];
    doubleTapTYTDValue.numberOfTapsRequired = 2;
    [aHeader.tYTDValue addGestureRecognizer:doubleTapTYTDValue];
    [doubleTapTYTDValue release];
    
}

- (void)handleHeaderDetailsDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {        
        if (self.customerTyvLyDataManager.detailClickTime % 2 == 0) {
            NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field16" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [self.customerTyvLyDataManager.displayList sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, nil]];
        } else {
            NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field2" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [self.customerTyvLyDataManager.displayList sortUsingDescriptors:[NSArray arrayWithObjects:detailsDescriptor, nil]];
            
        }
        [self.tableView reloadData];
        self.customerTyvLyDataManager.detailClickTime++;
    }
}

- (void)handleHeaderTYTDValueDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        BOOL ascendingFlag = YES;
        if (self.customerTyvLyDataManager.totalClickTime % 2 == 0) {
            
        } else {
            ascendingFlag = NO;
        }
        NSSortDescriptor* totalDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field5" ascending:ascendingFlag selector:@selector(localizedStandardCompare:)] autorelease];
        [self.customerTyvLyDataManager.displayList sortUsingDescriptors:[NSArray arrayWithObjects:totalDescriptor, nil]];
        [self.tableView reloadData];
        self.customerTyvLyDataManager.totalClickTime++;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.customerTyvLyDataManager.displayList != nil) {
        return [self.customerTyvLyDataManager.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self initColumn15TableViewCell:tableView cellForRowAtIndexPath:indexPath];
//    if (self.columnQty == 15) {
//        
//    }
    
//    NSLog(@"should not happen");
    
//    NSString *CellIdentifier = @"IdCustomerTyvLyTableCell";
//    
//    CustomerTyvLyTableCell *cell=(CustomerTyvLyTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//	if(cell == nil) {
//        
//        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerTyvLyTableCell" owner:self options:nil];        
//        
//        for (id nibItem in nibContents) {
//            if ([nibItem isKindOfClass:[CustomerTyvLyTableCell class]] && [[(CustomerTyvLyTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
//                cell= (CustomerTyvLyTableCell *) nibItem;
//                
//                //cell.delegate=self;                
//            }
//        }
//	}
//    
//    return cell;
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
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)totalsPressed:(id)sender {
    UILabel* details = (UILabel*)[self.tableHeader viewWithTag:300];
    details.text = @"another details";
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer invoice details");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        
//        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        self.columnQty = [result.FieldNames.Field50 intValue];
        NSLog(@"columnQty is: %d", self.columnQty);
        self.customerTyvLyDataManager.displayList = result.ArrayOfData;
        
        [self.tableListView reloadData];
        
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
//    [activityIndicator stopAnimating];    
}

#pragma mark - initiate the correct cell
- (UITableViewCell *)initColumn15TableViewCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"IdLabelCustomerTyvLyTableCell";
    if ([self.customerTyvLyDataManager.databaseName isEqualToString:[GlobalSharedClass shared].pxDbName] && [[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag]) {
        CellIdentifier = @"IdInStockLabelCustomerTyvLyTableCell";
    }
    
    CustomerTyvLyTableCell *cell=(CustomerTyvLyTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerTyvLyTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerTyvLyTableCell class]] && [[(CustomerTyvLyTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerTyvLyTableCell *) nibItem;
                
                //cell.delegate=self;                
            }
        }
	}        
    
    // Configure the cell...
    ArcosGenericClass* cellData = [self.customerTyvLyDataManager.displayList objectAtIndex:indexPath.row];
    cell.details.text = [cellData Field2];
    cell.orderPadDetails.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field16]]];
    cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field18]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field17]]];
    } else {
        cell.productCode.text = @"";
    }
    
    cell.inStock.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field19]]];
//    if ([cell.orderPadDetails.text isEqualToString:@""]) {
//        cell.productCode.text = @"";
//        cell.productSize.text = @"";
//    } else {
//        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field17]]];
//        cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field18]]];
//    }
    
    cell.lYQty.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field12]]];
    cell.lYBonus.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field13]]];
    cell.lYValue.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field14]]];
    
    cell.lYTDQty.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field9]]];
    cell.lYTDBonus.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field10]]];
    cell.lYTDValue.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field11]]];
    cell.tYTDQty.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field3]]];
    cell.tYTDBonus.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field4]]];
    cell.tYTDValue.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field5]]];    
    
    cell.qty.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertToIntString:[cellData Field15]]];    
    
    return cell;
}

//connectivity notification back
/**
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSLog(@"enter into the check connection.");
        [check stop];        
        [[NSNotificationCenter defaultCenter]removeObserver:self];        
        [callGenericServices getRecord:@"LocationSales" iur:[self.locationIUR intValue]];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}
*/


@end
