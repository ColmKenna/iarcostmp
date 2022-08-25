//
//  PreviousOrderDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 13/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "PreviousOrderDetailViewController.h"
#import "GlobalSharedClass.h"

@implementation PreviousOrderDetailViewController
@synthesize headerView;
@synthesize tableData;
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
    
    //minddle buttons
    NSArray *statusItems = [[NSArray alloc] initWithObjects:@"Search",@"Selection",nil];
    UISegmentedControl* segmentBut = [[UISegmentedControl alloc] initWithItems:statusItems];
    
    [segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentBut.frame = CGRectMake(0, 0, 300, 30);
//    segmentBut.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentBut.momentary = YES;
    
    self.navigationItem.titleView = segmentBut;
    
    //popovers
    SelectionPopoverViewController* spvc=[[SelectionPopoverViewController alloc]initWithNibName:@"SelectionPopoverViewController" bundle:nil];
    spvc.delegate=self;
    
    selectionPopover=[[UIPopoverController alloc]initWithContentViewController:spvc];
    selectionPopover.popoverContentSize=CGSizeMake(130, 150);
    
    //load data
    NSNumber* locationIUR=[GlobalSharedClass shared].currentSelectedLocationIUR;
    self.tableData =[[ArcosCoreData sharedArcosCoreData]allOrdersWithSortKey:@"OrderDate" withLocationIUR:locationIUR];
}
- (void)reloadTableData{
    //load data
    NSNumber* locationIUR=[GlobalSharedClass shared].currentSelectedLocationIUR;
    self.tableData =[[ArcosCoreData sharedArcosCoreData]allOrdersWithSortKey:@"OrderDate" withLocationIUR:locationIUR];
    [self.tableView reloadData];
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
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [selectionPopover dismissPopoverAnimated:YES];
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
    return [self.tableData count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return self.headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber* orderNumber=[[self.tableData objectAtIndex:indexPath.row]objectForKey:@"OrderNumber"];
//    NSMutableArray* orderLines=[[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"LineValue" locationIUR:nil];
    NSMutableArray* orderLines = nil;
    
//    NSLog(@"row %d is taped!",indexPath.row);
    OrderProductViewController* orderProducts=[[[OrderProductViewController alloc]initWithNibName:@"OrderProductViewController" bundle:nil]autorelease];
    orderProducts.tableData=orderLines;
    orderProducts.isCellEditable=NO;
    [self.navigationController pushViewController:orderProducts animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"PreviousOrderTableCell";
    
    PreviousOrderTableCell *cell=(PreviousOrderTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[PreviousOrderTableCell class]] && [[(PreviousOrderTableCell *)nibItem reuseIdentifier] isEqualToString: @"PreviousOrderTableCell"]) {
                cell= (PreviousOrderTableCell *) nibItem;
                
                //add taps
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                
                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
                doubleTap.numberOfTapsRequired = 2;
                [cell.contentView  addGestureRecognizer:doubleTap];
                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                [doubleTap release];
            }
        }
	}
    
    //fill data for cell
    NSMutableDictionary* cellData=[self.tableData objectAtIndex:indexPath.row];
    cell.number.text=[[cellData objectForKey:@"OrderNumber"]stringValue];
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.date.text=[formatter stringFromDate:[cellData objectForKey:@"OrderDate"]];
    cell.deliveryDate.text=[formatter stringFromDate:[cellData objectForKey:@"DeliveryDate"]];
    [formatter release];
    cell.point.text=[[cellData objectForKey:@"Points"]stringValue];
    cell.value.text=[[cellData objectForKey:@"TotalGoods"]stringValue];
    cell.name.text=[cellData objectForKey:@"Name"];
    cell.address.text=[cellData objectForKey:@"Address"];
    [cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    cell.data=cellData;
    
    
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

#pragma mark - Table view data source




// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //    // No editing style if not editing or the index path is nil.
    //    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    //    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    //    // existing content. Existing content can be deleted.    
    //    if (self.editing && indexPath.row == ([arry count])) 
    //	{
    //		return UITableViewCellEditingStyleInsert;
    //	} else 
    //	{
    //		return UITableViewCellEditingStyleDelete;
    //	}
    //    return UITableViewCellEditingStyleNone;
    
    return UITableViewCellEditingStyleDelete;
}
// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        NSLog(@"deleted committed");
    }
    //        [arry removeObjectAtIndex:indexPath.row];
    //		[Table reloadData];
    //    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    //	{
    //        [arry insertObject:@"Tutorial" atIndex:[arry count]];
    //		[Table reloadData];
    //    }
}

//ibaction
- (IBAction)DeleteButtonAction:(id)sender
{
	NSLog(@"delete button press");
}

- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}

-(void)showOnlySelectionItems{
    NSLog(@"show only selection pressed!");
    NSMutableArray* newList=[[[NSMutableArray alloc]init]autorelease];
    
    for(NSMutableDictionary* aDict in self.tableData ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [newList addObject:aDict];
        }
    }
    
    [self.tableData removeAllObjects];
    self.tableData=newList;
    [self.tableView reloadData];
    
    [selectionPopover dismissPopoverAnimated:YES];
}
-(void)clearAllSelections{
    
//    for(NSMutableDictionary* aDict in self.tableData ){
//        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
//        if ([isSelected boolValue]) {
//            [aDict setObject:[NSNumber numberWithBool:NO] forKey: @"IsSelected"];
//        }
//    }
    NSNumber* locationIUR=[GlobalSharedClass shared].currentSelectedLocationIUR;
    self.tableData =[[ArcosCoreData sharedArcosCoreData]allOrdersWithSortKey:@"OrderDate" withLocationIUR:locationIUR];
    
    [self.tableView reloadData];
    [selectionPopover dismissPopoverAnimated:YES];
}


//segment button action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
            [selectionPopover presentPopoverFromRect:segment.bounds inView:segment permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
            
        default:
            break;
    }
    
}


//model view delegate
- (void)didDismissModalView{
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    [parentView dismissViewControllerAnimated:YES completion:nil];
}


//popover delegate
-(void)showTotalOfSelections{
    NSLog(@"show total selection pressed!");
    
    OrderHeaderTotalViewController* ohvc=[[OrderHeaderTotalViewController alloc]initWithNibName:@"OrderHeaderTotalViewController" bundle:nil];
    ohvc.delegate=self;
    ohvc.theData=[self selectionTotal];
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:ohvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [ohvc release];
    
    [selectionPopover dismissPopoverAnimated:YES];
   
}
-(void)showOrderDetail:(NSMutableDictionary*)theDate{
    NSLog(@"show total selection pressed!");
    
    OrderDetailModelViewController* odmvc=[[OrderDetailModelViewController alloc]initWithNibName:@"OrderDetailModelViewController" bundle:nil];
    odmvc.delegate=self;
    odmvc.theData=theDate;
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:odmvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [odmvc release];
        
}
-(NSMutableDictionary*)selectionTotal{
    NSMutableDictionary* totalDict=[[[NSMutableDictionary alloc]init]autorelease];
    
    int totalOrders=0;
    float totalValue=0.0f;
    int totalPoints=0;
    
    for(NSMutableDictionary* aDict in self.tableData ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            totalOrders++;
            totalValue+=[[aDict objectForKey:@"TotalGoods"]floatValue];
            totalPoints+=[[aDict objectForKey:@"Points"]intValue];
        }
    }
    
    [totalDict setObject:[NSNumber numberWithInt:totalOrders] forKey:@"totalOrders"];
    [totalDict setObject:[NSNumber numberWithFloat:totalValue] forKey:@"totalValue"];
    [totalDict setObject:[NSNumber numberWithInt:totalPoints] forKey:@"totalPoints"];
    
    NSLog(@"selection total order %d  value  %f  points  %d",totalOrders,totalValue,totalPoints);
    return totalDict;

}

//taps 

-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        aCell=(SelectedableTableCell*)reconizer.view.superview;
        [aCell flipSelectStatus];
    }
    
}
-(void)handleDoubleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    PreviousOrderTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        aCell=(PreviousOrderTableCell*)reconizer.view.superview;
        NSLog(@"double taps on index %@",aCell.name.text);
        [self showOrderDetail:(NSMutableDictionary*) aCell.data];
    }
    
}


@end
