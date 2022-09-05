//
//  NewOrderViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "NewOrderViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "ArcosRootViewController.h"
@interface NewOrderViewController ()
- (void)layoutMySubviews;
- (void)hideHeaderLabelWithFlag:(BOOL)aFlag;
- (void)configTitleToWhite;
- (void)configTitleToBlue;
- (void)configRightBarButtons;
@end

@implementation NewOrderViewController
@synthesize tableNavigationBar = _tableNavigationBar;
@synthesize locationName = _locationName;
@synthesize locationAddress = _locationAddress;
@synthesize planogramButton = _planogramButton;
@synthesize orderPadsPopover = _orderPadsPopover;
@synthesize orderPadsButton = _orderPadsButton;
@synthesize orderBaseTableViewController = _orderBaseTableViewController;
@synthesize orderBaseContentView = _orderBaseContentView;
@synthesize orderBaseTableContentView = _orderBaseTableContentView;
@synthesize fdtvc = _fdtvc;
@synthesize frtvc = _frtvc;
@synthesize orderPadsBarButton = _orderPadsBarButton;
@synthesize orderBaseScrollContentView = _orderBaseScrollContentView;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize orderPadsNavigationController = _orderPadsNavigationController;
@synthesize productSearchDataManager = _productSearchDataManager;
@synthesize imageFormRowsDataManager = _imageFormRowsDataManager;
@synthesize downloadThread = _downloadThread;
@synthesize saveDataThread = _saveDataThread;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize myRootViewController = _myRootViewController;
@synthesize isOrderSaved = _isOrderSaved;
@synthesize custNameHeaderLabel = _custNameHeaderLabel;
@synthesize custAddrHeaderLabel = _custAddrHeaderLabel;
@synthesize myNewOrderDataManager = _myNewOrderDataManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [[self.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.tableNavigationBar != nil) { self.tableNavigationBar = nil; }
    if (self.locationName != nil) { self.locationName = nil; }
    if (self.locationAddress != nil) { self.locationAddress = nil; }
    self.planogramButton = nil;
    if (self.orderPadsPopover != nil) { self.orderPadsPopover = nil; }
    if (self.orderPadsButton != nil) { self.orderPadsButton = nil; }    
    if (self.orderBaseTableViewController != nil) { self.orderBaseTableViewController = nil; }
    if (self.orderBaseContentView != nil) { self.orderBaseContentView = nil; }
    if (self.orderBaseTableContentView != nil) { self.orderBaseTableContentView = nil; }
    if (self.fdtvc != nil) { self.fdtvc = nil; }    
    if (self.frtvc != nil) { self.frtvc = nil; }        
    if (self.orderPadsBarButton != nil) { self.orderPadsBarButton = nil; }
    if (self.orderBaseContentView != nil) { self.orderBaseContentView = nil; }
    
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.orderPadsNavigationController != nil) { self.orderPadsNavigationController = nil; }
    if (self.productSearchDataManager != nil) { self.productSearchDataManager = nil; }  
    if (self.imageFormRowsDataManager != nil) { self.imageFormRowsDataManager = nil; }
    if (self.downloadThread != nil) { self.downloadThread = nil; }
    if (self.saveDataThread != nil) { self.saveDataThread = nil; }
    self.myRootViewController = nil;
    self.custNameHeaderLabel = nil;
    self.custAddrHeaderLabel = nil;
    self.myNewOrderDataManager = nil;
    
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
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    self.productSearchDataManager = [[[ProductSearchDataManager alloc] init] autorelease];
    
//    [self.productSearchDataManager createSearchFormDetailData];
    self.fdtvc = [[[FormDetailTableViewController alloc]initWithNibName:@"FormDetailTableViewController" bundle:nil] autorelease];
    self.orderPadsNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.fdtvc] autorelease];
    self.fdtvc.delegate = self;
    self.fdtvc.dividerDelegate = self;
    
    self.orderPadsPopover = [[[UIPopoverController alloc]initWithContentViewController:self.orderPadsNavigationController] autorelease];
    self.orderPadsPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    self.myNewOrderDataManager = [[[NewOrderDataManager alloc] init] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    
    UIBarButtonItem* checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkout:)];
    
    self.orderPadsBarButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(orderPadsPressed:)] autorelease];    
    [rightButtonList addObject:checkoutButton];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enablePrinterFlag]) {
        UIBarButtonItem* printButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"printer.png"] style:UIBarButtonItemStylePlain target:self action:@selector(printButtonPressed:)];
        [rightButtonList addObject:printButton];
        [printButton release];
    }    
    //    [self.navigationItem setRightBarButtonItems:rightButtonList];
    self.planogramButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"planogram.png"] style:UIBarButtonItemStylePlain target:self action:@selector(planogramButtonPressed)] autorelease];
    [rightButtonList addObject:self.planogramButton];
    [rightButtonList addObject:self.orderPadsBarButton];
    self.navigationItem.rightBarButtonItems = rightButtonList;
    
    [checkoutButton release];
    */
//    NSLog(@"new order view controller:%@", NSStringFromSelector(_cmd));
    
//    self.navigationItem.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
    if (self.custNameHeaderLabel == nil) {
        self.custNameHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 1, 550.0, 26.0)] autorelease];
        self.custNameHeaderLabel.textColor = [UIColor whiteColor];
        self.custNameHeaderLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    self.custNameHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
    [self.navigationController.navigationBar addSubview:self.custNameHeaderLabel];
    if (self.custAddrHeaderLabel == nil) {
        self.custAddrHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 28, 550.0, 14.0)] autorelease];
        self.custAddrHeaderLabel.font = [UIFont systemFontOfSize:12.0];
        self.custAddrHeaderLabel.textColor = [UIColor whiteColor];
    }
    self.custAddrHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerAddress]];
    [self.navigationController.navigationBar addSubview:self.custAddrHeaderLabel];
    if ([self.navigationItem.leftBarButtonItems count] == 0) {
        [self configTitleToBlue];
//        self.navigationItem.title = @"";
        [self hideHeaderLabelWithFlag:NO];
    } else {
        [self configTitleToWhite];
        [self hideHeaderLabelWithFlag:YES];
    }
    self.navigationItem.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
}

- (void)configRightBarButtons {
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:4];
    
    UIBarButtonItem* checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Check Out" style:UIBarButtonItemStylePlain target:self action:@selector(checkout:)];
    
    self.orderPadsBarButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(orderPadsPressed:)] autorelease];    
    [rightButtonList addObject:checkoutButton];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enablePrinterFlag]) {
        UIBarButtonItem* printButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"printer.png"] style:UIBarButtonItemStylePlain target:self action:@selector(printButtonPressed:)];
        [rightButtonList addObject:printButton];
        [printButton release];
    }
    if ([OrderSharedClass sharedOrderSharedClass].currentFormIUR != nil) {
        NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
        NSNumber* presenterIUR = [currentFormDetailDict objectForKey:@"FontSize"];
        if ([presenterIUR intValue] != 0 && [presenterIUR intValue] != 8) {
            self.planogramButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"planogram.png"] style:UIBarButtonItemStylePlain target:self action:@selector(planogramButtonPressed)] autorelease];
            [rightButtonList addObject:self.planogramButton];
        }
    }    
    [rightButtonList addObject:self.orderPadsBarButton];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
        UIBarButtonItem* loadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"load.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loadButtonPressed)];
        [rightButtonList addObject:loadButton];
        [loadButton release];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        UIBarButtonItem* packageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"discount.png"] style:UIBarButtonItemStylePlain target:self action:@selector(packageButtonPressed)];
        [rightButtonList addObject:packageButton];
        [packageButton release];
    }
    self.navigationItem.rightBarButtonItems = rightButtonList;
    
    [checkoutButton release];
}

- (void)planogramButtonPressed {
    FormPlanogramViewController* fpvc = [[FormPlanogramViewController alloc] initWithNibName:@"FormPlanogramViewController" bundle:nil];
    [self.navigationController pushViewController:fpvc animated:YES];
    [fpvc release];
}

- (void)loadButtonPressed {
    if ([self.globalNavigationController.viewControllers count] > 0) {
        UIViewController* tmpUIViewController = [self.globalNavigationController.viewControllers objectAtIndex:0];
        if ([tmpUIViewController isKindOfClass:[FormRowsTableViewController class]]) {
            if ([GlobalSharedClass shared].currentSelectedLocationIUR == nil) return;
            FormRowsTableViewController* auxFormRowsTableViewController = (FormRowsTableViewController*)tmpUIViewController;
            NSMutableArray* locationProductMatList = [self.myNewOrderDataManager retrieveLocationProductMATWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            NSMutableDictionary* productIURMap = [NSMutableDictionary dictionaryWithCapacity:[locationProductMatList count]];
            for (NSDictionary* auxLocationProductMat in locationProductMatList) {
                NSNumber* auxInStock = [auxLocationProductMat objectForKey:@"inStock"];
                if ([auxInStock intValue] != 0) {
                    [productIURMap setObject:[auxLocationProductMat objectForKey:@"inStock"] forKey:[auxLocationProductMat objectForKey:@"productIUR"]];
                }
            }
            for (NSMutableDictionary* auxUnsortedFormrows in auxFormRowsTableViewController.unsortedFormrows) {
                NSNumber* auxProductIUR = [auxUnsortedFormrows objectForKey:@"ProductIUR"];
                NSNumber* auxInStock = [productIURMap objectForKey:auxProductIUR];
                if (auxInStock != nil) {
                    [auxUnsortedFormrows setObject:auxInStock forKey:@"InStock"];
                    [auxFormRowsTableViewController saveOrderToTheCart:auxUnsortedFormrows];
                    [auxFormRowsTableViewController reloadTableViewData];
                }
            }
        }
    }
}

- (void)packageButtonPressed {
    if (self.orderPadsPopover != nil && [self.orderPadsPopover isPopoverVisible]) {
        [self.orderPadsPopover dismissPopoverAnimated:NO];
        return;
    }
    PackageTableViewController* PTVC = [[PackageTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if ([PTVC.packageDataManager.displayList count] == 0) {
        [ArcosUtils showDialogBox:@"Selected Location does not have any Packages setup" title:@"" delegate:nil target:self tag:0 handler:nil];
        [GlobalSharedClass shared].packageViewCount = 1;
        [PTVC release];
        return;
    }
    PTVC.modalDelegate = self;
    PTVC.actionDelegate = self;
    UINavigationController* auxNavigationController = [[UINavigationController alloc] initWithRootViewController:PTVC];
    if (@available(iOS 13.0, *)) {
        auxNavigationController.modalInPresentation = YES;
    }
    auxNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    auxNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:auxNavigationController animated:YES completion:^{
        
    }];
    [auxNavigationController release];
    [PTVC release];
}

#pragma mark PackageTableViewControllerDelegate
- (void)packageSaveButtonPressed {
    NSDictionary* currentFormDetailRecordDict = [self.fdtvc.formDetailDataManager formDetailRecordDictWithIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    if (currentFormDetailRecordDict != nil) {
        [self didSelectFormDetailRow:currentFormDetailRecordDict];
    }
    
//    NSNumber* pGiur = [[[GlobalSharedClass shared] retrieveCurrentSelectedPackage] objectForKey:@"pGiur"];
    NSMutableDictionary* currentSelectedPackage = [[ArcosCoreData sharedArcosCoreData] retrievePackageWithIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]];
    NSNumber* pGiur = [currentSelectedPackage objectForKey:@"pGiur"];
    NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allKeys] count]];
    for(NSString* aKey in [OrderSharedClass sharedOrderSharedClass].currentOrderCart) {
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:aKey];
        NSNumber* tmpProductIUR = [aDict objectForKey:@"ProductIUR"];
        [productIURList addObject:tmpProductIUR];
    }
    NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:pGiur productIURList:productIURList];
    for(NSString* aKey in [OrderSharedClass sharedOrderSharedClass].currentOrderCart) {
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:aKey];
        NSNumber* tmpProductIUR = [aDict objectForKey:@"ProductIUR"];
        NSDictionary* tmpPriceDict = [priceHashMap objectForKey:tmpProductIUR];
        if (tmpPriceDict != nil) {
            [aDict setObject:[NSNumber numberWithBool:YES] forKey:@"PriceFlag"];
        } else {
            [aDict setObject:[NSNumber numberWithBool:NO] forKey:@"PriceFlag"];
        }
        NSDecimalNumber* tmpDiscountPercent = [tmpPriceDict objectForKey:@"DiscountPercent"];
        [aDict setObject:[NSNumber numberWithFloat:[tmpDiscountPercent floatValue]] forKey:@"DiscountPercent"];
        [aDict setObject:[NSNumber numberWithFloat:[tmpDiscountPercent floatValue]] forKey:@"PriceDiscountPercent"];
        [aDict setObject:[ProductFormRowConverter calculateLineValue:aDict] forKey:@"LineValue"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"cp%@",NSStringFromSelector(_cmd));
//    NSLog(@"orderFormViewController is: %@", [GlobalSharedClass shared].orderFormViewController);
//    MATFormRowsDataManager* matFormRowsDataManager = [[[MATFormRowsDataManager alloc] init] autorelease];
//    [matFormRowsDataManager createMATFormRowsData];
//    self.imageFormRowsDataManager = [[[ImageFormRowsDataManager alloc] init] autorelease];
//    [self.imageFormRowsDataManager createImageFormRowsData];
//   [self.productSearchDataManager createSearchFormDetailData];
//    LargeSmallImageFormRowsDataManager* largeSmallImageFormRowsDataManager = [[[LargeSmallImageFormRowsDataManager alloc] init] autorelease];
//    [largeSmallImageFormRowsDataManager createLargeSmallImageFormRowsData];
//    L3SearchDataManager* l3SearchDataManager = [[[L3SearchDataManager alloc] init] autorelease];
//    [l3SearchDataManager createBranchBoxGridL45Data];
//    [l3SearchDataManager createBranchBoxGridL35Data];
//    [l3SearchDataManager createBranchBoxL45Data];
//    [l3SearchDataManager createBranchBoxL35Data];
//    TwoBigImageLevelCodeDataManager* twoBigImageLevelCodeDataManager = [[[TwoBigImageLevelCodeDataManager alloc] init] autorelease];
//    [twoBigImageLevelCodeDataManager createTwoBigBoxGridL45Data];
//    LargeSmallL3SearchFormRowDataManager* lsl3SearchDataManager = [[[LargeSmallL3SearchFormRowDataManager alloc] init] autorelease];
//    [lsl3SearchDataManager createLargeSmallL3SearchFormRowsData];
//    LargeSmallFormDetailDataManager* largeSmallFormDetailDataManager = [[[LargeSmallFormDetailDataManager alloc] init] autorelease];
//    [largeSmallFormDetailDataManager createLargeSmallFormDetailData];
//    BranchLargeSmallDataManager* branchLargeSmallDataManager = [[[BranchLargeSmallDataManager alloc] init] autorelease];
//    [branchLargeSmallDataManager createBranchSmallL05GridData];
//    [branchLargeSmallDataManager createBranchLargeSmallL45GridData];
//    [branchLargeSmallDataManager createBranchLargeSmallL45Data];
//    [branchLargeSmallDataManager createBranchLargeSmallL35Data];
//    [[ArcosCoreData sharedArcosCoreData] clearTableWithName:@"DescrDetail"];
//    NSLog(@"presenterPath is: %@", [FileCommon presenterPath]);
//    [[ArcosCoreData sharedArcosCoreData] updatePresenterWithIUR:[NSNumber numberWithInt:33843]];
//    ArcosMemoryUtils* amu = [[[ArcosMemoryUtils alloc] init] autorelease];
//    [amu print_free_memory];
//    [FileCommon removeFileAtPath:[FileCommon updateCenterPlistPath]];
//    [FileCommon testCopyItemAtPath:nil toPath:nil error:nil];
//    [FileCommon copyfileTest];
//    [[ArcosCoreData sharedArcosCoreData] executeTransaction];
    [ArcosUtils processRotationEvent:self.orderBaseTableContentView tabBarHeight:0.0f navigationController:self.navigationController];
    [self layoutMySubviews];
    if ([GlobalSharedClass shared].currentSelectedLocationIUR == nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"Please select a customer!" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        alert.tag = 88;
        [alert show];
        [alert release];
        return;
    } 
    if (self.isNotFirstLoaded) {
        [self configRightBarButtons];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
            if ([GlobalSharedClass shared].packageViewCount == 0) {
                [self packageButtonPressed];
            }
        }
        return;
    }
//    [self.navigationController popToRootViewControllerAnimated:NO];
    NSNumber* defaultFormIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:7];
    if ([GlobalSharedClass shared].lastOrderFormIUR != nil) {
        defaultFormIUR = [NSNumber numberWithInt:[[GlobalSharedClass shared].lastOrderFormIUR intValue]];
    }
    //    NSLog(@"defaultFormIUR: %@", defaultFormIUR);
    NSDictionary* defaultFormDetailRecordDict = [self.fdtvc.formDetailDataManager formDetailRecordDictWithIUR:defaultFormIUR];
    if (defaultFormDetailRecordDict != nil) {
//        NSLog(@"defaultFormDetailRecordDict:%@",defaultFormDetailRecordDict);
        [self didSelectFormDetailRow:defaultFormDetailRecordDict];
    } else if([self.fdtvc.formDetailDataManager.displayList count] == 1){
        [self didSelectFormDetailRow:[self.fdtvc.formDetailDataManager.displayList objectAtIndex:0]];
    }
    self.isNotFirstLoaded = YES;
    [self configRightBarButtons];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        if ([GlobalSharedClass shared].packageViewCount == 0) {
            [self packageButtonPressed];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations    
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (self.orderPadsPopover != nil) {
        if ([self.orderPadsPopover isPopoverVisible]) {
//            [self.orderPadsPopover presentPopoverFromRect:self.orderPadsButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            [self.orderPadsPopover presentPopoverFromBarButtonItem:self.orderPadsBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
    NSArray* subviewsList = [self.orderBaseTableContentView subviews];
    for (UIView* subview in subviewsList) {
        if (self.frtvc != nil && [self.frtvc.view isEqual:subview]) {
            [self.frtvc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
            break;
        } else if(self.globalNavigationController != nil && [self.globalNavigationController.view isEqual:subview]) {
            [self.globalNavigationController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
            break;
        }
    }
    [self layoutMySubviews];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSArray* subviewsList = [self.orderBaseTableContentView subviews];
    for (UIView* subview in subviewsList) {
        if (self.frtvc != nil && [self.frtvc.view isEqual:subview]) {
            [self.frtvc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
            break;
        } else if(self.globalNavigationController != nil && [self.globalNavigationController.view isEqual:subview]) {
            [self.globalNavigationController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
            break;
        }
    }
}

- (void)printButtonPressed:(id)sender {
    CheckoutPrinterWrapperViewController* cpwvc = [[CheckoutPrinterWrapperViewController alloc] initWithNibName:@"CheckoutPrinterWrapperViewController" bundle:nil];
//    cpwvc.myDelegate = self;
    cpwvc.modalDelegate = self;
    cpwvc.orderHeader = [OrderSharedClass sharedOrderSharedClass].currentOrderHeader;
    cpwvc.packageIUR = [[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault];
    cpwvc.isOrderPadPrinterType = YES;
    if (@available(iOS 13.0, *)) {
        cpwvc.modalInPresentation = YES;
    }
//    if ([cpwvc respondsToSelector:@selector(isModalInPresentation)]) {
//        cpwvc.modalInPresentation = YES;
//    }
    cpwvc.modalPresentationStyle = UIModalPresentationFormSheet;
    cpwvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cpwvc animated:YES completion:^{
        
    }];
    [cpwvc release];
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)orderPadsPressed:(id)sender {
//    NSLog(@"orderPadsPressed");
//    FormRowsTableViewController* formrtvc = [[[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil] autorelease];
//    [self.navigationController pushViewController:formrtvc animated:YES];
//    return;
    /*
    MATFormRowsTableViewController* matfrtvc = [[[MATFormRowsTableViewController alloc] initWithNibName:@"MATFormRowsTableViewController" bundle:nil] autorelease];
    matfrtvc.locationIUR = [NSNumber numberWithInt:9735];
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:matfrtvc];
    tmpNavigationController.view.frame = self.orderBaseTableContentView.frame;
    [self.orderBaseTableContentView addSubview:tmpNavigationController.view];
    
    return;
     */
    if (self.orderPadsPopover != nil && [self.orderPadsPopover isPopoverVisible]) {
        [self.orderPadsPopover dismissPopoverAnimated:NO];
        return;
    }
    /*
    if (self.orderPadsPopover == nil) {        
        self.fdtvc = [[FormDetailTableViewController alloc]initWithNibName:@"FormDetailTableViewController" bundle:nil];
        self.orderPadsNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.fdtvc] autorelease];
        self.fdtvc.delegate = self;
        self.fdtvc.dividerDelegate = self;
        
        self.orderPadsPopover = [[UIPopoverController alloc]initWithContentViewController:self.orderPadsNavigationController];
        self.orderPadsPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
        
    }
    */
//    [self.fdtvc.formDetailTableView reloadData];
    if (self.fdtvc.frdtvc != nil) {
        [self.fdtvc.frdtvc.formRowDividerTableView reloadData];
    }
    [self.orderPadsPopover presentPopoverFromBarButtonItem:self.orderPadsBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - FormDetailDelegate
- (void)didSelectFormDetailRow:(NSDictionary*)cellData {
    [OrderSharedClass sharedOrderSharedClass].currentFormIUR = [cellData objectForKey:@"IUR"];
    [self configRightBarButtons];
    [[OrderSharedClass sharedOrderSharedClass] insertFormIUR:[cellData objectForKey:@"IUR"]];
    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR = nil;
//    NSLog(@"didSelectFormDetailRow subviews count: %d", [[self.orderBaseTableContentView subviews] count]);
    [[self.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.orderPadsPopover dismissPopoverAnimated:YES];
//    NSLog(@"didSelectFormDetailRow is: %@", cellData);
    NSString* details = [cellData objectForKey:@"Details"];
    NSRange aMATRange = [details rangeOfString:@"[MAT]"];
    if (aMATRange.location != NSNotFound) {
        [self showStandardOrderPadMat:[NSNumber numberWithInt:-1] dividerName:@"All"];
        [self controlBackButtonAndNavigationTitle];
        return;
    }
    NSString* formType = [ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:[cellData objectForKey:@"FormType"]]];
    int formTypeNumber = [[ArcosUtils convertStringToNumber:formType] intValue];
    NSRange formTypeRange = NSMakeRange(0, 1);
    int formTypeId = [[ArcosUtils convertStringToNumber:[formType substringWithRange:formTypeRange]] intValue];
    /*
     101: MAT
     102: L4\L5(Image)
     103: L3\L5(L3Search)
     104: FULL(Search)
     202: L4\L5 LL
     302: L4\L5 LS
     303: L3\L5 LS
     304: Divider\SubDivider LS
     */
    switch (formTypeId) {
        case 1:
        case 2:
        case 3: {
            [self traditionalOrderPadSelection:formTypeNumber cellData:cellData];
        }            
            break;
        case 4:
        case 5: {
            NSRange branchRange = NSMakeRange(1, 1);
            int branchCode = [[ArcosUtils convertStringToNumber:[formType substringWithRange:branchRange]] intValue];
            if (formTypeId == 5 && branchCode == 0) {
                BranchLeafProductGridViewController* BLPGVC = [[BranchLeafProductGridViewController alloc] initWithNibName:@"BranchLeafProductGridViewController" bundle:nil];
                BLPGVC.navigationTitleDelegate = self;
                BLPGVC.backButtonDelegate = self;
                BLPGVC.branchLeafProductDataManager.formTypeNumber = formTypeNumber;
                NSMutableDictionary* formTypeMiscDict = [BLPGVC.branchLeafProductDataManager analyseLeafFormTypeRawData:formType];
                NSString* leafDescrTypeCode = [formTypeMiscDict objectForKey:@"leafDescrTypeCode"];
                NSString* leafLxCode = [formTypeMiscDict objectForKey:@"leafLxCode"];
                [BLPGVC.branchLeafProductDataManager retrieveLeafNodesWithLeafDescrTypeCode:leafDescrTypeCode leafLxCode:leafLxCode];
                BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchDescrDetailCode = nil;
                BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.branchLxCode = nil;
                BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.leafLxCode = [NSString stringWithFormat:@"%@", leafLxCode];
                BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:BLPGVC.branchLeafProductDataManager.leafChildrenList];
                self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:BLPGVC] autorelease];
                [BLPGVC release];
                if ([BLPGVC.branchLeafProductDataManager.leafChildrenList count] == 0) break;
                self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
                [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
            } else {
                BranchLargeSmallSlideViewController* blssvc = [[BranchLargeSmallSlideViewController alloc] initWithNibName:@"BranchLargeSmallSlideViewController" bundle:nil];
                blssvc.formType = formType;
                blssvc.backButtonDelegate = self;
                blssvc.navigationTitleDelegate = self;
                self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:blssvc] autorelease];
                [blssvc release];
                self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
                [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
            }
        }
            break;
        case 6:
        case 7: {
            L3SearchFormRowsTableViewController* l3sfrtvc = [[L3SearchFormRowsTableViewController alloc] initWithNibName:@"L3SearchFormRowsTableViewController" bundle:nil];
            l3sfrtvc.formType = formType;
            l3sfrtvc.backButtonDelegate = self;
            l3sfrtvc.navigationTitleDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:l3sfrtvc] autorelease];
            [l3sfrtvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        case 8:
        case 9: {
            TwoBigImageLevelCodeTableViewController* tbilctvc = [[TwoBigImageLevelCodeTableViewController alloc] initWithNibName:@"TwoBigImageLevelCodeTableViewController" bundle:nil];
            tbilctvc.formType = formType;
            tbilctvc.backButtonDelegate = self;
            tbilctvc.navigationTitleDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:tbilctvc] autorelease];
            [tbilctvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        default:
            [self createBlankOrderPad];
            break;
    }    
//    if ([self.globalNavigationController.viewControllers count] == 1) {
//        self.navigationItem.leftBarButtonItem = nil;
//        [self resetNavigationTitleToBeginStatus];
//    }
    [self controlBackButtonAndNavigationTitle];
}

- (void)showStandardOrderPadMat:(NSNumber*)aDividerIUR dividerName:(NSString*)aDividerName {
    StandardOrderPadMatTableViewController* SOPMTVC = [[StandardOrderPadMatTableViewController alloc] initWithNibName:@"StandardOrderPadMatTableViewController" bundle:nil];
    SOPMTVC.backButtonDelegate = self;
    SOPMTVC.formRowsTableViewController.isShowingSearchBar = YES;
    NSNumber* resPackageIUR = [NSNumber numberWithInt:0];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        resPackageIUR = [[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault];
    }
    [SOPMTVC.formRowsTableViewController resetDividerFormRowsWithDividerIUR:aDividerIUR withDividerName:aDividerName locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:resPackageIUR];
//    [SOPMTVC.formRowsTableViewController resetDataWithDividerIUR:aDividerIUR withDividerName:aDividerName locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    [SOPMTVC.mATFormRowsTableViewController.matFormRowsDataManager processLocationProductMATData:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]];
    [SOPMTVC.standardOrderPadMatDataManager processMatDataList:SOPMTVC.mATFormRowsTableViewController.matFormRowsDataManager.displayList];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:SOPMTVC] autorelease];
    [SOPMTVC release];
    self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
    [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
} 

- (UIViewController*)retrieveCurrentViewController {
    return [self.globalNavigationController.viewControllers firstObject];
}

-(void)createBlankOrderPad {
    NSNumber* sequenceDivider = [NSNumber numberWithInt:-1];
    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR = sequenceDivider;
    FormRowsTableViewController* tmpfrtvc = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
    tmpfrtvc.view.frame = self.orderBaseTableContentView.frame;
    tmpfrtvc.isShowingSearchBar = YES;
    tmpfrtvc.isStandardOrderPadFlag = YES;
    NSNumber* resPackageIUR = [NSNumber numberWithInt:0];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        resPackageIUR = [[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault];
    }
    [tmpfrtvc resetDividerFormRowsWithDividerIUR:sequenceDivider withDividerName:@"All" locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:resPackageIUR];
//    [tmpfrtvc resetDataWithDividerIUR:sequenceDivider withDividerName:@"All" locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    tmpfrtvc.backButtonDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:tmpfrtvc] autorelease];
    [tmpfrtvc release];
    self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
    [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
}

- (void)removeSubviewInOrderPadTemplate {    
    [[self.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)didSelectFormRowDividerRow:(NSDictionary *)cellData formIUR:(NSNumber *)aFormIUR{
    [OrderSharedClass sharedOrderSharedClass].currentFormIUR = aFormIUR;
    [self configRightBarButtons];
    [[OrderSharedClass sharedOrderSharedClass] insertFormIUR:aFormIUR];
    [[self.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDictionary* currentFormDetailRecordDict = [self.fdtvc.formDetailDataManager formDetailRecordDictWithIUR:aFormIUR];    
    [self.orderPadsPopover dismissPopoverAnimated:YES];    
//    NSLog(@"didSelectFormRowDividerRow is: %@", cellData);    
    NSNumber* sequenceDivider = [cellData objectForKey:@"SequenceDivider"];
    NSString* details = [cellData objectForKey:@"Details"];
    [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR =sequenceDivider;
    NSString* formDetailDetails = [currentFormDetailRecordDict objectForKey:@"Details"];
    NSRange aMATRange = [formDetailDetails rangeOfString:@"[MAT]"];
    if (aMATRange.location != NSNotFound) {
        [self showStandardOrderPadMat:sequenceDivider dividerName:details];
        [self controlBackButtonAndNavigationTitle];
        return;
    }
    
//    NSLog(@"seletction name %@ with data %@",sequenceDivider,details);
    FormRowsTableViewController* tmpfrtvc = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
//    self.frtvc.view.frame = self.orderBaseTableContentView.frame;
    tmpfrtvc.isShowingSearchBar = YES;
    tmpfrtvc.isStandardOrderPadFlag = YES;
    tmpfrtvc.dividerIUR = sequenceDivider;
    NSNumber* resPackageIUR = [NSNumber numberWithInt:0];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        resPackageIUR = [[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault];
    }
    [tmpfrtvc resetDividerFormRowsWithDividerIUR:sequenceDivider withDividerName:details locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:resPackageIUR];
//    [tmpfrtvc resetDataWithDividerIUR:sequenceDivider withDividerName:details locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    tmpfrtvc.backButtonDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:tmpfrtvc] autorelease];
    [tmpfrtvc release];
    self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
    [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
//    [self.orderBaseTableContentView addSubview:self.frtvc.view];
//    if ([self.globalNavigationController.viewControllers count] == 1) {
//        self.navigationItem.leftBarButtonItem = nil;
//    }
    [self controlBackButtonAndNavigationTitle];
}

- (void)checkout:(id)sender {
    if (self.orderPadsPopover != nil && [self.orderPadsPopover isPopoverVisible]) {
        [self.orderPadsPopover dismissPopoverAnimated:NO];              
    }
//    CheckoutViewController* cvc = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
//    cvc.title = @"Checkout";
//    [self.navigationController pushViewController:cvc animated:YES];
//    [cvc release];
//    [self configTitleToWhite];
    NextCheckoutViewController* ncvc = [[NextCheckoutViewController alloc] initWithNibName:@"NextCheckoutViewController" bundle:nil];
//    ncvc.title = @"Checkout";
    [self.navigationController pushViewController:ncvc animated:YES];
    [ncvc release];
     /*
    NSProcessInfo* processInfo = [NSProcessInfo processInfo];
    
    NSLog(@"processInfo:%@ %d active: %d",[processInfo processName] , [processInfo processorCount], [processInfo activeProcessorCount]);
    
    NSNumber* memorySize = [NSNumber numberWithLongLong:[processInfo physicalMemory]];
    NSLog(@"physicalMemory: %@", [HumanReadableDataSizeHelper humanReadableSizeFromBytes:memorySize useSiPrefixes:YES useSiMultiplier:NO]);
    self.downloadThread = [[[NSThread alloc] init] autorelease];
    self.saveDataThread = [[[NSThread alloc] init] autorelease];
    NSLog(@"self.downloadThread: %d", [self.downloadThread isMainThread]);
    NSLog(@"self.saveDataThread: %d", [self.saveDataThread isMainThread]);
     */
//    NSLog(@"size of myObject: %zd", malloc_size(memorySize));
}

#pragma marks alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 88|| alertView.tag == 888) {//no customer alert        
        //root tab bar
        /*
        ArcosAppDelegate_iPad* delegate = [[UIApplication sharedApplication] delegate];
        UITabBarController* tabbar = (UITabBarController*) delegate.mainTabbarController;
        */
        //redirct to the customer pad
//        MainTabbarViewController* myRootViewController = (MainTabbarViewController*)[ArcosUtils getRootView];
        int itemIndex = [self.myRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
        self.myRootViewController.customerMasterViewController.currentIndexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
        [self.myRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
    }
}

- (void)backPressed:(id)sender {
    [self.globalNavigationController popViewControllerAnimated:YES];
//    if ([self.globalNavigationController.viewControllers count] == 1) {
//        self.navigationItem.leftBarButtonItem = nil;
//        [self resetNavigationTitleToBeginStatus];
//    }
    [self controlBackButtonAndNavigationTitle];
}

#pragma marks OrderFormNavigationControllerBackButtonDelegate
- (void)controlOrderFormBackButtonEvent {
    if ([self.navigationItem.leftBarButtonItems count] == 0) {
        UIBarButtonItem* tmpBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];                
        [self.navigationItem setLeftBarButtonItem:tmpBackButton];
        [tmpBackButton release];
        [self hideHeaderLabelWithFlag:YES];
        [self configTitleToWhite];
        self.navigationItem.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
    }
}

#pragma marks BranchLeafProductNavigationTitleDelegate
- (void)resetTopBranchLeafProductNavigationTitle:(NSString*)aDetail {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ / %@", [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]], aDetail];
}

-(void)traditionalOrderPadSelection:(int)aFormTypeNumber cellData:(NSDictionary*)aCellDataDict {
    switch (aFormTypeNumber) {
        case 101: {        
            MATFormRowsTableViewController* matfrtvc = [[MATFormRowsTableViewController alloc] initWithNibName:@"MATFormRowsTableViewController" bundle:nil];
            matfrtvc.locationIUR = [[GlobalSharedClass shared]currentSelectedLocationIUR];
            matfrtvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:matfrtvc] autorelease];
            [matfrtvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        case 102: {
            ImageFormRowsTableViewController* ifrtvc = [[ImageFormRowsTableViewController alloc] initWithNibName:@"ImageFormRowsTableViewController" bundle:nil];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ifrtvc] autorelease];
            [ifrtvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        case 104: {
            FormRowsTableViewController* tmpfrtvc = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
            tmpfrtvc.dividerIUR=[NSNumber numberWithInt:-2];
            tmpfrtvc.unsortedFormrows = [NSMutableArray array];
            tmpfrtvc.isShowingSearchBar = YES;
            tmpfrtvc.isSearchProductTable = YES;
            tmpfrtvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:tmpfrtvc] autorelease];
            [tmpfrtvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        case 105: {
            FormRowsTableViewController* tmpfrtvc = [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];            
            tmpfrtvc.isShowingSearchBar = YES;
            tmpfrtvc.isPredicativeSearchProduct = YES;
            tmpfrtvc.dividerIUR=[NSNumber numberWithInt:-2];
            tmpfrtvc.unsortedFormrows = [tmpfrtvc.formRowsTableDataManager retrievePredicativeTableViewDataSource];
            [tmpfrtvc syncUnsortedFormRowsWithOriginal];
            tmpfrtvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:tmpfrtvc] autorelease];
            [tmpfrtvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        case 202: {
            LargeImageFormRowsSlideViewController* lifrsvc = [[LargeImageFormRowsSlideViewController alloc] initWithNibName:@"LargeImageFormRowsSlideViewController" bundle:nil];
            lifrsvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:lifrsvc] autorelease];
            [lifrsvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
            
        case 302: {
            LargeSmallImageFormRowsSlideViewController* lsifrsvc = [[LargeSmallImageFormRowsSlideViewController alloc] initWithNibName:@"LargeSmallImageFormRowsSlideViewController" bundle:nil];
            lsifrsvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:lsifrsvc] autorelease];
            [lsifrsvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
            
        case 303: {
            LargeSmallL3SearchFormRowSlideViewController* lsl3sfrsvc = [[LargeSmallL3SearchFormRowSlideViewController alloc] initWithNibName:@"LargeSmallL3SearchFormRowSlideViewController" bundle:nil];
            lsl3sfrsvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:lsl3sfrsvc] autorelease];
            [lsl3sfrsvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
            
        case 304: {
            LargeSmallFormDetailSlideViewController* lsfdsvc = [[LargeSmallFormDetailSlideViewController alloc] initWithNibName:@"LargeSmallFormDetailSlideViewController" bundle:nil];
            lsfdsvc.formIUR = [aCellDataDict objectForKey:@"IUR"];
            lsfdsvc.backButtonDelegate = self;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:lsfdsvc] autorelease];
            [lsfdsvc release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
        
        case 305: {            
            BranchLeafProductGridViewController* BLPGVC = [[BranchLeafProductGridViewController alloc] initWithNibName:@"BranchLeafProductGridViewController" bundle:nil];
            BLPGVC.navigationTitleDelegate = self;
            BLPGVC.backButtonDelegate = self;
            BLPGVC.branchLeafProductDataManager.formTypeNumber = aFormTypeNumber;
            BLPGVC.branchLeafProductDataManager.formIUR = [aCellDataDict objectForKey:@"IUR"];
            [BLPGVC.branchLeafProductDataManager getFormDividerWithFormIUR:BLPGVC.branchLeafProductDataManager.formIUR];
            BLPGVC.leafSmallTemplateViewController.leafSmallTemplateDataManager.displayList = [NSMutableArray arrayWithArray:BLPGVC.branchLeafProductDataManager.leafChildrenList];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:BLPGVC] autorelease];
            [BLPGVC release];
            self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
            [self.orderBaseTableContentView addSubview:self.globalNavigationController.view];
        }
            break;
            
        default:
            [self createBlankOrderPad];
            break;
    }
}

-(void)resetNavigationTitleToBeginStatus {
    [self configTitleToBlue];
    self.navigationItem.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
//    self.navigationItem.title = @"";
    [self hideHeaderLabelWithFlag:NO];
}

-(void)controlBackButtonAndNavigationTitle {
    if ([self.globalNavigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = nil;
        [self resetNavigationTitleToBeginStatus];
    }
}

- (void)layoutMySubviews {
    self.globalNavigationController.view.frame = self.orderBaseTableContentView.frame;
}

- (void)hideHeaderLabelWithFlag:(BOOL)aFlag {
    self.custNameHeaderLabel.hidden = aFlag;
    self.custAddrHeaderLabel.hidden = aFlag;
}

- (void)configTitleToWhite {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        // Fallback on earlier versions
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)configTitleToBlue {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        // Fallback on earlier versions
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
    }
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
}

@end
