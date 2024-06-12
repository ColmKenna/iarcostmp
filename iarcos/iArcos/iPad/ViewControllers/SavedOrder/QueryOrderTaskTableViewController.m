//
//  QueryOrderTaskTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 21/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskTableViewController.h"
#import "ArcosXMLParser.h"

@interface QueryOrderTaskTableViewController ()
-(void)getTaskData;
- (void)createMemoWhenIssueClosedChanged;
- (void)alertViewCallBack;
@end

@implementation QueryOrderTaskTableViewController
@synthesize myDelegate = _myDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize editDelegate = _editDelegate;
@synthesize actionType = _actionType;
@synthesize IUR = _IUR;
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize queryOrderTaskDataManager = _queryOrderTaskDataManager;
@synthesize cellFactory = _cellFactory;
@synthesize employeeSecurityLevel = _employeeSecurityLevel;
@synthesize employeeName = _employeeName;
@synthesize locationIUR = _locationIUR;
@synthesize contactIUR = _contactIUR;
@synthesize processingIndexPath = _processingIndexPath;
@synthesize queryOrderTaskControlMemoTableCell = _queryOrderTaskControlMemoTableCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.allowsSelection = NO;
    UIBarButtonItem* tmpBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:tmpBackButton];
    [tmpBackButton release];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.employeeSecurityLevel = [self getEmployeeSecurityLevel];
    self.queryOrderTaskDataManager = [[[QueryOrderTaskDataManager alloc] init] autorelease];
    self.queryOrderTaskDataManager.contactIUR = self.contactIUR;
    if (![self.actionType isEqualToString:@"create"]) {
        [self.queryOrderTaskDataManager.ruleoutFieldNameDict setObject:@"FirstTimeToFix" forKey:@"FirstTimeToFix"];
    }
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
    self.cellFactory = [QueryOrderTaskTableCellFactory factory];
}

- (void)dealloc {
    self.actionType = nil;
    self.IUR = nil;
    self.callGenericServices = nil;
    self.queryOrderTaskDataManager = nil;
    self.cellFactory = nil;
    self.employeeName = nil;
    self.locationIUR = nil;
    self.contactIUR = nil;
    self.processingIndexPath = nil;
    self.queryOrderTaskControlMemoTableCell = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.employeeSecurityLevel = [self getEmployeeSecurityLevel];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [self getTaskData];
}

-(void)getTaskData {
    [self.callGenericServices getRecord:@"Task" iur:[self.IUR intValue] filter:@""];
}

- (void)cancelPressed:(id)sender {
    [self.myDelegate didDismissCustomisePresentView];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* fieldType = [self.queryOrderTaskDataManager.activeSeqFieldTypeList objectAtIndex:indexPath.section];
    if ([fieldType isEqualToString:@"System.String"]) {
        return 212;
    }
    if ([fieldType isEqualToString:@"Memos"] && indexPath.row != 0) {
        return [[self.queryOrderTaskDataManager.heightList objectAtIndex:indexPath.row - 1] floatValue] + 38.0;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.queryOrderTaskDataManager.constantFieldTypeTranslateDict objectForKey:[self.queryOrderTaskDataManager.activeSeqFieldTypeList objectAtIndex:section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.queryOrderTaskDataManager.activeSeqFieldTypeList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* fieldType = [self.queryOrderTaskDataManager.activeSeqFieldTypeList objectAtIndex:section];
    if ([fieldType isEqualToString:@"Memos"]) {
        if (self.queryOrderTaskDataManager.isMemoDetailShowed) {
            return 1 + [self.queryOrderTaskDataManager.memoDisplayList count];
        }
        return 1;
    }
    NSMutableArray* tmpDataArray = [self.queryOrderTaskDataManager.groupedDataDict objectForKey:fieldType];
    return [tmpDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* fieldType = [self.queryOrderTaskDataManager.activeSeqFieldTypeList objectAtIndex:indexPath.section];
    if ([fieldType isEqualToString:@"Memos"]) {
        if (indexPath.row == 0) {
            if (!self.queryOrderTaskDataManager.isMemoDetailShowed) {
                self.queryOrderTaskControlMemoTableCell.myControlLabel.text = @"Memos";
            } else {
                self.queryOrderTaskControlMemoTableCell.myControlLabel.text = @"Hide";
            }
            self.queryOrderTaskControlMemoTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.queryOrderTaskControlMemoTableCell;
        }
        if (indexPath.row > 0) {
            return [self getMemoCell:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    NSMutableDictionary* cellData = [self.queryOrderTaskDataManager cellDataWithIndexPath:indexPath];
    QueryOrderTMBaseTableCell* cell = (QueryOrderTMBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (QueryOrderTMBaseTableCell*)[self.cellFactory createCustomerBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.employeeSecurityLevel = self.employeeSecurityLevel;
    cell.indexPath = indexPath;
    cell.locationIUR = self.locationIUR;
    [cell configCellWithData:cellData];
    
    return cell;
}

- (UITableViewCell*)getMemoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"IdQueryOrderDetailTableCell";
    
    QueryOrderDetailTableCell *cell=(QueryOrderDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"QueryOrderDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[QueryOrderDetailTableCell class]] && [[(QueryOrderDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (QueryOrderDetailTableCell *) nibItem;
//                cell.delegate = self;
            }
        }
    }
    
    // Configure the cell...
    cell.separatorInset = UIEdgeInsetsMake(0, tableView.frame.size.width, 0, 0);
    NSUInteger memoIndex = indexPath.row - 1;
    [cell configCellWithData:[self.queryOrderTaskDataManager.heightList objectAtIndex:memoIndex]];
    cell.indexPath = indexPath;
    ArcosGenericClass* cellData = [self.queryOrderTaskDataManager.memoDisplayList objectAtIndex:memoIndex];
    
    @try {
        NSDate* startDate = [ArcosUtils dateFromString:[cellData Field1] format:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSMutableAttributedString* attributedDateString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils stringFromDate:startDate format:@"EEE dd MMMM "] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]}];
        NSAttributedString* attributedTimeString = [[NSAttributedString alloc] initWithString:[ArcosUtils stringFromDate:startDate format:@"HH:mm"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
        [attributedDateString appendAttributedString:attributedTimeString];
        cell.dateLabel.attributedText = attributedDateString;
        [attributedTimeString release];
        [attributedDateString release];
    }
    @catch (NSException *exception) {}
    cell.employeeLabel.text = [cellData Field3];
    cell.contactLabel.text = [cellData Field6];
    cell.detailsTextView.text = [NSString stringWithFormat:@"\n\n%@",[cellData Field2]];
    
    return cell;
}


#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        [self.queryOrderTaskDataManager processRawData:result actionType:self.actionType];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}

#pragma mark - check employee SecurityLevel
-(int)getEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    self.employeeName = [NSString stringWithFormat:@"%@ %@", [employeeDict objectForKey:@"ForeName"], [employeeDict objectForKey:@"Surname"]];
    return [securityLevel intValue];
}

#pragma mark CustomerTypeTableCellDelegate

-(void)inputFinishedWithData:(id)contentString actualData:(id)actualData forIndexpath:(NSIndexPath *)theIndexpath {
    [self.queryOrderTaskDataManager updateChangedData:contentString actualContent:actualData withIndexPath:theIndexpath];
}

-(NSString*)getFieldNameWithIndexPath:(NSIndexPath*)theIndexpath {
    return [self.queryOrderTaskDataManager getFieldNameWithIndexPath:theIndexpath];
}

- (UIViewController*)retrieveCustomerTypeParentViewController {
    return self;
}

-(void)savePressed:(id)sender {
    [self.view endEditing:YES];
    if (![self.queryOrderTaskDataManager checkAllowedStringField:@"Details" cellDictList:[self.queryOrderTaskDataManager.groupedDataDict objectForKey:@"System.String"]]) {
        [ArcosUtils showDialogBox:@"Please enter details" title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    [self.queryOrderTaskDataManager getChangedDataList];
    if ([self.queryOrderTaskDataManager.changedDataList count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if ([self.actionType isEqualToString:@"create"]) {//create location
        [self.queryOrderTaskDataManager prepareToCreateRecord];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"LocationIUR"];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[self.locationIUR stringValue]];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"EmployeeIUR"];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[[SettingManager employeeIUR] stringValue]];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"StartDate"];
        [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy:HH:mm"]];
        
        [self.callGenericServices createRecord:@"Task" fields:self.queryOrderTaskDataManager.arcosCreateRecordObject];
    } else {
        self.callGenericServices.isNotRecursion = NO;
        self.queryOrderTaskDataManager.isIssueClosedChanged = NO;
        [self submitChangedDataList];
    }
}

-(void)submitChangedDataList {
    if (self.queryOrderTaskDataManager.rowPointer == [self.queryOrderTaskDataManager.changedDataList count]) return;
    NSMutableDictionary* dataCell = [self.queryOrderTaskDataManager.changedDataList objectAtIndex:self.queryOrderTaskDataManager.rowPointer];
    self.queryOrderTaskDataManager.changedFieldName = [self.queryOrderTaskDataManager fieldNameWithIndex:[[dataCell objectForKey:@"originalIndex"] intValue] - 1];
    self.queryOrderTaskDataManager.changedActualContent = [dataCell objectForKey:@"actualContent"];
    if ([self.queryOrderTaskDataManager.changedFieldName isEqualToString:self.queryOrderTaskDataManager.issueClosedField]) {
        self.queryOrderTaskDataManager.isIssueClosedChanged = YES;
        self.queryOrderTaskDataManager.changedFieldName = @"CompletionDate";
        if ([self.queryOrderTaskDataManager.changedActualContent isEqualToString:@"1"]) {
            self.queryOrderTaskDataManager.issueClosedActualValue = YES;
            self.queryOrderTaskDataManager.changedActualContent = [ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy HH:mm"];
            self.queryOrderTaskDataManager.createMemoDetails = [NSString stringWithFormat:@"Closed by %@ on %@", self.employeeName, [ArcosUtils stringFromDate:[NSDate date] format:@"dd MMMM yyyy"]];
        } else {
            self.queryOrderTaskDataManager.issueClosedActualValue = NO;
            self.queryOrderTaskDataManager.changedActualContent = @"01/01/1990";
            self.queryOrderTaskDataManager.createMemoDetails = [NSString stringWithFormat:@"Reopen by %@ on %@", self.employeeName, [ArcosUtils stringFromDate:[NSDate date] format:@"dd MMMM yyyy"]];
        }
    }
    [self.callGenericServices updateRecord:@"Task" iur:[self.IUR intValue] fieldName:self.queryOrderTaskDataManager.changedFieldName newContent:self.queryOrderTaskDataManager.changedActualContent];
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        return;
    }
//    NSLog(@"%@ and %@", result.Field1, result);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        NSString* issuesTextResult = [GlobalSharedClass shared].issuesText;
        NSString* definedIssuesText = [ArcosUtils retrieveDefinedIssuesText];
        if (![definedIssuesText isEqualToString:@""]) {
            issuesTextResult = definedIssuesText;
        }
        [ArcosUtils showDialogBox:[NSString stringWithFormat:@"New %@ has been created.", issuesTextResult] title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            [ArcosUtils showDialogBox:[errorArcosGenericClass Field2] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        } else {
            [ArcosUtils showDialogBox:@"The operation could not be completed." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
//    NSLog(@"set result happens in customer details");
    if (result == nil) {
        //        [activityIndicator stopAnimating];
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.editDelegate editFinishedWithData:self.queryOrderTaskDataManager.changedActualContent fieldName:self.queryOrderTaskDataManager.changedFieldName forIndexpath:self.processingIndexPath];
        self.queryOrderTaskDataManager.rowPointer++;
        if (self.queryOrderTaskDataManager.rowPointer == [self.queryOrderTaskDataManager.changedDataList count]) {
            if (self.queryOrderTaskDataManager.isIssueClosedChanged) {
                [self createMemoWhenIssueClosedChanged];
            } else {
                self.callGenericServices.isNotRecursion = YES;
                [self.callGenericServices.HUD hide:YES];
                [self endOnSaveAction];
            }
        }
        [self submitChangedDataList];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)createMemoWhenIssueClosedChanged {
    self.queryOrderTaskDataManager.arcosCreateRecordObject = [[[ArcosCreateRecordObject alloc] init] autorelease];
    self.queryOrderTaskDataManager.createdFieldNameList = [NSMutableArray array];
    self.queryOrderTaskDataManager.createdFieldValueList = [NSMutableArray array];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"Details"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:self.queryOrderTaskDataManager.createMemoDetails];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"ContactIUR"];
    NSString* actualContactIUR = [self.queryOrderTaskDataManager getActualValueWithFieldName:@"ContactIUR" cellDictList:[self.queryOrderTaskDataManager.groupedDataDict objectForKey:@"IUR"]];
    if ([actualContactIUR isEqualToString:@""]) {
        actualContactIUR = @"0";
    }
//    NSLog(@"actualContactIUR: %@ %@", actualContactIUR, self.contactIUR);
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:actualContactIUR];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"LocationIUR"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[self.locationIUR stringValue]];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"TableIUR"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[self.IUR stringValue]];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"TableName"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:@"Task"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"EmployeeIUR"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[[SettingManager employeeIUR] stringValue]];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"FullFilled"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[[NSNumber numberWithBool:NO] stringValue]];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldNames addObject:@"DateEntered"];
    [self.queryOrderTaskDataManager.arcosCreateRecordObject.FieldValues addObject:[ArcosUtils stringFromDate:[NSDate date] format:@"dd/MM/yyyy:HH:mm"]];
    
    [self.callGenericServices genericCreateRecord:@"Memo" fields:self.queryOrderTaskDataManager.arcosCreateRecordObject action:@selector(setGenericCreateRecordResult:) target:self];
}

-(void)setGenericCreateRecordResult:(ArcosGenericClass*) result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    //    NSLog(@"%@ and %@", result.Field1, result);
    if (result.Field1 != nil && ![result.Field1 isEqualToString:@""]
        && ![result.Field1 isEqualToString:@"0"]) {
        self.callGenericServices.isNotRecursion = YES;
        [self.callGenericServices.HUD hide:YES];
        [self endOnSaveAction];
    } else {
        NSMutableArray* subObjects = result.SubObjects;
        if (subObjects != nil && [subObjects count] > 0) {
            ArcosGenericClass* errorArcosGenericClass = [subObjects objectAtIndex:0];
            [ArcosUtils showDialogBox:[errorArcosGenericClass Field2] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        } else {
            [ArcosUtils showDialogBox:@"The operation could not be completed." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
        }
    }
}

#pragma mark UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if(buttonIndex == 0){
//        //Code that will run after you press ok button
//        [self alertViewCallBack];
//    }
//}

-(void)endOnSaveAction {
    if ([self.actionType isEqualToString:@"create"]) {
        [self.refreshDelegate refreshParentContent];
    } else {
        [self.refreshDelegate refreshParentContentByEditType:self.queryOrderTaskDataManager.isIssueClosedChanged closeActualValue:self.queryOrderTaskDataManager.issueClosedActualValue  indexPath:self.processingIndexPath];
        [self.refreshDelegate refreshParentContentByEdit];
    }
    [self cancelPressed:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* fieldType = [self.queryOrderTaskDataManager.activeSeqFieldTypeList objectAtIndex:indexPath.section];
    if ([fieldType isEqualToString:@"Memos"] && indexPath.row == 0 && self.queryOrderTaskDataManager.memoDisplayList == nil) {
        [self getMemoListData];
    }
    if ([fieldType isEqualToString:@"Memos"] && indexPath.row == 0 && self.queryOrderTaskDataManager.memoDisplayList != nil) {
        self.queryOrderTaskDataManager.isMemoDetailShowed = !self.queryOrderTaskDataManager.isMemoDetailShowed;
        [self.tableView reloadData];
    }

}

- (void)getMemoListData {
    NSString* sqlString = [NSString stringWithFormat:@"select convert(varchar(19),DateEntered,126) as MyDateEntered,Details,Employee,TableIUR,IUR,Contact,EmployeeIUR from ipadmemoview where TableIUR = %d order by DateEntered asc", [self.IUR intValue]];
    [self.callGenericServices genericGetData:sqlString action:@selector(setGenericMemoGetDataResult:) target:self];
}

-(void)setGenericMemoGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        self.queryOrderTaskDataManager.isMemoDetailShowed = YES;
        self.queryOrderTaskDataManager.memoDisplayList = result.ArrayOfData;
        [self processHeightList];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        self.queryOrderTaskDataManager.memoDisplayList = [NSMutableArray array];
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}

- (void)processHeightList {
    float textViewContentWidth = self.tableView.frame.size.width - 50;
    self.queryOrderTaskDataManager.heightList = [NSMutableArray arrayWithCapacity:[self.queryOrderTaskDataManager.memoDisplayList count]];
    for (int i = 0; i < [self.queryOrderTaskDataManager.memoDisplayList count]; i++) {
        ArcosGenericClass* cellData = [self.queryOrderTaskDataManager.memoDisplayList objectAtIndex:i];
        NSString* tmpText = [NSString stringWithFormat:@"\n\n%@", [cellData Field2]];
        NSAttributedString* dynamicString = [[NSAttributedString alloc] initWithString:tmpText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        CGRect rect = [dynamicString boundingRectWithSize:CGSizeMake(textViewContentWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [dynamicString release];
        [self.queryOrderTaskDataManager.heightList addObject:[NSNumber numberWithFloat:rect.size.height + 16.0]];
    }
    
}

- (void)alertViewCallBack {
    [self.refreshDelegate refreshParentContent];
    [self cancelPressed:nil];
}

@end
