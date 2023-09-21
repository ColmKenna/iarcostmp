//
//  ReportTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 27/04/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "ReportTableViewController.h"
#import "ReportCell.h"
#import "ReportLocationCell.h"

@interface ReportTableViewController (Private)
-(NSMutableArray*)recordWithLink:(NSString*)link;
-(void)sortByFiledName:(NSString*)filedName;
-(void)detailViewWithData:(CXMLElement*)data;
- (void)alertViewCallBack;
@end

@implementation ReportTableViewController
@synthesize ReportDocument;
@synthesize DisplayList;
@synthesize MainData;
@synthesize Options;
@synthesize Subtotal;
@synthesize reportCode;
@synthesize headerView;
@synthesize factory = _factory;
@synthesize optionList;
@synthesize sortList;
//@synthesize thePopover = _thePopover;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize callGenericServices = _callGenericServices;
@synthesize customerTypesDataManager = _customerTypesDataManager;
@synthesize myArcosAdminEmail = _myArcosAdminEmail;
@synthesize customerContactTypesDataManager = _customerContactTypesDataManager;
@synthesize contactGenericReturnObject = _contactGenericReturnObject;
@synthesize emailActionType = _emailActionType;
@synthesize emailContactIUR = _emailContactIUR;
@synthesize nullStr = _nullStr;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //add save button to the navigation bar
    self.nullStr = @"null";
    UIBarButtonItem *optionButton = [[UIBarButtonItem alloc] 
                                     initWithTitle: @"Option"
                                     style:UIBarButtonItemStylePlain
                                     target: self
                                     action:@selector(option:)];
    
    //add save button to the navigation bar
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] 
                                     initWithTitle: @"Sort"
                                     style:UIBarButtonItemStylePlain
                                     target: self
                                     action:@selector(sort:)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:optionButton,sortButton, nil] animated:YES];
    
    [optionButton release];
    [sortButton release];

    
    
    self.MainData=[[[self.ReportDocument nodesForXPath:@"//Main" error:nil]mutableCopy] autorelease];
    self.DisplayList=self.MainData;
    
    //parse the option
    self.factory = [WidgetFactory factory];
    self.factory.delegate = self;
    self.optionList= [NSMutableArray array];
    self.sortList=[NSMutableArray array];
    
    //sort options
    if ([self.MainData count]>0) {
        CXMLElement* sortElement=[self.MainData objectAtIndex:0];
        for (int i=0; i<sortElement.childCount; i++) {
            NSMutableDictionary* elementDict=[NSMutableDictionary dictionary];
            if (![[sortElement childAtIndex:i].name isEqualToString:@"text"]) {
                
                if ([[sortElement childAtIndex:i]stringValue] !=nil) {
                    [elementDict setObject:[ArcosUtils convertNilToEmpty:[[sortElement childAtIndex:i]stringValue]] forKey:[ArcosUtils convertNilToEmpty:[sortElement childAtIndex:i].name]];
                }else {
                    [elementDict setObject:@"" forKey:[ArcosUtils convertNilToEmpty:[sortElement childAtIndex:i].name]];
                }
                
                
                [elementDict setObject:[ArcosUtils convertNilToEmpty:[sortElement childAtIndex:i].name] forKey:@"Title"];
                [elementDict setObject:@"Sort" forKey:@"PopoverCellType"];

                [self.sortList addObject:elementDict];
            }
            
        }
        
    }
    
    
    
    //sub table
    NSMutableDictionary* allOption = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"All",@"Details",self.nullStr,@"LinkIUR",@"All",@"Title",@"SubTable",@"PopoverCellType", nil];
    [self.optionList addObject:allOption];
        
    self.Options=[[[self.ReportDocument  nodesForXPath:@"//Sub" error:nil]mutableCopy] autorelease];
    for (CXMLElement* element in self.Options) {
        
        NSMutableDictionary* elementDict=[NSMutableDictionary dictionary];
        for (int i=0; i<element.childCount; i++) {
            
            if (![[element childAtIndex:i].name isEqualToString:@"text"]) {
                
                [elementDict setObject:[ArcosUtils convertNilToEmpty:[[element childAtIndex:i]stringValue]] forKey:[ArcosUtils convertNilToEmpty:[element childAtIndex:i].name]];
            }
        }
        
        NSString* subTitleString=[NSString stringWithFormat:@"%@",[elementDict objectForKey:@"Details"]];
        [elementDict setObject:[ArcosUtils convertNilToEmpty:subTitleString] forKey:@"Title"];
        [elementDict setObject:@"SubTable" forKey:@"PopoverCellType"];

        [self.optionList addObject:elementDict];
    }
    
    //make a cell factory
    cellFactory=[[ReportCellFactory alloc]init];
    reportCellIdentifier=[cellFactory cellIdentifierWithReportCode:self.reportCode];
    
    self.rootView = [ArcosUtils getRootView];

    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    //return self.headerView;
    UIView* auxView = [cellFactory headViewWithReportCode:self.reportCode];
    if ([cellFactory viewTagWithCode:self.reportCode] == 3) {
        ReportOrderHeaderView* resView = (ReportOrderHeaderView*)auxView;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            resView.goodsLabel.hidden = NO;
            resView.vatLabel.hidden = NO;
            resView.totalLabel.text = @"Total";
        } else {
            resView.goodsLabel.hidden = YES;
            resView.vatLabel.hidden = YES;
            resView.totalLabel.text = @"Value";
        }
    }
    return auxView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
    
    return [self.DisplayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = reportCellIdentifier;
    ReportCell *cell =(ReportCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"ReportCustomCells" owner:self options:nil];
        
        
        for (id nibItem in nibContents) {
            
            if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                
                cell=(ReportCell*)nibItem;
                break;
            }
        }
    }
    // Configure the cell...
    [cell setDataXML:[self.DisplayList objectAtIndex:indexPath.row]];

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
   
//    NSLog(@"table selected at %@--data:%@",indexPath,[self.DisplayList objectAtIndex:indexPath.row]);
    [self detailViewWithData:[self.DisplayList objectAtIndex:indexPath.row]];

}

#pragma mark option popover delegate
-(void)option:(id)sender{
//    UIBarButtonItem* button=(UIBarButtonItem*)sender;
//
//    NSLog(@"option press!");
//    if ([self.thePopover isPopoverVisible]) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    } else {
//        self.thePopover = [self.factory CreateTableWidgetWithData:self.optionList withTitle:@"Sub Totals" withParentContentString:@"Options"];
//        //do show the popover if there is no data
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
}
#pragma mark sort popover delegate
-(void)sort:(id)sender{
//    UIBarButtonItem* button=(UIBarButtonItem*)sender;
//
//    NSLog(@"sort press!");
//    if ([self.thePopover isPopoverVisible]) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    } else {
//        self.thePopover = [self.factory CreateTableWidgetWithData:self.sortList withTitle:@"Sort Options" withParentContentString:@"Sort Options"];
//        //do show the popover if there is no data
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//
//    }
}
-(void)operationDone:(id)data {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
////    NSLog(@"%@", data);
//
//    if ([[data objectForKey:@"PopoverCellType"]isEqualToString:@"Sort"]) {
//        [self sortByFiledName:[data objectForKey:@"Title"]];
//    }else if ([[data objectForKey:@"PopoverCellType"]isEqualToString:@"SubTable"]) {
//        NSString* link=[data objectForKey:@"LinkIUR"];
//
//        if ([link isEqualToString:self.nullStr]) {
//            self.DisplayList=self.MainData;
//        }else{
//            self.DisplayList=[self recordWithLink:link];
//        }
//    }
//
//
//
//    [self.tableView reloadData];
}

- (void)sortWithLinkIUR:(NSString*)aLinkIUR {
    if ([aLinkIUR isEqualToString:self.nullStr]) {
        self.DisplayList = self.MainData;
    }else{
        self.DisplayList = [self recordWithLink:aLinkIUR];
    }
    [self.tableView reloadData];
}

-(NSMutableArray*)recordWithLink:(NSString*)link{
    
    NSMutableArray* tempArray= [NSMutableArray array];
    for (CXMLElement* element in self.MainData) {
        
        for (int i=0; i<element.childCount; i++) {
            
            if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
                
                //check is link the one we need
                if([[element childAtIndex:i].name isEqualToString:@"LinkIUR"]&&
                   [[[element childAtIndex:i]stringValue]isEqualToString:link]){
                    
                    [tempArray addObject:element];
                }
            }
            
        }
        
    }
    return tempArray;
}

-(void)dismissPopoverController {
//    if (self.thePopover != nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
}


#pragma marks sort the records
-(void)sortByFiledName:(NSString*)filedName{
    self.DisplayList=[[[self.DisplayList sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2){
        CXMLElement* element1=(CXMLElement*)obj1;
        CXMLElement* element2=(CXMLElement*)obj2;
        
        NSString *value1 =@"";
        NSString *value2 =@"";
        
        for (int i=0; i<element1.childCount; i++) {
            
            if (![[element1 childAtIndex:i].name isEqualToString:@"text"]) {
                if ([filedName isEqualToString:[element1 childAtIndex:i].name]) {
                    value1=[[element1 childAtIndex:i]stringValue] ;
                    break;
                }
            }
        }
        
        for (int i=0; i<element2.childCount; i++) {
            
            if (![[element2 childAtIndex:i].name isEqualToString:@"text"]) {
                if ([filedName isEqualToString:[element2 childAtIndex:i].name]) {
                    value2=[[element2 childAtIndex:i]stringValue] ;
                    break;
                }

            }
        }
        
        
        return [value1 caseInsensitiveCompare:value2]; }]mutableCopy] autorelease];
}
#pragma mark populate data to detail views
-(NSString*)valueForTag:(NSString*)tag withElement:(CXMLElement*)element{
    NSString* value=@"";
    for (int i=0; i<element.childCount; i++) {
        
        if (![[element childAtIndex:i].name isEqualToString:@"text"]&&[[element childAtIndex:i]stringValue]!=nil) {
            if ([[element childAtIndex:i].name isEqualToString:tag]) {
                value= [[element childAtIndex:i]stringValue];
                break;
            }
        }
        
    }
    return value;
}
-(void)showLocationDetail:(CXMLElement*)data{
    NSString* IUR=[self valueForTag:@"IUR" withElement:data];
    NSLog(@"IUR of selected cell is %@",IUR);
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableEditLocationByEmailFlag]) {        
        self.callGenericServices.isNotRecursion = YES;
        [self.callGenericServices getRecord:@"Location" iur:[[ArcosUtils convertStringToNumber:IUR] intValue]];
        return;
    }
    
    CustomerDetailsWrapperModalViewController* cdwmvc = [[CustomerDetailsWrapperModalViewController alloc] initWithNibName:@"CustomerDetailsWrapperModalViewController" bundle:nil];
    cdwmvc.myDelegate = self;
    cdwmvc.delegate = self;
    cdwmvc.navgationBarTitle = [NSString stringWithFormat:@"Details for %@", [self valueForTag:@"Name" withElement:data]];
    cdwmvc.locationIUR =[NSNumber numberWithInt: [IUR intValue]];
    cdwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [cdwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}
-(void)showContactDetail:(CXMLElement*)data{
    NSNumber* IUR=[NSNumber numberWithInt:[[self valueForTag:@"IUR" withElement:data]intValue]];
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableEditContactByEmailFlag]) {        
        self.emailActionType = @"edit";
        self.emailContactIUR = IUR;
        self.callGenericServices.isNotRecursion = NO;
        [self.callGenericServices genericGetRecord:@"Contact" iur:[self.emailContactIUR intValue] action:@selector(setContactGenericGetRecordResult:) target:self];
        return;
    }
    
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.tableCellData = [NSMutableDictionary dictionaryWithObject:IUR forKey:@"IUR"];
    ccwmvc.actionType = @"edit";
    ccwmvc.myDelegate = self;
    ccwmvc.delegate = self;
    //ccwmvc.refreshDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Contact Details for %@", [self valueForTag:@"Forename" withElement:data]];
    //ccwmvc.locationIUR = [self valueForTag:@"Forename" withElement:data];
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    /*
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    */
    [ccwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}
-(void)showCallDetail:(CXMLElement*)data{
    CustomerCallDetailViewController* ccdmvc=[[CustomerCallDetailViewController alloc]initWithNibName:@"CustomerCallDetailViewController" bundle:nil];
    ccdmvc.animateDelegate=self;
    ccdmvc.IUR = [self valueForTag:@"IUR" withElement:data];
    ccdmvc.title = @"CALL DETAILS";
    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccdmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [ccdmvc release];
    
    //[arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
}
-(void)showOrderDetail:(CXMLElement*)data{
    NSString* orderDetailsNibName = @"CustomerOrderDetailsModalViewController";
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        orderDetailsNibName = @"CustomerOrderDetailsGoodsVatModalViewController";
    }
    CustomerOrderDetailsModalViewController* codmvc=[[CustomerOrderDetailsModalViewController alloc]initWithNibName:orderDetailsNibName bundle:nil];
    codmvc.title = @"ORDER DETAILS";    
    codmvc.animateDelegate=self;
    //    NSLog(@"order iur is %@", orderIUR); //52428
    codmvc.orderIUR = [self valueForTag:@"IUR" withElement:data];
//    codmvc.title = @"CALL DETAILS";
    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:codmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [codmvc release];
}
-(void)showInvoiceDetail:(CXMLElement*)data{
    CustomerInvoiceDetailsModalViewController* cidmvc=[[CustomerInvoiceDetailsModalViewController alloc]initWithNibName:@"CustomerInvoiceDetailsModalViewController" bundle:nil];
    cidmvc.animateDelegate=self;
    cidmvc.IUR = [self valueForTag:@"IUR" withElement:data];
    cidmvc.title = @"INVOICE DETAILS";
    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cidmvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [cidmvc release];
}
-(void)showMeetingDetail:(CXMLElement*)data {
    NSNumber* iUR = [ArcosUtils convertStringToNumber:[self valueForTag:@"iur" withElement:data]];
    MeetingMainTemplateViewController* mmtvc = [[MeetingMainTemplateViewController alloc] initWithNibName:@"MeetingMainTemplateViewController" bundle:nil];
    mmtvc.animateDelegate = self;
    mmtvc.meetingIUR = iUR;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:mmtvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [mmtvc release];
//    ReportMeetingWrapperViewController* rmwvc = [[ReportMeetingWrapperViewController alloc] initWithNibName:@"ReportMeetingWrapperViewController" bundle:nil];
//    rmwvc.myDelegate = self;
//    rmwvc.iUR = iUR;
//    rmwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
//    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:rmwvc] autorelease];
//    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
//    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
//    [self.rootView addChildViewController:self.globalNavigationController];
//    [self.rootView.view addSubview:self.globalNavigationController.view];
//    [self.globalNavigationController didMoveToParentViewController:self.rootView];
//    [rmwvc release];
//    [UIView animateWithDuration:0.3f animations:^{
//        self.globalNavigationController.view.frame = parentNavigationRect;
//    } completion:^(BOOL finished){
//
//    }];
}
-(void)showProductDetail:(CXMLElement*)data {
    NSNumber* iUR = [ArcosUtils convertStringToNumber:[self valueForTag:@"iur" withElement:data]];
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.presentViewDelegate = self;
    pdvc.productIUR = iUR;
    pdvc.locationIUR = [NSNumber numberWithInt:0];
    pdvc.productDetailDataManager.formRowDict = nil;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:pdvc] autorelease];
    self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [pdvc release];
}
-(void)detailViewWithData:(CXMLElement*)data{
    if ([reportCode hasPrefix:@"2.00"]) {//location report
        [self showLocationDetail:data];
    }else if ([reportCode isEqualToString:@"2.01"]) {//contact report
        [self showContactDetail:data];
    }else if ([reportCode isEqualToString:@"2.02"]) {//calls report
        [self showCallDetail:data];
    }else if ([reportCode isEqualToString:@"2.03"]) {//orders report
        [self showOrderDetail:data];
    }else if ([reportCode isEqualToString:@"2.13"]) {//invoices report
        [self showInvoiceDetail:data];
    }else if ([reportCode isEqualToString:@"2.04"]) {//product report
        [self showProductDetail:data];
    }else if ([reportCode isEqualToString:@"2.19"]) {//product report
        [self showMeetingDetail:data];
    }else{
    }
}

#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
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

- (void)didDismissModalView{
    [self.rootView dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
    }];
    
}
-(void)dismissUIViewAnimation {  
     [self.rootView dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.globalNavigationController = nil;
    }];
}

-(void)dealloc{
    if (self.ReportDocument!=nil)
        self.ReportDocument=nil;
    
    if (self.DisplayList!=nil)
        self.DisplayList=nil;
    
    if (self.sortList!=nil)
        self.sortList=nil;
    
    if (self.Subtotal!=nil)
        self.Subtotal=nil;
    
    if (self.MainData!=nil)
        self.MainData=nil;
    
    if (self.Options!=nil) 
        self.Options=nil;
    
    if (self.optionList != nil) { self.optionList = nil; }
    self.headerView = nil;
    if (self.factory != nil) { self.factory = nil; }
//    self.thePopover = nil;
    
    [cellFactory release];
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.customerTypesDataManager = nil;
    self.myArcosAdminEmail = nil;
    self.customerContactTypesDataManager = nil;
    self.emailActionType = nil;
    self.emailContactIUR = nil;
    self.nullStr = nil;
    [super dealloc];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.customerTypesDataManager = [[[CustomerTypesDataManager alloc] init] autorelease];
        [self.customerTypesDataManager createCustomerDetailsActionDataManager:@"edit"];
        self.customerTypesDataManager.orderedFieldTypeList = self.customerTypesDataManager.customerDetailsActionBaseDataManager.orderedFieldTypeList;
        [self.customerTypesDataManager processRawData:result withNumOfFields:47];
        NSNumber* employeeIUR = [SettingManager employeeIUR];
        NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
        NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
        NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:self.myArcosAdminEmail, nil];
        NSString* subject = [NSString stringWithFormat:@"Please Amend Location Details from %@", employeeName];
        NSString* body = [self.customerTypesDataManager buildEmailMessageBody];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
            ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
            amwvc.mailDelegate = self;
            amwvc.toRecipients = toRecipients;
            amwvc.subjectText = subject;
            amwvc.bodyText = body;
            amwvc.isHTML = YES;            
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
        if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
        MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        mailController.mailComposeDelegate = self;
        
        [mailController setToRecipients:toRecipients];
        [mailController setSubject:subject];        
        [mailController setMessageBody:body isHTML:YES];
        [self.rootView presentViewController:mailController animated:YES completion:nil];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
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

//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    [self alertViewCallBack];
//}

- (void)alertViewCallBack {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        
    }];
}

-(void)setContactGenericGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.contactGenericReturnObject = result;
        //        self.contactGenericClass = [result.ArrayOfData objectAtIndex:0];
        self.customerContactTypesDataManager = [[[CustomerContactTypesDataManager alloc] init] autorelease];
        [self.customerContactTypesDataManager createCustomerContactActionDataManager:self.emailActionType];
        self.customerContactTypesDataManager.orderedFieldTypeList = self.customerContactTypesDataManager.customerContactActionBaseDataManager.orderedFieldTypeList;
        if (![self.emailActionType isEqualToString:@"edit"]) {
            [self.callGenericServices.HUD hide:YES];
            [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:[NSMutableArray arrayWithCapacity:0]];
            [self createEmailComposeViewControllerWithType:self.emailActionType];
            return;
        }
        NSString* flagSqlStatement = [NSString stringWithFormat:@"select IUR,DescrDetailIUR,ContactIUR,LocationIUR,TeamIUR,EmployeeIUR from Flag where ContactIUR = %@", self.emailContactIUR];
        [self.callGenericServices genericGetData:flagSqlStatement action:@selector(setFlagGenericGetDataResult:) target:self];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        [self.callGenericServices.HUD hide:YES];
    }
}

#pragma mark - setFlagGenericGetDataResult
-(void)setFlagGenericGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code >= 0) {
        [self.customerContactTypesDataManager processRawData:self.contactGenericReturnObject flagData:result.ArrayOfData];
        [self createEmailComposeViewControllerWithType:self.emailActionType];
    } else if(result.ErrorModel.Code < 0) {
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)createEmailComposeViewControllerWithType:(NSString*)anEmailActionType {
    NSNumber* employeeIUR = [SettingManager employeeIUR];
    NSDictionary* employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:employeeIUR];
    NSString* employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[employeeDict objectForKey:@"Surname"]]];
    NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:self.myArcosAdminEmail, nil];
    NSString* subject = @"";
    if ([anEmailActionType isEqualToString:@"edit"]) {
        subject = [NSString stringWithFormat:@"Please Amend Contact Details from %@", employeeName];        
    } else {
        subject = [NSString stringWithFormat:@"Please Create a new Contact for %@", employeeName];
    }
    NSString* body = [self.customerContactTypesDataManager buildEmailMessageBody];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.toRecipients = toRecipients;
        amwvc.subjectText = subject;
        amwvc.bodyText = body;
        amwvc.isHTML = YES;            
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
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    MFMailComposeViewController* mailController = [[[MFMailComposeViewController alloc] init] autorelease];
    mailController.mailComposeDelegate = self;
    
    [mailController setToRecipients:toRecipients];
    [mailController setSubject:subject];    
    
    [mailController setMessageBody:body isHTML:YES];
    [self.rootView presentViewController:mailController animated:YES completion:nil];
}
@end
