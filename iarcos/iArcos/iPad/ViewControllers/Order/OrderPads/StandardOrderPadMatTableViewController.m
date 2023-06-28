//
//  StandardOrderPadMatTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/04/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "StandardOrderPadMatTableViewController.h"

@interface StandardOrderPadMatTableViewController ()

@end

@implementation StandardOrderPadMatTableViewController
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize standardOrderPadMatDataManager = _standardOrderPadMatDataManager;
@synthesize formRowsTableViewController = _formRowsTableViewController;
@synthesize mATFormRowsTableViewController = _mATFormRowsTableViewController;
@synthesize isShowingInStockFlag = _isShowingInStockFlag;
@synthesize isVanSalesEnabledFlag = _isVanSalesEnabledFlag;
@synthesize inputPopover = _inputPopover;
@synthesize factory = _factory;
@synthesize standardOrderPadMatHeaderView = _standardOrderPadMatHeaderView;
@synthesize mySearchBar = _mySearchBar;
@synthesize isPageMultipleLoaded = _isPageMultipleLoaded;
@synthesize mATFormRowsTableCellGeneratorDelegate = _mATFormRowsTableCellGeneratorDelegate;
@synthesize orderPadFooterViewDataManager = _orderPadFooterViewDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.standardOrderPadMatDataManager = [[[StandardOrderPadMatDataManager alloc] init] autorelease];
        self.formRowsTableViewController = [[[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil] autorelease];
        self.mATFormRowsTableViewController = [[[MATFormRowsTableViewController alloc] initWithNibName:@"MATFormRowsTableViewController" bundle:nil] autorelease];
        self.isShowingInStockFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] showInStockFlag];
        self.isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
        self.isPageMultipleLoaded = NO;
        self.orderPadFooterViewDataManager = [[[OrderPadFooterViewDataManager alloc] init] autorelease];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.mATFormRowsTableViewController.matFormRowsDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
    self.navigationController.navigationBarHidden = YES;
    self.factory = [WidgetFactory factory];
    self.factory.delegate = self;
//    self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.inputPopover.delegate = self;
    self.tableView.allowsSelection = NO;
}

- (void)dealloc {
    self.standardOrderPadMatDataManager = nil;
    self.formRowsTableViewController = nil;
    self.mATFormRowsTableViewController = nil;
    self.inputPopover = nil;
    self.factory = nil;
    self.standardOrderPadMatHeaderView = nil;
    self.mySearchBar = nil;
    self.mATFormRowsTableCellGeneratorDelegate = nil;
    self.orderPadFooterViewDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.mATFormRowsTableViewController.matFormRowsDataManager.currentFormDetailDict objectForKey:@"Details"]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) {
        self.mATFormRowsTableCellGeneratorDelegate = [[[MATFormRowsTableCellRrpGenerator alloc] init] autorelease];
    } else {
        self.mATFormRowsTableCellGeneratorDelegate = [[[MATFormRowsTableCellNormalGenerator alloc] init] autorelease];
    }
    if (!self.isPageMultipleLoaded) {        
        [self hideMySearchBar];
    }    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isShowingInStockFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] showInStockFlag];
    self.isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    if (self.isPageMultipleLoaded) {
        [self.formRowsTableViewController fillTheUnsortListWithData];
        [self.tableView reloadData];
    }    
    self.isPageMultipleLoaded = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ([self.inputPopover isPopoverVisible]) {
        [self.inputPopover dismissPopoverAnimated:NO];
        CGRect aRect = CGRectMake(self.formRowsTableViewController.rootView.view.bounds.size.width - 10, self.formRowsTableViewController.rootView.view.bounds.size.height - 10, 1, 1);
        [self.inputPopover presentPopoverFromRect:aRect inView:self.formRowsTableViewController.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* myHeaderView = [self.mATFormRowsTableCellGeneratorDelegate generateTableHeaderView];
    if ([self.formRowsTableViewController.unsortedFormrows count] > 0) {
        UILabel* detailsLabel = (UILabel*)[myHeaderView viewWithTag:2];
        for (UIGestureRecognizer* recognizer in detailsLabel.gestureRecognizers) {
            [detailsLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* doubleTap10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDoubleTapGesture:)];
        doubleTap10.numberOfTapsRequired = 2;
        [detailsLabel addGestureRecognizer:doubleTap10];
        [doubleTap10 release];
    }
    
    if ([self.formRowsTableViewController.unsortedFormrows count] > 0 && self.mATFormRowsTableViewController.matFormRowsDataManager.fieldNames != nil) {
        for (int i = 3; i <= 15; i++) {
            NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
            SEL selector = NSSelectorFromString(fieldMethodName);
            NSString* fieldName = [self.mATFormRowsTableViewController.matFormRowsDataManager.fieldNames performSelector:selector];
            UILabel* headerCellLabel = (UILabel*)[myHeaderView viewWithTag:i];
            @try {                
                headerCellLabel.text = [fieldName substringToIndex:3];
            }
            @catch (NSException *exception) {
                [ArcosUtils showMsg:-1 message:[NSString stringWithFormat:@"%@%@", [exception name], [exception reason]] delegate:nil];
                break;
            }
        }
//        UILabel* headerCellLabel = (UILabel*)[myHeaderView viewWithTag:16];
//        headerCellLabel.text = @"Total";
        UILabel* totalLabel = (UILabel*)[myHeaderView viewWithTag:16];
        totalLabel.text = @"Total";
        for (UIGestureRecognizer* recognizer in totalLabel.gestureRecognizers) {
            [totalLabel removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer* doubleTap12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDoubleTapGesture:)];
        doubleTap12.numberOfTapsRequired = 2;
        [totalLabel addGestureRecognizer:doubleTap12];
        [doubleTap12 release];
    } else {
        for (int i = 3; i <= 15; i++) {
            UILabel* headerCellLabel = (UILabel*)[myHeaderView viewWithTag:i];
            headerCellLabel.text = @"";
        }
        UILabel* headerCellLabel = (UILabel*)[myHeaderView viewWithTag:16];
        headerCellLabel.text = @"";
    }
    UILabel* qtyLabel = (UILabel*)[myHeaderView viewWithTag:17];
    qtyLabel.text = @"Qty";
    return myHeaderView;
}

- (void)handleHeaderDoubleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {        
        UILabel* selectedLabel = (UILabel*)recognizer.view;
        if (selectedLabel.tag == 2) {
            NSSortDescriptor* brandDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"SequenceDivider" ascending:YES] autorelease];
            NSSortDescriptor* detailsDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"SequenceNumber" ascending:YES] autorelease];
            [self.formRowsTableViewController.unsortedFormrows sortUsingDescriptors:[NSArray arrayWithObjects:brandDescriptor, detailsDescriptor, nil]];
            [self.tableView reloadData];
        } else if (selectedLabel.tag == 16) {
            [self processTotalValueOnMainList];
            BOOL ascendingFlag = NO;
            if (self.mATFormRowsTableViewController.matFormRowsDataManager.totalClickTime % 2 != 0) {
                ascendingFlag = YES;
            }
            self.mATFormRowsTableViewController.matFormRowsDataManager.totalClickTime++;
            NSSortDescriptor* totalDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"Field16" ascending:ascendingFlag selector:@selector(localizedStandardCompare:)] autorelease];
            [self.formRowsTableViewController.unsortedFormrows sortUsingDescriptors:[NSArray arrayWithObjects:totalDescriptor, nil]];
            [self.tableView reloadData];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) return nil;
    OrderPadFooterViewCell* orderPadFooterViewCell = [self.orderPadFooterViewDataManager generateTableFooterView];
    [self.orderPadFooterViewDataManager configDataWithTableFooterView:orderPadFooterViewCell];
    return orderPadFooterViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        return 44;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.formRowsTableViewController.unsortedFormrows count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSMutableDictionary* cellData = [self.formRowsTableViewController.unsortedFormrows objectAtIndex:indexPath.row];
    NSNumber* aProductIUR = [cellData objectForKey:@"ProductIUR"];
    if ([aProductIUR intValue] == 0) {
        NSString* dividerCellIdentifier = @"IdFormRowsDividerHeaderTableViewCell";
        FormRowsDividerHeaderTableViewCell* dividerCell = (FormRowsDividerHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:dividerCellIdentifier];
        if (dividerCell == nil) {
            NSArray* dividerNibContents = [[NSBundle mainBundle] loadNibNamed:@"FormRowsDividerHeaderTableViewCell" owner:self options:nil];
            for (id dividerNibItem in dividerNibContents) {
                if ([dividerNibItem isKindOfClass:[FormRowsDividerHeaderTableViewCell class]] && [[(FormRowsDividerHeaderTableViewCell *)dividerNibItem reuseIdentifier] isEqualToString:dividerCellIdentifier]) {
                    dividerCell = (FormRowsDividerHeaderTableViewCell *)dividerNibItem;
                    break;
                }
            }            
        }
        dividerCell.descLabel.text = [cellData objectForKey:@"Details"];
        return dividerCell;
    }
    if ([aProductIUR intValue] == -1) {
        NSString* subDividerCellIdentifier = @"IdFormRowsSubDividerHeaderTableViewCell";
        FormRowsSubDividerHeaderTableViewCell* subDividerCell = (FormRowsSubDividerHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:subDividerCellIdentifier];
        if (subDividerCell == nil) {
            NSArray* subDividerNibContents = [[NSBundle mainBundle] loadNibNamed:@"FormRowsSubDividerHeaderTableViewCell" owner:self options:nil];
            for (id subDividerNibItem in subDividerNibContents) {
                if ([subDividerNibItem isKindOfClass:[FormRowsSubDividerHeaderTableViewCell class]] && [[(FormRowsSubDividerHeaderTableViewCell*)subDividerNibItem reuseIdentifier] isEqualToString:subDividerCellIdentifier]) {
                    subDividerCell = (FormRowsSubDividerHeaderTableViewCell*)subDividerNibItem;
                    break;
                }
            }            
        }
        subDividerCell.descLabel.text = [cellData objectForKey:@"Details"];
        return subDividerCell;
    }
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
    
    
    cell.labelDetails.text = [cellData objectForKey:@"Details"];
    NSNumber* bonusBy = [cellData objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [cellData objectForKey:@"StockAvailable"];
    NSNumber* active = [cellData objectForKey:@"Active"];
    [ArcosUtils configDetailsColorWithLabel:cell.labelDetails active:active stockAvailable:stockAvailable bonusBy:bonusBy];
    NSString* orderPadDetailsStr = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData objectForKey:@"OrderPadDetails"]]];
    cell.orderPadDetails.text = orderPadDetailsStr;
    if (self.isShowingInStockFlag) {
        cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@]", orderPadDetailsStr, [cellData objectForKey:@"StockAvailable"]]];
        if (self.isVanSalesEnabledFlag) {
            cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@ / VAN %@]", orderPadDetailsStr, [cellData objectForKey:@"StockAvailable"], [cellData objectForKey:@"StockonHand"]]];
        }
    }
    cell.productSize.text = [cellData objectForKey:@"ProductSize"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
    } else {
        cell.productCode.text = @"";
    }
    cell.labelStock.text = [ArcosUtils convertZeroToBlank:[ArcosUtils convertNumberToIntString:[cellData objectForKey:@"StockAvailable"]]];
    
    cell.labelSRP.text = [NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitRRP"]floatValue] / 100];
    cell.labelPrice.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitPrice"]floatValue]];
    NSNumber* priceFlag = [cellData objectForKey:@"PriceFlag"];
    if ([priceFlag intValue] == 1) {
        cell.labelPrice.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else if([priceFlag intValue] == 2) {
        cell.labelPrice.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    } else {
        cell.labelPrice.textColor = [UIColor blackColor];
    }
    // Configure the cell...
    ArcosGenericClass* arcosGenericClass = [self.standardOrderPadMatDataManager.matDictHashtable objectForKey:[cellData objectForKey:@"ProductIUR"]];
    for (int i = 3; i <= 16; i++) {
        NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
        SEL selector = NSSelectorFromString(fieldMethodName);
        NSString* fieldValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:(NSString*)[arcosGenericClass performSelector:selector]]];
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
    
    
    NSNumber* qty = [cellData objectForKey:@"Qty"];
    NSNumber* bonus = [cellData objectForKey:@"Bonus"];
    if (([qty intValue]<=0 ||qty==nil)&&([bonus intValue]<=0 || bonus==nil)) {
        cell.labelQty.text=@"";
        cell.labelBon.text=@"";
    }else{
        cell.labelQty.text = [[cellData objectForKey:@"Qty"]stringValue];
        if ([[cellData objectForKey:@"Bonus"]intValue]!=0) {
            cell.labelBon.text = [[cellData objectForKey:@"Bonus"]stringValue];
        }else{
            cell.labelBon.text=@"";
        }
    }
    [cell setCellSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    return cell;
}

-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        NSMutableDictionary* cellFormRowData = [self.formRowsTableViewController.unsortedFormrows objectAtIndex:swipedIndexPath.row];
        CGRect aRect = CGRectMake(self.formRowsTableViewController.rootView.view.bounds.size.width - 10, self.formRowsTableViewController.rootView.view.bounds.size.height - 10, 1, 1);
//        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
                self.inputPopover = [self.factory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            } else {
                self.inputPopover = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            }
            
            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
            wvc.Data = cellFormRowData;
        } else {
            self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];            
            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data=cellFormRowData;
//            oipvc.showSeparator = showSeparator;
            oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
        self.inputPopover.delegate = self;
        [self.inputPopover presentPopoverFromRect:aRect inView:self.formRowsTableViewController.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
}

- (void)operationDone:(id)data {  
    [self.inputPopover dismissPopoverAnimated:YES];
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
    [self.formRowsTableViewController processDefaultQtyPercentProcessor:data];
    [self.tableView reloadData];
}

-(void)handleDoubleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        NSMutableDictionary* cellFormRowData = [self.formRowsTableViewController.unsortedFormrows  objectAtIndex:swipedIndexPath.row];
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

- (void)hideMySearchBar {
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top + self.mySearchBar.bounds.size.height) animated:NO];
}

#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.mySearchBar.showsCancelButton = NO;
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        [self.tableView reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        self.formRowsTableViewController.unsortedFormrows = [NSMutableArray arrayWithArray:self.formRowsTableViewController.originalUnsortedFormrows];
        [self.formRowsTableViewController fillTheUnsortListWithData];
        [self.tableView reloadData];
        return;
    } 
    [self.formRowsTableViewController.unsortedFormrows removeAllObjects];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Details CONTAINS[cd] %@ or ProductCode CONTAINS[cd] %@", searchText, searchText];
    NSArray* tmpArray = [self.formRowsTableViewController.originalUnsortedFormrows filteredArrayUsingPredicate:predicate];
    self.formRowsTableViewController.unsortedFormrows = [NSMutableArray arrayWithArray:tmpArray];
    [self.formRowsTableViewController fillTheUnsortListWithData];
    [self.tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.mySearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    self.formRowsTableViewController.unsortedFormrows = [NSMutableArray arrayWithArray:self.formRowsTableViewController.originalUnsortedFormrows];
    [self.formRowsTableViewController fillTheUnsortListWithData];
    [self.tableView reloadData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        @try {
            NSIndexPath* firstRowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:firstRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } @catch (NSException *exception) {
        } @finally {
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

- (void)processTotalValueOnMainList {
    for (int i = 0; i < [self.formRowsTableViewController.unsortedFormrows count]; i++) {
        NSMutableDictionary* tmpCellData = [self.formRowsTableViewController.unsortedFormrows objectAtIndex:i];
        ArcosGenericClass* arcosGenericClass = [self.standardOrderPadMatDataManager.matDictHashtable objectForKey:[tmpCellData objectForKey:@"ProductIUR"]];
        NSString* tmpTotalValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[arcosGenericClass Field16]]];
        [tmpCellData setObject:tmpTotalValue forKey:@"Field16"];
    }    
}
@end
