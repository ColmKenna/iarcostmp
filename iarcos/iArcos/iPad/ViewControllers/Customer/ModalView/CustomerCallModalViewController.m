//
//  CustomerCallModalViewController.m
//  Arcos
//
//  Created by David Kilmartin on 01/12/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerCallModalViewController.h"
@interface CustomerCallModalViewController()
-(void)clearGlobalNavigationController;
@end

@implementation CustomerCallModalViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize tableHeader;
@synthesize displayList;
@synthesize locationIUR;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize locationDefaultContactIUR = _locationDefaultContactIUR;

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
    self.tableHeader = nil;
    self.displayList = nil;
    self.locationIUR = nil;
    [callGenericServices release];
//    [activityIndicator release];
    [arcosCustomiseAnimation release];
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; } 
    if (self.rootView != nil) { self.rootView = nil; }
    if (connectivityCheck != nil) { [connectivityCheck release]; }
    if (self.locationDefaultContactIUR != nil) { self.locationDefaultContactIUR = nil; }
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
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(closePressed:)];
    [self.navigationItem setLeftBarButtonItem:closeButton];
    [closeButton release];
/*    
    UIBarButtonItem *totalsButton = [[UIBarButtonItem alloc] initWithTitle:@"Totals" style:UIBarButtonItemStyleBordered target:self action:@selector(totalsPressed:)];
    [self.navigationItem setLeftBarButtonItem:totalsButton];
    [totalsButton release];
*/    
//    activityIndicator = [ArcosUtils initActivityIndicatorWithView:self.view];
//    [activityIndicator startAnimating];
            
    

    callGenericServices = [[CallGenericServices alloc] initWithView:self.navigationController.view];
    callGenericServices.delegate = self;
    
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    arcosCustomiseAnimation.delegate = self;
    //set the notification
/**    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    //init a connectivity check
    connectivityCheck = [[ConnectivityCheck alloc]init];
    [connectivityCheck statusLog];
*/
    
    NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,CONVERT(VARCHAR(10),Date,103),Name,Employee,Type,Value from callview where LocationIUR = %@ order by date desc", self.locationIUR];
    if (self.locationDefaultContactIUR != nil) {
        sqlStatement = [NSString stringWithFormat:@"select IUR,CONVERT(VARCHAR(10),Date,103),Name,Employee,Type,Value from callview where LocationIUR = %@ or ContactIUR = %@ order by date desc", self.locationIUR, self.locationDefaultContactIUR];
    }
//    NSLog(@"sqlStatement: %@",sqlStatement);
    [callGenericServices getData: sqlStatement];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableHeader = nil;
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
    return tableHeader;
    
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
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }

    NSString *CellIdentifier = @"IdCustomerCallTableCell";
    
    CustomerCallTableCell *cell=(CustomerCallTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerCallTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerCallTableCell class]] && [[(CustomerCallTableCell *)nibItem reuseIdentifier] isEqualToString: @"IdCustomerCallTableCell"]) {
                cell= (CustomerCallTableCell *) nibItem;
                
                //cell.delegate=self;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                
                [singleTap release];
                
                
            }
        }
	}    
    
    // Configure the cell...
    
    
//    cell.text = [self.displayList objectAtIndex:indexPath.row];
    ArcosGenericClass* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.IUR = [cellData Field1];
    cell.date.text = [ArcosUtils convertDatetimeToDate:[cellData Field2]];
    cell.contact.text = [cellData Field3];
    cell.employee.text = [cellData Field4];
    cell.typeOfCall.text = [cellData Field5];
    cell.value.text = [NSString stringWithFormat:@"%.2f", [[cellData Field6] floatValue]];
    
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
}

-(void)closePressed:(id)sender {
    NSLog(@"closePressed is pressed");
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

-(void)totalsPressed:(id)sender {
    NSLog(@"totalsPressed is pressed");
    //    [activityIndicator stopAnimating];
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender {
    NSLog(@"handleSingleTapGesture");
//    CustomerCallTableCell* cell = (CustomerCallTableCell*)sender.view.superview;
//    NSLog(@"call iur is %@", cell.IUR);
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:sender tableview:self.tableView];
        CustomerCallTableCell* cell = (CustomerCallTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        CustomerCallDetailViewController* ccdmvc=[[CustomerCallDetailViewController alloc]initWithNibName:@"CustomerCallDetailViewController" bundle:nil];
        ccdmvc.animateDelegate=self;
        ccdmvc.IUR = cell.IUR;
        ccdmvc.title = @"CALL DETAILS";
        
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccdmvc] autorelease];
        [ccdmvc release];
        
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    }
    
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}

- (void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    NSLog(@"set result happens in customer call");
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        self.displayList = result.ArrayOfData;
        [self.tableView reloadData];        
    } else if(result.ErrorModel.Code <= 0) {
        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:self];
        
    }
//    [activityIndicator stopAnimating];
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
        NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,Date,Name,Employee,Type,Value from callview where LocationIUR = %@ order by date desc", self.locationIUR];
        [callGenericServices getData: sqlStatement];
    } else {
        [check stop];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
//        [activityIndicator stopAnimating];
        [ArcosUtils showMsg:check.errorString  delegate:nil];
    }        
}
*/

@end
