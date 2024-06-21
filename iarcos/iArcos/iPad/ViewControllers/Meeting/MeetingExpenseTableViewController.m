//
//  MeetingExpenseTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 23/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingExpenseTableViewController.h"

@interface MeetingExpenseTableViewController ()

@end

@implementation MeetingExpenseTableViewController
@synthesize accessDelegate = _accessDelegate;
@synthesize displayList = _displayList;
@synthesize deleteDisplayList = _deleteDisplayList;
@synthesize meetingExpenseDetailsDataManager = _meetingExpenseDetailsDataManager;
@synthesize currentSelectDeleteIndexPath = _currentSelectDeleteIndexPath;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.deleteDisplayList = [NSMutableArray array];
        self.meetingExpenseDetailsDataManager = [[[MeetingExpenseDetailsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
    self.deleteDisplayList = nil;
    self.meetingExpenseDetailsDataManager = nil;
    self.currentSelectDeleteIndexPath = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* resultView = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingExpenseTableViewCells" owner:self options:nil];
    
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[UIView class]] && [(UIView*)nibItem tag] == 100) {
            resultView = (UIView*)nibItem;
            break;
        }
    }
    return resultView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* meetingExpenseCellIdentifier = @"IdMeetingExpenseTableViewCell";
    
    MeetingExpenseTableViewCell* cell = (MeetingExpenseTableViewCell*) [tableView dequeueReusableCellWithIdentifier:meetingExpenseCellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"MeetingExpenseTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[MeetingExpenseTableViewCell class]] && [[(MeetingExpenseTableViewCell *)nibItem reuseIdentifier] isEqualToString:meetingExpenseCellIdentifier]) {
                cell = (MeetingExpenseTableViewCell *) nibItem;
                break;
            }
        }
    }
    
    // Configure the cell...
    ArcosExpenses* tmpArcosExpenses = [self.displayList objectAtIndex:indexPath.row];
    cell.dateLabel.text = [ArcosUtils stringFromDate:tmpArcosExpenses.ExpDate format:[GlobalSharedClass shared].dateFormat];
    NSDictionary* exTypeDataDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:[NSNumber numberWithInt:tmpArcosExpenses.EXiur]];
    cell.detailsLabel.text = [ArcosUtils convertNilToEmpty:[exTypeDataDict objectForKey:@"Detail"]];
    cell.commentsLabel.text = tmpArcosExpenses.Comments;
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f", [[NSNumber numberWithDouble:tmpArcosExpenses.TotalAmount] floatValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.currentSelectDeleteIndexPath = indexPath;
        [self deleteSelectedExpense];
    }
}

- (void)deleteSelectedExpense {
    void (^deleteActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self deleteExpenseProcessor];
    };
    void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        
    };
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure you want to delete the expense" title:@"" delegate:nil target:[self.accessDelegate retrieveMeetingCostingViewController] tag:0 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
}

- (void)deleteExpenseProcessor {
    ArcosExpenses* tmpArcosExpenses = [self.displayList objectAtIndex:self.currentSelectDeleteIndexPath.row];
    tmpArcosExpenses.Comments = @"DELETE";
    [self.deleteDisplayList addObject:tmpArcosExpenses];
    [self.displayList removeObjectAtIndex:self.currentSelectDeleteIndexPath.row];
    [[self.accessDelegate retrieveExpenseTableView] reloadData];
}

- (void)createBasicDataWithReturnObject:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    self.displayList = [NSMutableArray array];
    self.deleteDisplayList = [NSMutableArray array];
    if (anArcosMeetingWithDetailsDownload == nil) return;
    if ([anArcosMeetingWithDetailsDownload.Expenses count] == 0) return;
    for (int i = 0; i < [anArcosMeetingWithDetailsDownload.Expenses count]; i++) {
        ArcosExpenses* tmpArcosExpenses = [anArcosMeetingWithDetailsDownload.Expenses objectAtIndex:i];
        [self.displayList addObject:tmpArcosExpenses];
    }
}

- (void)meetingExpenseDetailsSaveButtonProcessorWithData:(NSMutableDictionary*)aHeadOfficeDataObjectDict {
    ArcosExpenses* tmpArcosExpenses = [[[ArcosExpenses alloc] init] autorelease];
    tmpArcosExpenses.IUR = 0;
    NSMutableDictionary* exTypeDataDict = [aHeadOfficeDataObjectDict objectForKey:self.meetingExpenseDetailsDataManager.exTypeKey];
    tmpArcosExpenses.EXiur = [[exTypeDataDict objectForKey:@"DescrDetailIUR"] intValue];
    tmpArcosExpenses.ExpDate = [aHeadOfficeDataObjectDict objectForKey:self.meetingExpenseDetailsDataManager.expDateKey];
    tmpArcosExpenses.Comments = [aHeadOfficeDataObjectDict objectForKey:self.meetingExpenseDetailsDataManager.commentsKey];
    tmpArcosExpenses.TotalAmount = [[aHeadOfficeDataObjectDict objectForKey:self.meetingExpenseDetailsDataManager.totalAmountKey] doubleValue];
    [self.displayList addObject:tmpArcosExpenses];
}

- (void)populateArcosMeetingWithDetails:(ArcosMeetingWithDetailsDownload*)anArcosMeetingWithDetailsDownload {
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosExpenses* tmpArcosExpenses = [self.displayList objectAtIndex:i];
        tmpArcosExpenses.Comments = [ArcosUtils wrapStringByCDATA:tmpArcosExpenses.Comments];
        [anArcosMeetingWithDetailsDownload.Expenses addObject:tmpArcosExpenses];
    }
    for (int j = 0; j < [self.deleteDisplayList count]; j++) {
        ArcosExpenses* tmpArcosExpenses = [self.deleteDisplayList objectAtIndex:j];
        tmpArcosExpenses.Comments = [ArcosUtils wrapStringByCDATA:tmpArcosExpenses.Comments];
        [anArcosMeetingWithDetailsDownload.Expenses addObject:tmpArcosExpenses];
    }
}


@end
