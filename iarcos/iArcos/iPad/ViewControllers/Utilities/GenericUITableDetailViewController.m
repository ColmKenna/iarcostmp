//
//  GenericUITableDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 26/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "GenericUITableDetailViewController.h"

@implementation GenericUITableDetailViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize displayList = _displayList;
@synthesize attrNameList = _attrNameList;
@synthesize attrNameTypeList = _attrNameTypeList;
@synthesize attrDict = _attrDict;
@synthesize recordCellData = _recordCellData;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {    
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.attrNameList != nil) { self.attrNameList = nil; }
    if (self.attrNameTypeList != nil) { self.attrNameTypeList = nil; }    
    if (self.attrDict != nil) { self.attrDict = nil; }
    if (self.recordCellData != nil) { self.recordCellData = nil; }
    
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    [self.navigationItem setLeftBarButtonItem:backButton];     
    
    [backButton release];
    self.tableView.allowsSelection = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.attrNameList != nil) {
        return [self.attrNameList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdGenericUITableDetailTableCell";
    
    GenericUITableDetailTableCell* cell=(GenericUITableDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericUITableDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericUITableDetailTableCell class]] && [[(GenericUITableDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (GenericUITableDetailTableCell *) nibItem;                
            }
        }
	}
    // Configure the cell...    
//    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.attributeName.text = [self.attrNameList objectAtIndex:indexPath.row];
    
//    NSAttributeDescription* attrDesc = [self.attrDict objectForKey:[self.attrNameList objectAtIndex:indexPath.row]];
//    NSString* attrType = [attrDesc attributeValueClassName];
    NSString* attrType = [self.attrNameTypeList objectAtIndex:indexPath.row];
    cell.attributeValue.text = [ArcosUtils convertToString:[self.recordCellData objectForKey:cell.attributeName.text] fieldType:attrType];
    
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

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

@end
