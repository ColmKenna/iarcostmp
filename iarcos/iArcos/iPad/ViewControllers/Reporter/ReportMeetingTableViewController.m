//
//  ReportMeetingTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 18/05/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "ReportMeetingTableViewController.h"

@interface ReportMeetingTableViewController ()

- (void)submitChangedDataList;
- (void)endOnSaveAction;

@end

@implementation ReportMeetingTableViewController
@synthesize myDelegate = _myDelegate;
@synthesize iUR = _iUR;
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize reportMeetingDataManager = _reportMeetingDataManager;
@synthesize cellFactory = _cellFactory;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithTitle:[GlobalSharedClass shared].cancelButtonText style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
    self.reportMeetingDataManager = [[[ReportMeetingDataManager alloc] init] autorelease];
    self.cellFactory = [GetRecordGenericTableCellFactory factory];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.iUR = nil;
    self.callGenericServices = nil;
    self.reportMeetingDataManager = nil;
    
    [super dealloc];
}

- (void)closePressed:(id)sender {
    [self.myDelegate didDismissCustomisePresentView];
}

- (void)saveButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self.reportMeetingDataManager retrieveChangedDataList];
    if ([self.reportMeetingDataManager.changedDataList count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    self.callGenericServices.isNotRecursion = NO;
    self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer = 0;
    [self submitChangedDataList];
}

- (void)submitChangedDataList {
    NSLog(@"a pointer: %d", self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer);
    if (self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer == [self.reportMeetingDataManager.changedDataList count]) return;
    NSMutableDictionary* dataDict = [self.reportMeetingDataManager.changedDataList objectAtIndex:self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer];
    NSString* auxChangedFieldName = [dataDict objectForKey:@"fieldName"];
    GetRecordTypeGenericBaseObject* auxGetRecordTypeGenericBaseObject = [dataDict objectForKey:@"actualContent"];
    NSString* auxChangedActualContent = [auxGetRecordTypeGenericBaseObject retrieveStringValue];
    [self.callGenericServices updateRecord:@"Meeting" iur:[self.iUR intValue] fieldName:auxChangedFieldName newContent:auxChangedActualContent];
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*)result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer++;
        if (self.reportMeetingDataManager.getRecordGenericDataManager.rowPointer == [self.reportMeetingDataManager.changedDataList count]) {
            [self.callGenericServices.HUD hide:YES];
            [self endOnSaveAction];
            return;
        }
        [self submitChangedDataList];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)endOnSaveAction {
    [self closePressed:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.reportMeetingDataManager.employeeSecurityLevel = [self.reportMeetingDataManager.getRecordGenericDataManager retrieveEmployeeSecurityLevel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [self.callGenericServices getRecord:@"Meeting" iur:[self.iUR intValue] filter:@""];
}

- (void)setGetRecordResult:(ArcosGenericReturnObject*)result {
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.reportMeetingDataManager.getRecordGenericReturnObject = [self.reportMeetingDataManager.getRecordGenericDataManager processRawData:result];
        
        [self.reportMeetingDataManager retrieveOrderedFieldTypeList:self.reportMeetingDataManager.getRecordGenericReturnObject.seqFieldTypeList];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.reportMeetingDataManager.orderedFieldTypeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* fieldType = [self.reportMeetingDataManager.orderedFieldTypeList objectAtIndex:section];
    NSMutableArray* tmpDataArray = [self.reportMeetingDataManager.getRecordGenericReturnObject.groupedDataDict objectForKey:fieldType];
    return [tmpDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.reportMeetingDataManager cellDataWithIndexPath:indexPath];
    GetRecordGenericBaseTableViewCell* cell = (GetRecordGenericBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (GetRecordGenericBaseTableViewCell*)[self.cellFactory createGetRecordGenericBaseTableViewCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.employeeSecurityLevel = self.reportMeetingDataManager.employeeSecurityLevel;
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark GetRecordGenericTypeTableCellDelegate
- (void)inputFinishedWithData:(id)aContentString actualData:(id)anActualData indexPath:(NSIndexPath*)anIndexPath {
    [self.reportMeetingDataManager inputFinishedWithData:aContentString actualData:anActualData indexPath:anIndexPath];
}
- (UIViewController*)retrieveGetRecordGenericTypeParentViewController {
    return self;
}

@end
