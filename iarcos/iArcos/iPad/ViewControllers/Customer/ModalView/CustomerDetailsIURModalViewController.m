//
//  CustomerDetailsIURModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 04/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerDetailsIURModalViewController.h"

@implementation CustomerDetailsIURModalViewController
@synthesize delegate;
@synthesize displayList;
@synthesize iurListView;
@synthesize parentContentString;
@synthesize descrTypeCode;
@synthesize parentActualContent;
@synthesize accessoryIndexPath;

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

- (void)dealloc {    
    if (self.displayList != nil) {
        self.displayList = nil;
    }
    if (self.iurListView != nil) {
        self.iurListView = nil;
    }
    if (self.parentContentString != nil) {
        self.parentContentString = nil;
    }    
    if (self.descrTypeCode != nil) {
        self.descrTypeCode = nil;
    }
    if (self.parentActualContent != nil) { self.parentActualContent = nil; }     
    if (self.accessoryIndexPath != nil) { self.accessoryIndexPath = nil; }  
    
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
    
//    NSMutableArray* data = [[[NSMutableArray alloc] initWithObjects:@"test",@"test2",@"O'Connell Street", nil] autorelease];
//    [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrType:self.descrTypeCode];
//    NSLog(@"descrtypecode is %@ ", self.descrTypeCode);
//    NSLog(@"parent index path is %d", self.accessoryIndexPath.row);
    
    self.displayList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:self.descrTypeCode];
//    NSLog(@"the length is %d", [self.displayList count]);
    
    
//    [iurListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.iurListView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"self.parentActualContent is %@, %@", self.parentActualContent, self.parentContentString);
/**    
    for (int i = 0; i < displayList.count; i++) {
        CustomerDetailsIURTableCell* tmpCell = (CustomerDetailsIURTableCell*)[iurListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([tmpCell.detail.text isEqualToString:self.parentContentString]) {
            tmpCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }  
        if ([tmpCell.active isEqualToString:@"0"]) {
            tmpCell.detail.textColor = [UIColor redColor];
        }
    }
*/ 
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
    if (self.displayList != nil) {
        return [self.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerDetailsIURTableCell";
    
    CustomerDetailsIURTableCell *cell=(CustomerDetailsIURTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerDetailsIURTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerDetailsIURTableCell class]] && [[(CustomerDetailsIURTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerDetailsIURTableCell *) nibItem;               
                
                
                UITapGestureRecognizer *doubleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
                doubleTap1.numberOfTapsRequired = 2;
                [cell addGestureRecognizer:doubleTap1];
                [doubleTap1 release];
            }
        }
	}    
    
    // Configure the cell...    
    
    NSDictionary* dataDict = [self.displayList objectAtIndex:indexPath.row];
    cell.detail.text = [ArcosUtils convertNilToEmpty:[dataDict objectForKey:@"Detail"]];
    cell.descrDetailIUR = [dataDict objectForKey:@"DescrDetailIUR"];
    cell.active = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"Active"]];
    if ([cell.detail.text isEqualToString:self.parentContentString]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }  
    if ([cell.active isEqualToString:@"0"]) {
        cell.detail.textColor = [UIColor redColor];
    } else {
        cell.detail.textColor = [UIColor blackColor];
    }
   
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
    for (int i = 0; i < displayList.count; i++) {
        CustomerDetailsIURTableCell* tmpCell = (CustomerDetailsIURTableCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    }
    CustomerDetailsIURTableCell* newCell = (CustomerDetailsIURTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate detailsIURFinishEditing:newCell.detail.text actualContent:newCell.descrDetailIUR WithIndexPath:self.accessoryIndexPath];
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)handleDoubleTap:(id)sender {
//    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
//    CustomerDetailsIURTableCell* cell = (CustomerDetailsIURTableCell*)recognizer.view;
//    [self.delegate detailsIURFinishEditing:cell accessoryButtonTappedForRowWithIndexPath:self.accessoryIndexPath];    
}

@end
