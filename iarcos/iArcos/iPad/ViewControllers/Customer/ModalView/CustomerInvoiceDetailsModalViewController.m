//
//  CustomerInvoiceDetailsModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerInvoiceDetailsModalViewController.h"
#import "CustomerOrderDetailsModalViewController.h"


@implementation CustomerInvoiceDetailsModalViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize invoiceDetailListView;
@synthesize tableHeader = _tableHeader;
@synthesize displayList;
@synthesize IUR;
@synthesize orderHeaderIUR = _orderHeaderIUR;
@synthesize orderNumber = _orderNumber;
@synthesize globalNavigationController = _globalNavigationController;

@synthesize textView;
@synthesize employee;
@synthesize type;
@synthesize status;
@synthesize deliveryBy;
@synthesize number;
@synthesize date;
@synthesize ref;
@synthesize order;

@synthesize comment1;
@synthesize comment2;
@synthesize carriage;
@synthesize goods;
@synthesize vat;
@synthesize total;
@synthesize screenLoadedFlag = _screenLoadedFlag;

@synthesize employeeLabel = _employeeLabel;
@synthesize typeLabel = _typeLabel;
@synthesize statusLabel = _statusLabel;
@synthesize deliveryByLabel = _deliveryByLabel;
@synthesize numberLabel = _numberLabel;
@synthesize dateLabel = _dateLabel;
@synthesize refLabel = _refLabel;
@synthesize orderLabel = _orderLabel;
@synthesize commentLabel = _commentLabel;
@synthesize carriageLabel = _carriageLabel;
@synthesize goodsLabel = _goodsLabel;
@synthesize vatLabel = _vatLabel;
@synthesize totalLabel = _totalLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if(self.invoiceDetailListView != nil) { self.invoiceDetailListView = nil; }
    if(self.tableHeader != nil) { self.tableHeader = nil; }    
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.IUR != nil) { self.IUR = nil; }
    self.orderHeaderIUR = nil;
    self.orderNumber = nil;
    self.globalNavigationController = nil;
    if (callGenericServices != nil) {
        [callGenericServices release];
        callGenericServices = nil;
    }
    
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }
    if (self.type != nil) { self.type = nil; }
    if (self.status != nil) { self.status = nil; }
    if (self.deliveryBy != nil) { self.deliveryBy = nil; }
    if (self.number != nil) { self.number = nil; }
    if (self.date != nil) { self.date = nil; }
    if (self.ref != nil) { self.ref = nil; }
    if (self.order != nil) { self.order = nil; }
    
    if (self.comment1 != nil) { self.comment1 = nil; } 
    if (self.comment2 != nil) { self.comment2 = nil; } 
    if (self.carriage != nil) { self.carriage = nil; }    
    if (self.goods != nil) { self.goods = nil; } 
    if (self.vat != nil) { self.vat = nil; } 
    if (self.total != nil) { self.total = nil; }
    
    self.employeeLabel = nil;
    self.typeLabel = nil;
    self.statusLabel = nil;
    self.deliveryByLabel = nil;
    self.numberLabel = nil;
    self.dateLabel = nil;
    self.refLabel = nil;
    self.orderLabel = nil;
    self.commentLabel = nil;
    self.carriageLabel = nil;
    self.goodsLabel = nil;
    self.vatLabel = nil;
    self.totalLabel = nil;
    
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
    // Do any additional setup after loading the view from its nib.
    //NSMutableArray* array = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    //self.displayList = array;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    
    [self.navigationItem setLeftBarButtonItem:doneButton];  
    
    [doneButton release];
    
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//	[dict setObject:@"33.2200" forKey:@"qty"];
//	[dict setObject:@"Doe" forKey:@"description"];
//	[dict setObject:@"55.2300" forKey:@"value"];
//    
//    self.displayList = [[[NSMutableArray alloc] init] autorelease];
//    [self.displayList addObject:dict];
//    [self.displayList addObject:dict];
//    [self.displayList addObject:dict];
//    [dict release];
    
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
//    [activityIndicator startAnimating];
    
    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
        
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.orderNumber = @"";
    self.orderHeaderIUR = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if(self.invoiceDetailListView != nil) { self.invoiceDetailListView = nil; }
    if(self.tableHeader != nil) { self.tableHeader = nil; }
    
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }
    if (self.type != nil) { self.type = nil; }
    if (self.status != nil) { self.status = nil; }
    if (self.deliveryBy != nil) { self.deliveryBy = nil; }
    if (self.number != nil) { self.number = nil; }
    if (self.date != nil) { self.date = nil; }
    if (self.ref != nil) { self.ref = nil; }
    if (self.order != nil) { self.order = nil; }
                                        
    if (self.comment1 != nil) { self.comment1 = nil; } 
    if (self.comment2 != nil) { self.comment2 = nil; } 
    if (self.carriage != nil) { self.carriage = nil; }    
    if (self.goods != nil) { self.goods = nil; } 
    if (self.vat != nil) { self.vat = nil; } 
    if (self.total != nil) { self.total = nil; }            
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.screenLoadedFlag) return;
    self.screenLoadedFlag = YES;
    [callGenericServices getRecord:@"Invoice" iur:[self.IUR intValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)donePressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    NSMutableArray* qtyObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"IQTY"];
    NSString* qtyTitle = @"Qty";
    if ([qtyObjectList count] > 0) {
        NSDictionary* qtyDescrDetailDict = [qtyObjectList objectAtIndex:0];
        NSString* qtyDetail = [qtyDescrDetailDict objectForKey:@"Detail"];
        qtyTitle = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:qtyDetail]];
    }
    NSString* bonTitle = @"Bon";
    NSMutableArray* bonObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"IBON"];
    if ([bonObjectList count] > 0) {
        NSDictionary* bonDescrDetailDict = [bonObjectList objectAtIndex:0];
        NSString* bonDetail = [bonDescrDetailDict objectForKey:@"Detail"];
        bonTitle = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:bonDetail]];
    }
    self.tableHeader.qtyLabel.text = qtyTitle;
    self.tableHeader.bonLabel.text = bonTitle;
    return self.tableHeader;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
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
     
    NSString *CellIdentifier = @"IdCustomerInvoiceDetailTableCell";
    
    CustomerInvoiceDetailTableCell *cell=(CustomerInvoiceDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerInvoiceDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerInvoiceDetailTableCell class]] && [[(CustomerInvoiceDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerInvoiceDetailTableCell *) nibItem;
                
                //cell.delegate=self;                
            }
        }
	}
    
    // Configure the cell...
    
    
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.qty.text = [ArcosUtils convertZeroToBlank:[cellData Field10]];
    cell.bonusQty.text = [ArcosUtils convertZeroToBlank:[cellData Field13]];
    
    cell.description.text = [cellData Field21];
    
    cell.value.text = [ArcosUtils convertToFloatString:[cellData Field11]];
    
    return cell;
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

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer invoice details");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
       
        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        NSMutableString* textViewString = [[NSMutableString alloc] init];
        
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [replyResult Field3]]];        
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field4]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field5]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field6]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field7]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field8]]]];
        
        self.textView.text = textViewString;
        [textViewString release];
        self.employee.text = [replyResult Field10];
        self.type.text = [replyResult Field12];
        self.status.text = [replyResult Field15];
        self.deliveryBy.text = [replyResult Field14];        
        self.number.text = [replyResult Field18];
        self.date.text = [ArcosUtils convertDatetimeToDate:[replyResult Field17]];
        self.ref.text = [replyResult Field24];
        self.order.text = [replyResult Field16];
        self.orderNumber = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field16]]]];
        self.orderHeaderIUR = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field25]]]];
        if (![self.orderNumber isEqualToString:@""]) {
            self.order.textColor = [UIColor blueColor];
        } else {
            self.order.textColor = [UIColor blackColor];
        }
        
        self.comment1.text = [replyResult Field19];
        self.comment2.text = [replyResult Field20];
        self.carriage.text = [ArcosUtils convertToFloatString:[replyResult Field23]];
        self.goods.text = [ArcosUtils convertToFloatString:[replyResult Field21]];
        self.vat.text = [ArcosUtils convertToFloatString:[replyResult Field22]];
        self.total.text = [NSString stringWithFormat:@"%.2f", [[replyResult Field21] floatValue] + [[replyResult Field22] floatValue]];        
        self.displayList = replyResult.SubObjects;
        [self.invoiceDetailListView reloadData];
        if ([[replyResult Field21] floatValue] + [[replyResult Field22] floatValue] < 0) {
            self.view.backgroundColor = [UIColor redColor];
        }
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
//    [activityIndicator stopAnimating];    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.orderNumber isEqualToString:@""]) {
        NSString* orderDetailsNibName = @"CustomerOrderDetailsModalViewController";
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            orderDetailsNibName = @"CustomerOrderDetailsGoodsVatModalViewController";
        }
        CustomerOrderDetailsModalViewController* codmvc=[[CustomerOrderDetailsModalViewController alloc]initWithNibName:orderDetailsNibName bundle:nil];
        codmvc.title = @"ORDER DETAILS";
        codmvc.animateDelegate = self;
        codmvc.orderIUR = self.orderHeaderIUR;
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:codmvc] autorelease];
        self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:self.globalNavigationController animated:YES completion:nil];
        [codmvc release];
    }
    return NO;
}

#pragma mark - SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

@end
