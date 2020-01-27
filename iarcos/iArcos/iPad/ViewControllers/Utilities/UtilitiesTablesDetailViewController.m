//
//  UtilitiesTablesDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "UtilitiesTablesDetailViewController.h"
@interface UtilitiesTablesDetailViewController ()
-(void)clearGlobalNavigationController;
@end

@implementation UtilitiesTablesDetailViewController
@synthesize displayList = _displayList;
@synthesize tableHeader;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize mailController = _mailController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    if (self.displayList != nil) { self.displayList = nil; }        
    if (self.tableHeader != nil) { self.tableHeader = nil; }      
    if (self.globalNavigationController != nil) {
        self.globalNavigationController = nil;
    }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
    if (arcosCustomiseAnimation != nil) {
        [arcosCustomiseAnimation release];
    }
    if (self.mailController != nil) { self.mailController = nil; }
    
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
//    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem* emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailAttachment:)];
    [self.navigationItem setRightBarButtonItem:emailButton];
    [emailButton release];
    /*
    ArcosAppDelegate_iPad* arcosDelegate = [[UIApplication sharedApplication] delegate];
    UITabBarController* tabbar = (UITabBarController*) arcosDelegate.mainTabbarController;
    */
    self.rootView = [ArcosUtils getRootView];
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    arcosCustomiseAnimation.delegate = self;
    self.title = @"Tables";
    [self createDisplayList];    
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
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSString *CellIdentifier = @"IdUtilitiesTablesDetailTableCell";
    
    UtilitiesTablesDetailTableCell* cell=(UtilitiesTablesDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"UtilitiesTablesDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UtilitiesTablesDetailTableCell class]] && [[(UtilitiesTablesDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (UtilitiesTablesDetailTableCell *) nibItem;                
            }
        }
	}
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    cell.tableName.text = [cellData objectForKey:@"TableName"];
    cell.recordQuantity.text = [[cellData objectForKey:@"RecordQuantity"] stringValue];
    
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
    
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];

    GenericUITableViewController* genericUITableViewController = [[GenericUITableViewController alloc] initWithNibName:@"GenericUITableViewController" bundle:nil];
    genericUITableViewController.rootView = self.rootView;
    genericUITableViewController.title = [cellData objectForKey:@"TableName"];
    NSMutableArray* attrNameList = [cellData objectForKey:@"AttributeName"];
    NSMutableArray* attrNameTypeList = [NSMutableArray arrayWithCapacity:[attrNameList count]];
    genericUITableViewController.attrNameList = attrNameList;    
    
    NSMutableDictionary* attrDict = [cellData objectForKey:@"AttributeDict"];
    for (int i = 0; i < [attrNameList count]; i++) {
        NSAttributeDescription* attrDesc = [attrDict objectForKey:[attrNameList objectAtIndex:i]];
        [attrNameTypeList addObject:[attrDesc attributeValueClassName]];
    }
    genericUITableViewController.attrNameTypeList = attrNameTypeList;
    genericUITableViewController.displayList = [[ArcosCoreData sharedArcosCoreData] entityContent:[cellData objectForKey:@"TableName"]];
//    genericUITableViewController.parentCellData = cellData;
    genericUITableViewController.animateDelegate = self;
    genericUITableViewController.clearDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:genericUITableViewController] autorelease];
    [genericUITableViewController release];

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    
}

//- (void)didDismissModalView {
//    [self dismissModalViewControllerAnimated:YES];
//}

- (void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

- (void)emailAttachment:(id)sender {
    NSLog(@"email");
    NSString* fileName = @"iArcos.sqlite";
    NSString* filePath = [NSString stringWithFormat:@"%@/iArcos.sqlite", [FileCommon documentsPath]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        if ([FileCommon fileExistAtPath:filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:filePath];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:data fileName:fileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
            }            
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.rootView addChildViewController:self.globalNavigationController];
        [self.rootView.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.rootView];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
        return;
    }
    if (![MFMailComposeViewController canSendMail]) {        
        [ArcosUtils showMsg:@"Please set up a Mail account in order to send email" title:@"No Mail Account" delegate:nil];
        return;
    }
    self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailController.mailComposeDelegate = self;
    
    NSLog(@"filepath is: %@", filePath);
    if ([FileCommon fileExistAtPath:filePath]) {
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        [self.mailController addAttachmentData:data mimeType:@"application/x-sqlite3" fileName:@"iArcos.sqlite"];
//        [self.mailController setToRecipients:[NSArray arrayWithObject:@"Richard@stratait.ie"]];
        [self presentViewController:self.mailController animated:YES completion:nil];
    } else {
        [ArcosUtils showMsg:@"The file does not exist." delegate:nil];
    }    
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    UIAlertView* v = nil;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"Result: canceled";
            break;
            
        case MFMailComposeResultSaved:
            message = @"Result: saved";
            break;
            
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";            
//            v = [[UIAlertView alloc] initWithTitle:@"App Email" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [v show];
//            [v release];
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
            [v show];
            [v release];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
    NSLog(@"Email sending error message %@ ", message);
	[self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - clear table delegate

-(void)refreshClearTableOperation {
    [self createDisplayList];
    [self.tableView reloadData];
}

- (void)createDisplayList {
    self.displayList = [NSMutableArray array];    
    NSArray* entityList = [[ArcosCoreData sharedArcosCoreData] allEntities];
    for (int i = 0; i < [entityList count]; i++) {
        NSEntityDescription* entity = [entityList objectAtIndex:i];
        NSString* entityName = [entity name];
        NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
        [cellData setObject:entityName forKey:@"TableName"];
        NSNumber* recordQuantity = [[ArcosCoreData sharedArcosCoreData] entityRecordQuantity:entityName];
        [cellData setObject:recordQuantity forKey:@"RecordQuantity"];
        
        NSDictionary* attrDict = [entity attributesByName];
        NSArray* allAttrKeys = [attrDict allKeys];
        [cellData setObject:allAttrKeys forKey:@"AttributeName"];
        [cellData setObject:attrDict forKey:@"AttributeDict"];     
        
        
        [self.displayList addObject:cellData];        
    }
}

-(void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
}

#pragma mark ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}


@end
