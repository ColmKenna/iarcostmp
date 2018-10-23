//
//  SavedIarcosOrderDetailTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailTableViewController.h"
#import "ArcosStackedViewController.h"

@interface SavedIarcosOrderDetailTableViewController ()
- (void)createEmailRecipientTableViewController:(NSMutableDictionary*)aCellData;
-(void)saveButtonCallBack;
@end

@implementation SavedIarcosOrderDetailTableViewController
@synthesize actionBarButton = _actionBarButton;
@synthesize emailButton = _emailButton;
@synthesize saveButton = _saveButton;
@synthesize rightBarButtonItemList = _rightBarButtonItemList;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize emailPopover = _emailPopover;
@synthesize emailActionDelegate = _emailActionDelegate;
@synthesize savedIarcosOrderDetailDataManager = _savedIarcosOrderDetailDataManager;
@synthesize savedOrderDetailCellData = _savedOrderDetailCellData;
@synthesize defaultOrderSentStatusDict = _defaultOrderSentStatusDict;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize headerTitleLabel = _headerTitleLabel;
@synthesize headerButton = _headerButton;
@synthesize headerContentLabel = _headerContentLabel;
@synthesize myHeaderView = _myHeaderView;
@synthesize contactDetailsTableViewCell = _contactDetailsTableViewCell;
@synthesize orderDetailsTableViewCell = _orderDetailsTableViewCell;
@synthesize memoDetailsTableViewCell = _memoDetailsTableViewCell;
@synthesize coordinateType = _coordinateType;
@synthesize callGenericServices = _callGenericServices;
@synthesize factory = _factory;
@synthesize actionPopover = _actionPopover;
@synthesize repeatOrderDataManager = _repeatOrderDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.rootView = [ArcosUtils getRootView];
    self.savedIarcosOrderDetailDataManager = [[[SavedIarcosOrderDetailDataManager alloc] init] autorelease];
    self.repeatOrderDataManager = [[[RepeatOrderDataManager alloc] init] autorelease];
    self.tableCellFactory = [SavedIarcosOrderDetailTableCellFactory factory];
    self.savedIarcosOrderDetailDataManager.actionTableDataDictList = [self.savedIarcosOrderDetailDataManager createActionTableDataDictList:self.savedOrderDetailCellData];
    
    self.actionBarButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)] autorelease];
//    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)] autorelease];
    
    self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.saveButton, self.actionBarButton, nil];
    [self.navigationItem setRightBarButtonItems:self.rightBarButtonItemList];
    if ([self.coordinateType intValue] == 1) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
        if ([[self.savedOrderDetailCellData objectForKey:@"NumberOflines"] intValue] > 0) {
            [self.callGenericServices genericGetRecord:@"Order" iur:[[self.savedOrderDetailCellData objectForKey:@"OrderHeaderIUR"] intValue] action:@selector(orderGetRecordResult:) target:self];
        }
        else if ([[self.savedOrderDetailCellData objectForKey:@"NumberOflines"] intValue] == 0) {
            [self.callGenericServices genericGetRecord:@"Call" iur:[[self.savedOrderDetailCellData objectForKey:@"OrderHeaderIUR"] intValue] action:@selector(callGetRecordResult:) target:self];
        }
    }
}

- (void)dealloc {
    self.actionBarButton = nil;
    self.emailButton = nil;
    self.saveButton = nil;
    self.rightBarButtonItemList = nil;
    if (self.emailRecipientTableViewController != nil) { self.emailRecipientTableViewController = nil; }
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailActionDelegate != nil) { self.emailActionDelegate = nil; }
    self.savedIarcosOrderDetailDataManager = nil;
    self.savedOrderDetailCellData = nil;
    self.defaultOrderSentStatusDict = nil;
    self.tableCellFactory = nil;
    self.headerTitleLabel = nil;
    self.headerButton = nil;
    self.headerContentLabel = nil;
    self.myHeaderView = nil;
    self.contactDetailsTableViewCell = nil;
    self.orderDetailsTableViewCell = nil;
    self.memoDetailsTableViewCell = nil;
    self.coordinateType = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.factory = nil;
    self.actionPopover = nil;
    self.repeatOrderDataManager = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.coordinateType intValue] == 1) return;
    [self loadSavedOrderDetailCellData:self.savedOrderDetailCellData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectionTitle = [self.savedIarcosOrderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        if ([sectionTitle isEqualToString:@"Memo"] && self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed && indexPath.row == ([auxDisplayList count] - 1)) {
            return 212;
        }
    } else {
        if ([sectionTitle isEqualToString:@"Memo"] && indexPath.row == ([auxDisplayList count] - 1)) {
            return 212;
        }
    }
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.savedIarcosOrderDetailDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.savedIarcosOrderDetailDataManager.sectionTitleList objectAtIndex:section];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.contactSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            if (!self.savedIarcosOrderDetailDataManager.isContactDetailsShowed) {
                return 1;
            } else {
                return [auxDisplayList count] + 1;
            }
        }
        
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.memoSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            if (!self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed) {
                return 1;
            } else {
                return [auxDisplayList count] + 1;
            }
        }
    }
    
    NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
    return [auxDisplayList count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        NSString* contactName = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"contactText"];
        NSString* suffixString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@", [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"], [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"Address1"], [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"Address2"], [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"Address3"], [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"Address4"]];
        if ([contactName isEqualToString:[GlobalSharedClass shared].unassignedText]) {
            self.headerContentLabel.text = suffixString;
        } else {
            self.headerContentLabel.text = [NSString stringWithFormat:@"%@\n%@", contactName, suffixString];
        }
        if ([self.coordinateType intValue] == 1 && [[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] == 0) {
            self.headerContentLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"], [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"Address1"], @" ", @" ", @" "];
        }
        return self.myHeaderView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 160.0f;
    }
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sectionTitle = [self.savedIarcosOrderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.contactSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            if (!self.savedIarcosOrderDetailDataManager.isContactDetailsShowed) {
                self.contactDetailsTableViewCell.controlLabel.text = @"Contact Details";
                return self.contactDetailsTableViewCell;
            } else if(self.savedIarcosOrderDetailDataManager.isContactDetailsShowed && indexPath.row == [auxDisplayList count]) {
                self.contactDetailsTableViewCell.controlLabel.text = @"Hide";
                return self.contactDetailsTableViewCell;
            }
        }
        
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.memoSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            if (!self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed) {
                self.memoDetailsTableViewCell.controlLabel.text = @"Memo Details";
                return self.memoDetailsTableViewCell;
            } else if(self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed && indexPath.row == [auxDisplayList count]) {
                self.memoDetailsTableViewCell.controlLabel.text = @"Hide";
                return self.memoDetailsTableViewCell;
            }
        }
    }
    
    
    
    NSMutableDictionary* cellData = [self.savedIarcosOrderDetailDataManager cellDataWithIndexPath:indexPath];
    OrderDetailBaseTableCell* cell = (OrderDetailBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (OrderDetailBaseTableCell*)[self.tableCellFactory createOrderDetailBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    cell.isNotEditable = [isSealed boolValue];
    [cell configCellWithData:cellData];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* sectionTitle = [self.savedIarcosOrderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.contactSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            NSUInteger numberOfRowsContactSection = [auxDisplayList count];
            if (!self.savedIarcosOrderDetailDataManager.isContactDetailsShowed) {
                self.savedIarcosOrderDetailDataManager.isContactDetailsShowed = YES;
                [self.tableView reloadData];
            } else if(self.savedIarcosOrderDetailDataManager.isContactDetailsShowed && indexPath.row == numberOfRowsContactSection) {
                self.savedIarcosOrderDetailDataManager.isContactDetailsShowed = NO;
                [self.tableView reloadData];
            }
        }
        
        if ([sectionTitle isEqualToString:self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager.memoSectionTitle]) {
            NSMutableArray* auxDisplayList = [self.savedIarcosOrderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            NSUInteger numberOfRowsContactSection = [auxDisplayList count];
            if (!self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed) {
                self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed = YES;
                [self.tableView reloadData];
            } else if(self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed && indexPath.row == numberOfRowsContactSection) {
                self.savedIarcosOrderDetailDataManager.isMemoDetailsShowed = NO;
                [self.tableView reloadData];
            }
        }
    }
    
}

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData {
    [self.savedIarcosOrderDetailDataManager loadSavedOrderDetailCellData:aCellData];
    [self.tableView reloadData];
    
    [self createEmailRecipientTableViewController:aCellData];
    /*
    if (self.emailRecipientTableViewController != nil) return;
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"LocationIUR"];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceOrder;
        NSMutableDictionary* tmpWholesalerDict = [self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager addTitleToDict:@"wholesaler" titleKey:@"wholesalerText"];
        self.emailRecipientTableViewController.wholesalerDict = tmpWholesalerDict;
        self.emailRecipientTableViewController.isSealedBOOLNumber = [aCellData objectForKey:@"IsSealed"];
        self.emailActionDelegate = [[[OrderDetailOrderEmailActionDataManager alloc] initWithOrderHeader:self.savedIarcosOrderDetailDataManager.orderHeader] autorelease];
    } else {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceCall;
        self.emailActionDelegate = [[[OrderDetailCallEmailActionDataManager alloc] initWithOrderHeader:self.savedIarcosOrderDetailDataManager.orderHeader] autorelease];
    }
    self.emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    */
}

#pragma mark OrderDetailTypesTableCellDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    [self.savedIarcosOrderDetailDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
}

-(void)showPrintViewControllerDelegate {
    CheckoutPrinterWrapperViewController* cpwvc = [[CheckoutPrinterWrapperViewController alloc] initWithNibName:@"CheckoutPrinterWrapperViewController" bundle:nil];
//    cpwvc.myDelegate = self;
    cpwvc.modalDelegate = self;
    cpwvc.orderHeader = self.savedIarcosOrderDetailDataManager.orderHeader;
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

-(void)showOrderlineDetailsDelegate {
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    NSNumber* orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine" locationIUR:[self.savedOrderDetailCellData objectForKey:@"LocationIUR"]];
    NSNumber* formIUR = [self.savedOrderDetailCellData objectForKey:@"FormIUR"];
    
    OrderlinesIarcosTableViewController* oitvc = [[OrderlinesIarcosTableViewController alloc] initWithStyle:UITableViewStylePlain];
    oitvc.isCellEditable = ![isSealed boolValue];
    oitvc.orderNumber = orderNumber;
    oitvc.formIUR = formIUR;
    oitvc.locationIUR = [self.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    [oitvc resetTableDataWithData:orderLines];
    oitvc.vansOrderHeader = self.savedIarcosOrderDetailDataManager.orderHeader;
    
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:oitvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [oitvc release];
    [tmpNavigationController release];
}

-(void)showRemoteOrderlineDetailsDelegate {
//    NSLog(@"a:%@", NSStringFromSelector(_cmd));
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    NSNumber* orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
//    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine"];
//    NSLog(@"orderlines: %@", orderLines);
    NSNumber* formIUR = [self.savedOrderDetailCellData objectForKey:@"FormIUR"];
    
    OrderlinesIarcosTableViewController* oitvc = [[OrderlinesIarcosTableViewController alloc] initWithStyle:UITableViewStylePlain];
    oitvc.isCellEditable = ![isSealed boolValue];
    oitvc.orderNumber = orderNumber;
    oitvc.formIUR = formIUR;
    oitvc.locationIUR = [self.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    [oitvc resetTableDataWithData:[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"RemoteOrderline"]];
    
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:oitvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [oitvc release];
    [tmpNavigationController release];
}

-(void)showCallDetailsDelegate {
    DetailingTableViewController* dtvc = [[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil];
    dtvc.requestSource = DetailingRequestSourceCustomer;
//    dtvc.title = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"];
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    NSNumber* orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    dtvc.orderNumber = orderNumber;
    dtvc.isEditable = ![isSealed boolValue];
    dtvc.locationIUR = [self.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    dtvc.locationName = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"];
    
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:dtvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [dtvc release];
    [tmpNavigationController release];
}

-(void)showRemoteCallDetailsDelegate {
    DetailingTableViewController* dtvc = [[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil];
    dtvc.requestSource = DetailingRequestSourceCustomer;
    //    dtvc.title = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"];
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    NSNumber* orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    dtvc.orderNumber = orderNumber;
    dtvc.isEditable = ![isSealed boolValue];
    dtvc.locationIUR = [self.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    dtvc.locationName = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"CustName"];
    dtvc.coordinateType = self.coordinateType;
    dtvc.orderHeader = self.savedIarcosOrderDetailDataManager.orderHeader;
    
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:dtvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [dtvc release];
    [tmpNavigationController release];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    NSString* message = nil;
    NSString* title = nil;
    switch (aResult) {
        case ArcosMailComposeResultSent: {
            message = @"Sent Email OK";
            title = @"App Email";
            [self mailComposeResultMessageProcessor:&message title:&title];
            [ArcosUtils showDialogBox:message title:title delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {                
            }];
        }            
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
        BOOL successFlag = NO;
        if (aResult == ArcosMailComposeResultSent) {
            successFlag = YES;
        }
        [self dismissEmailEndProcessor:successFlag];
    }];
    
}

-(UIViewController*)retrieveParentViewController {
    return self;
}

- (void)actionButtonPressed:(id)sender {
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.actionPopover = [self.factory CreateTableWidgetWithData:self.savedIarcosOrderDetailDataManager.actionTableDataDictList withTitle:@"" withParentContentString:@"" requestSource:TableWidgetRequestSourceListing];
    if (self.actionPopover != nil) {
        self.actionPopover.delegate = self;
        [self.actionPopover presentPopoverFromBarButtonItem:self.actionBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)saveButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.view endEditing:YES];
    NSString* requestSourceText = nil;
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        requestSourceText = @"Order";
    } else {
        requestSourceText = @"Call";
    }
    NSNumber* isSealed = [self.savedOrderDetailCellData objectForKey:@"IsSealed"];
    if ([isSealed boolValue]) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ is not allowed to be saved.", requestSourceText] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    BOOL resultFlag = [self.savedIarcosOrderDetailDataManager saveTheOrderHeader];
    
    if (resultFlag) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ has been saved.", requestSourceText] title:@"" delegate:self target:self tag:999999 handler:^(UIAlertAction *action) {
            [self saveButtonCallBack];
        }];
    } else {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ has not been saved.", requestSourceText] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0 && alertView.tag == 999999){
        //Code that will run after you press ok button
        [self saveButtonCallBack];
    }
}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
//    NSLog(@"didSelectEmailRecipientRow %@", cellData);    
    NSMutableDictionary* mailDict = [self.emailActionDelegate didSelectEmailRecipientRowWithCellData:cellData];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:[cellData objectForKey:@"Email"] , nil];
    NSString* fileName = [self.emailActionDelegate retrieveFileName];
    self.emailRecipientTableViewController.emailRecipientDataManager.currentRecipientDict = [NSMutableDictionary dictionaryWithDictionary:cellData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = [mailDict objectForKey:@"Subject"];
        amwvc.bodyText = [mailDict objectForKey:@"Body"];        
        amwvc.isHTML = YES;
        if (![fileName isEqualToString:@""]) {
            NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
            NSData* data = [NSData dataWithContentsOfFile:pdfFilePath];
            [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];            
            [FileCommon removeFileAtPath:pdfFilePath];
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            [self.emailPopover dismissPopoverAnimated:YES];
        }];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    [self.emailPopover dismissPopoverAnimated:YES];    
    
    MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    
    [mailComposeViewController setToRecipients:toRecipients];
    [mailComposeViewController setSubject:[mailDict objectForKey:@"Subject"]];
    [mailComposeViewController setMessageBody:[mailDict objectForKey:@"Body"] isHTML:YES];
    
    if (![fileName isEqualToString:@""]) {
        NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
        NSData* data = [NSData dataWithContentsOfFile:pdfFilePath];
        [mailComposeViewController addAttachmentData:data mimeType:@"application/pdf" fileName:fileName];
        [FileCommon removeFileAtPath:pdfFilePath];
    }
    
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
    [mailComposeViewController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    NSString* title = nil;
    UIAlertView* v = nil;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
            title = @"App Email";
            [self mailComposeResultMessageProcessor:&message title:&title];
            v = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [v show];
            [v release];
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
            [v show];
            [v release];
        }
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
//    NSLog(@"Email sending error message %@ ", message);
    [self dismissViewControllerAnimated:YES completion:^{
        BOOL successFlag = NO;
        if (result == MFMailComposeResultSent) {
            successFlag = YES;
        }
        [self dismissEmailEndProcessor:successFlag];        
    }];
}

- (void)mailComposeResultMessageProcessor:(NSString**)aMessage title:(NSString**)aTitle {
    NSNumber* recipientType = [self.emailRecipientTableViewController.emailRecipientDataManager.currentRecipientDict objectForKey:@"RecipientType"];
    if ([recipientType isEqualToNumber:[GlobalSharedClass shared].wholesalerDefaultImageIUR]) {
        NSNumber* defaultOrderSentStatus = [SettingManager defaultOrderSentStatus];
        NSDictionary* tmpDefaultOrderSentStatusDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:defaultOrderSentStatus];
        self.defaultOrderSentStatusDict = [NSMutableDictionary dictionaryWithDictionary:tmpDefaultOrderSentStatusDict];
        [self.defaultOrderSentStatusDict setObject:[tmpDefaultOrderSentStatusDict objectForKey:@"Detail"] forKey:@"Title"];
        *aMessage = [NSString stringWithFormat:@"Email Sent to %@ and Status Set to %@.", [self.emailRecipientTableViewController.emailRecipientDataManager.currentRecipientDict objectForKey:@"Title"], [self.defaultOrderSentStatusDict objectForKey:@"Title"]];
        *aTitle = @"";
    }
}

- (void)dismissEmailEndProcessor:(BOOL)aSuccessFlag {
    NSNumber* recipientType = [self.emailRecipientTableViewController.emailRecipientDataManager.currentRecipientDict objectForKey:@"RecipientType"];
    if ([recipientType isEqualToNumber:[GlobalSharedClass shared].wholesalerDefaultImageIUR] && aSuccessFlag) {
        NSIndexPath* orderStatusIndexPath = [NSIndexPath indexPathForRow:3 inSection:1];
        [self inputFinishedWithData:self.defaultOrderSentStatusDict forIndexpath:orderStatusIndexPath];
        [self.savedIarcosOrderDetailDataManager saveTheOrderHeader];
        [self.tableView reloadData];
    }
}

#pragma mark GetDataGenericDelegate
-(void)orderGetRecordResult:(ArcosGenericReturnObject*) result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        [self.savedIarcosOrderDetailDataManager processRemoteOrderDetailRawData:replyResult cellDict:self.savedOrderDetailCellData];
        [self createEmailRecipientTableViewController:self.savedOrderDetailCellData];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

-(void)callGetRecordResult:(ArcosGenericReturnObject*) result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        ArcosGenericClass* replyResult = [result.ArrayOfData objectAtIndex:0];
        [self.savedIarcosOrderDetailDataManager processRemoteCallDetailRawData:replyResult cellDict:self.savedOrderDetailCellData];
        [self createEmailRecipientTableViewController:self.savedOrderDetailCellData];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
}

- (void)createEmailRecipientTableViewController:(NSMutableDictionary*)aCellData{
    if (self.emailRecipientTableViewController != nil) return;
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"LocationIUR"];
    if ([[self.savedIarcosOrderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceOrder;
        NSMutableDictionary* tmpWholesalerDict = [self.savedIarcosOrderDetailDataManager.savedIarcosOrderDetailBaseDataManager addTitleToDict:@"wholesaler" titleKey:@"wholesalerText"];
        self.emailRecipientTableViewController.wholesalerDict = tmpWholesalerDict;
        self.emailRecipientTableViewController.isSealedBOOLNumber = [aCellData objectForKey:@"IsSealed"];
        self.emailActionDelegate = [[[OrderDetailOrderEmailActionDataManager alloc] initWithOrderHeader:self.savedIarcosOrderDetailDataManager.orderHeader] autorelease];
    } else {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceCall;
        self.emailActionDelegate = [[[OrderDetailCallEmailActionDataManager alloc] initWithOrderHeader:self.savedIarcosOrderDetailDataManager.orderHeader] autorelease];
    }
    self.emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
}

-(void)saveButtonCallBack {
    int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
    UINavigationController* prevNavigationController = [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:1];
    UIViewController* prevViewController = [prevNavigationController.viewControllers objectAtIndex:0];
    [prevViewController viewWillAppear:YES];
    [self.rcsStackedController popTopNavigationController:YES];
}

#pragma mark WidgetFactoryDelegate

- (void)operationDone:(id)data {
    [self.actionPopover dismissPopoverAnimated:NO];
    self.actionPopover = nil;
    self.factory.popoverController = nil;
    NSMutableDictionary* auxDataDict = (NSMutableDictionary*)data;
    switch ([[auxDataDict objectForKey:@"ActionType"] intValue]) {
        case 1: {
            [self.emailPopover presentPopoverFromBarButtonItem:self.actionBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }            
            break;
        case 2: {
            NSMutableDictionary* statusDict = [[SettingManager setting] getSettingForKeypath:@"CompanySetting.Default Types" atIndex:3];
            NSDictionary* orderStatusDescDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURActive:[statusDict objectForKey:@"Value"]];
            self.repeatOrderDataManager.orderStatusIUR = [statusDict objectForKey:@"Value"];
            NSString* orderStatusDescDetail = [orderStatusDescDict objectForKey:@"Detail"];
            
            if (orderStatusDescDetail == nil || [orderStatusDescDetail isEqualToString:@""]) {
                orderStatusDescDetail = @"Undefined";
            }
            NSString* message = [NSString stringWithFormat:@"Do you want to generate a new %@ order", orderStatusDescDetail];
            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            v.tag = 36;
            [v show];
            [v release];
        }
            break;            
        default:
            break;
    }    
}

-(void)dismissPopoverController {
    [self.actionPopover dismissPopoverAnimated:YES];
    self.actionPopover = nil;
    self.factory.popoverController = nil;
    [self.emailPopover dismissPopoverAnimated:YES];
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.actionPopover = nil;
    self.factory.popoverController = nil;
}

- (void)yesActionPressedProcessor {
    if ([self.coordinateType intValue] == 1) {            
        
    } else {
        NSNumber* orderNumber = [self.savedOrderDetailCellData objectForKey:@"OrderNumber"];
        NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine" locationIUR:[self.savedOrderDetailCellData objectForKey:@"LocationIUR"]];
        [self.savedIarcosOrderDetailDataManager.orderHeader setObject:orderLines forKey:@"OrderLines"];
    }
    [self.repeatOrderDataManager repeatOrderWithDataDict:self.savedIarcosOrderDetailDataManager.orderHeader];
    
    [ArcosUtils showDialogBox:@"New order created" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
        UINavigationController* prevNavigationController = [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:1];
        UIViewController* prevViewController = [prevNavigationController.viewControllers objectAtIndex:0];
        [prevViewController viewWillAppear:YES];
        [self.rcsStackedController popToNavigationController:prevNavigationController animated:YES];
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 36) return;
    if (buttonIndex == [alertView cancelButtonIndex]) {//yes action        
        [self yesActionPressedProcessor];
    } else {//no action
    }    
}

@end
