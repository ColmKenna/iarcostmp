//
//  ProductDetailPriceTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 12/12/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ProductDetailPriceTableViewController.h"

@implementation ProductDetailPriceTableViewController
@synthesize productDetailDataManager = _productDetailDataManager;
@synthesize arcosGenericHeaderViewController = _arcosGenericHeaderViewController;
- (id)init {
    self = [super init];
    if (self) {
        self.arcosGenericHeaderViewController = [[[ArcosGenericHeaderViewController alloc] initWithNibName:@"ArcosGenericHeaderViewController" bundle:nil] autorelease];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.productDetailDataManager != nil) { self.productDetailDataManager = nil; }
    self.arcosGenericHeaderViewController = nil;
    
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // custom view for header. will be adjusted to default or specified header height
    self.arcosGenericHeaderViewController.titleLabel.text = self.productDetailDataManager.miscTitle;
    return self.arcosGenericHeaderViewController.view;
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
    if (self.productDetailDataManager.priceDisplayList != nil) {
        return [self.productDetailDataManager.priceDisplayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdProductDetailPriceTableCell";
    
    ProductDetailPriceTableCell* cell=(ProductDetailPriceTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ProductDetailTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[ProductDetailPriceTableCell class]] && [[(ProductDetailPriceTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (ProductDetailPriceTableCell *) nibItem;                
            }
        }
	}
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.productDetailDataManager.priceDisplayList objectAtIndex:indexPath.row];
    //    NSLog(@"ProductDetailStockTableCell: %@", cellData);
    cell.priceTitle.text = [cellData objectForKey:@"Title"];
    cell.priceValue.text = [cellData objectForKey:@"Value"];
    if ([[cellData objectForKey:@"Title"] isEqualToString:@"Customer Price:"]) {
        cell.priceValue.font = [UIFont boldSystemFontOfSize:17.0];
        cell.priceValue.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else {
        cell.priceValue.font = [UIFont systemFontOfSize:17.0];
        cell.priceValue.textColor = [UIColor blackColor];
    }
    
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

@end
