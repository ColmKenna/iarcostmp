//
//  CustomerJourneyDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 16/10/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerJourneyDetailViewController.h"
#import "CustomerGroupViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@implementation CustomerJourneyDetailViewController
@synthesize customerJourneyDataManager = _customerJourneyDataManager;
//@synthesize actionPopoverController = _actionPopoverController;
@synthesize cjsdvc = _cjsdvc;
@synthesize actionButton = _actionButton;
@synthesize auxNavigationController = _auxNavigationController;
@synthesize checkLocationIURTemplateProcessor = _checkLocationIURTemplateProcessor;
@synthesize customerListingTableCellGeneratorDelegate = _customerListingTableCellGeneratorDelegate;
@synthesize customerJourneyDetailCallDataManager = _customerJourneyDetailCallDataManager;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.customerListingTableCellGeneratorDelegate = [[[CustomerJourneyDetailTableCellGenerator alloc] init] autorelease];
        self.customerJourneyDetailCallDataManager = [[[CustomerJourneyDetailCallDataManager alloc] init] autorelease];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.customerJourneyDataManager != nil) { self.customerJourneyDataManager = nil; }
//    if (self.actionPopoverController != nil) { self.actionPopoverController = nil; }
    if (self.cjsdvc != nil) { self.cjsdvc = nil; }
    if (self.actionButton != nil) { self.actionButton = nil; }
    if (self.auxNavigationController != nil) { self.auxNavigationController = nil; }
    self.checkLocationIURTemplateProcessor = nil;
    self.customerListingTableCellGeneratorDelegate = nil;
    self.customerJourneyDetailCallDataManager = nil;
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [ArcosUtils configEdgesForExtendedLayout:self];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List3.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithObjects:backButton, nil];
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    [backButton release];
    UIBarButtonItem* toggleListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleListButtonPressed:)];
    self.actionButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed:)] autorelease];
    NSMutableArray* buttonList = [NSMutableArray arrayWithObjects:toggleListButton, self.actionButton, nil];
    [self.navigationItem setRightBarButtonItems:buttonList];
    [toggleListButton release];
    
    self.cjsdvc = [[[CustomerJourneyStartDateViewController alloc] initWithNibName:@"CustomerJourneyStartDateViewController" bundle:nil] autorelease];
    self.cjsdvc.delegate = self;
    self.auxNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.cjsdvc] autorelease];
    self.auxNavigationController.preferredContentSize = CGSizeMake(700.0f, 360.0f);

//    self.actionPopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.auxNavigationController] autorelease];
//    self.actionPopoverController.popoverContentSize = CGSizeMake(700.0f, 360.0f);
    self.checkLocationIURTemplateProcessor = [[[CheckLocationIURTemplateProcessor alloc] initWithParentViewController:self] autorelease];
    self.checkLocationIURTemplateProcessor.delegate = self;
}

- (void)toggleListButtonPressed:(id)sender {
    NSArray* indexPathsVisibleRows = [self.tableView indexPathsForVisibleRows];
    if ([indexPathsVisibleRows count] > 0) {
        NSIndexPath* topIndexPath = [indexPathsVisibleRows firstObject];
        CustomerListingTableCell* tmpCustomerListingTableCell = [self.tableView cellForRowAtIndexPath:topIndexPath];
        self.customerJourneyDetailCallDataManager.textViewContentWidth = tmpCustomerListingTableCell.addressLabel.frame.size.width + 50 - 10;
//        NSLog(@"testccdd %@ %.2f", NSStringFromCGRect(tmpCustomerListingTableCell.addressLabel.frame), self.customerJourneyDetailCallDataManager.textViewContentWidth);
    }
    
    
    self.customerJourneyDetailCallDataManager.useCallTableCellFlag = !self.customerJourneyDetailCallDataManager.useCallTableCellFlag;
    if (self.customerJourneyDetailCallDataManager.useCallTableCellFlag) {
        self.customerListingTableCellGeneratorDelegate = [[[CustomerJourneyDetailCallTableCellGenerator alloc] init] autorelease];
        [self.customerJourneyDetailCallDataManager memoTextViewHeightProcessor];
    } else {
        self.customerListingTableCellGeneratorDelegate = [[[CustomerJourneyDetailTableCellGenerator alloc] init] autorelease];
    }
    
    [self.tableView reloadData];
}

- (void)callHeaderProcessor {
    [self.customerJourneyDetailCallDataManager callHeaderProcessorWithLocationIURList:[self.customerJourneyDataManager retrieveLocationIURList]];
    if (self.customerJourneyDetailCallDataManager.useCallTableCellFlag) {
        [self.customerJourneyDetailCallDataManager memoTextViewHeightProcessor];
    }
}

- (void)backButtonPressed:(id)sender {
    [self filterPressed:sender];
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
    [self.customerJourneyDataManager getLocationsWithJourneyDict:self.customerJourneyDataManager.currentJourneyDict];
    [self.tableView reloadData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.customerJourneyDetailCallDataManager.useCallTableCellFlag) {
        return 44.0;
    }
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    NSNumber* tmpLocationIUR = [aCust objectForKey:@"LocationIUR"];
    if ([self.customerJourneyDetailCallDataManager.callHeaderHashMap objectForKey:tmpLocationIUR] == nil) {
        return 44.0;
    }
    NSNumber* memoTextViewHeight = [self.customerJourneyDetailCallDataManager.memoTextViewHeightHashMap objectForKey:tmpLocationIUR];
    return 65.0 + 4.0 + [memoTextViewHeight floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.customerJourneyDataManager.sectionTitleList != nil) {
        return [self.customerJourneyDataManager.sectionTitleList count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.customerJourneyDataManager.locationListDict != nil) {
        NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:section];
        NSMutableArray* locationList = [self.customerJourneyDataManager.locationListDict objectForKey:sectionTitle];
        return [locationList count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{   // fixed font style. use custom view (UILabel) if you want something different
    if (self.customerJourneyDataManager.sectionTitleTextList != nil) {
        return [self.customerJourneyDataManager.sectionTitleTextList objectAtIndex:section];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//    }
    /*
    static NSString *CellIdentifier = @"IdCustomerJourneyDetailTableViewCell";
    
    CustomerJourneyDetailTableViewCell* cell = (CustomerJourneyDetailTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerJourneyDetailTableViewCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerJourneyDetailTableViewCell class]] && [[(CustomerJourneyDetailTableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerJourneyDetailTableViewCell *) nibItem;
            }
        }
    }
    */
    CustomerListingTableCell* cell = [self.customerListingTableCellGeneratorDelegate generateTableCellWithTableView:tableView];
    
    // Configure the cell...
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    cell.weekDayCallNumberLabel.text = [NSString stringWithFormat:@"%@:%@:%@", [aCust objectForKey:@"WeekNumber"], [aCust objectForKey:@"DayNumber"], [aCust objectForKey:@"CallNumber"]];
    for (UIGestureRecognizer* recognizer in cell.weekDayCallNumberLabel.gestureRecognizers) {
        [cell.weekDayCallNumberLabel removeGestureRecognizer:recognizer];
    }
    for (UIGestureRecognizer* recognizer in cell.contentView.gestureRecognizers) {
        [cell.contentView removeGestureRecognizer:recognizer];
    }
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [cell.contentView addGestureRecognizer:singleTap];
    
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [cell.weekDayCallNumberLabel addGestureRecognizer:doubleTap];
    [doubleTap release];
    [singleTap release];
    //Customer Name
    cell.nameLabel.text =[aCust objectForKey:@"Name"];    
    //Address
    if ([aCust objectForKey:@"Address1"]==nil) {
        [aCust setObject:@"" forKey:@"Address1"];
    }
    if ([aCust objectForKey:@"Address2"]==nil) {
        [aCust setObject:@"" forKey:@"Address2"];
    }
    if ([aCust objectForKey:@"Address3"]==nil) {
        [aCust setObject:@"" forKey:@"Address3"];
    }
    if ([aCust objectForKey:@"Address4"]==nil) {
        [aCust setObject:@"" forKey:@"Address4"];
    }
    if ([aCust objectForKey:@"Address5"]==nil) {
        [aCust setObject:@"" forKey:@"Address5"];
    }
    cell.addressLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[aCust objectForKey:@"Address1"],[aCust objectForKey:@"Address2"],[aCust objectForKey:@"Address3"],[aCust objectForKey:@"Address4"],[aCust objectForKey:@"Address5"]];

    [cell.locationStatusButton setImage:nil forState:UIControlStateNormal];
    [cell.creditStatusButton setImage:nil forState:UIControlStateNormal];
    NSNumber* locationStatusIUR = [aCust objectForKey:@"lsiur"];
    NSNumber* creditStatusIUR = [aCust objectForKey:@"CSiur"];
    NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithObjects:locationStatusIUR, creditStatusIUR, nil];
    NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:descrDetailIURList];
    NSMutableDictionary* descrDetailDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descrDetailDictList count]];
    for (int i = 0; i < [descrDetailDictList count]; i++) {        
        NSDictionary* auxDescrDetailDict = [descrDetailDictList objectAtIndex:i];
//        NSNumber* auxCodeType = [auxDescrDetailDict objectForKey:@"CodeType"];
//        if ([auxCodeType intValue] == 0) continue;
        NSNumber* auxDescrDetailIUR = [auxDescrDetailDict objectForKey:@"DescrDetailIUR"];
        NSNumber* auxImageIUR = [auxDescrDetailDict objectForKey:@"ImageIUR"];
        [descrDetailDictHashMap setObject:auxImageIUR forKey:auxDescrDetailIUR];
    }
    NSNumber* locationStatusImageIUR = [descrDetailDictHashMap objectForKey:locationStatusIUR];
    if ([locationStatusImageIUR intValue] != 0) {
        UIImage* locationStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:locationStatusImageIUR];
        if (locationStatusImage != nil) {
            [cell.locationStatusButton setImage:locationStatusImage forState:UIControlStateNormal];
        }
    }
    NSNumber* creditStatusImageIUR = [descrDetailDictHashMap objectForKey:creditStatusIUR];
    if ([creditStatusImageIUR intValue] != 0) {
        UIImage* creditStatusImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:creditStatusImageIUR];
        if (creditStatusImage != nil) {
            [cell.creditStatusButton setImage:creditStatusImage forState:UIControlStateNormal];
        }
    }
    
    NSNumber* auxLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [cell configCallInfoWithCallHeader:[self.customerJourneyDetailCallDataManager.callHeaderHashMap objectForKey:auxLocationIUR]];
    NSNumber* memoTextViewHeight = [self.customerJourneyDetailCallDataManager.memoTextViewHeightHashMap objectForKey:auxLocationIUR];
    cell.memoTextView.frame = CGRectMake(cell.memoTextView.frame.origin.x, cell.memoTextView.frame.origin.y, cell.memoTextView.frame.size.width, [memoTextViewHeight floatValue]);

    return cell;
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        NSMutableDictionary* aCust = [self getCustomerWithIndexPath:swipedIndexPath];
        [self.checkLocationIURTemplateProcessor checkLocationIUR:[aCust objectForKey:@"LocationIUR"] locationName:[aCust objectForKey:@"Name"] indexPath:swipedIndexPath];
    }
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer*)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.tableView];
        NSMutableDictionary* tmpJourneyLocationDict = [self getCustomerWithIndexPath:swipedIndexPath];
        CustomerJourneyDetailDateViewController* CJDDVC = [[CustomerJourneyDetailDateViewController alloc] initWithNibName:@"CustomerJourneyDetailDateViewController" bundle:nil];
        CJDDVC.customerJourneyDetailDateDataManager.journeyLocationDict = tmpJourneyLocationDict;
        if (@available(iOS 13.0, *)) {
            CJDDVC.modalInPresentation = YES;
        }
        CJDDVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        CJDDVC.actionDelegate = self;
        [self presentViewController:CJDDVC animated:YES completion:nil];
        [CJDDVC release];
    }
}

#pragma mark - CustomerJourneyDetailDateViewControllerDelegate
- (void)saveButtonPressedFromJourneyDetailDateWithJourneyIUR:(NSNumber *)aJourneyIUR {
    [self tapJourneyButtonProcessorWithJourneyIUR:aJourneyIUR];
}

- (void)cancelButtonPressedFromJourneyDetailDate {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeButtonPressedFromJourneyDetailDate {
    [self tapJourneyButtonProcessorFromRemoveButton];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:indexPath.section];
    NSMutableArray* orderQtyList = [self.customerJourneyDataManager.orderQtyListDict objectForKey:sectionTitle];
    NSNumber* orderQty = [orderQtyList objectAtIndex:indexPath.row];
    //0:no order 1:call 2:order
    if ([orderQty intValue] == 0) {
        cell.backgroundColor = [UIColor clearColor];
    } else if([orderQty intValue] == 1) {
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.64453125 blue:0.0 alpha:1.0];
    } else if ([orderQty intValue] == 2){
        cell.backgroundColor = [UIColor colorWithRed:0.59375 green:0.98046875 blue:0.59375 alpha:1.0]; 
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
//    [self.checkLocationIURTemplateProcessor checkLocationIUR:[aCust objectForKey:@"LocationIUR"] locationName:[aCust objectForKey:@"Name"] indexPath:indexPath];
    
    
}

-(void)resetTableList:(NSString*)aJourneyDate {
    [self.tableView reloadData];
    if ([aJourneyDate isEqualToString:@"All"]) {
        int sectionIndex = [self.customerJourneyDataManager getSectionIndexWithDate:[NSDate date]]; 
        if (sectionIndex != -1) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
}

- (void)resetTableListFromDateWheels:(NSString*)aJourneyDate journeyIUR:(NSNumber*)aJourneyIUR {
    [self.tableView reloadData];
    if ([aJourneyDate isEqualToString:@"All"]) {
        @try {
            NSIndexPath* tmpIndexPath = [self.customerJourneyDataManager retrieveIndexPathWithJourneyIUR:aJourneyIUR];
            [self.tableView scrollToRowAtIndexPath:tmpIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        } @catch (NSException *exception) {
            NSLog(@"%@", [exception reason]);
        }
    }
}
- (void)resetTableListFromDateWheelsRemoveButton:(NSString*)aJourneyDate {
    [self.tableView reloadData];
}

-(NSMutableDictionary*)getCustomerWithIndexPath:(NSIndexPath*)anIndexPath {
    NSString* sectionTitle = [self.customerJourneyDataManager.sectionTitleList objectAtIndex:anIndexPath.section];
    NSMutableArray* locationList = [self.customerJourneyDataManager.locationListDict objectForKey:sectionTitle];
    return [locationList objectAtIndex:anIndexPath.row];
}

#pragma mark ModelViewDelegate
- (void) didDismissModalView {
    
}

#pragma mark GenericRefreshParentContentDelegate
- (void) refreshParentContent {

}

- (void)refreshParentContentByEdit {

}

-(void)actionButtonPressed:(id)sender {
//    if ([self.actionPopoverController isPopoverVisible]) {
//        [self.actionPopoverController dismissPopoverAnimated:YES];
//    } else {
//        [self.actionPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
    self.auxNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.auxNavigationController.popoverPresentationController.barButtonItem = self.actionButton;
    self.auxNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:self.auxNavigationController animated:YES completion:nil];
}

#pragma mark CustomerJourneyStartDateDelegate
- (void)dismissJourneyStartDatePopoverController {
//    [self.actionPopoverController dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshParentContentForJourneyStartDate {
    //click the journey button
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
    groupViewController.segmentBut.selectedSegmentIndex = 1;
    [groupViewController.segmentBut sendActionsForControlEvents:UIControlEventValueChanged];
    groupViewController.segmentBut.selectedSegmentIndex = UISegmentedControlNoSegment;
    [groupViewController processJourneyWithIndexPath:groupViewController.auxJourneyIndexPath];
}

- (void)tapJourneyButtonProcessorFromRemoveButton {
    //click the journey button
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
    NSIndexPath* tmpIndexPath = [NSIndexPath indexPathForRow:groupViewController.auxJourneyIndexPath.row inSection:groupViewController.auxJourneyIndexPath.section];
    [groupViewController tapJourneyButtonPartialProcessor];
    groupViewController.auxJourneyIndexPath = tmpIndexPath;
    if (groupViewController.auxJourneyIndexPath.row > [groupViewController.customerJourneyDataManager.displayList count] - 1) {
        groupViewController.auxJourneyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [groupViewController processJourneyFromDateWheelsRemoveButtonWithIndexPath:groupViewController.auxJourneyIndexPath];
}

- (void)tapJourneyButtonProcessorWithJourneyIUR:(NSNumber *)aJourneyIUR {
    //click the journey button
    UINavigationController* tmpNavigationController = (UINavigationController*)self.rcsStackedController.myMasterViewController.masterViewController;
    
    CustomerGroupViewController* groupViewController = [tmpNavigationController.viewControllers objectAtIndex:0];
    NSIndexPath* tmpIndexPath = [NSIndexPath indexPathForRow:groupViewController.auxJourneyIndexPath.row inSection:groupViewController.auxJourneyIndexPath.section];
    [groupViewController tapJourneyButtonPartialProcessor];
    groupViewController.auxJourneyIndexPath = tmpIndexPath;
    if (groupViewController.auxJourneyIndexPath.row > [groupViewController.customerJourneyDataManager.displayList count] - 1) {
        groupViewController.auxJourneyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [groupViewController processJourneyFromDateWheelsWithIndexPath:groupViewController.auxJourneyIndexPath journeyIUR:aJourneyIUR];
}

-(NSMutableDictionary*)getSelectedCellData {
    return [self getCustomerWithIndexPath:self.currentIndexPath];
}

#pragma mark CheckLocationIURTemplateDelegate
- (void)succeedToCheckSameLocationIUR:(NSIndexPath*)indexPath {
    [GlobalSharedClass shared].startRecordingDate = [NSDate date];
    self.currentIndexPath = indexPath;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    CustomerInfoTableViewController* CITVC=[[CustomerInfoTableViewController alloc]initWithNibName:@"CustomerInfoTableViewController" bundle:nil];
    CITVC.refreshDelegate = self;
    CITVC.title = @"Customer Information Page";
    CITVC.custIUR=[aCust objectForKey:@"LocationIUR"];
    
    UINavigationController* CITVCNavigationController = [[UINavigationController alloc] initWithRootViewController:CITVC];
    [self.rcsStackedController pushNavigationController:CITVCNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController processSubMenuByCustomerListing:aCust reqSourceName:self.requestSourceName];
    [GlobalSharedClass shared].currentSelectedLocationIUR = [aCust objectForKey:@"LocationIUR"];
    [CITVC release];
    [CITVCNavigationController release];
}
- (void)succeedToCheckNewLocationIUR:(NSIndexPath*)indexPath {
    [self succeedToCheckSameLocationIUR:indexPath];
    [GlobalSharedClass shared].currentSelectedContactIUR = nil;
    [GlobalSharedClass shared].currentSelectedPackageIUR = nil;
    [GlobalSharedClass shared].packageViewCount = 0;
    NSMutableDictionary* aCust = [self getCustomerWithIndexPath:indexPath];
    [self resetCurrentOrderAndWholesaler:[aCust objectForKey:@"LocationIUR"]];
    [self configWholesalerLogo];
    [self syncCustomerContactViewController];
}
- (void)failToCheckLocationIUR:(NSString*)aTitle {
    if (self.currentIndexPath != nil) {
        [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    ArcosRootViewController* arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
    [arcosRootViewController.customerMasterViewController.selectedSubMenuTableViewController selectBottomRecordByTitle:aTitle];
}

@end
