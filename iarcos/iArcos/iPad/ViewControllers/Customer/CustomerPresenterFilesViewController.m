//
//  CustomerPresenterFilesViewController.m
//  Arcos
//
//  Created by David Kilmartin on 08/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerPresenterFilesViewController.h"

@implementation CustomerPresenterFilesViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize presenterFileList = _presenterFileList;
@synthesize tableHeader;
@synthesize displayList = _displayList;
@synthesize globalIndexPath = _globalIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.presenterFileList != nil) {
        self.presenterFileList = nil;
    }
    if (self.tableHeader != nil) {
        self.tableHeader = nil;
    }
    if (self.displayList != nil) {
        self.displayList = nil;
    }
    if (self.globalIndexPath != nil) {
        self.globalIndexPath = nil;
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
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];         
    [closeButton release];
    
    UIBarButtonItem *deleteAllButton = [[UIBarButtonItem alloc] initWithTitle:@"DeleteAll" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllPressed:)];    
    [self.navigationItem setRightBarButtonItem:deleteAllButton];         
    [deleteAllButton release];
    
    [self createDisplayList];
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
/**    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
*/
    NSString *CellIdentifier = @"IdCustomerPresenterFilesTableCell";
    
    CustomerPresenterFilesTableCell *cell=(CustomerPresenterFilesTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerPresenterFilesTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerPresenterFilesTableCell class]] && [[(CustomerPresenterFilesTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerPresenterFilesTableCell *) nibItem;
                
                //cell.delegate=self;                
                                
            }
        }
	}   
    // Configure the cell...
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.fileName.text = [cellData objectForKey:@"fileName"];
    cell.fileSize.text = [cellData objectForKey:@"fileSize"];
    cell.md5.text = [cellData objectForKey:@"md5"];
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
    self.globalIndexPath = indexPath;
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete the file?"
//                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
//                                                    otherButtonTitles:@"Cancel",nil];
//
//    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}

-(void)closePressed:(id)sender {
    NSLog(@"closePressed is pressed");
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

//action sheet delegate
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
//    NSLog(@"tag is %d", [actionSheet tag]);
    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0:{//ok button remove current order line            
            if (actionSheet.tag == 9) {
                [FileCommon removeAllFileUnderPresenterPath];
            } else {
                NSFileManager* fileManager = [NSFileManager defaultManager];
                NSError* error = nil;
                NSMutableDictionary* cellData = [self.displayList objectAtIndex:self.globalIndexPath.row];
                NSString* filePath = [NSString stringWithFormat:@"%@/%@",[FileCommon presenterPath], [cellData objectForKey:@"fileName"]];
                NSLog(@"the deleted file path is %@", filePath);
                [fileManager removeItemAtPath:filePath error:&error];                
            }
            [self createDisplayList];
            [self.tableView reloadData];
        }            
            break;   
        default:
            break;
    }
}
*/
- (void)createDisplayList {
    self.displayList = [NSMutableArray array];
    NSString* presenterFilePath = [FileCommon presenterPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    self.presenterFileList = [fileManager contentsOfDirectoryAtPath: presenterFilePath error:&error];
    for (int i = 0; i < [self.presenterFileList count]; i++) {
        NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
        NSString* fileName = [self.presenterFileList objectAtIndex:i];
        [cellData setObject:fileName forKey:@"fileName"];
        NSString* filePath = [presenterFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
        NSLog(@"filePath is %@", filePath);
        NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        NSNumber* fileSize = [fileAttributes objectForKey:@"NSFileSize"];
        [cellData setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:fileSize useSiPrefixes:YES useSiMultiplier:NO] forKey:@"fileSize"];
        NSData* fileNSData = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
        NSString* md5 = [fileNSData MD5]; 
        [cellData setObject:md5 forKey:@"md5"];
        [self.displayList addObject:cellData];
    }    
}

- (void)deleteAllPressed:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete all these files?"
//                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
//                                                    otherButtonTitles:@"Cancel",nil];
//    
//    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    actionSheet.tag = 9;
//    [actionSheet showInView:self.view];
//    [actionSheet release];
}
@end
