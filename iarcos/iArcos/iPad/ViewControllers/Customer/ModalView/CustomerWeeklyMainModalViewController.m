//
//  CustomerWeeklyMainModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 07/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerWeeklyMainModalViewController.h"
//#import "ArcosAppDelegate_iPad.h"
//#import "MainTabbarViewController.h"
//#import "ArcosRootViewController.h"
//#import <MobileCoreServices/MobileCoreServices.h>
@interface CustomerWeeklyMainModalViewController(Private)
//-(void)navgationTitleWrapper:(NSString*)aDateString;
//- (BOOL)validateHiddenPopovers;
//- (void)alertViewCallBack;
//- (void)saveButtonCallBack;
@end

@implementation CustomerWeeklyMainModalViewController
@synthesize weeklyMainTemplateDataManager = _weeklyMainTemplateDataManager;
//@synthesize delegate;
//@synthesize dateFormat = _dateFormat;
//@synthesize currentSundayDate = _currentSundayDate;
//@synthesize employeeIUR = _employeeIUR;
//@synthesize employeeName = _employeeName;
//@synthesize sectionTitleDictList = _sectionTitleDictList;

@synthesize weeklyTableList;
//@synthesize highestAllowedSundayDate = _highestAllowedSundayDate;
//@synthesize dayOfWeekend = _dayOfWeekend;
//@synthesize currentWeekendDate = _currentWeekendDate;
//@synthesize highestAllowedWeekendDate = _highestAllowedWeekendDate;
//@synthesize employeeDetailList = _employeeDetailList;
//@synthesize employeeDict = _employeeDict;
//@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
//@synthesize parentContentString = _parentContentString;
//@synthesize globalNavigationController = _globalNavigationController;
//@synthesize rootView = _rootView;
//@synthesize mailComposeViewController = _mailComposeViewController;
//@synthesize customerWeeklyEmailProcessCenter = _customerWeeklyEmailProcessCenter;
//@synthesize cameraRollButton = _cameraRollButton;
//@synthesize cameraRollPopover = _cameraRollPopover;
//@synthesize weeklyInputRequestSource = _weeklyInputRequestSource;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.customerWeeklyMainDataManager = [[[CustomerWeeklyMainDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
//    if (self.delegate != nil) { self.delegate = nil; }
    self.weeklyMainTemplateDataManager = nil;
//    if (self.dateFormat != nil) { self.dateFormat = nil; }
//    if (self.currentSundayDate != nil) { self.currentSundayDate = nil;}
//    if (self.employeeIUR != nil) { self.employeeIUR = nil;}    
//    if (self.employeeName != nil) { self.employeeName = nil;}    
//    if (self.sectionTitleDictList != nil) { self.sectionTitleDictList = nil;}    
//    if (callGenericServices != nil) {
//        callGenericServices.delegate = nil;
//        [callGenericServices release];
//    }
//    if (connectivityCheck != nil) { [connectivityCheck release]; }
//    if (customerWeeklyMainDataManager != nil) { [customerWeeklyMainDataManager release]; }
//    self.customerWeeklyMainDataManager = nil;
    if (self.weeklyTableList != nil) { self.weeklyTableList = nil; }
//    if (arcosCreateRecordObject != nil) { [arcosCreateRecordObject release]; }
//    if (self.highestAllowedSundayDate != nil) { self.highestAllowedSundayDate = nil; }
//    if (self.dayOfWeekend != nil) { self.dayOfWeekend = nil; }  
//    if (self.currentWeekendDate != nil) { self.currentWeekendDate = nil; }  
//    if (self.highestAllowedWeekendDate != nil) { self.highestAllowedWeekendDate = nil; }
//    if (self.employeeDetailList != nil) { self.employeeDetailList = nil; }
//    if (self.employeeDict != nil) { self.employeeDict = nil; }
//    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
//    if (self.parentContentString != nil) { self.parentContentString = nil; }
//    if (employeeButton != nil) { [employeeButton release]; }
//    self.globalNavigationController = nil;
//    if (self.rootView != nil) { self.rootView = nil; }    
//    if (self.mailComposeViewController != nil) { self.mailComposeViewController = nil; }
//    if (self.customerWeeklyEmailProcessCenter != nil) { self.customerWeeklyEmailProcessCenter = nil; }
//    self.cameraRollButton = nil;
//    self.cameraRollPopover = nil;
    
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
    /*
    self.dayOfWeekend = [self getDayOfWeekend];
    NSLog(@"self.dayOfWeekend from config table is %@", self.dayOfWeekend);
    rowPointer = 0;
    self.dateFormat = @"dd/MM/yyyy";
    self.weeklyTableList.allowsSelection = NO;
    
    self.employeeIUR = [SettingManager employeeIUR];
    self.employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:self.employeeIUR];
    self.employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[self.employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[self.employeeDict objectForKey:@"Surname"]]];
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithCapacity:2];
//    [leftButtonList addObject:cancelButton];
    [leftButtonList addObject:prevButton];
    
    NSNumber* securityLevel = [self.employeeDict objectForKey:@"SecurityLevel"];
    employeeButton = [[UIBarButtonItem alloc] initWithTitle:@"Employee" style:UIBarButtonItemStylePlain target:self action:@selector(employeePressed:)];
    if ([securityLevel intValue] > 95) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
        [leftButtonList addObject:employeeButton];
        self.employeeDetailList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    }
    
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
//    [cancelButton release];
    [prevButton release];
    
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextPressed:)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];

    UIBarButtonItem* emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailPressed:)];
    self.cameraRollButton = [[[UIBarButtonItem alloc] initWithTitle:@"Camera Roll" style:UIBarButtonItemStylePlain target:self action:@selector(cameraRollPressed:)] autorelease];
    
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:3];  
    
    [rightButtonList addObject:saveButton];
    [rightButtonList addObject:nextButton];
    [rightButtonList addObject:emailButton];
    [rightButtonList addObject:self.cameraRollButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];    
    [saveButton release];
    [nextButton release];
    [emailButton release];    
    
    
    self.currentWeekendDate = [self weekendOfWeek:[NSDate date] config:[self.dayOfWeekend integerValue]];
    self.highestAllowedWeekendDate = [self weekendOfWeek:[NSDate date] config:[self.dayOfWeekend integerValue]];
    [self navgationTitleWrapper:[ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='WF'"];
        NSArray* sortArray = [NSArray arrayWithObjects:@"DescrDetailCode",nil];
    self.sectionTitleDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicate sortByArray:sortArray];
//    NSLog(@"%@", self.sectionTitleDictList);

    arcosCreateRecordObject = [[ArcosCreateRecordObject alloc] init];
    
//    customerWeeklyMainDataManager = [[CustomerWeeklyMainDataManager alloc] initWithSectionTitleDictList:self.sectionTitleDictList];
        
    callGenericServices = [[CallGenericServices alloc] initWithView:self.view];
    callGenericServices.delegate = self;
    
    //set the notification

    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
    self.customerWeeklyEmailProcessCenter = [[[CustomerWeeklyEmailProcessCenter alloc] init] autorelease];
    */
//    [self queryWeeklyRecord:self.currentWeekendDate];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [callGenericServices refreshHUDViewFrame:self.view];
//    [self queryWeeklyRecord:self.currentWeekendDate];
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
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    for (int i = 0; i < [self.tableView.dataSource numberOfSectionsInTableView:self.tableView]; i++) {
        [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return 160;
    }
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.weeklyMainTemplateDataManager.sectionTitleDictList != nil) {
        return [self.weeklyMainTemplateDataManager.sectionTitleDictList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary* sectionTitleDict = [self.weeklyMainTemplateDataManager.sectionTitleDictList objectAtIndex:section];
    return [sectionTitleDict objectForKey:@"Detail"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    NSMutableDictionary* cellData = [self.weeklyMainTemplateDataManager cellDataWithIndexPath:indexPath];
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerWeeklyMainTableCell" owner:self options:nil];
    CustomerWeeklyMainTableCell* cell = [nibContents objectAtIndex:0];
    
    // Configure the cell...
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    cell.delegate = self;
    
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
}
/*
-(void)prevPressed:(id)sender {
    if (![self validateHiddenPopovers]) return;
    [self.view endEditing:YES];
    [self.weeklyMainTemplateDataManager reinitiateAttachmentAuxiObject];
    self.currentWeekendDate = [ArcosUtils prevSunday:self.currentWeekendDate];
    [self navgationTitleWrapper:[ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    [self queryWeeklyRecord:self.currentWeekendDate];
}

-(void)employeePressed:(id)sender {
    if (![self validateHiddenPopovers]) return;
    if ([self.thePopover isPopoverVisible]) {
        [self.thePopover dismissPopoverAnimated:YES];
    } else {
        self.thePopover = [self.factory CreateTableWidgetWithData:self.employeeDetailList withTitle:@"Employee" withParentContentString:self.employeeName];
        //do show the popover if there is no data
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromBarButtonItem:employeeButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
-(void)nextPressed:(id)sender {
    if (![self validateHiddenPopovers]) return;
    [self.view endEditing:YES];
    self.currentWeekendDate = [ArcosUtils nextSunday:self.currentWeekendDate];
//    NSLog(@"currentSundayDate is %@ ", [ArcosUtils stringFromDate:self.currentSundayDate format:self.dateFormat]);
//    NSLog(@"highestAllowedSundayDate is %@ ", [ArcosUtils stringFromDate:self.highestAllowedSundayDate format:self.dateFormat]);
    NSComparisonResult dateCompareResult = [self.currentWeekendDate compare:self.highestAllowedWeekendDate];
    if (dateCompareResult == NSOrderedDescending) {
        self.currentWeekendDate = [ArcosUtils prevSunday:self.currentWeekendDate];
        [ArcosUtils showMsg:-1 message:@"It is not allowed to fill out the weekly report on the date that is bigger than the day of weekend of the current week." delegate:nil];
        return;
    }
    [self.weeklyMainTemplateDataManager reinitiateAttachmentAuxiObject];
    [self navgationTitleWrapper:[ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    [self queryWeeklyRecord:self.currentWeekendDate];
}
 */
/*
-(void)savePressed:(id)sender {
//    NSLog(@"groupedDataDict is %@", [customerWeeklyMainDataManager groupedDataDict]);
    if (![self validateHiddenPopovers]) return;
    [self.view endEditing:YES];
    if (![customerWeeklyMainDataManager checkValidation]) {
        [ArcosUtils showDialogBox:@"Please fill out at least one of these fields." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([customerWeeklyMainDataManager isNewRecord]) {
        [self createWeeklyRecord];
    } else {
        [customerWeeklyMainDataManager getChangedDataList];
//        NSLog(@"updatedFieldNameList %@", customerWeeklyMainDataManager.updatedFieldNameList);
//        NSLog(@"updatedFieldValueList %@", customerWeeklyMainDataManager.updatedFieldValueList);
        if ([customerWeeklyMainDataManager.updatedFieldNameList count] == 0) {
            [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
        [self updateWeeklyRecord];
    }
}
 
-(void)navgationTitleWrapper:(NSString*)aDateString {
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@: %@", self.employeeName, aDateString]];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    //    NSLog(@"set result happens in customer memo");
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.weeklyMainTemplateDataManager processRawData:result.ArrayOfData];
//        NSLog(@"customerWeeklyMainDataManager is %@", customerWeeklyMainDataManager.groupedDataDict);
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        if (result.ErrorModel.Code < 0) {
            [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        }
//        NSLog(@"customerWeeklyMainDataManager second is  %@", customerWeeklyMainDataManager.groupedDataDict);
        [self.weeklyMainTemplateDataManager createBasicData];
        [self.tableView reloadData];
    }
    //    [activityIndicator stopAnimating];
}
*/
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
//    [customerWeeklyMainDataManager updateChangedData:data withIndexPath:theIndexpath];
    [self.weeklyMainTemplateDataManager updateChangedData:data withIndexPath:theIndexpath];
}

-(UIViewController*)retrieveParentViewController {
    return self;
}
/*
-(void)queryWeeklyRecord:(NSDate*)aCurrentWeekendDate {
    NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,EmployeeIUR,WeekEndDate,Narrative1,Narrative2,Narrative3,Narrative4,Day1AM  from Weekly where EmployeeIUR = %d and WeekEndDate = convert(datetime, '%@', 103)", [self.employeeIUR intValue], [ArcosUtils stringFromDate:aCurrentWeekendDate format:self.dateFormat]];
//    NSLog(@"%@", sqlStatement);
    [callGenericServices getData: sqlStatement];
}

-(void)createWeeklyRecord {
    [customerWeeklyMainDataManager prepareForCreateWeeklyRecord];
    [customerWeeklyMainDataManager.fieldNameList addObject:@"EmployeeIUR"];
    [customerWeeklyMainDataManager.fieldValueList addObject:[self.employeeIUR stringValue]];
    [customerWeeklyMainDataManager.fieldNameList addObject:@"WeekEndDate"];
    [customerWeeklyMainDataManager.fieldValueList addObject:[ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    arcosCreateRecordObject.FieldNames = customerWeeklyMainDataManager.fieldNameList;
    arcosCreateRecordObject.FieldValues = customerWeeklyMainDataManager.fieldValueList;
    [callGenericServices createRecord:@"Weekly" fields:arcosCreateRecordObject];
}

-(void)updateWeeklyRecord {
    if (rowPointer == [customerWeeklyMainDataManager.updatedFieldNameList count]) return;
    [callGenericServices updateRecord:@"Weekly" iur:[customerWeeklyMainDataManager.iur intValue] fieldName:[customerWeeklyMainDataManager.updatedFieldNameList objectAtIndex:rowPointer] newContent:[customerWeeklyMainDataManager.updatedFieldValueList objectAtIndex:rowPointer]];
    
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {        
        rowPointer++;        
        if (rowPointer == [customerWeeklyMainDataManager.updatedFieldNameList count]) {
            [ArcosUtils showDialogBox:@"Completed." title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
                [self saveButtonCallBack];
            }];
        }
        [self updateWeeklyRecord];
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        //        [activityIndicator stopAnimating];
        return;
    }
    [ArcosUtils showDialogBox:@"Completed" title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
        [self saveButtonCallBack];
    }];
}


-(NSNumber*)getDayOfWeekend {
    NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
    return [configDict objectForKey:@"DayofWeekend"];
}

-(NSDate*)weekendOfWeek:(NSDate*)aDate config:(NSInteger)aDayOfWeekend {
    //in sql server
    //0 or 7 stands for Sunday.
    //1 to 6 stand for Monday to Saturday
    //in objective c 1 to 7 stand for Sunday to Saturday
    if (aDayOfWeekend == 7) {
        aDayOfWeekend = 0;
    }
//    NSLog(@"aDayOfWeekend is %d", [ArcosUtils convertNSIntegerToInt:aDayOfWeekend]);
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents* weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:aDate];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    //in order to sync with the number in the sql server
    NSInteger weekday = [weekdayComponents weekday] - 1;
    NSInteger numOfdays = 0;
    if (weekday == aDayOfWeekend) {
        
    } else {
        numOfdays = (aDayOfWeekend == 0) ? (aDayOfWeekend - weekday + 7) : (aDayOfWeekend - weekday);
    }    
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aDate options:0];
}

-(NSDate*)prevWeekend:(NSDate*)aCurrentWeekendDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    int numOfdays = -7;
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aCurrentWeekendDate options:0];
}

-(NSDate*)nextWeekend:(NSDate*)aCurrentWeekendDate {
    NSCalendar* gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];    
    NSDateComponents* componentsToAdd = [[[NSDateComponents alloc] init] autorelease];
    int numOfdays = 7;
    [componentsToAdd setDay:numOfdays];
    return [gregorian dateByAddingComponents:componentsToAdd
                                      toDate:aCurrentWeekendDate options:0];
}

-(void)operationDone:(id)data {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    NSString* title = [data objectForKey:@"Title"];
    if ([title isEqualToString:self.employeeName]) return;
    self.employeeIUR = [data objectForKey:@"IUR"];
    self.employeeDict = data;
    self.employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[self.employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[self.employeeDict objectForKey:@"Surname"]]];
    [self navgationTitleWrapper:[ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    [self queryWeeklyRecord:self.currentWeekendDate];
//    NSLog(@"%@", data);
}

-(void)dismissPopoverController {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
}
 */
/*
-(void)emailPressed:(id)sender {
    if (![self validateHiddenPopovers]) return;
    NSString* subject = [NSString stringWithFormat:@"Weekly Report from %@ for Week Ending %@", self.employeeName, [ArcosUtils stringFromDate:self.currentWeekendDate format:self.dateFormat]];
    NSString* body = [self.customerWeeklyEmailProcessCenter buildEmailMessageWithDataManager:customerWeeklyMainDataManager];    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.subjectText = subject;
        amwvc.bodyText = body;
        amwvc.isHTML = YES;
        for (int i = 0; i < [customerWeeklyMainDataManager.attachmentFileNameList count]; i++) {
            NSData* tmpFileData = [customerWeeklyMainDataManager.attachmentFileContentList objectAtIndex:i];
            NSString* tmpFileName = [customerWeeklyMainDataManager.attachmentFileNameList objectAtIndex:i];
            [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:tmpFileData filename:tmpFileName]];
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
            
        }];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    self.mailComposeViewController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:subject];
    [self.mailComposeViewController setMessageBody:body isHTML:YES];
    for (int i = 0; i < [customerWeeklyMainDataManager.attachmentFileNameList count]; i++) {
        NSData* tmpFileData = [customerWeeklyMainDataManager.attachmentFileContentList objectAtIndex:i];
        NSString* tmpFileName = [customerWeeklyMainDataManager.attachmentFileNameList objectAtIndex:i];
        [self.mailComposeViewController addAttachmentData:tmpFileData mimeType:@"image/jpg" fileName:tmpFileName];
    }
//    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.mailComposeViewController animated:YES completion:nil];
    
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

-(void)cameraRollPressed:(id)sender {
    //    if (self.cameraRollPopover != nil && [self.cameraRollPopover isPopoverVisible]) {
    //        [self.cameraRollPopover dismissPopoverAnimated:YES];
    //        return;
    //    }
    if (![self validateHiddenPopovers]) return;
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
    }
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    self.cameraRollPopover = [[[UIPopoverController alloc] initWithContentViewController:imagePickerController] autorelease];
    [imagePickerController release];
    [self.cameraRollPopover presentPopoverFromBarButtonItem:self.cameraRollButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    @try {
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg",[GlobalSharedClass shared].currentTimeStamp];
        [customerWeeklyMainDataManager.attachmentFileNameList addObject:fileName];
        [customerWeeklyMainDataManager.attachmentFileContentList addObject:UIImageJPEGRepresentation(image, 1.0)];
        [ArcosUtils showMsg:@"The photo has been attached." delegate:nil];
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    [self.cameraRollPopover dismissPopoverAnimated:YES];
    self.cameraRollPopover = nil;
}
 
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.cameraRollPopover dismissPopoverAnimated:YES];
    self.cameraRollPopover = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)validateHiddenPopovers {
    if (self.cameraRollPopover != nil && [self.cameraRollPopover isPopoverVisible]) {
        [self.cameraRollPopover dismissPopoverAnimated:YES];
        return NO;
    }
    if (self.thePopover != nil && [self.thePopover isPopoverVisible]) {
        [self.thePopover dismissPopoverAnimated:YES];
        return NO;
    }
    return YES;
}

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
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.mailComposeViewController = nil;
    }];
}

- (void)saveButtonCallBack {
    rowPointer = 0;
    int itemIndex = [self.rootView.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    [self.rootView.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        [self alertViewCallBack];
    }
    if (alertView.tag == 77) {
        [self saveButtonCallBack];
    }
}
*/
@end
