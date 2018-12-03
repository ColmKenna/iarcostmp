//
//  MeetingCostingsViewController.m
//  iArcos
//
//  Created by David Kilmartin on 16/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingCostingsViewController.h"

@interface MeetingCostingsViewController ()
- (void)maskExpensesTemplateView;
@end

@implementation MeetingCostingsViewController
@synthesize budgetTemplateView = _budgetTemplateView;
@synthesize expensesTemplateView = _expensesTemplateView;
@synthesize budgetNavigationBar = _budgetNavigationBar;
@synthesize expensesNavigationBar = _expensesNavigationBar;
@synthesize budgetTableView = _budgetTableView;
@synthesize expensesTableView = _expensesTableView;
@synthesize meetingCostingsDataManager = _meetingCostingsDataManager;
@synthesize templateViewList = _templateViewList;
@synthesize addBarButtonItem = _addBarButtonItem;
@synthesize meetingExpenseTableViewController = _meetingExpenseTableViewController;
@synthesize meetingBudgetTableCellFactory = _meetingBudgetTableCellFactory;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.meetingCostingsDataManager = [[[MeetingCostingsDataManager alloc] init] autorelease];
//        [self.meetingCostingsDataManager createBasicData];
        self.meetingBudgetTableCellFactory = [[[MeetingBudgetTableCellFactory alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:211.0/255.0 green:215.0/255.0 blue:221.0/255.0 alpha:1.0];
    self.templateViewList = [NSArray arrayWithObjects:self.budgetTemplateView, self.expensesTemplateView, nil];
    [self maskTemplateViewWithView:self.budgetTemplateView];
    
    self.meetingExpenseTableViewController = [[[MeetingExpenseTableViewController alloc] init] autorelease];
    self.meetingExpenseTableViewController.accessDelegate = self;
    self.expensesTableView.dataSource = self.meetingExpenseTableViewController;
    self.expensesTableView.delegate = self.meetingExpenseTableViewController;
    
    [self createRightBarButtonItems];
    
    
    self.budgetTableView.dataSource = self;
    self.budgetTableView.delegate = self;
}

- (void)createRightBarButtonItems {
    NSMutableArray* barButtonItemList = [NSMutableArray arrayWithCapacity:2];
    
    self.addBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBarButtonPressed)] autorelease];
    [barButtonItemList addObject:self.addBarButtonItem];
    UIBarButtonSystemItem myBarButtonSystemItem = UIBarButtonSystemItemEdit;
    if (self.meetingExpenseTableViewController.editing) {
        myBarButtonSystemItem = UIBarButtonSystemItemDone;
    }
    UIBarButtonItem* editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:myBarButtonSystemItem target:self action:@selector(editBarButtonPressed)];
    [barButtonItemList addObject:editBarButtonItem];
    [editBarButtonItem release];
    self.expensesNavigationBar.topItem.rightBarButtonItems = barButtonItemList;
}

- (void)dealloc {
    self.budgetTemplateView = nil;
    self.expensesTemplateView = nil;
    self.budgetNavigationBar = nil;
    self.expensesNavigationBar = nil;
    self.budgetTableView = nil;
    self.expensesTableView = nil;
    self.meetingCostingsDataManager = nil;
    self.templateViewList = nil;
    self.addBarButtonItem = nil;
    self.meetingExpenseTableViewController = nil;
    self.meetingBudgetTableCellFactory = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self maskExpensesTemplateView];
}

- (void)maskExpensesTemplateView {
    [self maskTemplateViewWithView:self.expensesTemplateView];
}

- (void)maskTemplateViewWithView:(UIView*)aView {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight|UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = aView.bounds;
    maskLayer.path = maskPath.CGPath;
    aView.layer.mask = maskLayer;
    [maskLayer release];
}

- (void)addBarButtonPressed {
    MeetingExpenseDetailsViewController* meetingExpenseDetailsViewController = [[MeetingExpenseDetailsViewController alloc] initWithNibName:@"MeetingExpenseDetailsViewController" bundle:nil];
    meetingExpenseDetailsViewController.preferredContentSize = CGSizeMake(380.0f, 44*5 + 50);
    meetingExpenseDetailsViewController.modalDelegate = self;
    meetingExpenseDetailsViewController.actionDelegate = self;
    meetingExpenseDetailsViewController.modalPresentationStyle = UIModalPresentationPopover;
    meetingExpenseDetailsViewController.popoverPresentationController.barButtonItem = self.addBarButtonItem;
    [self presentViewController:meetingExpenseDetailsViewController animated:YES completion:^{
        
    }];
    [meetingExpenseDetailsViewController release];
}

- (void)editBarButtonPressed {
    if (self.meetingExpenseTableViewController.editing) {
        [self.meetingExpenseTableViewController setEditing:NO];
        [self.expensesTableView setEditing:NO animated:YES];
        [self.expensesTableView reloadData];
    } else {
        [self.meetingExpenseTableViewController setEditing:YES];
        [self.expensesTableView setEditing:YES animated:YES];
        [self.expensesTableView reloadData];
    }
    [self createRightBarButtonItems];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self maskExpensesTemplateView];
    }];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.meetingCostingsDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary* cellData = [self.meetingCostingsDataManager.displayList objectAtIndex:indexPath.row];
    MeetingBudgetBaseTableViewCell* cell = (MeetingBudgetBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[self.meetingBudgetTableCellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (MeetingBudgetBaseTableViewCell*)[self.meetingBudgetTableCellFactory createMeetingBudgetBaseTableCellWithData:cellData];
    }
    // Configure the cell...
    cell.myIndexPath = indexPath;
    cell.actionDelegate = self;
    [cell configCellWithData:cellData];
    
    return cell;
}


#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MeetingExpenseDetailsViewControllerDelegate
- (void)meetingExpenseDetailsSaveButtonWithData:(NSMutableDictionary *)aHeadOfficeDataObjectDict {
    [self.meetingExpenseTableViewController.displayList addObject:[NSMutableDictionary dictionaryWithDictionary:aHeadOfficeDataObjectDict]];
    [self.expensesTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MeetingExpenseTableViewControllerDelegate
- (UITableView*)retrieveExpenseTableView {
    return self.expensesTableView;
}

#pragma mark MeetingBaseTableViewCellDelegate
- (NSMutableDictionary*)retrieveHeadOfficeDataObjectDict {
    return self.meetingCostingsDataManager.headOfficeDataObjectDict;
}

- (void)meetingBaseInputFinishedWithData:(id)aData atIndexPath:(NSIndexPath*)anIndexPath {
    [self.meetingCostingsDataManager dataMeetingBaseInputFinishedWithData:aData atIndexPath:anIndexPath];
}

@end
