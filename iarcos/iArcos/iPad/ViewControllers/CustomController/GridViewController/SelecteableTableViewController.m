//
//  SelecteableTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SelecteableTableViewController.h"


@implementation SelecteableTableViewController
@synthesize tableData;
@synthesize isCellEditable;

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
    [selectionPopover release];
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
    
    //disable the selection function
    self.tableView.allowsSelection=NO;
    
    //middle buttons
    NSArray *statusItems = [NSArray arrayWithObjects:@"Search",@"Selection",nil];
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
    
    [spvc release];
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
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [selectionPopover dismissPopoverAnimated:YES];
}
#pragma mark - Table view data source




// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //    // No editing style if not editing or the index path is nil.
    //    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    //    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    //    // existing content. Existing content can be deleted.    
    //    if (self.editing && indexPath.row == ([array count])) 
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

//popover delegate
-(void)showTotalOfSelections{

    
}
-(void)showSelectedDetail:(NSMutableDictionary*)theData{

    
}
-(NSMutableDictionary*)selectionTotal{
    
    return nil;
    
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
//taps 
-(void)handleDoubleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        aCell=(SelectedableTableCell*)reconizer.view.superview;
        [self showSelectedDetail:(NSMutableDictionary*) aCell.data];
    }
    
}
-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        aCell=(SelectedableTableCell*)reconizer.view.superview;
        [aCell flipSelectStatus];
    }
    
}

//model view delegate
- (void)didDismissModalView{
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
//    [parentView dismissModalViewControllerAnimated:YES];
    [parentView dismissViewControllerAnimated:YES completion:nil];
}
@end
