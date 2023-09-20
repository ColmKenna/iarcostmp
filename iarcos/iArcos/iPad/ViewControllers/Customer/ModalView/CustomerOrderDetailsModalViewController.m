//
//  CustomerOrderDetailsModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerOrderDetailsModalViewController.h"
#import "CustomerInvoiceDetailsModalViewController.h"

@implementation CustomerOrderDetailsModalViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize orderDetailListView;
@synthesize tableHeader;
@synthesize displayList;


@synthesize textView;
@synthesize employee;
@synthesize type;
@synthesize form;
@synthesize status;
@synthesize number;
@synthesize date;
@synthesize ref;
@synthesize contact;

@synthesize delivery;
@synthesize deliveryBy;
@synthesize deliveryStatus;
@synthesize instructions;
@synthesize instructions2;
@synthesize memo;
@synthesize value;
@synthesize goods = _goods;
@synthesize vat = _vat;

@synthesize orderIUR;
@synthesize orderEntryInputDataManager = _orderEntryInputDataManager;
@synthesize invoiceRef = _invoiceRef;
@synthesize invoiceHeaderIUR = _invoiceHeaderIUR;
@synthesize screenLoadedFlag = _screenLoadedFlag;
@synthesize globalNavigationController = _globalNavigationController;

@synthesize employeeLabel = _employeeLabel;
@synthesize typeLabel = _typeLabel;
@synthesize formLabel = _formLabel;
@synthesize statusLabel = _statusLabel;
@synthesize numberLabel = _numberLabel;
@synthesize dateLabel = _dateLabel;
@synthesize refLabel = _refLabel;
@synthesize deliveryLabel = _deliveryLabel;
@synthesize deliveryByLabel = _deliveryByLabel;
@synthesize invoiceLabel = _invoiceLabel;
@synthesize instructionsLabel = _instructionsLabel;
@synthesize memoLabel = _memoLabel;
@synthesize valueLabel = _valueLabel;

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
    if (self.orderDetailListView != nil) { self.orderDetailListView = nil; }
    if (self.tableHeader != nil) { self.tableHeader = nil; }
    
    if (self.displayList != nil) { self.displayList = nil; }
    if (callGenericServices != nil) {
        [callGenericServices release];
        callGenericServices = nil;
    }    
    if (self.orderIUR != nil) { self.orderIUR = nil; }    
    
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }    
    if (self.type != nil) { self.type = nil; }
    if (self.form != nil) { self.form = nil; }    
    if (self.status != nil) { self.status = nil; }
    if (self.number != nil) { self.number = nil; }    
    if (self.date != nil) { self.date = nil; }
    if (self.ref != nil) { self.ref = nil; }
    if (self.contact != nil) { self.contact = nil; }
    
    if (self.delivery != nil) { self.delivery = nil; }
    if (self.deliveryBy != nil) { self.deliveryBy = nil; }
    if (self.deliveryStatus != nil) { self.deliveryStatus = nil; }    
    if (self.instructions != nil) { self.instructions = nil; }
    if (self.instructions2 != nil) { self.instructions2 = nil; }
    if (self.memo != nil) { self.memo = nil; }
    if (self.value != nil) { self.value = nil; }
    self.goods = nil;
    self.vat = nil;
    self.orderEntryInputDataManager = nil;
    self.invoiceRef = nil;
    self.invoiceHeaderIUR = nil;
    self.globalNavigationController = nil;
    
    self.employeeLabel = nil;
    self.typeLabel = nil;
    self.formLabel = nil;
    self.statusLabel = nil;
    self.numberLabel = nil;
    self.dateLabel = nil;
    self.refLabel = nil;
    self.deliveryLabel = nil;
    self.deliveryByLabel = nil;
    self.invoiceLabel = nil;
    self.instructionsLabel = nil;
    self.memoLabel = nil;
    self.valueLabel = nil;
    
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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed:)];
    
    [self.navigationItem setLeftBarButtonItem:doneButton];  
    
    [doneButton release];
    
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
//    [activityIndicator startAnimating];
    
    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
        
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.orderEntryInputDataManager = [[[OrderEntryInputDataManager alloc] init] autorelease];
    self.invoiceRef = @"";
    self.invoiceHeaderIUR = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.orderDetailListView != nil) { self.orderDetailListView = nil; }
    if (self.tableHeader != nil) { self.tableHeader = nil; }    
           
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }    
    if (self.type != nil) { self.type = nil; }
    if (self.form != nil) { self.form = nil; }    
    if (self.status != nil) { self.status = nil; }
    if (self.number != nil) { self.number = nil; }    
    if (self.date != nil) { self.date = nil; }
    if (self.ref != nil) { self.ref = nil; }
    if (self.contact != nil) { self.contact = nil; }
    
    if (self.delivery != nil) { self.delivery = nil; }
    if (self.deliveryBy != nil) { self.deliveryBy = nil; }
    if (self.deliveryStatus != nil) { self.deliveryStatus = nil; }    
    if (self.instructions != nil) { self.instructions = nil; }
    if (self.instructions2 != nil) { self.instructions2 = nil; }
    if (self.memo != nil) { self.memo = nil; }
    if (self.value != nil) { self.value = nil; }        
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.screenLoadedFlag) return;
    self.screenLoadedFlag = YES;
    [callGenericServices getRecord:@"Order" iur:[self.orderIUR intValue]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction)donePressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
//    [self.view removeFromSuperview];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    [self.orderEntryInputDataManager retrieveColumnDescriptionInfo];
    NSString* bonValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.bonKey];
    if (bonValue != nil) {
        self.tableHeader.bonusLabel.text = bonValue;
    }
    NSString* instValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.instKey];
    if (instValue != nil) {
        self.tableHeader.inStockLabel.text = instValue;
    }
    NSString* focValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.focKey];
    if (focValue != nil) {
        self.tableHeader.focLabel.text = focValue;
    }    
    NSString* testValue = [self.orderEntryInputDataManager.columnDescDataDict objectForKey:self.orderEntryInputDataManager.testKey];
    if (testValue != nil) {
        self.tableHeader.testersLabel.text = testValue;
    }
    return tableHeader;
    
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
    NSString *CellIdentifier = @"IdCustomerOrderDetailTableCell";
    
    CustomerOrderDetailTableCell *cell=(CustomerOrderDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerOrderDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerOrderDetailTableCell class]] && [[(CustomerOrderDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerOrderDetailTableCell *) nibItem;
                
                //cell.delegate=self;                
            }
        }
	}
    
    // Configure the cell...
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.qty.text = [ArcosUtils convertZeroToBlank:[cellData Field2]];
    cell.bon.text = [ArcosUtils convertZeroToBlank:[cellData Field3]];
    cell.inStock.text = [ArcosUtils convertZeroToBlank:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field12]]]];
    cell.foc.text = [ArcosUtils convertZeroToBlank:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field13]]]];
    cell.testers.text = [ArcosUtils convertZeroToBlank:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field17]]]];
    cell.discount.text = [ArcosUtils convertZeroToBlank: [ArcosUtils convertToFloatString: [cellData Field10]]]; 
    cell.description.text = [cellData Field5];
    cell.price.text = [NSString stringWithFormat:@"%.2f", [[cellData Field6] floatValue]];
    cell.value.text = [NSString stringWithFormat:@"%.2f", [[cellData Field7] floatValue]];

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
    NSLog(@"set result happens in customer order details");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        NSMutableString* textViewString = [[NSMutableString alloc] init];

        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [replyResult Field2]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field3]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field4]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field5]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field6]]]];
        [textViewString appendString:[NSString stringWithFormat:@"%@\n", [ArcosUtils convertNilToEmpty:[replyResult Field7]]]];            

        self.textView.text = textViewString;
        [textViewString release];
        self.employee.text = [replyResult Field8];
        self.type.text = [replyResult Field10];
        self.form.text = [replyResult Field12];
        self.status.text = [replyResult Field14];
        self.number.text = [replyResult Field15];
        self.date.text = [ArcosUtils convertDatetimeToDate:[replyResult Field16]];
        self.ref.text = [replyResult Field17];
        self.contact.text = [replyResult Field19];
        
        self.delivery.text = [ArcosUtils convertDatetimeToDate:[replyResult Field20]];
        self.deliveryBy.text = [replyResult Field22];
//        self.deliveryStatus.text = [replyResult Field24];
        self.invoiceRef = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field24]]]];
        self.deliveryStatus.text = self.invoiceRef;
        self.invoiceHeaderIUR = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field33]]]];
        if (![self.invoiceRef isEqualToString:@""]) {
            self.deliveryStatus.textColor = [UIColor blueColor];
        } else {
            self.deliveryStatus.textColor = [UIColor blackColor];
        }
        
        self.instructions.text = [replyResult Field25];
//        self.instructions2.text = [replyResult Field26];
        if ([[ArcosUtils convertNilToEmpty:[replyResult Field26]] isEqualToString:@""]) {
            self.memo.text = [ArcosUtils convertNilToEmpty:[replyResult Field28]];
        } else {
            if ([[ArcosUtils convertNilToEmpty:[replyResult Field28]] isEqualToString:@""]) {
                self.memo.text = [NSString stringWithFormat:@"%@", [replyResult Field26]];
            } else {
                self.memo.text = [NSString stringWithFormat:@"%@ | %@", [replyResult Field26], [replyResult Field28]];
            }
        }        
//        self.value.text = [NSString stringWithFormat:@"%.2f", [[replyResult Field27] floatValue]];
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            
        } else {
            
        }
        self.goods.text = [NSString stringWithFormat:@"%.2f", [[replyResult Field27] floatValue]];
        self.vat.text = [NSString stringWithFormat:@"%.2f", [[replyResult Field34] floatValue]];
        self.value.text = [NSString stringWithFormat:@"%.2f", ([[replyResult Field27] floatValue] + [[replyResult Field34] floatValue])];
        self.displayList = replyResult.SubObjects;
        [self.orderDetailListView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
//    [activityIndicator stopAnimating];    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (![self.invoiceRef isEqualToString:@""]) {
        CustomerInvoiceDetailsModalViewController* cidmvc=[[CustomerInvoiceDetailsModalViewController alloc]initWithNibName:@"CustomerInvoiceDetailsModalViewController" bundle:nil];
        cidmvc.animateDelegate = self;
        cidmvc.IUR = self.invoiceHeaderIUR;
        cidmvc.title = @"INVOICE DETAILS";
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cidmvc] autorelease];
        self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:self.globalNavigationController animated:YES completion:nil];
        [cidmvc release];
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
