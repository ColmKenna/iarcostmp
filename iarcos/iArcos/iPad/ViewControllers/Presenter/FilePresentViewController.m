//
//  FilePresentViewController.m
//  Arcos
//
//  Created by David Kilmartin on 04/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FilePresentViewController.h"
#import "GlobalSharedClass.h"

@implementation FilePresentViewController
@synthesize groupType;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [myFileReader release];
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    

}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    //landscape width 703 portrait width 768
    NSLog(@"table view width %f",self.tableView.frame.size.width);
    for (GalleryViewCell* anCell in self.gridCells) {
        if (toInterfaceOrientation==UIInterfaceOrientationPortrait||toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown) {
            [anCell rearrangeItemsWithWidth:768];
        }else{
            [anCell rearrangeItemsWithWidth:703];
        }
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.gridCells count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GridViewCell";
//    
//    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell == nil) {
        UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        GalleryViewCell* galleryViewCell=[self.gridCells objectAtIndex:indexPath.row];
        [cell.contentView addSubview:galleryViewCell];
    //}   


    // Configure the cell...
    
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

#pragma mark - delgate
//the master view controller will be hidden
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc {
    
    if (groupPopover==nil) {
        groupPopover=pc;
    }
    
    barButtonItem.title = @"Files";
    self.navigationItem.leftBarButtonItem=barButtonItem;
}
//the master view will be shown again
- (void)splitViewController:(UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)button {
    
    self.navigationItem.leftBarButtonItem=nil;
}

// the master view controller will be displayed in a popover
- (void)splitViewController:(UISplitViewController*)svc
          popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController {

    
}
//icon press event
-(void)gridItemPressed:(id)sender{
    GalleryItem* anItem=(GalleryItem*)sender;
    NSMutableDictionary* aFile=(NSMutableDictionary*)anItem.data;
    NSNumber* IUR=[aFile objectForKey:@"IUR"];
    NSLog(@"File IUR %d is pressed!",[IUR intValue]);
    
    //push file reader to the navigation
    if (myFileReader==nil) {
        myFileReader=[[FileReaderViewController alloc]initWithNibName:@"FileReaderViewController" bundle:nil];
    }
    myFileReader.title=[aFile objectForKey:@"Title"];
    [self.navigationController pushViewController:myFileReader animated:YES];

    //load random file
    NSNumber* aFileTypeIUR=[aFile objectForKey:@"FileTypeIUR"];
    NSString* aFileString;
    switch ([aFileTypeIUR intValue]) {
        case PresenterFileTypeAudio:
            aFileString=[NSString stringWithFormat:@"mp3%d.mp3",[[[GlobalSharedClass shared]randomIntBetween:1 and:2]intValue]];
            break;
        case PresenterFileTypeIamge:
            aFileString=[NSString stringWithFormat:@"jpg%d.jpg",[[[GlobalSharedClass shared]randomIntBetween:1 and:18]intValue]];
            break;
        case PresenterFileTypePdf:
            aFileString=[NSString stringWithFormat:@"pdf%d.pdf",[[[GlobalSharedClass shared]randomIntBetween:1 and:3]intValue]];
            break;
        case PresenterFileTypeTxt:
            aFileString=[NSString stringWithFormat:@"tif%d.tif",[[[GlobalSharedClass shared]randomIntBetween:1 and:2]intValue]];
            break;
        case PresenterFileTypeVideo:
            aFileString=[NSString stringWithFormat:@"mov%d.mov",[[[GlobalSharedClass shared]randomIntBetween:1 and:2]intValue]];
            break;
        case PresenterFileTypeWeb:
            aFileString=[NSString stringWithFormat:@"html%d.html",[[[GlobalSharedClass shared]randomIntBetween:1 and:3]intValue]];
            break;
        case PresenterFileTypeWord:
            aFileString=[NSString stringWithFormat:@"ppt%d.ppt",[[[GlobalSharedClass shared]randomIntBetween:1 and:3]intValue]];
            break;
        default:PresenterFileTypeUnknown:
            aFileString=[NSString stringWithFormat:@"jpg%d.jpg",[[[GlobalSharedClass shared]randomIntBetween:1 and:18]intValue]];
            break;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[FileCommon presenterPath], [aFile objectForKey:@"Name"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myFileReader loadFile:url];
    
}

#pragma mark - addtional functions
-(void)resetResource:(NSMutableArray*)resource WithGrouType:(NSString*)type{
    self.groupType=type;
    
    [self.gridCells removeAllObjects];
    [self.gridItems removeAllObjects];
    self.itemResource=resource;
    
    [self sortIconsWithColumnNumber:5];
    [self.tableView reloadData];
    
}
-(void)resetResource:(NSMutableArray *)resource{
    
}
-(void)sortIconsWithColumnNumber:(int)columns{
    
    //init the gallery view width
    float galleryViewWidth=0;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        galleryViewWidth=768;
    }else{
        galleryViewWidth=703;
    }
    
    int rows=[ArcosUtils convertNSUIntegerToUnsignedInt:[self.itemResource count]]/columns;
    if ([self.itemResource count]/columns>0) {
        rows++;
    }
    if (rows<=0) {
        rows=1;
    }
    
//    NSLog(@"%d items in the grid items %d rows need for the grid items",[self.itemResource count],rows);
    //init the gallery view cells rows and columns
    for (int row=0; row<rows; row++) {
        //a gallery cell
        GalleryViewCell* galleryViewCell=[[[GalleryViewCell alloc]initWithFrame:CGRectMake(0, 0, galleryViewWidth, 110)]autorelease];
        NSLog(@"table view width in the begin %f",self.tableView.frame.size.width);
        
        [galleryViewCell setTarget:self withSelector:@selector(gridItemPressed:)];
                
        //add items to the cell
        for (int column=0; column<columns; column++) {
            int currentItemIndex=row*columns+column;
            //do not let index go over the grid item number
            if (currentItemIndex>=[self.itemResource count]) {
                break;
            }
            NSMutableDictionary* tempItem= [self.itemResource objectAtIndex:currentItemIndex];
            
            UIImage* tempImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[tempItem objectForKey:@"ImageIUR"]];
            NSString* tempDesc=[tempItem objectForKey:@"Title"];
            
            GalleryItem* anItem=[[[GalleryItem alloc]initWithImage:tempImage withDescription:tempDesc]autorelease]; 
            //keep a reference of file
            anItem.data=tempItem;
            
            [galleryViewCell addItem:anItem];
            
        }
        [self.gridCells addObject:galleryViewCell];

    }
    
    //back to the root view
    [self.navigationController popToRootViewControllerAnimated:YES];

}
//split view bar item
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
}
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:NO];
    
}
@end
