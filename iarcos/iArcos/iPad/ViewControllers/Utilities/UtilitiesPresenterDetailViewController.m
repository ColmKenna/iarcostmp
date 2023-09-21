//
//  UtilitiesPresenterDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesPresenterDetailViewController.h"
#include <CommonCrypto/CommonDigest.h>
#import "ArcosUtils.h"

@interface UtilitiesPresenterDetailViewController()

- (NSString*)fileMD5:(NSString*)path;

@end

@implementation UtilitiesPresenterDetailViewController
@synthesize presenterFileList = _presenterFileList;
@synthesize tableHeader;
@synthesize displayList = _displayList;
@synthesize globalIndexPath = _globalIndexPath;
@synthesize fileMD5Calculator = _fileMD5Calculator;

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
    self.fileMD5Calculator = nil;
    
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
    
    UIBarButtonItem *deleteAllButton = [[UIBarButtonItem alloc] initWithTitle:@"DeleteAll" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllPressed:)];    
    [self.navigationItem setRightBarButtonItem:deleteAllButton];         
    [deleteAllButton release];   
//    [self createDisplayList];
    self.title = @"Resources";
    self.fileMD5Calculator = [[[FileMD5Calculator alloc] init] autorelease];
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
    [self createDisplayList];
    [self.tableView reloadData];
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
    NSString *CellIdentifier = @"IdUtilitiesPresenterDetailTableCell";
    
    UtilitiesPresenterDetailTableCell* cell=(UtilitiesPresenterDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesPresenterDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesPresenterDetailTableCell class]] && [[(UtilitiesPresenterDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (UtilitiesPresenterDetailTableCell *) nibItem;                
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
////    [actionSheet showFromRect:[ArcosUtils fromRect4ActionSheet:[self.tableView cellForRowAtIndexPath:indexPath]] inView:self.view animated:YES];
//    [actionSheet release];
    void (^lBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self.tableView deselectRowAtIndexPath:self.globalIndexPath animated:YES];
    };
    void (^rBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error = nil;
        NSMutableDictionary* cellData = [self.displayList objectAtIndex:self.globalIndexPath.row];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@",[FileCommon presenterPath], [cellData objectForKey:@"fileName"]];
        NSLog(@"the deleted file path is %@", filePath);
        [fileManager removeItemAtPath:filePath error:&error];
        [self createDisplayList];
        [self.tableView reloadData];
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure to delete the file?" title:@"" target:self lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:lBtnActionHandler rBtnHandler:rBtnActionHandler];
}

//action sheet delegate
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
//    NSLog(@"tag is %d", [actionSheet tag]);
    
    switch (buttonIndex) {
        case 1:{//cancel button do nothing
            if (actionSheet.tag != 9) {
                [self.tableView deselectRowAtIndexPath:self.globalIndexPath animated:YES];
            }            
        }
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
//        NSLog(@"filePath is %@", filePath);
        NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
        NSNumber* fileSize = [fileAttributes objectForKey:@"NSFileSize"];
        [cellData setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:fileSize useSiPrefixes:YES useSiMultiplier:NO] forKey:@"fileSize"];
//        NSData* fileNSData = [[NSData alloc] initWithContentsOfFile:filePath];
//        NSString* md5 = [fileNSData MD5];
//        [cellData setObject:md5 forKey:@"md5"];
//        [fileNSData release];
        NSString* md5 = [self.fileMD5Calculator retrieveFileMD5WithFilePath:filePath];
        [cellData setObject:md5 forKey:@"md5"];
        [self.displayList addObject:cellData];
    }    
}

- (NSString*)fileMD5:(NSString*)path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if(handle == nil) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done) {
        NSAutoreleasePool * pool = [NSAutoreleasePool new];
        NSData* fileData = [handle readDataOfLength:4096];
        CC_MD5_Update(&md5, [fileData bytes], [ArcosUtils convertNSUIntegerToUnsignedInt:[fileData length]]);
        if( [fileData length] == 0 ) done = YES;
        [pool drain];
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

- (void)deleteAllPressed:(id)sender {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete all these files?"
//                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
//                                                    otherButtonTitles:@"Cancel",nil];
//
//    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    actionSheet.tag = 9;
//    [actionSheet showInView:self.view];
////    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//    [actionSheet release];
    void (^lBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    void (^rBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [FileCommon removeAllFileUnderPresenterPath];
        [self createDisplayList];
        [self.tableView reloadData];
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure to delete all these files?" title:@"" target:self lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:lBtnActionHandler rBtnHandler:rBtnActionHandler];
}
@end
