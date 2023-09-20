//
//  CustomerNotBuyModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 14/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyModalViewController.h"
#import "ArcosRootViewController.h"
@interface CustomerNotBuyModalViewController ()

-(void)clearGlobalNavigationController;

@end

@implementation CustomerNotBuyModalViewController

@synthesize animateDelegate = _animateDelegate;
@synthesize notBuyHeaderView = _notBuyHeaderView;
@synthesize displayList;
@synthesize locationIUR;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize formDetailList = _formDetailList;
@synthesize formButton;
@synthesize defaultFormIUR = _defaultFormIUR;
@synthesize parentContentString = _parentContentString;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize currentProductLevel = _currentProductLevel;
@synthesize isFirstLevel = _isFirstLevel;
@synthesize levelCode = _levelCode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{    
    self.notBuyHeaderView = nil;
    if (self.displayList != nil) { self.displayList = nil; }        
    if (self.locationIUR != nil) { self.locationIUR = nil; }                    
    if (connectivityCheck != nil) { [connectivityCheck release]; }
    if (callGenericServices != nil) { [callGenericServices release]; }    
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    if (self.formDetailList != nil) { self.formDetailList = nil; }    
    if (self.formButton != nil) { self.formButton = nil; }           
    if (self.defaultFormIUR != nil) { self.defaultFormIUR = nil; }
    if (self.parentContentString != nil) { self.parentContentString = nil; }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
    [arcosCustomiseAnimation release];
    self.currentProductLevel = nil;
    self.levelCode = nil;
        
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
    
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
//    [self.navigationItem setLeftBarButtonItem:closeButton];
//    [closeButton release];
    
//    self.formButton = [[[UIBarButtonItem alloc] initWithTitle:@"Form" style:UIBarButtonItemStylePlain target:self action:@selector(formPressed:)] autorelease];
//    [self.navigationItem setRightBarButtonItem:self.formButton];
    
    
    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    
//    NSString* sqlStatement = [NSString stringWithFormat:@"select ProductCode,Description, [Last Ordered] from LocationNotOrdered where LocationIUR = %@ order by 'Last Ordered' desc", self.locationIUR];
//    [callGenericServices getData: sqlStatement];
    if (self.isFirstLevel) {
//        NSDictionary* configDict = [[ArcosCoreData sharedArcosCoreData] configWithIUR:[NSNumber numberWithInt:0]];
//        self.currentProductLevel = [configDict objectForKey:@"DefaultProductLevel"];
        self.currentProductLevel = [NSNumber numberWithInt:5];
        NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"NOTB"];
        if ([objectList count] > 0) {
            NSDictionary* descrDetailDict = [objectList objectAtIndex:0];
            NSString* detail = [descrDetailDict objectForKey:@"Detail"];
            if ([ArcosValidator isInteger:detail]) {
                self.currentProductLevel = [ArcosUtils convertStringToNumber:detail];
            }
        }
//        self.currentProductLevel = ([self.currentProductLevel intValue] == 0) ? [NSNumber numberWithInt:6] : self.currentProductLevel;
        [callGenericServices genericNotBuy:[self.locationIUR intValue] Level:[self.currentProductLevel intValue] LevelCode:@"" filterLevel:[self.currentProductLevel intValue] action:@selector(setGenericNotBuyResult:) target:self];
    } else {
//        [callGenericServices genericNotBuy:[self.locationIUR intValue] Level:[self.currentProductLevel intValue] LevelCode:self.levelCode action:@selector(setGenericNotBuyResult:) target:self];
    }
    
    
    
    self.factory = [WidgetFactory factory];
    self.factory.delegate = self;
    self.formDetailList = [[ArcosCoreData sharedArcosCoreData] formDetail];    
    self.defaultFormIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:7];
    self.parentContentString = [self formDetailDescWithFormIUR:self.defaultFormIUR];
//    NSLog(@"parentContentString is %@", self.parentContentString);
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
//    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
//    arcosCustomiseAnimation.delegate = self;
}

-(void)startCallService {
//    [connectivityCheck statusLog];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return self.notBuyHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.displayList != nil) {
        return [self.displayList count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"IdCustomerNotBuyTableCell";
    
    CustomerNotBuyTableCell *cell=(CustomerNotBuyTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerNotBuyTableCell" owner:self options:nil];
        
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerNotBuyTableCell class]] && [[(CustomerNotBuyTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerNotBuyTableCell *) nibItem;
                
                //cell.delegate=self;                             
                
            }
        }
	}        
    
    // Configure the cell...  
    
    
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
//    cell.productCode.text = [ArcosUtils trim:[cellData Field1]];
    cell.description.text = [cellData Field2];    
//    cell.lastOrdered.text = [ArcosUtils convertDatetimeToDate:[cellData Field3]];
    if ([self.currentProductLevel intValue] + 1 <= 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    if ([self.currentProductLevel intValue] + 1 > 6) return;
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    CustomerNotBuyDetailTableViewController* cnbdtvc =[[CustomerNotBuyDetailTableViewController alloc]initWithNibName:@"CustomerNotBuyDetailTableViewController" bundle:nil];            
    cnbdtvc.levelCode = [ArcosUtils trim:[cellData Field1]];
    cnbdtvc.locationIUR = self.locationIUR;
    cnbdtvc.filterLevel = self.currentProductLevel;
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cnbdtvc];
    [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
    [cnbdtvc release];
    [tmpNavigationController release];    
    
    /*
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    CustomerNotBuyModalViewController* cnbmvc =[[CustomerNotBuyModalViewController alloc]initWithNibName:@"CustomerNotBuyModalViewController" bundle:nil];
    cnbmvc.animateDelegate=self;
    cnbmvc.title = self.title;
    cnbmvc.currentProductLevel = [NSNumber numberWithInt:[self.currentProductLevel intValue] + 1];
    cnbmvc.levelCode = [ArcosUtils trim:[cellData Field1]];
    cnbmvc.locationIUR = self.locationIUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cnbmvc] autorelease];
    [cnbmvc release];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    */
}

-(void)closePressed:(id)sender {
//    NSLog(@"closePressed is pressed");
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}


#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer not buy");
    if (result == nil) {
//        [activityIndicator stopAnimating];
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];        
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
//    [activityIndicator stopAnimating];
//    [HUD hide:YES];
}

-(void)setGenericNotBuyResult:(ArcosGenericReturnObject*) result {
    result = [callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
    }
}

//connectivity notification back
/**
-(void)connectivityChanged: (NSNotification* )note{    
    ConnectivityCheck* check = [note object];    
    if (check != connectivityCheck) {
        return;
    }
    
    if (check.serviceCallAvailable) {
        NSLog(@"enter into the check connection.");
        [check stop];        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        NSString* sqlStatement = [NSString stringWithFormat:@"select ProductCode,Description, [Last Ordered] from LocationNotOrdered where LocationIUR = %@ order by 'Last Ordered' desc", self.locationIUR];
        [callGenericServices getData: sqlStatement];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}
*/

-(void)formPressed:(id)sender {
//    if ([self.thePopover isPopoverVisible]) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    } else {
//
//    }
    self.globalWidgetViewController = [self.factory CreateTableWidgetWithData:self.formDetailList withTitle:@"Form" withParentContentString:self.parentContentString];
    //do show the popover if there is no data
//    self.thePopover.delegate = self;
//    [self.thePopover presentPopoverFromBarButtonItem:self.formButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.globalWidgetViewController.popoverPresentationController.barButtonItem = self.formButton;
    self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
}

-(NSString*)formDetailDescWithFormIUR:(NSNumber*)anFormIUR {
    for (int i = 0; i < [self.formDetailList count]; i++) {
        NSMutableDictionary* cellData = [self.formDetailList objectAtIndex:i];
        NSComparisonResult result = [[cellData objectForKey:@"IUR"] compare:anFormIUR];
        if (result == NSOrderedSame) {
            return [cellData objectForKey:@"Title"];            
        }        
    }
    return nil;
}

-(void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@", data);
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

-(void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
//    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

@end
