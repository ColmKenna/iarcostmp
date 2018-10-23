//
//  PresenterGridListViewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PresenterGridListViewController.h"
#import "FileCommon.h"
@interface PresenterGridListViewController (Private)
-(void)sortResource;
@end

@implementation PresenterGridListViewController
@synthesize sortedResource;
@synthesize theResource;
@synthesize groupType;

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

    
    self.tableView.allowsSelection=NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
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
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)||orientation==0) {
        if (myBarButtonItem!=nil&&self.navigationItem.leftBarButtonItem==nil) {
            self.navigationItem.leftBarButtonItem=myBarButtonItem;
        }
    }else{
        if (self.navigationItem.leftBarButtonItem!=nil) {
            self.navigationItem.leftBarButtonItem=nil;
        }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.sortedResource count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"PresenterGridCell";
    
    PresenterGridCell *cell=(PresenterGridCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"PresenterGridCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[PresenterGridCell class]] && [[(PresenterGridCell *)nibItem reuseIdentifier] isEqualToString: @"PresenterGridCell"]) {
                cell= (PresenterGridCell *) nibItem;
                
                cell.delegate=self;
            }
        }
    }
    
    //fill the buttons
    [cell fillOutletArray];
    NSMutableArray* iconResource=[self.sortedResource objectAtIndex:indexPath.row];
    for (int i=0; i<[iconResource count]; i++) {
        UIButton* but=[cell.buttons objectAtIndex:i];
        UILabel* lab=[cell.labels objectAtIndex:i];
        [cell enableButtonAtIndex:i enable:YES];
        but.tag=indexPath.row*5+i;
        
        NSMutableDictionary* file=[iconResource objectAtIndex:i];
        
        lab.text=[file objectForKey:@"Title"];
        
        //buttom image
        UIImage* tempImage=nil;
        if ([self.groupType isEqualToString:@"L5GroupType"]) {
            
            tempImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[file objectForKey:@"FileImageIUR"]];
        }
        if ([self.groupType isEqualToString:@"FileType"]) {
            tempImage=[[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[file objectForKey:@"L5GroupImageIUR"]];
        }
            [but setBackgroundImage:tempImage forState:UIControlStateNormal];
    }
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
- (void)PresenterGridCell:(PresenterGridCell *)presenterGridCell buttonTouched:(UIButton *)button{
    
//    NSLog(@"button %d touched",button.tag);
    NSMutableDictionary* aFile=[self.theResource objectAtIndex:button.tag];

    //push file reader to the navigation
    if (myFileReader==nil) {
        myFileReader=[[FileReaderViewController alloc]initWithNibName:@"FileReaderViewController" bundle:nil];
    }
    myFileReader.title=[aFile objectForKey:@"Title"];
    [self.navigationController pushViewController:myFileReader animated:YES];
    
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",[FileCommon presenterPath], [aFile objectForKey:@"Name"]];
    NSURL *url = [NSURL fileURLWithPath:path];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //reset the reader
    [myFileReader loadFile:url];
    myFileReader.theData=aFile;
    NSLog(@"a file %@ is loaded!",aFile);
}
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:NO];
    myBarButtonItem=barButtonItem;
}
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem{
    [self.navigationController.navigationBar.topItem setLeftBarButtonItem:nil animated:NO];

}


#pragma mark presenter detail protocol
-(void)resetResource:(NSMutableArray*)resource WithGrouType:(NSString*)type{
    self.groupType=type;

    self.theResource=resource;
    if (self.sortedResource ==nil) {
        self.sortedResource=[NSMutableArray array];
    }else{
        [self.sortedResource removeAllObjects];
    }
    [self sortResource];
    //back to the root view
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self.tableView reloadData];
}
-(void)resetResource:(NSMutableArray*)resource{
    
}
-(void)sortResource{
    NSMutableArray* rowArray=[NSMutableArray array];
    for(int i=0;i<[self.theResource count];i++){
        [rowArray addObject:[self.theResource objectAtIndex:i]];
        if ((i+1)%5==0) {
            [self.sortedResource addObject:rowArray];
            rowArray=[NSMutableArray array];
        }
    }
    if ([rowArray count]>0) {
        [self.sortedResource addObject:rowArray];

    }
//    NSLog(@"the sorted resource has %d rows ",[self.sortedResource count]);
}

@end
