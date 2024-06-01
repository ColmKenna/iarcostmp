//
//  NextCheckoutViewController.m
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutViewController.h"
#import "ArcosRootViewController.h"

@interface NextCheckoutViewController ()

- (void)stampLocation;
- (void)showNumberPadPopoverWithData:(NSMutableDictionary*)aCellDict;
- (void)configRightBarButtons;
@end

@implementation NextCheckoutViewController
@synthesize orderInfoTableView = _orderInfoTableView;
@synthesize tableDivider = _tableDivider;
@synthesize orderlinesTableView = _orderlinesTableView;
@synthesize nextCheckoutDataManager = _nextCheckoutDataManager;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize orderDetailsHeaderView = _orderDetailsHeaderView;
@synthesize contactDetailsHeaderView = _contactDetailsHeaderView;
@synthesize commentsHeaderView = _commentsHeaderView;
@synthesize followUpHeaderView = _followUpHeaderView;
@synthesize headerViewList = _headerViewList;
@synthesize orderInfoTableViewController = _orderInfoTableViewController;
@synthesize CLController = _CLController;
@synthesize checkoutDataManager = _checkoutDataManager;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize widgetFactory = _widgetFactory;
@synthesize myRootViewController = _myRootViewController;
@synthesize myAVAudioPlayer = _myAVAudioPlayer;
@synthesize isCheckoutSuccessful = _isCheckoutSuccessful;
@synthesize discountButton = _discountButton;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.nextCheckoutDataManager = [[[NextCheckoutDataManager alloc] init] autorelease];
        self.checkoutDataManager = [[[CheckoutDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    
    self.orderInfoTableView.backgroundColor = [UIColor whiteColor];
    self.tableCellFactory = [[[OrderlinesIarcosTableCellFactory alloc] init] autorelease];
    self.headerViewList = [NSMutableArray arrayWithObjects:self.orderDetailsHeaderView, self.contactDetailsHeaderView, self.commentsHeaderView, self.followUpHeaderView, nil];
    self.orderInfoTableViewController = [[[NextCheckoutOrderInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    self.orderInfoTableViewController.orderInfoDelegate = self;
    self.orderInfoTableViewController.tableView = self.orderInfoTableView;
    self.orderInfoTableViewController.tableView.dataSource = self.orderInfoTableViewController;
    self.orderInfoTableViewController.tableView.delegate = self.orderInfoTableViewController;
    
    
    [self addChildViewController:self.orderInfoTableViewController];
    [self.orderInfoTableViewController didMoveToParentViewController:self];
    self.CLController = [[[CoreLocationController alloc] init] autorelease];
    self.CLController.delegate = self;
    
    self.widgetFactory = [WidgetFactory factory];
    self.widgetFactory.delegate = self;
//    self.thePopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.thePopover.delegate = self;
    self.myRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    NSString* buzzerFilePath = [[NSBundle mainBundle] pathForResource:@"buzzer" ofType:@"wav"];
    NSURL* buzzerFileURL = [NSURL fileURLWithPath:buzzerFilePath];
    NSError* error;
    self.myAVAudioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:buzzerFileURL error:&error] autorelease];
    self.myAVAudioPlayer.delegate = self;
    self.myAVAudioPlayer.volume = 0.03;
    [self.myAVAudioPlayer prepareToPlay];
}

- (void)dealloc {
    [self.orderInfoTableViewController willMoveToParentViewController:nil];
    [self.orderInfoTableViewController removeFromParentViewController];
    
    self.orderInfoTableView = nil;
    self.tableDivider = nil;
    self.orderlinesTableView = nil;
    self.nextCheckoutDataManager = nil;
    self.tableCellFactory = nil;
    self.orderDetailsHeaderView = nil;
    self.contactDetailsHeaderView = nil;
    self.commentsHeaderView = nil;
    self.followUpHeaderView = nil;
    self.headerViewList = nil;
    self.orderInfoTableViewController = nil;
    self.CLController = nil;
    self.checkoutDataManager = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.widgetFactory = nil;
    self.myRootViewController = nil;
    self.myAVAudioPlayer = nil;
    self.discountButton = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)discountButtonPressed {
    self.globalWidgetViewController = [self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourcePriceGroup];
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromBarButtonItem:self.discountButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    if (self.globalWidgetViewController != nil) {
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.barButtonItem = self.discountButton;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

- (void)configRightBarButtons {
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveOrder)];
    [rightButtonList addObject:saveButton];
    self.discountButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"discount.png"] style:UIBarButtonItemStylePlain target:self action:@selector(discountButtonPressed)] autorelease];
    NSNumber* allowDiscount = [SettingManager SettingForKeypath:@"CompanySetting.Order Processing" atIndex:1];
    SettingManager* sm = [SettingManager setting];
    NSMutableDictionary* presenterPwdDict = [sm getSettingForKeypath:@"CompanySetting.Connection" atIndex:8];
    NSString* presenterPwd = [[presenterPwdDict objectForKey:@"Value"] uppercaseString];
    NSRange aBDRange = [presenterPwd rangeOfString:@"[BD]"];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"Details"]];
    if (([allowDiscount boolValue] || aBDRange.location != NSNotFound) && ![ArcosConfigDataManager sharedArcosConfigDataManager].recordInStockRBFlag && !([[ArcosConfigDataManager sharedArcosConfigDataManager] showRRPInOrderPadFlag] && ![orderFormDetails containsString:@"[BD]"]) && [[ArcosConfigDataManager sharedArcosConfigDataManager] useDiscountByPriceGroupFlag]) {
        [rightButtonList addObject:self.discountButton];
    }
    self.navigationItem.rightBarButtonItems = rightButtonList;
    [saveButton release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.checkoutDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"Details"]];
    [self configRightBarButtons];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveBarCodeCheckoutNotification:)
                                                     name:@"BarCodeNotification"
                                                   object:nil];
    }
//    self.nextCheckoutDataManager.orderLines = [OrderSharedClass sharedOrderSharedClass].currentOrderCart;
    [[OrderSharedClass sharedOrderSharedClass] refreshCurrentOrderDate];    
    if ([[GlobalSharedClass shared].currentSelectedContactIUR intValue] != 0) {
        NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
        if (tmpContactDict != nil) {
            NSString* fullName = [tmpContactDict objectForKey:@"Title"];
            [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:tmpContactDict forKey:@"contact"];
            [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:fullName forKey:@"contactText"];
        }
    }
//    NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSDate* defaultDeliveryDate = [self.checkoutDataManager.currentFormDetailDict objectForKey:@"DefaultDeliveryDate"];
    NSString* wholesalerListString = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"BackColor"]]];
    NSNumber* wholesalerList = [ArcosUtils convertStringToNumber:wholesalerListString];
    if ([wholesalerList intValue] != 0) {
        NSMutableArray* wholesalerObjectList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:wholesalerList];
        if ([wholesalerObjectList count] == 1) {
            NSMutableDictionary* wholesalerDict = [wholesalerObjectList objectAtIndex:0];
            [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:wholesalerDict forKey:@"wholesaler"];
            [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[wholesalerDict objectForKey:@"Name"] forKey:@"wholesalerText"];
        }
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] clearWholeSalerFlag]) {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:@"Touch to pick a wholesaler" forKey:@"wholesalerText"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"wholesaler"];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] clearOrderTypeFlag]) {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:@"Touch to pick an order type" forKey:@"orderTypeText"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"type"];
    }
    
    if ([defaultDeliveryDate compare:[NSDate date]] == NSOrderedDescending) {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[ArcosUtils addHours:0 date:defaultDeliveryDate] forKey:@"deliveryDate"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithBool:YES] forKey:@"deliveryDateYellowBG"];
    } else {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSDate date] forKey:@"deliveryDate"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithBool:NO] forKey:@"deliveryDateYellowBG"];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"wholesaler"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"wholesalerText"];
        NSMutableDictionary* tmpCurrentSelectedPackage = [[ArcosCoreData sharedArcosCoreData] retrievePackageWithIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault]];
        NSNumber* packageWholesalerIUR = [tmpCurrentSelectedPackage objectForKey:@"wholesalerIUR"];
        if ([packageWholesalerIUR intValue] != 0) {
            NSMutableArray* packageWholesalerObjectList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:packageWholesalerIUR];
            if ([packageWholesalerObjectList count] == 1) {
                NSMutableDictionary* packageWholesalerDict = [packageWholesalerObjectList objectAtIndex:0];
                [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:packageWholesalerDict forKey:@"wholesaler"];
                [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[packageWholesalerDict objectForKey:@"Name"] forKey:@"wholesalerText"];
            }
        }
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"acctNo"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader removeObjectForKey:@"acctNoText"];
        NSString* tmpAccountCode = [ArcosUtils convertNilToEmpty:[tmpCurrentSelectedPackage objectForKey:@"accountCode"]];
        NSMutableDictionary* acctNoDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [acctNoDict setObject:tmpAccountCode forKey:@"acctNo"];
        [acctNoDict setObject:tmpAccountCode forKey:@"Title"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:acctNoDict forKey:@"acctNo"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:tmpAccountCode forKey:@"acctNoText"];
    }
    [self refreshTotalGoods];
    [self.orderInfoTableViewController createBasicDataWithOrderHeader:[OrderSharedClass sharedOrderSharedClass].currentOrderHeader];
    [self.orderInfoTableView reloadData];
    
    self.nextCheckoutDataManager.sortedOrderKeys = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allValues]];
    
    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowTopxCustomerFlag]) {
        [self.checkoutDataManager retrieveTopxListWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR orderFormDetails:orderFormDetails];
        if (!self.checkoutDataManager.isNotFirstTimeCustomerMsg) {
            self.checkoutDataManager.isNotFirstTimeCustomerMsg = YES;
            int topxNum = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.checkoutDataManager.topxList count]];
            if (topxNum > 0) {
//                [ArcosUtils showMsg:[NSString stringWithFormat:@"%d top %d products have been excluded from order.", topxNum, self.checkoutDataManager.topxNumber] delegate:nil];
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%d top %d products have been excluded from order.", topxNum, self.checkoutDataManager.topxNumber] title:@"" target:self handler:nil];
            }
        }
    } else {
        self.checkoutDataManager.topxList = nil;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowTopxCompanyFlag]) {
        [self.checkoutDataManager retrieveTopCompanyProductsWithOrderFormDetails:orderFormDetails];
        if (!self.checkoutDataManager.isNotFirstTimeCompanyMsg) {
            self.checkoutDataManager.isNotFirstTimeCompanyMsg = YES;
            if (self.checkoutDataManager.flaggedProductsNumber > 0) {
//                [ArcosUtils showMsg:[NSString stringWithFormat:@"%d flagged products have been excluded from order.", self.checkoutDataManager.flaggedProductsNumber] delegate:nil];
                [ArcosUtils showDialogBox:[NSString stringWithFormat:@"%d flagged products have been excluded from order.", self.checkoutDataManager.flaggedProductsNumber] title:@"" target:self handler:nil];
            }
        }
    }
    [self.orderlinesTableView reloadData];
    [self stampLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarCodeNotification" object:nil];
    }
}

- (void)saveOrder {
    [self.view endEditing:YES];
    //save the order
    if ([[OrderSharedClass sharedOrderSharedClass] anyOrderLine]) {
        //check wholesaler
        if ([[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"wholesaler"] == nil) {
            [ArcosUtils showDialogBox:@"Please select a wholesaler" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
        NSNumber* wholesalerIUR = [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"wholesaler"] objectForKey:@"LocationIUR"];
        NSString* wholesalerLocationCode = @"";
        NSString* wholesalerLocationName = @"";
        NSNumber* wholesalerCompetitor3 = [NSNumber numberWithInt:0];
        NSMutableArray* fromLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:wholesalerIUR];
        if ([fromLocationList count] > 0) {
            NSDictionary* fromLocationDict = [fromLocationList objectAtIndex:0];
            wholesalerLocationCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[fromLocationDict objectForKey:@"LocationCode"]]];
            wholesalerLocationName = [[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[fromLocationDict objectForKey:@"Name"]]] lowercaseString];
            wholesalerCompetitor3 = [ArcosUtils convertNilToZero:[fromLocationDict objectForKey:@"Competitor3"]];
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] checkAccountNumberFlag] && [wholesalerCompetitor3 intValue] == 1) {
            NSMutableDictionary* acctNoDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"acctNo"];
            NSString* acctNoContent = [ArcosUtils trim:[acctNoDict objectForKey:@"acctNo"]];            
            if ([acctNoContent isEqualToString:@""]) {
                NSString* acctNoMsg = @"";
                NSMutableArray* descrDetailDictList = [self.nextCheckoutDataManager descrDetailAllFieldsWithDescrTypeCode:@"IO" hasDescrDetailCode:@"39"];
                if ([descrDetailDictList count] > 0) {
                    NSDictionary* descrDetailDict = [descrDetailDictList objectAtIndex:0];
                    acctNoMsg = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"Tooltip"]]];
                }
//                [ArcosUtils showDialogBox:acctNoMsg title:@"" delegate:nil target:self tag:0 handler:nil];
                ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
                if (@available(iOS 13.0, *)) {
                    arcosAlertBoxViewController.modalInPresentation = YES;
                }
                arcosAlertBoxViewController.disableSaveButtonFlag = YES;
                arcosAlertBoxViewController.messageContent = acctNoMsg;
                arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                arcosAlertBoxViewController.actionDelegate = self;
                [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
                [arcosAlertBoxViewController release];
                return;
            }
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] forceEnterCusRefOnCheckoutFlag] && [[ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"custRef"]] isEqualToString:@""]) {
            int lP20 = 0;
            NSMutableArray* refLocationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[GlobalSharedClass shared].currentSelectedLocationIUR];
            if (refLocationList != nil && [refLocationList count] > 0) {
                NSDictionary* refLocationDict = [refLocationList objectAtIndex:0];
                lP20 = [[refLocationDict objectForKey:@"lP20"] intValue];
            }
            if (lP20 != 0) {
//                [ArcosUtils showDialogBox:@"Please enter a customer reference" title:@"Warning" delegate:nil target:self tag:0 handler:nil];
                ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
                if (@available(iOS 13.0, *)) {
                    arcosAlertBoxViewController.modalInPresentation = YES;
                }
                arcosAlertBoxViewController.disableSaveButtonFlag = YES;
                arcosAlertBoxViewController.messageContent = @"Customer PO must be entered";
                arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                arcosAlertBoxViewController.actionDelegate = self;
                [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
                [arcosAlertBoxViewController release];
                return;
            }
        }
//        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] confirmOrderDetailsAtCheckoutFlag]) {
//            ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
//            if (@available(iOS 13.0, *)) {
//                arcosAlertBoxViewController.modalInPresentation = YES;
//            }
//            arcosAlertBoxViewController.checkWholesalerFlag = YES;
//            arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            arcosAlertBoxViewController.actionDelegate = self;
//            arcosAlertBoxViewController.view.tag = 3;
//            [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
//            [arcosAlertBoxViewController release];
//        } else {
//            [self enableVanSaleProcessor];
//        }
        NSMutableDictionary* statusDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"status"];
        NSString* statusDescrDetailCode = [ArcosUtils convertNilToEmpty:[statusDict objectForKey:@"DescrDetailCode"]];
        if (![statusDescrDetailCode isEqualToString:@"0000"]) {
            ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
            if (@available(iOS 13.0, *)) {
                arcosAlertBoxViewController.modalInPresentation = YES;
            }
            arcosAlertBoxViewController.checkWholesalerFlag = NO;
            arcosAlertBoxViewController.messageContent = [NSString stringWithFormat:@"This Order will not be processed InHouse, Status set to %@", [ArcosUtils convertNilToEmpty:[statusDict objectForKey:@"Title"]]];
            arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            arcosAlertBoxViewController.actionDelegate = self;
            arcosAlertBoxViewController.view.tag = 200;
            [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
            [arcosAlertBoxViewController release];
        } else {
            [self confirmOrderDetailsProcessor];
        }
    } else{
        [ArcosUtils showDialogBox:@"Order has no lines,please Re-enter or use 'new call!'" title:@"Warning" delegate:self target:self tag:888 handler:^(UIAlertAction *action) {
            [self backPressed:nil];
        }];
    }
}

- (void)confirmOrderDetailsProcessor {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] confirmOrderDetailsAtCheckoutFlag]) {
        ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
        if (@available(iOS 13.0, *)) {
            arcosAlertBoxViewController.modalInPresentation = YES;
        }
        arcosAlertBoxViewController.checkWholesalerFlag = YES;
        arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        arcosAlertBoxViewController.actionDelegate = self;
        arcosAlertBoxViewController.view.tag = 3;
        [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
        [arcosAlertBoxViewController release];
    } else {
        [self enableVanSaleProcessor];
    }
}

#pragma mark - ArcosAlertBoxViewControllerDelegate
- (void)amendButtonPressed:(ArcosAlertBoxViewController*)anAlertBox {
    [self dismissViewControllerAnimated:YES completion:^ {
        if (anAlertBox.view.tag == 100) {
            [self backPressed:nil];
        }
    }];
}
- (void)saveButtonPressed:(ArcosAlertBoxViewController*)anAlertBox {
    if (anAlertBox.view.tag == 100) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self checkoutSaveProcessor];
        }];
        return;
    }
    if (anAlertBox.view.tag == 200) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self confirmOrderDetailsProcessor];
        }];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self enableVanSaleProcessor];
    }];
}

- (void)enableVanSaleProcessor {
    NSMutableDictionary* auxOrderType = [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"type"];
    if (auxOrderType == nil) {
        [ArcosUtils showDialogBox:@"Please select an order type" title:@"Warning" delegate:nil target:self tag:0 handler:nil];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag] && ![[auxOrderType objectForKey:@"DescrDetailCode"] isEqualToString:[GlobalSharedClass shared].vansCode]) {
        void (^continueActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] checkTotalOrderValueFlag]) {
                [self checkTotalOrderValueProcessor];
            } else {
                [self checkoutSaveProcessor];
            }
        };
        void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            
        };
        [ArcosUtils showTwoBtnsDialogBox:@"Order type is not set as van sales. Do you want to continue" title:@"Warning" delegate:nil target:self tag:0 lBtnText:@"Cancel" rBtnText:@"Continue" lBtnHandler:cancelActionHandler rBtnHandler:continueActionHandler];
    } else if ([[ArcosConfigDataManager sharedArcosConfigDataManager] checkTotalOrderValueFlag]) {
        [self checkTotalOrderValueProcessor];
    } else {
        [self checkoutSaveProcessor];
    }
}

- (void)checkTotalOrderValueProcessor {
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[GlobalSharedClass shared].currentSelectedLocationIUR];
    BOOL showMsgFlag = NO;
    if (locationList != nil && [locationList count] > 0) {
        NSDictionary* locationDict = [locationList objectAtIndex:0];
        NSNumber* LTiurNumber = [locationDict objectForKey:@"LTiur"];
        NSDictionary* LTiurDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:LTiurNumber];
        if (LTiurDict != nil) {
            if ([[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalGoods"] floatValue] < [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100) {
                showMsgFlag = YES;
//                NSString* errorTitle = @"Minimum Order Value required";
//                NSString* errorMsg = [ArcosUtils trim:[NSString stringWithFormat:@"%@ must have a minimum Order Value of %.0f\nShortfall of %.2f\n%@", [ArcosUtils convertNilToEmpty:[LTiurDict objectForKey:@"Detail"]], [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100, [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100 - [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalGoods"] floatValue],[ArcosUtils convertNilToEmpty:[LTiurDict objectForKey:@"Tooltip"]]]];
                NSString* errorMsg = [ArcosUtils trim:[NSString stringWithFormat:@"Minimum Order Value of %.2f Required.\nShortfall is %.2f", [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100, [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100 - [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalGoods"] floatValue]]];
//                void (^saveAnywayActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
//                    [self checkoutSaveProcessor];
//                };
//                void (^continueOrderActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
//                    [self backPressed:nil];
//                };
//                void (^okActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
//                    
//                };
                
                if ([[LTiurDict objectForKey:@"Toggle1"] boolValue]) {
//                    [ArcosUtils showTwoBtnsDialogBox:errorMsg title:errorTitle delegate:self target:self tag:75 lBtnText:@"Save Anyway" rBtnText:@"Continue Order" lBtnHandler:saveAnywayActionHandler rBtnHandler:continueOrderActionHandler];
                    ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
                    if (@available(iOS 13.0, *)) {
                        arcosAlertBoxViewController.modalInPresentation = YES;
                    }
                    arcosAlertBoxViewController.view.tag = 100;
                    arcosAlertBoxViewController.disableSaveButtonFlag = NO;
                    arcosAlertBoxViewController.messageContent = errorMsg;
                    arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    arcosAlertBoxViewController.actionDelegate = self;
                    [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
                    [arcosAlertBoxViewController release];
                } else {
//                    [ArcosUtils showDialogBox:errorMsg title:errorTitle delegate:self target:self tag:0 handler:okActionHandler];
//                    NSString* errorMsg = [ArcosUtils trim:[NSString stringWithFormat:@"Minimum Order Value of %.2f Required.\nShortfall is %.2f", [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100, [[LTiurDict objectForKey:@"Dec1"] floatValue] / 100 - [[[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"TotalGoods"] floatValue]]];
                    ArcosAlertBoxViewController* arcosAlertBoxViewController = [[ArcosAlertBoxViewController alloc] initWithNibName:@"ArcosAlertBoxViewController" bundle:nil];
                    if (@available(iOS 13.0, *)) {
                        arcosAlertBoxViewController.modalInPresentation = YES;
                    }
                    arcosAlertBoxViewController.disableSaveButtonFlag = YES;
                    arcosAlertBoxViewController.messageContent = errorMsg;
                    arcosAlertBoxViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    arcosAlertBoxViewController.actionDelegate = self;
                    [self presentViewController:arcosAlertBoxViewController animated:YES completion:nil];
                    [arcosAlertBoxViewController release];
                }
            }
        }
    }
    if (!showMsgFlag) {
        [self checkoutSaveProcessor];
    }
}

- (void)checkoutSaveProcessor {
    NSMutableDictionary* auxOrderType = [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader objectForKey:@"type"];
    NSString* auxOrderTypeDescrDetailCode = [NSString stringWithFormat:@"%@", [auxOrderType objectForKey:@"DescrDetailCode"]];
    NSNumber* orderNumberResult = [NSNumber numberWithInt:0];
    self.isCheckoutSuccessful = [[OrderSharedClass sharedOrderSharedClass] saveCurrentOrder:&orderNumberResult];
    if (!self.isCheckoutSuccessful) {
        [ArcosUtils showDialogBox:@"Unable to save order, please check the default settings" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        }];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableVanSaleFlag] && [auxOrderTypeDescrDetailCode isEqualToString:[GlobalSharedClass shared].vansCode]) {
        NSMutableDictionary* auxOrderHeader = [[ArcosCoreData sharedArcosCoreData] editingOrderHeaderWithOrderNumber:orderNumberResult];
        CheckoutPrinterWrapperViewController* cpwvc = [[CheckoutPrinterWrapperViewController alloc] initWithNibName:@"CheckoutPrinterWrapperViewController" bundle:nil];
        cpwvc.checkoutPrinterRequestSource = CheckoutPrinterCheckout;
//        cpwvc.myDelegate = self;
        cpwvc.modalDelegate = self;
        cpwvc.orderHeader = auxOrderHeader;
        cpwvc.packageIUR = [[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourceDefault];
        if (@available(iOS 13.0, *)) {
            cpwvc.modalInPresentation = YES;
        }
//        if ([cpwvc respondsToSelector:@selector(isModalInPresentation)]) {
//            cpwvc.modalInPresentation = YES;
//        }
        cpwvc.modalPresentationStyle = UIModalPresentationFormSheet;
        cpwvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:cpwvc animated:YES completion:^{
            
        }];
        [cpwvc release];
    } else {
        [self checkOrderSaving:self.isCheckoutSuccessful];
    }
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        [self checkOrderSaving:self.isCheckoutSuccessful];
    }];
}

#pragma marks CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self dismissViewControllerAnimated:YES completion:^{
        [self checkOrderSaving:self.isCheckoutSuccessful];
    }];    
}

-(void)checkOrderSaving:(BOOL)isSuccess{
//    if (!isSuccess) {
//        
//    } else {
//        
//    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        [GlobalSharedClass shared].currentSelectedPackageIUR = nil;
        [GlobalSharedClass shared].packageViewCount = 0;
    }
    [GlobalSharedClass shared].lastOrderFormIUR = [NSNumber numberWithInt:[[OrderSharedClass sharedOrderSharedClass].currentFormIUR intValue]];
    [OrderSharedClass sharedOrderSharedClass].currentFormIUR=nil;
    [GlobalSharedClass shared].currentSelectedOrderLocationIUR = nil;
    [GlobalSharedClass shared].currentSelectedPresenterLocationIUR = nil;
    [[OrderSharedClass sharedOrderSharedClass].lastPositionDict removeAllObjects];
    
    int itemIndex = [self.myRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.requestSourceName];
    
    [self.myRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
    if ([GlobalSharedClass shared].currentSelectedCallLocationIUR == nil && [GlobalSharedClass shared].currentSelectedSurveyLocationIUR == nil) {
        NSMutableDictionary* topTabBarCellDict = [self.myRootViewController.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
        ArcosStackedViewController* myArcosStackedViewController = [topTabBarCellDict objectForKey:@"MyCustomController"];
        NSArray* tmpControllerList = myArcosStackedViewController.rcsViewControllers;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideCustomerDetailsAfterUpdateFlag] && [tmpControllerList count] >= 2) {
            UINavigationController* customerInfoNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:1];
            CustomerInfoTableViewController* citvc = [customerInfoNavigationController.viewControllers objectAtIndex:0];
            [citvc addCoverHomePageImageView];
            myArcosStackedViewController.topVisibleNavigationController = customerInfoNavigationController;
        }
    }
    
    
    [FileCommon removeFileAtPath:[FileCommon orderRestorePlistPath]];
    
    [ArcosUtils showDialogBox:[NSString stringWithFormat: @"Order Saved for %@", [[OrderSharedClass sharedOrderSharedClass]currentCustomerName]] title:@"Message" delegate:self target:self tag:99 handler:^(UIAlertAction *action) {
        [self saveButtonCallBack];
    }];
}

- (void)saveButtonCallBack {
    @try {
        self.orderlinesTableView.dataSource = nil;
        self.orderlinesTableView.delegate = nil;
        NSMutableDictionary* subOrderCellDict = [self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.displayList objectAtIndex:0];
        UINavigationController* orderNavigationController = (UINavigationController*)[subOrderCellDict objectForKey:self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.myCustomControllerTitle];
        NewOrderViewController* newOrderViewController = [orderNavigationController.viewControllers objectAtIndex:0];
        newOrderViewController.isNotFirstLoaded = NO;
        [[newOrderViewController.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSMutableDictionary* subPresenterCellDict = [self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.displayList objectAtIndex:1];
        UINavigationController* presenterNavigationController = (UINavigationController*)[subPresenterCellDict objectForKey:self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.myCustomControllerTitle];
        int checkoutRequestIndex = [ArcosUtils convertNSUIntegerToUnsignedInt:self.myRootViewController.customerMasterViewController.subMenuListingTableViewController.currentIndexPath.row];
        int presenterCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[presenterNavigationController.viewControllers count]];
        if (checkoutRequestIndex == 0) {
            for (int i = presenterCount - 1; i > 0; i--) {
                [presenterNavigationController popViewControllerAnimated:NO];
            }
            if ([orderNavigationController.viewControllers count] > 1) {
                [orderNavigationController popViewControllerAnimated:NO];
            }
        }
        if (checkoutRequestIndex == 1) {
            if ([orderNavigationController.viewControllers count] > 1) {
                [orderNavigationController popViewControllerAnimated:NO];
            }
            for (int i = presenterCount - 1; i > 0; i--) {
                [presenterNavigationController popViewControllerAnimated:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Reset NewOrderViewController%@", [exception reason]);
    }
}

- (void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma marks alert delegate
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==88) {
        int itemIndex = [self.myRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
        self.myRootViewController.customerMasterViewController.currentIndexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
        [self.myRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:self.myRootViewController.customerMasterViewController.currentIndexPath];
    }
    if (alertView.tag==888) {
        [self backPressed:nil];
    }
    if (alertView.tag == 99) {
        [self saveButtonCallBack];
    }
    if (alertView.tag == 75) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self checkoutSaveProcessor];
        } else {
            [self backPressed:nil];
        }
    }
}
*/
#pragma mark NextCheckoutOrderInfoDelegate

- (UIView*)retrieveOrderInfoHeaderView:(NSInteger)aSection {
    return [self.headerViewList objectAtIndex:aSection];
}

- (void)refreshTotalGoods {
    int totalProducts = 0;
    float totalValue = 0.0f;
    int totalBonus = 0;
    int totalQty = 0;
    float totalVAT = 0.0f;
//    NSMutableDictionary* descrDetailDictHashMap = nil;
//    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
//        NSMutableArray* sortedOrderKeyList = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allValues]];
//        NSMutableDictionary* VCIURHashMap = [NSMutableDictionary dictionaryWithCapacity:[sortedOrderKeyList count]];
//        for (int i = 0; i < [sortedOrderKeyList count]; i++) {
//            NSString* tmpOrderKey = [sortedOrderKeyList objectAtIndex:i];
//            NSMutableDictionary* tmpOrderLineDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:tmpOrderKey];
//            NSNumber* tmpVCIUR = [tmpOrderLineDict objectForKey:@"VCIUR"];
//            [VCIURHashMap setObject:tmpVCIUR forKey:tmpVCIUR];
//        }
//        NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:[NSMutableArray arrayWithArray:[VCIURHashMap allKeys]]];
//        descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
//        for (int i = 0; i < [descrDetailDictList count]; i++) {
//            NSDictionary* tmpDescrDetailDict = [descrDetailDictList objectAtIndex:i];
//            [descrDetailDictHashMap setObject:tmpDescrDetailDict forKey:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]];
//        }
//    }
    
    for(NSString* aKey in [OrderSharedClass sharedOrderSharedClass].currentOrderCart){
        NSMutableDictionary* aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:aKey];
        NSNumber* isSelected = [aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            totalProducts++;
            totalValue += [[aDict objectForKey:@"LineValue"] floatValue];
            totalBonus += [[aDict objectForKey:@"Bonus"] intValue];
            totalQty += [[aDict objectForKey:@"Qty"] intValue];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
//                NSNumber* tmpVCIUR = [aDict objectForKey:@"VCIUR"];
//                NSDictionary* tmpDescrDetailDict = [descrDetailDictHashMap objectForKey:tmpVCIUR];
//                if (tmpDescrDetailDict != nil) {
//                    totalVAT += [[aDict objectForKey:@"LineValue"] floatValue] / 100 * [[tmpDescrDetailDict objectForKey:@"Dec1"] floatValue];
//                }
                totalVAT += [[aDict objectForKey:@"vatAmount"] floatValue];
            }
        }
    }
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:totalValue] forKey:@"TotalGoods"];
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:totalVAT] forKey:@"TotalVat"];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSString stringWithFormat:@"%1.2f", totalValue] forKey:@"totalGoodsText"];
    } else {
//        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSString stringWithFormat:@"Goods: %.2f VAT: %.2f Total: %.2f", totalValue, totalVAT, (totalValue + totalVAT)] forKey:@"totalGoodsText"];
        [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSString stringWithFormat:@"%1.2f", (totalValue + totalVAT)] forKey:@"totalGoodsText"];
    }
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:totalQty] forKey:@"TotalQty"];
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:totalBonus] forKey:@"TotalBonus"];
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:totalProducts] forKey:@"NumberOflines"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [[OrderSharedClass sharedOrderSharedClass].currentOrderCart count];
    }
    if (section == 1) {
        return [self.checkoutDataManager.topxList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* cellData = nil;
    if (indexPath.section == 0) {
        NSString* name = [self.nextCheckoutDataManager.sortedOrderKeys objectAtIndex:indexPath.row];
        cellData = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:name];
    }
    if (indexPath.section == 1) {
        cellData = [self.checkoutDataManager.topxList objectAtIndex:indexPath.row];
    }
    OrderlinesIarcosBaseTableViewCell* cell = (OrderlinesIarcosBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (OrderlinesIarcosBaseTableViewCell*)[self.tableCellFactory createOrderlinesIarcosBaseTableViewCellWithData:cellData];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        [cell.contentView addGestureRecognizer:singleTap];
        [singleTap release];
    }
    // Configure the cell...
    //fill data for cell
    [cellData setObject:[cellData objectForKey:@"Details"] forKey:@"Description"];
    [cell configCellWithData:cellData];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:sender tableview:self.orderlinesTableView];
        self.checkoutDataManager.currentIndexPath = swipedIndexPath;
        //get order line
        NSMutableDictionary* aDict = nil;
        if (swipedIndexPath.section == 0) {
            NSString* name = [self.nextCheckoutDataManager.sortedOrderKeys objectAtIndex:swipedIndexPath.row];
            aDict = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:name];
        }
        if (swipedIndexPath.section == 1) {
            aDict = [self.checkoutDataManager.topxList objectAtIndex:swipedIndexPath.row];
        }
        [self showNumberPadPopoverWithData:aDict];
    }
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender {
    
}

- (void)stampLocation {
    [self.CLController start];
}

#pragma mark CoreLocationControllerDelegate
- (void)locationUpdate:(CLLocation *)location {
//    NSLog(@"aa %f %f", location.coordinate.latitude, location.coordinate.longitude);
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"latitude"];
    [[OrderSharedClass sharedOrderSharedClass].currentOrderHeader setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"longitude"];
    [self.CLController stop];
}

- (void)locationError:(NSError *)error {
//    NSLog(@"location is coming back with error");
    [self.CLController stop];
}

- (void)showNumberPadPopoverWithData:(NSMutableDictionary*)aCellDict {
    CGRect aRect = CGRectMake(self.myRootViewController.view.bounds.size.width - 10, self.myRootViewController.view.bounds.size.height - 10, 1, 1);
//    BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
    
    //popover the input pad
//    self.thePopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.thePopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.thePopover.delegate = self;
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
        if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
            self.globalWidgetViewController = [self.widgetFactory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        } else {
            self.globalWidgetViewController = [self.widgetFactory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        }
        
//        WidgetViewController* wvc = (WidgetViewController*)self.thePopover.contentViewController;
        self.globalWidgetViewController.Data = aCellDict;
    } else {
        self.globalWidgetViewController = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*)self.globalWidgetViewController;
        oipvc.Data = aCellDict;
//        oipvc.showSeparator = showSeparator;
        oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
        if (!arcosErrorResult.successFlag) {
            [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
    
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromRect:aRect inView:self.myRootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.sourceView = self.myRootViewController.view;
    self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.globalWidgetViewController.popoverPresentationController.delegate = self;
    [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

#pragma mark WidgetFactoryDelegate
- (void)operationDone:(id)data {
    if ([self.globalWidgetViewController isKindOfClass:[PickerWidgetViewController class]]) {
        NSNumber* descrDetailIUR = [data objectForKey:@"DescrDetailIUR"];
        NSMutableArray* productIURList = [NSMutableArray arrayWithCapacity:[self.nextCheckoutDataManager.sortedOrderKeys count]];
        for (int i = 0; i < [self.nextCheckoutDataManager.sortedOrderKeys count]; i++) {
            NSString* tmpCombinationKey = [self.nextCheckoutDataManager.sortedOrderKeys objectAtIndex:i];
            NSMutableDictionary* tmpCellData = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:tmpCombinationKey];
            [productIURList addObject:[tmpCellData objectForKey:@"ProductIUR"]];
        }
        NSMutableDictionary* priceHashMap = [[ArcosCoreData sharedArcosCoreData] retrievePriceWithLocationIUR:descrDetailIUR productIURList:productIURList];
        for (int j = 0; j < [self.nextCheckoutDataManager.sortedOrderKeys count]; j++) {
            NSString* tmpCombinationKey = [self.nextCheckoutDataManager.sortedOrderKeys objectAtIndex:j];
            NSMutableDictionary* tmpCellData = [[OrderSharedClass sharedOrderSharedClass].currentOrderCart objectForKey:tmpCombinationKey];
            NSNumber* tmpProductIUR = [tmpCellData objectForKey:@"ProductIUR"];
            NSDictionary* tmpPriceDict = [priceHashMap objectForKey:tmpProductIUR];
            if (tmpPriceDict == nil) continue;
            NSDecimalNumber* tmpDiscountPercent = [tmpPriceDict objectForKey:@"DiscountPercent"];
            [tmpCellData setObject:[NSNumber numberWithFloat:[tmpDiscountPercent floatValue]] forKey:@"DiscountPercent"];
            [tmpCellData setObject:[ProductFormRowConverter calculateLineValue:tmpCellData] forKey:@"LineValue"];
        }
        [self.orderlinesTableView reloadData];
        [self.view endEditing:YES];
        [self refreshTotalGoods];
        [self.orderInfoTableViewController createBasicDataWithOrderHeader:[OrderSharedClass sharedOrderSharedClass].currentOrderHeader];
        [self.orderInfoTableView reloadData];
//        if ([self.thePopover isPopoverVisible]) {
//            [self.thePopover dismissPopoverAnimated:YES];
//        }
        [self dismissViewControllerAnimated:YES completion:^ {
            self.globalWidgetViewController = nil;
        }];
        return;
    }
    if (self.checkoutDataManager.currentIndexPath.section == 0) {
        [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
    }
    if (self.checkoutDataManager.currentIndexPath.section == 1) {
        NSNumber* isSelected = [data objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
            [self.checkoutDataManager removeTopxElementWithDataDict:data];
        }
    }
    self.nextCheckoutDataManager.sortedOrderKeys = [[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[[OrderSharedClass sharedOrderSharedClass].currentOrderCart allValues]];
    [self.orderlinesTableView reloadData];
    
    [self.view endEditing:YES];
    [self refreshTotalGoods];
    [self.orderInfoTableViewController createBasicDataWithOrderHeader:[OrderSharedClass sharedOrderSharedClass].currentOrderHeader];
    [self.orderInfoTableView reloadData];
//    [self selectionTotal];
//    if ([self.thePopover isPopoverVisible]) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [self dismissViewControllerAnimated:YES completion:^ {
        self.globalWidgetViewController = nil;
    }];
}

- (void)receiveBarCodeCheckoutNotification:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString* barcode = [userInfo objectForKey:@"BarCode"];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"Details"]];
    NSMutableArray* productList = [self.checkoutDataManager productWithDescriptionKeyword:barcode orderFormDetails:orderFormDetails];
//    if ([self.thePopover isPopoverVisible]) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    if (self.globalWidgetViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:^ {
            self.globalWidgetViewController = nil;
        }];
    }
    if ([productList count] > 0) {
        NSMutableDictionary* auxProductDict = [productList objectAtIndex:0];
        self.checkoutDataManager.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([self.checkoutDataManager checkScannedProductInTopxList:auxProductDict]) {
            self.checkoutDataManager.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        }
        [self showNumberPadPopoverWithData:auxProductDict];
    } else {
        //        [ArcosUtils showMsg:@"No data found" delegate:nil];
        [self.myAVAudioPlayer play];
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
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if ([self.thePopover.contentViewController isKindOfClass:[OrderInputPadViewController class]]) {
//        if ([self.thePopover isPopoverVisible]) {
//            [self.thePopover dismissPopoverAnimated:NO];
//            CGRect aRect = CGRectMake(self.myRootViewController.view.bounds.size.width - 10, self.myRootViewController.view.bounds.size.height - 10, 1, 1);
//            [self.thePopover presentPopoverFromRect:aRect inView:self.myRootViewController.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
//        }
//    }
//}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (self.presentedViewController != nil && [self.presentedViewController isKindOfClass:[WidgetViewController class]] && ![self.presentedViewController isKindOfClass:[PickerWidgetViewController class]]) {
            CGRect aRect = CGRectMake(self.myRootViewController.view.bounds.size.width - 10, self.myRootViewController.view.bounds.size.height - 10, 1, 1);
            self.globalWidgetViewController.popoverPresentationController.sourceRect = aRect;
        }
    }];
}

@end
