//
//  OrderlinesIarcosTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 10/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "OrderlinesIarcosTableViewController.h"
#import "ArcosStackedViewController.h"

@interface OrderlinesIarcosTableViewController ()
- (void)deleteOrderLine:(NSMutableDictionary*)data;
- (void)deleteOrderLineFromCellDeleteButton:(NSMutableDictionary*)data;
- (void)deleteCurrentOrderLine;
- (void)restoreCurrentOrderLine;
- (void)calculateOrderLinesTotal;
- (void)refreshParentNavController;
- (void)configRightBarButtons;
@end

@implementation OrderlinesIarcosTableViewController
@synthesize isCellEditable = _isCellEditable;
@synthesize formIUR = _formIUR;
@synthesize orderNumber = _orderNumber;
@synthesize displayList = _displayList;
@synthesize currentSelectedOrderLine = _currentSelectedOrderLine;
@synthesize backupSelectedOrderLine = _backupSelectedOrderLine;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize inputPopover = _inputPopover;
@synthesize factory = _factory;
@synthesize myRootViewController = _myRootViewController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize locationIUR = _locationIUR;
@synthesize vansOrderHeader = _vansOrderHeader;
@synthesize discountButton = _discountButton;

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.isCellEditable) {
//        NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
//        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
//        [rightButtonList addObject:addButton];
//        [addButton release];
//        UIBarButtonItem* addLineButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLinePressed:)];
//        [rightButtonList addObject:addLineButton];
//        [addLineButton release];
//        self.navigationItem.rightBarButtonItems = rightButtonList;
//    }
    self.tableView.allowsSelection = NO;
    self.tableCellFactory = [[[OrderlinesIarcosTableCellFactory alloc] init] autorelease];
    self.factory = [WidgetFactory factory];
    self.factory.delegate = self;
    
//    self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:self.locationIUR];
//    self.inputPopover.delegate = self;
    self.myRootViewController = [ArcosUtils getRootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.formIUR = nil;
    self.orderNumber = nil;
    self.displayList = nil;
    self.currentSelectedOrderLine = nil;
    self.backupSelectedOrderLine = nil;
    self.tableCellFactory = nil;
    self.inputPopover = nil;
    self.factory = nil;
    self.myRootViewController = nil;
    self.globalNavigationController = nil;
    self.locationIUR = nil;
    self.vansOrderHeader = nil;
    self.discountButton = nil;
    
    [super dealloc];
}

- (void)resetTableDataWithData:(NSMutableArray*)theData {
    self.displayList = theData;
}

- (void)configRightBarButtons {
    if (self.isCellEditable) {
        NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
        UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configRightBarButtons];
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
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    OrderlinesIarcosBaseTableViewCell* cell = (OrderlinesIarcosBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (OrderlinesIarcosBaseTableViewCell*)[self.tableCellFactory createOrderlinesIarcosBaseTableViewCellWithData:cellData];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [cell.contentView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTap.numberOfTapsRequired = 2;
        [cell.contentView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [singleTap release];
        [doubleTap release];
    }
    // Configure the cell...
    //fill data for cell
    [cell configCellWithData:cellData];
    
    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //repositioning the popover when rotation finished
    if ([self.inputPopover isPopoverVisible]) {
        [self.inputPopover dismissPopoverAnimated:NO];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        CGRect aRect = CGRectMake(parentNavigationRect.size.width-10, parentNavigationRect.size.height, 1, 1);
        [self.inputPopover presentPopoverFromRect:aRect inView:self.myRootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

-(void)handleSingleTapGesture:(id)sender{
    if (!self.isCellEditable) {//not editable
        return;
    }
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        self.backupSelectedOrderLine = [NSMutableDictionary dictionaryWithDictionary:[self.displayList objectAtIndex:swipedIndexPath.row]];
        //present the input popover
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        CGRect aRect = CGRectMake(parentNavigationRect.size.width-10, parentNavigationRect.size.height, 1, 1);
        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:self.formIUR];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            self.inputPopover = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
            wvc.Data = [self.displayList objectAtIndex:swipedIndexPath.row];;
        } else {
            self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data = [self.displayList objectAtIndex:swipedIndexPath.row];
            oipvc.showSeparator = showSeparator;
            oipvc.vansOrderHeader = self.vansOrderHeader;
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
        self.inputPopover.delegate = self;
        
        
        [self.inputPopover presentPopoverFromRect:aRect inView:self.myRootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)handleDoubleTapGesture:(id)sender{
//    if (!self.isCellEditable) return;//not editable
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        pdvc.presentViewDelegate = self;
        NSMutableDictionary* cellDataDict = [self.displayList objectAtIndex:swipedIndexPath.row];
        pdvc.productIUR = [cellDataDict objectForKey:@"ProductIUR"];
        pdvc.locationIUR = self.locationIUR;
        pdvc.productDetailDataManager.formRowDict = cellDataDict;
        if (self.globalNavigationController != nil) {
            self.globalNavigationController = nil;
        }
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:pdvc] autorelease];
        [pdvc release];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.myRootViewController addChildViewController:self.globalNavigationController];
        [self.myRootViewController.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteOrderLineFromCellDeleteButton:[self.displayList objectAtIndex:indexPath.row]];
    }
}

#pragma mark WidgetFactoryDelegate
-(void)operationDone:(id)data {
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
        [self resetTableDataWithData:orderLines];
        [self.tableView reloadData];
        [self calculateOrderLinesTotal];
        return;
    }
    
    if (![ProductFormRowConverter isSelectedWithFormRowDict:data]) {//No QTY value 0 means delete the line
        [self deleteOrderLine:data];
    }else{
        [[ArcosCoreData sharedArcosCoreData]updateOrderLine:data];
        NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:self.orderNumber withSortKey:@"OrderLine" locationIUR:self.locationIUR];
        [self resetTableDataWithData:orderLines];
        [self.tableView reloadData];
        [self calculateOrderLinesTotal];
    }
}

- (void)editTable:(id)sender {
    if(self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    } else {
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
    [oldptvc release];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark OrderLineDetailProductDelegate
- (void)didSaveOrderlinesFinish {
    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:self.orderNumber withSortKey:@"OrderLine" locationIUR:self.locationIUR];
    [self resetTableDataWithData:orderLines];
    [self.tableView reloadData];
    [self calculateOrderLinesTotal];
    [self didDismissPresentView];
}

- (void)didDeleteAllOrderlinesFinish {
    [self didDismissPresentView];
    [self popToIarcosSavedOrderDetailViewController];
}

-(void)popToIarcosSavedOrderDetailViewController {
    NSUInteger numOfViewControllers = [self.rcsStackedController.rcsViewControllers count];
    if (numOfViewControllers >= 3) {
        UINavigationController* topNavigationController = [self.rcsStackedController.rcsViewControllers objectAtIndex:numOfViewControllers - 3];
        [self.rcsStackedController popToNavigationController:topNavigationController animated:YES];
        UIViewController* topViewController = [topNavigationController.viewControllers objectAtIndex:0];
        [topViewController viewWillAppear:YES];
    }
}

- (void)deleteOrderLineFromCellDeleteButton:(NSMutableDictionary*)data {
    self.backupSelectedOrderLine = data;
    [self deleteOrderLine:data];
}

- (void)deleteOrderLine:(NSMutableDictionary*)data {
    NSString* title=@"";
    if ([self.displayList count]==1) {
        title=@"You are about to delete the last order line, you will also delele the order header it belongs to.";
    }else{
        title=@"You are about to delete the selected order line!";
        
    }
    self.currentSelectedOrderLine = data;
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Cancel",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    
    [self calculateOrderLinesTotal];
}

- (void)deleteCurrentOrderLine {
    if ([self.displayList count] == 1) {
        [[ArcosCoreData sharedArcosCoreData] deleteOrderHeaderWithOrderNumber:[self.currentSelectedOrderLine objectForKey:@"OrderNumber"]];
    } else {
        [[ArcosCoreData sharedArcosCoreData]deleteOrderLine:self.currentSelectedOrderLine];
    }
    [self.displayList removeObject:self.currentSelectedOrderLine];
    if ([self.displayList count] == 0) {
        [self popToIarcosSavedOrderDetailViewController];
    } else {
        [self.tableView reloadData];
    }
}

- (void)restoreCurrentOrderLine {
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

- (void)calculateOrderLinesTotal {
    float totalValue = 0.0f;
    
    for(NSMutableDictionary* aDict in self.displayList ){
        totalValue += [[aDict objectForKey:@"LineValue"]floatValue];
    }

    [[ArcosCoreData sharedArcosCoreData] updateOrderHeaderTotalGoods:[NSNumber numberWithFloat:totalValue] withOrderNumber:self.orderNumber];
    [self refreshParentNavController];
}

- (void)refreshParentNavController {
    int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
    if (currentIndex >= 2) {
        for (int i = 1; i <= 2; i++) {
            UINavigationController* prevNavigationController = [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:i];
            UIViewController* prevViewController = [prevNavigationController.viewControllers objectAtIndex:0];
            [prevViewController viewWillAppear:YES];
        }
    }
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


@end
