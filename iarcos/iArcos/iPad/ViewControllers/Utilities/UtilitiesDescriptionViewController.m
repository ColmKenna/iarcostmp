//
//  UtilitiesDescriptionViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesDescriptionViewController.h"

@implementation UtilitiesDescriptionViewController
@synthesize displayList = _displayList;
@synthesize codeLabel = _codeLabel;
@synthesize detailLabel = _detailLabel;
@synthesize tableHeader;
@synthesize testButton = _testButton;
@synthesize numberButton = _numberButton;
@synthesize stopButton = _stopButton;
@synthesize testTimer = _testTimer;
@synthesize currentNumber = _currentNumber;

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
    self.codeLabel = nil;
    self.detailLabel = nil;
    if (self.tableHeader != nil) {
        self.tableHeader = nil;
    }
    if (self.testButton != nil) { self.testButton = nil; }        
    if (self.numberButton != nil) { self.numberButton = nil; }
    if (self.stopButton != nil) { self.stopButton = nil; }
    if (self.testTimer != nil) {
        self.testTimer = nil;
    }
    
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
    self.displayList = [[ArcosCoreData sharedArcosCoreData] allDescrType];
    self.title = @"Description";
//    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPressed:)];
//    [self.navigationItem setRightBarButtonItem:addButton];
//    [addButton release];
    /*
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    self.testButton = [[[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStyleBordered target:self action:@selector(testPressed)] autorelease];
    self.numberButton = [[[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleBordered target:self action:@selector(addPressed:)] autorelease];
    self.stopButton = [[[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleBordered target:self action:@selector(stopPressed)] autorelease];
    [rightButtonList addObject:self.testButton];
    [rightButtonList addObject:self.stopButton];
    [rightButtonList addObject:self.numberButton];
    
//    [self.navigationItem setRightBarButtonItem:self.testButton];         
    [self.navigationItem setRightBarButtonItems:rightButtonList];
     */
    self.currentNumber = 0;
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
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
    }
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
    return tableHeader;
    
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
    if (self.displayList != nil) {
        return [self.displayList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdUtilitiesDescriptionTableCell";
    
    UtilitiesDescriptionTableCell* cell=(UtilitiesDescriptionTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesDescriptionTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesDescriptionTableCell class]] && [[(UtilitiesDescriptionTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (UtilitiesDescriptionTableCell *) nibItem;                
            }
        }
	}
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    [cell configCellData:cellData];
    
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
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    UtilitiesDescriptionDetailViewController* uddvc = [[UtilitiesDescriptionDetailViewController alloc] initWithNibName:@"UtilitiesDescriptionDetailViewController" bundle:nil];
    uddvc.navigationDelegate = self;
    uddvc.descrTypeCode = [cellData objectForKey:@"DescrTypeCode"];
    uddvc.title = [cellData objectForKey:@"Details"];
    [self.navigationController pushViewController:uddvc animated:YES];
    
    [uddvc release];
}

-(void)addPressed:(id)sender {
    NSLog(@"addPressed");
    ChartTestViewController* ctvc = [[ChartTestViewController alloc] init];
    [self.navigationController pushViewController:ctvc animated:YES];
    [ctvc release];
}

- (void)showNavigationBar {
    [self.navigationDelegate showNavigationBar];
}

- (void)hideNavigationBar {
    [self.navigationDelegate hideNavigationBar];
}

-(void)testPressed {
//    self.numberButton.title = @"1";
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPageNumberList) userInfo:nil repeats:YES];
}

- (void)checkPageNumberList {
    self.numberButton.title = [NSString stringWithFormat:@"%d", self.currentNumber];
    self.currentNumber++;
}

- (void)stopPressed {
    [self.testTimer invalidate];
    self.testTimer = nil;
}

@end
