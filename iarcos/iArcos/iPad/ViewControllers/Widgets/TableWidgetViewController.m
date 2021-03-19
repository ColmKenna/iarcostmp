//
//  TableWidgetViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "TableWidgetViewController.h"
#import "ArcosCoreData.h"


@implementation TableWidgetViewController
@synthesize delegate = _delegate;
@synthesize tableWidgetRequestSource = _tableWidgetRequestSource;
@synthesize displayList = _displayList;
@synthesize tableNavigationBarTitle = _tableNavigationBarTitle;
@synthesize parentContentString = _parentContentString;
@synthesize tableNavigationBar;
@synthesize tableNavigationItem;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
@synthesize emailPopover = _emailPopover;
@synthesize emailButton = _emailButton;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize myTableView = _myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString {
    [self initWithNibName:@"TableWidgetViewController" bundle:nil];
    self.displayList = aDataList;
    self.tableNavigationBarTitle = aTitle;
    self.parentContentString = aParentContentString;
    //any data source for the widget
    if (self.displayList == nil || [self.displayList count] <= 0) {
        anyDataSource = NO;
    }else{
        anyDataSource = YES;
    }
    return self;
}

- (id)initWithDataList:(NSMutableArray*)aDataList withTitle:(NSString*)aTitle withParentContentString:(NSString*)aParentContentString requestSource:(TableWidgetRequestSource)aTableWidgetRequestSource {
    self.tableWidgetRequestSource = aTableWidgetRequestSource;
    return [self initWithDataList:aDataList withTitle:aTitle withParentContentString:aParentContentString];
}

- (void)dealloc
{
//    if (self.delegate != nil) { self.delegate = nil; }
    if (self.displayList != nil) { self.displayList = nil; }
    if (self.tableNavigationBarTitle != nil) { self.tableNavigationBarTitle = nil; }  
    if (self.parentContentString != nil) { self.parentContentString = nil; }
    if (self.tableNavigationBar != nil) { self.tableNavigationBar = nil; }    
    if (self.tableNavigationItem != nil) { self.tableNavigationItem = nil; }
    if (self.emailRecipientTableViewController != nil) { self.emailRecipientTableViewController = nil; }
    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailButton != nil) { self.emailButton = nil; }
    self.currentIndexPath = nil;
    self.myTableView = nil;
    
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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    [self.tableNavigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    if (self.tableWidgetRequestSource == TableWidgetRequestSourcePresenter) {
        self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
        [self.tableNavigationItem setRightBarButtonItem:self.emailButton];
    }
    [self.tableNavigationItem setTitle:self.tableNavigationBarTitle];
}

- (void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        self.emailPopover = nil;
        return;
    }
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    self.emailRecipientTableViewController.requestSource = EmailRequestSourcePresenter;
    self.emailRecipientTableViewController.recipientDelegate = self;
    UINavigationController* emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:emailNavigationController] autorelease];
    self.emailPopover.delegate = self;
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
}

- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    [self.emailPopover dismissPopoverAnimated:YES];
    NSMutableDictionary* cellDict = [self.displayList objectAtIndex:self.currentIndexPath.row];
    [self.delegate emailPressedFromTablePopoverRow:cellData groupName:[cellDict objectForKey:@"Title"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    */
    NSString *CellIdentifier = @"IdGenericGroupedImageTableCell";
    
    GenericGroupedImageTableCell *cell=(GenericGroupedImageTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericGroupedImageTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericGroupedImageTableCell class]] && [[(GenericGroupedImageTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (GenericGroupedImageTableCell *) nibItem;                
            }
        }
	}

    // Configure the cell...
    NSMutableDictionary* cellDict = [self.displayList objectAtIndex:indexPath.row];
    cell.myTextLabel.text = [cellDict objectForKey:@"Title"];
    if ([cell.myTextLabel.text isEqualToString:self.parentContentString]) {
        self.currentIndexPath = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([cellDict objectForKey:@"Active"] != nil && 
        [[cellDict objectForKey:@"Active"] intValue] == 0) {
        cell.myTextLabel.textColor = [UIColor redColor];
    } else {
        cell.myTextLabel.textColor = [UIColor blackColor];
    }    
    NSNumber* imageIur = [cellDict objectForKey:@"ImageIUR"];
    if (imageIur != nil) {
        UIImage* anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
        if (anImage == nil) {
            anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
        }
        cell.myImageView.image = anImage;
    } else {
        cell.myImageView.image = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    NSString* imageFileName = [cellDict objectForKey:@"ImageFileName"];
    if (imageFileName != nil) {
        cell.myImageView.image = [UIImage imageNamed:imageFileName];
    }
    [cell configImageView];
    return cell;
}

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
    if ([cellData objectForKey:@"Active"] != nil &&
        [[cellData objectForKey:@"Active"] intValue] == 0) {
        [ArcosUtils showDialogBox:@"You cannot assign In-Active Items" title:@"" delegate:nil target:self tag:0 handler:nil];
        return;
    }
    [self.delegate operationDone:cellData];
}

- (void)cancelPressed {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        self.emailPopover = nil;
    }
    [self.delegate dismissPopoverController];
}

@end
