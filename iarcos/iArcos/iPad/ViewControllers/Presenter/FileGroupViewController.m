//
//  FileGroupViewController.m
//  Arcos
//
//  Created by David Kilmartin on 04/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FileGroupViewController.h"
#import "ArcosCoreData.h"
#import "PresenterGridListViewController.h"



@implementation FileGroupViewController
@synthesize popoverController, splitViewController, rootPopoverButtonItem;

@synthesize myGroups;
@synthesize currentGroupType;
@synthesize groupName;
@synthesize sortKeys;
@synthesize groupSelections;
@synthesize myFilePresentViewController;
@synthesize resource;
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
    [ myGroups release];
    [ groupName release];
    [ sortKeys release];
    [ groupSelections release];
    [ myFilePresentViewController release];
    
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
    [self updateBarButtonItems];
    
    //self.myGroups=[[ArcosCoreData sharedArcosCoreData]productsWithPresentDoc];
    self.myGroups=[[ArcosCoreData sharedArcosCoreData]productL5Group];
    self.currentGroupType=@"L5GroupType";
    [self sortGroups];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   
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
    if (self.myFilePresentViewController != nil) {
        [self.myFilePresentViewController.navigationController popToRootViewControllerAnimated:NO];
    }
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.groupName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString* aGroupName=[self.groupName objectAtIndex: indexPath.row];
    NSMutableDictionary* aProduct=[self.myGroups objectForKey:aGroupName];
    cell.textLabel.text = [aProduct objectForKey:@"description"];
    
    //testing images
    UIImage* productThumb;
    
    if (![aGroupName isEqualToString:@"All"]) {
        productThumb=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[aProduct objectForKey:@"ImageIUR"]];
        NSLog(@"image iur for group %d",[[aProduct objectForKey:@"ImageIUR"]intValue]);
    }
    if (productThumb==nil) {//default image
        productThumb=[UIImage imageNamed:@"DefaultListImage"];
    }
    
    cell.imageView.image=productThumb;
    
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

    NSString* aGroupName=[self.groupName objectAtIndex:indexPath.row];
    NSMutableDictionary* aGroup=[self.myGroups objectForKey:aGroupName];
    NSNumber* groupIUR=[aGroup objectForKey:@"IUR"];
    NSString* groupType=[aGroup objectForKey:@"GroupType"];
    NSMutableArray* iconResurces;
    
    //load the resurce depend on the group type 
    if ([groupType isEqualToString:@"FileType"]) {
        iconResurces=[[ArcosCoreData sharedArcosCoreData]filesWithTypeIUR:groupIUR withResultType:0];
    }
    if ([groupType isEqualToString:@"ProductType"]) {
        iconResurces=[[ArcosCoreData sharedArcosCoreData]filesWithProductIUR:groupIUR withResultType:0];
    }
    if ([groupType isEqualToString:@"L5GroupType"]) {
        iconResurces=[[ArcosCoreData sharedArcosCoreData]filesWithGroupType:[aGroup objectForKey:@"groupTypeCode"]];
    }
    self.resource=iconResurces;
    
    [self resetDetailviewContent];
}
#pragma mark - Split view controller delegate

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Documents";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    
    if ([navigationController.viewControllers count]>1) {
        return;
    }
    //don't do anything when we are not on the root view
    UIViewController <PresenterDetailViewProtocol> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    //don't do anything when we are not on the root view
    if ([navigationController.viewControllers count]>1) {
        return;
    }
    
    UIViewController <PresenterDetailViewProtocol> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}
//segment buttons action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex) {
        case 0:
            //[self loadProductList];
            [self loadL5GroupList];
            //clear the detail View
            [self.myFilePresentViewController resetResource:[NSMutableArray array] WithGrouType:@""];
            break;
        case 1:
            [self loadFileTypeList];
            //clear the detail View
            [self.myFilePresentViewController resetResource:[NSMutableArray array] WithGrouType:@""];
            break;
            
        default:
            break;
    }
//    NSLog(@"segment %d touched!!",segment.selectedSegmentIndex);

}
-(void)resetDetailviewContent{
    [myFilePresentViewController resetResource:self.resource WithGrouType:self.currentGroupType];
    
    //show the popover button
    if (self.rootPopoverButtonItem!=nil) {
        [myFilePresentViewController showRootPopoverButtonItem:self.rootPopoverButtonItem];
    }
}
-(void)loadL5GroupList{
    self.currentGroupType=@"L5GroupType";
    self.myGroups=[[ArcosCoreData sharedArcosCoreData]productL5Group];
    [self sortGroups];
    [self.tableView reloadData];
}
-(void)loadProductList{
    self.currentGroupType=@"ProductType";
    self.myGroups=[[ArcosCoreData sharedArcosCoreData]productsWithPresentDoc];
    [self sortGroups];
    [self.tableView reloadData];
}
-(void)loadFileTypeList{
    self.currentGroupType=@"FileType";
    self.myGroups=[[ArcosCoreData sharedArcosCoreData]fileTypes];
    [self sortGroups];
    [self.tableView reloadData];

}
//addtional funcitons
-(void)sortGroups{
    //release the old selections
    if (groupSelections!=nil) {
        [groupSelections removeAllObjects];
    }
    
    NSArray* tempGroupNameArray=[self.myGroups allKeys];
    
    self.groupName=[[[tempGroupNameArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy]autorelease];
    
    NSMutableArray* tempMutableArray=[[NSMutableArray alloc]init];
    
    NSString* currentChar;
    if ([self.myGroups count]>0) {
        currentChar=[[self.groupName objectAtIndex:0]substringToIndex:1];
    }else{
        currentChar=@"";
    }
    
    //put the group in the selections
    for (NSString* name in self.groupName ) {
        //NSLog(@"name --%@",name);
        if ([currentChar isEqualToString:[name substringToIndex:1]]) {
            [tempMutableArray addObject:name];
        }else{
            [groupSelections setObject:tempMutableArray forKey:currentChar];
            [tempMutableArray release];
            currentChar=[name substringToIndex:1];
            tempMutableArray=[[NSMutableArray alloc]init];
            [tempMutableArray addObject:name];
        }
        
    }
    if (![currentChar isEqualToString:@""]) {
        [groupSelections setObject:tempMutableArray forKey:currentChar];
    }
    self.sortKeys=[[groupSelections allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    
    for (NSString* akey in self.sortKeys) {
        NSLog(@"sort key %@",akey);
    }

}


-(void)updateBarButtonItems {
    NSArray *statusItems = [NSArray arrayWithObjects:@"Product",@"Type",nil];
    UISegmentedControl* segmentBut = [[UISegmentedControl alloc] initWithItems:statusItems];
    
    [segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentBut.frame = CGRectMake(0, 0, 250, 30);
//    segmentBut.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentBut.momentary = YES;
    
    self.navigationItem.titleView = segmentBut;
    [segmentBut release];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateBarButtonItems];
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}    

@end
