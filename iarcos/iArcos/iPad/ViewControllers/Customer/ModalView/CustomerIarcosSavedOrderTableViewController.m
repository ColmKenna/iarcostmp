//
//  CustomerIarcosSavedOrderTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 03/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerIarcosSavedOrderTableViewController.h"
#import "ArcosStackedViewController.h"

@interface CustomerIarcosSavedOrderTableViewController ()
- (void)deleteCurrentOrderHeader;
- (void)processNextNavControllerAfterDeleting;
- (void)processNextNavControllerAfterSending:(NSNumber*)orderNumber;
- (void)refreshTheList;
- (void)stopAllCellAnimation;
- (void)stopCellAnimationWithOrderNumber:(NSNumber*)orderNumber withStatus:(BOOL)status;
- (void)checkConnection;
- (void)updateOrderHeaderWithOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber*)newOrderNumber;
- (void)processSqlStatementByType:(int)aType;
@end

@implementation CustomerIarcosSavedOrderTableViewController
@synthesize locationIUR = _locationIUR;
@synthesize locationDefaultContactIUR = _locationDefaultContactIUR;
@synthesize customerIarcosSavedOrderDataManager = _customerIarcosSavedOrderDataManager;
@synthesize senderCenter = _senderCenter;
//@synthesize arcosConfigDataManager = _arcosConfigDataManager;
@synthesize savedOrderPresenterTranDataManager = _savedOrderPresenterTranDataManager;
@synthesize remoteButton = _remoteButton;
@synthesize callGenericServices = _callGenericServices;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize coordinateType = _coordinateType;
@synthesize HUD = _HUD;

- (void)dealloc {
    self.locationIUR = nil;
    self.locationDefaultContactIUR = nil;
    self.customerIarcosSavedOrderDataManager = nil;
    self.senderCenter.delegate = nil;
    self.senderCenter = nil;
    connectivityCheck.delegate = nil;
    [connectivityCheck release];
//    self.arcosConfigDataManager = nil;
    self.savedOrderPresenterTranDataManager = nil;
    self.remoteButton = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.factory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.coordinateType = nil;
    self.HUD = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.customerIarcosSavedOrderDataManager = [[[CustomerIarcosSavedOrderDataManager alloc] init] autorelease];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
    [rightButtonList addObject:editButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    [editButton release];
    self.senderCenter = [OrderSenderCenter center];
    self.senderCenter.delegate = self;
    connectivityCheck = [[ConnectivityCheck alloc]init];
    connectivityCheck.delegate = self;
//    self.arcosConfigDataManager = [[[ArcosConfigDataManager alloc] init] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        self.savedOrderPresenterTranDataManager = [[[SavedOrderPresenterTranDataManager alloc] init] autorelease];
    }
    self.remoteButton = [[[UIBarButtonItem alloc] initWithTitle:@"Remote" style:UIBarButtonItemStylePlain target:self action:@selector(remoteButtonPressed:)] autorelease];
    [self.navigationItem setLeftBarButtonItem:self.remoteButton];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
}

- (void)remoteButtonPressed:(id)sender {
//    NSString* sqlStatement = [NSString stringWithFormat:@"select * from orderview where LocationIUR = %@ order by date desc", self.locationIUR];
//    [self.callGenericServices getData: sqlStatement];
    if (self.customerIarcosSavedOrderDataManager.remoteTableDataDictList == nil) {
        self.customerIarcosSavedOrderDataManager.remoteTableDataDictList = [self.customerIarcosSavedOrderDataManager createTableDataDictList];
    }
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:self.customerIarcosSavedOrderDataManager.remoteTableDataDictList withTitle:@"Remote" withParentContentString:@"" requestSource:TableWidgetRequestSourceListing];
    //do show the popover if there is no data
//    if (self.thePopover != nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromBarButtonItem:self.remoteButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    }
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.barButtonItem = self.remoteButton;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshTheList];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];    
    if (self.HUD != nil) {
        self.HUD.frame = self.navigationController.view.frame;
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.customerIarcosSavedOrderDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerIarcosSavedOrderTableCell";
    
    CustomerIarcosSavedOrderTableCell* cell = (CustomerIarcosSavedOrderTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerIarcosSavedOrderTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerIarcosSavedOrderTableCell class]] && [[(CustomerIarcosSavedOrderTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerIarcosSavedOrderTableCell *) nibItem;
                cell.delegate = self;
            }
        }
    }
    
    // Configure the cell...
    NSMutableDictionary* cellData = [self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    NSMutableDictionary* cellData = [self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:indexPath.row];
    BOOL isSealled = [[cellData objectForKey:@"IsSealed"]boolValue];
    
    if (isSealled) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        self.customerIarcosSavedOrderDataManager.currentSelectedOrderHeader = [self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:indexPath.row];
        [self deleteOrderHeader:self.customerIarcosSavedOrderDataManager.currentSelectedOrderHeader];
    }
}

- (void)deleteOrderHeader:(NSMutableDictionary*)data {
    NSString* requestSourceText = nil;
    if ([[data objectForKey:@"NumberOflines"] intValue] > 0) {
        requestSourceText = @"Order";
    } else {
        requestSourceText = @"Call";
    }
    NSMutableArray* aLocaiton = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:[data objectForKey:@"LocationIUR"]];
    NSString* locationName = @"";
    if (aLocaiton != nil) {
        locationName = [[aLocaiton objectAtIndex:0] objectForKey:@"Name"];
    }
    
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete the %@ for %@",requestSourceText,locationName] delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete" otherButtonTitles:@"Cancel",nil];
//
//    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//    [actionSheet showInView:self.view];
//    [actionSheet release];
    void (^deleteActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteCurrentOrderHeader];
    };
    void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:[NSString stringWithFormat:@"Are you sure you want to delete the %@ for %@",requestSourceText,locationName] title:@"" target:self lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
}

- (void)deleteCurrentOrderHeader {
    BOOL resultFlag = [[ArcosCoreData sharedArcosCoreData] deleteOrderHeaderWithOrderNumber:[self.customerIarcosSavedOrderDataManager.currentSelectedOrderHeader objectForKey:@"OrderNumber"]];
    if (resultFlag) {
        [self.customerIarcosSavedOrderDataManager.displayList removeObject:self.customerIarcosSavedOrderDataManager.currentSelectedOrderHeader];
        [self.tableView reloadData];
        [self processNextNavControllerAfterDeleting];
    }
}

- (void)processNextNavControllerAfterDeleting {
    int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
    if (currentIndex == [self.rcsStackedController.rcsViewControllers count] - 1) return;
    UINavigationController* nextNavigationController = [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:-1];
    SavedIarcosOrderDetailTableViewController* SIODTVC = [nextNavigationController.viewControllers objectAtIndex:0];
    if ([[SIODTVC.savedOrderDetailCellData objectForKey:@"OrderNumber"] isEqualToNumber:[self.customerIarcosSavedOrderDataManager.currentSelectedOrderHeader objectForKey:@"OrderNumber"]]) {
        [self.rcsStackedController popToNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    }
}

- (void)processNextNavControllerAfterSending:(NSNumber*)orderNumber {
    int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
    if (currentIndex == [self.rcsStackedController.rcsViewControllers count] - 1) return;
    UINavigationController* nextNavigationController = [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:-1];
    SavedIarcosOrderDetailTableViewController* SIODTVC = [nextNavigationController.viewControllers objectAtIndex:0];
    if ([[SIODTVC.savedOrderDetailCellData objectForKey:@"OrderNumber"] isEqualToNumber:orderNumber]) {
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:self.customerIarcosSavedOrderDataManager.sendingIndexPath];
    }
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:indexPath.row];
    SavedIarcosOrderDetailTableViewController* SIODTVC = [[SavedIarcosOrderDetailTableViewController alloc] initWithNibName:@"SavedIarcosOrderDetailTableViewController" bundle:nil];
    SIODTVC.orderlinesIarcosTableViewControllerDelegate = self;
    SIODTVC.savedOrderDetailCellData = cellData;
    SIODTVC.coordinateType = self.coordinateType;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:SIODTVC];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController *)self.parentViewController animated:YES];
    [SIODTVC release];
    [tmpNavigationController release];
}

#pragma mark OrderlinesIarcosTableViewControllerDelegate
-(void)deleteIarcosOrderHeaderWithOrderNumber:(NSNumber*)anOrderNumber {
    
}
-(void)totalGoodsUpdateIarcosForOrderNumber:(NSNumber*)anOrderNumber withValue:(NSNumber*)aTotalGoods totalVat:(NSNumber*)aTotalVat {
    [self refreshTheList];
}
- (void)refreshCustomerIarcosSavedOrderDataList {
    [self refreshTheList];
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

- (void)pressAllButton:(id)sender {
    [self.rcsStackedController popToNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    self.customerIarcosSavedOrderDataManager.displayList = nil;
    [self processSqlStatementByType:1];
}

- (void)refreshTheList {
    if ([self.coordinateType intValue] == 1) return;
    [self.customerIarcosSavedOrderDataManager orderListingWithLocationIUR:self.locationIUR locationDefaultContactIUR:self.locationDefaultContactIUR];
    [self.tableView reloadData];
}

#pragma mark UIActionSheetDelegate
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0://ok button remove current order line
            [self deleteCurrentOrderHeader];
            break;
        default:
            break;
    }
}
*/
#pragma mark CustomerIarcosSavedOrderDelegate
- (void)sendPressedForCell:(CustomerIarcosSavedOrderTableCell *)cell {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        [self.savedOrderPresenterTranDataManager processPresenterTransaction];
    }
    NSNumber* orderNumber = [cell.cellData objectForKey:@"OrderNumber"];
    self.customerIarcosSavedOrderDataManager.sendingIndexPath = cell.indexPath;
    self.customerIarcosSavedOrderDataManager.sendingOrderNumber = orderNumber;
    
    [self.senderCenter addSenderWithOrderNumber:orderNumber];
    [cell animate];
    [self checkConnection];
}
#pragma mark OrderSenderCenterDelegate
-(void)sendingStatus:(BOOL)isSuccess withReason:(NSString*)reason forOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber*)newOrderNumber {
    self.customerIarcosSavedOrderDataManager.sendingSuccessFlag = isSuccess;
    if (orderNumber==nil) {
        return;
    }
    if (self.customerIarcosSavedOrderDataManager.sendingSuccessFlag && [self.senderCenter.ordersQueue count] == 0) {
        
    } else {
        [self stopCellAnimationWithOrderNumber:orderNumber withStatus:isSuccess];
    }
    
    if (!isSuccess) {
//        [ArcosUtils showMsg:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" delegate:nil];
        [ArcosUtils showDialogBox:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" target:self handler:nil];
        
        [self needSealTheCellWithOrderNumber:orderNumber need:NO];
        
    }else{
        
        [self updateOrderHeaderWithOrderNumber:orderNumber withNewOrderNumber:newOrderNumber];
    }
}
-(void)Error1003:(NSError*)error forOrderNumber:(NSNumber*)orderNumber {
    if (orderNumber==nil) {
        return;
    }
    [self stopCellAnimationWithOrderNumber:orderNumber withStatus:NO];
}
-(void)ServerFaultWithOrderNumber:(NSNumber*)orderNumber {
    NSString* reason=@"Server Fault";
    
//    [ArcosUtils showMsg:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" delegate:nil];
    [ArcosUtils showDialogBox:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" target:self handler:nil];
    //stop all animations
    [self stopAllCellAnimation];
}
-(void)timeOutForOrderNumber:(NSNumber*)orderNumber {
    [self stopCellAnimationWithOrderNumber:orderNumber withStatus:NO];
    
//    [ArcosUtils showMsg:@"Time out for the order sending" title:@"Warning" delegate:nil];
    [ArcosUtils showDialogBox:@"Time out for the order sending" title:@"Warning" target:self handler:nil];
}
-(void)allOrdersDone:(NSNumber*)totalOrderSent {
    if (self.HUD != nil) {
        [self.HUD hide:YES];
    }
    if (self.customerIarcosSavedOrderDataManager.sendingSuccessFlag) {
        [self stopCellAnimationWithOrderNumber:self.senderCenter.currentOrderNumber withStatus:self.customerIarcosSavedOrderDataManager.sendingSuccessFlag];
    }
    
    NSString* tmpMsg = [NSString stringWithFormat:@"%d order(s) has been sent to HQ",[totalOrderSent intValue]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] uploadPhotoAfterSendingOrderFlag]) {
        int successfulFileCount = self.senderCenter.localNewItemsUpdateCenter.itemsWebServiceProcessor.uploadProcessCenter.webServiceProcessor.photoTransferProcessMachine.successfulFileCount;
        if (successfulFileCount > 0) {
            tmpMsg = [NSString stringWithFormat:@"%@ (photos also sent)", tmpMsg];
        }
    }
//    [ArcosUtils showMsg:tmpMsg title:@"Message" delegate:nil];
    [ArcosUtils showDialogBox:tmpMsg title:@"Message" target:self handler:nil];
    [self refreshTheList];
    if (self.customerIarcosSavedOrderDataManager.sendingSuccessFlag) {
        [self processNextNavControllerAfterSending:self.customerIarcosSavedOrderDataManager.sendingOrderNumber];
    }
}

- (void)orderSenderStartLocalNewItemsSending:(NSString *)anItemName {
    if (self.HUD == nil) {
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
        self.HUD.dimBackground = YES;
        [self.navigationController.view addSubview:self.HUD];
    }
    self.HUD.labelText = [NSString stringWithFormat:@"Sending %@", anItemName];
    [self.HUD show:YES];
}

- (void)orderSenderErrorOccurredLocalNewItemsSending:(NSString *)anErrorMsg {
//    [ArcosUtils showMsg:anErrorMsg title:[GlobalSharedClass shared].errorTitle delegate:nil];
    [ArcosUtils showDialogBox:anErrorMsg title:[GlobalSharedClass shared].errorTitle target:self handler:nil];
}

- (void)checkConnection {
    [connectivityCheck asyncStart];
}

//connectivity notification back
-(void)connectivityChanged: (ConnectivityCheck* )check {
    NSParameterAssert([check isKindOfClass: [ConnectivityCheck class]]);
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        [self.customerIarcosSavedOrderDataManager normaliseData];
        [self.senderCenter startSend];
    }else{
//        [ArcosUtils showMsg:check.errorString title:@"Warning" delegate:nil];
        [ArcosUtils showDialogBox:check.errorString title:@"Warning" target:self handler:nil];
        //remove all orders from center
        [self.senderCenter abandonAll];
        //refresh the talbe
        [self stopAllCellAnimation];
    }
}

- (void)stopAllCellAnimation{
    for (int i=0; i<[self.customerIarcosSavedOrderDataManager.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader= [NSMutableDictionary dictionaryWithDictionary:[self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:i]];
        if ([[anOrderHeader objectForKey:@"OrderHeaderIUR"]intValue]==0) {
            NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            CustomerIarcosSavedOrderTableCell* cell=(CustomerIarcosSavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
            [anOrderHeader setObject:[NSNumber numberWithBool:NO] forKey:@"IsSealed"];
            //enable cell interaction
            cell.userInteractionEnabled=YES;
            cell.sendButton.enabled=YES;
            [self.customerIarcosSavedOrderDataManager.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
        }
    }
    [self.tableView reloadData];
}

- (void)stopCellAnimationWithOrderNumber:(NSNumber*)orderNumber withStatus:(BOOL)status {
    for (int i=0; i<[self.customerIarcosSavedOrderDataManager.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[NSMutableDictionary dictionaryWithDictionary:[self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:i]];
        
        if ([[anOrderHeader objectForKey:@"OrderNumber"]intValue]==[orderNumber intValue]) {
            NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            CustomerIarcosSavedOrderTableCell* cell=(CustomerIarcosSavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
            [anOrderHeader setObject:[NSNumber numberWithBool:NO] forKey:@"IsSealed"];
            [cell stopAnimateWithStatus:status];
            [self.customerIarcosSavedOrderDataManager.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
            break;
        }
    }
}

-(void)needSealTheCellWithOrderNumber:(NSNumber*)orderNumber need:(BOOL)need{
    for (int i=0; i<[self.customerIarcosSavedOrderDataManager.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:i];
        NSNumber* anOrderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        NSNumber* isCellSealed=[anOrderHeader objectForKey:@"IsSealed"];
        
        NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
        CustomerIarcosSavedOrderTableCell* cell=(CustomerIarcosSavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
        
        if ([anOrderNumber isEqualToNumber:orderNumber]) {
            //[self needCealTheCellWithOrderNumber:orderNumber need:YES];
            [cell needEditable:![isCellSealed boolValue]];
            return;
        }
    }
}

-(void)updateOrderHeaderWithOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber *)newOrderNumber{
    for (int i=0; i<[self.customerIarcosSavedOrderDataManager.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[NSMutableDictionary dictionaryWithDictionary: [self.customerIarcosSavedOrderDataManager.displayList objectAtIndex:i]];
        NSNumber* anOrderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        
        if ([anOrderNumber isEqualToNumber:orderNumber]) {
            [anOrderHeader setObject:newOrderNumber forKey:@"DocketIUR"];
            [anOrderHeader setObject: [newOrderNumber stringValue]  forKey:@"orderNumberText"];
            [anOrderHeader setObject:[NSNumber numberWithBool:YES] forKey:@"IsSealed"];
            [anOrderHeader setObject:[NSNumber numberWithInt:1] forKey:@"OrderHeaderIUR"];
            [self.customerIarcosSavedOrderDataManager.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
            return;
        }
    }
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//        self.thePopover = nil;
//        self.factory.popoverController = nil;
//    }
    self.globalWidgetViewController = nil;
}

#pragma mark WidgetFactoryDelegate
//coordinateType 0:local 1:remote
-(void)operationDone:(id)data {
    UIBarButtonItem* allButton = [[UIBarButtonItem alloc] initWithTitle:@"All" style:UIBarButtonItemStylePlain target:self action:@selector(pressAllButton:)];
    [self.navigationItem setRightBarButtonItem:allButton];
    [allButton release];
    [self.rcsStackedController popToNavigationController:(UINavigationController*)self.parentViewController animated:YES];
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.globalWidgetViewController = nil;
    self.coordinateType = [NSNumber numberWithInt:1];
    self.customerIarcosSavedOrderDataManager.currentNumberOflines = [data objectForKey:@"NumberOflines"];
    self.customerIarcosSavedOrderDataManager.displayList = nil;
    [self processSqlStatementByType:0];
}
//0: remote , 1: all
- (void)processSqlStatementByType:(int)aType {
//    NSString* prevDateSqlStatement = @" and DATEDIFF(mm, date, GETDATE()) between 0 and ";
    NSString* dateSqlStatement = @"";
    NSString* employeeSqlStatement = @"";
//    if (aType == 1) {
//        dateSqlStatement = @"";
//    }
    if ([self.customerIarcosSavedOrderDataManager.currentNumberOflines intValue] > 0) {
        if (aType == 0) {
            NSNumber* rightRangeNumber = [ArcosDateRangeProcessor retrieveRightRangeNumberWithCode:@"[REOR-"];
            dateSqlStatement = [NSString stringWithFormat:@" and DATEDIFF(mm, dbo.OrderHeader.OrderDate, GETDATE()) between 0 and  %d ",[rightRangeNumber intValue]];
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
            int employeeIur = [[SettingManager employeeIUR] intValue];
            employeeSqlStatement = [NSString stringWithFormat:@" AND dbo.OrderHeader.EmployeeIUR = %d", employeeIur];
        }
//        NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,Number,CONVERT(VARCHAR(10),Date,103),Wholesaler,Value,CONVERT(VARCHAR(10),DeliveryDate,103),Employee,OTIUR,LocationIUR,OSIUR from orderview where LocationIUR = %@ %@ order by date desc", self.locationIUR, dateSqlStatement];
        NSString* sqlStatement = [NSString stringWithFormat:@"SELECT TOP (99.9999) PERCENT ISNULL(dbo.OrderHeader.IUR, 0) AS IUR, ISNULL(dbo.OrderHeader.OrderNumber, 0) AS Number, CONVERT(VARCHAR(10),ISNULL(dbo.OrderHeader.OrderDate, 0),103) AS Date, ISNULL(dbo.Employee.Forename, ' ') + ' ' + ISNULL(dbo.Employee.Surname, ' ') AS Employee, ISNULL(dbo.OrderHeader.TotalGoods, 0) AS Value, CONVERT(VARCHAR(10),dbo.OrderHeader.DeliveryDate,103), dbo.OrderHeader.LocationIUR, WholeSaler.Name AS WholeSaler, WholeSaler.IUR AS WholesalerIUR, dbo.OrderHeader.OTiur, dbo.OrderHeader.OSiur, dbo.OrderHeader.EmployeeIUR,ISNULL(dbo.OrderHeader.TotalVat, 0) AS VatValue  FROM dbo.OrderHeader LEFT OUTER JOIN dbo.Employee ON dbo.OrderHeader.EmployeeIUR = dbo.Employee.IUR LEFT OUTER JOIN dbo.Location ON dbo.OrderHeader.LocationIUR = dbo.Location.IUR INNER JOIN dbo.Location AS WholeSaler ON dbo.OrderHeader.WholesaleIUR = WholeSaler.IUR GROUP BY dbo.OrderHeader.IUR, dbo.OrderHeader.OrderNumber, dbo.OrderHeader.OrderDate, dbo.Employee.Forename + ' ' + dbo.Employee.Surname, dbo.OrderHeader.TotalGoods, dbo.Employee.Surname, dbo.Employee.Forename,  dbo.OrderHeader.DeliveryDate, dbo.OrderHeader.LocationIUR, WholeSaler.Name, WholeSaler.IUR, dbo.OrderHeader.OTiur, dbo.OrderHeader.OSiur,dbo.OrderHeader.EmployeeIUR,dbo.OrderHeader.TotalVat HAVING (dbo.OrderHeader.IUR != 0 %@ AND dbo.OrderHeader.LocationIUR = %@) %@ ORDER BY dbo.OrderHeader.OrderDate DESC", employeeSqlStatement, self.locationIUR, dateSqlStatement];
        
        [self.callGenericServices getData: sqlStatement];
    } else if ([self.customerIarcosSavedOrderDataManager.currentNumberOflines intValue] == 0) {
        if (aType == 0) {
            NSNumber* rightRangeNumber = [ArcosDateRangeProcessor retrieveRightRangeNumberWithCode:@"[RECA-"];
            dateSqlStatement = [NSString stringWithFormat:@" and DATEDIFF(mm, dbo.Call.CallDate, GETDATE()) between 0 and  %d ",[rightRangeNumber intValue]];
        }
        
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowDownloadByEmployeeFlag]) {
            int employeeIur = [[SettingManager employeeIUR] intValue];
            employeeSqlStatement = [NSString stringWithFormat:@" AND dbo.Employee.IUR = %d", employeeIur];
        }
//        NSString* prefixSqlStatement = @"select IUR,CONVERT(VARCHAR(10),Date,103),Name,Employee,Type,Value,ContactIUR,LocationIUR from callview";
        NSString* prefixSqlStatement = @"SELECT TOP (100) PERCENT ISNULL(dbo.Call.IUR, 0) AS IUR, CONVERT(VARCHAR(10),dbo.Call.CallDate,103) AS Date, CASE WHEN call.contactiur > 0 THEN Contact.Forename + ' ' + Contact.Surname ELSE Location.Name END AS Name,  ISNULL(dbo.DescrDetail.Details, ' ') AS Type, ISNULL(dbo.Employee.Forename, ' ') + ' ' + ISNULL(dbo.Employee.Surname, ' ') AS Employee, SUM(dbo.OrderHeader.TotalGoods) AS Value,  dbo.Call.LocationIUR, dbo.Call.ContactIUR, dbo.Call.EmployeeIUR, dbo.Call.CTiur FROM dbo.Call INNER JOIN dbo.Employee ON dbo.Call.EmployeeIUR = dbo.Employee.IUR INNER JOIN dbo.DescrDetail ON dbo.Call.CTiur = dbo.DescrDetail.IUR LEFT OUTER JOIN dbo.OrderHeader ON dbo.Call.IUR = dbo.OrderHeader.CallIUR LEFT OUTER JOIN dbo.Location ON dbo.Call.LocationIUR = dbo.Location.IUR LEFT OUTER JOIN dbo.Contact ON dbo.Call.ContactIUR = dbo.Contact.IUR";
        
        NSString* suffixSqlStatement = @"GROUP BY ISNULL(dbo.Call.IUR, 0), dbo.Call.CallDate, dbo.Call.ContactIUR, dbo.Contact.Forename, dbo.Contact.Surname, dbo.Location.Name, ISNULL(dbo.DescrDetail.Details, ' '), dbo.Employee.Forename, dbo.Employee.Surname  , dbo.Call.LocationIUR, dbo.Call.ContactIUR, dbo.Call.EmployeeIUR, dbo.Call.CTiur ORDER BY dbo.Call.CallDate DESC";
        NSString* sqlStatement = [NSString stringWithFormat:@"%@ where dbo.Location.IUR = %@ %@ %@ %@", prefixSqlStatement, self.locationIUR, employeeSqlStatement, dateSqlStatement, suffixSqlStatement];
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] checkDrilldownOfOrderCall] && self.locationDefaultContactIUR != nil && [self.locationDefaultContactIUR intValue] != 0) {
//            sqlStatement = [NSString stringWithFormat:@"%@ where ContactIUR = %@ %@ order by date desc", prefixSqlStatement, self.locationDefaultContactIUR, dateSqlStatement];
            sqlStatement = [NSString stringWithFormat:@"%@ where dbo.Contact.IUR = %@ %@ %@ %@", prefixSqlStatement, self.locationDefaultContactIUR, employeeSqlStatement, dateSqlStatement, suffixSqlStatement];
        }
        
        [self.callGenericServices getSecondData: sqlStatement];
    }
}


#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.customerIarcosSavedOrderDataManager processRemoteOrderRawData:result.ArrayOfData];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
    [self.tableView reloadData];
}
-(void)setGetSecondDataResult:(ArcosGenericReturnObject *)result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.customerIarcosSavedOrderDataManager processRemoteCallRawData:result.ArrayOfData];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
    [self.tableView reloadData];
}
@end
