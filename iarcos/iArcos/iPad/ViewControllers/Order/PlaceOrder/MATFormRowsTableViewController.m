//
//  MATFormRowsTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 25/09/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "MATFormRowsTableViewController.h"

@implementation MATFormRowsTableViewController
@synthesize locationIUR = _locationIUR;
@synthesize modelDelegate = _modelDelegate;
@synthesize animateDelegate = _animateDelegate;
@synthesize callGenericServices = _callGenericServices;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize customiseTableHeaderView = _customiseTableHeaderView;
@synthesize matFormRowsDataManager = _matFormRowsDataManager;
@synthesize widgetFactory = _widgetFactory;
@synthesize inputPopover = _inputPopover;
@synthesize isServiceCalled = _isServiceCalled;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isShowingInStockFlag = _isShowingInStockFlag;
@synthesize isVanSalesEnabledFlag = _isVanSalesEnabledFlag;
@synthesize mySearchBar = _mySearchBar;
@synthesize isPageMultipleLoaded = _isPageMultipleLoaded;
@synthesize mATFormRowsTableCellGeneratorDelegate = _mATFormRowsTableCellGeneratorDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        self.matFormRowsDataManager = [[[MATFormRowsDataManager alloc] init] autorelease];
        self.isPageMultipleLoaded = NO;
    }
    return self;
}

- (void)dealloc
{
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.modelDelegate != nil) { self.modelDelegate = nil; }
    if (self.callGenericServices != nil) { self.callGenericServices = nil; }
    if (self.arcosCustomiseAnimation != nil) { self.arcosCustomiseAnimation = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.customiseTableHeaderView != nil) {
        [self.customiseTableHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.customiseTableHeaderView = nil;
    }
    if (self.matFormRowsDataManager != nil) { self.matFormRowsDataManager = nil; }
    if (self.widgetFactory != nil) { self.widgetFactory = nil; }
    self.inputPopover = nil;
    if (self.startDate != nil) { self.startDate = nil; }
    if (self.endDate != nil) { self.endDate = nil; }
    self.mySearchBar = nil;
    self.mATFormRowsTableCellGeneratorDelegate = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [ArcosUtils showMsg:@"System running low on memory, please close some other apps." delegate:nil];
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];    
    UIBarButtonItem* checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkout:)];
    [self.navigationItem setRightBarButtonItem:checkoutButton];
    [checkoutButton release];
    self.arcosCustomiseAnimation = [[[ArcosCustomiseAnimation alloc] init] autorelease];
    self.rootView = [ArcosUtils getRootView];    
    
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
    self.inputPopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    self.inputPopover.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
//    self.startDate = [NSDate date];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] retrieveLocationProductMATDataLocallyFlag]) {
        self.isServiceCalled = YES;
        [self.matFormRowsDataManager processLocationProductMATData:self.locationIUR];
    } else {
        self.isServiceCalled = NO;
        [self.callGenericServices genericGetCustomerData:[self.locationIUR intValue] startDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] endDate:[ArcosUtils dateFromString:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].datetimeFormat] format:[GlobalSharedClass shared].datetimeFormat] type:@"MATQTY" level:6 action:@selector(setTableGetCustomerDataResult:) target:self];
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
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag]) {
        self.mATFormRowsTableCellGeneratorDelegate = [[[MATFormRowsTableCellRrpGenerator alloc] init] autorelease];
    } else {
        self.mATFormRowsTableCellGeneratorDelegate = [[[MATFormRowsTableCellNormalGenerator alloc] init] autorelease];
    }
    if (!self.isPageMultipleLoaded) {
        self.isPageMultipleLoaded = YES;
        [self hideMySearchBar];
    }    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isShowingInStockFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] showInStockFlag];
    self.isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    if (!self.isServiceCalled) return;
    [self.matFormRowsDataManager syncQtyBonDisplayList];
    [self.tableView reloadData];
//    NSLog(@"qtyBonDisplayList: %@", self.matFormRowsDataManager.qtyBonDisplayList);
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
    NSLog(@"shouldAutorotateToInterfaceOrientation");
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //repositioning the popover when rotation finished
    if ([self.inputPopover isPopoverVisible]) {
        [self.inputPopover dismissPopoverAnimated:NO];
        CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height, 1, 1);
        [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    UIView* myHeaderView = [self.mATFormRowsTableCellGeneratorDelegate generateTableHeaderView];
    if (self.matFormRowsDataManager.fieldNames != nil) {
        //NSLog(@"customiseTableHeaderView is: %d", [[self.customiseTableHeaderView subviews] count]);
        
        UILabel* detailsLabel = (UILabel*)[myHeaderView viewWithTag:2];
//        detailsLabel.text = @"Description";
        for (UIGestureRecognizer* recognizer in detailsLabel.gestureRecognizers) {
            [detailsLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* doubleTap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDoubleTapGesture:)];
        doubleTap10.numberOfTapsRequired = 2;
        [detailsLabel addGestureRecognizer:doubleTap10];
        [doubleTap10 release];
        for (int i = 3; i<= 15; i++) {
            NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
            SEL selector = NSSelectorFromString(fieldMethodName);
            NSString* fieldName = [self.matFormRowsDataManager.fieldNames performSelector:selector];
            UILabel* headerCellLabel = (UILabel*)[myHeaderView viewWithTag:i];
            @try {
                headerCellLabel.text = [fieldName substringToIndex:3];
            }
            @catch (NSException *exception) {
                [ArcosUtils showMsg:-1 message:[NSString stringWithFormat:@"%@%@", [exception name], [exception reason]] delegate:nil];
                break;
            }
        }
        UILabel* totalLabel = (UILabel*)[myHeaderView viewWithTag:16];
        totalLabel.text = @"Total";
        for (UIGestureRecognizer* recognizer in totalLabel.gestureRecognizers) {
            [totalLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* doubleTap12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDoubleTapGesture:)];
        doubleTap12.numberOfTapsRequired = 2;
        [totalLabel addGestureRecognizer:doubleTap12];
        [doubleTap12 release];
        UILabel* qtyLabel = (UILabel*)[myHeaderView viewWithTag:17];
        qtyLabel.text = @"Qty";
//        UILabel* bonLabel = (UILabel*)[myHeaderView viewWithTag:18];
//        bonLabel.text = @"Bon";
//        UILabel* stockLabel = (UILabel*)[myHeaderView viewWithTag:19];
//        stockLabel.text = @"Stock";
    } else {
        [myHeaderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    return myHeaderView;
}

- (void)handleHeaderDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {        
        UILabel* selectedLabel = (UILabel*)recognizer.view;
        if (selectedLabel.tag == 2) {
            NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field20" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field2" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
            [self.matFormRowsDataManager.displayList sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, detailsDescriptor, nil]];
            [self.tableView reloadData];
        } else if (selectedLabel.tag == 16) {
            BOOL ascendingFlag = NO;
            if (self.matFormRowsDataManager.totalClickTime % 2 != 0) {
                ascendingFlag = YES;
            }
            self.matFormRowsDataManager.totalClickTime++;
            NSSortDescriptor* totalDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field16" ascending:ascendingFlag selector:@selector(localizedStandardCompare:)] autorelease];
            [self.matFormRowsDataManager.displayList sortUsingDescriptors:[NSArray arrayWithObjects:totalDescriptor, nil]];
            [self.tableView reloadData];
        }
    }
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
    if (self.matFormRowsDataManager.displayList != nil) {
//        NSLog(@"self.matFormRowsDataManager.displayList: %d", [self.matFormRowsDataManager.displayList count]);
        return [self.matFormRowsDataManager.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSString *CellIdentifier = @"IdLabelMATFormRowsTableCell";
    
    MATFormRowsTableCell *cell=(MATFormRowsTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MATFormRowsTableCell" owner:self options:nil];        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MATFormRowsTableCell class]] && [[(MATFormRowsTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (MATFormRowsTableCell *) nibItem;
//                [cell initIndicatorBorder];
                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
                doubleTap.numberOfTapsRequired = 2;
                [cell.contentView  addGestureRecognizer:doubleTap];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [singleTap requireGestureRecognizerToFail:doubleTap];
                [cell.contentView addGestureRecognizer:singleTap];
                [doubleTap release];
                [singleTap release];
                break;
            }
        }
	}
    */
    MATFormRowsTableCell* cell = [self.mATFormRowsTableCellGeneratorDelegate generateTableCellWithTableView:tableView];
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell.contentView  addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [cell.contentView addGestureRecognizer:singleTap];
    [doubleTap release];
    [singleTap release];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.indexPath = indexPath;
    ArcosGenericClass* cellData = [self.matFormRowsDataManager.displayList objectAtIndex:indexPath.row];
    cell.cellFormRowData = [self.matFormRowsDataManager.qtyBonDisplayList objectAtIndex:indexPath.row];
    
    cell.labelDetails.text = [cellData Field2];
    NSString* orderPadDetailsStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field20]]];
    cell.orderPadDetails.text = orderPadDetailsStr;
    if (self.isShowingInStockFlag) {
        cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@]", orderPadDetailsStr, [cell.cellFormRowData objectForKey:@"StockAvailable"]]];
        if (self.isVanSalesEnabledFlag) {
            cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@ / VAN %@]", orderPadDetailsStr, [cell.cellFormRowData objectForKey:@"StockAvailable"], [cell.cellFormRowData objectForKey:@"StockonHand"]]];
        }
    }
    cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
    } else {
        cell.productCode.text = @"";
    }
    cell.labelSRP.text = [NSString stringWithFormat:@"%1.2f",[[cell.cellFormRowData objectForKey:@"UnitRRP"]floatValue] / 100];
    cell.labelPrice.text=[NSString stringWithFormat:@"%1.2f",[[cell.cellFormRowData objectForKey:@"UnitPrice"]floatValue]];
    NSNumber* priceFlag = [cell.cellFormRowData objectForKey:@"PriceFlag"];
    if ([priceFlag intValue] == 1) {
//        cell.labelPrice.font = [UIFont boldSystemFontOfSize:17.0];
        cell.labelPrice.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else if([priceFlag intValue] == 2) {
//        cell.labelPrice.font = [UIFont boldSystemFontOfSize:17.0];
        cell.labelPrice.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    } else {
//        cell.labelPrice.font = [UIFont systemFontOfSize:17.0];
        cell.labelPrice.textColor = [UIColor blackColor];
    }
//    if ([cell.orderPadDetails.text isEqualToString:@""]) {
//        cell.productCode.text = @"";
//        cell.productSize.text = @"";
//    } else {
//        cell.productCode.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
//        cell.productSize.text = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
//    }
    for (int i = 3; i <= 16; i++) {
        NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(fieldMethodName);
        NSString* fieldValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:(NSString*)[cellData performSelector:selector]]];
        NSString* valueFirstMethodName = [NSString stringWithFormat:@"setText:"];
        NSString* valueSecondMethod = [NSString stringWithFormat:@"label%d", i];
        SEL secondSelector = NSSelectorFromString(valueSecondMethod);
        SEL firstSelector = NSSelectorFromString(valueFirstMethodName);
        if (![@"" isEqualToString:fieldValue]) {
            NSNumber* tmpFieldValueNumber = [ArcosUtils convertStringToFloatNumber:fieldValue];
            NSString* finalFieldValue = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", (int)roundf([tmpFieldValueNumber floatValue])]];
            [[cell performSelector:secondSelector] performSelector:firstSelector withObject:finalFieldValue];
        } else {
            [[cell performSelector:secondSelector] performSelector:firstSelector withObject:@""];
        }        
    }
    cell.labelStock.text = cellData.Field22;
    NSNumber* bonusBy = [cell.cellFormRowData objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:cellData.Field22]]];
    NSNumber* active = [cell.cellFormRowData objectForKey:@"Active"];
    if (![active boolValue]) {
        cell.labelDetails.textColor = [UIColor colorWithRed:13.0/255.0 green:152.0/255.0 blue:186.0/255.0 alpha:0.5];
    } else if ([stockAvailable intValue] == 0) {
        cell.labelDetails.textColor = [UIColor lightGrayColor];
    } else if ([bonusBy intValue] != 78) {
        cell.labelDetails.textColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
    } else {
        cell.labelDetails.textColor = [UIColor blackColor];
    }
    
    NSNumber* qty = [cell.cellFormRowData objectForKey:@"Qty"];
    NSNumber* bonus = [cell.cellFormRowData objectForKey:@"Bonus"];
    if (([qty intValue]<=0 ||qty==nil)&&([bonus intValue]<=0 || bonus==nil)) {
        cell.labelQty.text=@"";
        cell.labelBon.text=@"";
    }else{
        cell.labelQty.text = [[cell.cellFormRowData objectForKey:@"Qty"]stringValue];
        if ([[cell.cellFormRowData objectForKey:@"Bonus"]intValue]!=0) {
            cell.labelBon.text = [[cell.cellFormRowData objectForKey:@"Bonus"]stringValue];
        }else{
            cell.labelBon.text=@"";
        }
    }
    [cell setCellSelectStatus:[[cell.cellFormRowData objectForKey:@"IsSelected"]boolValue]];
    return cell;
}

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

-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
//        OrderProductTableCell* aCell;
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
//        aCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        NSMutableDictionary* cellFormRowData = [self.matFormRowsDataManager.qtyBonDisplayList objectAtIndex:swipedIndexPath.row];
        CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height, 1, 1);
        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        
        OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
        oipvc.Data=cellFormRowData;
        oipvc.showSeparator = showSeparator;
        ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
        if (!arcosErrorResult.successFlag) {
            [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
        [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

-(void)handleDoubleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        NSMutableDictionary* cellFormRowData = [self.matFormRowsDataManager.qtyBonDisplayList objectAtIndex:swipedIndexPath.row];
        ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        pdvc.productIUR = [cellFormRowData objectForKey:@"ProductIUR"];
        pdvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        pdvc.productDetailDataManager.formRowDict = cellFormRowData;
        [self.navigationController pushViewController:pdvc animated:YES];
        [pdvc release];
        
        if (self.backButtonDelegate != nil) {
            [self.backButtonDelegate controlOrderFormBackButtonEvent];
        }
    }
}

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)setTableGetCustomerDataResult:(ArcosGenericReturnObject*) result {
//    self.endDate = [NSDate date];
//    NSTimeInterval executeTime = [self.endDate timeIntervalSinceDate:self.startDate];
//    NSLog(@"mat: %f", executeTime);
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
//        NSDate* innerStartDate = [NSDate date];
//        self.matFormRowsDataManager.originalDisplayList = result.ArrayOfData;
        self.matFormRowsDataManager.originalFieldNames = result.FieldNames;
        self.matFormRowsDataManager.displayList = result.ArrayOfData;
        self.matFormRowsDataManager.originalDisplayList = [NSMutableArray arrayWithArray:self.matFormRowsDataManager.displayList];
        self.matFormRowsDataManager.fieldNames = result.FieldNames;
        [self.matFormRowsDataManager newProcessRawData:result.ArrayOfData locationIUR:self.locationIUR];
        [self.tableView reloadData];
//        NSDate* innerEndDate = [NSDate date];
//        NSTimeInterval innerExecuteTime = [innerEndDate timeIntervalSinceDate:innerStartDate];
//        NSLog(@"inner mat: %f", innerExecuteTime);
        self.isServiceCalled = YES;
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

//input popover delegate
-(void)operationDone:(id)data {
//    NSLog(@"Check Out mat input is done! with value %@", data);  
    [self.inputPopover dismissPopoverAnimated:YES];
//    [[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:data];
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];    
    [self.tableView reloadData];
}

- (IBAction) checkout:(id)sender{//redirect to the check out view    
    CheckoutViewController* cvc = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
    cvc.title = @"Checkout";
    cvc.matDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cvc] autorelease];
    [cvc release];
    [self.arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

#pragma mark SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}
#pragma mark MATCheckoutViewDelegate
-(void)dismissMATFormRowView {
    NSLog(@"dismissMATFormRowView is executed.");
    [self backPressed:nil];
}

- (void)hideMySearchBar {
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top + self.mySearchBar.bounds.size.height) animated:NO];
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        self.matFormRowsDataManager.displayList = [NSMutableArray arrayWithArray:self.matFormRowsDataManager.originalDisplayList];
        self.matFormRowsDataManager.qtyBonDisplayList = [NSMutableArray arrayWithArray:self.matFormRowsDataManager.originalQtyBonDisplayList];
        [self.matFormRowsDataManager syncQtyBonDisplayList];
        [self.tableView reloadData];
        return;
    }
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Field2 CONTAINS[cd] %@ or Field19 CONTAINS[cd] %@", searchText, searchText];
    NSArray* tmpArray = [self.matFormRowsDataManager.originalDisplayList filteredArrayUsingPredicate:predicate];
    self.matFormRowsDataManager.displayList = [NSMutableArray arrayWithArray:tmpArray];
    [self.matFormRowsDataManager retrieveQtyBonDisplayListWithDisplayList:self.matFormRowsDataManager.displayList];
    [self.matFormRowsDataManager syncQtyBonDisplayList];
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.mySearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    self.matFormRowsDataManager.displayList = [NSMutableArray arrayWithArray:self.matFormRowsDataManager.originalDisplayList];
    self.matFormRowsDataManager.qtyBonDisplayList = [NSMutableArray arrayWithArray:self.matFormRowsDataManager.originalQtyBonDisplayList];
    [self.matFormRowsDataManager syncQtyBonDisplayList];
    [self.tableView reloadData];
}

#pragma mark UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if ([popoverController.contentViewController isKindOfClass:[OrderInputPadViewController class]]) {
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*) popoverController.contentViewController;
        if ([[oipvc.Data objectForKey:@"RRIUR"] intValue] == -1) {
            return NO;
        }
    }    
    return YES;
}

@end
