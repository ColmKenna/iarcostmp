//
//  OrderDetailTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import "OrderDetailTableViewController.h"
#import "OrderDetailWriteLabelTableCell.h"
#import "ArcosStackedViewController.h"

@implementation OrderDetailTableViewController
@synthesize actionBarButton = _actionBarButton;
@synthesize emailButton = _emailButton;
@synthesize saveButton = _saveButton;
@synthesize rightBarButtonItemList = _rightBarButtonItemList;
@synthesize orderDetailDataManager = _orderDetailDataManager;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
@synthesize emailNavigationController = _emailNavigationController;
//@synthesize emailPopover = _emailPopover;
@synthesize emailActionDelegate = _emailActionDelegate;
@synthesize mailController = _mailController;
@synthesize isContactDetailShowed = _isContactDetailShowed;
@synthesize contactControlTableCell = _contactControlTableCell;
@synthesize orderProductViewControllerDelegate = _orderProductViewControllerDelegate;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize savedOrderDetailCellData = _savedOrderDetailCellData;
@synthesize defaultOrderSentStatusDict = _defaultOrderSentStatusDict;
@synthesize factory = _factory;
//@synthesize actionPopover = _actionPopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize repeatOrderDataManager = _repeatOrderDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize callGenericServices = _callGenericServices;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.actionBarButton = nil;
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }
    if (self.rightBarButtonItemList != nil) { self.rightBarButtonItemList = nil; }
    if (self.orderDetailDataManager != nil) { self.orderDetailDataManager = nil; }
    if (self.tableCellFactory != nil) { self.tableCellFactory = nil; }
    if (self.emailRecipientTableViewController != nil) { self.emailRecipientTableViewController = nil; }
    if (self.emailNavigationController != nil) { self.emailNavigationController = nil; }
//    if (self.emailPopover != nil) { self.emailPopover = nil; }
    if (self.emailActionDelegate != nil) { self.emailActionDelegate = nil; }
    if (self.mailController != nil) { self.mailController = nil; }       
    if (self.contactControlTableCell != nil) { self.contactControlTableCell = nil; }
    if (self.orderProductViewControllerDelegate != nil) { self.orderProductViewControllerDelegate = nil; }
    if (self.savedOrderDetailCellData != nil) { self.savedOrderDetailCellData = nil; }                
    if (self.defaultOrderSentStatusDict != nil) { self.defaultOrderSentStatusDict = nil; }
    self.factory = nil;
//    self.actionPopover = nil;
    self.globalWidgetViewController = nil;
    self.repeatOrderDataManager = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.callGenericServices = nil;
    
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
    self.rootView = [ArcosUtils getRootView];
    if ([self.orderDetailDataManager.actionTableDataDictList count] == 1) {
        self.actionBarButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"email_all.png"] style:UIBarButtonItemStylePlain target:self action:@selector(emailButtonPressed:)] autorelease];
    } else {
        self.actionBarButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)] autorelease];
    }
    
//    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)] autorelease];
    
    self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.saveButton, self.actionBarButton, nil];
    [self.navigationItem setRightBarButtonItems:self.rightBarButtonItemList];
    self.repeatOrderDataManager = [[[RepeatOrderDataManager alloc] init] autorelease];
//    self.tableView.allowsSelection = NO;
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (self.emailButton != nil) { self.emailButton = nil; }
    if (self.saveButton != nil) { self.saveButton = nil; }
    if (self.rightBarButtonItemList != nil) { self.rightBarButtonItemList = nil; }
    if (self.contactControlTableCell != nil) { self.contactControlTableCell = nil; }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isNotFirstLoaded && ![[self.savedOrderDetailCellData objectForKey:@"IsCealed"] boolValue]) {
//        NSLog(@"the table view is refreshed. %@", self.savedOrderDetailCellData);         
        [self loadSavedOrderDetailCellData:self.savedOrderDetailCellData];
        [self.tableView reloadData];
    }
    self.isNotFirstLoaded = YES;    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    if ([self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
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

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectionTitle = [self.orderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* auxDisplayList = [self.orderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
    NSMutableDictionary* auxCellDataDict = nil;
    @try {
        auxCellDataDict = [auxDisplayList objectAtIndex:indexPath.row];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    NSString* fieldNameLabel = [auxCellDataDict objectForKey:@"FieldNameLabel"];
    if ([sectionTitle isEqualToString:@"Memo"] && [fieldNameLabel isEqualToString:@"Memo"]) {
        return 212;
    }
//    if ([sectionTitle isEqualToString:@"Memo"] && indexPath.row == ([auxDisplayList count] - 1)) {
//        return 212;
//    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.orderDetailDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* sectionTitle = [self.orderDetailDataManager.sectionTitleList objectAtIndex:section];
    if ([[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {        
        if ([sectionTitle isEqualToString:@"Contact"]) {
            if (!self.isContactDetailShowed) {
                return 1;
            } else {
                NSMutableArray* auxDisplayList = [self.orderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
                return [auxDisplayList count] + 1;
            }
        }
    }
    NSMutableArray* auxDisplayList = [self.orderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
    return [auxDisplayList count];
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.orderDetailDataManager.sectionTitleList != nil) {
        return [self.orderDetailDataManager.sectionTitleList objectAtIndex:section];        
    } else {
        return @"";
    }
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
    */
    if ([[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        NSString* sectionTitle = [self.orderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
        if ([sectionTitle isEqualToString:@"Contact"]) {
            NSMutableArray* auxDisplayList = [self.orderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            if (!self.isContactDetailShowed) {
                self.contactControlTableCell.controlLabel.text = @"Contact Details";
                return self.contactControlTableCell;
            } else if(self.isContactDetailShowed && indexPath.row == [auxDisplayList count]) {
                self.contactControlTableCell.controlLabel.text = @"Hide";
                return self.contactControlTableCell;
            }
        }
    }
     
    NSMutableDictionary* cellData = [self.orderDetailDataManager cellDataWithIndexPath:indexPath];    
    OrderDetailBaseTableCell* cell = (OrderDetailBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.tableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (OrderDetailBaseTableCell*)[self.tableCellFactory createOrderDetailBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    NSNumber* isSealed = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"IsCealed"];
    cell.isNotEditable = [isSealed boolValue];
    [cell configCellWithData:cellData];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
    if ([[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        NSString* sectionTitle = [self.orderDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
        if ([sectionTitle isEqualToString:@"Contact"]) {
            NSMutableArray* auxDisplayList = [self.orderDetailDataManager.groupedDataDict objectForKey:sectionTitle];
            NSUInteger numberOfRowsContactSection = [auxDisplayList count];
            if (!self.isContactDetailShowed) {            
                self.isContactDetailShowed = YES;                
                [self.tableView reloadData];
            } else if(self.isContactDetailShowed && indexPath.row == numberOfRowsContactSection) {
                self.isContactDetailShowed = NO;
                [self.tableView reloadData];
            }
        }
    }   
    
}

- (void)actionButtonPressed:(id)sender {   
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:self.orderDetailDataManager.actionTableDataDictList withTitle:@"" withParentContentString:@"" requestSource:TableWidgetRequestSourceListing];
    if (self.globalWidgetViewController != nil) {
//        self.actionPopover.delegate = self;
//        [self.actionPopover presentPopoverFromBarButtonItem:self.actionBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.barButtonItem = self.actionBarButton;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }
}

-(void)emailButtonPressed:(id)sender {
    NSLog(@"emailButtonPressed");
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    [self.emailPopover presentPopoverFromBarButtonItem:self.actionBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.emailNavigationController.popoverPresentationController.barButtonItem = self.actionBarButton;
    self.emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.emailNavigationController animated:YES completion:nil];
}

-(void)saveButtonPressed:(id)sender {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
    [self.view endEditing:YES];
    NSString* requestSourceText = nil;
    if ([[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        requestSourceText = @"Order";
//        if (![ArcosValidator isInteger:[self.orderDetailDataManager.orderHeader objectForKey:@"acctNo"]]) {
//            [ArcosUtils showMsg:@"Please enter an integer in the Account No." delegate:nil];
//            return;
//        }
    } else {
        requestSourceText = @"Call";
    }
    NSNumber* isSealed = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"IsCealed"];
    if ([isSealed boolValue]) {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ is not allowed to be saved.", requestSourceText] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] forceEnterCusRefOnCheckoutFlag] && [[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0 && [[ArcosUtils trim:[self.orderDetailDataManager.orderHeader objectForKey:@"custRef"]] isEqualToString:@""]) {
        [ArcosUtils showDialogBox:@"Please enter a customer reference" title:@"Warning" delegate:nil target:self tag:0 handler:nil];
        return;
    }
    BOOL resultFlag = [self.orderDetailDataManager saveTheOrderHeader];
    
    if (resultFlag) {
        NSString* hintMsg = [NSString stringWithFormat:@"The %@ has been saved.", requestSourceText];
        if (self.orderDetailDataManager.locationSwitchedFlag) {
            hintMsg = @"Location has been switched, please check Contact and Account Number.";
        }
        [ArcosUtils showDialogBox:hintMsg title:@"" delegate:self target:self tag:999999 handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"The %@ has not been saved.", requestSourceText] title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)loadSavedOrderDetailCellData:(NSMutableDictionary*)aCellData {
    if (self.savedOrderDetailCellData == nil) {
//        NSLog(@"self.savedOrderDetailCellData is assigned.");
        self.savedOrderDetailCellData = aCellData;
    }
    self.orderDetailDataManager = [[[OrderDetailDataManager alloc] init] autorelease];
    [self.orderDetailDataManager loadSavedOrderDetailCellData:aCellData];
    self.orderDetailDataManager.actionTableDataDictList = [self.orderDetailDataManager createActionTableDataDictList:aCellData];
    self.tableCellFactory = [OrderDetailTableCellFactory factory];
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [self.orderDetailDataManager.orderHeader objectForKey:@"LocationIUR"];    
    if ([[self.orderDetailDataManager.orderHeader objectForKey:@"NumberOflines"] intValue] > 0) {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceOrder;
        NSMutableDictionary* tmpWholesalerDict = [self.orderDetailDataManager.orderDetailBaseDataManager addTitleToDict:@"wholesaler" titleKey:@"wholesalerText"];
        self.emailRecipientTableViewController.wholesalerDict = tmpWholesalerDict;
        self.emailRecipientTableViewController.isSealedBOOLNumber = [aCellData objectForKey:@"IsCealed"];
        self.emailActionDelegate = [[[OrderDetailOrderEmailActionDataManager alloc] initWithOrderHeader:self.orderDetailDataManager.orderHeader] autorelease];        
    } else {
        self.emailRecipientTableViewController.requestSource = EmailRequestSourceCall;
        self.emailActionDelegate = [[[OrderDetailCallEmailActionDataManager alloc] initWithOrderHeader:self.orderDetailDataManager.orderHeader] autorelease];
    }
    self.emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailNavigationController.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
//    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
//    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
}

#pragma mark - OrderDetailTypesTableCellDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    [self.orderDetailDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
}

-(void)showPrintViewControllerDelegate {
    CheckoutPrinterWrapperViewController* cpwvc = [[CheckoutPrinterWrapperViewController alloc] initWithNibName:@"CheckoutPrinterWrapperViewController" bundle:nil];
    cpwvc.modalDelegate = self;
    cpwvc.orderHeader = self.orderDetailDataManager.orderHeader;
    cpwvc.packageIUR = [self.orderDetailDataManager.orderHeader objectForKey:@"PosteedIUR"];
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

- (void)locationInputFinishedWithData:(id)data forIndexpath:(NSIndexPath *)theIndexpath {
    self.orderDetailDataManager.locationSwitchedFlag = YES;
    [self.orderDetailDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
    [self.orderDetailDataManager locationInputFinishedWithData:data forIndexpath:theIndexpath];
    [self.orderDetailDataManager.orderDetailBaseDataManager createLocationSectionDataProcessor];
    [self.tableView reloadData];
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)showOrderlineDetailsDelegate {
    NSLog(@"showOrderlineDetailsDelegate");
    NSNumber* isSealed = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"IsCealed"];
    NSNumber* orderNumber = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine" locationIUR:[self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"LocationIUR"] packageIUR:[self.orderDetailDataManager.orderHeader objectForKey:@"PosteedIUR"]];
    NSNumber* formIUR = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"FormIUR"];
    OrderProductViewController<SubstitutableDetailViewController>* orderProducts=[[[OrderProductViewController alloc]initWithNibName:@"OrderProductViewController" bundle:nil]autorelease];
    orderProducts.delegate=self;
    orderProducts.isCellEditable=![isSealed boolValue];
    orderProducts.formIUR = formIUR;
    orderProducts.orderNumber = orderNumber;
    orderProducts.locationIUR = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    [orderProducts reloadTableDataWithData:orderLines];
    orderProducts.vansOrderHeader = self.orderDetailDataManager.orderHeader;
    
    if (self.rcsStackedController == nil) {
        [self.navigationController pushViewController:orderProducts animated:YES];
    } else {
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:orderProducts];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [tmpNavigationController release];
    }
//    [self.navigationController pushViewController:orderProducts animated:YES];
}
-(void)showCallDetailsDelegate {
    NSLog(@"showCallDetailsDelegate");
    DetailingTableViewController* dtvc = [[[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil]autorelease];
    
    dtvc.title = [self.orderDetailDataManager.orderHeader objectForKey:@"CustName"];
    NSNumber* isSealed = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"IsCealed"];
    NSNumber* orderNumber = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    dtvc.orderNumber = orderNumber;
    dtvc.isEditable = ![isSealed boolValue];
    dtvc.locationIUR = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"LocationIUR"];
    dtvc.locationName = [self.orderDetailDataManager.orderHeader objectForKey:@"CustName"];
    [self.navigationController pushViewController:dtvc animated:YES];
    
    //disable the date group selection
    /*
    UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
    UITableViewController* dateViewController=[navigation.viewControllers objectAtIndex:0];
    if ([dateViewController respondsToSelector:@selector(tableView)]) {
        dateViewController.tableView.allowsSelection=NO;
    }
    */
}

-(UIViewController*)retrieveParentViewController {
    return self;
}

- (NSMutableDictionary*)retrieveParentOrderHeader {
    return self.orderDetailDataManager.orderHeader;
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



#pragma mark UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if(buttonIndex == 0 && alertView.tag == 999999){
//        //Code that will run after you press ok button
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
//    NSLog(@"didSelectEmailRecipientRow %@", cellData);
    self.orderDetailDataManager.selectedEmailRecipientDict = cellData;
    self.orderDetailDataManager.taskObjectList = [NSMutableArray array];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTaskInCallEmailFlag]) {
        NSString* sqlStatement = [NSString stringWithFormat:@"SELECT  ContactName, TaskDescription, StartDate, TaskDetails, EmployeeName FROM  iPadOutstandingTasks WHERE LocationIUR = %@ order by StartDate asc", [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"LocationIUR"]];
        [self.callGenericServices getData:sqlStatement];
    } else {
        [self didSelectEmailRecipientRowProcessor:cellData taskData:self.orderDetailDataManager.taskObjectList];
    }
}

- (void)didSelectEmailRecipientRowProcessor:(NSDictionary*)cellData taskData:(NSMutableArray*)aTaskObjectList {
    NSMutableDictionary* mailDict = [self.emailActionDelegate didSelectEmailRecipientRowWithCellData:cellData taskData:aTaskObjectList];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:[cellData objectForKey:@"Email"] , nil];
    NSString* fileName = [self.emailActionDelegate retrieveFileName];
    self.emailRecipientTableViewController.emailRecipientDataManager.currentRecipientDict = [NSMutableDictionary dictionaryWithDictionary:cellData];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = [mailDict objectForKey:@"Subject"];
        amwvc.bodyText = [mailDict objectForKey:@"Body"];
        amwvc.isHTML = YES;
        if (![fileName isEqualToString:@""]) {
            NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
            NSData* data = [NSData dataWithContentsOfFile:pdfFilePath];            
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:data fileName:fileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
            }
            
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
//            [self.emailPopover dismissPopoverAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        return;
    }
    if (![MFMailComposeViewController canSendMail]) {
        [self dismissViewControllerAnimated:YES completion:^ {
            [ArcosUtils showDialogBox:[GlobalSharedClass shared].noMailAcctMsg title:[GlobalSharedClass shared].noMailAcctTitle target:self handler:nil];
        }];
        return;
    }
//    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
//    [self.emailPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    if (self.mailController != nil) { self.mailController = nil; }
    
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

- (void)setGetDataResult:(ArcosGenericReturnObject *)result {
//    if (result == nil) {
//        return;
//    }
    if (result.ErrorModel.Code >= 0) {
        self.orderDetailDataManager.taskObjectList = result.ArrayOfData;
    } else if(result.ErrorModel.Code < 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self.emailNavigationController handler:^(UIAlertAction *action) {
            [self didSelectEmailRecipientRowProcessor:self.orderDetailDataManager.selectedEmailRecipientDict taskData:self.orderDetailDataManager.taskObjectList];
        }];
        return;
    }
    [self didSelectEmailRecipientRowProcessor:self.orderDetailDataManager.selectedEmailRecipientDict taskData:self.orderDetailDataManager.taskObjectList];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    NSString* message = nil;
    NSString* title = nil;
//    UIAlertView* v = nil;
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
//            v = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [v show];
//            [v release];
        }            
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
//            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//            [v show];
//            [v release];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
//    NSLog(@"Email sending error message %@ ", message);
    if (result == MFMailComposeResultSent || result == MFMailComposeResultFailed) {
        [ArcosUtils showDialogBox:message title:title target:controller handler:^(UIAlertAction *action) {
            [self mailDismissViewControllerProcessor:result];
        }];
    } else {
        [self mailDismissViewControllerProcessor:result];
    }
//    [self dismissViewControllerAnimated:YES completion:^{
////        NSString* fileName = [self.emailActionDelegate retrieveFileName];
////        if (![fileName isEqualToString:@""]) {
////            NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:fileName];
////            [FileCommon removeFileAtPath:pdfFilePath];
////        }
//        BOOL successFlag = NO;
//        if (result == MFMailComposeResultSent) {
//            successFlag = YES;
//        }
//        [self dismissEmailEndProcessor:successFlag];
//    }];
}

- (void)mailDismissViewControllerProcessor:(MFMailComposeResult)result {
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
        NSIndexPath* orderStatusIndexPath = [NSIndexPath indexPathForRow:3 inSection:2];           
        [self inputFinishedWithData:self.defaultOrderSentStatusDict forIndexpath:orderStatusIndexPath];
        [self.orderDetailDataManager saveTheOrderHeader];
        [self.tableView reloadData];
    }
}

#pragma mark OrderProductViewController delegate
-(void)deleteOrderHeaderWithOrderNnumber:(NSNumber *)orderNumber {
    [self.orderProductViewControllerDelegate deleteOrderHeaderWithOrderNnumber:orderNumber];
}
-(void)totalGoodsUpdateForOrderNumber:(NSNumber *)orderNumber withValue:(NSNumber *)totalGoods totalVat:(NSNumber*)aTotalVat {
    [self.orderProductViewControllerDelegate totalGoodsUpdateForOrderNumber:orderNumber withValue:totalGoods totalVat:aTotalVat];
}

#pragma mark WidgetFactoryDelegate

- (void)operationDone:(id)data {
//    [self.actionPopover dismissPopoverAnimated:NO];
//    self.actionPopover = nil;
//    self.factory.popoverController = nil;
    [self dismissViewControllerAnimated:YES completion:^ {
        NSMutableDictionary* auxDataDict = (NSMutableDictionary*)data;
        switch ([[auxDataDict objectForKey:@"ActionType"] intValue]) {
            case 1: {
    //            [self.emailPopover presentPopoverFromBarButtonItem:self.actionBarButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                self.emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
                self.emailNavigationController.popoverPresentationController.barButtonItem = self.actionBarButton;
                self.emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
                [self presentViewController:self.emailNavigationController animated:YES completion:nil];
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
    //            UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    //            v.tag = 36;
    //            [v show];
    //            [v release];
                void (^lBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                    [self yesActionPressedProcessor];
                };
                void (^rBtnActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                    
                };
                [ArcosUtils showTwoBtnsDialogBox:message title:@"" target:self lBtnText:@"YES" rBtnText:@"NO" lBtnHandler:lBtnActionHandler rBtnHandler:rBtnActionHandler];
            }
                break;
            default:
                break;
        }
    }];
}

-(void)dismissPopoverController {
//    [self.actionPopover dismissPopoverAnimated:YES];
//    self.actionPopover = nil;
//    self.factory.popoverController = nil;
//    [self.emailPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.actionPopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

- (void)yesActionPressedProcessor {    
    NSNumber* orderNumber = [self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"OrderNumber"];
    NSMutableArray* orderLines = [[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine" locationIUR:[self.orderDetailDataManager.savedOrderDetailCellData objectForKey:@"LocationIUR"] packageIUR:[self.orderDetailDataManager.orderHeader objectForKey:@"PosteedIUR"]];
    [self.orderDetailDataManager.orderHeader setObject:orderLines forKey:@"OrderLines"];    
    [self.repeatOrderDataManager repeatOrderWithDataDict:self.orderDetailDataManager.orderHeader];
    [ArcosUtils showDialogBox:@"New order created" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag != 36) return;
//    if (buttonIndex == [alertView cancelButtonIndex]) {//yes action        
//        [self yesActionPressedProcessor];
//    } else {//no action
//        
//    }    
//}


@end
