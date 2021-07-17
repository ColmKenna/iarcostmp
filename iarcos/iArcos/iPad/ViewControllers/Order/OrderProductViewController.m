//
//  OrderProductViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderProductViewController.h"
#import "ArcosCoreData.h"
@interface OrderProductViewController(Private)
-(void)deleteOrderLine:(NSMutableDictionary*)data;
- (void)deleteOrderLineFromCellDeleteButton:(NSMutableDictionary*)data;
-(void)deleteCurrentOrderLine;
-(void)restoreCurrentOrderLine;
-(NSMutableDictionary*)orderLinesTotal;
-(void)popToSavedOrderDetailViewController;
- (void)configRightBarButtons;
@end

@implementation OrderProductViewController
@synthesize descTitleLabel = _descTitleLabel;
@synthesize qtyTitleLabel = _qtyTitleLabel;
@synthesize valueTitleLabel = _valueTitleLabel;
@synthesize discTitleLabel = _discTitleLabel;
@synthesize bonTitleLabel = _bonTitleLabel;
@synthesize headerView;
@synthesize tableData;
@synthesize displayList;
@synthesize currentSelectedOrderLine;
@synthesize backupSelectedOrderLine;
@synthesize isCellEditable;
@synthesize inputPopover = _inputPopover;
@synthesize factory;
@synthesize delegate;
@synthesize footerView;
@synthesize totalQtyLabel;
@synthesize totalBonusLabel;
@synthesize totalValueLabel;
@synthesize totalLinesLabel;
@synthesize totalTitleLabel = _totalTitleLabel;
@synthesize linesTitleLabel = _linesTitleLabel;
@synthesize formIUR = _formIUR;
@synthesize orderNumber = _orderNumber;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize currentSelectedIndexPath = _currentSelectedIndexPath;
@synthesize rootView = _rootView;
@synthesize locationIUR = _locationIUR;
@synthesize arcosStockonHandUtils = _arcosStockonHandUtils;
@synthesize vansOrderHeader = _vansOrderHeader;
@synthesize discountButton = _discountButton;

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
    self.descTitleLabel = nil;
    self.qtyTitleLabel = nil;
    self.valueTitleLabel = nil;
    self.discTitleLabel = nil;
    self.bonTitleLabel = nil;
    self.headerView = nil;
    self.tableData = nil;
    self.displayList = nil;
    self.currentSelectedOrderLine = nil;
    self.backupSelectedOrderLine = nil;
    self.inputPopover = nil;
    self.factory = nil;
    
    self.totalValueLabel = nil;
    self.totalQtyLabel = nil;
    self.totalBonusLabel = nil;
    self.totalLinesLabel = nil;
    self.totalTitleLabel = nil;
    self.linesTitleLabel = nil;
    self.footerView = nil;
    if (self.formIUR != nil) { self.formIUR = nil; }
    if (self.orderNumber != nil) { self.orderNumber = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    self.currentSelectedIndexPath = nil;
    self.rootView = nil;
    self.locationIUR = nil;
    self.arcosStockonHandUtils = nil;
    self.vansOrderHeader = nil;
    self.discountButton = nil;
    
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
    //self.displayList=self.tableData;
    //edit button
//    if (self.isCellEditable) {
//        NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
//        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditTable:)];
//        [rightButtonList addObject:addButton];
//        [addButton release];
//        UIBarButtonItem* addLineButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLinePressed:)];
//        [rightButtonList addObject:addLineButton];
//        [addLineButton release];
//        self.navigationItem.rightBarButtonItems = rightButtonList;
//    }
    
    self.tableView.allowsSelection=NO;
    //minddle buttons
//    NSArray *statusItems = [NSArray arrayWithObjects: @"Search",@"Selection",nil];
//    UISegmentedControl* segmentBut = [[UISegmentedControl alloc] initWithItems:statusItems];
//    
//    [segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    segmentBut.frame = CGRectMake(0, 0, 300, 30);
//    segmentBut.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentBut.momentary = YES;
//    
//    self.navigationItem.titleView = segmentBut;
    
    //popovers
    /*
    SelectionPopoverViewController* spvc=[[SelectionPopoverViewController alloc]initWithNibName:@"SelectionPopoverViewController" bundle:nil];
    spvc.delegate=self;
    
    selectionPopover=[[UIPopoverController alloc]initWithContentViewController:spvc];
    
    if (self.isCellEditable) {
        selectionPopover.popoverContentSize=CGSizeMake(130, 190);

    }else{
        selectionPopover.popoverContentSize=CGSizeMake(130, 150);

    }
    */
    //input popover
    self.factory=[WidgetFactory factory];
    self.factory.delegate=self;
    
//    self.inputPopover=[factory CreateOrderInputPadWidgetWithLocationIUR:self.locationIUR];
//    self.inputPopover.delegate = self;
    
    //calculate total
    [self orderLinesTotal];
    self.rootView = [ArcosUtils getRootView];
    self.arcosStockonHandUtils = [[[ArcosStockonHandUtils alloc] init] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)configRightBarButtons {
    if (self.isCellEditable) {
        NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditTable:)];
        [rightButtonList addObject:addButton];
        [addButton release];
        UIBarButtonItem* addLineButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLinePressed:)];
        [rightButtonList addObject:addLineButton];
        [addLineButton release];
        self.discountButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"discount.png"] style:UIBarButtonItemStylePlain target:self action:@selector(discountButtonPressed)] autorelease];
        NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
        SettingManager* sm = [SettingManager setting];
        NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
        NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
        NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
        if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountByPriceGroupFlag]) {
            [rightButtonList addObject:self.discountButton];
        }
        self.navigationItem.rightBarButtonItems = rightButtonList;
    }
}

- (void)discountButtonPressed {
    self.inputPopover = [self.factory CreateCategoryWidgetWithDataSource:WidgetDataSourcePriceGroup];
    self.inputPopover.delegate = self;
    [self.inputPopover presentPopoverFromBarButtonItem:self.discountButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configRightBarButtons];
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
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //repositioning the popover when rotation finished
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if ([self.inputPopover isPopoverVisible]) {
        [self.inputPopover dismissPopoverAnimated:NO];
        CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
//        UIViewController* parentView=self.parentViewController;
//        CGRect aRect=CGRectMake(parentView.view.frame.size.width-10, parentView.view.frame.size.height, 1, 1);
        [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
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
    return [self.displayList count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"OrderlineOrderProductTableCell";
    
    OrderProductTableCell *cell=(OrderProductTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[OrderProductTableCell class]] && [[(OrderProductTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (OrderProductTableCell *) nibItem;
                
                //add taps
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                
//                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
//                doubleTap.numberOfTapsRequired = 2;
//                [cell.contentView  addGestureRecognizer:doubleTap];
//                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                [singleTap release];
//                [doubleTap release];
                break;
            }    
            
        }
	}
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [cell needEditButton:self.isCellEditable];
    
    //change the selection color
//    UIView *v = [[[UIView alloc] init] autorelease];
//    v.backgroundColor = [UIColor lightGrayColor];
//    cell.selectedBackgroundView = v;
    
    //fill data for cell
    NSMutableDictionary* cellData=[self.displayList objectAtIndex:indexPath.row];
    cell.description.text=[cellData objectForKey:@"Description"];
    cell.orderPadDetails.text = [cellData objectForKey:@"OrderPadDetails"];
    cell.productSize.text = [cellData objectForKey:@"ProductSize"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
    } else {
        cell.productCode.text = @"";
    }
//    if ([cell.orderPadDetails.text isEqualToString:@""]) {
//        cell.productCode.text = @"";
//        cell.productSize.text = @"";
//    } else {
//        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
//        cell.productSize.text = [cellData objectForKey:@"ProductSize"];
//    }
//    cell.price.text=[[cellData objectForKey:@"UnitPrice"]stringValue];
    cell.qty.text=[[cellData objectForKey:@"Qty"]stringValue];
    cell.value.text=[NSString stringWithFormat:@"%1.2f", [[cellData objectForKey:@"LineValue"]floatValue]];
    
    if ([[cellData objectForKey:@"DiscountPercent"]floatValue]!=0) {
        cell.discount.text=[NSString stringWithFormat:@"%1.2f%%",[[cellData objectForKey:@"DiscountPercent"]floatValue]] ;   
    }else{
        cell.discount.text=@"";
    }
    if ([[cellData objectForKey:@"Bonus"]intValue]!=0) {
        cell.bonus.text=[[cellData objectForKey:@"Bonus"]stringValue];
    }else{
        cell.bonus.text=@"";
    }
    cell.InStock.text = [ArcosUtils convertZeroToBlank:[[cellData objectForKey:@"InStock"] stringValue]];
    cell.FOC.text = [ArcosUtils convertZeroToBlank:[[cellData objectForKey:@"FOC"] stringValue]];
    
//    [cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
//    [cell configBackgroundColour:[[cellData objectForKey:@"IsSelected"]boolValue]];
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
    
    if (self.isCellEditable) {
        return UITableViewCellEditingStyleDelete;
        
    }else{
        return UITableViewCellEditingStyleNone;
        
    }
}
// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        NSLog(@"deleted committed");
        //get the cell
        OrderProductTableCell* cell=(OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        self.currentSelectedIndexPath = indexPath;
        [self deleteOrderLineFromCellDeleteButton:(NSMutableDictionary*) cell.data];
//        [self deleteOrderLine:(NSMutableDictionary*) cell.data];
//
//        
//        [self.displayList removeObjectAtIndex:indexPath.row];
//        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
    }
    //        [arry removeObjectAtIndex:indexPath.row];
    //		[Table reloadData];
    //    } else if (editingStyle == UITableViewCellEditingStyleInsert)
    //	{
    //        [arry insertObject:@"Tutorial" atIndex:[arry count]];
    //		[Table reloadData];
    //    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
//    pdvc.productDetailRequestSource = ProductDetailRequestSourceProductDetail;
    pdvc.presentViewDelegate = self;
    NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:indexPath.row];
    pdvc.productIUR = [cellDataDict objectForKey:@"ProductIUR"];
    pdvc.locationIUR = self.locationIUR;
    pdvc.productDetailDataManager.formRowDict = cellDataDict;
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:pdvc] autorelease];
    [pdvc release];
//    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [selectionPopover dismissPopoverAnimated:YES];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


//ibaction
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

- (void)addLinePressed:(id)sender {
    OrderLineDetailProductTableViewController* oldptvc = [[OrderLineDetailProductTableViewController alloc] initWithNibName:@"OrderLineDetailProductTableViewController" bundle:nil];
    oldptvc.locationIUR = self.locationIUR;
    oldptvc.delegate = self;
    oldptvc.saveDelegate = self;
    oldptvc.orderLineDetailProductDataManager.formIUR = self.formIUR;
    [oldptvc.orderLineDetailProductDataManager importExistentOrderLineToOrderCart:self.displayList];
    oldptvc.orderLineDetailProductDataManager.orderNumber = self.orderNumber;
    oldptvc.vansOrderHeader = self.vansOrderHeader;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:oldptvc] autorelease];
//    [self.rootView presentViewController:tmpNavigationController animated:YES completion:nil];
    [oldptvc release];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

- (IBAction)DeleteButtonAction:(id)sender
{
	NSLog(@"delete button press");
}

-(void)showOnlySelectionItems{
    NSLog(@"show only selection pressed!");
    NSMutableArray* newList=[[[NSMutableArray alloc]init]autorelease];
    
    for(NSMutableDictionary* aDict in self.displayList ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [newList addObject:aDict];
        }
    }
    
    self.displayList=newList;
    [self.tableView reloadData];
    
//    [selectionPopover dismissPopoverAnimated:YES];
    
    [self orderLinesTotal];
}
-(void)clearAllSelections{
    for(NSMutableDictionary* aDict in self.displayList ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [aDict setObject:[NSNumber numberWithBool:NO] forKey: @"IsSelected"];
        }
    }
    self.displayList=self.tableData;
    [self.tableView reloadData];
//    [selectionPopover dismissPopoverAnimated:YES];
    
    [self orderLinesTotal];
    
}

//segment button action
/*
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
*/
-(void)showSelectedDetail:(NSMutableDictionary*)theData{
    NSLog(@"show total selection pressed!");
    
    OrderProductDetailModelViewController* opdmvc=[[OrderProductDetailModelViewController alloc]initWithNibName:@"OrderProductDetailModelViewController" bundle:nil];
    opdmvc.delegate=self;
    opdmvc.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];
    opdmvc.theData=theData;
    opdmvc.isViewEditable=self.isCellEditable;
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:opdmvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [opdmvc release];
    
}
//taps 
//-(void)handleDoubleTapGesture:(id)sender{
//    NSLog(@"double tap");
//    if (!self.isCellEditable) {//not editable
//        return;
//    }
//    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
//    SelectedableTableCell* aCell;
//    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
//        aCell=(SelectedableTableCell*)reconizer.view.superview;
//        //[self showSelectedDetail:(NSMutableDictionary*) aCell.data];
//    }
//    self.backupSelectedOrderLine=[NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary*) aCell.data];
//    
//    //present the input popover
//    UIViewController* parentView=self.parentViewController;
//    CGRect aRect=CGRectMake(parentView.view.frame.size.width-10, parentView.view.frame.size.height, 1, 1);
//    
//    OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
//    oipvc.Data=aCell.data;
//    
//    [self.inputPopover presentPopoverFromRect:aRect inView:parentView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
//    
//}
-(void)handleSingleTapGesture:(id)sender{
    NSLog(@"single tap");
    if (!self.isCellEditable && ![[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {//not editable
        return;
    }
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        SelectedableTableCell* aCell;
        /*
        if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
            aCell=(SelectedableTableCell*)reconizer.view.superview;
            //[self showSelectedDetail:(NSMutableDictionary*) aCell.data];
        }
         */
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        self.currentSelectedIndexPath = swipedIndexPath;
        aCell = (SelectedableTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        self.backupSelectedOrderLine=[NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary*) aCell.data];
        
        //present the input popover
        UIViewController* parentView=self.parentViewController;
        CGRect aRect=CGRectMake(parentView.view.frame.size.width-10, parentView.view.frame.size.height - 10, 1, 1);
//        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:self.formIUR];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
                self.inputPopover = [self.factory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:self.locationIUR];
            } else {
                self.inputPopover = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:self.locationIUR];
            }
            
            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
            wvc.Data = aCell.data;
            wvc.isWidgetEditable = self.isCellEditable;
        } else {
            self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:self.locationIUR];
            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data=aCell.data;
//            oipvc.showSeparator = showSeparator;
            oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:self.formIUR];
            oipvc.vansOrderHeader = self.vansOrderHeader;
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
        self.inputPopover.delegate = self;
        [self.inputPopover presentPopoverFromRect:aRect inView:parentView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
    
    OrderProductTotalModelViewController* optmvc=[[OrderProductTotalModelViewController alloc]initWithNibName:@"OrderProductTotalModelViewController" bundle:nil];
    optmvc.delegate=self;
    optmvc.theData=[self selectionTotal];
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:optmvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [optmvc release];
    
//    [selectionPopover dismissPopoverAnimated:YES];
    
}

-(NSMutableDictionary*)selectionTotal{
    NSMutableDictionary* totalDict=[[[NSMutableDictionary alloc]init]autorelease];
    
    int totalProducts=0;
    float totalValue=0.0f;
    int totalPoints=0;
    float totalBonus=0.0f;
    int totalQty=0;
    
    for(NSMutableDictionary* aDict in self.displayList ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            totalProducts++;
            totalValue+=[[aDict objectForKey:@"LineValue"]floatValue];
            totalPoints+=[[aDict objectForKey:@"Points"]intValue];
            totalBonus+=[[aDict objectForKey:@"Bonus"]floatValue];
            totalQty+=[[aDict objectForKey:@"Qty"]intValue];
        }
    }
    
    [totalDict setObject:[NSNumber numberWithInt:totalProducts] forKey:@"totalProducts"];
    [totalDict setObject:[NSNumber numberWithFloat:totalValue] forKey:@"totalValue"];
    [totalDict setObject:[NSNumber numberWithInt:totalPoints] forKey:@"totalPoints"];
    [totalDict setObject:[NSNumber numberWithFloat:totalBonus] forKey:@"totalBonus"];
    [totalDict setObject:[NSNumber numberWithInt:totalQty] forKey:@"totalQty"];
    
    
    NSLog(@"selection total order %d  value  %f  points  %d",totalProducts,totalValue,totalPoints);
    return totalDict;
    
}
#pragma mark
- (void)reloadTableDataWithData:(NSMutableArray*)theData{
    self.tableData=theData;
    self.displayList=self.tableData;
    [self.tableView reloadData];
}
#pragma mark input popover delegate
//input popover delegate
-(void)operationDone:(id)data{
//    NSLog(@"input is done! with value %@",data);
    
    [self.inputPopover dismissPopoverAnimated:YES];
    if ([self.inputPopover.contentViewController isKindOfClass:[PickerWidgetViewController class]]) {
        NSNumber* descrDetailIUR = [data objectForKey:@"DescrDetailIUR"];
        NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
        for (int i = 0; i < [self.displayList count]; i++) {
            NSMutableDictionary* tmpCellData = [self.displayList objectAtIndex:i];
            [productIURList addObject:[tmpCellData objectForKey:@"ProductIUR"]];
        }
        NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:descrDetailIUR productIURList:productIURList];
        for (int j = 0; j < [self.displayList count]; j++) {
            NSMutableDictionary* tmpCellData = [self.displayList objectAtIndex:j];
            NSNumber* tmpProductIUR = [tmpCellData objectForKey:@"ProductIUR"];
            NSDictionary* tmpPriceDict = [priceHashMap objectForKey:tmpProductIUR];
            if (tmpPriceDict == nil) continue;
            NSDecimalNumber* tmpDiscountPercent = [tmpPriceDict objectForKey:@"DiscountPercent"];
            [tmpCellData setObject:[NSNumber numberWithFloat:[tmpDiscountPercent floatValue]] forKey:@"DiscountPercent"];
            [tmpCellData setObject:[ProductFormRowConverter calculateLineValue:tmpCellData] forKey:@"LineValue"];
            [[ArcosCoreData sharedArcosCoreData]updateOrderLine:tmpCellData];
        }
        NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:self.orderNumber withSortKey:@"OrderLine" locationIUR:self.locationIUR];
        [self reloadTableDataWithData:orderLines];
        [self orderLinesTotal];
        return;
    }
    NSMutableDictionary* orderLine= (NSMutableDictionary*)data;
//    NSNumber* QTY=[orderLine objectForKey:@"Qty"];
    
    //[QTY intValue]<=0
    if (![ProductFormRowConverter isSelectedWithFormRowDict:orderLine]) {//No QTY value 0 means delete the line
        [self deleteOrderLine:data];
    }else{
        [[ArcosCoreData sharedArcosCoreData]updateOrderLine:data];
        NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:self.orderNumber withSortKey:@"OrderLine" locationIUR:self.locationIUR];
        [self reloadTableDataWithData:orderLines];
//        [self.tableView reloadData];
        [self orderLinesTotal];
    }
    
}
- (void)deleteOrderLineFromCellDeleteButton:(NSMutableDictionary*)data {
//    self.backupSelectedOrderLine = data;
    self.backupSelectedOrderLine=[NSMutableDictionary dictionaryWithDictionary:data];
    [self deleteOrderLine:data];
}

-(void)deleteOrderLine:(NSMutableDictionary*)data{
    NSString* title=@"";
    if ([self.tableData count]==1) {
        title=@"You are about to delete the last order line, you will also delele the order header it belongs to.";
    }else{
        title=@"You are about to delete the selected order line!";

    }
    self.currentSelectedOrderLine=data;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Cancel",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
//    [actionSheet showFromRect:[ArcosUtils fromRect4ActionSheet:[self.tableView cellForRowAtIndexPath:self.currentSelectedIndexPath]] inView:self.view animated:YES];
    [actionSheet release];
}
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
    
    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            [self restoreCurrentOrderLine];
            break;
        case 0://ok button remove current order line 
            [self deleteCurrentOrderLine];
            break;   
        default:
            break;
    }
    
    [self orderLinesTotal];
}
-(void)deleteCurrentOrderLine{
    if ([self.tableData count]==1) {
        [self.delegate deleteOrderHeaderWithOrderNnumber:[self.currentSelectedOrderLine objectForKey:@"OrderNumber"]];
    } else {
        [[ArcosCoreData sharedArcosCoreData]deleteOrderLine:self.currentSelectedOrderLine];
    }    
    [self.displayList removeObject:self.currentSelectedOrderLine];
    [self.tableData removeObject:self.currentSelectedOrderLine];
    [self.tableView reloadData];
    if ([self.tableData count] == 0) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self popToSavedOrderDetailViewController];
    }
}
-(void)restoreCurrentOrderLine{
    if (self.backupSelectedOrderLine != nil) {
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"LineValue" ]forKey:@"LineValue"];
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"DiscountPercent" ]forKey:@"DiscountPercent"];
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"Bonus" ]forKey:@"Bonus"];
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"Qty" ]forKey:@"Qty"];
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"InStock" ]forKey:@"InStock"];
        [self.currentSelectedOrderLine setObject:[self.backupSelectedOrderLine objectForKey:@"FOC" ]forKey:@"FOC"];
    }    
    [self.tableView reloadData];

}

#pragma mark selection total
-(NSMutableDictionary*)orderLinesTotal{
   // NSMutableDictionary* totalDict=[[[NSMutableDictionary alloc]init]autorelease];
    
    int totalProducts=0;
    float totalValue=0.0f;
    int totalPoints=0;
    int totalBonus=0;
    int totalQty=0;
    
    for(NSMutableDictionary* aDict in self.displayList ){
        //NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if (YES) {
            totalProducts++;
            totalValue+=[[aDict objectForKey:@"LineValue"]floatValue];
            totalPoints+=[[aDict objectForKey:@"Points"]intValue];
            totalBonus+=[[aDict objectForKey:@"Bonus"]intValue];
            totalQty+=[[aDict objectForKey:@"Qty"]intValue];
        }
    }
    totalQtyLabel.text=[NSString stringWithFormat:@"%d",totalQty];
    
    if (totalBonus!=0) {
        totalBonusLabel.text=[NSString stringWithFormat:@"%d",totalBonus];
    }else{
        totalBonusLabel.text=@"";
    }
    
    totalValueLabel.text=[NSString stringWithFormat:@"%1.2f",totalValue];
    totalLinesLabel.text=[NSString stringWithFormat:@"%d",totalProducts];
    
    
    //sync with order header table
    [[ArcosCoreData sharedArcosCoreData]updateOrderHeaderTotalGoods:[NSNumber numberWithFloat:[ArcosUtils roundFloatTwoDecimal:totalValue]] withOrderNumber:self.orderNumber];
    [self.delegate totalGoodsUpdateForOrderNumber:self.orderNumber withValue:[NSNumber numberWithFloat:[ArcosUtils roundFloatTwoDecimal:totalValue]]];
    
    return nil;
    
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
//    [self.rootView dismissViewControllerAnimated:YES completion:nil];
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

#pragma mark OrderLineDetailProductDelegate
- (void)didSaveOrderlinesFinish {
    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:self.orderNumber withSortKey:@"OrderLine" locationIUR:self.locationIUR];
    [self reloadTableDataWithData:orderLines];
    [self orderLinesTotal];
    [self didDismissPresentView];
}

#pragma mark UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if ([popoverController.contentViewController isKindOfClass:[OrderInputPadViewController class]]) {
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*) popoverController.contentViewController;
        if ([[oipvc.Data objectForKey:@"RRIUR"] intValue] == -1) {
            return NO;
        }
        if (![[ArcosUtils convertNilToEmpty:[oipvc.Data objectForKey:@"BonusDeal"]] isEqualToString:@""]) {
            return NO;
        }
    }    
    return YES;
}

- (void)didDeleteAllOrderlinesFinish {
    [self didDismissPresentView];
    [self popToSavedOrderDetailViewController];    
}

-(void)popToSavedOrderDetailViewController {
    NSUInteger numOfViewControllers = [self.navigationController.viewControllers count];
    if (numOfViewControllers >= 3) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:numOfViewControllers - 3] animated:YES];
    }
}

@end
