//
//  QueryOrderMasterTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/05/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderMasterTableViewController.h"
#import "ArcosStackedViewController.h"

@interface QueryOrderMasterTableViewController ()

- (CGRect)getCorrelativeRootViewRect;
- (void)getTaskListData;
- (NSString*)getSuffixSqlStringWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
- (void)processHeightList;
- (void)selectCurrentIndexPathRow;
- (UINavigationController*)getNextNavigationalController;
- (void)alertViewCallBack;

@end

@implementation QueryOrderMasterTableViewController
@synthesize delegate = _delegate;
@synthesize displayList = _displayList;
@synthesize heightList = _heightList;
@synthesize callGenericServices = _callGenericServices;
@synthesize addButton = _addButton;
@synthesize emailButton = _emailButton;
@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize rightBarButtonItemList = _rightBarButtonItemList;
@synthesize queryOrderTaskTableViewController = _queryOrderTaskTableViewController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;
@synthesize queryOrderSource = _queryOrderSource;
@synthesize refreshRequestSource = _refreshRequestSource;
@synthesize animateDelegate = _animateDelegate;
@synthesize myParentNavigationControllerView = _myParentNavigationControllerView;
@synthesize mailController = _mailController;
@synthesize locationIUR = _locationIUR;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize taskTypeInstance = _taskTypeInstance;
@synthesize queryOrderEmailProcessCenter = _queryOrderEmailProcessCenter;
@synthesize atomicSqlFieldString = _atomicSqlFieldString;
@synthesize prefixSqlString = _prefixSqlString;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize textViewContentWidth = _textViewContentWidth;
@synthesize ownLocationPrefixSqlString = _ownLocationPrefixSqlString;
@synthesize issueClosedActualValue = _issueClosedActualValue;
@synthesize isIssueClosedChanged = _isIssueClosedChanged;
@synthesize defaultComletionDateString = _defaultComletionDateString;
@synthesize masterInputRequestSource = _masterInputRequestSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.masterInputRequestSource == MasterInputRequestSourceDashboard) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.defaultComletionDateString = @"01/01/1990";
    self.title = @"Tasks";
    self.myRootViewController = [ArcosUtils getRootView];
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    self.addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed:)] autorelease];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    EmailRecipientTableViewController* emailRecipientTableViewController = [[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil];
//    emailRecipientTableViewController.locationIUR = self.locationIUR;
    emailRecipientTableViewController.requestSource = EmailRequestSourceEmployee;
    emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:emailRecipientTableViewController] autorelease];
    [emailRecipientTableViewController release];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:self.emailNavigationController] autorelease];
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    if (self.queryOrderSource == QueryOrderHomePage) {
        [ArcosUtils configEdgesForExtendedLayout:self];
//        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)];
//        self.navigationItem.leftBarButtonItem = backButton;
        self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.addButton, self.emailButton, nil];
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.parentViewController.view] autorelease];
    } else if (self.queryOrderSource == QueryOrderListings) {
        self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.emailButton, nil];
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.myParentNavigationControllerView] autorelease];
    } else if (self.queryOrderSource == QueryOrderDashboard) {
        self.rightBarButtonItemList = [NSMutableArray arrayWithObjects:self.emailButton, nil];
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.myParentNavigationControllerView] autorelease];
    }
    [self.navigationItem setRightBarButtonItems:self.rightBarButtonItemList];
    
    self.queryOrderEmailProcessCenter = [[[QueryOrderEmailProcessCenter alloc] init] autorelease];
    self.atomicSqlFieldString = @"select IPADTaskView.TaskIUR,IPADTaskView.LocationIUR,IPADTaskView.Name,IPADTaskView.Address,IPADTaskView.Details,convert(varchar(19),IPADTaskView.StartDate,126) as MyStartDate,IPADTaskView.Status,IPADTaskView.ContactIUR,CONVERT(VARCHAR(10),IPADTaskView.CompletionDate,103) as MyCompletionDate,IPADTaskView.Employee ";
    self.prefixSqlString = [NSString stringWithFormat:@"%@ from IPADTaskView ", self.atomicSqlFieldString];

    self.ownLocationPrefixSqlString = [NSString stringWithFormat:@"%@ from Location INNER JOIN LocEmpLink ON Location.IUR = LocEmpLink.LocationIUR INNER JOIN IPADTaskView ON Location.IUR = IPADTaskView.LocationIUR ", self.atomicSqlFieldString];
}

- (void)dealloc {
    self.displayList = nil;
    self.heightList = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.addButton = nil;
    self.emailButton = nil;
    self.emailPopover = nil;
    self.emailNavigationController = nil;
    self.rightBarButtonItemList = nil;
    self.queryOrderTaskTableViewController = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    [arcosCustomiseAnimation release];
    self.myParentNavigationControllerView = nil;
    self.mailController = nil;
    self.locationIUR = nil;
    self.queryOrderEmailProcessCenter = nil;
    self.atomicSqlFieldString = nil;
    self.prefixSqlString = nil;
    self.currentIndexPath = nil;
    self.ownLocationPrefixSqlString = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textViewContentWidth = self.tableView.frame.size.width - 50;
//    NSLog(@"textViewContentWidth: %f", self.textViewContentWidth);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [self loadDataByRequestSource];
}

- (void)getTaskListData {
//    NSLog(@"a1");
    NSString* sqlString = [NSString stringWithFormat:@"%@ where IPADTaskView.LocationIUR = %@ order by IPADTaskView.StartDate desc", self.prefixSqlString, self.locationIUR];
    [self.callGenericServices genericGetData:sqlString action:@selector(setGenericGetDataResult:) target:self];
}

- (void)loadDataByTaskType:(NSInteger)taskType {
    NSString* suffixSqlString = @"";
    switch (taskType) {
        case 0:
            suffixSqlString = @"where IPADTaskView.TaskIUR != 0";
            break;
        case 1: {//today
            suffixSqlString = [self getSuffixSqlStringWithBeginDate:[ArcosUtils beginOfDay:[NSDate date]] endDate:[NSDate date]];
        }
            break;
        case 2: {
            suffixSqlString = [self getSuffixSqlStringWithBeginDate:[[GlobalSharedClass shared]thisWeek] endDate:[NSDate date]];
        }
            break;
        case 3: {
            suffixSqlString = [self getSuffixSqlStringWithBeginDate:[[GlobalSharedClass shared]thisMonth] endDate:[NSDate date]];
        }
            break;
        case 4: {
            suffixSqlString = [self getSuffixSqlStringWithBeginDate:[[GlobalSharedClass shared]thisYear] endDate:[NSDate date]];
        }
            break;
        case 5: {
            suffixSqlString = [self getSuffixSqlStringWithBeginDate:[[GlobalSharedClass shared]thisMat] endDate:[NSDate date]];
        }
            break;
        case 6: {
            suffixSqlString = @"where convert(varchar(10),IPADTaskView.CompletionDate,103) = '01/01/1990' and IPADTaskView.TaskIUR != 0";
        }
            break;
            
        default:
            break;
    }
    
    NSString* sqlString = @"";
    SettingManager* sm = [SettingManager setting];
    NSString* keypath = [NSString stringWithFormat:@"CompanySetting.%@",@"Download"];
    NSMutableDictionary* ownLocationOnly=[sm getSettingForKeypath:keypath atIndex:0];
    NSNumber* ownLocation = [ownLocationOnly objectForKey:@"Value"];
    
    if ([ownLocation boolValue]) {
        NSMutableDictionary* empolyee = [sm getSettingForKeypath:@"PersonalSetting.Personal" atIndex:0];
        NSNumber* empolyeeIUR = [empolyee objectForKey:@"Value"];
        NSString* ownLocationFilter = [NSString stringWithFormat:@" and LocEmpLink.EmployeeIUR = %d", [empolyeeIUR intValue]];
        sqlString = [NSString stringWithFormat:@"%@ %@ %@ order by IPADTaskView.StartDate desc", self.ownLocationPrefixSqlString, suffixSqlString, ownLocationFilter];
    } else {
        sqlString = [NSString stringWithFormat:@"%@ %@ order by IPADTaskView.StartDate desc", self.prefixSqlString, suffixSqlString];
    }
    [self.callGenericServices genericGetData:sqlString action:@selector(setGenericGetDataResult:) target:self];
}

- (NSString*)getSuffixSqlStringWithBeginDate:(NSDate*)beginDate endDate:(NSDate*)endDate {
    NSString* dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString* beginTodayString = [ArcosUtils stringFromDate:beginDate format:dateFormat];
    NSDate* endToday = [ArcosUtils endOfDay:endDate];
    NSString* endTodayString = [ArcosUtils stringFromDate:endToday format:dateFormat];
    
    return [NSString stringWithFormat:@"where IPADTaskView.StartDate between CONVERT(DATETIME, '%@', 120) and CONVERT(DATETIME, '%@', 120)",beginTodayString, endTodayString];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.textViewContentWidth = self.tableView.frame.size.width - 50;
    [self processHeightList];
    [self.tableView reloadData];
    [self selectCurrentIndexPathRow];
}
/*
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.textViewContentWidth = self.tableView.frame.size.width - 50;
        [self processHeightList];
        [self.tableView reloadData];
        [self selectCurrentIndexPathRow];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}
*/

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 220;
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
    NSString *CellIdentifier = @"IdQueryOrderMasterTableCell";
    
    QueryOrderMasterTableCell *cell=(QueryOrderMasterTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"QueryOrderMasterTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[QueryOrderMasterTableCell class]] && [[(QueryOrderMasterTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (QueryOrderMasterTableCell *) nibItem;
                cell.delegate = self;
            }
        }
	}
    
    // Configure the cell...
    [cell configCellWithData:[self.heightList objectAtIndex:indexPath.row]];
    cell.indexPath = indexPath;
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [cellData Field3];
    cell.addressLabel.text = [cellData Field4];
//    cell.detailsTextView.text = [NSString stringWithFormat:@"\n\n\n%@\n%@",[cellData Field5],[cellData Field10]];
    NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n\n%@\n\n",[cellData Field5]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    NSAttributedString* attributedEmployeeString = [[NSAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:[cellData Field10]] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:88.0/255.0 green:128.0/255.0 blue:0.0 alpha:1.0]}];
    [attributedDetailsString appendAttributedString:attributedEmployeeString];
    cell.detailsTextView.attributedText = attributedDetailsString;
    [attributedEmployeeString release];
    [attributedDetailsString release];
    if ([[cellData Field9] isEqualToString:self.defaultComletionDateString]) {
        cell.closeImageView.hidden = YES;
    } else {
        cell.closeImageView.hidden = NO;
    }
    @try {
        NSDate* tmpDate = [ArcosUtils dateFromString:[cellData Field6] format:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSMutableAttributedString* attributedDateString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils stringFromDate:tmpDate format:@"EEE dd MMMM "] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]}];
        NSAttributedString* attributedTimeString = [[NSAttributedString alloc] initWithString:[ArcosUtils stringFromDate:tmpDate format:@"HH:mm"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
        [attributedDateString appendAttributedString:attributedTimeString];
        cell.dateLabel.attributedText = attributedDateString;
        [attributedTimeString release];
        [attributedDateString release];
    }
    @catch (NSException *exception) {}
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    [self.delegate selectQueryOrderMasterRecord:[ArcosUtils convertStringToNumber:[cellData Field1]]];
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
//    NSLog(@"displayList: %@ %@", self.displayList, self.heightList);
//    NSLog(@"rrs: %d", self.refreshRequestSource);
    switch (self.refreshRequestSource) {
        case 0:
        case 1: {
            [self.delegate clearDetailTableCellList];
            self.currentIndexPath = nil;
        }
            break;
        case 2: {
            [self.delegate clearDetailTableCellList];
            self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self selectCurrentIndexPathRow];
        }
            break;
        case 3: {//edit
            if (self.taskTypeInstance == 6 && self.isIssueClosedChanged && self.issueClosedActualValue) {
                [self.delegate clearDetailTableCellList];
            } else {
                [self selectCurrentIndexPathRow];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - QueryOrderMasterTableCellDelegate
- (void)selectQueryOrderMasterTableCellRecord:(NSIndexPath *)anIndexPath {
    [self.tableView selectRowAtIndexPath:anIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:anIndexPath];
}

- (void)doubleTapQueryOrderMasterTableCellRecord:(NSIndexPath *)anIndexPath {
    self.refreshRequestSource = RefreshRequestEdit;
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    QueryOrderTaskWrapperViewController* qotwvc = [[QueryOrderTaskWrapperViewController alloc] initWithNibName:@"QueryOrderTaskWrapperViewController" bundle:nil];
    qotwvc.processingIndexPath = anIndexPath;
    qotwvc.myDelegate = self;
    qotwvc.refreshDelegate = self;
    qotwvc.editDelegate = self;
    qotwvc.actionType = @"edit";
    qotwvc.IUR = [ArcosUtils convertStringToNumber:cellData.Field1];
    qotwvc.locationIUR = [ArcosUtils convertStringToNumber:cellData.Field2];
    qotwvc.contactIUR = [ArcosUtils convertStringToNumber:cellData.Field8];
    qotwvc.navgationBarTitle = [NSString stringWithFormat:@"Task for %@", cellData.Field3];
    qotwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qotwvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    [qotwvc release];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self didDismissViewControllerProcessor];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self didDismissViewControllerProcessor];
}

- (void)didDismissViewControllerProcessor {
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


#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self didDismissCustomisePresentView];
}

#pragma mark 
- (void)didDismissModalView {
    [self didDismissCustomisePresentView];
}

- (void)addButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    self.refreshRequestSource = RefreshRequestAdd;
    QueryOrderTaskWrapperViewController* qotwvc = [[QueryOrderTaskWrapperViewController alloc] initWithNibName:@"QueryOrderTaskWrapperViewController" bundle:nil];
    qotwvc.myDelegate = self;
    qotwvc.refreshDelegate = self;
    qotwvc.actionType = @"create";
    qotwvc.IUR = [NSNumber numberWithInt:0];
    qotwvc.navgationBarTitle = @"Create New Task";
    qotwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    qotwvc.locationIUR = self.locationIUR;
    qotwvc.contactIUR = [GlobalSharedClass shared].currentSelectedContactIUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:qotwvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.myRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.myRootViewController addChildViewController:self.globalNavigationController];
    [self.myRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.myRootViewController];
    
    [qotwvc release];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

- (void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        return;
    }
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)backButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
    }
    [self.animateDelegate dismissSlideAcrossViewAnimation];
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

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {
    NSIndexPath* currentSelectedIndexPath = self.tableView.indexPathForSelectedRow;
    if (currentSelectedIndexPath == nil) {
        [ArcosUtils showMsg:@"Please select a task" delegate:nil];
        return;
    }
    NSString* body = @"";
    NSString* email = [cellData objectForKey:@"Email"];
    NSArray* toRecipients = [NSArray arrayWithObjects:email, nil];
    ArcosGenericClass* arcosGenericClass = [self.displayList objectAtIndex:currentSelectedIndexPath.row];
    @try {
        body = [self.queryOrderEmailProcessCenter buildEmailMessageWithTaskObject:arcosGenericClass memoDataList:[self.delegate getQueryOrderDetailDataList]];
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
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
            if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
                [self.emailPopover dismissPopoverAnimated:YES];
                return;
            }
        }];
        return;
    }    
    
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    [self.emailPopover dismissPopoverAnimated:YES];
    
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    @try {
        [self.mailController setMessageBody:body isHTML:YES];
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    
    [self.mailController setToRecipients:toRecipients];
    [self.mailController setSubject:[NSString stringWithFormat:@"%@ %@", arcosGenericClass.Field3, arcosGenericClass.Field4]];
    [self.myRootViewController presentViewController:self.mailController animated:YES completion:nil];
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self alertViewCallBack];
}

- (void)alertViewCallBack {
    [self.myRootViewController dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    [self loadDataByRequestSource];
}

- (void)refreshParentContentByEdit {
//    [self loadDataByRequestSource];
    [self processHeightList];
    NSMutableArray* rowsToReload = [NSMutableArray array];
    [rowsToReload addObject:self.currentIndexPath];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [self selectCurrentIndexPathRow];
}

- (void)refreshParentContentByEditType:(BOOL)aFlag closeActualValue:(BOOL)aCloseActualValue  indexPath:(NSIndexPath *)anIndexPath {
    self.isIssueClosedChanged = aFlag;
    self.issueClosedActualValue = aCloseActualValue;
//    if (self.taskTypeInstance == 6 && aFlag && aCloseActualValue) {
//        self.currentIndexPath = nil;
//        return;
//    }
    if (self.currentIndexPath != nil && self.currentIndexPath.row == anIndexPath.row) {
        if (aFlag) {
            [self selectQueryOrderMasterTableCellRecord:self.currentIndexPath];
        }
    } else {
        self.currentIndexPath = anIndexPath;
        [self selectQueryOrderMasterTableCellRecord:self.currentIndexPath];
    }
}

- (void)loadDataByRequestSource {
    if (self.queryOrderSource == QueryOrderListings) {
        [self loadDataByTaskType:self.taskTypeInstance];
        return;
    }
    [self getTaskListData];
}

- (void)processHeightList {
    self.heightList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:i];
        NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n\n%@\n\n",[cellData Field5]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        NSAttributedString* attributedEmployeeString = [[NSAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:[cellData Field10]] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor colorWithRed:88.0/255.0 green:128.0/255.0 blue:0.0 alpha:1.0]}];
        [attributedDetailsString appendAttributedString:attributedEmployeeString];
        
        CGRect rect = [attributedDetailsString boundingRectWithSize:CGSizeMake(self.textViewContentWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedEmployeeString release];
        [attributedDetailsString release];
//        NSLog(@"height:%f",rect.size.height);
        [self.heightList addObject:[NSNumber numberWithFloat:rect.size.height + 16.0]];
    }
}

- (void)selectCurrentIndexPathRow {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark EditOperationViewControllerDelegate
- (void)editFinishedWithData:(id)contentString fieldName:(NSString*)fieldName forIndexpath:(NSIndexPath*)theIndexpath {
    if ([[fieldName uppercaseString] isEqualToString:@"DETAILS"]) {
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:theIndexpath.row];
        cellData.Field5 = contentString;
    } else if ([[fieldName uppercaseString] isEqualToString:@"COMPLETIONDATE"]) {
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:theIndexpath.row];
        cellData.Field9 = contentString;
    }
    
}

#pragma mark QueryOrderMasterTableViewControllerDelegate
- (void)selectQueryOrderMasterRecord:(NSNumber*)taskIUR {
    QueryOrderDetailTableViewController* queryOrderDetailTableViewController = [[QueryOrderDetailTableViewController alloc] initWithStyle:UITableViewStylePlain];
    queryOrderDetailTableViewController.delegate = self;
    queryOrderDetailTableViewController.taskIUR = taskIUR;
    queryOrderDetailTableViewController.queryOrderDetailSource = QueryOrderDetailHomePage;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:queryOrderDetailTableViewController];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    
    [queryOrderDetailTableViewController release];
    [tmpNavigationController release];
}
//- (CGRect)getParentFrameFromChild {
//    return CGRectMake(0, 0, 0, 0);
//}
- (NSMutableArray*)getQueryOrderDetailDataList {
    UINavigationController* nextNavigationController = [self getNextNavigationalController];
    if (nextNavigationController == nil) return nil;
    QueryOrderDetailTableViewController* tmpQueryOrderDetailTableViewController = [nextNavigationController.viewControllers objectAtIndex:0];
    return tmpQueryOrderDetailTableViewController.displayList;
}

- (void)clearDetailTableCellList {
    UINavigationController* nextNavigationController = [self getNextNavigationalController];
//    NSLog(@"nnc: %@", nextNavigationController);
    if (nextNavigationController == nil) return;
    QueryOrderDetailTableViewController* tmpQueryOrderDetailTableViewController = [nextNavigationController.viewControllers objectAtIndex:0];
//    NSLog(@"Detail: %@", tmpQueryOrderDetailTableViewController);
    tmpQueryOrderDetailTableViewController.displayList = [NSMutableArray arrayWithCapacity:0];
    [tmpQueryOrderDetailTableViewController.tableView reloadData];
}

- (UINavigationController*)getNextNavigationalController {
    int currentIndex = [self.rcsStackedController indexOfMyNavigationController:(UINavigationController *)self.parentViewController];
//    NSLog(@"currentIndex: %d", currentIndex);
    return [self.rcsStackedController previousNavControllerWithCurrentIndex:currentIndex step:-1];
}

#pragma mark QueryOrderDetailTableViewControllerDelegate
- (NSIndexPath*)getMasterTaskSelectedRow {
    return [self.tableView indexPathForSelectedRow];
}
- (NSNumber*)getMasterTaskLocationIUR {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field2]];
}
- (NSNumber*)getMasterTaskIUR {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field1]];
}
- (NSNumber*)getMasterTaskContactIUR {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [ArcosUtils convertStringToNumber:[cellData Field8]];
}
- (NSString*)getMasterTaskCompletionDate {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:[self getMasterTaskSelectedRow].row];
    return [cellData Field9];
}
- (void)refreshMasterContentByMemoCreate:(NSIndexPath*)anIndexPath {
    self.refreshRequestSource = RefreshRequestEdit;
    [self refreshParentContentByEdit];
}
- (void)inheritEditFinishedWithData:(id)contentString fieldName:(NSString *)fieldName forIndexpath:(NSIndexPath *)theIndexpath {
    [self editFinishedWithData:contentString fieldName:fieldName forIndexpath:theIndexpath];
}

@end
