//
//  CustomerCallDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerCallDetailViewController.h"
#import "CustomerOrderDetailsModalViewController.h"


@implementation CustomerCallDetailViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize callDetailListView;
@synthesize tableHeader;
@synthesize displayList;
@synthesize IUR;

@synthesize textView;
@synthesize employee;
@synthesize type;
@synthesize contact;
@synthesize date;    

@synthesize memo;
@synthesize orderLabel = _orderLabel;
@synthesize orderTextField = _orderTextField;
@synthesize orderHeaderIUR = _orderHeaderIUR;
@synthesize orderNumber = _orderNumber;
@synthesize screenLoadedFlag = _screenLoadedFlag;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize employeeLabel = _employeeLabel;
@synthesize typeLabel = _typeLabel;
@synthesize contactLabel = _contactLabel;
@synthesize dateLabel = _dateLabel;


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
    if (self.callDetailListView != nil) { self.callDetailListView = nil; }
    if (self.tableHeader != nil) { self.tableHeader = nil; }
    
    if (self.displayList != nil) { self.displayList = nil; }
    if (callGenericServices != nil) {
        [callGenericServices release];
        callGenericServices = nil;
    }
    if (self.IUR != nil) { self.IUR = nil; }    
    
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }    
    if (self.type != nil) { self.type = nil; }
    if (self.contact != nil) { self.contact = nil; }    
    if (self.date != nil) { self.date = nil; }  
    
    if (self.memo != nil) { self.memo = nil; }
    self.orderLabel = nil;
    self.orderTextField = nil;
    self.orderHeaderIUR = nil;
    self.orderNumber = nil;
    self.globalNavigationController = nil;
    
    self.employeeLabel = nil;
    self.typeLabel = nil;
    self.contactLabel = nil;
    self.dateLabel = nil;
    
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
        
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.orderNumber = @"";
    self.orderHeaderIUR = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.callDetailListView != nil) { self.callDetailListView = nil; }
    if (self.tableHeader != nil) { self.tableHeader = nil; }        
    
    if (self.textView != nil) { self.textView = nil; }
    if (self.employee != nil) { self.employee = nil; }    
    if (self.type != nil) { self.type = nil; }
    if (self.contact != nil) { self.contact = nil; }    
    if (self.date != nil) { self.date = nil; }  
    
    if (self.memo != nil) { self.memo = nil; }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.screenLoadedFlag) return;
    self.screenLoadedFlag = YES;
    [callGenericServices getRecord:@"Call" iur:[self.IUR intValue]];
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
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
   
    
    NSString *CellIdentifier = @"IdCustomerCallDetailTableCell";
    
    CustomerCallDetailTableCell *cell=(CustomerCallDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerCallDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerCallDetailTableCell class]] && [[(CustomerCallDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerCallDetailTableCell *) nibItem;
                
                //cell.delegate=self;                
            }
        }
	}
    
    
    
    
    // Configure the cell...
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.description.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field4]]];
    cell.details.text = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field3]]];
    

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
        
        self.textView.text = textViewString;
        [textViewString release];
        
        self.employee.text = [replyResult Field8];
        self.type.text = [replyResult Field6];
        self.contact.text = [replyResult Field13];        
//        self.date.text = [ArcosUtils convertDatetimeToDate:[replyResult Field2]];
        self.date.text = [replyResult Field2];

        self.memo.text = [replyResult Field11];
        self.orderTextField.text = [replyResult Field15];
        self.orderNumber = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field15]]]];
        self.orderHeaderIUR = [ArcosUtils trim:[ArcosUtils convertToString:[ArcosUtils convertNilToEmpty:[replyResult Field16]]]];
        if (![self.orderNumber isEqualToString:@""] && ![self.orderNumber isEqualToString:@"0"]) {
            self.orderLabel.hidden = NO;
            self.orderTextField.hidden = NO;
            self.orderTextField.textColor = [UIColor blueColor];
        } else {
            self.orderLabel.hidden = YES;
            self.orderTextField.hidden = YES;
            self.orderTextField.textColor = [UIColor blackColor];
        }
        
        self.displayList = replyResult.SubObjects;
        [self.callDetailListView reloadData];
        
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
