//
//  SavedOrderDetailViewController.m
//  Arcos
//
//  Created by David Kilmartin on 13/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "SavedOrderDetailViewController.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "Reachability.h"
#import "SettingManager.h"
#import "DetailingTableViewController.h"
#import "SettingManager.h"
#import "ArcosUtils.h"
#include <arpa/inet.h>
#include "CustomerAnalyzeModalViewController.h"
#import "ArcosStackedViewController.h"

@interface SavedOrderDetailViewController (Private)
-(void)deleteOrderHeader:(NSMutableDictionary*)data;
-(void)deleteCurrentOrderHeader;
-(void)updateOrderHeaderWithOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber*)newOrderNumber;
-(void)updateOrderHeaderToFailWithOrderNumber:(NSNumber*)orderNumber ;
-(void)needCealTheCellWithOrderNumber:(NSNumber*)orderNumber need:(BOOL)need;
-(void)sendAllNewOrders;
-(void)stopCellAnimationWithOrderNumber:(NSNumber*)orderNumber withStatus:(BOOL)status;
-(void)stopAllCellAnimation;
-(void)refreshTheList;
-(BOOL)checkHostAddress;
-(void)checkConnection;
-(void)processPTranWhenAllowed;
@end

@implementation SavedOrderDetailViewController
@synthesize customerLabel = _customerLabel;
@synthesize valueLabel = _valueLabel;
@synthesize headerView = _headerView;
@synthesize tableData;
@synthesize displayList;
@synthesize isCellEditable;
@synthesize currentSelectDeleteIndexPath;
@synthesize currentSelectOrderHeader;
@synthesize delegate;
@synthesize orderQueue;
@synthesize senderCenter;
@synthesize alert;
@synthesize orderDisplayType;
@synthesize locationIUR;
@synthesize lastOrderNumber = _lastOrderNumber;
@synthesize rootView = _rootView;
@synthesize globalNavigationController = _globalNavigationController;
//@synthesize arcosConfigDataManager = _arcosConfigDataManager;
@synthesize savedOrderPresenterTranDataManager = _savedOrderPresenterTranDataManager;
@synthesize savedOrderDetailDataManager = _savedOrderDetailDataManager;
@synthesize HUD = _HUD;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.globalNavigationController = nil;
    }
    return self;
}

- (void)dealloc
{
    self.customerLabel = nil;
    self.valueLabel = nil;
    self.headerView = nil;
//    [headerView release];
    self.tableData = nil;
    self.displayList = nil;
    self.currentSelectDeleteIndexPath = nil;
    self.currentSelectOrderHeader = nil;
    self.orderQueue = nil;
    self.senderCenter.delegate = nil;
    self.senderCenter = nil;
    self.alert = nil;
    self.locationIUR = nil;
    connectivityCheck.delegate = nil;
    [connectivityCheck release];
    if (self.lastOrderNumber != nil) { self.lastOrderNumber = nil; }
    if (self.rootView != nil) { self.rootView = nil; }
    self.globalNavigationController = nil;
//    self.arcosConfigDataManager = nil;
    self.savedOrderPresenterTranDataManager = nil;
    self.savedOrderDetailDataManager = nil;
    self.HUD = nil;
    
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //debug varialble
    needVPNCheck=NO;
    
    //testing data
    self.isCellEditable=YES;
    //edit button
    if (self.isCellEditable) {
        NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:2];  
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(EditTable:)];
//        [self.navigationItem setRightBarButtonItem:addButton];
        
        UIBarButtonItem* animatedButton = [[UIBarButtonItem alloc] initWithTitle:@"Animated" style:UIBarButtonItemStylePlain target:self action:@selector(animatedPressed:)];    
//        [self.navigationItem setLeftBarButtonItem:animatedButton];         
        
        [rightButtonList addObject:addButton];
//        [rightButtonList addObject:animatedButton];
        [self.navigationItem setRightBarButtonItems:rightButtonList];
        [addButton release];
        [animatedButton release];
    }
    
    self.tableView.allowsSelection=NO;
    //minddle buttons
    NSArray *statusItems = [NSArray arrayWithObjects:@"Total",@"Send All",nil];
    UISegmentedControl* segmentBut = [[UISegmentedControl alloc] initWithItems:statusItems];
    
    [segmentBut addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentBut.frame = CGRectMake(0, 0, 300, 30);
//    segmentBut.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentBut.momentary = YES;
    
    self.navigationItem.titleView = segmentBut;
    
    //popovers
//    SelectionPopoverViewController* spvc=[[SelectionPopoverViewController alloc]initWithNibName:@"SelectionPopoverViewController" bundle:nil];
//    spvc.delegate=self;
//    
//    selectionPopover=[[UIPopoverController alloc]initWithContentViewController:spvc];
//    if (self.isCellEditable) {
//        selectionPopover.popoverContentSize=CGSizeMake(130, 240);
//    }else{
//        selectionPopover.popoverContentSize=CGSizeMake(130, 150);
//    }
    
    //sender center
    self.senderCenter=[OrderSenderCenter center];
    self.senderCenter.delegate=self;
    self.savedOrderDetailDataManager = [[[SavedOrderDetailDataManager alloc] init] autorelease];
    //add connectivity observer
    // Observe the ConnectivityChangeNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    //[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(connectivityChanged:) name: kConnectivityChangeNotification object: nil];
    
    //init a connectivity check
    connectivityCheck=[[ConnectivityCheck alloc]init];
    connectivityCheck.delegate=self;
    self.rootView = [ArcosUtils getRootView];
//    self.arcosConfigDataManager = [[[ArcosConfigDataManager alloc] init] autorelease];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        self.savedOrderPresenterTranDataManager = [[[SavedOrderPresenterTranDataManager alloc] init] autorelease];
    }
}
- (void)reloadTableData{
    //load data
//    NSNumber* locationIUR=[GlobalSharedClass shared].currentSelectedLocationIUR;
//    self.tableData =[[ArcosCoreData sharedArcosCoreData]allOrdersWithSortKey:@"OrderDate" withLocationIUR:locationIUR];
    [self.tableView reloadData];
}
- (void)reloadTableDataWithData:(NSMutableArray*)theData{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.tableData=theData;
    self.displayList=self.tableData;
    [self.tableView reloadData];
    
    //[self.orderQueue removeAllObjects];
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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self refreshTheList];
    
    //enable the date group selection
    /* come back later on
    UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
    UITableViewController* dateViewController=[navigation.viewControllers objectAtIndex:0];
    if ([dateViewController respondsToSelector:@selector(tableView)]) {
        dateViewController.tableView.allowsSelection=YES;
    }
    */
}
-(void)refreshTheList{
    switch (orderDisplayType) {
        case 0:
            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:nil withEndDate:nil];
            break;
        case 1:
            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]today] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
            break;
        case 2:
            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisWeek] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
            break;
        case 3:
            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisMonth] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
            break;
        case 4:
            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisYear] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
            break;
//        case 5:
//            self.tableData=[[ArcosCoreData sharedArcosCoreData]ordersWithCustomerIUR:self.locationIUR];
//            break;
//        case 6:
//            self.tableData=[[ArcosCoreData sharedArcosCoreData]callsWithCustomerIUR:self.locationIUR];
//            break;
//        case 7: {
//            self.tableData = [[ArcosCoreData sharedArcosCoreData] lastOrderWithOrderNumber:self.lastOrderNumber];
//        }
            break;
        case 8: {
            self.tableData = [[ArcosCoreData sharedArcosCoreData]ordersWithDataRangeStart:[[GlobalSharedClass shared]thisMat] withEndDate:[ArcosUtils endOfDay:[NSDate date]]];
        }
            break;
        case 9: {
            self.tableData = [[ArcosCoreData sharedArcosCoreData] retrievePendingOnlyOrders];
        }
            break;
        default:
            break;
    }
    
    
    self.displayList=self.tableData;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.displayList count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        self.headerView.goodsLabel.hidden = NO;
        self.headerView.vatLabel.hidden = NO;
        self.headerView.totalLabel.text = @"Total";
    } else {
        self.headerView.goodsLabel.hidden = YES;
        self.headerView.vatLabel.hidden = YES;
        self.headerView.totalLabel.text = @"Value";
    }
    return self.headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSNumber* isCellCealed=[(NSMutableDictionary*)cell.data objectForKey:@"IsCealed"];

    NSNumber* orderNumber=[[self.displayList objectAtIndex:indexPath.row]objectForKey:@"OrderNumber"];
//    NSMutableArray* orderLines=[[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"OrderLine" locationIUR:[[self.displayList objectAtIndex:indexPath.row]objectForKey:@"LocationIUR"]];
    NSMutableArray* orderLines = nil;
    NSNumber* formIUR = [[self.displayList objectAtIndex:indexPath.row] objectForKey:@"FormIUR"];
//    NSLog(@"row %d is taped!",indexPath.row);
    
    
    //check if any order lines
    if ([orderLines count]>0) {//some order lines 
        OrderProductViewController<SubstitutableDetailViewController>* orderProducts=[[[OrderProductViewController alloc]initWithNibName:@"OrderProductViewController" bundle:nil]autorelease];
        orderProducts.delegate=self;
        orderProducts.isCellEditable=![isCellCealed boolValue];
        orderProducts.formIUR = formIUR;
        [orderProducts reloadTableDataWithData:orderLines];
        
        [self.navigationController pushViewController:orderProducts animated:YES];
    }else{//do detailing 
        //OrderHeader* OH=[[ArcosCoreData sharedArcosCoreData]orderHeaderWithOrderNumber:orderNumber];
        //if (OH.calltrans !=nil && [OH.calltrans count]>0) {
            DetailingTableViewController* dtvc=[[[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil]autorelease];
            
            dtvc.title=cell.name.text;
            dtvc.orderNumber=orderNumber;
            dtvc.isEditable=![isCellCealed boolValue];
            [self.navigationController pushViewController:dtvc animated:YES];
            
            //disable the date group selection
            UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
            UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
            UITableViewController* dateViewController=[navigation.viewControllers objectAtIndex:0];
            if ([dateViewController respondsToSelector:@selector(tableView)]) {
                dateViewController.tableView.allowsSelection=NO;
            }
            
        //}
    }
    
    self.currentSelectOrderHeader=(NSMutableDictionary*) cell.data;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"SavedOrderTableCell";
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
        CellIdentifier = @"SavedOrderGoodsVatTableCell";
    }
    
    SavedOrderTableCell *cell=(SavedOrderTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[SavedOrderTableCell class]] && [[(SavedOrderTableCell *)nibItem reuseIdentifier] isEqualToString:CellIdentifier]) {
                cell= (SavedOrderTableCell *) nibItem;
                cell.delegate=self;
                //add taps
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                /*
                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
                doubleTap.numberOfTapsRequired = 2;
                [cell.contentView  addGestureRecognizer:doubleTap];
                [singleTap requireGestureRecognizerToFail:doubleTap];
                */
                singleTap.delegate=self;
//                doubleTap.delegate=self;
                [singleTap release];
//                [doubleTap release];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
        }
	}

    // Configure the cell...
    //fill data for cell
    NSMutableDictionary* cellData=[NSMutableDictionary dictionaryWithDictionary:[self.displayList objectAtIndex:indexPath.row]];
    //name and address load them when we need
    NSNumber* orderHeaderIUR=[cellData objectForKey:@"OrderHeaderIUR"];
    
    NSMutableArray* aLocaiton=[[ArcosCoreData sharedArcosCoreData] locationWithIUR:[cellData objectForKey:@"LocationIUR"]];
    NSMutableArray* contactList = nil;
    BOOL isCealed=YES;
    //if order is sent then seal the order
    if ([cellData objectForKey:@"IsCealed"]==nil ) {        
        if ([orderHeaderIUR intValue]>0||[orderHeaderIUR intValue]<0) {
            [cellData setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
            isCealed=YES;
        }else{
            [cellData setObject:[NSNumber numberWithBool:NO] forKey:@"IsCealed"];
            isCealed=NO;
        }
    }else{
        isCealed=[[cellData objectForKey:@"IsCealed"]boolValue];
    }
    

    //end name and address
    
    //BOOL isCealed=[[cellData objectForKey:@"IsCealed"]boolValue];
    [cell needEditable:!isCealed];
    NSNumber* orderNumber=[cellData objectForKey:@"OrderNumber"];
    //cell.number.text=[orderNumber stringValue];
    
    [cell inSending:[self.senderCenter isOrderInTheQueue:orderNumber]];
    //check is the order sent status equals to default order sent status then hid the send button
//    NSNumber* OSiur=[cellData objectForKey:@"OSiur"];
//    NSNumber* OSiurDefault=[SettingManager defaultOrderSentStatus];
//    if ([OSiur isEqualToNumber:OSiurDefault] ) {
//        cell.sendButton.hidden=YES;
//    }
    
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.date.text=[formatter stringFromDate:[cellData objectForKey:@"OrderDate"]];
    cell.deliveryDate.text=[formatter stringFromDate:[cellData objectForKey:@"DeliveryDate"]];
    [formatter release];
    cell.point.text=[[cellData objectForKey:@"Points"]stringValue];
    
    //check if the order has only memon and call
    NSNumber* numberOfLines=[cellData objectForKey:@"NumberOflines"];

    if ([numberOfLines intValue]>0) {
        if (![[ArcosConfigDataManager sharedArcosConfigDataManager] showTotalVATInvoiceFlag]) {
            cell.value.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"TotalGoods"]floatValue]];
        } else {
            cell.goodsLabel.text = [NSString stringWithFormat:@"%1.2f", [[cellData objectForKey:@"TotalGoods"] floatValue]];
            cell.vatLabel.text = [NSString stringWithFormat:@"%1.2f", [[cellData objectForKey:@"TotalVat"] floatValue]];
            cell.value.text=[NSString stringWithFormat:@"%1.2f",([[cellData objectForKey:@"TotalGoods"] floatValue] + [[cellData objectForKey:@"TotalVat"] floatValue])];
        }
        //[cell.name setTextColor:[UIColor blueColor]];
        //assign icon
        UIImage* auxWholesalerImage = nil;
        NSNumber* auxWholesaleIUR = [cellData objectForKey:@"WholesaleIUR"];
        NSMutableArray* wholeSalerDictList = [[ArcosCoreData sharedArcosCoreData] locationWithIUR:auxWholesaleIUR];
        if (wholeSalerDictList != nil) {
            NSDictionary* auxWholesalerDict = [wholeSalerDictList objectAtIndex:0];
            NSNumber* auxWholesalerImageIUR = [auxWholesalerDict objectForKey:@"ImageIUR"];
            if ([auxWholesalerImageIUR intValue] > 0) {
                auxWholesalerImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:auxWholesalerImageIUR];
            }
        }
        if (isCealed) {
            if (auxWholesalerImage == nil) {
                cell.icon.image=[UIImage imageNamed:@"Order_sent"];
                cell.icon.alpha = 1.0;
            } else {
                cell.icon.image = auxWholesalerImage;
                cell.icon.alpha = [GlobalSharedClass shared].imageCellAlpha;
            }
        }else {
            if (auxWholesalerImage == nil) {
                cell.icon.image=[UIImage imageNamed:@"Order"];
            } else {
                cell.icon.image = auxWholesalerImage;
            }
            cell.icon.alpha = 1.0;
        }
    }else{//call with no order lines
        contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:[cellData objectForKey:@"ContactIUR"]];
        cell.value.text=@"";
        //[cell.name setTextColor:[UIColor purpleColor]];
        //assign icon
        UIImage* auxCTiurImage = nil;
        NSDictionary* cTiurDescrDetailDict = [[ArcosCoreData sharedArcosCoreData] descriptionWithIUR:[cellData objectForKey:@"CTiur"]];
        NSNumber* cTiurImageIUR = [cTiurDescrDetailDict objectForKey:@"ImageIUR"];
        if ([cTiurImageIUR intValue] > 0) {
            auxCTiurImage = [[ArcosCoreData sharedArcosCoreData] thumbWithIUR:cTiurImageIUR];
        }
        if (isCealed) {
            if (auxCTiurImage == nil) {
                cell.icon.image = [UIImage imageNamed:@"Memo_sent"];
                cell.icon.alpha = 1.0;
            } else {
                cell.icon.image = auxCTiurImage;
                cell.icon.alpha = [GlobalSharedClass shared].imageCellAlpha;
            }
        }else {
            if (auxCTiurImage == nil) {
                cell.icon.image = [UIImage imageNamed:@"Memo"];
            } else {
                cell.icon.image = auxCTiurImage;
            }
            cell.icon.alpha = 1.0;
        }
    }
    
    //cell.name.text=[cellData objectForKey:@"Name"];
    //cell.address.text=[cellData objectForKey:@"Address"];
    //contact location are different
    if ([numberOfLines intValue]>0) {//Order
        if (aLocaiton!=nil) {
            
            cell.name.text=[[aLocaiton objectAtIndex:0] objectForKey:@"Name"];
            cell.address.text=[ArcosUtils trim:[[ArcosCoreData sharedArcosCoreData] fullAddressWith:[aLocaiton objectAtIndex:0]]];
            
        }else{
            cell.name.text=@"Location UnAssigned";
            cell.address.text=@"";
            
        }
    } else {//Call
        BOOL isContactFound = NO;
        if (contactList != nil && [contactList count] > 0) {
            NSMutableDictionary* contactDict = [contactList objectAtIndex:0];
            if ([[contactDict objectForKey:@"IUR"] intValue] != 0) {
                NSString* surname = [ArcosUtils convertNilToEmpty:[contactDict  objectForKey:@"Surname"]];
                NSString* forename = [ArcosUtils convertNilToEmpty:[contactDict objectForKey:@"Forename"]];
                NSString* contactName = [NSString stringWithFormat:@"%@ %@",[NSString stringWithString:forename],[NSString stringWithString:surname]];
                cell.name.text = contactName;
                isContactFound = YES;
            } else {
//                cell.name.text = [GlobalSharedClass shared].unassignedText;
                cell.name.text = @"";
            }
        } else {
//            cell.name.text = [GlobalSharedClass shared].unassignedText;
            cell.name.text = @"";
        }
        if (aLocaiton!=nil) {
            if (isContactFound) {                
                cell.address.text= [NSString stringWithFormat:@"%@ %@",[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[[aLocaiton objectAtIndex:0] objectForKey:@"Name"]]], [ArcosUtils trim:[[ArcosCoreData sharedArcosCoreData] fullAddressWith:[aLocaiton objectAtIndex:0]]]];
            } else {
                cell.name.text = [NSString stringWithFormat:@"%@",[ArcosUtils trim:[ArcosUtils convertNilToEmpty:[[aLocaiton objectAtIndex:0] objectForKey:@"Name"]]]];
                cell.address.text= [NSString stringWithFormat:@"%@", [ArcosUtils trim:[[ArcosCoreData sharedArcosCoreData] fullAddressWith:[aLocaiton objectAtIndex:0]]]];
            }                            
        }else{
            cell.address.text = @"Location UnAssigned";
        }
    }    
    
    [cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    cell.data=cellData;

    //NSLog(@"EnteredDate for cell ---%@",[cellData objectForKey:@"EnteredDate"]);
    [self.displayList replaceObjectAtIndex:indexPath.row withObject:cellData];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

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

#pragma mark - Table view data source




// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //    // No editing style if not editing or the index path is nil.
    //    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    //    // Determine the editing style based on whether the cell is a placeholder for adding content or already 
    //    // existing content. Existing content can be deleted.    
    //    if (self.editing && indexPath.row == ([arry count])) 
    //	{
    //		return UITableViewCellEditingStyleInsert;
    //	} else 
    //	{
    //		return UITableViewCellEditingStyleDelete;
    //	}
    //    return UITableViewCellEditingStyleNone;
    NSMutableDictionary* cellData=[self.displayList objectAtIndex:indexPath.row];
    BOOL isCealled=[[cellData objectForKey:@"IsCealed"]boolValue];
    
    if (isCealled) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}
// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        NSLog(@"deleted committed");
        self.currentSelectDeleteIndexPath=indexPath;
        //get the cell
        SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:self.currentSelectDeleteIndexPath];
        [self deleteOrderHeader:(NSMutableDictionary*) cell.data];
        
    }
    //        [arry removeObjectAtIndex:indexPath.row];
    //		[Table reloadData];
    //    }
    //else if (editingStyle == UITableViewCellEditingStyleInsert)
    //	{
    //        [arry insertObject:@"Tutorial" atIndex:[arry count]];
    //		[Table reloadData];
    //    }
}
//taps 

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    [selectionPopover dismissPopoverAnimated:YES];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];    
    if (self.HUD != nil) {
        self.HUD.frame = self.navigationController.view.frame;
    }
}

//ibaction
- (IBAction) EditTable:(id)sender
{
	if(self.editing)
	{
		[super setEditing:NO animated:NO]; 
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES]; 
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
		[self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}
}
- (IBAction)DeleteButtonAction:(id)sender
{
	NSLog(@"delete button press");
}

-(void)showOnlySelectionItems{
    NSLog(@"show only selection pressed!");
    NSMutableArray* newList=[[[NSMutableArray alloc]init]autorelease];
    
    for(NSMutableDictionary* aDict in self.displayList ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [newList addObject:aDict];
        }
    }
    
    self.displayList=newList;
    [self.tableView reloadData];
    
//    [selectionPopover dismissPopoverAnimated:YES];
}
-(void)clearAllSelections{
    for(NSMutableDictionary* aDict in self.displayList ){
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [aDict setObject:[NSNumber numberWithBool:NO] forKey: @"IsSelected"];
        }
    }
    
    self.displayList=self.tableData;
    [self.tableView reloadData];
    
//    [selectionPopover dismissPopoverAnimated:YES];
    
}

-(void)showOrderDetailTableView:(NSMutableDictionary*)theData{
    OrderDetailTableViewController* odtvc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
    odtvc.orderProductViewControllerDelegate = self;
    [odtvc loadSavedOrderDetailCellData:theData];
    if (self.rcsStackedController == nil) {
        [self.navigationController pushViewController:odtvc animated:YES];
        [odtvc release];
    } else {
        UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:odtvc];
        [self.rcsStackedController pushNavigationController:tmpNavigationController fromNavigationController:(UINavigationController*)self.parentViewController animated:YES];
        [odtvc release];
        [tmpNavigationController release];
    }
    
    /*come back later on
    OrderDetailTableViewController* odtvc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
    [odtvc loadSavedOrderDetailCellData:theData];
    [self.navigationController pushViewController:odtvc animated:YES];
    [odtvc release];
    */
}

-(void)showSelectedDetail:(NSMutableDictionary*)theData{
    NSLog(@"show total selection pressed!with data %@",theData);
    
    OrderDetailModelViewController* odmvc=[[OrderDetailModelViewController alloc]initWithNibName:@"OrderDetailModelViewController" bundle:nil];
    odmvc.delegate=self;
    odmvc.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.9f];
    [odmvc loadOrderHeader:theData];
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:odmvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [odmvc release];
    
}
-(void)sendAllNewOrders{
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        [self.savedOrderPresenterTranDataManager processPresenterTransaction];
    }
    //send the new orders
    for (int i=0; i<[self.displayList count]; i++) {
        //NSMutableDictionary* anOrderHeader= [NSMutableDictionary dictionaryWithDictionary:[self.displayList objectAtIndex:i]];
        NSMutableDictionary* anOrderHeader= [self.displayList objectAtIndex:i];
        NSNumber* orderHeaderIUR=[anOrderHeader objectForKey:@"OrderHeaderIUR"];

        NSNumber* orderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        
        NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
        SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
        
        if ([orderHeaderIUR intValue]==0) {
            //[anOrderHeader setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
//            NSLog(@"order header will be sent %@",anOrderHeader);
            [senderCenter addSenderWithOrderNumber:orderNumber];
            [cell animate];
            [cell needEditable:NO];

        }
    }
    
    [self checkConnection];

}

//segment button action
-(void)segmentAction:(id)sender{
    UISegmentedControl* segment=(UISegmentedControl*)sender;
    
    
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self showTotalOfSelections];
            break;
        case 1:
            
//            [selectionPopover presentPopoverFromRect:segment.bounds inView:segment permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [self sendAllNewOrders];
            break;
            
        default:
            break;
    }
    
}
#pragma mark taps
//taps 
-(void)handleDoubleTapGesture:(id)sender{
    NSLog(@"double tap");
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    //SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
//        aCell=(SelectedableTableCell*)reconizer.view.superview;
//        [self showSelectedDetail:(NSMutableDictionary*) aCell.data];
    }
    
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer*)sender{
//    NSLog(@"single tap");
/*
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        //select the cell
//        aCell=(SelectedableTableCell*)reconizer.view.superview;
//        [aCell flipSelectStatus];
//        NSLog(@"handleSingleTapGesture:%@",NSStringFromClass([reconizer.view.superview class]));
        aCell=(SelectedableTableCell*)reconizer.view.superview;        
        self.currentSelectOrderHeader = (NSMutableDictionary*)aCell.data;
        [self showOrderDetailTableView:(NSMutableDictionary*)aCell.data];
//        [self showSelectedDetail:(NSMutableDictionary*) aCell.data];
//        NSLog(@"showSelectedDetail: %@",aCell.data);
    }
*/
    if (sender.state == UIGestureRecognizerStateEnded) {
        SelectedableTableCell* aCell;
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:sender tableview:self.tableView];
        aCell = (SelectedableTableCell*)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        self.currentSelectOrderHeader = (NSMutableDictionary*)aCell.data;
        [self showOrderDetailTableView:(NSMutableDictionary*)aCell.data];
    }
}

#pragma mark view delegate
- (void)didDismissModalView{
//    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    [self.rootView dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark PresentViewControllerDelegate
- (void)didDismissPresentView {
//    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
//    [self.rootView dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark seletion operations
//popover delegate
-(void)showTotalOfSelections{
    if (self.globalNavigationController != nil) return;
    OrderHeaderTotalGraphViewController* ohtgvc = [[OrderHeaderTotalGraphViewController alloc] initWithNibName:@"OrderHeaderTotalGraphViewController" bundle:nil];    
//    ohtgvc.delegate = self;
    ohtgvc.presentDelegate = self;
//    ohtgvc.theData = [self selectionTotal];
    ohtgvc.title = @"Order Summary";
    /*
    UINavigationController* tmpNavigationController = [[UINavigationController alloc] initWithRootViewController:ohtgvc];
    [ohtgvc release];
    [self presentViewController:tmpNavigationController animated:YES completion:nil];
    [tmpNavigationController release];
    */
    
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ohtgvc] autorelease];
//    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [self.rootView setModalPresentationStyle:UIModalPresentationFullScreen];
//    [self.rootView presentViewController:navigationController animated:YES completion:nil];
    [ohtgvc release];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
//    [navigationController release];
//    [selectionPopover dismissPopoverAnimated:YES];
    
/**    
    NSLog(@"show total selection pressed!");
    
    OrderHeaderTotalViewController* ohvc=[[OrderHeaderTotalViewController alloc]initWithNibName:@"OrderHeaderTotalViewController" bundle:nil];
    ohvc.delegate=self;
    ohvc.theData=[self selectionTotal];
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentModalViewController:ohvc animated:YES];
    //[[self parentViewController].view addSubview:ohvc.view];
    [ohvc release];
    
    [selectionPopover dismissPopoverAnimated:YES];
*/    
}

-(NSMutableDictionary*)selectionTotal{
    NSMutableDictionary* totalDict=[[[NSMutableDictionary alloc]init]autorelease];
    
    int totalOrders=0;
    float totalValue=0.0f;
    int totalPoints=0;
    float averageValue=0.0f;
    
    for(NSMutableDictionary* aDict in self.displayList ){
        //NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        //if ([isSelected boolValue]) {
            totalOrders++;
            totalValue+=[[aDict objectForKey:@"TotalGoods"]floatValue];
            totalPoints+=[[aDict objectForKey:@"Points"]intValue];
        //}
    }
    if (totalOrders>0) {
        averageValue=totalValue/totalOrders;
    }
    [totalDict setObject:[NSNumber numberWithInt:totalOrders] forKey:@"totalOrders"];
    [totalDict setObject:[NSNumber numberWithFloat:totalValue] forKey:@"totalValue"];
    [totalDict setObject:[NSNumber numberWithInt:totalPoints] forKey:@"totalPoints"];
    [totalDict setObject:[NSNumber numberWithFloat:averageValue] forKey:@"averageValue"];

    
    NSLog(@"selection total order %d  value  %f  points  %d",totalOrders,totalValue,totalPoints);
    
    //calculate the targets
    SettingManager* sm=[SettingManager setting];
    NSString* keypath=[NSString stringWithFormat:@"PersonalSetting.%@",@"Personal"];
    NSMutableDictionary* weeklyTarget=[sm getSettingForKeypath:keypath atIndex:1];
    NSMutableDictionary* monthlyTarget=[sm getSettingForKeypath:keypath atIndex:2];
    NSMutableDictionary* yearlyTarget=[sm getSettingForKeypath:keypath atIndex:3];
    
    [totalDict setObject:[weeklyTarget objectForKey:@"Value"]forKey:@"weeklyTarget"];
    [totalDict setObject:[monthlyTarget objectForKey:@"Value"] forKey:@"monthlyTarget"];
    [totalDict setObject:[yearlyTarget objectForKey:@"Value" ]forKey:@"yearlyTarget"];
    NSNumber* dailyTarget=[NSNumber numberWithFloat: [[weeklyTarget objectForKey:@"Value"]floatValue]/5 ];
    [totalDict setObject:dailyTarget forKey:@"dailyTarget"];
    
    //target presentage
    NSMutableDictionary* orderTotalValues=[[ArcosCoreData sharedArcosCoreData]orderTotalValues];
    float dailyPresentage=[[orderTotalValues objectForKey:@"todayTotal"]floatValue]/[dailyTarget floatValue]*100;
    float weekPresentage=[[orderTotalValues objectForKey:@"weekTotal"]floatValue]/[[weeklyTarget objectForKey:@"Value"]floatValue]*100;
    float monthPresentage=[[orderTotalValues objectForKey:@"monthTotal"]floatValue]/[[monthlyTarget objectForKey:@"Value"]floatValue]*100;
    float yearPresentage=[[orderTotalValues objectForKey:@"yearTotal"]floatValue]/[[yearlyTarget objectForKey:@"Value" ]floatValue]*100;
    
    [totalDict setObject:[NSNumber numberWithFloat:dailyPresentage]forKey:@"dailyPresentage"];
    [totalDict setObject:[NSNumber numberWithFloat:weekPresentage]forKey:@"weekPresentage"];
    [totalDict setObject:[NSNumber numberWithFloat:monthPresentage]forKey:@"monthPresentage"];
    [totalDict setObject:[NSNumber numberWithFloat:yearPresentage]forKey:@"yearPresentage"];
    
    //order total type
    [totalDict setObject:[NSNumber numberWithInteger:self.orderDisplayType]forKey:@"orderDisplyType"];
    
    [totalDict setObject:orderTotalValues forKey:@"orderTotalValues"];

    return totalDict;
    
}

#pragma mark gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}
#pragma mark delete header
-(void)deleteOrderHeader:(NSMutableDictionary*)data{
    self.currentSelectOrderHeader=data;

    //get the location name
    NSMutableArray* aLocaiton=[[ArcosCoreData sharedArcosCoreData] locationWithIUR:[data objectForKey:@"LocationIUR"]];
    NSString* locationName=@"";
    if (aLocaiton!=nil) {
        locationName=[[aLocaiton objectAtIndex:0] objectForKey:@"Name"];
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete order for %@",locationName]
                                                             delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Cancel",nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
    [actionSheet release];
}
-(void)updateOrderHeaderWithOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber *)newOrderNumber{
    for (int i=0; i<[self.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[NSMutableDictionary dictionaryWithDictionary: [self.displayList objectAtIndex:i]];
        NSNumber* anOrderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        
        if ([anOrderNumber isEqualToNumber:orderNumber]) {
            [anOrderHeader setObject:newOrderNumber forKey:@"DocketIUR"];
            [anOrderHeader setObject: [newOrderNumber stringValue]  forKey:@"orderNumberText"];
            [anOrderHeader setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
            [anOrderHeader setObject:[NSNumber numberWithInt:1] forKey:@"OrderHeaderIUR"];
//            NSLog(@"order header to update is %@",anOrderHeader);
            [self.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
            return;
        }
    }
}
-(void)updateOrderHeaderToFailWithOrderNumber:(NSNumber*)orderNumber{
    for (int i=0; i<[self.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[NSMutableDictionary dictionaryWithDictionary: [self.displayList objectAtIndex:i]];
        NSNumber* anOrderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        
        if ([anOrderNumber isEqualToNumber:orderNumber]) {
            NSNumber* OSiurDefault=[SettingManager defaultOrderSentStatus];
            [anOrderHeader setObject:OSiurDefault forKey:@"OSiur"];
            [anOrderHeader setObject:[NSNumber numberWithInt:-1] forKey:@"OrderHeaderIUR"];
            //[anOrderHeader setObject:[NSNumber numberWithBool:YES] forKey:@"IsCealed"];
            [self.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
            
            //reset the order header in core data
            [[ArcosCoreData sharedArcosCoreData] changeOrderHeaderIurWithOrderNumber:orderNumber WithValue:[NSNumber numberWithInt:-1]];
            return;
        }
    }
}
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
    
    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0://ok button remove current order line 
            [self deleteCurrentOrderHeader];
            break;   
        default:
            break;
    }
}
-(void)deleteCurrentOrderHeader{

    //delete
    //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentSelectDeleteIndexPath] withRowAnimation:YES];
    [self.displayList removeObject:self.currentSelectOrderHeader];
    [self.tableData removeObject:self.currentSelectOrderHeader];
    //delete from coredata
    [[ArcosCoreData sharedArcosCoreData]deleteOrderHeader:self.currentSelectOrderHeader];
    [self.tableView reloadData];
}
-(void)needCealTheCellWithOrderNumber:(NSNumber*)orderNumber need:(BOOL)need{
    for (int i=0; i<[self.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[self.displayList objectAtIndex:i];
        NSNumber* anOrderNumber=[anOrderHeader objectForKey:@"OrderNumber"];
        NSNumber* isCellCealed=[anOrderHeader objectForKey:@"IsCealed"];
        
        NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
        SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
        
        if ([anOrderNumber isEqualToNumber:orderNumber]) {
            //[self needCealTheCellWithOrderNumber:orderNumber need:YES];
            [cell needEditable:![isCellCealed boolValue]];
            return;
        }
    }
}
-(void)stopCellAnimationWithOrderNumber:(NSNumber*)orderNumber withStatus:(BOOL)status{
    for (int i=0; i<[self.displayList count]; i++) {        
        NSMutableDictionary* anOrderHeader=[NSMutableDictionary dictionaryWithDictionary:[self.displayList objectAtIndex:i]];
        
        if ([[anOrderHeader objectForKey:@"OrderNumber"]intValue]==[orderNumber intValue]) {
            NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
            [anOrderHeader setObject:[NSNumber numberWithBool:NO] forKey:@"IsCealed"];
            [cell stopAnimateWithStatus:status];
            [self.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
            break;
        }
    } 
}
-(void)stopAllCellAnimation{
    for (int i=0; i<[self.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader= [NSMutableDictionary dictionaryWithDictionary:[self.displayList objectAtIndex:i]];
        if ([[anOrderHeader objectForKey:@"OrderHeaderIUR"]intValue]==0) {
            NSIndexPath* indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.tableView cellForRowAtIndexPath:indexpath];
            [anOrderHeader setObject:[NSNumber numberWithBool:NO] forKey:@"IsCealed"];
            //enable cell interaction
            cell.userInteractionEnabled=YES;
            cell.sendButton.enabled=YES;
            [self.displayList replaceObjectAtIndex:i withObject:anOrderHeader];
        }
    }
    [self.tableView reloadData];
}
#pragma mark OrderProductViewController delegate
-(void)deleteOrderHeaderWithOrderNnumber:(NSNumber *)orderNumber{
    if ([[self.currentSelectOrderHeader objectForKey:@"OrderNumber"]intValue]==[orderNumber intValue]) {
        [self deleteCurrentOrderHeader];
    }else{
        NSMutableDictionary* headerNeedDelete = nil;
        for (NSMutableDictionary* orderHeader in self.tableData) {
            NSNumber* temporderNumber=[orderHeader objectForKey:@"OrderNumber"];
            if ([temporderNumber intValue]==[orderNumber intValue]) {
                headerNeedDelete=orderHeader;
                break;
            }
        }
        
        if (headerNeedDelete!=nil) {
            [self.displayList removeObject:headerNeedDelete];
            [self.tableData removeObject:headerNeedDelete];
            [[ArcosCoreData sharedArcosCoreData]deleteOrderHeader:headerNeedDelete];
            [self.tableView reloadData];
        }
    }
}
-(void)totalGoodsUpdateForOrderNumber:(NSNumber *)orderNumber withValue:(NSNumber *)totalGoods totalVat:(NSNumber*)aTotalVat {
    for (int i=0; i<[self.displayList count]; i++) {
        NSMutableDictionary* anOrderHeader=[self.displayList objectAtIndex:i];
        if ([[anOrderHeader objectForKey:@"OrderNumber"]intValue]==[orderNumber intValue]) {
            [anOrderHeader setObject:[NSDecimalNumber decimalNumberWithString:[totalGoods stringValue]] forKey:@"TotalGoods"];
            [anOrderHeader setObject:[NSDecimalNumber decimalNumberWithString:[aTotalVat stringValue]] forKey:@"TotalVat"];
            break;
        }
    }
    [self.tableView reloadData];
}

#pragma mark saved order  table cell delegate
-(void)sendingStatus:(BOOL)isSuccess withReason:(NSString*)reason forOrderNumber:(NSNumber*)orderNumber withNewOrderNumber:(NSNumber *)newOrderNumber{
    self.savedOrderDetailDataManager.sendingSuccessFlag = isSuccess;
    if (orderNumber==nil) {
        return;
    }
    if (self.savedOrderDetailDataManager.sendingSuccessFlag && [senderCenter.ordersQueue count] == 0) {
        
    } else {
        [self stopCellAnimationWithOrderNumber:orderNumber withStatus:isSuccess];
    }

    if (!isSuccess) {
        // open an alert
        /*
        if ([self.alert isVisible]){
            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
        }
        
            self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                               message:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] delegate:self cancelButtonTitle:@"OK"
                                     otherButtonTitles: nil]autorelease];
            [self.alert show];
         */
        [ArcosUtils showMsg:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" delegate:nil];
        
        [self needCealTheCellWithOrderNumber:orderNumber need:NO];
        
    }else{
        // open an alert
//        if ([self.alert isVisible]){
//            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
//        }
//            self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
//                                               message:@"Order successfully sent!" delegate:self cancelButtonTitle:@"OK"
//                                     otherButtonTitles: nil]autorelease];
//            [self.alert show];

        
        [self updateOrderHeaderWithOrderNumber:orderNumber withNewOrderNumber:newOrderNumber];

    }
    
}
//handle the error 1003
-(void)Error1003:(NSError *)error forOrderNumber:(NSNumber *)orderNumber{
    if (orderNumber==nil) {
        return;
    }
    [self stopCellAnimationWithOrderNumber:orderNumber withStatus:NO];
    
    //order header send but no respond
    //[self updateOrderHeaderToFailWithOrderNumber:orderNumber];
}
-(void)ServerFaultWithOrderNumber:(NSNumber *)orderNumber{
    // open an alert
    /*
    if ([self.alert isVisible]){
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    */
    NSString* reason=@"Server Fault";
    /*
    self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                             message:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] delegate:self cancelButtonTitle:@"OK"
                                   otherButtonTitles: nil]autorelease];
    [self.alert show];
    */
    [ArcosUtils showMsg:[NSString stringWithFormat: @"Something is wrong with order sending! (%@) You might try it again later!",reason] title:@"Warning" delegate:nil];
    //stop all animations
    [self stopAllCellAnimation];
}
-(void)timeOutForOrderNumber:(NSNumber *)orderNumber{
    NSLog(@"time out for order number %@",orderNumber);
    [self stopCellAnimationWithOrderNumber:orderNumber withStatus:NO];
    /*
    if ([self.alert isVisible]){
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }
        self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                           message:@"Time out for the order sending" delegate:self cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil]autorelease];
    [self.alert show];
     */
    [ArcosUtils showMsg:@"Time out for the order sending" title:@"Warning" delegate:nil];
}

-(void)sendPressedForCell:(SavedOrderTableCell *)cell{
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        [self.savedOrderPresenterTranDataManager processPresenterTransaction];
    }
    NSMutableDictionary* aDict=(NSMutableDictionary*)cell.data;
    NSNumber* orderNumber=[aDict objectForKey:@"OrderNumber"];
    [senderCenter addSenderWithOrderNumber:orderNumber];
    [cell animate];
    
    [self checkConnection];
}

-(void)checkConnection{
    //[connectivityCheck syncStart];
    //[ArcosUtils showMsg:connectivityCheck.errorString delegate:nil];
    [connectivityCheck asyncStart];
}
//connectivity notification back
-(void)connectivityChanged: (ConnectivityCheck* )check{
	NSParameterAssert([check isKindOfClass: [ConnectivityCheck class]]);
    NSLog(@"connectivity is changed %@",check.description);
    
    if (check!=connectivityCheck) {
        return;
    }
    
    
    if (check.serviceCallAvailable) {
        [self.savedOrderDetailDataManager normaliseData];
        [senderCenter startSend];
    }else{
        /*
        if ([self.alert isVisible]){
            return;
            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
        }
        self.alert = [[[UIAlertView alloc] initWithTitle:@"Warning" 
                                                 message:check.errorString delegate:self cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil]autorelease];
        [self.alert show];
         */
        [ArcosUtils showMsg:check.errorString title:@"Warning" delegate:nil];
        //remove all orders from center
        [senderCenter abandonAll];
        //refresh the talbe
        [self stopAllCellAnimation];
        [self.tableView reloadData];

    }
}
-(void)allOrdersDone:(NSNumber*)totalOrderSent{
    /*
    if ([self.alert isVisible]){
        [self.alert dismissWithClickedButtonIndex:0 animated:NO];
    }

        self.alert = [[[UIAlertView alloc] initWithTitle:@"Message" 
                                           message:[NSString stringWithFormat:@"%d order(s) has been sent to HQ !",[totalOrderSent intValue]] delegate:self cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil]autorelease];
        [self.alert show];
     */
    if (self.HUD != nil) {
        [self.HUD hide:YES];
    }
    if (self.savedOrderDetailDataManager.sendingSuccessFlag) {
        [self stopCellAnimationWithOrderNumber:self.senderCenter.currentOrderNumber withStatus:self.savedOrderDetailDataManager.sendingSuccessFlag];
    }
    
    NSString* tmpMsg = [NSString stringWithFormat:@"%d order(s) has been sent to HQ",[totalOrderSent intValue]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] uploadPhotoAfterSendingOrderFlag]) {
        int successfulFileCount = self.senderCenter.localNewItemsUpdateCenter.itemsWebServiceProcessor.uploadProcessCenter.webServiceProcessor.photoTransferProcessMachine.successfulFileCount;
        if (successfulFileCount > 0) {
            tmpMsg = [NSString stringWithFormat:@"%@ (photos also sent)", tmpMsg];
        }
    }
    [ArcosUtils showMsg:tmpMsg title:@"Message" delegate:nil];
    [self refreshTheList];
//    [self.tableView reloadData];
    
}
- (void)orderSenderStartLocalNewItemsSending:(NSString *)anItemName {    
    if (self.HUD == nil) {
        self.HUD = [[[MBProgressHUD alloc] initWithView:self.navigationController.view] autorelease];
        self.HUD.dimBackground = YES;
        [self.navigationController.view addSubview:self.HUD];
    }
    self.HUD.labelText = [NSString stringWithFormat:@"Sending %@", anItemName];
    [self.HUD show:YES];
}
- (void)orderSenderErrorOccurredLocalNewItemsSending:(NSString *)anErrorMsg {
    [ArcosUtils showMsg:anErrorMsg title:[GlobalSharedClass shared].errorTitle delegate:nil];
}
//-(void)startSendOrder:(id)aData{
//    NSMutableDictionary* aDict=(NSMutableDictionary*)aData;
//    NSNumber* orderNumber=[aDict objectForKey:@"OrderNumber"];
//    if (orderNumber==nil) {
//        return;
//    }
//    [self needCealTheCellWithOrderNumber:orderNumber need:YES];
//}
#pragma mark alert view delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

}
- (void)animatedPressed:(id)sender {    
//    [ArcosXMLParser doXMLParse:@"testxmldoc" deserializeTo:[[ArcosGenericReturnObject alloc] autorelease]];
    CustomerAnalyzeModalViewController* camvc =[[CustomerAnalyzeModalViewController alloc]initWithNibName:@"CustomerAnalyzeModalViewController" bundle:nil];            
//    camvc.delegate=self;
    camvc.modalDelegate = self;
    camvc.title = [NSString stringWithFormat:@"Analysis for"];            
    camvc.locationIUR = [NSNumber numberWithInt:9735];
    UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController:camvc] autorelease];
    [camvc release];
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [parentView presentViewController:navigationController animated:YES completion:nil];
}
-(void)processPTranWhenAllowed {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag]) {
        [self.savedOrderPresenterTranDataManager processPresenterTransaction];
    }
}
@end
