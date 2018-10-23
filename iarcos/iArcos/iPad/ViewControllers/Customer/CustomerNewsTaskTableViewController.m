//
//  CustomerNewsTaskTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 23/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "CustomerNewsTaskTableViewController.h"

@interface CustomerNewsTaskTableViewController ()
- (void)processTaskData;
@end

@implementation CustomerNewsTaskTableViewController
@synthesize customerNewsTaskRequestSource = _customerNewsTaskRequestSource;
@synthesize myDelegate = _myDelegate;
@synthesize callGenericServices = _callGenericServices;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize displayList = _displayList;
@synthesize heightList = _heightList;
@synthesize typeList = _typeList;
@synthesize textViewContentWidth = _textViewContentWidth;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize myRootViewController = _myRootViewController;

- (void)dealloc {
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.displayList = nil;
    self.heightList = nil;
    self.typeList = nil;
    self.globalNavigationController = nil;
    self.myRootViewController = nil;
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.allowsSelection = NO;
    self.title = @"Reminder";
    self.displayList = [NSMutableArray array];
    self.heightList = [NSMutableArray array];
    self.typeList = [NSMutableArray array];
    if (self.customerNewsTaskRequestSource != CustomerNewsTaskDashboard) {
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
        self.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
//    self.callGenericServices.isNotRecursion = NO;
    self.callGenericServices.delegate = self;
    self.myRootViewController = [ArcosUtils getRootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isNotFirstLoaded) return;
    self.isNotFirstLoaded = YES;
    [self getNewsData];
}

- (void)getNewsData {
    NSDate* myDate = [NSDate date];
//    [ArcosUtils dateFromString:@"14/12/2010" format:[GlobalSharedClass shared].dateFormat];
    NSString* stringDate = [NSString stringWithFormat:@"%@ 00:00:00", [ArcosUtils stringFromDate:myDate format:@"yyyy-MM-dd"]];
    NSString* sqlString = [NSString stringWithFormat:@"select Title, Details, LinkAddress from News where ExpiryDate > CONVERT(DATETIME, '%@', 102) ", stringDate];
    [self.callGenericServices getData:sqlString];
}

- (void)backPressed {
    [self.myDelegate didDismissCustomisePresentView];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 220.0;
    return [[self.heightList objectAtIndex:indexPath.row] floatValue] + 38.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.displayList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"IdCustomerNewsTaskTableCell";
    
    CustomerNewsTaskTableCell* cell = (CustomerNewsTaskTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerNewsTaskTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerNewsTaskTableCell class]] && [[(CustomerNewsTaskTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerNewsTaskTableCell *) nibItem;
                cell.actionDelegate = self;
            }
        }
    }
    cell.indexPath = indexPath;
    [cell configCellWithData:[self.heightList objectAtIndex:indexPath.row]];
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.myTitle.text = [ArcosUtils convertNilToEmpty:cellData.Field1];
    cell.myDetails.text = [ArcosUtils convertNilToEmpty:cellData.Field2];
    cell.type = [self.typeList objectAtIndex:indexPath.row];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    if ([cell.type intValue] == 1) {
        cell.linkAddress.attributedText = [[[NSAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:cellData.Field3] attributes:underlineAttribute] autorelease];
    }
    if ([cell.type intValue] == 2) {
        cell.linkAddress.attributedText = [[[NSAttributedString alloc] initWithString:@"Properties" attributes:underlineAttribute] autorelease];
    }
    
    return cell;
}


#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
//        [self.callGenericServices.HUD hide:YES];
        return;
    }
    self.displayList = [NSMutableArray array];
    if (result.ErrorModel.Code > 0) {
//        result = [ArcosXMLParser doXMLParse:@"news_resp" deserializeTo:[[ArcosGenericReturnObject alloc] autorelease]];
        self.displayList = result.ArrayOfData;
        for (int i = 0; i < [result.ArrayOfData count]; i++) {
            [self.typeList addObject:[NSNumber numberWithInt:1]];
        }
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
    [self processHeightList];
    [self.tableView reloadData];
//    if (result.ErrorModel >= 0) {
//        [self processTaskData];
//    }
}

- (void)processTaskData {
    NSNumber* employeeIUR = [SettingManager employeeIUR];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* ownDataOnly = [employeeDict objectForKey:@"OwnDataOnly"];
    NSString* whereClause = @"";
    if ([ownDataOnly boolValue]) {
        whereClause = [NSString stringWithFormat:@" WHERE (Task.CompletionDate = CONVERT(DATETIME, '1990-01-01 00:00:00', 102)) AND (Task.EmployeeIUR = %d) OR (Task.CompletionDate = CONVERT(DATETIME, '1990-01-01 00:00:00', 102)) AND  (Task.PassedToEmployeeIUR = %d)", [employeeIUR intValue], [employeeIUR intValue]];
    } else {
        whereClause = @" WHERE (Task.CompletionDate = CONVERT(DATETIME, '1990-01-01 00:00:00', 102))";
    }
    NSString* sqlString = [NSString stringWithFormat:@"SELECT DescrDetail.Details AS Type, Task.Details, Task.Priority , Task.IUR, Task.LocationIUR, Task.ContactIUR, Task.EmployeeIUR, Task.PassedToEmployeeIUR FROM Task INNER JOIN DescrDetail ON Task.TYiur = DescrDetail.IUR %@", whereClause];
    [self.callGenericServices genericGetData:sqlString action:@selector(setTaskGetDataResult:) target:self];
}

#pragma mark - setTaskGetDataResult
-(void)setTaskGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.displayList addObjectsFromArray:result.ArrayOfData];
        for (int i = 0; i < [result.ArrayOfData count]; i++) {
            [self.typeList addObject:[NSNumber numberWithInt:2]];
        }
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
    }
    if (result.ErrorModel.Code >= 0) {
        [self processHeightList];
        [self.tableView reloadData];
    }
}

- (void)processHeightList {
    self.textViewContentWidth = self.tableView.frame.size.width - 50;
    self.heightList = [NSMutableArray arrayWithCapacity:[self.displayList count]];
    for (int i = 0; i < [self.displayList count]; i++) {
        ArcosGenericClass* cellData = [self.displayList objectAtIndex:i];
        NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n\ntest",[cellData Field2]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
        
        CGRect rect = [attributedDetailsString boundingRectWithSize:CGSizeMake(self.textViewContentWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedDetailsString release];
        //        NSLog(@"height:%f",rect.size.height);
        [self.heightList addObject:[NSNumber numberWithFloat:rect.size.height + 16.0]];
    }
}

#pragma mark CustomerNewsTaskTableCellDelegate
- (void)selectNewsTableCellRecord:(NSIndexPath *)anIndexPath {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    NSURL* myURL = [NSURL URLWithString:[ArcosUtils convertNilToEmpty:cellData.Field3]];
    if ([[UIApplication sharedApplication] canOpenURL:myURL]) {
        [[UIApplication sharedApplication] openURL:myURL];
    } else {
        [ArcosUtils showMsg:[NSString stringWithFormat:@"can not open %@", myURL] delegate:nil];
    }
}

- (void)selectTaskTableCellRecord:(NSIndexPath *)anIndexPath {
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:anIndexPath.row];
    QueryOrderTaskWrapperViewController* qotwvc = [[QueryOrderTaskWrapperViewController alloc] initWithNibName:@"QueryOrderTaskWrapperViewController" bundle:nil];
    qotwvc.processingIndexPath = anIndexPath;
    qotwvc.myDelegate = self;
    qotwvc.refreshDelegate = self;
//    qotwvc.editDelegate = self;
    qotwvc.actionType = @"edit";
    qotwvc.IUR = [ArcosUtils convertStringToNumber:cellData.Field4];
    qotwvc.locationIUR = [ArcosUtils convertStringToNumber:cellData.Field5];
    qotwvc.contactIUR = [ArcosUtils convertStringToNumber:[ArcosUtils convertNilToEmpty:cellData.Field6]];
//    qotwvc.navgationBarTitle = [NSString stringWithFormat:@"Task for %@", cellData.Field3];
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[ArcosUtils convertStringToNumber:cellData.Field5]];
    if ([locationList count] == 1) {
        NSDictionary* locationDict = [locationList objectAtIndex:0];
        qotwvc.navgationBarTitle = [NSString stringWithFormat:@"Task for %@", [locationDict objectForKey:@"Name"]];
    }
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

#pragma mark GenericRefreshParentContentDelegate
#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    
}

- (void)refreshParentContentByEdit {
    [self getNewsData];
}

- (void)refreshParentContentByEditType:(BOOL)aFlag closeActualValue:(BOOL)aCloseActualValue  indexPath:(NSIndexPath *)anIndexPath {
    
}

@end
