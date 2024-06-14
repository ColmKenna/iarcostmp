//
//  OrderLineDetailProductTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/06/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderLineDetailProductTableViewController.h"
@interface OrderLineDetailProductTableViewController (Private) 
- (void)saveOrderLineToOrderCart:(NSMutableDictionary*)anOrderLineDict;
- (void)hideMySearchBar;
@end

@implementation OrderLineDetailProductTableViewController
@synthesize mySearchBar = _mySearchBar;
@synthesize delegate = _delegate;
@synthesize orderLineDetailProductDataManager = _orderLineDetailProductDataManager;
@synthesize rootView = _rootView;
//@synthesize inputPopover = _inputPopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize widgetFactory = _widgetFactory;
@synthesize showSeparator = _showSeparator;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize saveDelegate = _saveDelegate;
@synthesize locationIUR = _locationIUR;
@synthesize formRowSearchDelegate = _formRowSearchDelegate;
@synthesize vansOrderHeader = _vansOrderHeader;
@synthesize formRowTableCellGeneratorDelegate = _formRowTableCellGeneratorDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.orderLineDetailProductDataManager = [[[OrderLineDetailProductDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    if (self.mySearchBar != nil) { self.mySearchBar = nil; }        
    if (self.delegate != nil) { self.delegate = nil; }
    if (self.orderLineDetailProductDataManager != nil) { self.orderLineDetailProductDataManager = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
//    self.inputPopover = nil;
    self.globalWidgetViewController = nil;
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
//    if (self.saveDelegate != nil) { self.saveDelegate = nil; }
    self.locationIUR = nil;
    self.formRowSearchDelegate = nil;
    self.vansOrderHeader = nil;
    self.formRowTableCellGeneratorDelegate = nil;
    
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
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [cancelButton release];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].saveButtonText style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.orderLineDetailProductDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:self.orderLineDetailProductDataManager.formIUR];
    
    self.rootView = [ArcosUtils getRootView];
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
//    self.inputPopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:self.locationIUR];
//    self.inputPopover.delegate = self;
//    self.showSeparator = [ProductFormRowConverter showSeparatorWithFormType:@"104"];
    if ([self.orderLineDetailProductDataManager checkFormIURStandardFlag] && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showFullProductTableAddingLinesFlag]) {
        self.formRowSearchDelegate = [[[FormRowCurrentListSearchDataManager alloc] initWithTarget:self] autorelease];
//        self.showSeparator = [self.orderLineDetailProductDataManager showSeparatorWithFormIUR:self.orderLineDetailProductDataManager.formIUR];
        [self.orderLineDetailProductDataManager retrieveStandardFormDataList:self.locationIUR packageIUR:[self.vansOrderHeader objectForKey:@"PosteedIUR"]];
    } else {
        self.formRowSearchDelegate = [[[ProductSearchDataManager alloc] initWithTarget:self] autorelease];
//        self.showSeparator = [ProductFormRowConverter showSeparatorWithFormType:@"104"];
    }
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
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.orderLineDetailProductDataManager.currentFormDetailDict objectForKey:@"Details"]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) {
        self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellRrpGenerator alloc] init] autorelease];
    } else {
        self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellNormalGenerator alloc] init] autorelease];
    }
    if (self.isNotFirstLoaded) return;
    if (self.orderLineDetailProductDataManager.standardOrderFormFlag && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showFullProductTableAddingLinesFlag]) {
        [self hideMySearchBar];
    } else {
        [self.mySearchBar becomeFirstResponder];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    if (self.orderLineDetailProductDataManager.standardOrderFormFlag && ![[ArcosConfigDataManager sharedArcosConfigDataManager] showFullProductTableAddingLinesFlag]) {
        [self hideMySearchBar];
    }
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    self.mySearchBar.frame = CGRectMake(0, MAX(0,self.tableView.contentOffset.y), self.tableView.bounds.size.width, 44);
//    if (self.inputPopover.popoverVisible) {
//        [self showInputPopover];
//    }
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if ([self.inputPopover isPopoverVisible]) {
//        [self.inputPopover dismissPopoverAnimated:NO];
//        [self showInputPopover];
//    }
//}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.presentedViewController != nil && [self.presentedViewController isKindOfClass:[WidgetViewController class]]) {
            CGRect aRect = CGRectMake(self.navigationController.view.bounds.size.width - 10, self.navigationController.view.bounds.size.height - 10, 1, 1);
            self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
        }
    }];
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
    return [self.orderLineDetailProductDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSString *CellIdentifier = @"OrderProductTableCell";
    OrderProductTableCell *cell=(OrderProductTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[OrderProductTableCell class]] && [[(OrderProductTableCell *)nibItem reuseIdentifier] isEqualToString: @"OrderProductTableCell"]) {
                cell= (OrderProductTableCell *) nibItem;
                //add taps
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];                
                [cell.contentView addGestureRecognizer:singleTap];                
                [singleTap release];
                break;
            }    
            
        }
        
	}
    */
    OrderProductTableCell* cell = [self.formRowTableCellGeneratorDelegate generateTableCellWithTableView:tableView];    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [cell.contentView addGestureRecognizer:singleTap];
    [singleTap release];
    // Configure the cell...
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;    
    NSMutableDictionary* aRow = [self.orderLineDetailProductDataManager.displayList objectAtIndex:indexPath.row];
    
    NSMutableDictionary* cellData = [NSMutableDictionary dictionaryWithDictionary:aRow];
    [self.orderLineDetailProductDataManager.displayList replaceObjectAtIndex:indexPath.row withObject:cellData];
    
    cell.cellDelegate = self;
    [cell configCellWithData:cellData];
    cell.description.text = [cellData objectForKey:@"Details"];
    NSNumber* bonusBy = [cellData objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [cellData objectForKey:@"StockAvailable"];
    NSNumber* active = [cellData objectForKey:@"Active"];
//    if (stockAvailable != nil && [stockAvailable intValue] == 0) {
//        cell.description.textColor = [UIColor lightGrayColor];
//    } else if ([bonusBy intValue] != 78) {
//        cell.description.textColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
//    } else {
//        cell.description.textColor = [UIColor blackColor];
//    }
    [ArcosUtils configDetailsColorWithLabel:cell.description active:active stockAvailable:stockAvailable bonusBy:bonusBy];
    cell.rrpPrice.text = [NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitRRP"]floatValue] / 100];
    cell.price.text = [NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitPrice"]floatValue]];
    NSNumber* priceFlag = [cellData objectForKey:@"PriceFlag"];
    if ([priceFlag intValue] == 1) {
        cell.price.font = [UIFont boldSystemFontOfSize:17.0];
        cell.price.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else if([priceFlag intValue] == 2) {
        cell.price.font = [UIFont boldSystemFontOfSize:17.0];
        cell.price.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    } else {
        cell.price.font = [UIFont systemFontOfSize:17.0];
        cell.price.textColor = [UIColor blackColor];
    }
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
    
    //qty and bonus must not be zero
    //inStock == qty split pack;foc == bonus split pack
    NSNumber* qty=[cellData objectForKey:@"Qty"];
    NSNumber* bonus=[cellData objectForKey:@"Bonus"];
    NSNumber* inStock = [cellData objectForKey:@"InStock"];
    NSNumber* units = [cellData objectForKey:@"units"];
    NSNumber* FOC = [cellData objectForKey:@"FOC"];
    
    if (([qty intValue]<=0 ||qty==nil) && ([inStock intValue]==0 || inStock == nil) && ([units intValue]==0 || units == nil) && ([bonus intValue]<=0 || bonus==nil) && ([FOC intValue]<=0 || FOC == nil)) {
        cell.qty.text=@"";
        cell.value.text=@"";
        cell.discount.text=@"";
        cell.bonus.text=@"";
        cell.InStock.text = @"";
        cell.FOC.text = @"";
    }else{
        cell.qty.text=[ArcosUtils convertZeroToBlank:[[cellData objectForKey:@"Qty"]stringValue]];
        cell.value.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"LineValue"]floatValue]];
        
        if ([[cellData objectForKey:@"DiscountPercent"]floatValue]!=0) {
            cell.discount.text=[NSString stringWithFormat:@"%1.2f%%",[[cellData objectForKey:@"DiscountPercent"]floatValue]];
        }else{
            cell.discount.text=@"";
        }
        if ([[cellData objectForKey:@"Bonus"]intValue]!=0) {
            cell.bonus.text=[[cellData objectForKey:@"Bonus"]stringValue];
        }else{
            cell.bonus.text=@"";
        }
        cell.InStock.text = [ArcosUtils convertZeroToBlank:[units stringValue]];
        cell.FOC.text = [ArcosUtils convertZeroToBlank:[FOC stringValue]];        
    }
//    [cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    [cell configBackgroundColour:[[cellData objectForKey:@"IsSelected"]boolValue]];
    
    cell.theIndexPath=indexPath;
    cell.data=[ProductFormRowConverter convertToOrderProductDict:cellData];
    
    return cell;
}

- (void)cancelPressed:(id)sender {
    [self.delegate didDismissPresentView];
}

- (void)savePressed:(id)sender {
    if ([self.orderLineDetailProductDataManager.orderLineOrderCart count] == 0) {
        NSString* tmpTitleText = @"Deleting all order lines will delete the order header.";
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:tmpTitleText
//                                                                 delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
//                                                        otherButtonTitles:@"Cancel",nil];
//
//        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//        [actionSheet showInView:self.navigationController.view];
////        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//        [actionSheet release];
        void (^lBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            
        };
        void (^rBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            BOOL resultFlag = [[ArcosCoreData sharedArcosCoreData] deleteOrderHeaderWithOrderNumber:self.orderLineDetailProductDataManager.orderNumber];
            if (resultFlag) {
                [self.saveDelegate didDeleteAllOrderlinesFinish];
            }
        };
        [ArcosUtils showTwoBtnsDialogBox:tmpTitleText title:@"" target:self lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:lBtnActionHandler rBtnHandler:rBtnActionHandler];
    } else {
        [[ArcosCoreData sharedArcosCoreData] saveOrderLineWithOrderNumber:self.orderLineDetailProductDataManager.orderNumber withOrderlines:self.orderLineDetailProductDataManager.orderLineOrderCart];
        [self.saveDelegate didSaveOrderlinesFinish];        
    }    
}

//action sheet delegate
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0:{//ok button remove current order line 
            BOOL resultFlag = [[ArcosCoreData sharedArcosCoreData] deleteOrderHeaderWithOrderNumber:self.orderLineDetailProductDataManager.orderNumber];
            if (resultFlag) {
                [self.saveDelegate didDeleteAllOrderlinesFinish];
            }
        }            
            break;
        default:
            break;
    }
}
*/
#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.mySearchBar.showsCancelButton = YES;
    [self.formRowSearchDelegate searchBarTextDidBeginEditing:searchBar];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    self.mySearchBar.showsCancelButton = NO;
    [self.formRowSearchDelegate searchBarTextDidEndEditing:searchBar];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.formRowSearchDelegate searchBar:searchBar textDidChange:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.formRowSearchDelegate searchBarSearchButtonClicked:searchBar];
//    [self.mySearchBar resignFirstResponder];
//    [self.orderLineDetailProductDataManager productWithDescriptionKeyword:[NSString stringWithFormat:@"%@", searchBar.text]];
//    [self reloadTableViewData];
//    if ([self.orderLineDetailProductDataManager.displayList count] == 0) {
//        [ArcosUtils showDialogBox:[GlobalSharedClass shared].noDataFoundMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
//            
//        }];
//    }
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
//    [self.mySearchBar resignFirstResponder];
//    self.mySearchBar.text = @"";
    [self.formRowSearchDelegate searchBarCancelButtonClicked:searchBar];
}

//functions to be called by ProductSearchDataManager
- (void)resetTableViewDataSourceWithSearchText:(NSString*)aSearchText {
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.orderLineDetailProductDataManager.currentFormDetailDict objectForKey:@"Details"]];
    [self.orderLineDetailProductDataManager productWithDescriptionKeyword:[NSString stringWithFormat:@"%@", aSearchText] orderFormDetails:orderFormDetails];
    [self reloadTableViewData];
    if ([self.orderLineDetailProductDataManager.displayList count] == 0) {
        [ArcosUtils showDialogBox:[GlobalSharedClass shared].noDataFoundMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

//functions to be called by FormRowCurrentListSearchDataManager
-(void)currentListSearchBarSearchButtonClicked:(NSString *)searchText {
    [self.mySearchBar resignFirstResponder];
}

-(void)currentListSearchBarCancelButtonClicked {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    self.orderLineDetailProductDataManager.displayList = [NSMutableArray arrayWithArray:self.orderLineDetailProductDataManager.originalDisplayList];
    [self reloadTableViewData];
}

-(void)currentListSearchTextDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        self.orderLineDetailProductDataManager.displayList = [NSMutableArray arrayWithArray:self.orderLineDetailProductDataManager.originalDisplayList];
        [self reloadTableViewData];
        return;
    }
    [self.orderLineDetailProductDataManager.displayList removeAllObjects];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Details CONTAINS[cd] %@", searchText];
    NSArray* tmpArray = [self.orderLineDetailProductDataManager.originalDisplayList filteredArrayUsingPredicate:predicate];
    self.orderLineDetailProductDataManager.displayList = [NSMutableArray arrayWithArray:tmpArray];
    [self reloadTableViewData];
}

-(void)currentListSearchBarTextDidBeginEditing {
    self.mySearchBar.showsCancelButton = YES;
}

-(void)currentListSearchBarTextDidEndEditing {
    self.mySearchBar.showsCancelButton = NO;
}

-(void)handleSingleTapGesture:(id)sender{    
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        OrderProductTableCell* aCell;
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        aCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
                self.globalWidgetViewController = [self.widgetFactory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:self.locationIUR];
            } else {
                self.globalWidgetViewController = [self.widgetFactory CreateOrderEntryInputWidgetWithLocationIUR:self.locationIUR];
            }
            
//            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
//            self.globalWidgetViewController.Data = aCell.data;
            OrderEntryInputViewController* oeivc = (OrderEntryInputViewController*)self.globalWidgetViewController;
            oeivc.Data = aCell.data;
            if (self.orderLineDetailProductDataManager.standardOrderFormFlag) {
                oeivc.orderEntryInputDataManager.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:self.orderLineDetailProductDataManager.formIUR];
            } else {
                oeivc.orderEntryInputDataManager.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormType:@"104"];
            }
        } else {
            self.globalWidgetViewController = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:self.locationIUR];
            OrderInputPadViewController* oipvc = (OrderInputPadViewController*)self.globalWidgetViewController;
//            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data=aCell.data;
//            oipvc.showSeparator = self.showSeparator;
            if (self.orderLineDetailProductDataManager.standardOrderFormFlag) {
                oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:self.orderLineDetailProductDataManager.formIUR];
            } else {
                oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormType:@"104"];
            }
            oipvc.vansOrderHeader = self.vansOrderHeader;
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
//        self.inputPopover.delegate = self;
//        [self showInputPopover];
        CGRect aRect = CGRectMake(self.navigationController.view.bounds.size.width - 10, self.navigationController.view.bounds.size.height - 10, 1, 1);
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.navigationController.view;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
    /*
    OrderProductTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        aCell=(OrderProductTableCell*)reconizer.view.superview;
        //[aCell flipSelectStatus];
    }
     
    OrderInputPadViewController* oipvc=(OrderInputPadViewController*) inputPopover.contentViewController;
    oipvc.Data=aCell.data;
    oipvc.showSeparator = self.showSeparator;
    [self showInputPopover];
     */
}

-(void)operationDone:(id)data {
//    [self.inputPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (data == nil) {//invalid data 
        return;
    }
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:data];
    [data setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    
    [self saveOrderLineToOrderCart:data];
    [self reloadTableViewData];
}

- (void)saveOrderLineToOrderCart:(NSMutableDictionary*)anOrderLineDict {
    [self.orderLineDetailProductDataManager saveOrderLineToOrderCart:anOrderLineDict];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.mySearchBar.frame = CGRectMake(0, MAX(0,scrollView.contentOffset.y), scrollView.bounds.size.width, 44);    
}

- (void)reloadTableViewData {
    [self.tableView reloadData];
//    self.mySearchBar.frame = CGRectMake(0, MAX(0, self.tableView.contentOffset.y), self.tableView.bounds.size.width, 44);    
}

- (void)showInputPopover {
//    CGRect aRect = CGRectMake(self.navigationController.view.bounds.size.width - 10, self.navigationController.view.bounds.size.height - 10, 1, 1);
//    [self.inputPopover presentPopoverFromRect:aRect inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

//- (void)drilldownTapGesture:(id)sender {
//    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
//    if (recognizer.state == UIGestureRecognizerStateEnded) {
//        OrderProductTableCell* aCell;
//        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
//        aCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
//        ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
//        NSMutableDictionary* cellDataDict = [self.orderLineDetailProductDataManager.displayList objectAtIndex:swipedIndexPath.row];
//        pdvc.productIUR = [cellDataDict objectForKey:@"ProductIUR"];
//        [self.navigationController pushViewController:pdvc animated:YES];
//        [pdvc release];
//        
//    }
//}

#pragma mark OrderProductTableCellDelegate
- (void)displayBigProductImageWithProductCode:(NSString*)aProductCode {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = [ArcosUtils trim:aProductCode];
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
}

- (void)displayProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath *)anIndexPath{    
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.productIUR = aProductIUR;
    pdvc.locationIUR = self.locationIUR;
    pdvc.productDetailDataManager.formRowDict = [self.orderLineDetailProductDataManager.displayList objectAtIndex:anIndexPath.row];
    [self.navigationController pushViewController:pdvc animated:YES];
    [pdvc release];
}

- (void)toggleShelfImageWithData:(NSMutableDictionary*)aCellData {
    NSNumber* myInStockNumber = [aCellData objectForKey:@"InStock"];
    if ([myInStockNumber intValue] == 0) {
        myInStockNumber = [NSNumber numberWithInt:1];
    } else {
        myInStockNumber = [NSNumber numberWithInt:0];
    }
    [aCellData setObject:myInStockNumber forKey:@"InStock"];
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:aCellData];
    [aCellData setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    [self saveOrderLineToOrderCart:aCellData];
    [self reloadTableViewData];
}

- (void)hideMySearchBar {
    
    float statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        statusBarHeight = 0.0;
    }
    [self.tableView setContentOffset:CGPointMake(0, 0 - statusBarHeight - self.navigationController.navigationBar.frame.size.height + self.mySearchBar.bounds.size.height) animated:NO];
//    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top + self.mySearchBar.bounds.size.height) animated:NO];
}

#pragma mark UIPopoverControllerDelegate
/*
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
}*/
#pragma mark UIPopoverPresentationControllerDelegate
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([popoverPresentationController.presentedViewController isKindOfClass:[OrderInputPadViewController class]]) {
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*)popoverPresentationController.presentedViewController;
        if ([[oipvc.Data objectForKey:@"RRIUR"] intValue] == -1) {
            return NO;
        }
        if (![[ArcosUtils convertNilToEmpty:[oipvc.Data objectForKey:@"BonusDeal"]] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

@end
