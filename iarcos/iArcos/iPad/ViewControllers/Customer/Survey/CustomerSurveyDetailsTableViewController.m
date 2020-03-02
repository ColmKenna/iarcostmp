//
//  CustomerSurveyDetailsTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 21/06/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyDetailsTableViewController.h"

@interface CustomerSurveyDetailsTableViewController ()

- (void)alertViewCallBack;

@end

@implementation CustomerSurveyDetailsTableViewController
@synthesize callGenericServices = _callGenericServices;
@synthesize summaryCellData = _summaryCellData;
@synthesize customerSurveyDetailsDataManager = _customerSurveyDetailsDataManager;
@synthesize cellFactory = _cellFactory;
@synthesize emailButton = _emailButton;
@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize rightBarButtonItemList = _rightBarButtonItemList;
@synthesize mailController = _mailController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;
@synthesize subjectTitle = _subjectTitle;

- (void)viewDidLoad {
    [super viewDidLoad];    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
    emailRecipientTableViewController.requestSource = EmailRequestSourceEmployee;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];
    [emailRecipientTableViewController release];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.emailButton, nil];
    [self.navigationItem setRightBarButtonItems:self.rightBarButtonItemList];
    self.myRootViewController = [ArcosUtils getRootView];
    self.cellFactory = [CustomerSurveyDetailsTableCellFactory factory];
    self.customerSurveyDetailsDataManager = [[[CustomerSurveyDetailsDataManager alloc] init] autorelease];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    NSDate* auxResponseDate = [ArcosUtils dateFromString:[self.summaryCellData Field2] format:[GlobalSharedClass shared].dateFormat];
    NSDate* responseDate = [ArcosUtils addHours:1 date:auxResponseDate];
    [self.callGenericServices genericGetSurveryDetailsByLocation:[[ArcosUtils convertStringToNumber:[self.summaryCellData Field8]] intValue] contactiur:[[ArcosUtils convertStringToNumber:[self.summaryCellData Field6]] intValue] surveyiur:[[ArcosUtils convertStringToNumber:[self.summaryCellData Field1]] intValue] responseDate:responseDate action:@selector(resultBackFromGetSurveyDetailsByLocation:) target:self];
}

- (void)resultBackFromGetSurveyDetailsByLocation:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
//        self.customerSurveyDetailsDataManager.displayList = result.ArrayOfData;
        [self.customerSurveyDetailsDataManager processRawData:result.ArrayOfData];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSString* email = [cellData objectForKey:@"Email"];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:email, nil];    
    NSString* body = [self.customerSurveyDetailsDataManager buildEmailMessage];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = self.subjectTitle;
        amwvc.bodyText = body;
        amwvc.isHTML = YES;
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.myRootViewController addChildViewController:self.globalNavigationController];
        [self.myRootViewController.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            [self.emailPopover dismissPopoverAnimated:YES];
        }];
        return;
    }
    [self.emailPopover dismissPopoverAnimated:YES];
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;    
    
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    
    [self.mailController setMessageBody:body isHTML:YES];
    [self.mailController setToRecipients:toRecipients];
    [self.mailController setSubject:self.subjectTitle];
    [self.myRootViewController presentViewController:self.mailController animated:YES completion:nil];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
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

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = @"";
    NSString* title = @"";
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
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            title = [GlobalSharedClass shared].errorTitle;
        }
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    if (result != MFMailComposeResultFailed) {
        [self alertViewCallBack];
    } else {
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:99 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertViewCallBack {
    [self.myRootViewController dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}


- (void)dealloc {
    self.callGenericServices = nil;
    self.summaryCellData = nil;
    self.customerSurveyDetailsDataManager = nil;
    self.cellFactory = nil;
    self.emailButton = nil;
    self.emailPopover = nil;
    self.emailNavigationController = nil;
    self.rightBarButtonItemList = nil;
    self.mailController = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    self.subjectTitle = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ArcosGenericClass* arcosGenericClass = [self.customerSurveyDetailsDataManager.displayList objectAtIndex:indexPath.row];
    ArcosGenericClass* arcosGenericClass = [self.customerSurveyDetailsDataManager cellDataWithIndexPath:indexPath];
    int questionType = [[ArcosUtils convertStringToNumber:[arcosGenericClass Field3]] intValue];
    float auxHeight = 44.0f;
    switch (questionType) {
        case 13:
        case 14:
            auxHeight = 70.0f;
            break;
            
        default:
            break;
    }
    return auxHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.customerSurveyDetailsDataManager.sectionNoList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    CustomerSurveyDetailsSectionHeader* auxCustomerSurveyDetailsSectionHeader = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerSurveyDetailsTableCell" owner:self options:nil];
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[CustomerSurveyDetailsSectionHeader class]]) {
            auxCustomerSurveyDetailsSectionHeader = (CustomerSurveyDetailsSectionHeader*)nibItem;
            break;
        }
    }
    auxCustomerSurveyDetailsSectionHeader.narrative.text = [self.customerSurveyDetailsDataManager.sectionTitleList objectAtIndex:section];
    return auxCustomerSurveyDetailsSectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber* auxSectionNo = [self.customerSurveyDetailsDataManager.sectionNoList objectAtIndex:section];
    NSMutableArray* auxDataList = [self.customerSurveyDetailsDataManager.groupedDataDict objectForKey:auxSectionNo];
    return [auxDataList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ArcosGenericClass* cellData = [self.customerSurveyDetailsDataManager.displayList objectAtIndex:indexPath.row];
    ArcosGenericClass* cellData = [self.customerSurveyDetailsDataManager cellDataWithIndexPath:indexPath];
    CustomerSurveyDetailsResponseBaseTableCell* cell = (CustomerSurveyDetailsResponseBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (CustomerSurveyDetailsResponseBaseTableCell*)[self.cellFactory createCustomerSurveyDetailsResponseBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    
    return cell;
}



/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark CustomerSurveyDetailsResponseTableCellDelegate
- (void)inputFinishedWithData:(id)aData forIndexPath:(NSIndexPath*)theIndexPath {
    self.customerSurveyDetailsDataManager.currentIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row inSection:theIndexPath.section];
    ArcosGenericClass* auxCellData = [self.customerSurveyDetailsDataManager cellDataWithIndexPath:theIndexPath];
    if ([aData isEqualToString:auxCellData.Field6]) return;
    auxCellData.Field6 = aData;
    
    [self.callGenericServices genericUpdateRecord:@"Response" iur:[[ArcosUtils convertStringToNumber:[ArcosUtils trim:auxCellData.Field7]] intValue] fieldName:self.customerSurveyDetailsDataManager.editFieldName newContent:aData action:@selector(setGenericUpdateRecordResult:) target:self];    
}

- (void)booleanInputFinishedWithData:(id)aData forIndexPath:(NSIndexPath*)theIndexPath {
    self.customerSurveyDetailsDataManager.currentIndexPath = [NSIndexPath indexPathForRow:theIndexPath.row inSection:theIndexPath.section];
    ArcosGenericClass* auxCellData = [self.customerSurveyDetailsDataManager cellDataWithIndexPath:theIndexPath];
    if ([aData isEqualToString:auxCellData.Field6]) return;
    auxCellData.Field6 = aData;
    
    [self.callGenericServices genericUpdateRecord:@"Response" iur:[[ArcosUtils convertStringToNumber:[ArcosUtils trim:auxCellData.Field7]] intValue] fieldName:self.customerSurveyDetailsDataManager.editFieldName newContent:aData action:@selector(setBooleanGenericUpdateRecordResult:) target:self];
}

- (void)setGenericUpdateRecordResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.customerSurveyDetailsDataManager updateResponseRecord];        
    } else {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)setBooleanGenericUpdateRecordResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.customerSurveyDetailsDataManager updateBooleanResponseRecord];        
    } else {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}




@end
