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
@synthesize meetingExpenseDetailsDataManager = _meetingExpenseDetailsDataManager;
@synthesize currentSelectDeleteIndexPath = _currentSelectDeleteIndexPath;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayList = [NSMutableArray array];
        self.meetingExpenseDetailsDataManager = [[[MeetingExpenseDetailsDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    self.displayList = nil;
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
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.dateLabel.text = [ArcosUtils stringFromDate:[cellData objectForKey:self.meetingExpenseDetailsDataManager.expDateKey] format:[GlobalSharedClass shared].dateFormat];
    NSMutableDictionary* exTypeDataDict = [cellData objectForKey:self.meetingExpenseDetailsDataManager.exTypeKey];
    cell.detailsLabel.text = [exTypeDataDict objectForKey:@"Title"];
    cell.commentsLabel.text = [cellData objectForKey:self.meetingExpenseDetailsDataManager.commentsKey];
    cell.amountLabel.text = [cellData objectForKey:self.meetingExpenseDetailsDataManager.totalAmountKey];
    
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
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
    [ArcosUtils showTwoBtnsDialogBox:@"Are you sure you want to delete the expense" title:@"" delegate:nil target:self tag:0 lBtnText:@"Cancel" rBtnText:@"Delete" lBtnHandler:cancelActionHandler rBtnHandler:deleteActionHandler];
}

- (void)deleteExpenseProcessor {
    [self.displayList removeObjectAtIndex:self.currentSelectDeleteIndexPath.row];
    [[self.accessDelegate retrieveExpenseTableView] reloadData];
}


@end
