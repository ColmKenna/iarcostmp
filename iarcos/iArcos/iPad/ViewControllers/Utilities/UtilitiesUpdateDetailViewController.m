//
//  UtilitiesUpdateDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 29/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "UtilitiesUpdateDetailViewController.h"
#include <arpa/inet.h>

@interface UtilitiesUpdateDetailViewController(Private)
//-(void)loadAllUpdateSelectors;
-(void)startUIUpdateTimer;
-(void)stopUiUpdateTimer;
-(void)switchAllOFF;
-(BOOL)testTheConnection;
-(BOOL)checkHostAddress;
- (void)checkUploadConnection;
- (void)enableUploadButton:(BOOL)anEnableFlag;
- (void)nomaliseUploadButton;
@end

@implementation UtilitiesUpdateDetailViewController
@synthesize updateStatusCell;
//@synthesize tableCells;
@synthesize updateCenter;
@synthesize downloadTableCell;
@synthesize uploadTableCell;
@synthesize updateStatusTableCell;
//@synthesize reloadHiddenLabel = _reloadHiddenLabel;
//@synthesize statusTitleLabel = _statusTitleLabel;
@synthesize updateButton;
@synthesize currentUpdateButton = _currentUpdateButton;
@synthesize selectors;
//@synthesize indicator;
//@synthesize branchProgressBar;
//@synthesize progressBar;
//@synthesize updateStatus;
@synthesize switches;
@synthesize alert;

//@synthesize downloadTableCells = _downloadTableCells;
@synthesize datePickerPopover = _datePickerPopover;
@synthesize callDatePickerPopover = _callDatePickerPopover;
@synthesize responsePickerPopover = _responsePickerPopover;
@synthesize utilitiesUpdateDetailDataManager = _utilitiesUpdateDetailDataManager;
@synthesize updateCenterTableCellFactory = _updateCenterTableCellFactory;
@synthesize uploadProcessCenter = _uploadProcessCenter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.updateStatusCell = nil;
    self.downloadTableCell = nil;
    self.uploadTableCell = nil;
    self.updateStatusTableCell = nil;
//    self.reloadHiddenLabel = nil;
//    self.statusTitleLabel = nil;
    self.updateButton = nil;
    self.currentUpdateButton = nil;
//    self.tableCells = nil;
    self.switches = nil;
    
    [updateCenter release];
    self.selectors = nil;
//    self.indicator = nil;
//    self.branchProgressBar = nil;
//    self.progressBar = nil;
//    self.updateStatus = nil;
    self.alert = nil;
    
    [connectivityCheck release];
//    if (self.downloadTableCells != nil) { self.downloadTableCells = nil; }
    self.datePickerPopover = nil;
    if (self.callDatePickerPopover != nil) { self.callDatePickerPopover = nil; }
    self.responsePickerPopover = nil;
    if (self.utilitiesUpdateDetailDataManager != nil) { self.utilitiesUpdateDetailDataManager = nil; }
    if (self.updateCenterTableCellFactory != nil) { self.updateCenterTableCellFactory = nil; }
    self.uploadProcessCenter.webServiceProcessor.utilitiesUpdateDetailViewController = nil;
    self.uploadProcessCenter = nil;
    
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
    needVPNCheck=NO;
    
    self.title=[NSString stringWithFormat:@"Update Center V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    self.tableView.allowsSelection=NO;
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.utilitiesUpdateDetailDataManager = [[[UtilitiesUpdateDetailDataManager alloc] init] autorelease];
    self.updateCenterTableCellFactory = [UpdateCenterTableCellFactory factory];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed)];    
    [self.navigationItem setRightBarButtonItem:saveButton];         
    [saveButton release];
    
//    self.tableCells=[NSMutableArray array];
//    self.downloadTableCells = [NSMutableArray array];
    
//    [self.tableCells addObject:updateStatusCell];
    self.downloadTableCell.myDelegate = self;
    self.uploadTableCell.myDelegate = self;
//    [self.downloadTableCells addObject:self.downloadTableCell];
//    [self.downloadTableCells addObject:reloadAllCell];

    
    //update center
    updateCenter=[[UpdateCenter alloc]init];
    updateCenter.delegate=self;
    updateCenter.serviceClass.paginatedRequestObjectProvider.utilitiesUpdateDetailDataManager = self.utilitiesUpdateDetailDataManager;
    
    //update progress
    progressTotalSegements=0;
    progressValue=0.0f;
    
    //init switches 
    self.switches=[NSMutableDictionary dictionary];
    
    //set the notification
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    //init a connectivity check
    connectivityCheck=[[ConnectivityCheck alloc]init];
    //connectivityCheck.delegate=self;
    self.uploadProcessCenter = [[[UploadProcessCenter alloc] init] autorelease];
    self.uploadProcessCenter.myDelegate = self;
    self.uploadProcessCenter.webServiceProcessor.sectionTitle = [NSString stringWithFormat:@"%@", self.utilitiesUpdateDetailDataManager.uploadSectionTitle];
    self.uploadProcessCenter.webServiceProcessor.utilitiesUpdateDetailViewController = self;
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
    updateCenter.serviceClass.service = [ArcosService serviceWithUsername:@"u1103395_Support" andPassword:@"Strata411325"];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.utilitiesUpdateDetailDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        NSString* mySectionTitle = [self.utilitiesUpdateDetailDataManager.sectionTitleList objectAtIndex:section];
        NSMutableArray* tmpDisplayList = [self.utilitiesUpdateDetailDataManager.groupedDataDict objectForKey:mySectionTitle];
        return [tmpDisplayList count] + 1;
    } else{
        return 1;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 44;
    } else {
        return 100;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.utilitiesUpdateDetailDataManager.sectionTitleList objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0 && indexPath.row == [self.utilitiesUpdateDetailDataManager.dataTablesDisplayList count]) {
            return self.downloadTableCell;
        }
        if (indexPath.section == 1 && indexPath.row == [self.utilitiesUpdateDetailDataManager.uploadItemsDisplayList count]) {
            return self.uploadTableCell;
        }
        NSString* mySectionTitle = [self.utilitiesUpdateDetailDataManager.sectionTitleList objectAtIndex:indexPath.section];
        NSMutableArray* tmpDisplayList = [self.utilitiesUpdateDetailDataManager.groupedDataDict objectForKey:mySectionTitle];
        NSMutableDictionary* cellData = [tmpDisplayList objectAtIndex:indexPath.row];
        UtilitiesUpdateCenterDataTableCell* dataTableCell = [self.updateCenterTableCellFactory createUpdateCenterCellWithData:cellData];
        dataTableCell.delegate = self;
        dataTableCell.indexPath = indexPath;
        [dataTableCell configCellWithData:cellData sectionTitle:mySectionTitle];
        return dataTableCell;
    } else {
        return updateStatusCell;
    }
}

#pragma mark DownloadFunctionTableViewCellDelegate
- (void)downloadFunctionButtonPressedDelegate {
    if (!self.uploadTableCell.uploadButton.enabled) return;
    [self disableUpdateButtons:YES];
    [self buildUpdateCenterSelectorList];
    self.currentUpdateButton = self.downloadTableCell.downloadButton;
    
    [self.currentUpdateButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [self checkConnection];
    
    
    if ([updateCenter.selectors count]<=0) {//no selectors do nothing
        return;
    }
}

- (void)uploadFunctionButtonPressedDelegate {
//    [self.uploadProcessCenter.webServiceProcessor uploadPhoto];
    if (!self.downloadTableCell.downloadButton.enabled) return;
    [self enableUploadButton:NO];
    [self buildUploadSelectorList];
    [self.uploadTableCell.uploadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self checkUploadConnection];
}

//-(IBAction)reloadSelectedTables:(id)sender{
//    
//     
//}
//relaod all tables
/*
-(IBAction)reloadAllTables:(id)sender{    
    currentUpdateButton=(UIButton*)sender;
    [self disableUpdateButtons:YES];
    [currentUpdateButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

    
    NSLog(@"reload all tables press!");
    [self loadAllUpdateSelectors];
    
    [self checkConnection];

}
*/

-(void)checkConnection{
    //[connectivityCheck asyncStart];
    if ([connectivityCheck syncStart]) {
        if ([updateCenter.selectors count]>0) {
            [updateCenter startPreformSelectors];
            [self disableUpdateButtons:YES];
        }else{
            if (self.currentUpdateButton!=nil) {
                [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self disableUpdateButtons:NO];
            }
        }
    }else{
        if ([self.alert isVisible]){
            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
        }
        self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                 message:connectivityCheck.errorString  delegate:self cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil]autorelease];
        [self.alert show];
        
        //change the color of button back to normal
        if (self.currentUpdateButton!=nil) {
            [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self disableUpdateButtons:NO];
        }
        //
        [self switchAllOFF];
        
        //remove all selectors
        [updateCenter removeAllSelectors];
        [self disableUpdateButtons:NO];
        
    }
        
}
//connectivity notification back
//-(void)connectivityChanged: (ConnectivityCheck* )check{
//
//	NSParameterAssert([check isKindOfClass: [ConnectivityCheck class]]);
//    NSLog(@"connectivity is changed %@",check.description);
//    
//    if (check!=connectivityCheck) {
//        return;
//    }
//    
//    if (check.serviceCallAvailable) {
//        if ([updateCenter.selectors count]>0) {
//            [updateCenter startPreformSelectors];
//            [self disableUpdateButtons:YES];
//        }else{
//            if (self.currentUpdateButton!=nil) {
//                [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                [self disableUpdateButtons:NO];
//            }
//        }
//    }else{
//        if ([self.alert isVisible]){
//            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
//        }
//        self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
//                                                 message:check.errorString  delegate:self cancelButtonTitle:@"OK"
//                                       otherButtonTitles: nil]autorelease];
//        [self.alert show];
//        
//        //change the color of button back to normal
//        if (self.currentUpdateButton!=nil) {
//            [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            [self disableUpdateButtons:NO];
//        }
//        //
//        [self switchAllOFF];
//        
//        //remove all selectors
//        [updateCenter removeAllSelectors];
//        [self disableUpdateButtons:NO];
//
//    }
//    
//}

#pragma mark update timer
-(void)startUIUpdateTimer{
    //progress timer
    if (uiUpdateTimer==nil) {
        uiUpdateTimer =[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    }else{
        [self stopUiUpdateTimer];
    }
}
-(void)stopUiUpdateTimer{
    if (uiUpdateTimer!=nil) {
        [uiUpdateTimer invalidate];
        //[uiUpdateTimer release];
        uiUpdateTimer=nil;
    }
}
-(void)updateProgressBar{
//    NSLog(@"updating progress bar with value---%f",progressValue);
    //[self.progressBar setProgress:progressValue];
}
#pragma interface
-(void)disableUpdateButtons:(BOOL)needDisable{
    if (needDisable) {
        updateButton.enabled=NO;
//        updateAllButton.enabled=NO;
    }else{
        updateButton.enabled=YES;
//        updateAllButton.enabled=YES;
    }
}
#pragma mark webservice delegate
-(void)RetrievingProcessInitiation {
    [self.updateStatusTableCell.branchProgressBar setProgress:0];
    [self.updateStatusTableCell.progressBar setProgress:0];
}
-(void)StartGettingDataFor:(NSString *)selectorName{
    NSLog(@"start getting data for ---%@",updateCenter.currentSelectorName);
    self.updateStatusTableCell.updateStatus.text = [NSString stringWithFormat:@"Retrieving %@",selectorName];
    self.updateStatusTableCell.indicator.hidden=NO;
    [self.updateStatusTableCell.indicator startAnimating];
    [self.updateStatusTableCell.progressBar setProgress:0];
}
-(void)GotData:(NSUInteger)dataCount{
    NSLog(@"got %u records for ---%@",[ArcosUtils convertNSUIntegerToUnsignedInt:dataCount], updateCenter.currentSelectorName);
//    if (dataCount>=0) {
//        
//    }
    progressTotalSegements=[ArcosUtils convertNSUIntegerToUnsignedInt:dataCount];
    
    [self.updateStatusTableCell.progressBar setProgress:0.3f];
}
-(void)UpdateData:(NSString*)selectorName {
    self.updateStatusTableCell.updateStatus.text = [NSString stringWithFormat:@"Updating %@",selectorName];
}
-(void)CommitData:(NSString*)selectorName {
    self.updateStatusTableCell.updateStatus.text = [NSString stringWithFormat:@"Committing %@",selectorName];
}
-(void)LoadingData:(int)currentDataCount{
    [self.updateStatusTableCell.progressBar setProgress:0.5f];
    
    //updateStatus.text=[NSString stringWithFormat:@"Loading data for %@",updateCenter.currentSelectorName];
    [self.updateStatusTableCell.updateStatus performSelector:@selector(setText:) withObject:[NSString stringWithFormat:@"Loading data for %@",updateCenter.currentSelectorName]];

    
//    if (currentDataCount>=0&&progressTotalSegements>=0) {
        //[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:[NSNumber numberWithFloat: (currentDataCount*1.0f)/progressTotalSegements] waitUntilDone:YES];
        
//        progressValue=(currentDataCount*1.0f)/progressTotalSegements;
//        [self performSelectorOnMainThread:@selector (updateProgressBar) withObject:nil waitUntilDone:YES];
//         NSLog(@"%@ loading in progress ---%f",updateCenter.currentSelectorName,self.progressBar.progress);

//    }
    [self.updateStatusTableCell.indicator stopAnimating];
}
-(void)FinishLoadingDataFor:(NSString*)selectorName overallNumber:(NSUInteger)anOverallNumber {
    NSLog(@"%@ is finished load",updateCenter.currentSelectorName);
//    updateStatus.text=[NSString stringWithFormat:@"Finish getting data for %@",selectorName];
    
    if (updateCenter.selectorsCount != 0) {
        int currentIndex = updateCenter.selectorsCount - [ArcosUtils convertNSUIntegerToUnsignedInt:[updateCenter.selectors count]];
        [self.updateStatusTableCell.branchProgressBar setProgress:currentIndex * 1.0/updateCenter.selectorsCount animated:YES];
    }
    
    NSIndexPath* selectorIndexPath = [self.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:selectorName];
//    NSLog(@"section %d : row %d", [ArcosUtils convertNSIntegerToInt:selectorIndexPath.section], [ArcosUtils convertNSIntegerToInt:selectorIndexPath.row]);
    

    [self.utilitiesUpdateDetailDataManager downloadFinishedWithData:[ArcosUtils convertNSUIntegerToUnsignedInt:anOverallNumber] forSelectorIndexpath:selectorIndexPath];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:selectorIndexPath.section inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObject:rowToReload];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    if ([selectorName isEqualToString:[GlobalSharedClass shared].locationSelectorName]) {
        NSMutableDictionary* auxLocationDataDict = [self.utilitiesUpdateDetailDataManager.dataTablesDisplayList objectAtIndex:selectorIndexPath.section];
        if ([[auxLocationDataDict objectForKey:@"DownloadMode"] intValue] == 0) {
            NSMutableArray* auxSelectorNameList = [NSMutableArray arrayWithObjects:[GlobalSharedClass shared].locationProductMATSelectorName, [GlobalSharedClass shared].orderHeaderSelectorName, [GlobalSharedClass shared].callOrderHeaderSelectorName, nil];
            for (int i = 0; i < [auxSelectorNameList count]; i++) {
                NSString* auxSelectorName = [auxSelectorNameList objectAtIndex:i];
                NSIndexPath* auxSelectorIndexPath = [self.utilitiesUpdateDetailDataManager getIndexPathWithSelectorName:auxSelectorName];
                [self.utilitiesUpdateDetailDataManager addTableRecordQtyWithIndex:auxSelectorIndexPath.section];
                NSIndexPath* auxSelectorRowToReload = [NSIndexPath indexPathForRow:auxSelectorIndexPath.section inSection:0];
                NSArray* auxSelectorRowToReloadList = [NSArray arrayWithObject:auxSelectorRowToReload];
                [self.tableView reloadRowsAtIndexPaths:auxSelectorRowToReloadList withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
    }
    [self.updateStatusTableCell.progressBar setProgress:1];

}
-(void)ErrorOccured:(NSString*)errorDesc{
    NSLog(@"Error for %@ loading--%@",updateCenter.currentSelectorName,errorDesc);
    [self.updateStatusTableCell.indicator stopAnimating];
    self.updateStatusTableCell.updateStatus.text=[NSString stringWithFormat:@"Server Fault"];
    [self disableUpdateButtons:NO];
    [self switchAllOFF];
    
    if (self.currentUpdateButton!=nil) {
        [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    // open an alert 
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                     message:[NSString stringWithFormat: @"Server Fault! %@ Please try again later!",errorDesc] delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert1 show];	
    [alert1 release];
}


-(void)UpdateCompleted{
    [self.updateStatusTableCell.indicator stopAnimating];
    self.updateStatusTableCell.updateStatus.text=[NSString stringWithFormat:@"Download has Completed"];
    [self disableUpdateButtons:NO];
    [self switchAllOFF];
    
    if (self.currentUpdateButton!=nil) {
        [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    // open an alert 
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:@"Download has Completed" delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert1 show];	
    [alert1 release];
    
    

}
-(void)switchAllOFF{
    /*
    for (NSString* key in switches) {
        UISwitch* aSwitch=(UISwitch*)[switches objectForKey:key];
        aSwitch.on=NO;
    }
    if (currentUpdateButton!=nil) {
        [currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [switches removeAllObjects];
    */
}
-(void)TimeOutFor:(NSString *)selectorName{
    self.updateStatusTableCell.updateStatus.text=[NSString stringWithFormat:@"Update time out for %@",selectorName];
    [self.updateStatusTableCell.indicator stopAnimating];
    //updateStatus.text=[NSString stringWithFormat:@"Time out for update!"];
    [self disableUpdateButtons:NO];
    [self switchAllOFF];
    
    if (self.currentUpdateButton!=nil) {
        [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    // open an alert 
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                     message:self.updateStatusTableCell.updateStatus.text delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert1 show];	
    [alert1 release];
}

#pragma mark - UtilitiesOrderDateRangePickerDelegate
-(void)utilitiesDateSelectedForm:(NSDate*)start To:(NSDate*)end {
    updateCenter.orderStartDate = start;
    updateCenter.orderEndDate = end;
    [self.datePickerPopover dismissPopoverAnimated:YES];
    self.datePickerPopover = nil;
}

#pragma mark - UtilitiesCallDateRangePickerDelegate
-(void)utilitiesCallDateSelectedForm:(NSDate*)start To:(NSDate*)end {
    updateCenter.callStartDate = start;
    updateCenter.callEndDate = end;
    [self.callDatePickerPopover dismissPopoverAnimated:YES];
    self.callDatePickerPopover = nil;
}

#pragma mark - TwoDatePickerWidgetDelegate
- (void)dateSelectedFromDate:(NSDate*)aStartDate ToDate:(NSDate*)anEndDate {
    updateCenter.responseStartDate = aStartDate;
    updateCenter.responseEndDate = anEndDate;
    [self.responsePickerPopover dismissPopoverAnimated:YES];
    self.responsePickerPopover = nil;
}

-(void)ProgressViewWithValue:(float)aProgressValue {
    [self.updateStatusTableCell.progressBar setProgress:aProgressValue animated:YES];
}

-(void)ProgressViewWithValueWithoutAnimation:(float)aProgressValue {
    [self.updateStatusTableCell.progressBar setProgress:aProgressValue animated:NO];
}

-(void)ResourceStatusTextWithValue:(NSString*)aValue {
    self.updateStatusTableCell.updateStatus.text = aValue;
}

- (void)GotFailWithErrorResourcesFileDelegate:(NSError *)anError {
    [self.updateStatusTableCell.indicator stopAnimating];
    self.updateStatusTableCell.updateStatus.text = [NSString stringWithFormat:@"%@", [anError localizedDescription]];
    [self disableUpdateButtons:NO];
    
    if (self.currentUpdateButton!=nil) {
        [self.currentUpdateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
}

- (void)GotErrorWithResourcesFile:(NSError *)anError {
    [ArcosUtils showMsg:[anError localizedDescription] delegate:nil];
}

-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {    
    [self.utilitiesUpdateDetailDataManager inputFinishedWithData:data forIndexpath:theIndexpath];
    NSString* tableName = [self.utilitiesUpdateDetailDataManager.tableNameList objectAtIndex:theIndexpath.row];
    NSNumber* downloadMode = [data objectForKey:@"DownloadMode"];
    int downloadModeValue = [downloadMode intValue];
    if ((downloadModeValue == 0 || downloadModeValue == 1) && [tableName isEqualToString:@"Order"]) {
        UITableViewCell* orderTableViewCell = [self.tableView cellForRowAtIndexPath:theIndexpath];
//        if (self.datePickerPopover == nil) {
        UtilitiesOrderDateRangePicker* UODRP = [[UtilitiesOrderDateRangePicker alloc]initWithNibName:@"UtilitiesOrderDateRangePicker" bundle:nil];
        UODRP.delegate = self;
        UODRP.orderStartDate = updateCenter.orderStartDate;
        UODRP.orderEndDate = updateCenter.orderEndDate;
        if (downloadModeValue == 1) {
            NSMutableDictionary* tmpCellData = [self.utilitiesUpdateDetailDataManager cellDataWithIndexPath:theIndexpath];
            NSDate* tmpOrderStartDate = [NSDate date];
            NSDate* tmpOrderEndDate = [NSDate date];
            if ([[tmpCellData objectForKey:@"IsDownloaded"] boolValue]) {
                tmpOrderStartDate = [tmpCellData objectForKey:@"DownloadDate"];
            }
            UODRP.orderStartDate = tmpOrderStartDate;
            UODRP.orderEndDate = tmpOrderEndDate;
        }
        self.datePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:UODRP] autorelease];
        [UODRP release];
        self.datePickerPopover.popoverContentSize = CGSizeMake(328, 500);
        [self.datePickerPopover presentPopoverFromRect:orderTableViewCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        } else {
//            [self.datePickerPopover presentPopoverFromRect:orderTableViewCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        }
    }
    if ((downloadModeValue == 0 || downloadModeValue == 1) && [tableName isEqualToString:@"Call"]) {
        UITableViewCell* callTableViewCell = [self.tableView cellForRowAtIndexPath:theIndexpath];
//        if (self.callDatePickerPopover == nil) {
        UtilitiesCallDateRangePicker* UCDRP = [[UtilitiesCallDateRangePicker alloc]initWithNibName:@"UtilitiesCallDateRangePicker" bundle:nil];
        UCDRP.delegate = self;
        UCDRP.callStartDate = updateCenter.callStartDate;
        UCDRP.callEndDate = updateCenter.callEndDate;
        if (downloadModeValue == 1) {
            NSMutableDictionary* tmpCellData = [self.utilitiesUpdateDetailDataManager cellDataWithIndexPath:theIndexpath];
            NSDate* tmpCallStartDate = [NSDate date];
            NSDate* tmpCallEndDate = [NSDate date];
            if ([[tmpCellData objectForKey:@"IsDownloaded"] boolValue]) {
                tmpCallStartDate = [tmpCellData objectForKey:@"DownloadDate"];
            }
            UCDRP.callStartDate = tmpCallStartDate;
            UCDRP.callEndDate = tmpCallEndDate;
        }
        self.callDatePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:UCDRP] autorelease];
        [UCDRP release];
        self.callDatePickerPopover.popoverContentSize = CGSizeMake(328, 500);
        [self.callDatePickerPopover presentPopoverFromRect:callTableViewCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        } else {
//            [self.callDatePickerPopover presentPopoverFromRect:callTableViewCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        }
    }
    if ((downloadModeValue == 0 || downloadModeValue == 1) && [tableName isEqualToString:@"Response"]) {
        UITableViewCell* responseTableViewCell = [self.tableView cellForRowAtIndexPath:theIndexpath];
        TwoDatePickerWidgetViewController* TDPWVC = [[TwoDatePickerWidgetViewController alloc] initWithNibName:@"TwoDatePickerWidgetViewController" bundle:nil];
        TDPWVC.delegate = self;
        TDPWVC.startDate = updateCenter.responseStartDate;
        TDPWVC.endDate = updateCenter.responseEndDate;
        self.responsePickerPopover = [[[UIPopoverController alloc]initWithContentViewController:TDPWVC] autorelease];
        [TDPWVC release];
        self.responsePickerPopover.popoverContentSize = CGSizeMake(328, 500);
        [self.responsePickerPopover presentPopoverFromRect:responseTableViewCell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)buildUpdateCenterSelectorList {
    //name should be synced with the name set in the dataTableNameRelatedEntityDict
    [updateCenter.selectors removeAllObjects];
    NSMutableArray* rowsToReload = [NSMutableArray array];    
    for (int i = 0; i < [self.utilitiesUpdateDetailDataManager.dataTablesDisplayList count]; i++) {
        NSMutableDictionary* dataDict = [self.utilitiesUpdateDetailDataManager.dataTablesDisplayList objectAtIndex:i];
//        [dataDict setObject:nil forKey:@"DownloadRecordQty"];
        [dataDict removeObjectForKey:@"DownloadRecordQty"];
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:i inSection:0];
        [rowsToReload addObject:rowToReload];
        NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
        int downloadModeValue = [downloadMode intValue]; 
        NSNumber* tableIUR = [dataDict objectForKey:@"IUR"];
        switch ([tableIUR intValue]) {
            case 100:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadLocationsToDB) withName:[GlobalSharedClass shared].locationSelectorName];
                    [updateCenter pushSelector: @selector(loadLocLocLinkToDB) withName:[GlobalSharedClass shared].locLocLinkSelectorName];
                }
                break;
            case 105:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector:@selector(loadLocationProductMATToDB) withName:[GlobalSharedClass shared].locationProductMATSelectorName];
                }
                break;
            case 110:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadProductsToDB) withName:[GlobalSharedClass shared].productSelectorName];
                }
                break;
            case 115:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadPriceToDB) withName:[GlobalSharedClass shared].priceSelectorName];
                }
                break;
            case 120:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadDescrDetailsToDB) withName:[GlobalSharedClass shared].descrDetailSelectorName];
                    [updateCenter pushSelector: @selector(loadDescriptionTypeToDB) withName:[GlobalSharedClass shared].descrTypeSelectorName];
                }
                break;
            case 125:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadResourcesToFolder) withName:[GlobalSharedClass shared].resourcesSelectorName];                    
                }
                break;
            case 130:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadPresenterToDB) withName:[GlobalSharedClass shared].presenterSelectorName];
                }
                break;
            case 140:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector:@selector(loadImageToDB) withName:[GlobalSharedClass shared].imageSelectorName];
                }
                break;    
            case 150:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadContactToDB) withName:[GlobalSharedClass shared].contactSelectorName];
                    [updateCenter pushSelector: @selector(loadConLocLinkToDB) withName:[GlobalSharedClass shared].conLocLinkSelectorName];
                }
                break;
            case 160:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadFormDetailsToDB) withName:[GlobalSharedClass shared].formDetailSelectorName];
                    [updateCenter pushSelector: @selector(loadFormRowsToDB) withName:[GlobalSharedClass shared].formRowSelectorName];
                }
                break;
            case 170:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadEmployeeToDB) withName:[GlobalSharedClass shared].employeeSelectorName];                    
                }
                break;
            case 180:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadConfigToDB) withName:[GlobalSharedClass shared].configSelectorName];                    
                }
                break;
            case 190:
                if (downloadModeValue == 0 || downloadModeValue == 1) {                    
                    [updateCenter pushSelector: @selector(loadOrderToDB:endDate:) withName:[GlobalSharedClass shared].orderHeaderSelectorName];                
                }
                break;
            case 195:
                if (downloadModeValue == 0 || downloadModeValue == 1) {                    
                    [updateCenter pushSelector: @selector(loadCallToDB:endDate:) withName:[GlobalSharedClass shared].callOrderHeaderSelectorName];                
                }
                break;    
            case 200:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadSurveyToDB) withName:[GlobalSharedClass shared].surveySelectorName];                    
                }
                break;
            case 205:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadResponseToDB:endDate:) withName:[GlobalSharedClass shared].responseSelectorName];
                }
                break;
            case 210:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [updateCenter pushSelector: @selector(loadJourneyToDB) withName:[GlobalSharedClass shared].journeySelectorName];
                }
                break;            
            default:
                break;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (void)savePressed {
    [self.utilitiesUpdateDetailDataManager savePressed];
    [ArcosUtils showMsg:@"Download modes are saved." delegate:nil];
}

- (void)buildUploadSelectorList {
    //name should be synced with the name set in the dataTableNameRelatedEntityDict
    [self.uploadProcessCenter.selectorList removeAllObjects];
    NSMutableArray* rowsToReload = [NSMutableArray array];
    for (int i = 0; i < [self.utilitiesUpdateDetailDataManager.uploadItemsDisplayList count]; i++) {
        NSMutableDictionary* dataDict = [self.utilitiesUpdateDetailDataManager.uploadItemsDisplayList objectAtIndex:i];
        [dataDict removeObjectForKey:@"DownloadRecordQty"];
        int mySectionIndex = [self.utilitiesUpdateDetailDataManager retrieveSectionIndexWithSectionTitle:self.utilitiesUpdateDetailDataManager.uploadSectionTitle];
        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:i inSection:mySectionIndex];
        [rowsToReload addObject:rowToReload];
        NSNumber* downloadMode = [dataDict objectForKey:@"DownloadMode"];
        int downloadModeValue = [downloadMode intValue];
        NSNumber* tableIUR = [dataDict objectForKey:@"IUR"];
        switch ([tableIUR intValue]) {
            case 500:
                if (downloadModeValue == 0 || downloadModeValue == 1) {
                    [self.uploadProcessCenter pushSelector:@selector(uploadPhoto) name:[GlobalSharedClass shared].collectedSelectorName];
                }
                break;
            default:
                break;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}

- (void)checkUploadConnection {
    if ([connectivityCheck syncStart]) {
        if ([self.uploadProcessCenter.selectorList count] > 0) {
            [self.uploadProcessCenter startPerformSelectorList];
            [self enableUploadButton:NO];
        } else {
            [self nomaliseUploadButton];
        }
    } else {
        [ArcosUtils showDialogBox:connectivityCheck.errorString title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self nomaliseUploadButton];
        [self.uploadProcessCenter stopTask];
    }
}

- (void)enableUploadButton:(BOOL)anEnableFlag {
    self.uploadTableCell.uploadButton.enabled = anEnableFlag;
}

- (void)nomaliseUploadButton {
    [self.uploadTableCell.uploadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self enableUploadButton:YES];
}

#pragma mark UploadWebServiceProcessorDelegate
- (void)uploadBranchProcessInitiation {
    self.updateStatusTableCell.indicator.hidden = NO;
    [self.updateStatusTableCell.indicator startAnimating];
    self.updateStatusTableCell.updateStatus.text = @"";
    [self.updateStatusTableCell.branchProgressBar setProgress:0];
    [self.updateStatusTableCell.progressBar setProgress:0];
}
- (void)uploadBranchProcessCompleted {
    [self.updateStatusTableCell.indicator stopAnimating];
    self.updateStatusTableCell.updateStatus.text=[NSString stringWithFormat:@"Upload has Completed"];
    [ArcosUtils showDialogBox:@"Upload has Completed" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        
    }];
    [self.uploadTableCell.uploadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self nomaliseUploadButton];
}
- (void)uploadProcessStarted {
    [self.updateStatusTableCell.progressBar setProgress:0];
}
- (void)uploadProcessWithText:(NSString *)aText {
    self.updateStatusTableCell.updateStatus.text = aText;
}
- (void)uploadProgressViewWithValue:(float)aProgressValue {
    [self.updateStatusTableCell.progressBar setProgress:aProgressValue animated:YES];
}
- (void)uploadProcessFinished:(NSString *)aSelectorName sectionTitle:(NSString *)aSectionTitle overallNumber:(int)anOverallNumber {
    if (self.uploadProcessCenter.selectorListCount != 0) {
        int currentIndex = self.uploadProcessCenter.selectorListCount - [ArcosUtils convertNSUIntegerToUnsignedInt:[self.uploadProcessCenter.selectorList count]];
        [self.updateStatusTableCell.branchProgressBar setProgress:currentIndex * 1.0 / self.uploadProcessCenter.selectorListCount animated:YES];
    }
    
    CompositeIndexResult* tmpCompositeIndexResult = [self.utilitiesUpdateDetailDataManager retrieveCompositeIndexResultWithSelectorName:aSelectorName sectionTitle:aSectionTitle];
    
    int tmpSectionIndex = [self.utilitiesUpdateDetailDataManager retrieveSectionIndexWithSectionTitle:aSectionTitle];
    [self.utilitiesUpdateDetailDataManager processFinishedWithOverallNumber:anOverallNumber compositeIndexResult:tmpCompositeIndexResult];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:tmpCompositeIndexResult.indexPath.section inSection:tmpSectionIndex];
    NSArray* rowsToReload = [NSArray arrayWithObject:rowToReload];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [self.updateStatusTableCell.progressBar setProgress:1];
}
- (void)uploadProcessWithErrorMsg:(NSString *)anErrorMsg {
    [self.updateStatusTableCell.indicator stopAnimating];
    self.updateStatusTableCell.updateStatus.text = [NSString stringWithFormat:@"Server Fault"];
    [self nomaliseUploadButton];
    
    [ArcosUtils showDialogBox:anErrorMsg title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        
    }];
}


@end
