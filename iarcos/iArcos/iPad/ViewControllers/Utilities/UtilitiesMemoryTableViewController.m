//
//  UtilitiesMemoryTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMemoryTableViewController.h"

@interface UtilitiesMemoryTableViewController ()
- (NSMutableDictionary*)createMemoryDict:(NSString*)aMemoryType memorySize:(NSString*)aMemorySize;

@end

@implementation UtilitiesMemoryTableViewController
@synthesize displayList = _displayList;
@synthesize arcosMemoryUtils = _arcosMemoryUtils;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.arcosMemoryUtils = [[[ArcosMemoryUtils alloc] init] autorelease];
    self.title = @"Memory";
}

- (void)dealloc {
    self.displayList = nil;
    self.arcosMemoryUtils = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.displayList = [NSMutableArray arrayWithCapacity:5];
    NSMutableDictionary* memoryDict = [self.arcosMemoryUtils retrieveSystemMemory];
    [self.displayList addObject:[self createMemoryDict:@"Free" memorySize:[memoryDict objectForKey:@"Free"]]];
    [self.displayList addObject:[self createMemoryDict:@"Active" memorySize:[memoryDict objectForKey:@"Active"]]];
    [self.displayList addObject:[self createMemoryDict:@"Inactive" memorySize:[memoryDict objectForKey:@"Inactive"]]];
    [self.displayList addObject:[self createMemoryDict:@"Wired" memorySize:[memoryDict objectForKey:@"Wired"]]];
    [self.displayList addObject:[self createMemoryDict:@"Total" memorySize:[memoryDict objectForKey:@"Total"]]];
}

- (NSMutableDictionary*)createMemoryDict:(NSString*)aMemoryType memorySize:(NSString*)aMemorySize {
    NSMutableDictionary* memoryDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [memoryDict setObject:aMemoryType forKey:@"MemoryType"];
    [memoryDict setObject:[ArcosUtils convertNilToEmpty:aMemorySize] forKey:@"MemorySize"];
    return memoryDict;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdUtilitiesMemoryTableCell";
    
    UtilitiesMemoryTableCell* cell=(UtilitiesMemoryTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesMemoryTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesMemoryTableCell class]] && [[(UtilitiesMemoryTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (UtilitiesMemoryTableCell *) nibItem;
            }
        }
    }
    // Configure the cell...
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.memoryType.text = [cellData objectForKey:@"MemoryType"];
    cell.memorySize.text = [cellData objectForKey:@"MemorySize"];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
