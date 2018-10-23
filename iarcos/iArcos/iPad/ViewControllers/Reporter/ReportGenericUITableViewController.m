//
//  ReportGenericUITableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 17/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportGenericUITableViewController.h"
#import "ArcosAppDelegate_iPad.h"


@implementation ReportGenericUITableViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize customiseTableHeaderView;
@synthesize customiseScrollView;
@synthesize parentCellData;
@synthesize cellWidth,cellHeight;
@synthesize attrNameList;
@synthesize attrNameTypeList;
@synthesize attrDict;
@synthesize customiseTableView;
@synthesize displayList = _displayList;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.customiseTableHeaderView != nil) { self.customiseTableHeaderView = nil; }
    if (self.customiseScrollView != nil) {
        self.customiseScrollView = nil;
    }
    if (self.parentCellData != nil) { self.parentCellData = nil; }
    if (self.attrNameList != nil) {
        self.attrNameList = nil;
    }
    if (self.attrNameTypeList != nil) {
        self.attrNameTypeList = nil;
    }
    if (self.attrDict != nil) {
        self.attrDict = nil;
    }
    if (self.customiseTableView != nil) {
        self.customiseTableView = nil;
    }
    if (self.displayList != nil) {
        self.displayList = nil;
    }
    if (arcosCustomiseAnimation != nil) {
        [arcosCustomiseAnimation release];
    }
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }    
    if (self.rootView != nil) { self.rootView = nil; }
    
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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    
    [self.navigationItem setLeftBarButtonItem:backButton];     
    
    [backButton release];
    
    self.cellWidth = 128;
    self.cellHeight = 44;
    //    self.attrNameList = [self.parentCellData objectForKey:@"AttributeName"];
    //    self.attrDict = [self.parentCellData objectForKey:@"AttributeDict"];
    //    self.displayList = [[ArcosCoreData sharedArcosCoreData] entityContent:[self.parentCellData objectForKey:@"TableName"]];
    /*
    ArcosAppDelegate_iPad* arcosDelegate = [[UIApplication sharedApplication] delegate];
    UITabBarController* tabbar = (UITabBarController*) arcosDelegate.mainTabbarController;
    */
    
    self.rootView = [ArcosUtils getRootView];
    
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //    self.customiseTableHeaderView = nil;
    self.customiseScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    NSLog(@"shouldAutorotateToInterfaceOrientation");
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    /**    
     NSLog(@"customiseScrollView.frame.size.width: %f", customiseScrollView.frame.size.width);
     float totalCellWidth = self.cellWidth * [self.attrNameList count];
     float customiseWidth = self.customiseScrollView.frame.size.width > totalCellWidth ? self.customiseScrollView.frame.size.width : totalCellWidth;
     self.customiseScrollView.contentSize = CGSizeMake(customiseWidth, self.view.frame.size.height);
     
     self.customiseTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, customiseWidth, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
     //    self.customiseTableView.allowsSelection = NO;
     //    self.customiseTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
     self.customiseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     self.customiseTableView.delegate = self;
     self.customiseTableView.dataSource = self;
     
     [self.customiseScrollView addSubview:self.customiseTableView];
     self.customiseTableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customiseScrollView.contentSize.width, self.cellHeight)] autorelease];
     self.customiseTableHeaderView.backgroundColor = [UIColor darkGrayColor];
     for (int i = 0; i < [self.attrNameList count]; i++) {
     CGFloat xOrigin = i * self.cellWidth;
     UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, self.cellWidth, self.cellHeight)];
     headerLabel.textAlignment = UITextAlignmentCenter;
     headerLabel.text = [self.attrNameList objectAtIndex:i];
     headerLabel.backgroundColor = [UIColor clearColor];
     [headerLabel setTextColor:[UIColor whiteColor]];
     [headerLabel setFont:[UIFont fontWithName:@"Helvetica" size:17.0f]];
     [self.customiseTableHeaderView addSubview:headerLabel];
     [headerLabel release];
     }
     
     self.customiseScrollView.pagingEnabled = YES;
     */ 
    
    //    NSLog(@"self.customiseScrollView.contentInset %f, %f, %f, %f", self.customiseScrollView.scrollIndicatorInsets.top,self.customiseScrollView.scrollIndicatorInsets.left,self.customiseScrollView.scrollIndicatorInsets.bottom,self.customiseScrollView.scrollIndicatorInsets.right);
    //    self.customiseScrollView.bounds = CGRectMake(0, 0, self.cellWidth, self.customiseScrollView.frame.size.height);
    //    self.customiseScrollView.clipsToBounds = NO;
    NSLog(@"viewWillAppear with rotaion.");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"customiseScrollView.frame.size.width: %f", customiseScrollView.frame.size.width);
    float totalCellWidth = self.cellWidth * [self.attrNameList count];
    float customiseWidth = self.customiseScrollView.frame.size.width > totalCellWidth ? self.customiseScrollView.frame.size.width : totalCellWidth;
    self.customiseScrollView.contentSize = CGSizeMake(customiseWidth, self.view.frame.size.height);
    if (customiseWidth < 1024) {
        customiseWidth = 1024;
    }
    self.customiseTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, customiseWidth, self.view.frame.size.height) style:UITableViewStylePlain] autorelease];
    //    self.customiseTableView.allowsSelection = NO;
    //    self.customiseTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight  | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.customiseTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.customiseTableView.delegate = self;
    self.customiseTableView.dataSource = self;
    
    [self.customiseScrollView addSubview:self.customiseTableView];
    self.customiseTableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.customiseScrollView.contentSize.width, self.cellHeight)] autorelease];
    self.customiseTableHeaderView.backgroundColor = [UIColor darkGrayColor];
    for (int i = 0; i < [self.attrNameList count]; i++) {
        CGFloat xOrigin = i * self.cellWidth;
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 0, self.cellWidth, self.cellHeight)];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.text = [self.attrNameList objectAtIndex:i];
        headerLabel.backgroundColor = [UIColor clearColor];
        [headerLabel setTextColor:[UIColor whiteColor]];
        [headerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.customiseTableHeaderView addSubview:headerLabel];
        [headerLabel release];
    }
    
    self.customiseScrollView.pagingEnabled = YES;
    
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

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    return self.customiseTableHeaderView;
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
    static NSString *CellIdentifier = @"Cell";
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    //    }
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    // Configure the cell...    
    NSMutableDictionary* recordCellData = [self.displayList objectAtIndex:indexPath.row];
    //    NSDictionary* attrDict = [self.parentCellData objectForKey:@"AttributeDict"];
    
    
    for (int i = 0; i < [self.attrNameList count]; i++) {
        //        NSAttributeDescription* attrDesc = [self.attrDict objectForKey:[self.attrNameList objectAtIndex:i]];
        //        NSString* attrType = [attrDesc attributeValueClassName];
        NSString* attrNameType = [self.attrNameTypeList objectAtIndex:i];
        CGFloat xOrigin = i * self.cellWidth;
        cell.frame = CGRectMake(0, 0, self.customiseScrollView.contentSize.width, 44);
        UILabel* cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin, 11, self.cellWidth, 21)];        
        cellLabel.textAlignment = NSTextAlignmentCenter;
        cellLabel.text = [ArcosUtils convertToString:[recordCellData objectForKey:[self.attrNameList objectAtIndex:i]] fieldType:attrNameType];
        [cellLabel setTextColor:[UIColor blackColor]];
        [cellLabel setFont:[UIFont systemFontOfSize:17.0f]];
        
        [cell addSubview:cellLabel];
        [cellLabel release];
    }
    
    return cell;
}


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
    
    NSLog(@"GenericUITableDetailViewController is clicked.");
    GenericUITableDetailViewController* cuitdvc = [[GenericUITableDetailViewController alloc] initWithNibName:@"GenericUITableDetailViewController" bundle:nil];
    cuitdvc.title = [NSString stringWithFormat:@"%@ Details", [ArcosUtils convertNilToEmpty:self.title]];
    cuitdvc.attrNameList = self.attrNameList;
    cuitdvc.attrNameTypeList = self.attrNameTypeList;
    //    cuitdvc.attrDict = self.attrDict;
    cuitdvc.animateDelegate = self;
    cuitdvc.recordCellData = [self.displayList objectAtIndex:indexPath.row];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cuitdvc] autorelease];
    
    [cuitdvc release];
    [self.customiseTableView deselectRowAtIndexPath:indexPath animated:YES];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    
    
}

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}


-(void)insertRow:(NSMutableDictionary*)rowData{
    [self.displayList addObject:rowData];    
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:[self.displayList count] inSection:0];
    [self.customiseTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
}


@end
