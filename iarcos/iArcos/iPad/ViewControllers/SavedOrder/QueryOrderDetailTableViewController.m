//
//  QueryOrderDetailTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderDetailTableViewController.h"

@interface QueryOrderDetailTableViewController ()

- (CGRect)getCorrelativeRootViewRect;
- (void)getMemoListData;
- (void)processHeightList;

@end

@implementation QueryOrderDetailTableViewController
@synthesize delegate = _delegate;
@synthesize queryOrderDetailSource = _queryOrderDetailSource;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize callGenericServices = _callGenericServices;
@synthesize displayList = _displayList;
@synthesize heightList = _heightList;
@synthesize addButton = _addButton;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;
@synthesize myParentNavigationControllerView = _myParentNavigationControllerView;
@synthesize taskIUR = _taskIUR;
@synthesize textViewContentWidth = _textViewContentWidth;
@synthesize detailInputRequestSource = _detailInputRequestSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.detailInputRequestSource == DetailInputRequestSourceDashboard) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.title = @"Memos";
    self.tableView.allowsSelection = NO;
    self.myRootViewController = [ArcosUtils getRootView];
    self.addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    self.textViewContentWidth = 310.0f;
    if (self.queryOrderDetailSource == QueryOrderDetailHomePage) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.parentViewController.view] autorelease];
    } else {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.myParentNavigationControllerView] autorelease];
    }
}

- (void)dealloc {
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.displayList = nil;
    self.heightList = nil;
    self.addButton = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    self.myParentNavigationControllerView = nil;
    self.taskIUR = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textViewContentWidth = self.view.bounds.size.width - 42.0;
//    NSLog(@"aaa: %f", self.textViewContentWidth);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.queryOrderDetailSource == QueryOrderDetailHomePage) {
        if (self.isNotFirstLoaded) return;
        self.isNotFirstLoaded = YES;
        [self loadDataForTableView:self.taskIUR];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addButtonPressed:(id)sender {
    NSIndexPath* taskSelectedIndexPath = [self.delegate getMasterTaskSelectedRow];
    if (taskSelectedIndexPath == nil) {
        [ArcosUtils showMsg:@"Please select a task." delegate:nil];
        return;
    }
    NSNumber* taskLocationIUR = [self.delegate getMasterTaskLocationIUR];
    QueryOrderMemoWrapperViewController* qomwvc = [[QueryOrderMemoWrapperViewController alloc] initWithNibName:@"QueryOrderMemoWrapperViewController" bundle:nil];
    qomwvc.myDelegate = self;
    qomwvc.refreshDelegate = self;
    qomwvc.editDelegate = self;
    qomwvc.actionType = @"create";
    qomwvc.IUR = [NSNumber numberWithInt:0];
    qomwvc.locationIUR = taskLocationIUR;
    qomwvc.taskIUR = [self.delegate getMasterTaskIUR];
    qomwvc.contactIUR = [self.delegate getMasterTaskContactIUR];
    qomwvc.taskCompletionDate = [self.delegate getMasterTaskCompletionDate];
    qomwvc.taskCurrentIndexPath = taskSelectedIndexPath;
    qomwvc.navgationBarTitle = @"Create New Memo";
    qomwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qomwvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    
    [qomwvc release];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
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


- (void)loadDataForTableView:(NSNumber*)taskIUR {
    self.taskIUR = taskIUR;
    [self getMemoListData];
}

- (void)getMemoListData {
    NSString* sqlString = [NSString stringWithFormat:@"select convert(varchar(19),DateEntered,126) as MyDateEntered,Details,Employee,TableIUR,IUR,Contact,EmployeeIUR from ipadmemoview where TableIUR = %d order by DateEntered asc", [self.taskIUR intValue]];
    [self.callGenericServices genericGetData:sqlString action:@selector(setGenericGetDataResult:) target:self];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[self.heightList objectAtIndex:indexPath.row] floatValue] + 38.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdQueryOrderDetailTableCell";
    
    QueryOrderDetailTableCell *cell=(QueryOrderDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"QueryOrderDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[QueryOrderDetailTableCell class]] && [[(QueryOrderDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (QueryOrderDetailTableCell *) nibItem;
                cell.delegate = self;
            }
        }
	}
    
    // Configure the cell...
    [cell configCellWithData:[self.heightList objectAtIndex:indexPath.row]];
    cell.indexPath = indexPath;
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    
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

#pragma mark - setGenericGetDataResult
-(void)setGenericGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
    } else if(result.ErrorModel.Code <= 0) {
        self.displayList = [NSMutableArray arrayWithCapacity:0];
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
    [self processHeightList];
    [self.tableView reloadData];
    NSUInteger listLength = [self.displayList count];
    if (listLength != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:listLength-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)processHeightList {
    self.heightList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:i];
        NSString* tmpText = [NSString stringWithFormat:@"\n\n%@", [cellData Field2]];
        NSAttributedString* dynamicString = [[NSAttributedString alloc] initWithString:tmpText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        CGRect rect = [dynamicString boundingRectWithSize:CGSizeMake(self.textViewContentWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [dynamicString release];
//        NSLog(@"height:%f",rect.size.height);
        [self.heightList addObject:[NSNumber numberWithFloat:rect.size.height + 16.0]];
    }
    
}

- (CGRect)getCorrelativeRootViewRect {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
        return CGRectMake(self.myRootViewController.view.frame.origin.x, self.myRootViewController.view.frame.origin.y, self.myRootViewController.view.frame.size.height, self.myRootViewController.view.frame.size.width);
    } else if ((orientation == UIInterfaceOrientationPortrait) || (orientation == UIInterfaceOrientationPortraitUpsideDown)) {
        return CGRectMake(self.myRootViewController.view.frame.origin.x, self.myRootViewController.view.frame.origin.y, self.myRootViewController.view.frame.size.width, self.myRootViewController.view.frame.size.height);
    }
    return self.myRootViewController.view.frame;
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    [self loadDataForTableView:[self.delegate getMasterTaskIUR]];
//    [self getMemoListData];
}

- (void)refreshParentContentByCreate:(NSIndexPath*)anIndexPath {
    [self.delegate refreshMasterContentByMemoCreate:anIndexPath];
}

#pragma mark GenericDoubleTapRecordDelegate
- (void)customiseDoubleTapRecord:(NSIndexPath*)anIndexPath {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    NSNumber* taskLocationIUR = [self.delegate getMasterTaskLocationIUR];
    QueryOrderMemoWrapperViewController* qomwvc = [[QueryOrderMemoWrapperViewController alloc] initWithNibName:@"QueryOrderMemoWrapperViewController" bundle:nil];
    qomwvc.myDelegate = self;
    qomwvc.refreshDelegate = self;
    qomwvc.actionType = @"edit";
    qomwvc.IUR = [ArcosUtils convertStringToNumber:[cellData Field5]];
    qomwvc.locationIUR = taskLocationIUR;
    qomwvc.navgationBarTitle = @"Memo Details";
    qomwvc.memoEmployeeIUR = [ArcosUtils convertStringToNumber:[cellData Field7]];
    qomwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qomwvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    [qomwvc release];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark EditOperationViewControllerDelegate
- (void)editFinishedWithData:(id)contentString fieldName:(NSString *)fieldName forIndexpath:(NSIndexPath *)theIndexpath {
    [self.delegate inheritEditFinishedWithData:contentString fieldName:fieldName forIndexpath:theIndexpath];
}

@end
