//
//  DetailingTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/10/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "DetailingTableViewController.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@interface DetailingTableViewController (Private)
-(BOOL)checkBasicInfo;
-(BOOL)checkDetailing;
-(BOOL)checkKeyMessage;
-(BOOL)checkSample;
-(BOOL)checkPromotionalItems;
-(BOOL)checkPresenter;
-(BOOL)saveCalltrans;
-(void)fillTheExsitDetailing;
-(void)stampLocation;
-(void)fillDetailingByCalltranList:(NSMutableArray*)aCallTranList;
-(void)fillRemoteDetailing;
- (void)alertViewCallBack;
@end

@implementation DetailingTableViewController
@synthesize requestSource = _requestSource;
@synthesize detailingSelections;
@synthesize detailingSelectionNames;
@synthesize cellFactory;
//@synthesize tablecellPopover = _tablecellPopover;
@synthesize orderHeader;
@synthesize calltrans;
@synthesize orderNumber;
@synthesize isEditable;
@synthesize CLController;
@synthesize locationDefaultContactIUR = _locationDefaultContactIUR;
@synthesize locationIUR = _locationIUR;
@synthesize locationName = _locationName;
@synthesize detailingDataManager = _detailingDataManager;
@synthesize rootView = _rootView;
//@synthesize arcosConfigDataManager = _arcosConfigDataManager;
@synthesize coordinateType = _coordinateType;
@synthesize custNameHeaderLabel = _custNameHeaderLabel;
@synthesize custAddrHeaderLabel = _custAddrHeaderLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.detailingDataManager = [[[DetailingDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.detailingSelections = nil;
    self.detailingSelectionNames = nil;
    self.cellFactory = nil;
//    self.tablecellPopover = nil;
    self.orderHeader = nil;
    self.calltrans = nil;
    self.orderNumber = nil;
    self.CLController = nil;
    if (self.locationDefaultContactIUR != nil) { self.locationDefaultContactIUR = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil; }
    if (self.locationName != nil) { self.locationName = nil; }
    self.detailingDataManager = nil;
    self.rootView = nil;
//    self.arcosConfigDataManager = nil;
    self.coordinateType = nil;
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
    self.custNameHeaderLabel = nil;
    self.custAddrHeaderLabel = nil;
    
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
    //core location controller
//    self.arcosConfigDataManager = [[[ArcosConfigDataManager alloc] init] autorelease];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
    self.CLController = [[[CoreLocationController alloc] init] autorelease];
    self.CLController.delegate = self;
    
    [self.detailingDataManager createBasicData];
    
    //add save button to the navigation bar
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Save"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(saveOrder)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    self.tableView.allowsSelection=NO;
    
    NSMutableArray* basicInfo = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.basicInfoKey];
    if (self.orderNumber!=nil) {
        if ([self.coordinateType intValue] == 0) {
            [self fillTheExsitDetailing];
        } else if ([self.coordinateType intValue] == 1){
            [self fillRemoteDetailing];
        }
    } else {//get the default call type from setting
        NSNumber* callTypeNumber = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:2];
//        NSLog(@"default callTypeNumber: %@", callTypeNumber);
        if ([callTypeNumber intValue] != 0) {
            NSMutableArray* descrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrDetailIUR:callTypeNumber];
            if ([descrDetailDictList count] > 0) {
                NSDictionary* tmpDescrDetailDict = [descrDetailDictList objectAtIndex:0];
                NSMutableDictionary* descrDetailDict = [NSMutableDictionary dictionaryWithDictionary:tmpDescrDetailDict];
                [descrDetailDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
                if ([descrDetailDict objectForKey:@"Detail"] == nil) {
                    [descrDetailDict setObject:@"Not Defined" forKey:@"Title"];
                }else{
                    [descrDetailDict setObject:[descrDetailDict objectForKey:@"Detail"] forKey:@"Title"];
                }
                NSMutableDictionary* basicInfoDict = [basicInfo objectAtIndex:0];
                NSMutableDictionary* MData = [basicInfoDict objectForKey:@"data"];
                if (MData == nil) {
                    MData = [NSMutableDictionary dictionary];
                }
                [MData setObject:descrDetailDict forKey:@"CallType"];
                [MData setObject:[NSDate date] forKey:@"OrderDate"];
                [basicInfoDict setObject:MData forKey:@"data"];
            }
        }
        NSMutableArray* invoiceRefList = [NSMutableArray arrayWithCapacity:4];
        [invoiceRefList addObject:@""];
        [invoiceRefList addObject:[NSNumber numberWithInt:0]];
        [invoiceRefList addObject:[NSNumber numberWithInt:0]];
        [invoiceRefList addObject:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateFormat]];
        NSMutableDictionary* basicInfoDict = [basicInfo objectAtIndex:0];
        NSMutableDictionary* MData = [basicInfoDict objectForKey:@"data"];
        if (MData == nil) {
            MData = [NSMutableDictionary dictionary];
        }
        [MData setObject:invoiceRefList forKey:@"invoiceRef"];
        [basicInfoDict setObject:MData forKey:@"data"];
    }
    
    //get a factory
    self.cellFactory=[DetailingTableCellFactory factory];
    self.cellFactory.actionType = self.detailingDataManager.actionType;
    //init array of call trans
    self.calltrans=[[[ArcosArrayOfCallTran alloc]init] autorelease];
    
    //disable the back button
    self.navigationItem.hidesBackButton=YES;
    
    //change the back button title
    if (self.requestSource == DetailingRequestSourceListings) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
        self.navigationItem.leftBarButtonItem = backButton;
        [backButton release];
    }
    
    
    anySampleOrQA=NO;
//    if (self.locationDefaultContactIUR != nil) {
//        NSMutableDictionary* basicInfoDict = [basicInfo objectAtIndex:0];
//        NSMutableArray* contacts = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:self.locationDefaultContactIUR];
//        if ([contacts count]>0 && contacts!=nil) {
//            NSMutableDictionary* newDict = [NSMutableDictionary dictionaryWithDictionary:[contacts objectAtIndex:0]];
//            
//            NSString* fullName = [ArcosUtils contactFullName:newDict];
//            NSLog(@"full name of contact is %@",fullName);
//            
//            [newDict setObject:fullName forKey:@"Title"];
//            [newDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsDefault"];
//            NSMutableDictionary* MData = [basicInfoDict objectForKey:@"data"];
//            if (MData == nil) {
//                MData = [NSMutableDictionary dictionary];
//            }
//            [MData setObject:newDict forKey:@"Contact"];
//            [basicInfoDict setObject:MData forKey:@"data"];
//        }
//    }
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
    if ([ArcosSystemCodesUtils logoOptionExistence]) {
        UIImage* tmpImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
        if (tmpImage != nil) {
            self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:tmpImage] autorelease];
            self.tableView.backgroundView.alpha = 0.15;
        }
    } else {
        self.tableView.backgroundView = nil;
    }
//    [ArcosUtils handleSeparatorTableView:self.tableView];
    CGRect viewRect = CGRectMake(0, 0, 0, 0);
    UIView* myView = [[[UIView alloc] initWithFrame:viewRect] autorelease];
    if ([myView respondsToSelector:@selector(tintColor)]) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if (self.orderNumber == nil) {//create call entry
        [self.detailingDataManager refreshContactField];
        [self.tableView reloadData];
    }
    if (self.requestSource == DetailingRequestSourceCall) {
        if (self.custNameHeaderLabel == nil) {
            self.custNameHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 1, 550.0, 26.0)] autorelease];
            self.custNameHeaderLabel.textColor = [UIColor whiteColor];
            self.custNameHeaderLabel.font = [UIFont boldSystemFontOfSize:17.0];
        }
        self.custNameHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
        [self.navigationController.navigationBar addSubview:self.custNameHeaderLabel];
        if (self.custAddrHeaderLabel == nil) {
            self.custAddrHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 28, 550.0, 14.0)] autorelease];
            self.custAddrHeaderLabel.font = [UIFont systemFontOfSize:12.0];
            self.custAddrHeaderLabel.textColor = [UIColor whiteColor];
        }
        self.custAddrHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerAddress]];
        [self.navigationController.navigationBar addSubview:self.custAddrHeaderLabel];
        if ([self.navigationItem.leftBarButtonItems count] == 0) {
            [self configTitleToBlue];
            [self hideHeaderLabelWithFlag:NO];
        } else {
            [self configTitleToWhite];
            [self hideHeaderLabelWithFlag:YES];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.orderNumber == nil) {
        [self.tableView reloadData];
    }
    [self stampLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
//    if(self.tablecellPopover!=nil)
//        [self.tablecellPopover dismissPopoverAnimated:NO];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return [self.detailingSelectionNames count];
    return [self.detailingDataManager.detailingActiveKeyList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [[self.detailingSelections objectAtIndex:section]count];
    if (self.requestSource == DetailingRequestSourceCustomer && section == 0) {
        return 0;
    }
    NSString* activeKey = [self.detailingDataManager.detailingActiveKeyList objectAtIndex:section];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presenterKey]) {
        return 0;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && !self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presentationsKey]) {
        return 0;
    }
    return [[self.detailingDataManager rowListWithSection:section] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.detailingSelectionNames objectAtIndex:section];
    if (self.requestSource == DetailingRequestSourceCustomer && section == 0) {
        return nil;
    }
    NSString* activeKey = [self.detailingDataManager.detailingActiveKeyList objectAtIndex:section];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presenterKey]) {
        return nil;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && !self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presentationsKey]) {
        return nil;
    }
//    NSString* activeKey = [self.detailingDataManager activeKeyWithSection:section];
    return [self.detailingDataManager.detailingHeaderDict objectForKey:activeKey];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.requestSource == DetailingRequestSourceCustomer && indexPath.section == 0) {
        return 0;
    }
    NSString* activeKey = [self.detailingDataManager.detailingActiveKeyList objectAtIndex:indexPath.section];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presenterKey]) {
        return 0;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && !self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presentationsKey]) {
        return 0;
    }
    if (indexPath.section==0) {
        return 230;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.requestSource == DetailingRequestSourceCustomer && section == 0) {
        return 0.1;
    }
    NSString* activeKey = [self.detailingDataManager.detailingActiveKeyList objectAtIndex:section];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presenterKey]) {
        return 0.1;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && !self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presentationsKey]) {
        return 0.1;
    }
    return 38.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSMutableArray* theSection=[self.detailingSelections objectAtIndex:indexPath.section];
    NSMutableArray* rowList = [self.detailingDataManager rowListWithSection:indexPath.section];
   // NSLog(@"the section is %@",theSection);
    NSMutableDictionary* theCellData = [rowList objectAtIndex:indexPath.row];
//    NSLog(@"theCellData: %@",theCellData);
    
    
    DetailingTableCell* cell = (DetailingTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:theCellData]];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell=(DetailingTableCell*)[self.cellFactory createDetailingTableCellWithData:theCellData];
        cell.delegate=self;
    }
    
    // Configure the cell...
    
    //cell.textLabel.text=[item objectForKey:@"Label"];
    cell.isEditable=self.isEditable;
    cell.indexPath=indexPath;
    cell.locationIUR = self.locationIUR;
    cell.orderNumber = self.orderNumber;
    cell.locationName = self.locationName;
    [cell configCellWithData:theCellData];
    [cell layoutMySubviews:self.detailingDataManager.actionType];
    
    return cell;
        
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.requestSource == DetailingRequestSourceCustomer && indexPath.section == 0) {
        return;
    }
    NSString* activeKey = [self.detailingDataManager.detailingActiveKeyList objectAtIndex:indexPath.section];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presenterKey]) {
        return;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && !self.isEditable && [activeKey isEqualToString:self.detailingDataManager.presentationsKey]) {
        return;
    }
    [ArcosUtils groupStyleTableView:tableView tableCell:cell indexPath:indexPath];
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


//segment buttons action
-(void)segmentAction:(id)sender{
//    UISegmentedControl* segment=(UISegmentedControl*)sender;
//    switch (segment.selectedSegmentIndex) {
//        case 0:
//            [self clearPins];
//            break;
//        case 1:
//            break;
//            
//        default:
//            break;
//    }
//    NSLog(@"segment %d touched!!",segment.selectedSegmentIndex);
    
}
-(void)updateValue:(id)data ForIndexpath:(NSIndexPath*)indexPath{
//    NSMutableArray* theSection=[self.detailingSelections objectAtIndex:indexPath.section];
    NSMutableArray* rowList = [self.detailingDataManager rowListWithSection:indexPath.section];
    //NSLog(@"the section is %@",theSection);
    NSMutableDictionary* theCellData=[rowList objectAtIndex:indexPath.row];
    [theCellData setObject:data forKey:@"data"];
    
//    NSLog(@"the cell data is %@",theCellData);
}

#pragma Save the detailing 
-(void)saveOrder{
    if ([self.coordinateType intValue] == 1) return;
    [self.view endEditing:YES];
    [self.calltrans removeAllObjects];

    if (![self checkDetailing]) {
        return;
    }
    if (![self checkKeyMessage]) {
        return;
    }
    if (![self checkSample]) {
        return;
    }
    if (![self checkPromotionalItems]) {
        return;
    }
    if (![self checkPresenter]) {
        return;
    }
    if (![self checkPresentations]) {
        return;
    }
    
    if (![self checkBasicInfo]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
//                                                        message:@"Please select call type !" delegate:nil cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
//        [alert show];	
//        [alert release];
        [ArcosUtils showDialogBox:@"Please select call type !" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    
    
    
    
    [self saveCalltrans];
//    NSLog(@"array of call trans are %@",self.calltrans);

    [self.calltrans removeAllObjects];
//    NSLog(@"order header is %@",self.orderHeader);
    
    
    //detailling successfully saved
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" 
//                                                    message:@"Detailing Saved!" delegate:nil cancelButtonTitle:@"OK"
//                                          otherButtonTitles: nil];
//    [alert show];	
//    [alert release];
    [ArcosUtils showDialogBox:@"Detailing Saved!" title:@"Message" delegate:self target:self tag:99 handler:^(UIAlertAction *action) {
        [self alertViewCallBack];
    }];
    
}
- (void)alertViewCallBack {
    if (self.requestSource == DetailingRequestSourceCustomer) {
        [self.rcsStackedController popTopNavigationController:YES];
    } else if (self.requestSource == DetailingRequestSourceCall) {
        [GlobalSharedClass shared].currentSelectedCallLocationIUR = nil;
        self.detailingDataManager.isCallSaved = YES;
        //        int itemIndex = 1;
        //        if ([self.rootView.customerMasterViewController.subMenuListingTableViewController.requestSourceName isEqualToString:[GlobalSharedClass shared].contactText]) {
        //            itemIndex = 2;
        //        }
        int itemIndex = [self.rootView.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:self.rootView.customerMasterViewController.subMenuListingTableViewController.requestSourceName];
        [self.rootView.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
        if ([GlobalSharedClass shared].currentSelectedOrderLocationIUR == nil && [GlobalSharedClass shared].currentSelectedPresenterLocationIUR == nil && [GlobalSharedClass shared].currentSelectedSurveyLocationIUR == nil) {
            NSMutableDictionary* topTabBarCellDict = [self.rootView.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
            ArcosStackedViewController* myArcosStackedViewController = [topTabBarCellDict objectForKey:@"MyCustomController"];
            NSArray* tmpControllerList = myArcosStackedViewController.rcsViewControllers;
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideCustomerDetailsAfterUpdateFlag] && [tmpControllerList count] >= 2) {
                UINavigationController* customerInfoNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:1];
                CustomerInfoTableViewController* citvc = [customerInfoNavigationController.viewControllers objectAtIndex:0];
                [citvc addCoverHomePageImageView];
                myArcosStackedViewController.topVisibleNavigationController = customerInfoNavigationController;
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 99) {
//        [self alertViewCallBack];
//    }
//}
-(BOOL)checkBasicInfo{
    //chek the order header items
//    NSMutableDictionary* basicInfo=[[self.detailingSelections objectAtIndex:0]objectAtIndex:0];
    NSMutableDictionary* basicInfo = [[self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.basicInfoKey] objectAtIndex:0];
    if ([basicInfo objectForKey:@"data"]==nil) {
        return NO;
    }
    //check contact
    if ([basicInfo valueForKeyPath:@"data.Contact"]==nil){
        NSMutableDictionary* contact=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"No contact found",@"Title",nil],@"Contact", nil];
        [self.orderHeader setObject:contact forKey:@"contact"];
//        NSLog(@"contact is %@",contact);

    }else{
        NSMutableDictionary* contact=[basicInfo valueForKeyPath:@"data.Contact"];
        [self.orderHeader setObject:contact forKey:@"contact"];
    }
    
    //check call type
    if([basicInfo valueForKeyPath:@"data.OrderDate"]!=nil){
        NSDate* orderDate = [basicInfo valueForKeyPath:@"data.OrderDate"];
        [self.orderHeader setObject:orderDate forKey:@"orderDate"];
    }else{
        [self.orderHeader setObject:[NSDate date] forKey:@"orderDate"];
    }
    //check call type
    if([basicInfo valueForKeyPath:@"data.CallType"]==nil){
        return NO;
    }else{
        NSMutableDictionary* callType=[basicInfo valueForKeyPath:@"data.CallType"];
        [self.orderHeader setObject:callType forKey:@"callType"];
    }
    
    //check the memo
    if ([basicInfo valueForKeyPath:@"data.Memo"]==nil || [[basicInfo valueForKeyPath:@"data.Memo"]length]<=0) {
        [self.orderHeader setObject:@"" forKey:@"memo"];
//
//        if (!anySampleOrQA) {//any QA or sample entry
//            return NO;
//        }else{
//            anySampleOrQA=NO;
//            [self.orderHeader setObject:@"" forKey:@"memo"];
//        }
    }else{
        NSString* memo= [basicInfo valueForKeyPath:@"data.Memo"];
        [self.orderHeader setObject:memo forKey:@"memo"];

    }
    NSMutableArray* invoiceRefList = [basicInfo valueForKeyPath:@"data.invoiceRef"];
    if (invoiceRefList != nil) {
        [self.orderHeader setObject:invoiceRefList forKey:@"invoiceRef"];
    }
    return YES;
}
-(BOOL)checkDetailing{
    //check and get the detailing inputs
//    NSMutableDictionary* detailing=[self.detailingSelections objectAtIndex:1];
    NSMutableArray* detailingList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.adoptionLadderKey];
    
    for (NSMutableDictionary* aDict in detailingList) {
        NSMutableDictionary* data=[aDict objectForKey:@"data"];
        if (data!=nil) {
            //create a call tran
            ArcosCallTran* aCalltran=[[ArcosCallTran alloc]init];
        
            aCalltran.ProductIUR=[[aDict objectForKey:@"ProductIUR"]intValue];
            aCalltran.DetailIUR=[[aDict objectForKey:@"DescIUR"]intValue];
            
            aCalltran.DetailLevel=[aDict objectForKey:@"DetailLevel"];
            aCalltran.DTIUR=0;
            
            NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
            if (![tmpDescrDetailCode containsString:@"*"]) {
                aCalltran.Score=[[data objectForKey:@"DescrDetailIUR"]intValue];
                aCalltran.Reference=@"";
            } else {
                aCalltran.Score = 0;
                NSMutableArray* msdata = [data objectForKey:@"msdata"];
                NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithCapacity:[msdata count]];
                for (int i = 0; i < [msdata count]; i++) {
                    NSMutableDictionary* tmpDescrDetailDict = [msdata objectAtIndex:i];
                    [descrDetailIURList addObject:[ArcosUtils convertNilToZero:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]]];
                }
                aCalltran.Reference = [descrDetailIURList componentsJoinedByString:@","];
            }
            
            //add call tran to the calltrans array
            [self.calltrans addObject:aCalltran];
            [aCalltran release];

            anySampleOrQA=YES;

        }
    }
    
    return YES;
}
-(BOOL)checkKeyMessage {
    NSMutableArray* keyMessageList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.keyMessagesKey];
    
    for (NSMutableDictionary* aDict in keyMessageList) {
        NSMutableDictionary* data=[aDict objectForKey:@"data"];
        if (data!=nil) {
            //create a call tran
            ArcosCallTran* aCalltran=[[ArcosCallTran alloc]init];
            
            aCalltran.ProductIUR=[[aDict objectForKey:@"ProductIUR"]intValue];
            aCalltran.DetailIUR=[[aDict objectForKey:@"DescIUR"]intValue];
            aCalltran.DetailLevel=[aDict objectForKey:@"DetailLevel"];
            aCalltran.DTIUR=0;
            
            NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
            if (![tmpDescrDetailCode containsString:@"*"]) {
                aCalltran.Score=[[data objectForKey:@"DescrDetailIUR"]intValue];
                aCalltran.Reference=@"";
            } else {
                aCalltran.Score = 0;
                NSMutableArray* msdata = [data objectForKey:@"msdata"];
                NSMutableArray* descrDetailIURList = [NSMutableArray arrayWithCapacity:[msdata count]];
                for (int i = 0; i < [msdata count]; i++) {
                    NSMutableDictionary* tmpDescrDetailDict = [msdata objectAtIndex:i];
                    [descrDetailIURList addObject:[ArcosUtils convertNilToZero:[tmpDescrDetailDict objectForKey:@"DescrDetailIUR"]]];
                }
                aCalltran.Reference = [descrDetailIURList componentsJoinedByString:@","];
            }
            
            //add call tran to the calltrans array
            [self.calltrans addObject:aCalltran];
            [aCalltran release];
            
            anySampleOrQA=YES;
            
        }
    }
    
    return YES;
}
-(BOOL)checkSample{
    //check and get the samples input
//    NSMutableDictionary* samples=[self.detailingSelections objectAtIndex:2];
    NSMutableArray* samples = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.samplesKey];
    
    for (NSMutableDictionary* aDict in samples) {
        NSMutableDictionary* data=[aDict objectForKey:@"data"];
        if (data!=nil) {
            NSMutableDictionary* qty=[data objectForKey:@"Qty"];
            if (qty !=nil && [[qty objectForKey:@"Qty"] intValue]>0) {
                //create a call tran
                ArcosCallTran* aCalltran=[[ArcosCallTran alloc]init];
                
                aCalltran.ProductIUR=[[aDict objectForKey:@"IUR"]intValue];
                aCalltran.DetailIUR=0;
                aCalltran.Score=[[qty objectForKey:@"Qty"]intValue];
                aCalltran.DetailLevel=[aDict objectForKey:@"DetailLevel"];
                aCalltran.DTIUR=0;
                
                if ([data objectForKey:@"Batch"]!=nil ) {
                    aCalltran.Reference=[[data objectForKey:@"Batch"]objectForKey:@"Value"];
                }else{
                    aCalltran.Reference=@"";
                }
                
                
                //add call tran to the calltrans array
                [self.calltrans addObject:aCalltran];
                [aCalltran release];
                
                anySampleOrQA=YES;

            }
            
            
        }
        
    }
    return YES;
}
-(BOOL)checkPromotionalItems{
    //check and get the samples input
//    NSMutableDictionary* promotionals=[self.detailingSelections objectAtIndex:3];
    NSMutableArray* promotionals = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.promotionalItemsKey];
    
    for (NSMutableDictionary* aDict in promotionals) {
//        NSLog(@"promotion item dict is %@",aDict);
        NSMutableDictionary* data=[aDict objectForKey:@"data"];
        if (data!=nil) {
            NSMutableDictionary* request=[data objectForKey:@"Request"];
            NSMutableDictionary* given=[data objectForKey:@"Given"];

            if (request !=nil) {
                NSNumber* qty=[request objectForKey:@"Qty"];
                if ([qty intValue]>0) {
                    //create a call tran
                    ArcosCallTran* aCalltran=[[ArcosCallTran alloc]init];
                    
                    aCalltran.ProductIUR=0;
                    aCalltran.DetailIUR=[[aDict objectForKey:@"IUR"]intValue];
                    aCalltran.Score=[qty intValue];
                    aCalltran.DetailLevel=[request objectForKey:@"DetailLevel"];
                    aCalltran.DTIUR=0;
                    aCalltran.Reference=@"";

                    //add call tran to the calltrans array
                    [self.calltrans addObject:aCalltran];
                    [aCalltran release];
                    
                    anySampleOrQA=YES;

                }
                
            }
            if (given !=nil) {
                NSNumber* qty=[given objectForKey:@"Qty"];
                if ([qty intValue]>0) {
                    //create a call tran
                    ArcosCallTran* aCalltran=[[ArcosCallTran alloc]init];
                    
                    aCalltran.ProductIUR=0;
                    aCalltran.DetailIUR=[[aDict objectForKey:@"IUR"]intValue];
                    aCalltran.Score=[qty intValue];
                    aCalltran.DetailLevel=[given objectForKey:@"DetailLevel"];
                    aCalltran.DTIUR=0;
                    aCalltran.Reference=@"";
                    
                    //add call tran to the calltrans array
                    [self.calltrans addObject:aCalltran];
                    [aCalltran release];
                    
                    anySampleOrQA=YES;

                }
            
                
            }
        }
        
    }
    
    return YES;
}

-(BOOL)checkPresenter {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag]) return YES;
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) return YES;
    NSMutableArray* presenterList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.presenterKey];
    for (int i = 0; i < [presenterList count]; i++) {
        NSMutableDictionary* presenterDict = [presenterList objectAtIndex:i];
        ArcosCallTran* aCalltran = [[ArcosCallTran alloc]init];
        
        aCalltran.DetailIUR = [[presenterDict objectForKey:@"presenterIUR"]intValue];
        aCalltran.Score = [[presenterDict objectForKey:@"data"] intValue];
        aCalltran.DetailLevel = [presenterDict objectForKey:@"DetailLevel"];
        
        //add call tran to the calltrans array
        [self.calltrans addObject:aCalltran];
        [aCalltran release];
    }
    return YES;
}

- (BOOL)checkPresentations {
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag]) return YES;
    NSArray* tmpKeyList = [self.detailingDataManager.presentationsHashMap allKeys];
    for (int i = 0; i < [tmpKeyList count]; i++) {
        NSMutableArray* tmpValueList = [self.detailingDataManager.presentationsHashMap objectForKey:[tmpKeyList objectAtIndex:i]];
        for (NSMutableDictionary* aDict in tmpValueList) {
            if ([[aDict objectForKey:@"data"] boolValue]) {
                ArcosCallTran* aCalltran = [[ArcosCallTran alloc] init];
                aCalltran.DetailIUR = [[aDict objectForKey:@"IUR"] intValue];
                aCalltran.Score = 0;
                aCalltran.DetailLevel = @"PS";
                [self.calltrans addObject:aCalltran];
                [aCalltran release];
            }
        }
    }
    return YES;
}

-(BOOL)saveCalltrans{
    BOOL isSuccess=NO;
    if (self.orderNumber!=nil) {//update the order header
        [self.orderHeader setObject:self.calltrans forKey:@"CallTrans"];
        [[ArcosCoreData sharedArcosCoreData]saveOrderHeader:self.orderHeader];
    }else{//add new order header
//        NSLog(@"order header to save is %@",self.orderHeader);
        [self.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"NumberOflines"];
        [self.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"TotalGoods"];
        [self.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"TotalVat"];
        isSuccess= [[OrderSharedClass sharedOrderSharedClass]saveAnOrderWithHearder:self.orderHeader withCallTrans:self.calltrans]; 
    }
    
    return isSuccess;
}
- (void) backButtonPressed:(id)sender{
    if (!self.isEditable) {//no editable then go back straight away
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
//    NSLog(@"Back button pressed");
    bool anyCall=NO;
    
    if ([self checkBasicInfo]) {
        anyCall=YES;
    }
    if ([self checkDetailing]) {
        anyCall=YES;
    }
    if ([self checkSample]) {
        anyCall=YES;
    }
    if ([self checkPromotionalItems]) {
        anyCall=YES;
    }
    
    if (anyCall) {
        // open a dialog
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You have detailing in progress! Do you want to delete current detailing?"
//                                                                 delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                        otherButtonTitles:@"Cancel",nil];
//
//        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//        [actionSheet showInView:self.view];
////        [actionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
//        [actionSheet release];
        void (^okActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self.navigationController popViewControllerAnimated:YES];
        };
        void (^cancelActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            
        };
        [ArcosUtils showTwoBtnsDialogBox:@"You have detailing in progress! Do you want to delete current detailing?" title:@"" target:self lBtnText:@"Cancel" rBtnText:@"OK" lBtnHandler:cancelActionHandler rBtnHandler:okActionHandler];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1://cancel button do nothing
            //[self.navigationController pushViewController:fstvc animated:YES];
            break;
        case 0://ok button remove current order use the new form
            [self.navigationController popViewControllerAnimated:YES];
            
            break;   
        default:
            break;
    }
}*/
#pragma mark setting input cell delegate
-(void)editStartForIndexpath:(NSIndexPath*)theIndexpath{
    //[self showAuthorizeWarning];
    //saveButton.enabled=NO;
}
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath{
    
//    NSLog(@"input is completed with data %@",data);
    [self updateValue:data ForIndexpath:theIndexpath];
    
    //saveButton.enabled=YES;
}
-(void)invalidDataForIndexpath:(NSString*)theIndexpath{
    
}
//-(void)popoverShows:(UIPopoverController*)aPopover{
////    self.tablecellPopover=aPopover;
//}
-(UIViewController*)retrieveParentViewController {
    return self;
}
- (void)presenterHeaderPressedWithIndexPath:(NSIndexPath *)anIndexpath {
    NSMutableDictionary* cellData = [self.detailingDataManager.presentationsDisplayList objectAtIndex:anIndexpath.row];
    BOOL openFlag = [[cellData objectForKey:@"OpenFlag"] boolValue];
    NSString* detailLevelString = [cellData objectForKey:@"DetailLevel"];
    if ([detailLevelString isEqualToString:@"PP"]) return;
    [self.detailingDataManager resetBranchData];
    [cellData setObject:[NSNumber numberWithBool:!openFlag] forKey:@"OpenFlag"];
    
    self.detailingDataManager.presentationsDisplayList = [NSMutableArray array];
    for (int i = 0; i < [self.detailingDataManager.originalPresentationsDisplayList count]; i++) {
        NSMutableDictionary* tmpCellData = [self.detailingDataManager.originalPresentationsDisplayList objectAtIndex:i];
        [self.detailingDataManager.presentationsDisplayList addObject:tmpCellData];
        BOOL tmpOpenFlag = [[tmpCellData objectForKey:@"OpenFlag"] boolValue];
        if (tmpOpenFlag) {
            NSMutableArray* tmpLeafDataList = [self.detailingDataManager.presentationsHashMap objectForKey:[tmpCellData objectForKey:@"DescrDetailIUR"]];
            [self.detailingDataManager.presentationsDisplayList addObjectsFromArray:tmpLeafDataList];
        }
    }
    [self.detailingDataManager.detailingRowDict setObject:self.detailingDataManager.presentationsDisplayList forKey:self.detailingDataManager.presentationsKey];
    
    [self.tableView reloadData];
}

- (void)shownButtonPressedWithValue:(BOOL)aValue atIndexPath:(NSIndexPath *)anIndexPath {
    NSMutableDictionary* tmpPresentationsDict = [self.detailingDataManager.presentationsDisplayList objectAtIndex:anIndexPath.row];
    if (aValue) {
        [tmpPresentationsDict setObject:[NSNumber numberWithBool:aValue] forKey:@"data"];
    } else {
        [tmpPresentationsDict removeObjectForKey:@"data"];
    }
    [self.tableView reloadData];
}

- (BOOL)presenterParentHasShownChild:(NSNumber*)aDescrDetailIUR {
    return [self.detailingDataManager presenterParentHasShownChildProcessor:aDescrDetailIUR];
}

#pragma mark filling the detailing
-(void)fillTheExsitDetailing{
    //fill the order header
    NSMutableDictionary* editOrderHeader=[[ArcosCoreData sharedArcosCoreData]editingOrderHeaderWithOrderNumber:self.orderNumber];
//    NSLog(@"editable order header is %@",editOrderHeader);
    if (editOrderHeader ==nil) {//no order header found then reset order number to be nil
        self.orderNumber=nil;
        return;
    }
    
    self.orderHeader=editOrderHeader;
//    NSMutableDictionary* MainSelection=[[self.detailingSelections objectAtIndex:0]objectAtIndex:0];
    NSMutableDictionary* MainSelection = [[self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.basicInfoKey] objectAtIndex:0];
    NSMutableDictionary* aMainData=[NSMutableDictionary dictionary];
    [aMainData setObject:[self.orderHeader objectForKey:@"orderDate"]  forKey:@"OrderDate"];
    //call type
    if ([self.orderHeader objectForKey:@"callType"] != nil) {
        [aMainData setObject:[self.orderHeader objectForKey:@"callType"] forKey:@"CallType"];
    }    
    //contact
    NSMutableDictionary* aContact=[self.orderHeader objectForKey:@"contact"] ;
    NSMutableDictionary* aNewContact=[NSMutableDictionary dictionary];
    [aNewContact setObject:[aContact objectForKey:@"IUR"]  forKey:@"IUR"];
    [aNewContact setObject:[editOrderHeader objectForKey:@"contactText"]  forKey:@"Title"];
    [aMainData setObject:aNewContact forKey:@"Contact"];
    //memo
    [aMainData setObject:[self.orderHeader objectForKey:@"memo"] forKey:@"Memo"];
    [MainSelection setObject:aMainData forKey:@"data"];
    
   // NSLog(@"Contact is %@",[self.orderHeader objectForKey:@"contact"]);
    //fill the calltrans
    OrderHeader* OH=[[ArcosCoreData sharedArcosCoreData]orderHeaderWithOrderNumber:self.orderNumber];
//    NSLog(@"calltrans from orderheader is: %@",OH);
    NSSet* calltranSet=OH.calltrans;
    NSMutableArray* calltranList = [ProductFormRowConverter convertManagedCalltranSet:calltranSet];
    [self fillDetailingByCalltranList:calltranList];
    if (!self.isEditable) {
        [self.detailingDataManager resetDataToShowResultOnlyWhenSent];
    }
}

#pragma mark core location delegate
-(void)stampLocation{
//    NSLog(@"location stamping!");
    [self.CLController start];
    
}
//core location delegate
- (void)locationUpdate:(CLLocation *)location {
//    NSLog(@"location is coming back %@",[location description]);
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"latitude"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"longitude"];
    [self.CLController stop];
}
- (void)locationError:(NSError *)error {
	//locLabel.text = [error description];
//    NSLog(@"location is coming back with error");
    [self.CLController stop];
    
}

-(void)fillDetailingByCalltranList:(NSMutableArray*)aCallTranList {
    BOOL multipleSelectionFlag = NO;
    NSMutableDictionary* dTMultipleSelectionHashtable = [NSMutableDictionary dictionary];
    NSMutableDictionary* kMMultipleSelectionHashtable = [NSMutableDictionary dictionary];
    NSMutableArray* QASelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.adoptionLadderKey];
    for (NSMutableDictionary* aDict in QASelection) {
        NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
        if ([tmpDescrDetailCode containsString:@"*"]) {
            multipleSelectionFlag = YES;
            break;
        }
    }
    if (!multipleSelectionFlag) {
        NSMutableArray* keyMessageList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.keyMessagesKey];
        for (NSMutableDictionary* aDict in keyMessageList) {
            NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
            if ([tmpDescrDetailCode containsString:@"*"]) {
                multipleSelectionFlag = YES;
                break;
            }
        }
    }
    if (multipleSelectionFlag) {
        for (ArcosCallTran* CT in aCallTranList) {
            if ([CT.DetailLevel isEqualToString:@"DT"]) {
                NSMutableArray* QASelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.adoptionLadderKey];
                for (NSMutableDictionary* aDict in QASelection) {
                    if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"] != nil) {
                        if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                            NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
                            if ([tmpDescrDetailCode containsString:@"*"] && CT.Score != 0) {
                                NSMutableArray* dTMultipleSelectionValueList = [dTMultipleSelectionHashtable objectForKey:[NSNumber numberWithInt:CT.DetailIUR]];
                                if (dTMultipleSelectionValueList == nil) {
                                    dTMultipleSelectionValueList = [NSMutableArray array];
                                }
                                [dTMultipleSelectionValueList addObject:[NSString stringWithFormat:@"%d", CT.Score]];
                                [dTMultipleSelectionHashtable setObject:dTMultipleSelectionValueList forKey:[NSNumber numberWithInt:CT.DetailIUR]];
                            }
                        }
                    }
                }
            }
            if ([CT.DetailLevel isEqualToString:self.detailingDataManager.keyMessagesKey]) {
                NSMutableArray* keyMessageList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.keyMessagesKey];
                for (NSMutableDictionary* aDict in keyMessageList) {
                    if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"] != nil) {
                        if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                            NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
                            if ([tmpDescrDetailCode containsString:@"*"] && CT.Score != 0) {
                                NSMutableArray* kMMultipleSelectionValueList = [kMMultipleSelectionHashtable objectForKey:[NSNumber numberWithInt:CT.DetailIUR]];
                                if (kMMultipleSelectionValueList == nil) {
                                    kMMultipleSelectionValueList = [NSMutableArray array];
                                }
                                [kMMultipleSelectionValueList addObject:[NSString stringWithFormat:@"%d", CT.Score]];
                                [kMMultipleSelectionHashtable setObject:kMMultipleSelectionValueList forKey:[NSNumber numberWithInt:CT.DetailIUR]];
                            }
                        }
                    }
                }
            }
        }
    }
    
    for (ArcosCallTran* CT in aCallTranList) {
        //fill
        if ([CT.DetailLevel isEqualToString:@"DT"]) {
            NSMutableArray* QASelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.adoptionLadderKey];
            for (NSMutableDictionary* aDict in QASelection) {
                if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"]!=nil) {
                    if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                        NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
                        if (![tmpDescrDetailCode containsString:@"*"]) {
                            NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                            if (aData != nil) {
                                [aDict setObject:aData forKey:@"data"];
                            }
                        } else {
                            NSArray* tmpDescrDetailIURList = nil;
                            NSMutableArray* dTMultipleSelectionValueList = [dTMultipleSelectionHashtable objectForKey:[NSNumber numberWithInt:CT.DetailIUR]];
                            if (dTMultipleSelectionValueList != nil) {
                                tmpDescrDetailIURList = dTMultipleSelectionValueList;
                            } else {
                                if (CT.Reference != nil && ![CT.Reference isEqualToString:@""]) {
                                    tmpDescrDetailIURList = [CT.Reference componentsSeparatedByString:@","];
                                }
                            }
                            NSMutableArray* descrDetailDictList = [NSMutableArray arrayWithCapacity:[tmpDescrDetailIURList count]];
                            NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:1];
                            [resultDict setObject:descrDetailDictList forKey:@"msdata"];
                            [aDict setObject:resultDict forKey:@"data"];
                            for (int i = 0; i < [tmpDescrDetailIURList count]; i++) {
                                NSString* tmpDescrDetailIURString = [tmpDescrDetailIURList objectAtIndex:i];
                                NSNumber* tmpDescrDetailIUR = [ArcosUtils convertStringToNumber:tmpDescrDetailIURString];
                                NSDictionary* tmpDescrDetailDict = [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:tmpDescrDetailIUR];
                                if (tmpDescrDetailDict != nil) {
                                    [descrDetailDictList addObject:tmpDescrDetailDict];
                                }
                            }
                        }
                    }
                }
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"ProductIUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"ProductIUR"] intValue]) {
                        NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        if (aData != nil) {
                            [aDict setObject:aData forKey:@"data"];
                        }
                    }
                }
            }
            
        }
        if ([CT.DetailLevel isEqualToString:self.detailingDataManager.keyMessagesKey]) {
            NSMutableArray* keyMessageList = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.keyMessagesKey];
            
            for (NSMutableDictionary* aDict in keyMessageList) {
                if (CT.DetailIUR != 0 && [aDict valueForKeyPath:@"DescIUR"]!=nil) {
                    if (CT.DetailIUR == [[aDict valueForKeyPath:@"DescIUR"] intValue]) {
                        NSString* tmpDescrDetailCode = [aDict objectForKey:@"DescrDetailCode"];
                        if (![tmpDescrDetailCode containsString:@"*"]) {
                            NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                            if (aData != nil) {
                                [aDict setObject:aData forKey:@"data"];
                            }
                        } else {
                            NSArray* tmpDescrDetailIURList = nil;
                            NSMutableArray* kMMultipleSelectionValueList = [kMMultipleSelectionHashtable objectForKey:[NSNumber numberWithInt:CT.DetailIUR]];
                            if (kMMultipleSelectionValueList != nil) {
                                tmpDescrDetailIURList = kMMultipleSelectionValueList;
                            } else {
                                if (CT.Reference != nil && ![CT.Reference isEqualToString:@""]) {
                                    tmpDescrDetailIURList = [CT.Reference componentsSeparatedByString:@","];
                                }
                            }
                            NSMutableArray* descrDetailDictList = [NSMutableArray arrayWithCapacity:[tmpDescrDetailIURList count]];
                            NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:1];
                            [resultDict setObject:descrDetailDictList forKey:@"msdata"];
                            [aDict setObject:resultDict forKey:@"data"];
                            for (int i = 0; i < [tmpDescrDetailIURList count]; i++) {
                                NSString* tmpDescrDetailIURString = [tmpDescrDetailIURList objectAtIndex:i];
                                NSNumber* tmpDescrDetailIUR = [ArcosUtils convertStringToNumber:tmpDescrDetailIURString];
                                NSDictionary* tmpDescrDetailDict = [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:tmpDescrDetailIUR];
                                if (tmpDescrDetailDict != nil) {
                                    [descrDetailDictList addObject:tmpDescrDetailDict];
                                }
                            }
                        }
                    }
                }
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"ProductIUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"ProductIUR"] intValue]) {
                        NSDictionary* aData= [[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[NSNumber numberWithInt:CT.Score]];
                        if (aData != nil) {
                            [aDict setObject:aData forKey:@"data"];
                        }                        
                    }
                }
            }
            
        }
        //fill up the samples
        if ([CT.DetailLevel isEqualToString:@"SM"]) {
            NSLog(@"SM found");
            
            //            NSMutableArray* SampleSelection=[self.detailingSelections objectAtIndex:2];
            NSMutableArray* SampleSelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.samplesKey];
            for (NSMutableDictionary* aDict in SampleSelection) {
                if (CT.ProductIUR != 0 && [aDict valueForKeyPath:@"IUR"]!=nil) {
                    if (CT.ProductIUR == [[aDict valueForKeyPath:@"IUR"] intValue]){
                        NSMutableDictionary* aData=[NSMutableDictionary dictionary];
                        NSMutableDictionary* aBatch=[NSMutableDictionary dictionary];
                        NSMutableDictionary* aQty=[NSMutableDictionary dictionary];
                        
                        [aBatch setObject:[NSNumber numberWithInt:CT.ProductIUR] forKey:@"ProductIUR"];
                        [aBatch setObject:[ArcosUtils convertNilToEmpty:CT.Reference] forKey:@"Value"];
                        [aQty setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        
                        [aData setObject:aBatch forKey:@"Batch"];
                        [aData setObject:aQty forKey:@"Qty"];
                        
                        [aDict setObject:aData forKey:@"data"];
                    }
                }
            }
            
        }
        
        //fill out the request and given
        if ([CT.DetailLevel isEqualToString:@"GV"]||[CT.DetailLevel isEqualToString:@"RQ"]) {
            //NSLog(@"GV and RQ found");
            //            NSMutableArray* GiveAndRequestSelection=[self.detailingSelections objectAtIndex:3];
            NSMutableArray* GiveAndRequestSelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.promotionalItemsKey];
            for (NSMutableDictionary* aDict in GiveAndRequestSelection) {
                
                NSMutableDictionary* aData;
                if ([aDict objectForKey:@"data"]!=nil) {
                    aData=[aDict objectForKey:@"data"];
                }else{
                    aData=[NSMutableDictionary dictionary];
                }
                
                if (CT.DetailIUR == [[aDict valueForKeyPath:@"IUR"] intValue]){
                    
                    if ([CT.DetailLevel isEqualToString: @"GV"]) {
                        NSMutableDictionary* aGiven=[NSMutableDictionary dictionary];
                        [aGiven setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        [aGiven setObject:@"GV" forKey:@"DetailLevel"];
                        [aData setObject:aGiven forKey:@"Given"];
                        
                    }
                    if ([CT.DetailLevel isEqualToString: @"RQ"]) {
                        NSMutableDictionary* aRequest=[NSMutableDictionary dictionary];
                        [aRequest setObject:[NSNumber numberWithInt:CT.Score] forKey:@"Qty"];
                        [aRequest setObject:@"RQ" forKey:@"DetailLevel"];
                        [aData setObject:aRequest forKey:@"Request"];
                        
                    }
                    [aDict setObject:aData forKey:@"data"];
                }
            }
        }
        //[[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] &&
        if ([CT.DetailLevel isEqualToString:self.detailingDataManager.presenterKey]) {
            
            NSMutableArray* presenterSelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.presenterKey];
            if (presenterSelection == nil) {
                presenterSelection = [NSMutableArray array];
                [self.detailingDataManager.detailingActiveKeyList addObject:self.detailingDataManager.presenterKey];
                [self.detailingDataManager.detailingRowDict setObject:presenterSelection forKey:self.detailingDataManager.presenterKey];
            }
            
            NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
            NSDictionary* presenterDict = [[ArcosCoreData sharedArcosCoreData] presenterWithIUR:[NSNumber numberWithInt:CT.DetailIUR]];
            [cellData setObject:[NSNumber numberWithInt:CT.DetailIUR] forKey:@"presenterIUR"];
            [cellData setObject:@"PS" forKey:@"DetailLevel"];
            [cellData setObject:[ArcosUtils convertNilToEmpty:[presenterDict objectForKey:@"fullTitle"]]  forKey:@"Label"];
//            [cellData setObject:[NSNumber numberWithInt:CT.Score] forKey:@"data"];
            [cellData setObject:[ArcosUtils convertNilToEmpty:CT.Reference] forKey:@"data"];
            [presenterSelection addObject:cellData];
        }
        if ([CT.DetailLevel isEqualToString:self.detailingDataManager.meetingContactKey]) {
            NSMutableArray* meetingContactSelection = [self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.meetingContactKey];
            if (meetingContactSelection == nil) {
                meetingContactSelection = [NSMutableArray array];
                [self.detailingDataManager.detailingActiveKeyList addObject:self.detailingDataManager.meetingContactKey];
                [self.detailingDataManager.detailingRowDict setObject:meetingContactSelection forKey:self.detailingDataManager.meetingContactKey];
            }
            
            NSMutableDictionary* cellData = [NSMutableDictionary dictionary];
            [cellData setObject:@"MC" forKey:@"DetailLevel"];
            NSArray* referenceList = [CT.Reference componentsSeparatedByString:@"|"];
            @try {
                [cellData setObject:[ArcosUtils convertNilToEmpty:[referenceList objectAtIndex:0]]  forKey:@"Label"];
                [cellData setObject:[ArcosUtils convertNilToEmpty:[referenceList objectAtIndex:1]] forKey:@"data"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            [meetingContactSelection addObject:cellData];
        }
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPresenterInDetailingFlag] && [CT.DetailLevel isEqualToString:self.detailingDataManager.presenterKey]) {
            NSArray* tmpKeyList = [self.detailingDataManager.presentationsHashMap allKeys];
            for (int i = 0; i < [tmpKeyList count]; i++) {
                NSMutableArray* tmpValueList = [self.detailingDataManager.presentationsHashMap objectForKey:[tmpKeyList objectAtIndex:i]];
                for (NSMutableDictionary* aDict in tmpValueList) {
                    if (CT.DetailIUR != 0 && [[aDict objectForKey:@"IUR"] intValue] != 0) {
                        if (CT.DetailIUR == [[aDict valueForKeyPath:@"IUR"] intValue]) {
                            [aDict setObject:[NSNumber numberWithBool:YES] forKey:@"data"];
                        }
                    }
                }
            }            
        }
    }
}
-(void)fillRemoteDetailing {
    NSMutableDictionary* MainSelection = [[self.detailingDataManager.detailingRowDict objectForKey:self.detailingDataManager.basicInfoKey] objectAtIndex:0];
    NSMutableDictionary* aMainData=[NSMutableDictionary dictionary];
    [MainSelection setObject:aMainData forKey:@"data"];
    [self fillDetailingByCalltranList:[self.orderHeader objectForKey:@"RemoteCallTrans"]];
    if (!self.isEditable) {
        [self.detailingDataManager resetDataToShowResultOnlyWhenSent];
    }
}

- (void)hideHeaderLabelWithFlag:(BOOL)aFlag {
    self.custNameHeaderLabel.hidden = aFlag;
    self.custAddrHeaderLabel.hidden = aFlag;
}

- (void)configTitleToWhite {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (void)configTitleToBlue {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
    }
}
@end
