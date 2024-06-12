//
//  CustomerInfoTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 24/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoTableViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "OrderSharedClass.h"
#import "SavedOrderTableCell.h"
#import "ArcosUtils.h"
#import "ArcosStackedViewController.h"
#import "ArcosRootViewController.h"

@interface CustomerInfoTableViewController (Private)
-(void)resetContentWithDict:(NSMutableDictionary*)aDict compulsoryRefresh:(BOOL)aFlag;
-(void)convertToTableCustData:(NSMutableDictionary*)dict compulsoryRefresh:(BOOL)aFlag;
- (void)refreshOptionDescription:(NSMutableDictionary*)dict compulsoryRefresh:(BOOL)aFlag;
- (void)refreshOptionDescriptionProcessor:(NSMutableDictionary*)dict;
-(void)processLastCallOption;
-(void)refresh;
-(void)clearGlobalNavigationController;
//-(void)createCustKeysWithStatus:(NSString*)statusValue;
-(void)historyActionSelectedIndex:(NSInteger)index;
-(void)analysisActionSelectedIndex:(NSInteger)index;
-(void)overviewActionSelectedIndex:(NSInteger)index;
-(void)layoutMySubviews;
- (void)alertViewCallBack;
@end

@implementation CustomerInfoTableViewController

@synthesize refreshDelegate = _refreshDelegate;
@synthesize aCustDict;
@synthesize custIUR;
@synthesize aCustKeys;
@synthesize detailButCell;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

@synthesize orderHeader;

@synthesize myTopHeaderButtonView = _myTopHeaderButtonView;
@synthesize myTopHeaderLabelView = _myTopHeaderLabelView;
@synthesize myTopHeaderView = _myTopHeaderView;
@synthesize locationDefaultContactIUR = _locationDefaultContactIUR;
@synthesize locationDefaultContactName = _locationDefaultContactName;
@synthesize mailController = _mailController;
@synthesize customerInfoTableDataManager = _customerInfoTableDataManager;
@synthesize customerCoverHomePageImageViewController = _customerCoverHomePageImageViewController;
@synthesize customerDetailsBuyingGroupDataManager = _customerDetailsBuyingGroupDataManager;
@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize accountBalanceLabel = _accountBalanceLabel;
@synthesize callGenericServices = _callGenericServices;
@synthesize customerTypesDataManager = _customerTypesDataManager;
@synthesize myArcosAdminEmail = _myArcosAdminEmail;
@synthesize customerAccessTimesUtils = _customerAccessTimesUtils;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
//    self.tableView.backgroundColor=[UIColor whiteColor];
    self.customerAccessTimesUtils = [[[CustomerAccessTimesUtils alloc] init] autorelease];
    self.accountBalanceLabel = @"A/C Balance";
    self.tableView.allowsSelection=YES;
    needShowDetail=NO;
    NSMutableDictionary* location=[[[ArcosCoreData sharedArcosCoreData] locationWithIUR:self.custIUR]objectAtIndex:0];
    if (location == nil) {
        [ArcosUtils showDialogBox:@"Location information not available on this iPad." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        return;
    }
    self.customerInfoTableDataManager = [[[CustomerInfoTableDataManager alloc] initWithLocationIUR:self.custIUR] autorelease];
    [self.customerInfoTableDataManager createCustKeysOnStartUp];
    
    self.customerInfoTableDataManager.csIUR = [location objectForKey:@"CSiur"];
    [self resetContentWithDict:location compulsoryRefresh:NO];
    
    //animations
    self.orderHeader=[[OrderSharedClass sharedOrderSharedClass]getADefaultOrderHeader];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    arcosCustomiseAnimation.delegate = self;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editPressed:)];
    [self.navigationItem setRightBarButtonItem:editButton];
    [editButton release];
    
//    NSString* status=@"UnAssigned";//[statusDict objectForKey:@"Details"];
//    
//    [self createCustKeysWithStatus:status];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.myTopHeaderLabelView addGestureRecognizer:singleTap];
    [singleTap release];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self processAccountBalanceRecord];
    [self.customerInfoTableDataManager processIssuesRecord];
    [self.customerInfoTableDataManager processAccountOverviewRecord];
    [self.customerInfoTableDataManager processGDPRRecord];
    //set the location iur to order header
    [self.orderHeader setObject:[aCustDict objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    [self processLastCallOption];
    
    
    [self.tableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.callGenericServices == nil) {
        self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
        self.callGenericServices.delegate = self;
    }
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
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self layoutMySubviews];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.aCustDict == nil) {
        return 0;
    }
    return [self.customerInfoTableDataManager.sectionTitleList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* auxSectionTitle = [self.customerInfoTableDataManager.sectionTitleList objectAtIndex:section];
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.infoSectionTitle]) {
//        NSLog(@"number of row for the section %d",[aCustKeys count]);
        if (needShowDetail) {
            return [self.customerInfoTableDataManager.custKeyList count] + 1;
        }else{
            return [self.customerInfoTableDataManager.headerItemList count] + 1;
        }
        
    }else if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.historySectionTitle]){
        return [self.customerInfoTableDataManager.historyKeyList count];
    }else if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.analysisSectionTitle]){
        return [self.customerInfoTableDataManager.analysisKeyList count];
    }else {
        return [self.customerInfoTableDataManager.overviewKeyList count];
    }

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.customerInfoTableDataManager.sectionTitleList objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        if (self.locationDefaultContactIUR != nil) {
            self.myTopHeaderLabelView.text = [NSString stringWithFormat:@"%@\n%@",self.locationDefaultContactName, [self.aCustDict objectForKey:@"Name"]];
        } else {
            self.myTopHeaderLabelView.text = [self.aCustDict objectForKey:@"Name"];
        }
        if ([GlobalSharedClass shared].currentSelectedContactIUR != nil) {
            self.myTopHeaderLabelView.text = [NSString stringWithFormat:@"%@\n%@",[OrderSharedClass sharedOrderSharedClass].currentContactName, [self.aCustDict objectForKey:@"Name"]];
        }
        return self.myTopHeaderView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 56.0f;
    }
    return 38.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* auxSectionTitle = [self.customerInfoTableDataManager.sectionTitleList objectAtIndex:indexPath.section];
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.infoSectionTitle]) {//info cell
        self.detailButCell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row == [self.customerInfoTableDataManager.headerItemList count] && !needShowDetail) {
            return self.detailButCell;
        }
        if (indexPath.row == [self.customerInfoTableDataManager.custKeyList count] && needShowDetail) {
            return self.detailButCell;
        }
    }
    
    NSString *CellIdentifier = @"cell";
    NSString* auxCustKey = [self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row];
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.infoSectionTitle]) {
        CellIdentifier=@"CustomerInfoCell";
        if (needShowDetail) {
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showAccountBalancesFlag] && indexPath.row == self.customerInfoTableDataManager.buyingGroupIndex-1) {
                CellIdentifier=@"CustomerInfoButtonCell";
            }
            if (indexPath.row == self.customerInfoTableDataManager.linkedToIndex) {
                CellIdentifier = @"IdCustomerInfoLinkedToTableViewCell";
            }
            if ([auxCustKey isEqualToString:self.customerInfoTableDataManager.accessTimesLabel]) {
                CellIdentifier = @"IdCustomerInfoAccessTimesTableViewCell";
            }
            if ([auxCustKey isEqualToString:self.customerInfoTableDataManager.startTimeLabel]) {
                CellIdentifier = @"IdCustomerInfoStartTimeTableViewCell";
            }
        }
    }else{
        CellIdentifier=@"CustomerOptionCell";
    }
    
    UITableViewCell *cell=(UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerInfoTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[UITableViewCell class]] && [[(UITableViewCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (UITableViewCell *) nibItem;
                break;
            }
        }
	}
    

    
    // Configure the cell...
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.infoSectionTitle]) {//info cell
        //NSLog(@"customer is %@",self.aCustDict);
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showAccountBalancesFlag] && indexPath.row == self.customerInfoTableDataManager.buyingGroupIndex-1) {
            CustomerInfoButtonCell* aCell = (CustomerInfoButtonCell*)cell;
//            aCell.cellData = self.aCustDict;
            aCell.actionDelegate = self;
            aCell.infoTitle.text = [self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row];
            aCell.infoValue.text = [self.aCustDict objectForKey:[self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row]];
            [aCell configCellWithData:self.aCustDict];
            return aCell;
        }
        if (self.customerInfoTableDataManager.linkedToIndex != 0 && indexPath.row == self.customerInfoTableDataManager.linkedToIndex) {
            CustomerInfoLinkedToTableViewCell* tmpCell = (CustomerInfoLinkedToTableViewCell*)cell;
            tmpCell.actionDelegate = self;
            if ([self.customerInfoTableDataManager.auxLinkedContactCOiur intValue] <= 0) {
                tmpCell.infoTitle.text = [self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row];
            } else {
                tmpCell.infoTitle.text = self.customerInfoTableDataManager.auxLinkedContactContactTitle;
            }
            
            tmpCell.infoValue.text = [self.aCustDict objectForKey:[self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row]];
            [tmpCell configCellWithData:self.aCustDict];
            return tmpCell;
        }
        if ([auxCustKey isEqualToString:self.customerInfoTableDataManager.accessTimesLabel]) {
            CustomerInfoAccessTimesTableViewCell* auxAccessTimesCell = (CustomerInfoAccessTimesTableViewCell*)cell;
            auxAccessTimesCell.actionDelegate = self;
            auxAccessTimesCell.infoTitle.text = auxCustKey;
            auxAccessTimesCell.infoValue.text = [self.customerAccessTimesUtils retrieveAccessTimesInfoValue:[self.aCustDict objectForKey:self.customerInfoTableDataManager.accessTimesLabel]];
            //[self.customerInfoTableDataManager retrieveAccessTimesInfoValue:self.aCustDict];
            [auxAccessTimesCell configCellWithData:self.aCustDict];
            return auxAccessTimesCell;
        }
        if ([auxCustKey isEqualToString:self.customerInfoTableDataManager.startTimeLabel]) {
            CustomerInfoStartTimeTableViewCell* auxStartTimeCell = (CustomerInfoStartTimeTableViewCell*)cell;
            auxStartTimeCell.actionDelegate = self;
            auxStartTimeCell.infoTitle.text = auxCustKey;            
            [auxStartTimeCell configCellWithoutData];
            return auxStartTimeCell;
        }
        
        CustomerInfoCell* aCell=(CustomerInfoCell*)cell;
        if (indexPath.row<1||indexPath.row>4) {
            NSString* tmpCustKey = [self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row];
            if (indexPath.row > self.customerInfoTableDataManager.buyingGroupIndex && [tmpCustKey hasPrefix:self.customerInfoTableDataManager.buyingGroupLabel]) {
                aCell.infoTitle.text=@"";
            } else {
                aCell.infoTitle.text=[self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row];
            }
        }else{
            aCell.infoTitle.text=@"";

        }
        aCell.infoValue.text=[self.aCustDict objectForKey:[self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row]];
        if (aCell.infoTitle.text != nil && [aCell.infoTitle.text isEqualToString:self.customerInfoTableDataManager.emailLabel] && indexPath.row <= [self.customerInfoTableDataManager.headerItemList count] && aCell.infoValue.text != nil && ![aCell.infoValue.text isEqualToString:@""]) {
            NSDictionary* underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            aCell.infoValue.attributedText = [[[NSAttributedString alloc] initWithString:[self.aCustDict objectForKey:[self.customerInfoTableDataManager.custKeyList objectAtIndex:indexPath.row]] attributes:underlineAttribute] autorelease];
            aCell.infoValue.textColor = [UIColor blueColor];
            aCell.accessoryType = UITableViewCellAccessoryNone;
        } else if (aCell.infoTitle.text != nil && [aCell.infoTitle.text isEqualToString:self.customerInfoTableDataManager.lastCallLabel] && indexPath.row <= [self.customerInfoTableDataManager.headerItemList count] && aCell.infoValue.text != nil && ![aCell.infoValue.text isEqualToString:@""]) {
            aCell.infoValue.textColor = [UIColor blackColor];
            aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            aCell.infoValue.textColor = [UIColor blackColor];
            aCell.accessoryType = UITableViewCellAccessoryNone;
        }
        aCell.selectionStyle=UITableViewCellSelectionStyleNone;

        return aCell;
        
    }else if([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.historySectionTitle]){//local action cell
        CustomerOptionCell* aCell=(CustomerOptionCell*)cell;
        aCell.optionTitle.text=[self.customerInfoTableDataManager.historyKeyList objectAtIndex:indexPath.row];
        aCell.optionAddBut.hidden=YES;
        aCell.optionAddBut.tag=indexPath.row;
        aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        aCell.optionDetail.hidden=YES;
        aCell.delegate=self;
        aCell.optionIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.customerInfoTableDataManager.historyImageKeyList objectAtIndex:indexPath.row]]];
        
        if ([self.customerInfoTableDataManager.codeType intValue] == 2) {
            aCell.optionAddBut.enabled = NO;
        }
        
        return aCell;
        
    }else if([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.analysisSectionTitle]){//remote action cell
        
        CustomerOptionCell* aCell=(CustomerOptionCell*)cell;
        aCell.optionAddBut.tag=indexPath.row+200;
        aCell.optionAddBut.hidden=YES;
        aCell.optionDetail.hidden=YES;
        aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        aCell.optionTitle.text=[self.customerInfoTableDataManager.analysisKeyList objectAtIndex:indexPath.row];
        aCell.delegate=self;
        aCell.optionIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.customerInfoTableDataManager.analysisImageKeyList objectAtIndex:indexPath.row]]];

        return aCell;
        
    }else{
        CustomerOptionCell* aCell=(CustomerOptionCell*)cell;
        aCell.optionAddBut.hidden=YES;
        aCell.optionDetail.hidden=YES;
        aCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        aCell.optionTitle.text=[self.customerInfoTableDataManager.overviewKeyList objectAtIndex:indexPath.row];
        aCell.delegate=self;
        aCell.optionIcon.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.customerInfoTableDataManager.overviewImageKeyList objectAtIndex:indexPath.row]]];
        return aCell;
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* auxSectionTitle = [self.customerInfoTableDataManager.sectionTitleList objectAtIndex:indexPath.section];
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.infoSectionTitle]) {//info cell
        if (indexPath.row==[self.customerInfoTableDataManager.headerItemList count]&&!needShowDetail) {
            needShowDetail=!needShowDetail;
            [self refreshOptionDescriptionProcessor:self.aCustDict];
            self.detailButCell.infoTitle.text=@"Hide";
            [self.tableView reloadData];
        }
        if (indexPath.row==[self.customerInfoTableDataManager.custKeyList count]&&needShowDetail) {
            self.detailButCell.infoTitle.text=@"More";
            needShowDetail=!needShowDetail;
            [self.tableView reloadData];
        }
        
        //email checking
        CustomerInfoCell* aCell = (CustomerInfoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        if (aCell.infoTitle.text != nil && [aCell.infoTitle.text isEqualToString:self.customerInfoTableDataManager.emailLabel] && aCell.infoValue.text != nil && ![aCell.infoValue.text isEqualToString:@""]) {
            NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:aCell.infoValue.text, nil];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//                    amwvc.myDelegate = self;
                amwvc.mailDelegate = self;
                amwvc.toRecipients = toRecipients;
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
            self.mailController = [[[MFMailComposeViewController alloc] init]autorelease];
            self.mailController.mailComposeDelegate = self;
            
            [self.mailController setToRecipients:toRecipients];
            [self.rootView presentViewController:self.mailController animated:YES completion:nil];
        }
        if (aCell.infoTitle.text != nil && [aCell.infoTitle.text isEqualToString:self.customerInfoTableDataManager.lastCallLabel] && [self.aCustDict objectForKey:@"LastOrderNumber"] != nil) {//last call
            NSMutableArray* tmpObjectList = [[ArcosCoreData sharedArcosCoreData] lastOrderWithOrderNumber:[self.aCustDict objectForKey:@"LastOrderNumber"]];
            if ([tmpObjectList count] > 0) {
                NSDictionary* tmpDict = [tmpObjectList objectAtIndex:0];
                NSMutableDictionary* tmpMutableDict = [NSMutableDictionary dictionaryWithDictionary:tmpDict];
                NSNumber* orderHeaderIUR = [tmpMutableDict objectForKey:@"OrderHeaderIUR"];
                if ([orderHeaderIUR intValue]>0||[orderHeaderIUR intValue]<0) {
                    [tmpMutableDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
                }else{
                    [tmpMutableDict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCealed"];
                }
                OrderDetailTableViewController* odtvc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
                [odtvc loadSavedOrderDetailCellData:tmpMutableDict];
                UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:odtvc];
                [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
                [odtvc release];
                [tmpNavigationController release];
            }
        }
    }
    //local actions cell
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.historySectionTitle]){
        [self historyActionSelectedIndex:indexPath.row];
    }
    //analysis actions cell
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.analysisSectionTitle]){
        [self analysisActionSelectedIndex:indexPath.row];
    }
    if ([auxSectionTitle isEqualToString:self.customerInfoTableDataManager.overviewSectionTitle]) {
        [self overviewActionSelectedIndex:indexPath.row];
    }
}


#pragma mark reset the customer dictionary
//reset the content of the view
-(void)resetContentWithDict:(NSMutableDictionary*)aDict compulsoryRefresh:(BOOL)aFlag{
    
    [self convertToTableCustData:aDict compulsoryRefresh:aFlag];
}
-(void)convertToTableCustData:(NSMutableDictionary *)dict compulsoryRefresh:(BOOL)aFlag{
    NSString* Name=[ArcosUtils convertNilToEmpty:[dict objectForKey:@"Name"]];
    NSString* Email=[dict objectForKey:@"Email"];
    if (Email==nil) {
        Email=@"";
    }
    NSString* FaxNumber=[dict objectForKey:@"FaxNumber"];
    if (FaxNumber==nil) {
        FaxNumber=@"";
    }
    NSString* PhoneNumber=[dict objectForKey:@"PhoneNumber"];
    NSString* Address1=[dict objectForKey:@"Address1"];

    self.aCustDict=[NSMutableDictionary dictionaryWithDictionary:dict];
    [self.aCustDict setObject:Name forKey:@"Name"];
    if (Email==nil) {
        [self.aCustDict setObject:@"" forKey:@"Email"];
    }else{
        [self.aCustDict setObject:Email forKey:@"Email"];
    }
    if (FaxNumber==nil) {
        [self.aCustDict setObject:@"" forKey:@"Fax Number"];
    }else{
        [self.aCustDict setObject:FaxNumber forKey:@"Fax Number"];
    }
    if (PhoneNumber==nil) {
        [self.aCustDict setObject:@"" forKey:@"Phone Number"];
    }else{
        [self.aCustDict setObject:PhoneNumber forKey:@"Phone Number"];
    }
//    [self processLastCallOption];
    
    [self.aCustDict setObject:[ArcosUtils convertNilToEmpty:Address1] forKey:@"Address"];
    
    [self refreshOptionDescription:dict compulsoryRefresh:aFlag];
}

- (void)refreshOptionDescription:(NSMutableDictionary*)dict compulsoryRefresh:(BOOL)aFlag {
    if (aFlag) {
        [self refreshOptionDescriptionProcessor:dict];
    } else {
        if (needShowDetail || [[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].myDbName]) {
            [self refreshOptionDescriptionProcessor:dict];
        }
    }
}

- (void)refreshOptionDescriptionProcessor:(NSMutableDictionary*)dict {
    NSMutableArray* iurList = [NSMutableArray array];
    NSNumber* CSiurNumber = [dict objectForKey:@"CSiur"];
    if (CSiurNumber != nil) {
        [iurList addObject:CSiurNumber];
    }
    NSNumber* LTiurNumber = [dict objectForKey:@"LTiur"];
    if (LTiurNumber != nil) {
        [iurList addObject:LTiurNumber];
    }
    NSNumber* lsiurNumber = [dict objectForKey:@"lsiur"];
    if (lsiurNumber != nil) {
        [iurList addObject:lsiurNumber];
    }
//    NSNumber* LP01Number = [dict objectForKey:@"LP01"];
//    if (LP01Number != nil) {
//        [iurList addObject:LP01Number];
//    }
    NSNumber* pgiurNumber = [dict objectForKey:@"PGiur"];
    if (pgiurNumber != nil) {
        [iurList addObject:pgiurNumber];
    }
    
    NSMutableArray* descDictList = [[ArcosCoreData sharedArcosCoreData] descriptionWithIURList:iurList];
    NSMutableDictionary* descDictHashMap = [NSMutableDictionary dictionaryWithCapacity:[descDictList count]];
    for (int i = 0; i < [descDictList count]; i++) {
        NSDictionary* descDict = [descDictList objectAtIndex:i];
        [descDictHashMap setObject:descDict forKey:[descDict objectForKey:@"DescrDetailIUR"]];
    }
    NSDictionary* aDict = nil;
    
    if (CSiurNumber != nil) {
        aDict = [descDictHashMap objectForKey:CSiurNumber];
        NSString* detail=[aDict objectForKey:@"Detail"];
        if (detail!=nil) {
            [self.aCustDict setObject:detail forKey:self.customerInfoTableDataManager.creditStatusLabel];
        }else{
            [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.creditStatusLabel];
        }
    }else{
        [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.creditStatusLabel];
    }
    
    
    if (LTiurNumber != nil) {
        aDict = [descDictHashMap objectForKey:LTiurNumber];
        NSString* detail=[aDict objectForKey:@"Detail"];
        if (detail!=nil) {
            [self.aCustDict setObject:detail forKey:self.customerInfoTableDataManager.locationTypeLabel];
            
        }else{
            [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.locationTypeLabel];
            
        }
    }else{
        [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.locationTypeLabel];
    }
    
    
    if (lsiurNumber != nil) {
        aDict = [descDictHashMap objectForKey:lsiurNumber];
        NSString* detail=[aDict objectForKey:@"Detail"];
        if (detail!=nil) {
            [self.aCustDict setObject:detail forKey:self.customerInfoTableDataManager.locationStatusLabel];
            
        }else{
            [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.locationStatusLabel];
            
        }
    }else{
        [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.locationStatusLabel];
    }
    
    if (pgiurNumber != nil) {
        aDict = [descDictHashMap objectForKey:pgiurNumber];
        NSString* detail = [aDict objectForKey:@"Detail"];
        if (detail != nil) {
            [self.aCustDict setObject:detail forKey:self.customerInfoTableDataManager.priceGroupsLabel];
        } else {
            [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.priceGroupsLabel];
        }
    } else {
        [self.aCustDict setObject:@"UnAssigned" forKey:self.customerInfoTableDataManager.priceGroupsLabel];
    }
    
    
    //bad fit for the staus label
//    NSDictionary* statusDict=[[ArcosCoreData sharedArcosCoreData]descrTypeAllRecordsWithTypeCode:@"21"];
//    NSString* status=[statusDict objectForKey:@"Details"];
//    [self createCustKeysWithStatus:status];
    
    [self.customerInfoTableDataManager processLocationProfileWithDict:self.aCustDict];
    [self.customerInfoTableDataManager processContactProfileWithContactIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
    [self.customerInfoTableDataManager createCustKeysOnProcessing:self.aCustDict];
    [self processAccountBalanceRecord];
    
//    if (LP01Number != nil) {
//        aDict = [descDictHashMap objectForKey:LP01Number];
//        NSString* detail=[aDict objectForKey:@"Detail"];
//        if (detail!=nil) {
//            [self.aCustDict setObject:detail forKey:status];
//        }else{
//            [self.aCustDict setObject:@"UnAssigned" forKey:status];
//        }
//        
//    }else{
//        [self.aCustDict setObject:@"UnAssigned" forKey:status];
//    }
    
    if ([dict objectForKey:@"LocationCode"] != nil) {
        [self.aCustDict setObject:[dict objectForKey:@"LocationCode"] forKey:@"Location Code"];
    } else {
        [self.aCustDict setObject:@"UnAssigned" forKey:@"Location Code"];
    }
    
    
    
    
    //MemberOf;
    NSString* groupName=[[ArcosCoreData sharedArcosCoreData]locationNameWithIUR:[dict objectForKey:@"MasterLocationIUR"]];
    
    [self.aCustDict setObject:[ArcosUtils convertNilToEmpty:groupName] forKey:@"Member Of"];
    [self.aCustDict setObject:[ArcosUtils convertNilToEmpty:[dict objectForKey:@"accessTimes"]] forKey:self.customerInfoTableDataManager.accessTimesLabel];
    [self.aCustDict setObject:[NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"OustandingBalance"] floatValue]] forKey:@"A/C Balance"];
    if (self.customerDetailsBuyingGroupDataManager == nil) {
        self.customerDetailsBuyingGroupDataManager = [[[CustomerDetailsEditDataManager alloc] init] autorelease];
    }
        
    NSMutableArray* linksLocationList = [self.customerDetailsBuyingGroupDataManager buyingGroupLocationListWithLocationIUR:[dict objectForKey:@"LocationIUR"]];
    NSSortDescriptor* descriptor = [[[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
    [linksLocationList sortUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    for (NSUInteger i = [self.customerInfoTableDataManager.custKeyList count] - 1; i > self.customerInfoTableDataManager.buyingGroupIndex; i--) {
        NSString* tmpCustKey = [self.customerInfoTableDataManager.custKeyList objectAtIndex:i];
        if ([tmpCustKey hasPrefix:self.customerInfoTableDataManager.buyingGroupLabel]) {
            [self.aCustDict removeObjectForKey:tmpCustKey];
            [self.customerInfoTableDataManager.custKeyList removeObjectAtIndex:i];
        }
    }
    if ([linksLocationList count] > 0) {
        NSMutableDictionary* tmpLocationDict = [linksLocationList objectAtIndex:0];
        [self.aCustDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[tmpLocationDict objectForKey:@"Name"]]] forKey:self.customerInfoTableDataManager.buyingGroupLabel];
        for (int i = 1; i < [linksLocationList count]; i++) {
            NSMutableDictionary* tmpInnerLocationDict = [linksLocationList objectAtIndex:i];
            NSString* tmpKey = [NSString stringWithFormat:@"%@%d", self.customerInfoTableDataManager.buyingGroupLabel, i];
            [self.customerInfoTableDataManager.custKeyList insertObject:tmpKey atIndex:self.customerInfoTableDataManager.buyingGroupIndex+i];
            [self.aCustDict setObject:[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[tmpInnerLocationDict objectForKey:@"Name"]]] forKey:tmpKey];
        }
        self.customerInfoTableDataManager.extraBuyingGroupItemQty = [ArcosUtils convertNSUIntegerToUnsignedInt:[linksLocationList count]] - 1;
    } else {
        [self.aCustDict setObject:@"" forKey:self.customerInfoTableDataManager.buyingGroupLabel];
        self.customerInfoTableDataManager.extraBuyingGroupItemQty = 0;
    }
    
}


#pragma mark ustomer option cell delegate
-(void)AddButtonPressed:(NSInteger)index{

}



#pragma mark view delegate
- (void)didDismissModalView{
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        [self clearGlobalNavigationController];
    }];
    [self refresh];
    
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}
#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        [self clearGlobalNavigationController];
    }];
}
-(void)clearGlobalNavigationController {
    self.globalNavigationController = nil;
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
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
        self.customerInfoTableDataManager.popoverOpenFlag = NO;
    }];
}

-(void)editPressed:(id)sender {
    if (self.customerInfoTableDataManager.popoverOpenFlag) {
        return;
    }
    self.customerInfoTableDataManager.popoverOpenFlag = YES;
    self.myArcosAdminEmail = [ArcosUtils convertNilToEmpty:[SettingManager arcosAdminEmail]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableEditLocationByEmailFlag]) {        
        [self.callGenericServices getRecord:@"Location" iur:[[self.aCustDict objectForKey:@"LocationIUR"] intValue] filter:@""];
        return;
    }
    CustomerDetailsWrapperModalViewController* cdwmvc = [[CustomerDetailsWrapperModalViewController alloc] initWithNibName:@"CustomerDetailsWrapperModalViewController" bundle:nil];
    cdwmvc.myDelegate = self;
    cdwmvc.delegate = self;
    cdwmvc.refreshDelegate = self;
    cdwmvc.actionDelegate = self;
    cdwmvc.navgationBarTitle = [NSString stringWithFormat:@"Details for %@", [aCustDict objectForKey:@"Name"]];
    cdwmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
    cdwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [cdwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

-(void)refresh{
    NSMutableDictionary* location=[[[ArcosCoreData sharedArcosCoreData] locationWithIUR:self.custIUR]objectAtIndex:0];
    [self resetContentWithDict:location compulsoryRefresh:YES];
    [self.tableView reloadData];
}

- (void) refreshParentContent {
    [self.refreshDelegate refreshParentContent];
}

- (void)refreshParentContentByEdit {
    [self refresh];
    [self.refreshDelegate refreshParentContentByEdit];
}

-(void)dealloc{
    self.custIUR=nil;
    self.aCustKeys = nil;
    self.aCustDict = nil;
    
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) {
        self.rootView = nil;
    }
    [arcosCustomiseAnimation release];
    self.orderHeader = nil;
    if (self.locationDefaultContactIUR != nil) { self.locationDefaultContactIUR = nil; }
    self.locationDefaultContactName = nil;
    if (self.mailController != nil) { self.mailController = nil; }
    self.myTopHeaderButtonView = nil;
    self.myTopHeaderLabelView = nil;
    self.myTopHeaderView = nil;
    self.detailButCell = nil;
    self.customerInfoTableDataManager = nil;
    [self.customerCoverHomePageImageViewController.view removeFromSuperview];
    self.customerCoverHomePageImageViewController = nil;
    self.customerDetailsBuyingGroupDataManager = nil;
    self.factory = nil;
//    self.thePopover = nil;
    self.globalWidgetViewController = nil;
    self.accountBalanceLabel = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.customerTypesDataManager = nil;
    self.myArcosAdminEmail = nil;
    self.customerAccessTimesUtils = nil;
    
    [super dealloc];
    
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
        self.mailController = nil;
        self.customerInfoTableDataManager.popoverOpenFlag = NO;
    }];
}

-(void)processLastCallOption {
    OrderHeader* lastOrderHeaderDict = [[ArcosCoreData sharedArcosCoreData] theLastOrderHeaderWithLocationIUR:[self.aCustDict objectForKey:@"LocationIUR"]];
    if (lastOrderHeaderDict != nil) {
        [self.aCustDict setObject:lastOrderHeaderDict.OrderNumber forKey:@"LastOrderNumber"];
        [self.aCustDict setObject:[NSString stringWithFormat:@"%@",[ArcosUtils stringFromDate:lastOrderHeaderDict.OrderDate format:@"dd/MM/yyyy"]] forKey:@"Last Call"];
    }
}

#pragma mark ArcosCustomiseAnimationDelegate
- (void)dismissPushViewCallBack {
    [self performSelector:@selector(clearGlobalNavigationController) withObject:nil afterDelay:0.3];
}
//-(void)createCustKeysWithStatus:(NSString*)statusValue {
//    self.aCustKeys=[[[NSMutableArray alloc] initWithObjects:@"Address",@"Address2",@"Address3",@"Address4",@"Phone Number",@"Email",@"Last Call",@"Fax Number",statusValue,@"Credit Status",@"Location Type",@"Location Status",@"Location Code",@"Member Of",self.customerInfoTableDataManager.buyingGroupLabel, nil] autorelease];
//}

-(void)historyActionSelectedIndex:(NSInteger)index {
    NSString* historyKey = [self.customerInfoTableDataManager.historyKeyList objectAtIndex:index];
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.orderCallLabel]) {
        CustomerIarcosSavedOrderTableViewController* CISOTVC = [[CustomerIarcosSavedOrderTableViewController alloc] initWithNibName:@"CustomerIarcosSavedOrderTableViewController" bundle:nil];
        CISOTVC.coordinateType = [NSNumber numberWithInt:0];
        CISOTVC.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        CISOTVC.locationDefaultContactIUR = self.locationDefaultContactIUR;
        if ([GlobalSharedClass shared].currentSelectedContactIUR != nil) {
            CISOTVC.locationDefaultContactIUR = [GlobalSharedClass shared].currentSelectedContactIUR;
        }
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:CISOTVC];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [CISOTVC release];
        [tmpNavigationController release];
    }
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.invoicesLabel]) {
        CustomerInvoiceModalViewController* cimvc =[[CustomerInvoiceModalViewController alloc]initWithNibName:@"CustomerInvoiceModalViewController" bundle:nil];
//        cimvc.animateDelegate=self;
        cimvc.title = [NSString stringWithFormat:@"Invoices for %@", [aCustDict objectForKey:@"Name"]];
        cimvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        cimvc.rootView = self.rootView;
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cimvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [cimvc release];
        [tmpNavigationController release];
    }
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.memosLabel]) {
        CustomerMemoModalViewController* cmmvc =[[CustomerMemoModalViewController alloc]initWithNibName:@"CustomerMemoModalViewController" bundle:nil];
        cmmvc.animateDelegate=self;
        cmmvc.title = [NSString stringWithFormat:@"Memos for %@", [aCustDict objectForKey:@"Name"]];
        cmmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cmmvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [cmmvc release];
        [tmpNavigationController release];
    }
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.surveysLabel]) {
        CustomerSurveySummaryTableViewController* csstvc = [[CustomerSurveySummaryTableViewController alloc] initWithNibName:@"CustomerSurveySummaryTableViewController" bundle:nil];
        csstvc.title = [NSString stringWithFormat:@"%@ for %@", self.customerInfoTableDataManager.surveysLabel, [aCustDict objectForKey:@"Name"]];
        csstvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:csstvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [csstvc release];
        [tmpNavigationController release];
    }
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.issuesLabel]) {
//        QueryOrderTemplateSplitViewController* queryOrderTemplateSplitViewController = [[QueryOrderTemplateSplitViewController alloc] initWithNibName:@"QueryOrderTemplateSplitViewController" bundle:nil];
//        queryOrderTemplateSplitViewController.queryOrderSource = QueryOrderHomePage;
//        queryOrderTemplateSplitViewController.refreshRequestSource = RefreshRequestHomePage;
//        queryOrderTemplateSplitViewController.animateDelegate = self;
//        queryOrderTemplateSplitViewController.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        
        QueryOrderMasterTableViewController* qomtvc = [[QueryOrderMasterTableViewController alloc] initWithStyle:UITableViewStylePlain];
        qomtvc.queryOrderSource = QueryOrderHomePage;
        qomtvc.refreshRequestSource = RefreshRequestHomePage;
        qomtvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        qomtvc.delegate = qomtvc;
        
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:qomtvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [qomtvc release];
        [tmpNavigationController release];
    }
    if ([historyKey hasPrefix:self.customerInfoTableDataManager.contactsLabel]) {
        CustomerContactInfoTableViewController* ccitvc = [[CustomerContactInfoTableViewController alloc] initWithNibName:@"CustomerContactInfoTableViewController" bundle:nil];
        ccitvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        ccitvc.title = [NSString stringWithFormat:@"Contacts for %@", [aCustDict objectForKey:@"Name"]];
        ccitvc.aCustDict = self.aCustDict;
        ccitvc.rootView = self.rootView;
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ccitvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [ccitvc release];
        [tmpNavigationController release];
    }
    if ([historyKey isEqualToString:self.customerInfoTableDataManager.flagsLabel]) {
        CustomerFlagModalViewController* cfmvc = [[CustomerFlagModalViewController alloc] initWithNibName:@"CustomerFlagModalViewController" bundle:nil];
        cfmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        cfmvc.title = [NSString stringWithFormat:@"Flags for %@", [aCustDict objectForKey:@"Name"]];
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cfmvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [cfmvc release];
        [tmpNavigationController release];
    }
}

-(void)analysisActionSelectedIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            UtilitiesAnimatedViewController* uavc = [[UtilitiesAnimatedViewController alloc] initWithNibName:@"UtilitiesAnimatedViewController" bundle:nil];
            uavc.customerName = [aCustDict objectForKey:@"Name"];
            uavc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            uavc.animateDelegate = self;
            if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
            
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:uavc] autorelease];
            [uavc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }
            break;
        case 1: {
            CustomerTyvLyModalViewController* ctlmvc =[[CustomerTyvLyModalViewController alloc]initWithNibName:@"CustomerTyvLyModalViewController" bundle:nil];
            ctlmvc.animateDelegate = self;
            ctlmvc.title = [NSString stringWithFormat:@"This Year vs Last Year for %@", [aCustDict objectForKey:@"Name"]];
            ctlmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ctlmvc] autorelease];
            [ctlmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }
            break;
        case 2: {
            CustomerNotBuyModalViewController* cnbmvc =[[CustomerNotBuyModalViewController alloc]initWithNibName:@"CustomerNotBuyModalViewController" bundle:nil];
            cnbmvc.isFirstLevel = YES;
            cnbmvc.animateDelegate=self;
            cnbmvc.title = [NSString stringWithFormat:@"Not Buy for %@", [aCustDict objectForKey:@"Name"]];
            cnbmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];            
            
            UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:cnbmvc];
            [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
            [cnbmvc release];
            [tmpNavigationController release];
        }
            break;
            
        default:
            break;
    }
}
-(void)overviewActionSelectedIndex:(NSInteger)index {
    NSString* overviewKey = [self.customerInfoTableDataManager.overviewKeyList objectAtIndex:index];
    if ([overviewKey isEqualToString:self.customerInfoTableDataManager.mapLabel]) {
        Location* tempLocation=[[ArcosCoreData sharedArcosCoreData]locationMAWithIUR:[self.aCustDict objectForKey:@"LocationIUR"]];
        if ([tempLocation.Latitude floatValue]==0||[tempLocation.Longitude floatValue]==0) {
            [ArcosUtils showDialogBox:@"No map available, due to Coordination is not assigned!" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {}];
        }else{
            LocationStampMapView* LSMV = [[LocationStampMapView alloc]initWithNibName:@"LocationStampMapView" bundle:nil];
            LSMV.title = [NSString stringWithFormat:@"Map of %@",[aCustDict objectForKey:@"Name"]];
            LSMV.animateDelegate = self;
            LSMV.locationIUR=[self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:LSMV] autorelease];
            [LSMV release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }
        return;
    }
    if ([overviewKey isEqualToString:self.customerInfoTableDataManager.photosLabel]) {
        CustomerPhotoSlideViewController* cpsvc = [[CustomerPhotoSlideViewController alloc] initWithNibName:@"CustomerPhotoSlideViewController" bundle:nil];
        cpsvc.locationIUR = [aCustDict objectForKey:@"LocationIUR"];
        cpsvc.title = [NSString stringWithFormat:@"Photos from %@", [aCustDict objectForKey:@"Name"]];
        cpsvc.animateDelegate = self;
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cpsvc] autorelease];
        [cpsvc release];
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        return;
    }
    if ([overviewKey isEqualToString:self.customerInfoTableDataManager.accountOverviewLabel]) {
        CustomerAccountOverviewViewController* caovc = [[CustomerAccountOverviewViewController alloc] initWithNibName:@"CustomerAccountOverviewViewController" bundle:nil];
        caovc.title = [NSString stringWithFormat:@"Detailed Account for %@", [aCustDict objectForKey:@"Name"]];
        caovc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        caovc.locationCode = [self.aCustDict objectForKey:@"LocationCode"];
        caovc.animateDelegate = self;
        caovc.myRootViewController = self.rootView;
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:caovc] autorelease];
        [caovc release];
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        return;
    }
    if ([overviewKey isEqualToString:self.customerInfoTableDataManager.gdprLabel]) {
        CustomerGDPRViewController* cgvc = [[CustomerGDPRViewController alloc] initWithNibName:@"CustomerGDPRViewController" bundle:nil];
        cgvc.rootView = self.rootView;
        cgvc.animateDelegate = self;
        cgvc.refreshDelegate = self;
        cgvc.customerGDPRDataManager.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
        cgvc.customerGDPRDataManager.locationName = [self.aCustDict objectForKey:@"Name"];
        cgvc.customerGDPRDataManager.locationAddress = [ArcosUtils trim:[NSString stringWithFormat:@"%@ %@ %@ %@ %@", [ArcosUtils convertNilToEmpty:[self.aCustDict objectForKey:@"Address1"]], [ArcosUtils convertNilToEmpty:[self.aCustDict objectForKey:@"Address2"]], [ArcosUtils convertNilToEmpty:[self.aCustDict objectForKey:@"Address3"]], [ArcosUtils convertNilToEmpty:[self.aCustDict objectForKey:@"Address4"]], [ArcosUtils convertNilToEmpty:[self.aCustDict objectForKey:@"Address5"]]]];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cgvc] autorelease];
        [cgvc release];
        [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        return;
    }
}

- (void)addCoverHomePageImageView {
    if (self.customerCoverHomePageImageViewController == nil) {
        self.customerCoverHomePageImageViewController = [[[CustomerCoverHomePageImageViewController alloc] initWithNibName:@"CustomerCoverHomePageImageViewController" bundle:nil] autorelease];
    }
    [self.navigationController.view addSubview:self.customerCoverHomePageImageViewController.view];
    self.customerCoverHomePageImageViewController.view.frame = self.view.frame;
}

-(void)layoutMySubviews {
    self.customerCoverHomePageImageViewController.view.frame = self.view.frame;
}

-(void)handleSingleTapGesture:(id)sender{
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    self.customerInfoTableDataManager.currentContactPopoverTag = 1;
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[self.aCustDict objectForKey:@"LocationIUR"]];
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [miscDataDict setObject:@"Contact" forKey:@"Title"];
    [miscDataDict setObject:[self.aCustDict objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
    [miscDataDict setObject:[self.aCustDict objectForKey:@"Name"] forKey:@"Name"];
    self.globalWidgetViewController =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
    //do show the popover if there is no data
    if (self.globalWidgetViewController!=nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:self.myTopHeaderLabelView.bounds inView:self.myTopHeaderLabelView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.sourceView = self.myTopHeaderLabelView;
        self.globalWidgetViewController.popoverPresentationController.sourceRect = self.myTopHeaderLabelView.bounds;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
    }    
}

#pragma mark WidgetFactoryDelegate
-(void)operationDone:(id)data{
//    if (self.thePopover!=nil) {
//        [self.thePopover dismissPopoverAnimated:YES];
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (self.customerInfoTableDataManager.currentContactPopoverTag) {
        case 1: {
            [GlobalSharedClass shared].currentSelectedContactIUR = [data objectForKey:@"IUR"];
            [self refreshOptionDescriptionProcessor:self.aCustDict];
            self.locationDefaultContactName = [data objectForKey:@"Title"];
            self.locationDefaultContactIUR = [data objectForKey:@"IUR"];
            [self.tableView reloadData];
        }
            break;
        case 2: {
            self.customerInfoTableDataManager.auxLinkedContactIUR = [data objectForKey:@"IUR"];
            self.customerInfoTableDataManager.auxContactFullName = [data objectForKey:@"Title"];
            self.customerInfoTableDataManager.auxLinkedContactCOiur = [data objectForKey:@"COiur"];
            [self.callGenericServices updateRecord:[NSString stringWithFormat:@"Contact,%d", [[SettingManager employeeIUR] intValue]] iur:[[GlobalSharedClass shared].currentSelectedContactIUR intValue] fieldName:@"linkedContactIUR" newContent:[ArcosUtils convertNumberToIntString:self.customerInfoTableDataManager.auxLinkedContactIUR]];
        }
            break;
            
        default:
            break;
    }
    
//    self.myTopHeaderLabelView.text = [NSString stringWithFormat:@"%@\n%@",[data objectForKey:@"Title"], [self.aCustDict objectForKey:@"Name"]];
    
}
-(void)setUpdateRecordResult:(ArcosGenericReturnObject*)result {
    if (result.ErrorModel.Code > 0) {
        [self.customerInfoTableDataManager updateLinkedContactIUR:self.customerInfoTableDataManager.auxLinkedContactIUR];
        [self.aCustDict setObject:self.customerInfoTableDataManager.auxContactFullName forKey:self.customerInfoTableDataManager.linkedToLabel];
        [self.customerInfoTableDataManager processLinkedContactCOiur:self.customerInfoTableDataManager.auxLinkedContactCOiur];
        [self.tableView reloadData];
    } else if(result.ErrorModel.Code <= 0) {
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}
-(BOOL)allowToShowAddContactButton {
    return YES;
}
#pragma mark UIPopoverControllerDelegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
//}
#pragma mark UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    self.globalWidgetViewController = nil;
}

- (void)processAccountBalanceRecord {
    int tmpBuyingGroupIndex = [self.customerInfoTableDataManager retrieveIndexByLabel:self.customerInfoTableDataManager.buyingGroupLabel];
    int tmpAccountBalanceIndex = tmpBuyingGroupIndex - 1;
    NSString* accountBalanceKey = [self.customerInfoTableDataManager.custKeyList objectAtIndex:tmpAccountBalanceIndex];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showAccountBalancesFlag]) {
        if (![accountBalanceKey isEqualToString:self.accountBalanceLabel]) {
            [self.customerInfoTableDataManager.custKeyList insertObject:self.accountBalanceLabel atIndex:tmpBuyingGroupIndex];
        }
    } else {
        if ([accountBalanceKey isEqualToString:self.accountBalanceLabel]) {
            [self.customerInfoTableDataManager.custKeyList removeObjectAtIndex:tmpAccountBalanceIndex];
        }
    }
    self.customerInfoTableDataManager.buyingGroupIndex = [self.customerInfoTableDataManager retrieveIndexByLabel:self.customerInfoTableDataManager.buyingGroupLabel];
    self.customerInfoTableDataManager.linkedToIndex = [self.customerInfoTableDataManager retrieveIndexByLabel:self.customerInfoTableDataManager.linkedToLabel];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        self.customerInfoTableDataManager.popoverOpenFlag = NO;
        return;
    }
    if (result.ErrorModel.Code >= 0 && [result.ArrayOfData count] > 0) {
        self.customerTypesDataManager = [[[CustomerTypesDataManager alloc] init] autorelease];
        self.customerTypesDataManager.myCustDict = self.aCustDict;
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
//            amwvc.myDelegate = self;
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
        if (![ArcosEmailValidator checkCanSendMailStatus:self]) {
            self.customerInfoTableDataManager.popoverOpenFlag = NO;
            return;
        }
        self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        self.mailController.mailComposeDelegate = self;
        
        [self.mailController setToRecipients:toRecipients];
        [self.mailController setSubject:subject];
        
        [self.mailController setMessageBody:body isHTML:YES];
        if (@available(iOS 13.0, *)) {
            self.mailController.modalInPresentation = YES;
        }
        self.mailController.modalPresentationStyle = UIModalPresentationPageSheet;
        self.mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.rootView presentViewController:self.mailController animated:YES completion:nil];
    } else if(result.ErrorModel.Code < 0 || [result.ArrayOfData count] == 0) {
//        [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
        self.customerInfoTableDataManager.popoverOpenFlag = NO;
    }
}

#pragma mark CustomerInfoLinkedToTableViewCellDelegate
- (void)selectCustomerInfoLinkedToRecord:(NSMutableDictionary *)aCellDict {
//    if (self.factory == nil) {
//        self.factory = [WidgetFactory factory];
//        self.factory.delegate = self;
//    }
//    self.customerInfoTableDataManager.currentContactPopoverTag = 2;
//    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[self.aCustDict objectForKey:@"LocationIUR"]];
//    int removeIndex = -1;
//    for (int i = 0; i < [contactList count]; i++) {
//        NSMutableDictionary* tmpContactDict = [contactList objectAtIndex:i];
//        if ([[tmpContactDict objectForKey:@"IUR"] isEqualToNumber:[GlobalSharedClass shared].currentSelectedContactIUR]) {
//            removeIndex = i;
//        }
//    }
//    if (removeIndex != -1) {
//        [contactList removeObjectAtIndex:removeIndex];
//    }
//    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
//    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
//    [miscDataDict setObject:@"Contact" forKey:@"Title"];
//    [miscDataDict setObject:[self.aCustDict objectForKey:@"LocationIUR"] forKey:@"LocationIUR"];
//    [miscDataDict setObject:[self.aCustDict objectForKey:@"Name"] forKey:@"Name"];
//    self.thePopover =[self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
//    //do show the popover if there is no data
//    if (self.thePopover!=nil) {
//        self.thePopover.delegate = self;
//        [self.thePopover presentPopoverFromRect:aValueLabel.bounds inView:aValueLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//    }
    self.customerInfoTableDataManager.auxLinkedContactIUR = [aCellDict objectForKey:@"IUR"];
    self.customerInfoTableDataManager.auxContactFullName = [aCellDict objectForKey:@"Title"];
    self.customerInfoTableDataManager.auxLinkedContactCOiur = [aCellDict objectForKey:@"COiur"];
    [self.callGenericServices updateRecord:[NSString stringWithFormat:@"Contact,%d", [[SettingManager employeeIUR] intValue]] iur:[[GlobalSharedClass shared].currentSelectedContactIUR intValue] fieldName:@"linkedContactIUR" newContent:[ArcosUtils convertNumberToIntString:self.customerInfoTableDataManager.auxLinkedContactIUR]];
}
- (UIViewController*)retrieveCustomerInfoLinkedToParentViewController {
    return self;
}

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    [self refresh];
}
- (UIViewController*)retrieveCustomerInfoAccessTimesCalendarParentViewController {
    return self;
}
#pragma mark CustomerInfoButtonCellDelegate
- (UIViewController*)retrieveCustomerInfoButtonParentViewController {
    return self;
}

@end
