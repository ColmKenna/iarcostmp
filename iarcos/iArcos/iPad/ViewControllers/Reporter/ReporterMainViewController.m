//
//  ReporterMainViewController.m
//  Arcos
//
//  Created by David Kilmartin on 06/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReporterMainViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "SettingManager.h"
#import "ArcosUtils.h"

@implementation ReporterMainViewController
@synthesize reportListView;
//@synthesize displayList;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize reportGenericUITableViewController = _reportGenericUITableViewController;
@synthesize callGenericServices = _callGenericServices;
@synthesize HUD = _HUD;
@synthesize selectedReportCode = _selectedReportCode;
@synthesize reportTitle = _reportTitle;
@synthesize reportManager = _reportManager;
@synthesize reporterFileManager = _reporterFileManager;
@synthesize reporterExcelQLPreviewController = _reporterExcelQLPreviewController;
@synthesize startCalculateDate = _startCalculateDate;
@synthesize endCalculateDate = _endCalculateDate;
@synthesize reporterMainDataManager = _reporterMainDataManager;
@synthesize reporterService = _reporterService;
@synthesize arcosCustomiseAnimation = _arcosCustomiseAnimation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.reporterMainDataManager = [[[ReporterMainDataManager alloc] init] autorelease];
        self.reporterService = [ArcosService service];
    }
    return self;
}

- (void)dealloc
{    
    if (self.reportListView != nil) { self.reportListView = nil; }        
//    if (self.displayList != nil) { self.displayList = nil; }
    if (self.callGenericServices != nil) {
        self.callGenericServices = nil;
    }
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
//    if (arcosCustomiseAnimation != nil) {
//        [arcosCustomiseAnimation release];
//    }
    if (self.reportGenericUITableViewController != nil) {
        self.reportGenericUITableViewController = nil;
    }
    if (self.HUD != nil) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    if (self.selectedReportCode != nil) { self.selectedReportCode = nil; }
    if (self.reportTitle != nil) { self.reportTitle = nil; }    
    if (self.reportManager != nil) { self.reportManager = nil; }
    if (self.reporterFileManager != nil) { self.reporterFileManager = nil; }
    if (self.reporterExcelQLPreviewController != nil) { self.reporterExcelQLPreviewController = nil; }
    if (self.startCalculateDate != nil) { self.startCalculateDate = nil; }
    if (self.endCalculateDate != nil) { self.endCalculateDate = nil; }
    if (self.reporterMainDataManager != nil) { self.reporterMainDataManager = nil; }
    self.reporterService = nil;
    self.arcosCustomiseAnimation = nil;
    
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
    self.arcosCustomiseAnimation = [[[ArcosCustomiseAnimation alloc] init] autorelease];
    self.arcosCustomiseAnimation.delegate = self;
    self.reportListView.backgroundColor=[UIColor colorWithRed:239/256.0f green:235/256.0f blue:229/256.0f alpha:1.0f];
    self.reportListView.sectionHeaderHeight = 5;
    self.reportListView.sectionFooterHeight = 5;
    /*
    ArcosAppDelegate_iPad* delegate = [[UIApplication sharedApplication] delegate];
    UITabBarController* tabbar = (UITabBarController*) delegate.mainTabbarController;
    */
    self.rootView = [ArcosUtils getRootView];
    
//    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
//    self.title = @"Reporter";
    
    self.selectedReportCode=@"";
    self.reportTitle=@"";
    
    isReportSet=NO;
    self.reportManager = [ReportManager Manager];
    self.reportManager.delegate = self;
    [FileCommon createFolder:@"reporter"];
    [FileCommon removeAllFileUnderFolder:@"reporter"];
    self.reporterFileManager = [[[ReporterFileManager alloc] init] autorelease];
    self.reporterFileManager.fileDelegate = self;
//    self.reporterMainDataManager = [[[ReporterMainDataManager alloc] init] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.reportListView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
//    self.callGenericServices.delegate = self;
    /*
    if (!isReportSet) {
        NSString* sqlStatement = [NSString stringWithFormat:@"select * from iPadSavedFilters"];
        [self.callGenericServices getData: sqlStatement];  
    }
    */
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isReportSet) {
//        NSString* sqlStatement = [NSString stringWithFormat:@"select Active,Toggle1,EmployeeIUR,ImageIUR,CurrentOption,Subject,Details,DescrTypeCode,ProfileOrder,PrintSequence,iur,StartDate,EndDate from iPadSavedFilters where (employeeiur = %@ or toggle1 = 1) order by Subject", [SettingManager employeeIUR]];
//        [self.callGenericServices getData: sqlStatement];
//        [self.callGenericServices genericReporterOptionsWithAction:@selector(resultBackFromReporterOptions:) target:self];
    }
    if (self.HUD != nil) {
        self.HUD.frame = self.navigationController.view.bounds;
    }
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.navigationController.view setNeedsLayout];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.reporterMainDataManager.displayList != nil) {
        return [self.reporterMainDataManager.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *CellIdentifier = @"IdReporterTableViewCell";
    
    ReporterTableViewCell *cell=(ReporterTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReporterTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[ReporterTableViewCell class]] && [[(ReporterTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (ReporterTableViewCell *) nibItem;                
            }    
            
        }
        
	}
    
    //fill the data for cell
    ArcosGenericClass* aReporter = [self.reporterMainDataManager.displayList objectAtIndex:indexPath.row];
    NSMutableDictionary* aDateDict = [self.reporterMainDataManager.dateDictDisplayList objectAtIndex:indexPath.row];
    cell.reporterHolder = aReporter;
    [cell configCellWithData:aDateDict];
    cell.locationList = self.reporterMainDataManager.locationList;
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.startDateLabel.text = [ArcosUtils stringFromDate:[aDateDict objectForKey:@"StartDate"] format:[GlobalSharedClass shared].dateFormat];
    cell.endDateLabel.text = [ArcosUtils stringFromDate:[aDateDict objectForKey:@"EndDate"] format:[GlobalSharedClass shared].dateFormat];
    cell.locationTitleLabel.text = [NSString stringWithFormat:@"%@:",[aDateDict objectForKey:@"TableName"]];
    cell.locationLabel.text = [aDateDict objectForKey:@"SelectedIURName"];
    
    cell.sortByValueLabel.text = [aDateDict objectForKey:@"SortBy"];
    UIImage* bgImage = [UIImage imageNamed:@"presenterTableCell_stretchable.png"];    
    cell.bgImageView.image = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];//[bgImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    
    //NSLog(@"presenter title is %@  name is %@",[aPresentProduct objectForKey:@"Title"],[aPresentProduct objectForKey:@"Name"]);
//    cell.title.text = [aReporter Field6];
    cell.myDescription.text = [aReporter Field7];
    if ([aReporter.Field8 isEqualToString:@"IQ"]) {
        cell.myDescription.text = @"";
    }
    cell.extraDesc.text = [aReporter Field5];
    
    NSNumber* imageIur = [ArcosUtils convertStringToNumber:[aReporter Field4]];
    UIImage* anImage = nil;
    if ([imageIur intValue] > 0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
    }
    if (anImage == nil) {
        anImage=[UIImage imageNamed:@"iArcos_72.png"];
    }
    //cell.mainImage.image = anImage;
    [cell.mainButton setImage:anImage forState:UIControlStateNormal];
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
//    ReportViewController* RVC=[[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
//    [self.navigationController pushViewController:RVC animated:YES];
//    [RVC release];
    
//    ReportViewController2* RVC=[[ReportViewController2 alloc]initWithNibName:@"ReportViewController2" bundle:nil];
//    [self.navigationController pushViewController:RVC animated:YES];
//    [RVC release];
    
//    [callGenericServices.HUD show:YES];
    ReporterTableViewCell* auxCell = (ReporterTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
     ArcosGenericClass* aReporter = [self.reporterMainDataManager.displayList objectAtIndex:indexPath.row];
    self.reporterMainDataManager.selectedReporterHolder = aReporter;
    NSNumber* reportIUR=[NSNumber numberWithInt: [aReporter.Field11 intValue]];
    self.selectedReportCode = [NSString stringWithFormat:@"%@", aReporter.Field5] ;
    NSString* auxTitle = @"";
    if (![auxCell.productValueLabel.text isEqualToString:@""] && ![auxCell.productValueLabel.text isEqualToString:@"All"]) {
        auxTitle = [NSString stringWithFormat:@"%@ - %@", [ArcosUtils convertNilToEmpty:aReporter.Field6], auxCell.productValueLabel.text];
    } else {
        auxTitle = [NSString stringWithFormat:@"%@", [ArcosUtils convertNilToEmpty:aReporter.Field6]];
    }
//    if ([auxCell.productValueLabel.text isEqualToString:@""]) {
//        auxTitle = [NSString stringWithFormat:@"%@", aReporter.Field6];
//    } else {
//        auxTitle = [NSString stringWithFormat:@"%@ - %@", aReporter.Field6, auxCell.productValueLabel.text];
//    }
    self.reportTitle = [NSString stringWithFormat:@"%@", auxTitle];
    self.reporterFileManager.reportTitle = [NSString stringWithFormat:@"%@", auxTitle];
    NSMutableDictionary* tmpDateDict = [self.reporterMainDataManager.dateDictDisplayList objectAtIndex:indexPath.row];
    NSString* tableNameValue = [tmpDateDict objectForKey:@"TableName"];
    if (![[ArcosUtils trim:[ArcosUtils convertNilToEmpty:aReporter.Field15]] isEqualToString:@""]) {
        tableNameValue = [NSString stringWithFormat:@"%@,%@", [tmpDateDict objectForKey:@"TableName"], [tmpDateDict objectForKey:@"SortBy"]];
    }
    NSString* testExtraParams = @"";
    NSString* productsContent = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:aReporter.Field18]];
    if ([productsContent isEqualToString:@""] || [productsContent isEqualToString:@"0"]) {
        testExtraParams = @"";
    } else {
        testExtraParams = [NSString stringWithFormat:@"{\"products\":\"%@\"}", productsContent];
    }
    
    [self doParseReport:reportIUR startDate:[tmpDateDict objectForKey:@"StartDate"] endDate:[tmpDateDict objectForKey:@"EndDate"] tableName:tableNameValue selectedIUR:[tmpDateDict objectForKey:@"SelectedIUR"]  extraParams:testExtraParams];
//    NSLog(@"TableName SelectedIUR %@ %@ %@ %@", [tmpDateDict objectForKey:@"TableName"], [tmpDateDict objectForKey:@"SelectedIUR"], [tmpDateDict objectForKey:@"StartDate"], [tmpDateDict objectForKey:@"EndDate"]);
}

- (void) doParseReport:(NSNumber*)reportIUR startDate:(NSDate*)aStartDate endDate:(NSDate*)anEndDate tableName:(NSString*)aTableName selectedIUR:(NSNumber*)aSelectedIUR extraParams:(NSString*)anExtraParams {
    //spining
    if (self.HUD == nil) {
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
        self.HUD.dimBackground = YES;
        self.HUD.labelText = @"Loading";
        [self.navigationController.view addSubview:self.HUD];
    }
    
    
    
    //reprot manager
    
//    ReportManager* manager=[ReportManager Manager];
//    manager.delegate=self;
    NSLog(@"selectedReportCode is: %@", self.selectedReportCode);
//    NSLog(@"aStartDate anEndDate: %@ %@", aStartDate, anEndDate);
    [GlobalSharedClass shared].serviceTimeoutInterval=[GlobalSharedClass shared].reporterServiceTimeoutInterval;
    
    if ([self.reporterMainDataManager.selectedReporterHolder.Field8 isEqualToString:@"IQ"]) {
        [self.HUD show:YES];
        [self.reporterService ExecuteSql:self action:@selector(backFromExecuteSql:) TypeCode:@"IQ" DetailCode:[ArcosUtils convertNilToEmpty:self.reporterMainDataManager.selectedReporterHolder.Field19]];
        return;
    }
    if ([[self.selectedReportCode substringToIndex:1]isEqualToString:@"2"]) {
        [self.HUD show:YES];        
        [self.reportManager runXMLReportWithIUR:reportIUR withEmployeeIUR:[SettingManager employeeIUR] withStartDate:aStartDate withEndDate:anEndDate tableName:aTableName selectedIUR:aSelectedIUR extraParams:anExtraParams];
    } else if ([self.selectedReportCode isEqualToString:@"3.03"]) {
        ReporterTrackGraphViewController* RTGVC = [[ReporterTrackGraphViewController alloc] initWithNibName:@"ReporterTrackGraphViewController" bundle:nil];
        RTGVC.title = self.reportTitle;
        RTGVC.reportIUR = reportIUR;
        RTGVC.startDate = aStartDate;
        RTGVC.endDate = anEndDate;
        RTGVC.tableName = aTableName;
        RTGVC.selectedIUR = aSelectedIUR;
        [self.navigationController pushViewController:RTGVC animated:YES];
        [RTGVC release];      
    } else {        
        [self.HUD show:YES];
        [self.reportManager runExcelReportWithIUR:reportIUR withEmployeeIUR:[SettingManager employeeIUR] withStartDate:aStartDate withEndDate:anEndDate tableName:aTableName selectedIUR:aSelectedIUR extraParams:anExtraParams];
    }
}

- (void)backFromExecuteSql:(ArcosGenericClass*)result {
    [GlobalSharedClass shared].serviceTimeoutInterval = [GlobalSharedClass shared].defaultServiceTimeoutInterval;
    if (result != nil) {
        if ([result isKindOfClass:[NSError class]]) {
            [self.HUD hide:YES];
            NSError* anError = (NSError*)result;
            [ArcosUtils showDialogBox:[anError description] title:@"" target:self handler:nil];
        } else if([result isKindOfClass:[SoapFault class]]){
            [self.HUD hide:YES];
            SoapFault* anFault = (SoapFault*)result;
            [ArcosUtils showDialogBox:[anFault faultString] title:@"" target:self handler:nil];
        } else {
            NSString* aFileName = [NSString stringWithFormat:@"%@", [ArcosUtils convertNilToEmpty:result.Field2]];
//            NSString* serverFilePath = [self.reportManager createReportFilePath:aFileName];
//            NSURL* serverFileURL = [NSURL URLWithString:serverFilePath];
            NSString* excelFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", self.reporterFileManager.reporterFolderName, aFileName]];
            self.reporterFileManager.localExcelFilePath = excelFilePath;
            self.reporterFileManager.fileName = aFileName;
            [FileCommon removeFileAtPath:excelFilePath];
            BOOL wsrExistence = [ArcosSystemCodesUtils webServiceResourceExistence];
            if (!wsrExistence) {
//                [self.reporterFileManager downloadFileWithURL:serverFileURL destFolderName:self.reporterFileManager.reporterFolderName fileName:aFileName];
                [self.HUD hide:YES];
                [ArcosUtils showDialogBox:@"Please check the default settings" title:@"" target:self handler:nil];
            } else {
                self.reporterFileManager.destFolderName = self.reporterFileManager.reporterFolderName;
                [self.reporterService GetFromResources:self action:@selector(wsrCsvBackFromService:) FileNAme:self.reporterFileManager.fileName];
                self.reporterFileManager.previewDocumentList = [NSMutableArray arrayWithCapacity:1];
                [self.reporterFileManager.previewDocumentList addObject:[NSString stringWithFormat:@"%@", aFileName]];
            }
        }
    } else {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:@"Data not expected" title:@"" target:self handler:nil];
    }
}

- (void)wsrCsvBackFromService:(id)result {
//    [self.HUD hide:YES];
    result = [ArcosSystemCodesUtils handleResultErrorProcess:result];
    if (result == nil) {
        [self.HUD hide:YES];
        return;
    }
    BOOL saveFileFlag = [ArcosSystemCodesUtils convertBase64ToPhysicalFile:result filePath:[NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath], self.reporterFileManager.fileName]];
    if (saveFileFlag) {
        [self.reporterService DeleteFromResources:self action:@selector(deleteResourcesBackFromService:) FileNAme:self.reporterFileManager.fileName];
    } else {
        [self.HUD hide:YES];
        [ArcosUtils showDialogBox:@"Unable to save the csv file on the iPad." title:@"" target:self handler:^(UIAlertAction *action) {}];
    }
}

- (void)deleteResourcesBackFromService:(id)result {
    [self.HUD hide:YES];
    result = [ArcosSystemCodesUtils handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    [self drillDownToCsvView];
}

- (void)drillDownToCsvView {
    ReporterCsvViewController* reporterCsvViewController = [[ReporterCsvViewController alloc] initWithNibName:@"ReporterCsvViewController" bundle:nil];
    reporterCsvViewController.animateDelegate = self;
    reporterCsvViewController.title = self.reportTitle;
    [reporterCsvViewController.reporterCsvDataManager processRawDataWithFilePath:[NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath], self.reporterFileManager.fileName]];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:reporterCsvViewController] autorelease];
    [reporterCsvViewController release];
    [self.arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

#pragma mark - SlideAcrossViewAnimationDelegate
- (void)dismissSlideAcrossViewAnimation {
    [self.arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

#pragma mark - ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

- (void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

#pragma mark - GetDataGenericDelegate
- (void)resultBackFromReporterOptions:(ArcosGenericReturnObject*)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.reporterMainDataManager processRawData:result.ArrayOfData];
        [self.tableView reloadData];
        isReportSet=YES;
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}

-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
//    NSLog(@"set result happens in customer order");
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        /*
        self.displayList = result.ArrayOfData;
        self.dateDictDisplayList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
        for (int i = 0; i < [self.displayList count]; i++) {            
            NSDate* tmpStartDate = [ArcosUtils addMonths:-1 date:[NSDate date]];
            NSDate* tmpEndDate = [NSDate date];
            NSMutableDictionary* tmpDateDict = [NSMutableDictionary dictionaryWithCapacity:2];
            [tmpDateDict setObject:tmpStartDate forKey:@"StartDate"];
            [tmpDateDict setObject:tmpEndDate forKey:@"EndDate"];
            [self.dateDictDisplayList addObject:tmpDateDict];
        }
        */
        [self.reporterMainDataManager processRawData:result.ArrayOfData];
        [self.tableView reloadData]; 
        isReportSet=YES;
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}
#pragma mark reprot manager delegate
-(void)reportXMLDocumentGenerated:(CXMLDocument *)doc{
    ReportCellFactory* RCF =[[[ReportCellFactory alloc]init] autorelease];
    int cellTag=[RCF viewTagWithCode:self.selectedReportCode];
    
    if (cellTag!=88) {//if the report is not the default one
        
//        ReportTableViewController* table=[[ReportTableViewController alloc]initWithNibName:@"ReportTableViewController" bundle:nil];
//        table.ReportDocument=doc;
//        table.reportCode=self.selectedReportCode;
//        table.title=self.reportTitle;
//
//        [self.navigationController pushViewController:table animated:YES];
//        [table release];
         
        ReportMainTemplateViewController* reportMainTemplateViewController = [[ReportMainTemplateViewController alloc] initWithNibName:@"ReportMainTemplateViewController" bundle:nil];
        reportMainTemplateViewController.reportTableViewController.ReportDocument = doc;
        reportMainTemplateViewController.reportTableViewController.reportCode = self.selectedReportCode;
        reportMainTemplateViewController.title = self.reportTitle;
        
        [reportMainTemplateViewController.reporterXmlSubTableViewController.reporterXmlSubDataManager processRawData:doc];
        [reportMainTemplateViewController.reporterXmlGraphViewController.reporterXmlGraphDataManager processRawData:doc];
        [reportMainTemplateViewController.reporterXmlExcelViewController processRawData:doc fileName:self.reporterMainDataManager.selectedReporterHolder.Field6];
        
        [self.navigationController pushViewController:reportMainTemplateViewController animated:YES];
        [reportMainTemplateViewController release];
    }
    self.reportManager.ReportDocument = nil;
    [self.HUD hide:YES];
//    [self.HUD removeFromSuperview];
}
-(void)reportExcelDocumentGenerated:(NSString*)doc{
    NSLog(@"excel document name %@",doc);
    ReportExcelViewController* excelView=[[ReportExcelViewController alloc]initWithNibName:@"ReportExcelViewController" bundle:nil];
    
    excelView.filePath=doc;
    //excelView.filePath=@"http://www.strataarcos.com/copydataservice/Resources/83056.xls";//for testing
    [self.navigationController pushViewController:excelView animated:YES];
    [excelView release];
    
    [self.HUD hide:YES];
//    [self.HUD removeFromSuperview];
}

-(void)reportDocumentGeneratedWithError:(NSString*)error{
//    [ArcosUtils showMsg:error title:@"Error" delegate:nil];
    [ArcosUtils showDialogBox:error title:@"Error" delegate:nil target:self tag:0 handler:nil];
    [self.HUD hide:YES];
//    [self.HUD removeFromSuperview];
}
-(void)reportDocumentGeneratedWithErrorOccured {
    [self.HUD hide:YES];
}

-(void)reportExcelDocumentGeneratedWithServerFilePath:(NSString*)aServerFilePath fileName:(NSString*)aFileName pdfServerFilePath:(NSString *)aPdfServerFilePath pdfFileName:(NSString *)aPdfFileName {
    //remove files downloaded before
    NSString* excelFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", self.reporterFileManager.reporterFolderName, aFileName]];
    self.reporterFileManager.localExcelFilePath = excelFilePath;
    self.reporterFileManager.fileName = aFileName;
    [FileCommon removeFileAtPath:excelFilePath];
//    NSString* pdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", self.reporterFileManager.reporterFolderName, aPdfFileName]];
//    [FileCommon removeFileAtPath:pdfFilePath];
    NSURL* serverFileURL = [NSURL URLWithString:aServerFilePath];
//    self.reporterFileManager.pdfFileName = [NSString stringWithFormat:@"%@", aPdfFileName];
//    self.reporterFileManager.pdfServerFilePath = [NSString stringWithFormat:@"%@", aPdfServerFilePath];
//    self.startCalculateDate = [NSDate date];
    BOOL wsrExistence = [ArcosSystemCodesUtils webServiceResourceExistence];
    if (!wsrExistence) {
        [self.reporterFileManager downloadFileWithURL:serverFileURL destFolderName:self.reporterFileManager.reporterFolderName fileName:aFileName];
    } else {
        
        self.reporterFileManager.destFolderName = self.reporterFileManager.reporterFolderName;
        ArcosService* service = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
        [service GetFromResources:self action:@selector(wsrExcelBackFromService:) FileNAme:aFileName];
    }
    self.reporterFileManager.previewDocumentList = [NSMutableArray arrayWithCapacity:1];
    [self.reporterFileManager.previewDocumentList addObject:[NSString stringWithFormat:@"%@", aFileName]];
//    self.reporterFileManager.previewPdfDocumentList = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@", aPdfFileName]];
    
    
}

#pragma mark ReporterFileDelegate
- (void)didFinishLoadingReporterFileDelegate {
    [self.HUD hide:YES];
    if (self.reporterFileManager.isFileNotSuccessfullyDownloaded) return;
//    self.endCalculateDate = [NSDate date];
//    NSTimeInterval executeTime = [self.endCalculateDate timeIntervalSinceDate:self.startCalculateDate];
//    NSLog(@"ExcelDocument calculate: %f",executeTime);
    /*
    if (self.reporterExcelQLPreviewController != nil) { self.reporterExcelQLPreviewController = nil; }    
    self.reporterExcelQLPreviewController = [[[ReporterExcelQLPreviewController alloc] init] autorelease];
    [self.reporterExcelQLPreviewController setDataSource:self];
    [self.reporterExcelQLPreviewController setDelegate:self];
    self.reporterExcelQLPreviewController.arcosPreviewDelegate = self;
    [self.reporterExcelQLPreviewController setCurrentPreviewItemIndex:0];
    
    self.reporterExcelQLPreviewController.reporterFileManager = self.reporterFileManager;
    
    [self.navigationController pushViewController:self.reporterExcelQLPreviewController animated:YES];
    */
    NSLog(@"using download pattern");
    [self drillDownToExcelView];
}

- (void)didFailWithErrorReporterFileDelegate:(NSError *)anError {
    [self.HUD hide:YES];
//    [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
    [ArcosUtils showDialogBox:[anError localizedDescription] title:@"" target:self handler:nil];
}

#pragma mark Preview Controller
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller 
{
	return [self.reporterFileManager.previewDocumentList count];
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index 
{   
    NSString* tmpFileName = [self.reporterFileManager.previewDocumentList objectAtIndex:index];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon pathWithFolder:self.reporterFileManager.reporterFolderName], tmpFileName];
    ArcosQLPreviewItem* arcosQLPreviewItem = [[[ArcosQLPreviewItem alloc] init] autorelease];
    arcosQLPreviewItem.myItemURL = [NSURL fileURLWithPath:filePath];
    arcosQLPreviewItem.myItemTitle = [NSString stringWithFormat:@"%@", self.reportTitle];
    return arcosQLPreviewItem;
}

#pragma mark ArcosQLPreviewControllerDelegate
- (BOOL)downloadPdfFileDelegate {
    NSString* tmpPdfFilePath = [[FileCommon documentsPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@", self.reporterFileManager.reporterFolderName, self.reporterFileManager.pdfFileName]];
    if ([FileCommon fileExistAtPath:tmpPdfFilePath]) {
        return YES;
    }
    BOOL pdfFlag = NO;
    NSURL* pdfServerFileURL = [NSURL URLWithString:self.reporterFileManager.pdfServerFilePath];
    pdfFlag = [self.reporterFileManager synchronousDownloadFileWithURL:pdfServerFileURL destFolderName:self.reporterFileManager.reporterFolderName fileName:self.reporterFileManager.pdfFileName];
    return pdfFlag;
}


#pragma mark TwoDatePickerWidgetDelegate
- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate indexPath:(NSIndexPath *)anIndexPath {
    [self.reporterMainDataManager dateSelectedFromDate:aStartDate ToDate:anEndDate indexPath:anIndexPath];
    /*
    NSMutableDictionary* dateDict = [self.dateDictDisplayList objectAtIndex:anIndexPath.row];
    [dateDict setObject:aStartDate forKey:@"StartDate"];
    [dateDict setObject:anEndDate forKey:@"EndDate"];
    */
}
#pragma mark CustomerSelectionListingDelegate
- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict indexPath:(NSIndexPath *)anIndexPath {
    [self.reporterMainDataManager didSelectCustomerSelectionListingRecord:aCustDict indexPath:anIndexPath];
}

- (UIViewController*)retrieveReporterTableViewController {
    return self;
}

- (void)reloadReporterTableView {
    [self.tableView reloadData];
}

- (void)wsrExcelBackFromService:(id)result {
    [self.HUD hide:YES];
    result = [ArcosSystemCodesUtils handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
//    ArcosGetFromResourcesResult* arcosGetFromResourcesResult = (ArcosGetFromResourcesResult*)result;
//    if (arcosGetFromResourcesResult.ErrorModel.Code > 0) {
//        
//    } else {
//        [ArcosUtils showDialogBox:arcosGetFromResourcesResult.ErrorModel.Message title:@"" delegate:nil target:self tag:0 handler:nil];
//    }
    BOOL saveFileFlag = [ArcosSystemCodesUtils convertBase64ToPhysicalFile:result filePath:[NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath],self.reporterFileManager.fileName]];
    if (saveFileFlag) {
        [self drillDownToExcelView];
    } else {
        [ArcosUtils showDialogBox:@"Unable to save the file on the iPad." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
    }
//    BOOL isSuccessful = [ArcosSystemCodesUtils convertBase64ToPhysicalFile:result filePath:[NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath],self.reporterFileManager.fileName]];
//    if (isSuccessful) {
//        [self drillDownToExcelView];
//    }
}

- (void)drillDownToExcelView {
    /*
    if (self.reporterExcelQLPreviewController != nil) { self.reporterExcelQLPreviewController = nil; }
    self.reporterExcelQLPreviewController = [[[ReporterExcelQLPreviewController alloc] init] autorelease];
    [self.reporterExcelQLPreviewController setDataSource:self];
    [self.reporterExcelQLPreviewController setDelegate:self];
    self.reporterExcelQLPreviewController.arcosPreviewDelegate = self;
    [self.reporterExcelQLPreviewController setCurrentPreviewItemIndex:0];
    
    self.reporterExcelQLPreviewController.reporterFileManager = self.reporterFileManager;
    */
    ReportExcelViewController* excelView=[[ReportExcelViewController alloc]initWithNibName:@"ReportExcelViewController" bundle:nil];
    excelView.reporterFileManager = self.reporterFileManager;
    excelView.filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon reporterPath],self.reporterFileManager.fileName];
    [self.navigationController pushViewController:excelView animated:YES];
    [excelView release];
}

@end
