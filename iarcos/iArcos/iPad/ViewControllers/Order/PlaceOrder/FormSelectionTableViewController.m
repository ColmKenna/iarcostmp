//
//  FormSelectionTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FormSelectionTableViewController.h"
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"
#import "GlobalSharedClass.h"

@implementation FormSelectionTableViewController
@synthesize formIUR;
@synthesize tableData;
@synthesize myGroups;
@synthesize groupName;
@synthesize sortKeys;
@synthesize groupSelections;
@synthesize headerView;
@synthesize frtvc;
@synthesize formName;
@synthesize orderTableViewHeader;
@synthesize mySelecitons;
@synthesize selectedIndexPath;

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
    if (self.mySelecitons != nil) { self.mySelecitons = nil; }    
    if (self.selectedIndexPath != nil) { self.selectedIndexPath = nil; }        
    
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
    //self.myGroups=[[ArcosCoreData sharedArcosCoreData]selectionWithOrderIUR:self.formIUR];
    //[self sortGroups];
    self.mySelecitons=[[ArcosCoreData sharedArcosCoreData]selectionWithFormIUR:self.formIUR];
    //add all selection
    //add all selection option
    NSMutableDictionary* allDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"All",@"Details", [NSNumber numberWithInt:-1],@"SequenceDivider", nil];
    
    [self.mySelecitons insertObject:allDict atIndex:0];
    
    //insert the selections if there is no selection in the order share class
    if (![[OrderSharedClass sharedOrderSharedClass]anySelections]) {
        for (int i=0; i<[self.mySelecitons count]; i++) {
            NSMutableDictionary* selection=[self.mySelecitons objectAtIndex:i];
            NSString* name=[selection objectForKey:@"Details"];
            [[OrderSharedClass sharedOrderSharedClass] insertSelection:name];
        }
        [[OrderSharedClass sharedOrderSharedClass] insertSelection:@"All"];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.orderTableViewHeader=[[OrderTableViewHeader alloc]initWithNibName:@"OrderTableViewHeader" bundle:nil];
    //customer name and address
    self.orderTableViewHeader.name=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
    self.orderTableViewHeader.address=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    self.orderTableViewHeader.phone=[[OrderSharedClass sharedOrderSharedClass]currentCustomerPhoneNumber];
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
    
    //customer name and address
    self.orderTableViewHeader.name=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
    self.orderTableViewHeader.address=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    self.orderTableViewHeader.phone=[[OrderSharedClass sharedOrderSharedClass]currentCustomerPhoneNumber];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //back to root if customer changed
    if(![[OrderSharedClass sharedOrderSharedClass]anyForm]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.frtvc clearData];
    }
    
    //default rows
//    NSString* name=[self.groupName objectAtIndex:0];
//    NSNumber* anIUR=[self.myGroups objectForKey:name];
//    NSLog(@"seletction name %@ with data %@",name,anIUR);
//    self.frtvc.dividerName=name;
//    self.frtvc.dividerIUR=anIUR;
//    [self.frtvc resetDataWithDividerIUR:anIUR withDividerName:name];
//    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR=anIUR;
//    self.selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];

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
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    // custom view for header. will be adjusted to default or specified header height
    return self.orderTableViewHeader.view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 132;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.mySelecitons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //NSString* aGroupName=[self.groupName objectAtIndex: indexPath.row];
    NSMutableDictionary* selection=[self.mySelecitons objectAtIndex:indexPath.row];
    NSString* name=[selection objectForKey:@"Details"];
    cell.textLabel.text = name;
    
    //highlight the selected cell
    if (self.selectedIndexPath!=nil) {
        if([self.selectedIndexPath compare:indexPath]==NSOrderedSame){
            cell.textLabel.textColor=[UIColor redColor];
        }else{
            cell.textLabel.textColor=[UIColor blackColor];
            
        }
    }
    
    //don't need the selection color
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSMutableDictionary* selection=[self.mySelecitons objectAtIndex:indexPath.row];
    NSNumber* anIUR=[selection objectForKey:@"SequenceDivider"];
    NSString* name=[selection objectForKey:@"Details"];
    NSLog(@"seletction name %@ with data %@",name,selection);
    [self.frtvc resetDataWithDividerIUR:anIUR withDividerName:name locationIUR:nil];
    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR=anIUR;
    //[OrderSharedClass sharedOrderSharedClass].currentFormIUR=[selection objectForKey:@"FormIUR"];
    
    //highlight the selected selection
    UITableViewCell* cell=[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    cell.textLabel.textColor=[UIColor blackColor];
    
    cell=[self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor redColor];
    
    self.selectedIndexPath=indexPath;
    
}


//addtional funcitons
-(void)sortGroups{
    //release the old selections
    if (groupSelections!=nil) {
        [groupSelections removeAllObjects];
        [groupSelections release];
    }
    //reinitialize the customer sections
    groupSelections=[[NSMutableDictionary alloc]init];
    
    //a temp sorted group name
    NSMutableArray* sortedGroupNameArray=nil;
    sortedGroupNameArray=[[[[self.myGroups allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy]autorelease];
    
    //reinitialize the sort key
    if (self.sortKeys ==nil) {
        self.sortKeys=[[[NSMutableArray alloc]init]autorelease];
    }else{
        [self.sortKeys removeAllObjects];
    }
    
    
    //get the first char of the  list
    NSString* currentChar=@"";
    if ([sortedGroupNameArray count]>0) {
        NSString* name=[sortedGroupNameArray objectAtIndex:0];
        currentChar =[name substringToIndex:1];
        //add first Char
        if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
            [self.sortKeys addObject:currentChar]; 
        }
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=0;
    
    //start sorting the customer in to the sections
    for (int i=0; i<[sortedGroupNameArray count]; i++) {
        //sotring the name into the array
        NSString* name=[sortedGroupNameArray objectAtIndex:i];
        if (name==nil||[name isEqualToString:@""]) {
            name=@"Unknown Group";
        }
        
        //sorting
        length++;
        if ([currentChar isEqualToString:[name substringToIndex:1]]) {
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [groupSelections setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=i+1;
            length=0;
            //get the current char
            currentChar=[name substringToIndex:1];
            //add char to sort key
            if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
                [self.sortKeys addObject:currentChar]; 
            }
        }
    }
    
    //assgin the customer names
    self.groupName=sortedGroupNameArray;
    
    NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [groupSelections setObject:tempArray forKey:currentChar];
    }
    
    [tempArray release];
    //add char to sort key
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [self.sortKeys addObject:currentChar]; 
    }
    
    //add all selection option
    [groupName insertObject:@"All" atIndex:0];
    [myGroups setObject:[NSNumber numberWithInt:-1] forKey:@"All"];
    
    for (NSString* akey in self.sortKeys) {
        NSLog(@"sort key %@",akey);
    }
    
}

//selecting the default selection
-(void)selectDefaultSelection{
    //default rows
    NSString* name=[self.groupName objectAtIndex:0];
    NSNumber* anIUR=[self.myGroups objectForKey:name];
    if ([anIUR intValue]<=0) {
        anIUR=[NSNumber numberWithInt:-1];
        name=@"All";
        [[OrderSharedClass sharedOrderSharedClass] insertSelection:@"All"];

    }
    NSLog(@"seletction name %@ with data %@",name,anIUR);
    self.frtvc.dividerName=name;
    self.frtvc.dividerIUR=anIUR;
    [self.frtvc resetDataWithDividerIUR:anIUR withDividerName:name locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR=anIUR;
    self.selectedIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];    
}
  
@end
