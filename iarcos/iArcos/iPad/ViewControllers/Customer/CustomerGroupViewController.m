//
//  CustomerGroupViewController.m
//  Arcos
//
//  Created by David Kilmartin on 22/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "CustomerGroupViewController.h"
#import "ArcosCoreData.h"
#import "ArcosStackedViewController.h"
@interface CustomerGroupViewController()

- (void)showBarButtonItem;
- (void)hideBarButtonItem;

@end

@implementation CustomerGroupViewController
@synthesize requestSource = _requestSource;
@synthesize myMoveDelegate = _myMoveDelegate;
@synthesize customerGroupDataManager = _customerGroupDataManager;
@synthesize popoverController, splitViewController, rootPopoverButtonItem;

@synthesize myCustomerListingViewController;
//@synthesize searchBar;
@synthesize myGroups;
@synthesize groupType;
@synthesize groupName;
@synthesize groupSelections = _groupSelections;
@synthesize sortKeys;
@synthesize segmentBut = _segmentBut;
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
@synthesize listingDetailViewController = _listingDetailViewController;
@synthesize journeyDetailViewController = _journeyDetailViewController;
@synthesize myJourneyDetailViewController = _myJourneyDetailViewController;
@synthesize contactDetailViewController = _contactDetailViewController;
@synthesize myContactDetailViewController = _myContactDetailViewController;
@synthesize auxDetailViewController = _auxDetailViewController;
@synthesize journeyDefaultImage = _journeyDefaultImage;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;
@synthesize listTypeText = _listTypeText;
@synthesize journeyTypeText = _journeyTypeText;
@synthesize auxJourneyIndexPath = _auxJourneyIndexPath;
@synthesize tableCellFactory = _tableCellFactory;
@synthesize accessTimesWidgetViewController = _accessTimesWidgetViewController;
@synthesize outlookTypeText = _outlookTypeText;

- (instancetype)initWithStyle:(UITableViewStyle)aStyle requestSource:(CustomerGroupRequestSource)aRequestSource {
    self.requestSource = aRequestSource;
    return [self initWithStyle:aStyle];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.listTypeText = @"List";
        self.journeyTypeText = @"Journey";
        self.customerJourneyDataManager = [[[CustomerJourneyDataManager alloc]init] autorelease];
        self.myJourneyDetailViewController = [[[CustomerJourneyDetailViewController alloc] initWithNibName:@"CustomerJourneyDetailViewController" bundle:nil] autorelease];
        self.myJourneyDetailViewController.requestSourceName = [GlobalSharedClass shared].customerText;
        self.myJourneyDetailViewController.customerJourneyDataManager = self.customerJourneyDataManager;
        self.myCustomerListingViewController = [[[CustomerListingViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        self.myCustomerListingViewController.requestSourceName = [GlobalSharedClass shared].customerText;
        self.myContactDetailViewController = [[[CustomerContactDetailViewController alloc] initWithNibName:@"CustomerContactDetailViewController" bundle:nil] autorelease];
        self.myContactDetailViewController.requestSourceName = [GlobalSharedClass shared].contactText;
        self.tableCellFactory = [CustomerGroupTableCellFactory factory];
        if (self.requestSource == CustomerGroupRequestSourceMaster) {
            self.auxDetailViewController = self.myCustomerListingViewController;
            self.customerGroupDataManager = [[[CustomerGroupListDataManager alloc] init] autorelease];
            self.groupType = self.listTypeText;
        } else {
            self.auxDetailViewController = self.myContactDetailViewController;
            self.customerGroupDataManager = [[[CustomerGroupContactDataManager alloc] init] autorelease];
            self.groupType = [GlobalSharedClass shared].contactText;
        }
        self.outlookTypeText = @"Outlook";
    }
    return self;
}

- (void)dealloc
{
//    [groupSelections release];
//    [searchBar release];
    self.customerGroupDataManager = nil;
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
    self.myCustomerListingViewController = nil;
    self.groupType = nil;
    self.myGroups = nil;
    self.groupName = nil;
    self.groupSelections = nil;
    self.sortKeys = nil;
    if (self.segmentBut != nil) { self.segmentBut = nil; }
    if (self.customerJourneyDataManager != nil) { self.customerJourneyDataManager = nil; }
    if (self.listingDetailViewController != nil) { self.listingDetailViewController = nil; }    
    if (self.journeyDetailViewController != nil) {self.journeyDetailViewController = nil; }    
    if (self.myJourneyDetailViewController != nil) {self.myJourneyDetailViewController = nil; }
    if (self.contactDetailViewController != nil) {self.contactDetailViewController = nil; }    
    if (self.myContactDetailViewController != nil) {self.myContactDetailViewController = nil; }
    self.auxDetailViewController = nil;
    if (self.journeyDefaultImage != nil) { self.journeyDefaultImage = nil; }
    self.factory = nil;
    self.thePopover = nil;
    self.auxJourneyIndexPath = nil;
    self.tableCellFactory = nil;
    self.accessTimesWidgetViewController = nil;
    self.outlookTypeText = nil;
    
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
    if (self.requestSource == CustomerGroupRequestSourceMaster) {
        NSArray* statusItems = [NSArray arrayWithObjects:self.listTypeText, self.journeyTypeText, nil];// self.outlookTypeText,
        self.segmentBut = [[[UISegmentedControl alloc] initWithItems:statusItems] autorelease];
        
        [self.segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        self.segmentBut.frame = CGRectMake(0, 0, 150, 30);
        self.segmentBut.momentary = YES;
        self.navigationItem.titleView = self.segmentBut;
    }
    [self showBarButtonItem];
    [self.customerGroupDataManager createDataList];
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    searching = NO;
    letUserSelectRow = YES;
    
}

- (void)showBarButtonItem {
    UIBarButtonItem* resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed:)];
    [self.navigationItem setLeftBarButtonItem:resetButton];
    [resetButton release];
    UIBarButtonItem* applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(applyButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:applyButton];
    [applyButton release];
}

- (void)hideBarButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void)resetButtonPressed:(id)sender {
    [self.customerGroupDataManager resetDataList];
    [self.tableView reloadData];
    [self applyButtonPressed:nil];
    self.auxDetailViewController.title = @"All";
}

- (void)applyButtonPressed:(id)sender {
    NSMutableArray* resultList = [self.customerGroupDataManager applyButtonPressed];
    [self showDetailViewController:self.auxDetailViewController];
    self.auxDetailViewController.title = @"";
    [self.auxDetailViewController resetCustomer:resultList];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.groupType isEqualToString:@"Journey"]) {
        return [self.customerJourneyDataManager.displayList count];
    }
    return [self.customerGroupDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.groupType isEqualToString:[GlobalSharedClass shared].contactText] || [self.groupType isEqualToString:self.listTypeText]) {
        NSMutableDictionary* cellDict = [self.customerGroupDataManager.displayList objectAtIndex:indexPath.row];
        NSString* contactCellIdentifier = [self.tableCellFactory identifierWithData:cellDict];
        CustomerGroupBaseTableViewCell* baseCell = (CustomerGroupBaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:contactCellIdentifier];
        if(baseCell == nil) {
            baseCell = (CustomerGroupBaseTableViewCell*)[self.tableCellFactory createCustomerGroupBaseTableViewCellWithData:cellDict];
        }
        
        baseCell.actionDelegate = self;
        baseCell.indexPath = indexPath;
        baseCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [baseCell configCellWithData:cellDict];
        
        return baseCell;
    }
    NSString *CellIdentifier = @"IdGenericPlainTableCell";
    
    GenericPlainTableCell *cell=(GenericPlainTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"GenericPlainTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[GenericPlainTableCell class]] && [[(GenericPlainTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (GenericPlainTableCell *) nibItem;                
            }
        }
	}
    
    // Configure the cell...
    if ([self.groupType isEqualToString:@"Journey"]) {
        NSMutableDictionary* journeyDict = [self.customerJourneyDataManager.displayList objectAtIndex:indexPath.row];        
        cell.myTextLabel.text = [journeyDict objectForKey:@"JourneyDateText"];
        if([cell.myTextLabel.text isEqualToString:@"All"]) {
            cell.myImageView.image = [UIImage imageNamed:@"asterisk_orange.png"];
            cell.myImageView.alpha = 1.0;
        } else {
            if (self.journeyDefaultImage != nil) {
                cell.myImageView.image = self.journeyDefaultImage;                                
            } else {
                cell.myImageView.image = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];                
            }
            NSDate* tmpJourneyDate = [journeyDict objectForKey:@"JourneyActualDate"];                
            NSString* currentDateString = [ArcosUtils stringFromDate:[NSDate date] format:@"yyyyMMdd"];
            NSString* tmpJourneyDateString = [ArcosUtils stringFromDate:tmpJourneyDate format:@"yyyyMMdd"];
            NSNumber* currentDateNumber = [ArcosUtils convertStringToNumber:currentDateString];
            NSNumber* tmpJourneyDateNumber = [ArcosUtils convertStringToNumber:tmpJourneyDateString];
            if ([tmpJourneyDateNumber intValue] < [currentDateNumber intValue]) {
                cell.myImageView.alpha = [GlobalSharedClass shared].imageCellAlpha;
            } else {
                cell.myImageView.alpha = 1.0;
            }
        }
    }
    
    [cell configImageView];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomerBaseDetailViewController* baseDetailViewController;
    
    if ([self.groupType isEqualToString:@"Journey"]) {
        if (self.journeyDetailViewController == nil) {
            baseDetailViewController = (CustomerBaseDetailViewController*)self.myJourneyDetailViewController;
            self.journeyDetailViewController = baseDetailViewController;
            
        }else{
            baseDetailViewController = self.journeyDetailViewController;
        }
        self.auxJourneyIndexPath = indexPath;
        [self showDetailViewController:baseDetailViewController];
        [self processJourneyWithIndexPath:self.auxJourneyIndexPath];
        
        return;
    }
}
//segment buttons action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    switch (segment.selectedSegmentIndex) {
        case 0: {
            [self showBarButtonItem];
            self.groupType = self.listTypeText;
            [self.tableView reloadData];
        }
            break;
        case 1:{
            self.groupType = @"Journey";
            [self hideBarButtonItem];
            self.journeyDefaultImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[GlobalSharedClass shared].journeyDefaultImageIUR];
            NSMutableArray* journeyList = [[ArcosCoreData sharedArcosCoreData]allJourney];
            [self.customerJourneyDataManager processRawData:journeyList]; 
//            NSLog(@"self.customerJourneyDataManager.displayList: %@", self.customerJourneyDataManager.displayList);
            [self.tableView reloadData];
            int index = [self.customerJourneyDataManager getIndexWithDate:[NSDate date]];
            if (index != -1) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            }
        }
            break;
        case 2: {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - Split view controller delegate
/*
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Groups";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UINavigationController  *navigationController = [splitViewController.viewControllers objectAtIndex:1];
    UIViewController <SubstitutableDetailViewController> *detailViewController = [navigationController.viewControllers objectAtIndex:0]; 
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}
*/

-(void)showDetailViewController:(CustomerBaseDetailViewController*)baseDetailViewController {
    ArcosStackedViewController* arcosStackedViewController = (ArcosStackedViewController*)self.parentViewController.parentViewController.parentViewController;
    [arcosStackedViewController processMoveMasterViewController:CGPointMake(-1.0, 0)];
    [arcosStackedViewController popToRootNavigationController:NO];
    [arcosStackedViewController updateNavigationControllerContent:arcosStackedViewController.topVisibleNavigationController viewController:baseDetailViewController];
}

#pragma mark - check employee SecurityLevel
- (int)getEmployeeSecurityLevel {
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:[SettingManager employeeIUR]];
    NSNumber* securityLevel = [employeeDict objectForKey:@"SecurityLevel"];
    return [securityLevel intValue];
}

- (NSMutableArray*)contactDataGenerator:(NSMutableDictionary*)aDict {
    NSMutableArray* contactLocationObjectList = [[ArcosCoreData sharedArcosCoreData] contactLocationWithCOIUR:[aDict objectForKey:@"DescrDetailIUR"]];
    [self.customerGroupDataManager sortContactLocationResultList:contactLocationObjectList];
    return contactLocationObjectList;
}

#pragma mark CustomerGroupContactTableViewCellDelegate
- (void)selectCustomerGroupContactRecord:(UILabel *)aLabel indexPath:(NSIndexPath *)anIndexPath {
    self.customerGroupDataManager.currentIndexPath = anIndexPath;
    NSMutableDictionary* contactDict = [self.customerGroupDataManager.displayList objectAtIndex:anIndexPath.row];
    NSString* myDescrTypeCode = [contactDict objectForKey:@"DescrTypeCode"];
    NSMutableArray* aDataList = nil;
    if ([myDescrTypeCode isEqualToString:self.customerGroupDataManager.masterLocationDescrTypeCode]) {
        aDataList = [[ArcosCoreData sharedArcosCoreData] locationGroups];
    } else if ([myDescrTypeCode isEqualToString:self.customerGroupDataManager.locationTypesDescrTypeCode]) {
        aDataList = [[ArcosCoreData sharedArcosCoreData] locationTypes];
        int employeeSecurityLevel = [self getEmployeeSecurityLevel];
        if (employeeSecurityLevel < 99) {
            for (int i = 0; i < [aDataList count]; i++) {
                NSMutableDictionary* tmpDescrDetailDict = [aDataList objectAtIndex:i];
                NSString* tmpDescrDetailCode = [tmpDescrDetailDict objectForKey:@"DescrDetailCode"];
                if (tmpDescrDetailCode != nil && [tmpDescrDetailCode compare:@"WHOL" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                    [aDataList removeObjectAtIndex:i];
                    break;
                }
            }
        }
    } else if ([myDescrTypeCode isEqualToString:self.customerGroupDataManager.contactTypeDescrTypeCode]) {
        aDataList = [[ArcosCoreData sharedArcosCoreData] locationContactTypes];
    } else {
        aDataList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrCodeType:myDescrTypeCode];
    }
    NSString* aTitle = [contactDict objectForKey:@"Details"];
    NSMutableDictionary* answerDict = [contactDict objectForKey:@"Answer"];
    NSString* aParentContentString = [answerDict objectForKey:@"Detail"];
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateTableWidgetWithData:aDataList withTitle:aTitle withParentContentString:aParentContentString requestSource:TableWidgetRequestSourceMasterContact];
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}

- (void)selectCustomerGroupAccessTimesRecord:(UILabel *)aLabel indexPath:(NSIndexPath *)anIndexPath {
    self.customerGroupDataManager.currentIndexPath = anIndexPath;
    self.accessTimesWidgetViewController = [[[AccessTimesWidgetViewController alloc] initWithNibName:@"AccessTimesWidgetViewController" bundle:nil] autorelease];
    self.accessTimesWidgetViewController.actionDelegate = self;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:self.accessTimesWidgetViewController];
    self.thePopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];
    [tmpNavigationController release];
    self.thePopover.popoverContentSize = CGSizeMake(self.accessTimesWidgetViewController.view.bounds.size.width, self.accessTimesWidgetViewController.view.bounds.size.height + tmpNavigationController.navigationBar.frame.size.height);
    self.thePopover.delegate = self;
    [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)selectCustomerGroupNotSeenRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath {
    self.customerGroupDataManager.currentIndexPath = anIndexPath;
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.thePopover = [self.factory CreateDateWidgetWithDataSource:WidgetDataSourceNormalDate];
    
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}
- (void)selectCustomerGroupBuyingGroupRecord:(UILabel*)aLabel indexPath:(NSIndexPath*)anIndexPath {    
    self.customerGroupDataManager.currentIndexPath = anIndexPath;
    CustomerContactLinkHeaderViewController* CCLHVC = [[CustomerContactLinkHeaderViewController alloc] initWithNibName:@"CustomerContactLinkHeaderViewController" bundle:nil];
    CCLHVC.linkHeaderRequestSource = CustomerContactLinkHeaderRequestLocation;
    [CCLHVC processDisplayList];
    CustomerSelectionListingTableViewController* CSLTVC = [[CustomerSelectionListingTableViewController alloc] initWithNibName:@"CustomerSelectionListingTableViewController" bundle:nil];
    CSLTVC.selectionDelegate = self;
    CSLTVC.isNotShowingAllButton = YES;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CSLTVC];    
    self.thePopover = [[[UIPopoverController alloc] initWithContentViewController:tmpNavigationController] autorelease];
    self.thePopover.delegate = self;
    self.thePopover.popoverContentSize = CGSizeMake(700, 700);    
    [self.thePopover presentPopoverFromRect:aLabel.bounds inView:aLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    [CSLTVC resetCustomer:CCLHVC.locationList];
    [CSLTVC release];
    CSLTVC = nil;
    [tmpNavigationController release];
    tmpNavigationController = nil;
    [CCLHVC release];
}
#pragma mark CustomerSelectionListingDelegate
- (void)didDismissSelectionPopover {
    if (self.thePopover != nil && [self.thePopover isPopoverVisible]) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.thePopover = nil;
    }    
}

- (void)didSelectCustomerSelectionListingRecord:(NSMutableDictionary*)aCustDict {
    NSMutableDictionary* auxAnswerDict = [self.customerGroupDataManager processBuyingGroupResult:aCustDict];
    [self.customerGroupDataManager inputFinishedWithData:auxAnswerDict indexPath:self.customerGroupDataManager.currentIndexPath];
    [self.tableView reloadData];
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.thePopover = nil;
    }
}
#pragma mark AccessTimesWidgetViewControllerDelegate
- (void)accessTimesOperationDone:(NSMutableDictionary *)aWeekDayDict startTime:(NSDate *)aStartTime endTime:(NSDate *)anEndTime {
    NSMutableDictionary* tmpAnswerDict = [self.customerGroupDataManager processAccessTimesResult:aWeekDayDict startTime:aStartTime endTime:anEndTime];
    
    [self.customerGroupDataManager inputFinishedWithData:tmpAnswerDict indexPath:self.customerGroupDataManager.currentIndexPath];
    [self.tableView reloadData];
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.factory.popoverController = nil;
        self.accessTimesWidgetViewController = nil;
        self.thePopover = nil;
    }
}

#pragma mark WidgetViewControllerDelegate
- (void)operationDone:(id)data {
    NSMutableDictionary* tmpCellDict = [self.customerGroupDataManager.displayList objectAtIndex:self.customerGroupDataManager.currentIndexPath.row];
    NSString* tmpDescrTypeCode = [tmpCellDict objectForKey:@"DescrTypeCode"];
    if ([tmpDescrTypeCode isEqualToString:self.customerGroupDataManager.notSeenDescrTypeCode]) {
        data = [self.customerGroupDataManager processNotSeenResult:data];
    }
    
    [self.customerGroupDataManager inputFinishedWithData:data indexPath:self.customerGroupDataManager.currentIndexPath];
    [self.tableView reloadData];
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.factory.popoverController = nil;
        self.accessTimesWidgetViewController = nil;
        self.thePopover = nil;
    }
}
-(void)dismissPopoverController {
    if (self.thePopover != nil) {
        [self.thePopover dismissPopoverAnimated:YES];
        self.factory.popoverController = nil;
        self.accessTimesWidgetViewController = nil;
        self.thePopover = nil;
    }
}

#pragma mark 
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
    self.accessTimesWidgetViewController = nil;
}

- (void)processJourneyWithIndexPath:(NSIndexPath*)anIndexPath {
    NSMutableDictionary* aJourneyDict = [self.customerJourneyDataManager.displayList objectAtIndex:anIndexPath.row];
    self.myJourneyDetailViewController.title = [aJourneyDict objectForKey:@"JourneyDateText"];
    [self.customerJourneyDataManager getLocationsWithJourneyDict:aJourneyDict];
    [self.myJourneyDetailViewController resetTableList:[aJourneyDict objectForKey:@"JourneyDate"]];
}

@end
