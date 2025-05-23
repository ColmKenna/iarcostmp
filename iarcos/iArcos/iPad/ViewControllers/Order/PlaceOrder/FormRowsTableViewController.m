//
//  FormRowsTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FormRowsTableViewController.h"
#import "ArcosCoreData.h"
#import "OrderSharedClass.h"
#import "ArcosAppDelegate_iPad.h"
#import "ArcosOrderRestoreUtils.h"

#ifndef NSFoundationVersionNumber_iOS_6_1
#define NSFoundationVersionNumber_iOS_6_1 993.00
#endif

@interface FormRowsTableViewController (Private) 


-(void)showNumberPadPopoverWithIndexPath:(NSIndexPath*)anIndexPath;
- (void)hideMySearchBar;
- (void)showMySearchBar;
@end

@implementation FormRowsTableViewController
@synthesize actionDelegate = _actionDelegate;
@synthesize dividerIUR;
@synthesize dividerName;
@synthesize tableData;
@synthesize myGroups;
@synthesize displayList;
@synthesize groupName;
@synthesize sortKeys;
@synthesize groupSelections = _groupSelections;
@synthesize descTitleLabel = _descTitleLabel;
@synthesize qtyTitleLabel = _qtyTitleLabel;
@synthesize priceTitleLabel = _priceTitleLabel;
@synthesize valueTitleLabel = _valueTitleLabel;
@synthesize discTitleLabel = _discTitleLabel;
@synthesize bonusTitleLabel = _bonusTitleLabel;
@synthesize headerView;

@synthesize isCellEditable;
//@synthesize inputPopover = _inputPopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize factory = _factory;
@synthesize unsortedFormrows;
@synthesize originalUnsortedFormrows = _originalUnsortedFormrows;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize isRequestSourceFromImageForm;
@synthesize isShowingSearchBar = _isShowingSearchBar;
@synthesize mySearchBar;
@synthesize isSearchProductTable = _isSearchProductTable;
@synthesize productSearchDataManager = _productSearchDataManager;
@synthesize isRequestSourceFromPresenter = _isRequestSourceFromPresenter;
@synthesize formRowSearchDelegate = _formRowSearchDelegate;
@synthesize isShowingTableHeaderView = _isShowingTableHeaderView;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize isShowingInStockFlag = _isShowingInStockFlag;
@synthesize formRowsTableDataManager = _formRowsTableDataManager;
@synthesize isVanSalesEnabledFlag = _isVanSalesEnabledFlag;
@synthesize isPredicativeSearchProduct = _isPredicativeSearchProduct;
@synthesize isStandardOrderPadFlag = _isStandardOrderPadFlag;
@synthesize formRowTableCellGeneratorDelegate = _formRowTableCellGeneratorDelegate;
@synthesize orderPadFooterViewDataManager = _orderPadFooterViewDataManager;
@synthesize orderPopoverGeneratorProcessorDelegate = _orderPopoverGeneratorProcessorDelegate;
@synthesize formRowsFooterMatTableViewController = _formRowsFooterMatTableViewController;
@synthesize orderPadFooterViewCell = _orderPadFooterViewCell;

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
        self.formRowsTableDataManager = [[[FormRowsTableDataManager alloc] init] autorelease];
        self.rootView = [ArcosUtils getRootView];
        self.orderPadFooterViewDataManager = [[[OrderPadFooterViewDataManager alloc] init] autorelease];
        self.formRowsTableDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        self.formRowsFooterMatTableViewController = [[[FormRowsFooterMatTableViewController alloc] initWithNibName:@"FormRowsFooterMatTableViewController" bundle:nil] autorelease];
//        if (@available(iOS 11.0, *)) {
//            [self setNeedsUpdateOfHomeIndicatorAutoHidden];
//        } else {
//            // Fallback on earlier versions
//        }
    }
    return self;
}

- (void)dealloc
{
    self.tableView.tableHeaderView = nil;
    [self.mySearchBar removeFromSuperview];
    self.mySearchBar = nil;
    self.dividerIUR = nil;
    self.dividerName = nil;
    self.myGroups = nil;
    self.displayList = nil;
    self.groupName = nil;
    self.sortKeys = nil;
    self.groupSelections = nil;
    self.tableData = nil;
    self.descTitleLabel = nil;
    self.qtyTitleLabel = nil;
    self.priceTitleLabel = nil;
    self.valueTitleLabel = nil;
    self.discTitleLabel = nil;
    self.bonusTitleLabel = nil;
    self.headerView = nil;
//    self.inputPopover = nil;
    self.globalWidgetViewController = nil;
    self.factory = nil;
    if (self.originalUnsortedFormrows != nil) { self.originalUnsortedFormrows = nil; }
    if (self.unsortedFormrows != nil) { self.unsortedFormrows = nil; }
    if (self.arcosCustomiseAnimation != nil) { self.arcosCustomiseAnimation = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.mySearchBar != nil) { self.mySearchBar = nil; }
    if (self.productSearchDataManager != nil) { self.productSearchDataManager = nil; }
    if (self.formRowSearchDelegate != nil) { self.formRowSearchDelegate = nil; }
    self.formRowsTableDataManager = nil;
    self.formRowTableCellGeneratorDelegate = nil;
    self.orderPadFooterViewDataManager = nil;
    self.orderPopoverGeneratorProcessorDelegate = nil;
    self.formRowsFooterMatTableViewController = nil;
    self.orderPadFooterViewCell = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
//    [ArcosUtils showMsg:@"System running low on memory, please close some other apps." delegate:nil];
    [ArcosUtils showDialogBox:@"System running low on memory, please close some other apps." title:@"" target:self handler:nil];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
//- (BOOL)prefersHomeIndicatorAutoHidden {
//    return YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ArcosUtils configEdgesForExtendedLayout:self];
    if (self.isCellEditable) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditTable:)];
        [self.navigationItem setRightBarButtonItem:addButton];
        [addButton release];
    }else{
        
    }
    if (self.isRequestSourceFromPresenter) {
        UIBarButtonItem* checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkout:)];
        checkoutButton.tintColor = [UIColor blackColor];
        [self.navigationItem setRightBarButtonItem:checkoutButton];
        [checkoutButton release];
        [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
        self.tableView.tableHeaderView = nil;
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
            [customNavigationBarAppearance configureWithOpaqueBackground];
            [customNavigationBarAppearance setBackgroundColor:[UIColor greenColor]];
            self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
            self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
            [customNavigationBarAppearance release];            
        }
    } else {
//        NSLog(@"setNavigationBarHidden");
        self.navigationController.navigationBarHidden = YES;
    }
    self.tableView.allowsSelection=NO;
    
    //input popover
    self.factory=[WidgetFactory factory];
    self.factory.delegate=self;
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
//        self.orderPopoverGeneratorProcessorDelegate = [[[OrderEntryInputPopoverGeneratorProcessor alloc] init] autorelease];
//    } else {
//        self.orderPopoverGeneratorProcessorDelegate = [[[OrderInputPadPopoverGeneratorProcessor alloc] init] autorelease];
//    }
    
//    self.inputPopover=[self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.inputPopover.delegate = self;
//    self.mySearchBar = [[[UISearchBar alloc]initWithFrame:CGRectMake(0,0,1024,44)] autorelease];
    
    
//    self.mySearchBar.delegate = self;
    if (self.isShowingSearchBar) {
//        NSLog(@"self.tableView.tableHeaderView = self.mySearchBar");
        self.tableView.tableHeaderView = self.mySearchBar;
    }
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
//    NSLog(@"viewWillAppear");
    if (self.formRowsTableDataManager.viewHasBeenAppearedTime == 0) {
        [self selectFirstProductRow];
        if (self.formRowsTableDataManager.currentIndexPath != nil) {
            self.formRowsTableDataManager.firstProductRowIndex = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row];
        }
    }
    self.formRowsTableDataManager.viewHasBeenAppearedTime++;
    self.formRowsTableDataManager.prevStandardOrderPadFlag = NO;
    self.formRowsTableDataManager.prevNormalStandardOrderPadFlag = NO;
    self.formRowsTableDataManager.enablePhysKeyboardFlag = NO;
    self.formRowsTableDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.formRowsTableDataManager.currentFormDetailDict objectForKey:@"Details"]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) {
        NSMutableArray* prevObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"PREVIOUS"];
        self.formRowsTableDataManager.prevNumber = [NSNumber numberWithInt:0];
        if ([prevObjectList count] > 0) {
            NSDictionary* prevDescrDetailDict = [prevObjectList objectAtIndex:0];
            NSString* prevDetail = [prevDescrDetailDict objectForKey:@"Detail"];
            NSNumber* tmpPrevNumber = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:prevDetail]]];
            if ([tmpPrevNumber intValue] >= 0 && [tmpPrevNumber intValue] <= 25) {
                self.formRowsTableDataManager.prevNumber = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:prevDetail]]];
            } else {
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Invalid previous months found.\n%@", tmpPrevNumber] title:@"" delegate:nil target:self tag:0 handler:nil];
            }
            self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellPrevRrpGenerator alloc] init] autorelease];
            self.formRowsTableDataManager.prevStandardOrderPadFlag = YES;
        } else {
            self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellRrpGenerator alloc] init] autorelease];
        }
    } else if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName] && [orderFormDetails containsString:@"[NB]"]) {
        self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellMyGenerator alloc] init] autorelease];
    } else {
        NSMutableArray* prevNormalObjectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"PREVIOUS"];
        self.formRowsTableDataManager.prevNormalNumber = [NSNumber numberWithInt:0];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPreviousMonthsInNormalOrderPadFlag] && [prevNormalObjectList count] > 0) {
            NSDictionary* prevNormalDescrDetailDict = [prevNormalObjectList objectAtIndex:0];
            NSString* prevNormalDetail = [prevNormalDescrDetailDict objectForKey:@"Detail"];
            NSNumber* tmpPrevNormalNumber = [ArcosUtils convertStringToNumber:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:prevNormalDetail]]];
            if ([tmpPrevNormalNumber intValue] >= 0 && [tmpPrevNormalNumber intValue] <= 25) {
                self.formRowsTableDataManager.prevNormalNumber = [NSNumber numberWithInt:[tmpPrevNormalNumber intValue]];
            } else {
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Invalid previous months found.\n%@", tmpPrevNormalNumber] title:@"" delegate:nil target:self tag:0 handler:nil];
            }
            self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellPrevNormalGenerator alloc] init] autorelease];
            self.formRowsTableDataManager.prevNormalStandardOrderPadFlag = YES;
        } else if ([orderFormDetails containsString:@"[KB]"]) {
            self.formRowsTableDataManager.enablePhysKeyboardFlag = YES;
            self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellKbGenerator alloc] init] autorelease];
        } else {
            self.formRowTableCellGeneratorDelegate = [[[FormRowTableCellNormalGenerator alloc] init] autorelease];
        }
    }
    self.isShowingInStockFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] showInStockFlag];
    self.isVanSalesEnabledFlag = [[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag];
    if ([ArcosSystemCodesUtils logoOptionExistence]) {
        UIImage* tmpImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
        if (tmpImage != nil) {
            self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:tmpImage] autorelease];
            self.tableView.backgroundView.alpha = 0.15;
        }
    } else {
        self.tableView.backgroundView = nil;
    }
    
    //back to root if customer changed
//    NSLog(@"Form Row viewWillAppear");
    if (self.isShowingSearchBar && self.isSearchProductTable) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveBarCodeNotification:)
                                                         name:@"BarCodeNotification"
                                                       object:nil];
        }
    }
    if (self.isNotFirstLoaded) return;
    [self reloadTableViewData];
    if (self.isShowingSearchBar) {
        self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        if (self.isSearchProductTable) {
//            NSLog(@"ProductSearchDataManager initWithTarget");
            self.formRowSearchDelegate = [[[ProductSearchDataManager alloc] initWithTarget:self] autorelease];
            [self.mySearchBar becomeFirstResponder];
//            [self.navigationController setNavigationBarHidden:YES];
        } else if (self.isPredicativeSearchProduct) {
            self.formRowSearchDelegate = [[[ProductPredictiveSearchDataManager alloc] initWithTarget:self] autorelease];
            [self.mySearchBar becomeFirstResponder];
        } else {
//            NSLog(@"FormRowCurrentListSearchDataManager initWithTarget");
            self.formRowSearchDelegate = [[[FormRowCurrentListSearchDataManager alloc] initWithTarget:self] autorelease];
        }
    } else {
        self.mySearchBar.hidden = YES;
    }
    if (!self.isNotFirstLoaded && (!self.isSearchProductTable && !self.isPredicativeSearchProduct)) {// && !self.isRequestSourceFromPresenter
//        [self scrollBehindSearchSection];
        [self hideMySearchBar];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear %ld", self.formRowsTableDataManager.currentIndexPath.row);
    if (!self.isNotFirstLoaded && self.formRowsTableDataManager.enablePhysKeyboardFlag && self.formRowsTableDataManager.currentIndexPath != nil) {
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                NSLog(@"viewDidAppear enter");
                [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } completion:^(BOOL finished) {
                NSLog(@"viewDidAppear enter process");
                OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
                self.formRowsTableDataManager.currentTextFieldIndex = 0;
                [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
            }];
        }
    }
    if (self.isRequestSourceFromPresenter) {
        
    } else {
        self.navigationController.navigationBarHidden = YES;
    }
    if (self.isNotFirstLoaded) {
        [self fillTheUnsortListWithData];
        if (@available(iOS 11.0, *)) {
            [self.tableView performBatchUpdates:^{
                NSLog(@"performBatchUpdates");
                [self reloadTableViewData];
            } completion:^(BOOL finished) {
                [self focusCurrentIndexPathTextField];
            }];
        } else {
            // Fallback on earlier versions
            [self reloadTableViewData];
        }
//        [self reloadTableViewData];
        return;
    }
    if (self.isRequestSourceFromPresenter) {
        [self requestSourceFromPresenterScrollProcessor];
    }
    if ([self.dividerIUR intValue]!=-2) {
        
    }else{
        
    }
    if (self.isRequestSourceFromImageForm) {
        
    }
    
    self.isNotFirstLoaded = YES;
}

- (void)focusCurrentIndexPathTextField {
    if (self.formRowsTableDataManager.enablePhysKeyboardFlag && self.formRowsTableDataManager.currentIndexPath != nil) {
        NSLog(@"performBatchUpdates completed");
        NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];
        BOOL indexPathVisibleFlag = NO;
        for (int i = 0; i < [indexPathsVisibleRows count]; i++) {
            NSIndexPath* tmpIndexPath = [indexPathsVisibleRows objectAtIndex:i];
            if (self.formRowsTableDataManager.currentIndexPath.row == tmpIndexPath.row) {
                indexPathVisibleFlag = YES;
                break;
            }
        }
        if (indexPathVisibleFlag) {
            OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
            if (self.formRowsTableDataManager.currentTextFieldIndex > [tmpOrderProductTableCell.textFieldList count] - 1) {
                self.formRowsTableDataManager.currentTextFieldIndex = 0;
            }
            [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
        } else {
            if ([indexPathsVisibleRows count] > 0) {
                NSIndexPath* firstIndexPath = [indexPathsVisibleRows firstObject];
                NSIndexPath* lastIndexPath = [indexPathsVisibleRows lastObject];
                if (self.formRowsTableDataManager.currentIndexPath.row < firstIndexPath.row) {
                    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
                    if (self.formRowsTableDataManager.currentTextFieldIndex > [tmpOrderProductTableCell.textFieldList count] - 1) {
                        self.formRowsTableDataManager.currentTextFieldIndex = 0;
                    }
                    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
                } else if (self.formRowsTableDataManager.currentIndexPath.row > lastIndexPath.row) {
                    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
                    if (self.formRowsTableDataManager.currentTextFieldIndex > [tmpOrderProductTableCell.textFieldList count] - 1) {
                        self.formRowsTableDataManager.currentTextFieldIndex = 0;
                    }
                    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
                }
            }
        }
    }
}

- (void)requestSourceFromPresenterScrollProcessor {
    NSNumber* lastProductIUR = [[OrderSharedClass sharedOrderSharedClass].lastPositionDict objectForKey:@"ProductIUR"];
    NSIndexPath* lastIndexPath = [[OrderSharedClass sharedOrderSharedClass].lastPositionDict objectForKey:@"IndexPath"];
    @try {
        if ([lastProductIUR intValue] != 0 && lastIndexPath != nil) {
            NSMutableDictionary* auxDataDict = [self.unsortedFormrows objectAtIndex:lastIndexPath.row];
            if ([lastProductIUR intValue] == [[auxDataDict objectForKey:@"ProductIUR"] intValue]) {
                [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    } @catch (NSException *exception) {
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isShowingSearchBar && self.isSearchProductTable) {
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarCodeNotification" object:nil];
        }
        
    }
    if (self.formRowsTableDataManager.enablePhysKeyboardFlag) {
        [self.view endEditing:YES];
    }
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
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    UIView* auxHeaderView = [self.formRowTableCellGeneratorDelegate generateTableHeaderView];
    if (self.formRowsTableDataManager.prevStandardOrderPadFlag) {
        FormRowTableHeaderView* auxPrevHeaderView = (FormRowTableHeaderView*)auxHeaderView;
        auxPrevHeaderView.prevLabel.text = [NSString stringWithFormat:@"%@ Months", self.formRowsTableDataManager.prevNumber];
    }
    if (self.formRowsTableDataManager.prevNormalStandardOrderPadFlag) {
        FormRowTableHeaderView* auxPrevHeaderView = (FormRowTableHeaderView*)auxHeaderView;
        auxPrevHeaderView.prevNormalLabel.text = [NSString stringWithFormat:@"%@ Months", self.formRowsTableDataManager.prevNormalNumber];
    }
    for (UIGestureRecognizer* recognizer in auxHeaderView.gestureRecognizers) {
        [auxHeaderView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* headerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderDoubleTapGesture:)];
    headerDoubleTap.numberOfTapsRequired = 2;
    [auxHeaderView addGestureRecognizer:headerDoubleTap];
    [headerDoubleTap release];
    return auxHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.formRowsTableDataManager.showFooterMatViewFlag) {
        return self.formRowsFooterMatTableViewController.view;
    }
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) return nil;
    [self.orderPadFooterViewDataManager configDataWithTableFooterView:self.orderPadFooterViewCell];
    return self.orderPadFooterViewCell;
//    OrderPadFooterViewCell* orderPadFooterViewCell = [self.orderPadFooterViewDataManager generateTableFooterView];
//    [self.orderPadFooterViewDataManager configDataWithTableFooterView:orderPadFooterViewCell];
//    return orderPadFooterViewCell;
}

-(void)handleHeaderDoubleTapGesture:(id)sender{    
    UITapGestureRecognizer* auxRecognizer = (UITapGestureRecognizer*)sender;
    if (auxRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.mySearchBar becomeFirstResponder];
        [self showMySearchBar];        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (!self.isShowingTableHeaderView) return 0;
//    if (self.isRequestSourceFromPresenter) return 0;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.formRowsTableDataManager.showFooterMatViewFlag) {
        return 87;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        return 44;
    }
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.unsortedFormrows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* aRow=[self.unsortedFormrows objectAtIndex:indexPath.row];
    NSNumber* aProductIUR = [aRow objectForKey:@"ProductIUR"];
    if (self.isStandardOrderPadFlag && [aProductIUR intValue] == 0) {
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
        dividerCell.descLabel.text = [aRow objectForKey:@"Details"];
//        dividerCell.backgroundColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        return dividerCell;
    }
    if (self.isStandardOrderPadFlag && [aProductIUR intValue] == -1) {
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
        subDividerCell.descLabel.text = [aRow objectForKey:@"Details"];
//        subDividerCell.backgroundColor = [UIColor colorWithRed:0.0 green:100.0/255.0 blue:0.0 alpha:1.0];
        return subDividerCell;
    }
    OrderProductTableCell* cell = [self.formRowTableCellGeneratorDelegate generateTableCellWithTableView:tableView];    
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [cell.contentView addGestureRecognizer:singleTap];
    [singleTap release];
    // Configure the cell...
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//    if (self.isRequestSourceFromPresenter) {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    //fill data for cell
    [cell needEditButton:self.isCellEditable];
    //NSString* name=[self.groupName objectAtIndex:indexPath.row];
//    NSMutableDictionary* aRow=[self.unsortedFormrows objectAtIndex:indexPath.row];
    // NSMutableDictionary* cellData=[self.displayList objectForKey:name];
    NSMutableDictionary* cellData= [NSMutableDictionary dictionaryWithDictionary:aRow];
    cell.cellDelegate = self;
    [cell configCellWithData:cellData];
    [cell configMatImageWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIUR:[cellData objectForKey:@"ProductIUR"]];
    [cell configPreviousWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIUR:[cellData objectForKey:@"ProductIUR"] previousNumber:self.formRowsTableDataManager.prevNumber prevFlag:self.formRowsTableDataManager.prevStandardOrderPadFlag prevLabel:cell.prevLabel];
    [cell configPreviousWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIUR:[cellData objectForKey:@"ProductIUR"] previousNumber:self.formRowsTableDataManager.prevNormalNumber prevFlag:self.formRowsTableDataManager.prevNormalStandardOrderPadFlag prevLabel:cell.prevNormalLabel];
    
    
    [self.unsortedFormrows replaceObjectAtIndex:indexPath.row withObject:cellData];
    cell.description.text=[cellData objectForKey:@"Details"];
    NSNumber* bonusBy = [cellData objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [cellData objectForKey:@"StockAvailable"];
    NSNumber* active = [cellData objectForKey:@"Active"];
//    if (![active boolValue]) {
//        cell.description.textColor = [UIColor colorWithRed:13.0/255.0 green:152.0/255.0 blue:186.0/255.0 alpha:0.5];
//    } else if (stockAvailable != nil && [stockAvailable intValue] == 0) {
//        cell.description.textColor = [UIColor lightGrayColor];
//    } else if ([bonusBy intValue] != 78) {
//        cell.description.textColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
//    } else {
//        cell.description.textColor = [UIColor blackColor];
//    }
    [ArcosUtils configDetailsColorWithLabel:cell.description active:active stockAvailable:stockAvailable bonusBy:bonusBy];
    cell.rrpPrice.text = [NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitRRP"]floatValue] / 100];
    cell.price.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitPrice"]floatValue]];
    NSNumber* priceFlag = [cellData objectForKey:@"PriceFlag"];
    if ([priceFlag intValue] == 1) {
//        cell.price.font = [UIFont boldSystemFontOfSize:17.0];
        cell.price.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.price.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else if([priceFlag intValue] == 2) {
//        cell.price.font = [UIFont boldSystemFontOfSize:17.0];
        cell.price.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.price.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:1.0 alpha:1.0];
    } else {
//        cell.price.font = [UIFont systemFontOfSize:17.0];
        cell.price.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        cell.price.textColor = [UIColor blackColor];
    }
    cell.orderPadDetails.text = [cellData objectForKey:@"OrderPadDetails"];
    cell.productSize.text = [cellData objectForKey:@"ProductSize"];
    if (self.isShowingInStockFlag) {
        cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@]", [cellData objectForKey:@"OrderPadDetails"], [cellData objectForKey:@"StockAvailable"]]];
        if (self.isVanSalesEnabledFlag) {
            cell.orderPadDetails.text = [ArcosUtils trim:[NSString stringWithFormat:@"%@ [Stock %@ / VAN %@]", [cellData objectForKey:@"OrderPadDetails"], [cellData objectForKey:@"StockAvailable"], [cellData objectForKey:@"StockonHand"]]];
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
    } else {
        cell.productCode.text = @"";
    }
    
        
    //qty and bonus must not be zero
    //inStock == qty split pack;foc == bonus split pack; use units qty split pack
    NSNumber* qty=[cellData objectForKey:@"Qty"];
    NSNumber* bonus=[cellData objectForKey:@"Bonus"];
    NSNumber* inStock = [cellData objectForKey:@"InStock"];
    NSNumber* units = [cellData objectForKey:@"units"];
    NSNumber* FOC = [cellData objectForKey:@"FOC"];
    
    if (([qty intValue]<=0 ||qty==nil) && ([inStock intValue]==0 || inStock == nil) && ([units intValue]==0 || units == nil) && ([bonus intValue]<=0 || bonus==nil) && ([FOC intValue]<=0 || FOC == nil)) {
        cell.qty.text=@"";
        cell.value.text=@"";
//        cell.discount.text=@"";
        cell.bonus.text=@"";
        cell.InStock.text = @"";
        cell.FOC.text = @"";
    }else{
        cell.qty.text=[ArcosUtils convertZeroToBlank:[[cellData objectForKey:@"Qty"]stringValue]];
        cell.value.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"LineValue"]floatValue]];
        
        
        if ([[cellData objectForKey:@"Bonus"]intValue]!=0) {
            cell.bonus.text=[[cellData objectForKey:@"Bonus"]stringValue];
        }else{
            cell.bonus.text=@"";
        }
        cell.InStock.text = [ArcosUtils convertZeroToBlank:[units stringValue]];
        cell.FOC.text = [ArcosUtils convertZeroToBlank:[FOC stringValue]];        
    }
    if ([[cellData objectForKey:@"DiscountPercent"]floatValue]!=0) {
        cell.discount.text=[NSString stringWithFormat:@"%1.2f%%",[[cellData objectForKey:@"DiscountPercent"]floatValue]];
    }else{
        cell.discount.text=@"";
    }
    ArcosMyResult* arcosMyResult = [[ArcosMyResult alloc] init];
    [arcosMyResult processRawData:[cellData objectForKey:@"ProductColour"]];
//    cell.uniLabel.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", arcosMyResult.uni]];
    cell.maxLabel.text = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%.2f", [arcosMyResult.max floatValue]]];
    [arcosMyResult release];
//    [cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    [cell configBackgroundColour:[[cellData objectForKey:@"IsSelected"]boolValue]];
    
    cell.theIndexPath=indexPath;
    cell.data=[self convertToOrderProductDict:cellData];
    [cell configTextFieldListWithKbFlag:self.formRowsTableDataManager.enablePhysKeyboardFlag data:cellData relatedFormDetailDict:self.formRowsTableDataManager.currentFormDetailDict];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
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
        [self.tableData removeObjectAtIndex:indexPath.row];
        [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
    }
}
/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [selectionPopover dismissPopoverAnimated:YES];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if ([self.inputPopover isPopoverVisible]) {
//        [self.inputPopover dismissPopoverAnimated:NO];
//        CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
//        [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
//
//    }
//    [self.navigationController.view setNeedsLayout];
}*/
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.presentedViewController != nil && [self.presentedViewController isKindOfClass:[WidgetViewController class]]) {
            CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
            self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
        }
    }];
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
- (IBAction) checkout:(id)sender{//redirect to the check out view
    /**
    //root tab bar
    ArcosAppDelegate_iPad *delegate = [[UIApplication sharedApplication] delegate];
    UITabBarController* tabbar=(UITabBarController*) delegate.mainTabbarController;
    //redirct to the customer pad
    tabbar.selectedIndex=4;
     */
//    CheckoutViewController* cvc = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
//    cvc.title = @"Checkout";
//    if (self.isRequestSourceFromImageForm) {
//        cvc.isRequestSourceFromImageForm = self.isRequestSourceFromImageForm;
//    }
    [self.actionDelegate didPressCheckoutButton];    
}
- (IBAction)DeleteButtonAction:(id)sender
{
	NSLog(@"delete button press");
}

-(void)showOnlySelectionItems{
    NSLog(@"show only selection pressed!");
    NSMutableDictionary* newList=[[[NSMutableDictionary alloc]init]autorelease];
    
    for(NSString* aKey in self.myGroups ){
        NSMutableDictionary* aDict=[self.myGroups objectForKey:aKey];
//        NSLog(@"adict %@",aDict);
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [newList setObject:aDict forKey:aKey];
        }
    }
    //keep full list 
    self.displayList=newList;
    [self sortGroups:self.displayList];
    [self reloadTableViewData];
}
-(void)clearAllSelections{
    self.displayList=self.myGroups;
    [self sortGroups:self.displayList];
    [self reloadTableViewData];
}

//segment button action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            
            break;
        case 1:
            
//            [selectionPopover presentPopoverFromRect:segment.bounds inView:segment permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
            
        default:
            break;
    }
    
}
-(void)showSelectedDetail:(NSMutableDictionary*)theDate{
    NSLog(@"show total selection pressed!");
    
    OrderProductDetailModelViewController* opdmvc=[[OrderProductDetailModelViewController alloc]initWithNibName:@"OrderProductDetailModelViewController" bundle:nil];
    opdmvc.delegate=self;
    opdmvc.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];
    opdmvc.theData=theDate;
    opdmvc.isViewEditable=YES;
    [self.rootView presentViewController:opdmvc animated:YES completion:nil];
    [opdmvc release];
    
}
//taps 
-(void)handleDoubleTapGesture:(id)sender{
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        OrderProductTableCell* aCell;
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        aCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        [self showSelectedDetail:(NSMutableDictionary*) aCell.data];
    }
}
-(void)handleSingleTapGesture:(id)sender{
//    NSLog(@"single tap");
    if (self.formRowsTableDataManager.enablePhysKeyboardFlag) {
        return;
    }
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    if (reconizer.state == UIGestureRecognizerStateEnded) {
        
        
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:reconizer tableview:self.tableView];
        self.formRowsTableDataManager.currentIndexPath = swipedIndexPath;
        [self showNumberPadPopoverWithIndexPath:swipedIndexPath];
    }
}

//model view delegate
- (void)didDismissModalView{
    [self.rootView dismissViewControllerAnimated:YES completion:nil];
}
- (void)savePressedWithNewData:(NSMutableDictionary*)theData{
    [self saveOrderToTheCart:theData];
    [self reloadTableViewData];
}
#pragma mark popover delegate

//popover delegate
-(void)showTotalOfSelections{
    NSLog(@"show total selection pressed!");
    
    OrderProductTotalModelViewController* optmvc=[[OrderProductTotalModelViewController alloc]initWithNibName:@"OrderProductTotalModelViewController" bundle:nil];
    optmvc.delegate=self;
    optmvc.theData=[self selectionTotal];
    

    [self.rootView presentViewController:optmvc animated:YES completion:nil];
    [optmvc release];
}

-(NSMutableDictionary*)selectionTotal{
    NSMutableDictionary* totalDict=[NSMutableDictionary dictionary];
    
    int totalProducts=0;
    float totalValue=0.0f;
    int totalPoints=0;
    float totalBonus=0.0f;
    int totalQty=0;
    
    for(NSString* aKey in self.myGroups ){
        NSMutableDictionary* aDict=[self.myGroups objectForKey:aKey];
//        NSLog(@"adict %@",aDict);
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
//input popover delegate
-(void)operationDone:(id)data{
//    [self.inputPopover dismissPopoverAnimated:YES];
    [self.rootView dismissViewControllerAnimated:YES completion:nil];
    [self saveOrderToTheCart:data];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.formRowsTableDataManager.currentFormDetailDict objectForKey:@"Details"]];
    [self processDefaultQtyPercentProcessor:data orderFormDetails:orderFormDetails];
    if (self.isRequestSourceFromPresenter) {
        if ([[data objectForKey:@"IsSelected"] boolValue]) {
            [[OrderSharedClass sharedOrderSharedClass].lastPositionDict setObject:[NSNumber numberWithInt:[[data objectForKey:@"ProductIUR"] intValue]] forKey:@"ProductIUR"];
            [[OrderSharedClass sharedOrderSharedClass].lastPositionDict setObject:[NSIndexPath indexPathForRow:self.formRowsTableDataManager.currentIndexPath.row inSection:self.formRowsTableDataManager.currentIndexPath.section] forKey:@"IndexPath"];
        } else {
            NSNumber* lastProductIUR = [[OrderSharedClass sharedOrderSharedClass].lastPositionDict objectForKey:@"ProductIUR"];
            if ([lastProductIUR intValue] != 0 && [lastProductIUR intValue] == [[data objectForKey:@"ProductIUR"] intValue]) {
                [[OrderSharedClass sharedOrderSharedClass].lastPositionDict removeAllObjects];
            }
        }
    }
    [self reloadTableViewData];
    if (self.isPredicativeSearchProduct && [self.unsortedFormrows count] == 1) {
        [self.mySearchBar becomeFirstResponder];
        self.mySearchBar.text = @"";
        self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
        [self fillTheUnsortListWithData];
        [self reloadTableViewData];
    }
}

-(void)saveOrderToTheCart:(NSMutableDictionary*)data{
    if (data==nil) {//invalid data
        return;
    }
    
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:data];
    [data setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];

}
#pragma mark sort the group
//addtional funcitons
-(void)sortGroups:(NSMutableDictionary*)aList{
    //release the old selections
//    if (self.groupSelections!=nil) {
//        [self.groupSelections removeAllObjects];
//    }
    //reinitialize the customer sections
    self.groupSelections=[[[NSMutableDictionary alloc]init] autorelease];
    
    //a temp sorted group name
    NSMutableArray* sortedGroupNameArray=nil;
    sortedGroupNameArray=[[[[aList allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]mutableCopy]autorelease];
    
    //reinitialize the sort key
    if (self.sortKeys ==nil) {
        self.sortKeys=[[[NSMutableArray alloc]init]autorelease];
    }else{
        [self.sortKeys removeAllObjects];
    }
    
    
    //get the first char of the  list
    NSString* currentChar=@"";
    if ([sortedGroupNameArray count]>0) {
        NSString* name=[sortedGroupNameArray objectAtIndex:0];
        currentChar =[name substringToIndex:1];
        //add first Char
        if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
            [self.sortKeys addObject:currentChar]; 
        }
    }
    
    //location and length used to get the sub array of customer list
    int location=0;
    int length=0;
    
    //start sorting the customer in to the sections
    for (int i=0; i<[sortedGroupNameArray count]; i++) {
        //sotring the name into the array
        NSString* name=[sortedGroupNameArray objectAtIndex:i];
        if (name==nil||[name isEqualToString:@""]) {
            name=@"Unknown Group";
        }
        
        //sorting
        length++;
        if ([currentChar isEqualToString:[name substringToIndex:1]]) {
            
        }else{
            //store the sub array of customer to the section dictionary
            NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
            [self.groupSelections setObject:tempArray forKey:currentChar];
            [tempArray release];
            //reset the location and length
            location=i+1;
            length=0;
            //get the current char
            currentChar=[name substringToIndex:1];
            //add char to sort key
            if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
                [self.sortKeys addObject:currentChar]; 
            }
        }
    }
    
    //assgin the customer names
    self.groupName=sortedGroupNameArray;
    NSLog(@"group name %@",self.groupName);
    
    NSMutableArray* tempArray=[[sortedGroupNameArray subarrayWithRange:NSMakeRange(location, length)]mutableCopy];
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [self.groupSelections setObject:tempArray forKey:currentChar];
    }
    [tempArray release];
    
    //add char to sort key
    if (currentChar!=nil && ![currentChar isEqualToString:@""]) {
        [self.sortKeys addObject:currentChar]; 
    }
    
    for (NSString* akey in self.sortKeys) {
        NSLog(@"sort key %@",akey);
    }
    
}

-(void)fillTheUnsortListWithData{
    
    for (int i=0;i<[self.unsortedFormrows count];i++) {
        NSMutableDictionary* aRow=[self.unsortedFormrows objectAtIndex:i];
        NSString* combinationkey= [NSString stringWithFormat:@"%@->%d", [aRow objectForKey:@"Details"],[[aRow objectForKey:@"ProductIUR"]intValue]];
        
        NSMutableDictionary* aDict=[[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:combinationkey];
        if (aDict!=nil) {
            [self.unsortedFormrows replaceObjectAtIndex:i withObject:aDict];
        } else {
            [ProductFormRowConverter resetFormRowFigureWithFormRowDict:aRow];
        }
    }
}
//functions
- (void)resetDividerFormRowsWithDividerIUR:(NSNumber*)anIUR withDividerName:(NSString*)name locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    self.dividerName = name;
    self.unsortedFormrows = [[ArcosCoreData sharedArcosCoreData] dividerFormRowsWithDividerIUR:anIUR formIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR locationIUR:aLocationIUR packageIUR:aPackageIUR];
        
    [self processDefaultQtyPercent:self.unsortedFormrows];
    [self processUnsortedFormRows];
}

-(void)resetDataWithDividerIUR:(NSNumber*)anIUR withDividerName:(NSString*)name locationIUR:(NSNumber*)aLocationIUR{
//    self.dividerName=name;
//
//    //get new form row list which is sort by coredata
//    self.unsortedFormrows=[[ArcosCoreData sharedArcosCoreData] formRowWithDividerIURSortByNatureOrder:anIUR withFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR locationIUR:aLocationIUR];
//    [self processDefaultQtyPercent:self.unsortedFormrows];
//    [self processUnsortedFormRows];
}

- (void)processDefaultQtyPercent:(NSMutableArray*)aFormRowDictList {
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.formRowsTableDataManager.currentFormDetailDict objectForKey:@"Details"]];
    NSMutableDictionary* restoreOrderLineKeyDict = [NSMutableDictionary dictionary];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAutosaveFlag]) {
        ArcosOrderRestoreUtils* arcosOrderRestoreUtils = [[[ArcosOrderRestoreUtils alloc] init] autorelease];
        if ([[OrderSharedClass sharedOrderSharedClass] anyOrderLine] && ![arcosOrderRestoreUtils orderRestorePlistExistent]) {
            NSArray* keyArray = [[[OrderSharedClass sharedOrderSharedClass] currentOrderCart] allKeys];
            for (int i = 0; i < [keyArray count]; i++) {
                NSString* auxKey = [keyArray objectAtIndex:i];
                [restoreOrderLineKeyDict setObject:auxKey forKey:auxKey];
            }
        }
    }
    NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
    for (int i = 0; i < [aFormRowDictList count]; i++) {
        NSMutableDictionary* orderPadFormRow = [aFormRowDictList objectAtIndex:i];
        NSString* combinationKeyContent = [orderPadFormRow objectForKey:@"CombinationKey"];
        if (combinationKeyContent == nil) {
            continue;
        }
        if ([restoreOrderLineKeyDict objectForKey:combinationKeyContent] != nil) {
            continue;
        }
        NSNumber* auxDefaultQty = [orderPadFormRow objectForKey:@"DefaultQty"];
        NSDecimalNumber* auxDefaultPercent = [orderPadFormRow objectForKey:@"DefaultPercent"];
        NSNumber* auxDiscountPercent = [orderPadFormRow objectForKey:@"DiscountPercent"];
        BOOL priceFlagBoolean = [[ArcosUtils convertNilToZero:[orderPadFormRow objectForKey:@"PriceFlag"]] intValue] == 1 && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountFromPriceFlag] && [auxDiscountPercent floatValue] != 0;
        
        if ([auxDefaultQty intValue] > 0) {
            [orderPadFormRow setObject:auxDefaultQty forKey:@"Qty"];
            
            [orderPadFormRow setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
            
            if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) && !priceFlagBoolean) {
                [orderPadFormRow setObject:auxDefaultPercent forKey:@"DiscountPercent"];
            }
            [orderPadFormRow setObject:[ProductFormRowConverter calculateLineValue:orderPadFormRow] forKey:@"LineValue"];
            [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:orderPadFormRow];
        }
        if ([auxDefaultQty intValue] == 0 && [auxDefaultPercent intValue] > 0) {
            if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) && !priceFlagBoolean) {
                [orderPadFormRow setObject:auxDefaultPercent forKey:@"DiscountPercent"];
            }
        }
    }
}

- (void)processDefaultQtyPercentProcessor:(NSMutableDictionary*)anOrderPadFormRow  orderFormDetails:(NSString*)anOrderFormDetails {
    NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
    NSNumber* auxDefaultPercent = [anOrderPadFormRow objectForKey:@"DefaultPercent"];
    NSNumber* auxPriceDiscountPercent = [anOrderPadFormRow objectForKey:@"PriceDiscountPercent"];
    BOOL priceFlagBoolean = [[ArcosUtils convertNilToZero:[anOrderPadFormRow objectForKey:@"PriceFlag"]] intValue] == 1 && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountFromPriceFlag] && [auxPriceDiscountPercent floatValue] != 0;
    NSNumber* qty=[anOrderPadFormRow objectForKey:@"Qty"];
    NSNumber* bonus=[anOrderPadFormRow objectForKey:@"Bonus"];
    NSNumber* inStock = [anOrderPadFormRow objectForKey:@"InStock"];
    NSNumber* units = [anOrderPadFormRow objectForKey:@"units"];
    NSNumber* FOC = [anOrderPadFormRow objectForKey:@"FOC"];
    
    if (([qty intValue]<=0 ||qty==nil) && ([inStock intValue]==0 || inStock == nil) && ([units intValue]==0 || units == nil) && ([bonus intValue]<=0 || bonus==nil) && ([FOC intValue]<=0 || FOC == nil)) {
        if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![anOrderFormDetails containsString:@"[BD]"]) && !priceFlagBoolean) {
            [anOrderPadFormRow setObject:[ArcosUtils convertNilToZero:auxDefaultPercent] forKey:@"DiscountPercent"];
        } else if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![anOrderFormDetails containsString:@"[BD]"]) && priceFlagBoolean) {
            [anOrderPadFormRow setObject:[ArcosUtils convertNilToZero:auxPriceDiscountPercent] forKey:@"DiscountPercent"];
        } else {
            [anOrderPadFormRow setObject:[NSNumber numberWithFloat:0] forKey:@"DiscountPercent"];
        }
    }
}

-(void)resetDataWithDividerRecordIUR:(NSNumber*)aDividerRecordIUR locationIUR:(NSNumber*)aLocationIUR packageIUR:(NSNumber*)aPackageIUR {
    self.unsortedFormrows = [[ArcosCoreData sharedArcosCoreData] formRowWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR dividerRecordIUR:aDividerRecordIUR locationIUR:aLocationIUR packageIUR:aPackageIUR];
    [self processUnsortedFormRows];
}

-(void)processUnsortedFormRows {
    [self fillTheUnsortListWithData];
    [self reloadTableViewData];
    [self syncUnsortedFormRowsWithOriginal];
}

-(void)resetDataWithFormRows:(NSMutableDictionary*)formRows{
    self.myGroups=formRows;
    self.displayList=self.myGroups;
    [self sortGroups:self.displayList];
}
-(void)clearData{
    //save selection back to the global dictionary
    if ([[OrderSharedClass sharedOrderSharedClass]anyForm]&&self.dividerName!=nil ) {
        [[OrderSharedClass sharedOrderSharedClass]setFormRows:self.myGroups ForSelection:self.dividerName];
    }
    //remove the data
    [self.myGroups removeAllObjects];
    [self reloadTableViewData];
    self.dividerIUR=[NSNumber numberWithInt:-1];
}
-(NSMutableDictionary*)convertToOrderProductDict:(NSMutableDictionary*)aDict{
    [aDict setObject: [aDict objectForKey:@"Details"]  forKey:@"Description"];
    return aDict;
}


#pragma mark - search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.formRowSearchDelegate searchBarTextDidBeginEditing:searchBar];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.formRowSearchDelegate searchBarTextDidEndEditing:searchBar];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        [self.tableView reloadData];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.formRowSearchDelegate searchBar:searchBar textDidChange:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.formRowSearchDelegate searchBarSearchButtonClicked:searchBar];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.formRowSearchDelegate searchBarCancelButtonClicked:searchBar];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
        @try {
            NSIndexPath* firstRowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:firstRowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } @catch (NSException *exception) {
        } @finally {
        }
    }    
}

//-(void)resetFormRowTableViewDataSource:(NSMutableArray*)aDataList {
//    self.unsortedFormrows = aDataList;
//    [self reloadTableViewData];
//    if ([aDataList count] == 0) {
//        [ArcosUtils showDialogBox:[GlobalSharedClass shared].noDataFoundMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
//            
//        }];
//    }
//}

- (void)resetTableViewDataSourceWithSearchText:(NSString*)aSearchText {
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.formRowsTableDataManager.currentFormDetailDict objectForKey:@"Details"]];
    self.unsortedFormrows = [self.formRowsTableDataManager retrieveTableViewDataSourceWithSearchText:aSearchText orderFormDetails:orderFormDetails];
    [self reloadTableViewData];
    if ([self.unsortedFormrows count] == 0) {
        [ArcosUtils showDialogBox:[GlobalSharedClass shared].noDataFoundMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

-(void)syncUnsortedFormRowsWithOriginal {
    if (self.isShowingSearchBar && !self.isSearchProductTable) {
        self.originalUnsortedFormrows = [NSMutableArray arrayWithArray:self.unsortedFormrows];
    }
}

//functions to be called by FormRowCurrentListSearchDataManager
-(void)currentListSearchBarSearchButtonClicked:(NSString *)searchText {
    [self.mySearchBar resignFirstResponder];
}

-(void)currentListSearchBarCancelButtonClicked {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
    [self fillTheUnsortListWithData];
    [self reloadTableViewData];
}

-(void)currentListSearchTextDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
        [self fillTheUnsortListWithData];
        [self reloadTableViewData];
        return;
    } 
    [self.unsortedFormrows removeAllObjects];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"Details CONTAINS[cd] %@ or ProductCode CONTAINS[cd] %@", searchText, searchText];
    NSArray* tmpArray = [self.originalUnsortedFormrows filteredArrayUsingPredicate:predicate];
    self.unsortedFormrows = [NSMutableArray arrayWithArray:tmpArray];
    [self fillTheUnsortListWithData];
    [self reloadTableViewData];
}

-(void)currentListSearchBarTextDidBeginEditing {
    self.mySearchBar.showsCancelButton = YES;
}

-(void)currentListSearchBarTextDidEndEditing {
    self.mySearchBar.showsCancelButton = NO;
}
#pragma mark predictive search
- (void)predictiveSearchBarTextDidBeginEditing {
    self.mySearchBar.showsCancelButton = YES;
}

- (void)predictiveSearchBarTextDidEndEditing {
    self.mySearchBar.showsCancelButton = NO;
}

- (void)predictiveSearchBarTextDidChange:(NSString *)searchText {
    if(searchText == nil || [searchText isEqualToString:@""]) {
        self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
        [self fillTheUnsortListWithData];
        [self reloadTableViewData];
        return;
    } 
    [self.unsortedFormrows removeAllObjects];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductCode BEGINSWITH[cd] %@", searchText];
    NSArray* tmpArray = [self.originalUnsortedFormrows filteredArrayUsingPredicate:predicate];
    self.unsortedFormrows = [NSMutableArray arrayWithArray:tmpArray];
    [self fillTheUnsortListWithData];
    [self reloadTableViewData];
    if ([self.unsortedFormrows count] == 1) {
        [self.mySearchBar resignFirstResponder];
        [self showNumberPadPopoverWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)predictiveSearchBarSearchButtonClicked:(NSString *)searchText {
    [self.mySearchBar resignFirstResponder];
}

- (void)predictiveSearchBarCancelButtonClicked {
    [self.mySearchBar resignFirstResponder];
    self.mySearchBar.text = @"";
    self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
    [self fillTheUnsortListWithData];
    [self reloadTableViewData];
}

- (void)reloadTableViewData {
    [self.tableView reloadData];
}

- (void)scrollBehindSearchSection {
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    /*
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    */
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        // do stuff for iOS 7 and newer
        // scroll search bar out of sight
        CGRect newBounds = self.tableView.bounds;
        if (self.tableView.bounds.origin.y < 44) {
            newBounds.origin.y = newBounds.origin.y + self.mySearchBar.bounds.size.height;
            self.tableView.bounds = newBounds;
        }
        // new for iOS 7
        if ([self.unsortedFormrows count] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:0 animated:YES];
        }
    }
    else {
        // do stuff for older versions than iOS 7
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
}

- (void)hideMySearchBar {
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top + self.mySearchBar.bounds.size.height) animated:NO];
}

- (void)showMySearchBar {
    if (self.isShowingSearchBar) {
        [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:NO];
    }    
}

#pragma mark OrderProductTableCellDelegate
- (void)displayBigProductImageWithProductCode:(NSString*)aProductCode {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = [ArcosUtils trim:aProductCode];
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
    if (self.backButtonDelegate != nil) {
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    }
}

- (void)displayProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath*)anIndexPath{    
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.productIUR = aProductIUR;
    pdvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    pdvc.productDetailDataManager.formRowDict = [self.unsortedFormrows objectAtIndex:anIndexPath.row];
    [self.navigationController pushViewController:pdvc animated:YES];
    [pdvc release];
    
    if (self.backButtonDelegate != nil) {
        [self.backButtonDelegate controlOrderFormBackButtonEvent];
    }
}

- (void)toggleShelfImageWithData:(NSMutableDictionary*)aCellData {
    NSNumber* myInStockNumber = [aCellData objectForKey:@"InStock"];
    if ([myInStockNumber intValue] == 0) {
        myInStockNumber = [NSNumber numberWithInt:1];
    } else {
        myInStockNumber = [NSNumber numberWithInt:0];
    }
    [aCellData setObject:myInStockNumber forKey:@"InStock"];
    [self saveOrderToTheCart:aCellData];
    [self reloadTableViewData];
}

- (void)configCurrentTextFieldIndex:(int)anIndex {
    self.formRowsTableDataManager.currentTextFieldIndex = anIndex;
}
- (void)configCurrentIndexPath:(NSIndexPath*)anIndexPath {
    self.formRowsTableDataManager.currentIndexPath = anIndexPath;
}
- (void)inputFinishedWithData:(NSMutableDictionary*)aData forIndexPath:(NSIndexPath*)anIndexPath {
    @try {
        [self saveOrderToTheCart:aData];
        NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.formRowsTableDataManager.currentFormDetailDict objectForKey:@"Details"]];
        [self processDefaultQtyPercentProcessor:aData orderFormDetails:orderFormDetails];
        if (self.isRequestSourceFromPresenter) {
            if ([[aData objectForKey:@"IsSelected"] boolValue]) {
                [[OrderSharedClass sharedOrderSharedClass].lastPositionDict setObject:[NSNumber numberWithInt:[[aData objectForKey:@"ProductIUR"] intValue]] forKey:@"ProductIUR"];
                [[OrderSharedClass sharedOrderSharedClass].lastPositionDict setObject:[NSIndexPath indexPathForRow:anIndexPath.row inSection:anIndexPath.section] forKey:@"IndexPath"];
            } else {
                NSNumber* lastProductIUR = [[OrderSharedClass sharedOrderSharedClass].lastPositionDict objectForKey:@"ProductIUR"];
                if ([lastProductIUR intValue] != 0 && [lastProductIUR intValue] == [[aData objectForKey:@"ProductIUR"] intValue]) {
                    [[OrderSharedClass sharedOrderSharedClass].lastPositionDict removeAllObjects];
                }
            }
        }
        NSLog(@"currentIndexPath row %ld", anIndexPath.row);
        OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:anIndexPath];
//        [tmpOrderProductTableCell configBackgroundColour:[[aData objectForKey:@"IsSelected"]boolValue]];
        NSNumber* qty = [aData objectForKey:@"Qty"];
        NSNumber* bonus = [aData objectForKey:@"Bonus"];
        if ([qty intValue] <= 0 && [bonus intValue] <= 0) {
            tmpOrderProductTableCell.qtyTextField.text = @"";
            tmpOrderProductTableCell.value.text = @"";
            tmpOrderProductTableCell.bonusTextField.text = @"";
        } else {
            tmpOrderProductTableCell.qtyTextField.text = [ArcosUtils convertZeroToBlank:[[aData objectForKey:@"Qty"] stringValue]];
            tmpOrderProductTableCell.value.text = [NSString stringWithFormat:@"%1.2f", [[aData objectForKey:@"LineValue"] floatValue]];
            tmpOrderProductTableCell.bonusTextField.text = [ArcosUtils convertZeroToBlank:[[aData objectForKey:@"Bonus"] stringValue]];
        }
        float discountPercentValue = [[aData objectForKey:@"DiscountPercent"] floatValue];
        if (discountPercentValue != 0) {
            tmpOrderProductTableCell.discTextField.text = [NSString stringWithFormat:@"%1.2f", discountPercentValue];
        } else {
            tmpOrderProductTableCell.discTextField.text = @"";
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showRunningTotalFlag]) {
            [self.orderPadFooterViewDataManager configDataWithTableFooterView:self.orderPadFooterViewCell];
        }        
    } @catch (NSException *exception) {
        NSLog(@"inputFinishedWithData %@", [exception reason]);
    }
    
//    [self reloadTableViewData];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.formRowsTableDataManager.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    if (self.isPredicativeSearchProduct && [self.unsortedFormrows count] == 1) {
//        [self.mySearchBar becomeFirstResponder];
//        self.mySearchBar.text = @"";
//        self.unsortedFormrows = [NSMutableArray arrayWithArray:self.originalUnsortedFormrows];
//        [self fillTheUnsortListWithData];
//        [self reloadTableViewData];
//    }
}
- (NSNumber*)retrieveCurrentTextFieldValueWithTag:(int)aTag forIndexPath:(NSIndexPath*)anIndexPath forCartKey:(NSString *)aCartKey {
    NSMutableDictionary* tmpDataDict = [self.unsortedFormrows objectAtIndex:anIndexPath.row];
    NSString* textFieldKey = [self.formRowsTableDataManager.textFieldTagKeyDict objectForKey:[NSNumber numberWithInt:aTag]];
    return [tmpDataDict objectForKey:textFieldKey];
}
- (int)retrieveCurrentTextFieldIndex {
    return self.formRowsTableDataManager.currentTextFieldIndex;
}
- (void)configCurrentTextFieldHighlightedFlag:(BOOL)aFlag {
    self.formRowsTableDataManager.currentTextFieldHighlightedFlag = aFlag;
}
- (BOOL)retrieveCurrentTextFieldHighlightedFlag {
    return self.formRowsTableDataManager.currentTextFieldHighlightedFlag;
}
- (NSIndexPath*)retrieveCurrentIndexPath {
    return self.formRowsTableDataManager.currentIndexPath;
}
- (int)retrieveViewHasBeenAppearedTime {
    return self.formRowsTableDataManager.viewHasBeenAppearedTime;
}
- (int)retrieveFirstProductRowIndex {
    return self.formRowsTableDataManager.firstProductRowIndex;
}
- (BOOL)retrieveFirstProductRowHasBeenShowedFlag {
    return self.formRowsTableDataManager.firstProductRowHasBeenShowedFlag;
}
- (void)configFirstProductRowHasBeenShowedFlag:(BOOL)aFlag {
    self.formRowsTableDataManager.firstProductRowHasBeenShowedFlag = aFlag;
}
- (void)showFooterMatDataWithIndexPath:(NSIndexPath*)anIndexPath {
    if (!self.formRowsTableDataManager.showFooterMatViewFlag) return;
    NSMutableDictionary* aRow = [self.unsortedFormrows objectAtIndex:anIndexPath.row];
    NSNumber* aProductIUR = [aRow objectForKey:@"ProductIUR"];
    [self.formRowsFooterMatTableViewController.formRowsFooterMatDataManager retrieveFooterMatDataWithProductIUR:aProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [self.formRowsFooterMatTableViewController.tableView reloadData];
}
- (UIViewController*)retrieveOrderProductParentViewController {
    return self;
}
- (NSIndexPath*)recalculateIndexPathWithCurrentIndexPath:(NSIndexPath*)anIndexPath cartKey:(NSString*)aCartKey {
    return anIndexPath;
}
- (UIColor*)retrieveCellBackgroundColourWithSelectedFlag:(NSNumber*)aSelectedFlag {
    if ([aSelectedFlag boolValue]) {
        return [UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:.2];
    } else {
        return [UIColor whiteColor];
    }
}

-(void)showNumberPadPopoverWithIndexPath:(NSIndexPath*)anIndexPath {
    OrderProductTableCell* aCell = nil;
    aCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:anIndexPath];
    CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
//    BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
//        self.orderPopoverGeneratorProcessorDelegate = [[[OrderEntryInputPopoverGeneratorProcessor alloc] init] autorelease];
//    } else {
//        self.orderPopoverGeneratorProcessorDelegate = [[[OrderInputPadPopoverGeneratorProcessor alloc] init] autorelease];
//    }
//    self.inputPopover = [self.orderPopoverGeneratorProcessorDelegate createOrderPopoverWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR factory:self.factory];
//    self.inputPopover.delegate = self;
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
        if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
            self.globalWidgetViewController = [self.factory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        } else {
            self.globalWidgetViewController = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        }        
//        WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
//        self.globalWidgetViewController.Data = aCell.data;
        OrderEntryInputViewController* oeivc = (OrderEntryInputViewController*)self.globalWidgetViewController;
        oeivc.Data = aCell.data;
        oeivc.orderEntryInputDataManager.relatedFormDetailDict = self.formRowsTableDataManager.currentFormDetailDict;
    } else {
//        self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//        OrderInputPadViewController* oipvc = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        self.globalWidgetViewController = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*)self.globalWidgetViewController;
//        OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
        oipvc.Data=aCell.data;
//        oipvc.showSeparator = showSeparator;
        oipvc.relatedFormDetailDict = self.formRowsTableDataManager.currentFormDetailDict;
//        [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
        if (!arcosErrorResult.successFlag) {
            [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
//    self.inputPopover.delegate = self;
    
//    [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.rootView.view;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [self.rootView presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

- (void)receiveBarCodeNotification:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString* barcode = [userInfo objectForKey:@"BarCode"];
    self.mySearchBar.text = barcode;
    [self.formRowSearchDelegate searchBarSearchButtonClicked:self.mySearchBar];
    if (self.presentedViewController != nil && [self.presentedViewController isKindOfClass:[WidgetViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    if ([self.inputPopover isPopoverVisible]) {
//        [self.inputPopover dismissPopoverAnimated:YES];
//    }
    if ([self.unsortedFormrows count] > 0) {
        [self showNumberPadPopoverWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
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

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)selectFirstProductRow {
    for (int i = 0; i < [self.unsortedFormrows count]; i++) {
        NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
        NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
        if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
            continue;
        }
        self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        break;
    }
}

- (void)processCurrentTextFieldIndexIfNotReachable:(OrderProductTableCell*)anOrderProductTableCell {
    if (self.formRowsTableDataManager.currentTextFieldIndex == 1) {
        if (!anOrderProductTableCell.bonusTextField.enabled) {
            self.formRowsTableDataManager.currentTextFieldIndex = 0;
        } else {
            NSMutableDictionary* tmpCellData = [self.unsortedFormrows objectAtIndex:self.formRowsTableDataManager.currentIndexPath.row];;
            if (!anOrderProductTableCell.bonusTextField.hidden && anOrderProductTableCell.bonusTextField.enabled && [[ArcosConfigDataManager sharedArcosConfigDataManager] disableBonusBoxWithPriceRecordFlag] && ([[tmpCellData objectForKey:@"PriceFlag"] intValue] == 1 || [[tmpCellData objectForKey:@"PriceFlag"] intValue] == 2)) {
                self.formRowsTableDataManager.currentTextFieldIndex = 0;
            }
        }
    }
}

- (void)moveDownOneRow:(id)sender {
    NSLog(@"moveDownOneRow key %ld", self.formRowsTableDataManager.currentIndexPath.row);
    if (self.formRowsTableDataManager.currentIndexPath == nil) {
        [self selectFirstProductRow];
    } else {
        if (self.formRowsTableDataManager.currentIndexPath.row + 1 < [self.unsortedFormrows count]) {
            for (int i = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row] + 1; i < [self.unsortedFormrows count]; i++) {
                NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
                NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
                if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
                    continue;
                }
                self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    if (self.formRowsTableDataManager.currentIndexPath == nil) return;
    
//    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];
    if ([indexPathsVisibleRows count] > 0) {
        NSIndexPath* bottomIndexPath = [indexPathsVisibleRows lastObject];
        if (self.formRowsTableDataManager.currentIndexPath.row > bottomIndexPath.row) {
            NSLog(@"moveDown bottom");
            [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    NSLog(@"move down %ld", self.formRowsTableDataManager.currentIndexPath.row);
    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
    [self processCurrentTextFieldIndexIfNotReachable:tmpOrderProductTableCell];
    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
}

- (void)moveUpOneRow:(id)sender {
    NSLog(@"moveUpOneRow key");
    if (self.formRowsTableDataManager.currentIndexPath == nil) {
        [self selectFirstProductRow];
    } else {
        if ((self.formRowsTableDataManager.currentIndexPath.row - 1) >= 0) {
            for (int i = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row] - 1; i >= 0; i--) {
                NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
                NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
                if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
                    continue;
                }
                self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }

    if (self.formRowsTableDataManager.currentIndexPath == nil) return;
//    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];    
    if ([indexPathsVisibleRows count] > 0) {
        NSIndexPath* topIndexPath = [indexPathsVisibleRows objectAtIndex:0];
        if (self.formRowsTableDataManager.currentIndexPath.row < topIndexPath.row) {
            NSLog(@"moveUp top");
            [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
    [self processCurrentTextFieldIndexIfNotReachable:tmpOrderProductTableCell];
    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
}

- (void)moveRightOneField:(id)sender {
    NSLog(@"moveRightOneField key");

    if (self.formRowsTableDataManager.currentIndexPath == nil) {
        [self selectFirstProductRow];
    }
    if (self.formRowsTableDataManager.currentIndexPath == nil) return;
//    [self.tableView selectRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
    if (self.formRowsTableDataManager.currentTextFieldIndex < [tmpOrderProductTableCell.textFieldList count] - 1) {
        [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex + 1] becomeFirstResponder];
    } else if (self.formRowsTableDataManager.currentTextFieldIndex == [tmpOrderProductTableCell.textFieldList count] - 1) {
        if (self.formRowsTableDataManager.currentIndexPath.row + 1 < [self.unsortedFormrows count]) {
            for (int i = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row] + 1; i < [self.unsortedFormrows count]; i++) {
                NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
                NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
                if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
                    continue;
                }
                self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
        self.formRowsTableDataManager.currentTextFieldIndex = 0;
        OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
        [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
    } else {
        [[tmpOrderProductTableCell.textFieldList objectAtIndex:0] becomeFirstResponder];
    }
}

- (void)moveLeftOneField:(id)sender {
    NSLog(@"moveLeftOneField key");

    if (self.formRowsTableDataManager.currentIndexPath == nil) {
        [self selectFirstProductRow];
    }

//    [self.tableView selectRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
    if (self.formRowsTableDataManager.currentTextFieldIndex > 0) {
        [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex - 1] becomeFirstResponder];
    } else {
        [[tmpOrderProductTableCell.textFieldList lastObject] becomeFirstResponder];
    }
}

- (void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(nullable UIPressesEvent *)event {
    [super pressesEnded:presses withEvent:event];
    @try {
        if (!self.formRowsTableDataManager.enablePhysKeyboardFlag) {
            return;
        }
        for (UIPress* aPress in presses) {
            if (aPress.key.modifierFlags == UIKeyModifierAlternate) {
                NSLog(@"UIKeyModifierAlternate");
                if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardS) {
                    self.formRowsTableDataManager.searchBarFocusedByShortCutFlag = YES;
                    self.formRowsTableDataManager.currentIndexPath = nil;
                    self.formRowsTableDataManager.currentTextFieldIndex = 0;
                    [self showMySearchBar];
                    [self.mySearchBar becomeFirstResponder];
                    self.mySearchBar.text = @"";
                    return;
                }
                // || (self.formRowsTableDataManager.currentIndexPath == nil && !self.formRowsTableDataManager.searchBarFocusedByShortCutFlag)
                if ([self.unsortedFormrows count] == 0) {
                    return;
                }
                if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardUpArrow) {
                    if (self.formRowsTableDataManager.currentIndexPath == nil || [self.mySearchBar isFirstResponder]) {
                        return;
                    }
                    NSLog(@"page up");
                    int rowNumber = 0;
                    int nextRowNumber = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row] - 15;
                    if (nextRowNumber > rowNumber) {
                        rowNumber = nextRowNumber;
                    }
                    for (int i = rowNumber; i < self.formRowsTableDataManager.currentIndexPath.row; i++) {
                        NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
                        NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
                        if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
                            continue;
                        }
                        self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        break;
                    }
                    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
                    [self processCurrentTextFieldIndexIfNotReachable:tmpOrderProductTableCell];
                    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
                    NSLog(@"page up %ld", self.formRowsTableDataManager.currentIndexPath.row);
                } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardDownArrow) {
                    NSLog(@"page down");
                    if (self.formRowsTableDataManager.currentIndexPath == nil || [self.mySearchBar isFirstResponder]) {
                        return;
                    }
                    int rowNumber = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.unsortedFormrows count] - 1];
                    int nextRowNumber = [ArcosUtils convertNSIntegerToInt:self.formRowsTableDataManager.currentIndexPath.row] + 15;
                    if (nextRowNumber < rowNumber) {
                        rowNumber = nextRowNumber;
                    }
                    for (int i = rowNumber; i > self.formRowsTableDataManager.currentIndexPath.row; i--) {
                        NSMutableDictionary* tmpCellDataDict = [self.unsortedFormrows objectAtIndex:i];
                        NSNumber* tmpProductIUR = [tmpCellDataDict objectForKey:@"ProductIUR"];
                        if (self.isStandardOrderPadFlag && ([tmpProductIUR intValue] == 0 || [tmpProductIUR intValue] == -1)) {
                            continue;
                        }
                        self.formRowsTableDataManager.currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        break;
                    }
                    [self.tableView scrollToRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    OrderProductTableCell* tmpOrderProductTableCell = (OrderProductTableCell*)[self.tableView cellForRowAtIndexPath:self.formRowsTableDataManager.currentIndexPath];
                    [self processCurrentTextFieldIndexIfNotReachable:tmpOrderProductTableCell];
                    [[tmpOrderProductTableCell.textFieldList objectAtIndex:self.formRowsTableDataManager.currentTextFieldIndex] becomeFirstResponder];
                    NSLog(@"page down %ld", self.formRowsTableDataManager.currentIndexPath.row);
                }
            } else {
                if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardReturnOrEnter || aPress.key.keyCode == UIKeyboardHIDUsageKeyboardDownArrow) {
                    NSLog(@"moveDownOneRow pressed");
                    if (self.formRowsTableDataManager.searchBarFocusedByShortCutFlag || [self.mySearchBar isFirstResponder]) {
                        if ([self.mySearchBar isFirstResponder]) {
                            [self.mySearchBar resignFirstResponder];
                        }
                        self.formRowsTableDataManager.searchBarFocusedByShortCutFlag = NO;
                    }
                    [self moveDownOneRow:nil];
                } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardUpArrow) {
                    if (self.formRowsTableDataManager.currentIndexPath == nil || [self.mySearchBar isFirstResponder]) {
                        return;
                    }
                    [self moveUpOneRow:nil];
                } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardLeftArrow) {
                    if (self.formRowsTableDataManager.currentIndexPath == nil || [self.mySearchBar isFirstResponder]) {
                        return;
                    }
                    [self moveLeftOneField:nil];
                } else if (aPress.key.keyCode == UIKeyboardHIDUsageKeyboardRightArrow) {
                    if (self.formRowsTableDataManager.currentIndexPath == nil || [self.mySearchBar isFirstResponder]) {
                        return;
                    }
                    [self moveRightOneField:nil];
                } else {
                    
                }
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"pressesEnded %@", [exception reason]);
    }
}

//- (NSArray*)keyCommands {
//    return @[[UIKeyCommand keyCommandWithInput:UIKeyInputEscape modifierFlags:0 action:@selector(tabKeyPressed:)]];
//    return @[[UIKeyCommand keyCommandWithInput:@"\t" modifierFlags:0 action:@selector(tabKeyPressed:)]];
//    return @[[UIKeyCommand commandWithTitle:@"Tab" image:nil action:@selector(tabKeyPressed:) input:@"\t" modifierFlags:0 propertyList:nil]];
//}

//- (void)tabKeyPressed:(id)sender {
//    NSLog(@"Tab Key Pressed");
//}

- (void)reloadTableViewFooterData {
    if (@available(iOS 11.0, *)) {
        [self.tableView performBatchUpdates:^{
            if (self.formRowsTableDataManager.showFooterMatViewFlag) {
                self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
            } else {
                self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            [self reloadTableViewData];
        } completion:^(BOOL finished) {
            [self focusCurrentIndexPathTextField];
        }];
    } else {
        // Fallback on earlier versions
        
    }
}


@end
