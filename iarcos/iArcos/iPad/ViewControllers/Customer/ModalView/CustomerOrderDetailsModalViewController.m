//
//  CustomerOrderDetailsModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerOrderDetailsModalViewController.h"


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

@synthesize orderIUR;


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
    [callGenericServices getRecord:@"Order" iur:[self.orderIUR intValue]];    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
        self.deliveryStatus.text = [replyResult Field24];
        self.instructions.text = [replyResult Field25];
//        self.instructions2.text = [replyResult Field26];
        if ([[ArcosUtils convertNilToEmpty:[replyResult Field26]] isEqualToString:@""]) {
            self.memo.text = [replyResult Field28];
        } else {
            self.memo.text = [NSString stringWithFormat:@"%@ | %@", [replyResult Field26], [replyResult Field28]];
        }        
        self.value.text = [NSString stringWithFormat:@"%.2f", [[replyResult Field27] floatValue]];
        self.displayList = replyResult.SubObjects;
        [self.orderDetailListView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        
    }
//    [activityIndicator stopAnimating];    
}


@end
