//
//  EmailRecipientTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "EmailRecipientTableViewController.h"

@implementation EmailRecipientTableViewController
@synthesize locationIUR = _locationIUR;
@synthesize requestSource = _requestSource;
@synthesize wholesalerDict = _wholesalerDict;
@synthesize emailRecipientDataManager = _emailRecipientDataManager;
@synthesize recipientDelegate = _recipientDelegate;
@synthesize isSealedBOOLNumber = _isSealedBOOLNumber;

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
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.wholesalerDict != nil) { self.wholesalerDict = nil; }
    if (self.emailRecipientDataManager != nil) { self.emailRecipientDataManager = nil; }
//    if (self.recipientDelegate != nil) { self.recipientDelegate = nil; }    
    if (self.isSealedBOOLNumber != nil) { self.isSealedBOOLNumber = nil; }    
    
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
    self.navigationItem.title = @"Recipient";
    self.emailRecipientDataManager = [[[EmailRecipientDataManager alloc] initWithLocationIUR:self.locationIUR requestSource:self.requestSource] autorelease];
    self.emailRecipientDataManager.emailRecipientBaseDataManager.wholesalerDict = self.wholesalerDict;
    self.emailRecipientDataManager.emailRecipientBaseDataManager.isSealedBOOLNumber = self.isSealedBOOLNumber;
//    NSLog(@"self.emailRecipientDataManager.locationIUR: %@", self.emailRecipientDataManager.locationIUR);
    [self.emailRecipientDataManager.emailRecipientBaseDataManager getAllRecipients];
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.emailRecipientDataManager.sectionTypeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* sectionType = [self.emailRecipientDataManager.sectionTypeList objectAtIndex:section];
    NSMutableArray* tmpDisplayList = [self.emailRecipientDataManager.groupedDataDict objectForKey:sectionType];
    return [tmpDisplayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    */
    
    // Configure the cell...
    /*
    NSString* sectionType = [self.emailRecipientDataManager.sectionTypeList objectAtIndex:indexPath.section];
    NSMutableArray* tmpDisplayList = [self.emailRecipientDataManager.groupedDataDict objectForKey:sectionType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:indexPath.row];
    cell.textLabel.text = [cellData objectForKey:@"Title"];
    */
    
    NSString *CellIdentifier = @"IdEmailRecipientTableCell";
    
    EmailRecipientTableCell *cell=(EmailRecipientTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"EmailRecipientTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[EmailRecipientTableCell class]] && [[(EmailRecipientTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (EmailRecipientTableCell *) nibItem;                
            }
        }
	}
    
    // Configure the cell...
    NSString* sectionType = [self.emailRecipientDataManager.sectionTypeList objectAtIndex:indexPath.section];
    NSMutableArray* tmpDisplayList = [self.emailRecipientDataManager.groupedDataDict objectForKey:sectionType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:indexPath.row];
    cell.myTextLabel.text = [cellData objectForKey:@"Title"];    
    UIImage* anImage = nil;
    NSNumber* recipientType = [cellData objectForKey:@"RecipientType"];
    if ([recipientType intValue] > 0) {
        anImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:recipientType];
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    cell.myImageView.image = anImage;
    [cell configImageView];
//    NSLog(@"%@", cellData);
    
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
    NSString* sectionType = [self.emailRecipientDataManager.sectionTypeList objectAtIndex:indexPath.section];
    NSMutableArray* tmpDisplayList = [self.emailRecipientDataManager.groupedDataDict objectForKey:sectionType];
    NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:indexPath.row];
    [self.recipientDelegate didSelectEmailRecipientRow:cellData];
    
}

@end
