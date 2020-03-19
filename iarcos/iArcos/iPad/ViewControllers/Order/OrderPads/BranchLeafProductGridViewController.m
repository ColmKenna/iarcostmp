//
//  BranchLeafProductGridViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/08/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "BranchLeafProductGridViewController.h"
#import "ArcosRootViewController.h"
@interface BranchLeafProductGridViewController ()
- (void)alignSubviewsWillAppear;
- (void)alignSubviews;
- (void)alignBottomSubviews;
- (void)alignPageIndexSubView;
- (void)formrowListSelectSmallTemplateViewItemWithData:(NSMutableDictionary*)aCellDataDict;
- (NSMutableDictionary*)retrieveProductDictWithIndex:(NSIndexPath*)anIndexPath;
- (void)productListWithLeafLxCode:(NSString*)anLeafLxCode;
- (int)retrieveStatusBarHeight;
@end

@implementation BranchLeafProductGridViewController
@synthesize baseScrollContentView = _baseScrollContentView;
@synthesize numberInputPadViewController = _numberInputPadViewController;
@synthesize isNumberInputPadViewShowing = _isNumberInputPadViewShowing;
@synthesize myTableView = _myTableView;
@synthesize branchLeafProductDataManager = _branchLeafProductDataManager;
@synthesize leafSmallTemplateViewController = _leafSmallTemplateViewController;
@synthesize slideUpViewHeight = _slideUpViewHeight;
@synthesize isSlideUpViewShowing = _isSlideUpViewShowing;
@synthesize pageIndexViewController = _pageIndexViewController;
@synthesize isPageIndexViewShowing = _isPageIndexViewShowing;
@synthesize inputPopover = _inputPopover;
@synthesize factory = _factory;
@synthesize rootView = _rootView;
@synthesize navigationTitleDelegate = _navigationTitleDelegate;
@synthesize backButtonDelegate = _backButtonDelegate;
@synthesize discountAllowedNumber = _discountAllowedNumber;
@synthesize showSeparator = _showSeparator;
@synthesize isLeafSmallHidden = _isLeafSmallHidden;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.discountAllowedNumber = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
        self.showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        self.leafSmallTemplateViewController = [[[LeafSmallTemplateViewController alloc] initWithNibName:@"LeafSmallTemplateViewController" bundle:nil] autorelease];
        self.leafSmallTemplateViewController.delegate = self;
        self.numberInputPadViewController = [[[NumberInputPadViewController alloc] initWithNibName:@"NumberInputPadViewController" bundle:nil] autorelease];
        self.numberInputPadViewController.funcDelegate = self;
        self.numberInputPadViewController.showSeparator = self.showSeparator;
        self.numberInputPadViewController.discountAllowedNumber = self.discountAllowedNumber;
        self.branchLeafProductDataManager = [[[BranchLeafProductDataManager alloc] init] autorelease];
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
//        self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//        self.inputPopover.delegate = self;
        self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
        
    }
    return self;
}

- (void)dealloc {
    if (self.baseScrollContentView != nil) { self.baseScrollContentView = nil; }    
    if (self.numberInputPadViewController != nil) { self.numberInputPadViewController = nil; }
    if (self.myTableView != nil) { self.myTableView = nil; }
    if (self.branchLeafProductDataManager != nil) { self.branchLeafProductDataManager = nil; }
    if (self.leafSmallTemplateViewController != nil) {
        self.leafSmallTemplateViewController = nil;
    }
    if (self.pageIndexViewController != nil) { self.pageIndexViewController = nil; }
    if (self.inputPopover != nil) { self.inputPopover = nil; }
    if (self.factory != nil) { self.factory = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    if (self.discountAllowedNumber != nil) { self.discountAllowedNumber = nil; }
    
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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.slideUpViewHeight = [GlobalSharedClass shared].slideUpViewHeight;
    if (self.isLeafSmallHidden) {
        self.slideUpViewHeight = 0;
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
//    self.discountAllowedNumber = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
//    self.showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
//    self.numberInputPadViewController.showSeparator = self.showSeparator;
//    self.numberInputPadViewController.discountAllowedNumber = self.discountAllowedNumber;
    [self.view addSubview:self.numberInputPadViewController.view];
    [self.numberInputPadViewController viewWillAppear:animated];
    if (!self.isNumberInputPadViewShowing) {        
        self.isNumberInputPadViewShowing = YES;
    }
//    [self alignSubviews];
    [self alignSubviewsWillAppear];
    if (self.isSlideUpViewShowing && self.leafSmallTemplateViewController.leafSmallTemplateDataManager.selectedIndexPath != nil) {
        NSMutableArray* subsetDisplayList = [self.leafSmallTemplateViewController.leafSmallTemplateDataManager.pagedDisplayList objectAtIndex:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.selectedIndexPath.section];
        NSMutableDictionary* cellDataDict = [subsetDisplayList objectAtIndex:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.selectedIndexPath.row];
        [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:[cellDataDict objectForKey:@"Detail"]];
    }
    [self showLeafSmallTableViewController:YES];
    [self.leafSmallTemplateViewController viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self alignSubviews];
    [self showLeafSmallTableViewController:NO];
    [self alignBottomSubviews];
    [self.leafSmallTemplateViewController viewDidAppear:YES];
    if (!self.isSlideUpViewShowing) {        
        [self.leafSmallTemplateViewController.leafSmallTemplateDataManager createPageIndexList:self.branchLeafProductDataManager.formTypeNumber];
        self.pageIndexViewController = [[[LeafSmallTemplatePageIndexViewController alloc] initWithNibName:@"LeafSmallTemplatePageIndexViewController" bundle:nil] autorelease];
        self.pageIndexViewController.pageIndexDelegate = self;
        self.pageIndexViewController.displayList = self.leafSmallTemplateViewController.leafSmallTemplateDataManager.pageIndexList;
        self.isSlideUpViewShowing = YES;
    }
    
    [self showPageIndexView];
    if (!self.isPageIndexViewShowing) {        
        self.isPageIndexViewShowing = YES;
    }
    [self alignPageIndexSubView];    
//    NSLog(@"abc: %@", self.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList);
    
    [self syncTableViewData];
    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.numberInputPadViewController.view removeFromSuperview];
    [self.leafSmallTemplateViewController.view removeFromSuperview];
    [self.pageIndexViewController.view removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self alignSubviews];
    [self alignBottomSubviews];
    [self alignPageIndexSubView];
    [self.leafSmallTemplateViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self.pageIndexViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    if ([self.inputPopover isPopoverVisible]) {
        [self.inputPopover dismissPopoverAnimated:NO];
        CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
        [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)alignSubviewsWillAppear {
    if (self.isNumberInputPadViewShowing) {
        CGRect numberInputPadFrame = CGRectMake(self.rootView.selectedRightViewController.view.bounds.size.width - 204, 0, 204, self.baseScrollContentView.bounds.size.height);
        int statusBarLength = [self retrieveStatusBarHeight];
        int headerHeight = statusBarLength + self.navigationController.navigationBar.frame.size.height;
        self.numberInputPadViewController.view.frame = numberInputPadFrame;
        self.numberInputPadViewController.inStockTitle.frame = CGRectMake(self.numberInputPadViewController.inStockTitle.frame.origin.x, self.rootView.selectedRightViewController.view.bounds.size.height - headerHeight - self.slideUpViewHeight - 30, self.numberInputPadViewController.inStockTitle.frame.size.width, self.numberInputPadViewController.inStockTitle.frame.size.height);
        self.numberInputPadViewController.inStockValue.frame = CGRectMake(self.numberInputPadViewController.inStockValue.frame.origin.x, self.rootView.selectedRightViewController.view.bounds.size.height - headerHeight - self.slideUpViewHeight - 30, self.numberInputPadViewController.inStockValue.frame.size.width, self.numberInputPadViewController.inStockValue.frame.size.height);
    }
    CGRect myTableFrame = CGRectMake(0, 0, self.myTableView.bounds.size.width, self.baseScrollContentView.bounds.size.height - self.slideUpViewHeight);
    self.myTableView.frame = myTableFrame;
}

- (void)alignSubviews {
    if (self.isNumberInputPadViewShowing) {
        CGRect numberInputPadFrame = CGRectMake(self.myTableView.bounds.size.width + 1, 0, 204, self.baseScrollContentView.bounds.size.height);
//        CGRect numberInputPadFrame = CGRectMake(self.rootView.selectedRightViewController.view.bounds.size.width - 204, 0, 204, self.baseScrollContentView.bounds.size.height);
        self.numberInputPadViewController.view.frame = numberInputPadFrame;
        self.numberInputPadViewController.inStockTitle.frame = CGRectMake(self.numberInputPadViewController.inStockTitle.frame.origin.x, self.baseScrollContentView.bounds.size.height - self.slideUpViewHeight - 30, self.numberInputPadViewController.inStockTitle.frame.size.width, self.numberInputPadViewController.inStockTitle.frame.size.height);
        self.numberInputPadViewController.inStockValue.frame = CGRectMake(self.numberInputPadViewController.inStockValue.frame.origin.x, self.baseScrollContentView.bounds.size.height - self.slideUpViewHeight - 30, self.numberInputPadViewController.inStockValue.frame.size.width, self.numberInputPadViewController.inStockValue.frame.size.height);
    }
    CGRect myTableFrame = CGRectMake(0, 0, self.myTableView.bounds.size.width, self.baseScrollContentView.bounds.size.height - self.slideUpViewHeight);
    self.myTableView.frame = myTableFrame;
}

- (void)alignBottomSubviews {
    if (self.isSlideUpViewShowing) {
        CGRect slideUpViewFrame = CGRectMake(0, self.baseScrollContentView.bounds.size.height, self.baseScrollContentView.bounds.size.width, self.slideUpViewHeight);
        if (self.isSlideUpViewShowing) {
            slideUpViewFrame.origin.y -= slideUpViewFrame.size.height;
        } else {
            slideUpViewFrame.origin.y += slideUpViewFrame.size.height;
        }
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
    }
}

- (void)alignPageIndexSubView {
    if (self.isPageIndexViewShowing) {
        CGRect pageIndexViewFrame = CGRectMake(self.baseScrollContentView.bounds.size.width - self.pageIndexViewController.pageIndexViewWidth, 0, self.pageIndexViewController.pageIndexViewWidth, self.baseScrollContentView.bounds.size.height);
        self.pageIndexViewController.view.frame = pageIndexViewFrame;
//         NSLog(@"alignPageIndexSubView: %@",NSStringFromCGRect(self.pageIndexViewController.view.frame));
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return 1;
    return [self.branchLeafProductDataManager.productSectionDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    if (self.branchLeafProductDataManager.displayList != nil) {
//        return [self.branchLeafProductDataManager.displayList count];
//    }
//    return 0;
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    return [aSectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdBranchLeafProductGridListTableViewCell";
    
    BranchLeafProductGridListTableViewCell *cell=(BranchLeafProductGridListTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"BranchLeafProductGridTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[BranchLeafProductGridListTableViewCell class]] && [[(BranchLeafProductGridListTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (BranchLeafProductGridListTableViewCell *) nibItem;
                break;
            }    
            
        }
        
	}
    
    //fill the data for cell
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.cellDelegate = self;
    cell.indexPath = indexPath;
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:indexPath.section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    NSMutableDictionary* productDetailDict = [aSectionArray objectAtIndex:indexPath.row];
    [cell configToShowSplitPack:self.showSeparator];
    [cell configToShowDiscBonus:self.discountAllowedNumber];
    [cell configCellWithData:productDetailDict];
    if (self.branchLeafProductDataManager.selectedIndexPath != nil && self.branchLeafProductDataManager.selectedIndexPath.row == indexPath.row && self.branchLeafProductDataManager.selectedIndexPath.section == indexPath.section) {
        [tableView selectRowAtIndexPath:self.branchLeafProductDataManager.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }    
//    [cell configSelectedImageView:self.branchLeafProductDataManager.selectedIndexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.branchLeafProductDataManager.selectedIndexPath = indexPath;
    [self.numberInputPadViewController resetFuncBtn];
    NSMutableDictionary* tmpProductDict = [self retrieveProductDictWithIndex:indexPath];
    self.numberInputPadViewController.inStockValue.text = [ArcosUtils convertNumberToIntString:[tmpProductDict objectForKey:@"StockAvailable"]];
    
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:indexPath.section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    NSMutableDictionary* cellDataDict = [aSectionArray objectAtIndex:indexPath.row];
    NSNumber* bonusBy = [cellDataDict objectForKey:@"Bonusby"];
    NSNumber* stockAvailable = [cellDataDict objectForKey:@"StockAvailable"];
    if (stockAvailable != nil && [stockAvailable intValue] == 0) {
        cell.backgroundColor = [UIColor lightGrayColor];
    } else if ([bonusBy intValue] != 78) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}
*/
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if ([self.branchLeafProductDataManager.sortKeyList count] <= 1) {
//        return nil;
//    }
    if (self.branchLeafProductDataManager.formTypeNumber == [[GlobalSharedClass shared].formRowFormTypeNumber intValue]) {
        return nil;
    }
    return self.branchLeafProductDataManager.sortKeyList;
}

- (void)showLeafSmallTableViewController:(BOOL)aFlag {
    if (self.isLeafSmallHidden) return;
    if (aFlag) {
        int statusBarHeight = [self retrieveStatusBarHeight];
        CGRect slideUpViewFrame = CGRectMake(0, self.rootView.selectedRightViewController.view.bounds.size.height - statusBarHeight - self.navigationController.navigationBar.frame.size.height - self.slideUpViewHeight, self.rootView.selectedRightViewController.view.bounds.size.width, self.slideUpViewHeight);
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
        [self.view addSubview:self.leafSmallTemplateViewController.view];
    } else {
        CGRect slideUpViewFrame = CGRectMake(0, self.baseScrollContentView.bounds.size.height - self.slideUpViewHeight, self.baseScrollContentView.bounds.size.width, self.slideUpViewHeight);
        self.leafSmallTemplateViewController.view.frame = slideUpViewFrame;
    }
}

- (void)showPageIndexView {
    if (self.isLeafSmallHidden) return;
    CGRect pageIndexViewFrame = CGRectMake(self.baseScrollContentView.bounds.size.width - self.pageIndexViewController.pageIndexViewWidth, 0, self.pageIndexViewController.pageIndexViewWidth, self.baseScrollContentView.bounds.size.height);
    self.pageIndexViewController.view.frame = pageIndexViewFrame;
    [self.view addSubview:self.pageIndexViewController.view];
//    NSLog(@"showPageIndexView: %@",NSStringFromCGRect(self.pageIndexViewController.view.frame));
}

#pragma mark NumberInputPadViewDelegate 
- (void)numberInputPadWithFuncBtn:(UIButton*)aFuncBtn {
//    NSLog(@"abcdef %d", aFuncBtn.tag);
//    [self.myTableView reloadData];
//    [self.leafSmallTemplateViewController jumpToSpecificPage:1];
}

- (void)numberInputPadWithNumberBtn:(UIButton *)aNumberBtn funcBtn:(UIButton *)aFuncBtn {
//    NSLog(@"numberInputPadWithNumberBtn: %d %d", aNumberBtn.tag, aFuncBtn.tag);
//    self.branchLeafProductDataManager.selectedIndexPath
    if (self.branchLeafProductDataManager.selectedIndexPath == nil) {
        return;
    }    
    NSString* productSpecKey = [self.branchLeafProductDataManager.funcBtnProductSpecHashMap objectForKey:[NSNumber numberWithInteger:aFuncBtn.tag]];
//    NSMutableDictionary* productDetailDict = [self.branchLeafProductDataManager.displayList objectAtIndex:self.branchLeafProductDataManager.selectedIndexPath.row];
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:self.branchLeafProductDataManager.selectedIndexPath.section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    NSMutableDictionary* productDetailDict = [aSectionArray objectAtIndex:self.branchLeafProductDataManager.selectedIndexPath.row];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
        self.inputPopover = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
        wvc.Data = productDetailDict;
    } else {
        self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*) self.inputPopover.contentViewController;
        oipvc.Data = productDetailDict;
        oipvc.bonusDealResultDict = [oipvc interpretBonusDeal:[productDetailDict objectForKey:@"BonusDeal"]];
        [self checkQtyByBonusDeal:productDetailDict orderInputPadViewController:oipvc numberBtn:aNumberBtn funcBtn:aFuncBtn];
        oipvc.showSeparator = self.showSeparator;
        ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
        if (!arcosErrorResult.successFlag) {
            [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
    self.inputPopover.delegate = self;
    NSNumber* unitsPerPack = [productDetailDict objectForKey:@"UnitsPerPack"];
    if ((aFuncBtn.tag == 2 || aFuncBtn.tag == 3) && aNumberBtn.tag >= [unitsPerPack intValue]) {//spqty or spbon btn
        [ArcosUtils showMsg:[NSString stringWithFormat:@"The value can not be greater or equal to %d.", [unitsPerPack intValue]] delegate:nil];
        return;
    }
    
    [productDetailDict setObject:[NSNumber numberWithInteger:aNumberBtn.tag] forKey:productSpecKey];
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:productDetailDict];
    if (!isSelected) {
        [productDetailDict setObject:[NSNumber numberWithFloat:0] forKey:@"DiscountPercent"];
    }
    [productDetailDict setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    [productDetailDict setObject:[ProductFormRowConverter calculateLineValue:productDetailDict] forKey:@"LineValue"];
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:productDetailDict];

    [self.myTableView reloadData];
}

- (void)checkQtyByBonusDeal:(NSMutableDictionary*)aProductDetailDict orderInputPadViewController:(OrderInputPadViewController*)anOipvc numberBtn:(UIButton *)aNumberBtn funcBtn:(UIButton*)aFuncBtn {
    if ([[aProductDetailDict objectForKey:@"PriceFlag"] intValue] != 1) return;
    if (![[anOipvc.bonusDealResultDict objectForKey:@"OkFlag"] boolValue]) return;
    if (aFuncBtn.tag != 0) return;
    [anOipvc enterQtyFoundProcessor:[[NSNumber numberWithInteger:aNumberBtn.tag] intValue]];
}

- (void)numberInputPadWithOtherBtn {
    if (self.branchLeafProductDataManager.selectedIndexPath == nil) {
        return;
    }
    CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
//    BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
    
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:self.branchLeafProductDataManager.selectedIndexPath.section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    NSMutableDictionary* productDetailDict = [aSectionArray objectAtIndex:self.branchLeafProductDataManager.selectedIndexPath.row];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
        self.inputPopover = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
        wvc.Data = productDetailDict;
    } else {
        self.inputPopover = [self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
        oipvc.Data = productDetailDict;
        oipvc.showSeparator = self.showSeparator;
        ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
        if (!arcosErrorResult.successFlag) {
            [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
    self.inputPopover.delegate = self;
    [self.inputPopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)numberInputPadWithSearchBtn:(NSString*)aKeyword {
//    NSLog(@"aTextField %@", aKeyword);
    NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData] productWithProductCodeKeyword:aKeyword];
    if (products == nil) {
        self.branchLeafProductDataManager.displayList = [NSMutableArray array];
    } else {
        self.branchLeafProductDataManager.displayList = [NSMutableArray arrayWithCapacity:[products count]];
        NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[products count]];
        for (NSDictionary* aDict in products) {
            [productIURList addObject:[aDict objectForKey:@"ProductIUR"]];
        }
//        NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR productIURList:productIURList];
//        products = [[ArcosCoreData sharedArcosCoreData].arcosCoreDataManager processPriceProductList:products priceHashMap:priceHashMap];
        products = [[ArcosCoreData sharedArcosCoreData] processEntryPriceProductList:products productIURList:productIURList locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        for (NSMutableDictionary* aProduct in products) {//loop products
            
            NSMutableDictionary* formRow = [ProductFormRowConverter createFormRowWithProduct:aProduct];
            //sync the row with current cart
            formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
            [self.branchLeafProductDataManager.displayList addObject:formRow];
        }
    }
    self.branchLeafProductDataManager.selectedIndexPath = nil;
    [self.branchLeafProductDataManager categoriseSortedListIntoSection:self.branchLeafProductDataManager.displayList formTypeNumber:0];
    
    [self.myTableView reloadData];
    [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:@""];
}

#pragma mark LeafSmallTemplatePageIndexDelegate
- (void)pressPageIndexWithLabel:(UILabel*)anLabel {
    NSNumber* pageNumber = [self.leafSmallTemplateViewController.leafSmallTemplateDataManager.pageIndexDict objectForKey:anLabel.text];
    [self.leafSmallTemplateViewController jumpToSpecificPage:[pageNumber intValue]];
}

#pragma mark LeafSmallTemplateViewItemDelegate 
-(void)didSelectSmallTemplateViewItemWithButton:(UIButton*)aBtn indexPathRow:(int)anIndexPathRow {
    //    NSLog(@"didSelectSbranchlargesmallslideview %d %d",aBtn.tag, anIndexPathRow);
    self.leafSmallTemplateViewController.leafSmallTemplateDataManager.selectedIndexPath = [NSIndexPath indexPathForRow:aBtn.tag inSection:anIndexPathRow];
    NSMutableArray* subsetDisplayList = [self.leafSmallTemplateViewController.leafSmallTemplateDataManager.pagedDisplayList objectAtIndex:anIndexPathRow];
    NSMutableDictionary* cellDataDict = [subsetDisplayList objectAtIndex:aBtn.tag];
    switch (self.branchLeafProductDataManager.formTypeNumber) {
        case 305: {
            [self formrowListSelectSmallTemplateViewItemWithData:cellDataDict];
        }            
            break;
            
        default: {
            [self productListSelectSmallTemplateViewItemWithData:cellDataDict];
        }
            break;
    }    
    [self.myTableView reloadData];
    [self.navigationTitleDelegate resetTopBranchLeafProductNavigationTitle:[cellDataDict objectForKey:@"Detail"]];
    self.numberInputPadViewController.inStockValue.text = @"";
}

- (void)formrowListSelectSmallTemplateViewItemWithData:(NSMutableDictionary*)aCellDataDict {
    NSNumber* sequenceDivider = [aCellDataDict objectForKey:@"SequenceDivider"];
    NSMutableArray* unsortFormRows = [[ArcosCoreData sharedArcosCoreData] formRowWithDividerIURSortByNatureOrder:sequenceDivider withFormIUR:self.branchLeafProductDataManager.formIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [self.branchLeafProductDataManager fillTheUnsortListWithData:unsortFormRows];    
    
    self.branchLeafProductDataManager.displayList = unsortFormRows;
    self.branchLeafProductDataManager.selectedIndexPath = nil;
    [self.branchLeafProductDataManager categoriseSortedListIntoSection:self.branchLeafProductDataManager.displayList formTypeNumber:self.branchLeafProductDataManager.formTypeNumber];
}

- (void)productListSelectSmallTemplateViewItemWithData:(NSMutableDictionary*)aCellDataDict {
    NSString* leafDescrDetailCode = [aCellDataDict objectForKey:@"DescrDetailCode"];
    [self productListWithLeafLxCode:leafDescrDetailCode];
}

- (void)productListDoubleTapLargeImage {
    [self productListWithLeafLxCode:nil];
}

- (void)productListWithLeafLxCode:(NSString*)anLeafLxCode {
    NSMutableArray* unsortFormRows = [self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLeafMiscUtils getFormRowList:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode branchLxCode:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLxCode leafLxCodeContent:anLeafLxCode leafLxCode:self.leafSmallTemplateViewController.leafSmallTemplateDataManager.leafLxCode];
    self.branchLeafProductDataManager.displayList = unsortFormRows;
    self.branchLeafProductDataManager.selectedIndexPath = nil;
    [self.branchLeafProductDataManager categoriseSortedListIntoSection:self.branchLeafProductDataManager.displayList formTypeNumber:self.branchLeafProductDataManager.formTypeNumber];
}

#pragma mark WidgetFactoryDelegate
-(void)operationDone:(id)data{
    [self.inputPopover dismissPopoverAnimated:YES];
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:data];
    [data setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
    [self.myTableView reloadData];
}
#pragma mark BranchLeafProductGridListTableViewCellDelegate
-(void)showBigProductImageWithProductCode:(NSString*)aProductCode {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = [ArcosUtils trim:aProductCode];
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

-(void)showProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath *)anIndexPath{
    NSString* auxKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:anIndexPath.section];
    NSMutableArray* auxSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:auxKey];
    NSMutableDictionary* auxProductDetailDict = [auxSectionArray objectAtIndex:anIndexPath.row];
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.productIUR = aProductIUR;
    pdvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    pdvc.productDetailDataManager.formRowDict = auxProductDetailDict;
    [self.navigationController pushViewController:pdvc animated:YES];
    [pdvc release];
    
    [self.backButtonDelegate controlOrderFormBackButtonEvent];
}

- (void)syncTableViewData {
    [self.branchLeafProductDataManager fillTheUnsortListWithData:self.branchLeafProductDataManager.displayList];
    [self.branchLeafProductDataManager categoriseSortedListIntoSection:self.branchLeafProductDataManager.displayList formTypeNumber:self.branchLeafProductDataManager.formTypeNumber];
}

- (NSMutableDictionary*)retrieveProductDictWithIndex:(NSIndexPath*)anIndexPath {
    NSString* aKey = [self.branchLeafProductDataManager.sortKeyList objectAtIndex:anIndexPath.section];
    NSMutableArray* aSectionArray = [self.branchLeafProductDataManager.productSectionDict objectForKey:aKey];
    return [aSectionArray objectAtIndex:anIndexPath.row];
}

- (int)retrieveStatusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width;
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
