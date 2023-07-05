//
//  CheckoutViewController.m
//  Arcos
//
//  Created by David Kilmartin on 02/08/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CheckoutViewController.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "ArcosAppDelegate_iPad.h"
#import "NewOrderViewController.h"
//#import "MainTabbarViewController.h"
#import "ArcosRootViewController.h"
#import "ArcosOrderRestoreUtils.h"
#import "ArcosValidator.h"

@interface CheckoutViewController (Private)
-(void)needHighlightCurrentLabel:(BOOL)need;
-(void)fillOrderDetailData:(id)data;
-(NSMutableDictionary*)convertToOrderProductDict:(NSMutableDictionary*)aDict;
-(NSMutableDictionary*)selectionTotal;
-(void)stampLocation;
-(void)checkOrderSaving:(BOOL)isSuccess;
-(void)showNumberPadPopoverWithData:(NSMutableDictionary*)aCellDict;
-(void)saveButtonCallBack;
- (void)operationDoneFromOrderLine:(id)data;
@end

@implementation CheckoutViewController
@synthesize  widgetFactory;
@synthesize  Name;
//@synthesize  Address;
@synthesize  OrderDate;
@synthesize  DeliveryDate;
@synthesize  Wholesaler;
@synthesize  Status;
@synthesize  Type;
@synthesize CallType;
@synthesize Contact;
@synthesize  CustomerRef;
@synthesize accountNumber = _accountNumber;
@synthesize  Memo;
@synthesize  orders;
@synthesize  widgetPopPoint;
@synthesize currentLabel = _currentLabel;
@synthesize thePopover = _thePopover;
@synthesize  orderHeader;
@synthesize checkoutList;
@synthesize headerView;
@synthesize footerView;
@synthesize sortedOrderKeys;
@synthesize orderLines;
@synthesize isCellEditable;

@synthesize totalQtyLabel;
@synthesize totalBonusLabel;
@synthesize totalValueLabel;
@synthesize totalLinesLabel;
@synthesize totalTitle = _totalTitle;
@synthesize linesTitle = _linesTitle;

@synthesize CLController;
@synthesize  Latitude;
@synthesize  Longitude;
@synthesize checkoutDelegate = _checkoutDelegate;
@synthesize matDelegate = _matDelegate;
@synthesize isRequestSourceFromImageForm;
@synthesize templateView = _templateView;
@synthesize rootView = _rootView;

@synthesize orderDateTitle = _orderDateTitle;
@synthesize deliveryDateTitle = _deliveryDateTitle;
@synthesize wholesalerTitle = _wholesalerTitle;
@synthesize statusTitle = _statusTitle;
@synthesize typeTitle = _typeTitle;
@synthesize callTypeTitle = _callTypeTitle;
@synthesize contactTitle = _contactTitle;
@synthesize customerRefTitle = _customerRefTitle;
@synthesize accountNumberTitle = _accountNumberTitle;
@synthesize memoTitle = _memoTitle;

@synthesize descriptionTitle = _descriptionTitle;
@synthesize priceTitle = _priceTitle;
@synthesize qtyTitle = _qtyTitle;
@synthesize bonusTitle = _bonusTitle;
@synthesize discountTitle = _discountTitle;
@synthesize valueTitle = _valueTitle;
@synthesize checkoutDataManager = _checkoutDataManager;
@synthesize myAVAudioPlayer = _myAVAudioPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentControlTag=0;
        

    }
    return self;
}

- (void)dealloc
{
    self.CLController = nil;
    if (self.checkoutDelegate != nil) { self.checkoutDelegate = nil; }    
    if (self.matDelegate != nil) { self.matDelegate = nil; }
    
    self.orderDateTitle = nil;
    self.deliveryDateTitle = nil;
    self.wholesalerTitle = nil;
    self.statusTitle = nil;
    self.typeTitle = nil;
    self.callTypeTitle = nil;
    self.contactTitle = nil;
    self.customerRefTitle = nil;
    self.accountNumberTitle = nil;
    self.memoTitle = nil;
    
    self.Name = nil;
    self.Longitude = nil;
    self.Latitude = nil;
    self.OrderDate = nil;
    self.DeliveryDate = nil;
    self.Wholesaler = nil;
    self.Status = nil;
    self.Type = nil;
    self.CallType = nil;
    self.Contact = nil;
    self.CustomerRef = nil;
    self.accountNumber = nil;
    self.Memo = nil;
    self.orders = nil;
    self.widgetPopPoint = nil;
    self.checkoutList = nil;
    self.currentLabel = nil;
    
    self.descriptionTitle = nil;
    self.priceTitle = nil;
    self.qtyTitle = nil;
    self.bonusTitle = nil;
    self.discountTitle = nil;
    self.valueTitle = nil;
    self.headerView = nil;
    
    self.totalValueLabel = nil;
    self.totalQtyLabel = nil;
    self.totalBonusLabel = nil;
    self.totalLinesLabel = nil;
    self.totalTitle = nil;
    self.linesTitle = nil;
    self.footerView = nil;
    
    self.templateView = nil;
    self.rootView = nil;
    self.widgetFactory = nil;
    self.thePopover = nil;
    self.orderHeader = nil;
    self.sortedOrderKeys = nil;
    self.orderLines = nil;
    self.checkoutDataManager = nil;
    self.myAVAudioPlayer = nil;

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
    self.checkoutDataManager = [[[CheckoutDataManager alloc] init] autorelease];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
    //core location controller
    self.checkoutList.allowsSelection = NO;
    self.CLController = [[[CoreLocationController alloc] init] autorelease];
    self.CLController.delegate = self;
    
    //get a factory
    self.widgetFactory=[WidgetFactory factory];
    self.widgetFactory.delegate=self; 
    
    // Do any additional setup after loading the view from its nib.
    //add taps to labels
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.OrderDate addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.DeliveryDate addGestureRecognizer:singleTap2];
    
    UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.Wholesaler addGestureRecognizer:singleTap3];
    
    UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.Status addGestureRecognizer:singleTap4];
    
    UITapGestureRecognizer *singleTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.Type addGestureRecognizer:singleTap5];
    
    UITapGestureRecognizer *singleTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.Contact addGestureRecognizer:singleTap6];
    
    UITapGestureRecognizer *singleTap7 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.CallType addGestureRecognizer:singleTap7];
    
    UITapGestureRecognizer *singleTap8 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    [self.accountNumber addGestureRecognizer:singleTap8];
    
    [singleTap1 release];
    [singleTap2 release];
    [singleTap3 release];
    [singleTap4 release];
    [singleTap5 release];
    [singleTap6 release];
    [singleTap7 release];
    [singleTap8 release];


    //add save button to the navigation bar
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Save"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(saveOrder)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backPressed:)];
//    [self.navigationItem setLeftBarButtonItem:backButton];
//    [backButton release];
    
    //textview outline
    self.Memo.layer.borderWidth=0.5f;
    self.Memo.layer.borderColor=[[UIColor greenColor]CGColor];
    [self.Memo.layer setCornerRadius:5.0f];
    [self.templateView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.templateView.layer setBorderWidth:0.5];
    [self.templateView.layer setCornerRadius:5.0f];
    
    //check if we need refresh the order date
    needRefreshData=YES;
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    [ArcosUtils configEdgesForExtendedLayout:self];
    NSString* buzzerFilePath = [[NSBundle mainBundle] pathForResource:@"buzzer" ofType:@"wav"];
    NSURL* buzzerFileURL = [NSURL fileURLWithPath:buzzerFilePath];
    NSError* error;
    self.myAVAudioPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:buzzerFileURL error:&error] autorelease];
    self.myAVAudioPlayer.delegate = self;
    self.myAVAudioPlayer.volume = 0.03;
    [self.myAVAudioPlayer prepareToPlay];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)disableUserInteractions{
    if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
        self.Memo.userInteractionEnabled=YES;
        self.navigationItem.rightBarButtonItem.enabled=YES;
        self.CustomerRef.userInteractionEnabled=YES;
    }else{
        self.Memo.userInteractionEnabled=NO;
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.CustomerRef.userInteractionEnabled=NO;
        
        // open an alert 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"Please select a customer!" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        alert.tag=88;
        [alert show];	
        [alert release];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.checkoutDataManager.currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"Details"]];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveBarCodeCheckoutNotification:)
                                                     name:@"BarCodeNotification"
                                                   object:nil];
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowTopxCustomerFlag]) {
        [self.checkoutDataManager retrieveTopxListWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR orderFormDetails:orderFormDetails];
        if (!self.checkoutDataManager.isNotFirstTimeCustomerMsg) {
            self.checkoutDataManager.isNotFirstTimeCustomerMsg = YES;
            int topxNum = [ArcosUtils convertNSUIntegerToUnsignedInt:[self.checkoutDataManager.topxList count]];
            if (topxNum > 0) {
                [ArcosUtils showMsg:[NSString stringWithFormat:@"%d top %d products have been excluded from order.", topxNum, self.checkoutDataManager.topxNumber] delegate:nil];
            }
        }
    } else {
        self.checkoutDataManager.topxList = nil;
    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowTopxCompanyFlag]) {
        [self.checkoutDataManager retrieveTopCompanyProductsWithOrderFormDetails:orderFormDetails];
        if (!self.checkoutDataManager.isNotFirstTimeCompanyMsg) {
            self.checkoutDataManager.isNotFirstTimeCompanyMsg = YES;
            if (self.checkoutDataManager.flaggedProductsNumber > 0) {
                [ArcosUtils showMsg:[NSString stringWithFormat:@"%d flagged products have been excluded from order.", self.checkoutDataManager.flaggedProductsNumber] delegate:nil];
            }
        }
    }
    //customer name and address
    [self disableUserInteractions];
    Name.text=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
//    Address.text=[[OrderSharedClass sharedOrderSharedClass]currentCustomerAddress];
    
    //reload order header
    [[OrderSharedClass sharedOrderSharedClass] refreshCurrentOrderDate];
    self.orderHeader=[OrderSharedClass sharedOrderSharedClass].currentOrderHeader;
    if ([[GlobalSharedClass shared].currentSelectedContactIUR intValue] != 0) {
        NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
        if (tmpContactDict != nil) {
            NSString* fullName = [tmpContactDict objectForKey:@"Title"];
            [self.orderHeader setObject:tmpContactDict forKey:@"contact"];
            [self.orderHeader setObject:fullName forKey:@"contactText"];
        }
    }
    NSDictionary* currentFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSDate* defaultDeliveryDate = [currentFormDetailDict objectForKey:@"DefaultDeliveryDate"];
    
    if ([defaultDeliveryDate compare:[NSDate date]] == NSOrderedDescending) {
        self.DeliveryDate.backgroundColor = [UIColor yellowColor];
        [self.orderHeader setObject:[ArcosUtils addHours:0 date:defaultDeliveryDate] forKey:@"deliveryDate"];
        [self.orderHeader setObject:[ArcosUtils stringFromDate:defaultDeliveryDate format:[GlobalSharedClass shared].dateHyphenFormat] forKey:@"deliveryDateText"];        
    } else {
        self.DeliveryDate.backgroundColor = [UIColor clearColor];
        [self.orderHeader setObject:[NSDate date] forKey:@"deliveryDate"];
        [self.orderHeader setObject:[ArcosUtils stringFromDate:[NSDate date] format:[GlobalSharedClass shared].dateHyphenFormat] forKey:@"deliveryDateText"];
    }
//    NSLog(@"currentFormDetailDict: %@", currentFormDetailDict);
    self.OrderDate.text=[self.orderHeader objectForKey:@"orderDateText"];
    self.Status.text=[self.orderHeader objectForKey:@"statusText"];
    self.Type.text=[self.orderHeader objectForKey:@"orderTypeText"];
    self.CallType.text=[self.orderHeader objectForKey:@"callTypeText"];
    self.DeliveryDate.text=[self.orderHeader objectForKey:@"deliveryDateText"];
    self.Wholesaler.text=[self.orderHeader objectForKey:@"wholesalerText"];
    self.Contact.text=[self.orderHeader objectForKey:@"contactText"];
    self.CustomerRef.text=[self.orderHeader objectForKey:@"custRef"];
    self.accountNumber.text = [self.orderHeader objectForKey:@"acctNoText"];
    self.Memo.text=[self.orderHeader objectForKey:@"memo"];

    //reload the table data
    self.orderLines=[OrderSharedClass sharedOrderSharedClass].currentOrderCart;
    self.sortedOrderKeys=[[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[self.orderLines allValues]];
    [self.orders reloadData];
    
    //set the selection total footer
    [self selectionTotal];
    
    //stamp location
    [self stampLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] allowScannerToBeUsedFlag]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BarCodeNotification" object:nil];
    }
}

-(NSMutableDictionary*)selectionTotal{
    NSMutableDictionary* totalDict=[[[NSMutableDictionary alloc]init]autorelease];
    
    int totalProducts=0;
    float totalValue=0.0f;
    int totalPoints=0;
    int totalBonus=0;
    int totalQty=0;
    
    for(NSString* aKey in self.orderLines ){
        NSMutableDictionary* aDict=[self.orderLines objectForKey:aKey];
//        NSLog(@"adict %@",aDict);
        NSNumber* isSelected=[aDict objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            totalProducts++;
            totalValue+=[[aDict objectForKey:@"LineValue"]floatValue];
            totalPoints+=[[aDict objectForKey:@"Points"]intValue];
            totalBonus+=[[aDict objectForKey:@"Bonus"]intValue];
            totalQty+=[[aDict objectForKey:@"Qty"]intValue];
        }
    }
    totalQtyLabel.text=[NSString stringWithFormat:@"%d",totalQty];
    if (totalBonus!=0) {
        totalBonusLabel.text=[NSString stringWithFormat:@"%d",totalBonus];
    }else{
        totalBonusLabel.text=@"";
    }
    totalValueLabel.text=[NSString stringWithFormat:@"%1.2f",totalValue];
    totalLinesLabel.text=[NSString stringWithFormat:@"%d",totalProducts];

    
//    NSLog(@"selection total order %d  value  %f  points  %d",totalProducts,totalValue,totalPoints);
    
    //set the order header
    [self.orderHeader setObject:[NSNumber numberWithFloat:totalValue] forKey:@"TotalGoods"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:totalQty] forKey:@"TotalQty"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:totalBonus] forKey:@"TotalBonus"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:totalProducts] forKey:@"NumberOflines"];

    return totalDict;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //repostition the pop over
    if (self.thePopover!=nil) {
        if ([self.thePopover isPopoverVisible]) {
            [self.thePopover presentPopoverFromRect:self.widgetPopPoint.bounds inView:self.widgetPopPoint permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
    }
	return YES;
}

//hightlight current label
-(void)needHighlightCurrentLabel:(BOOL)need{
    if (self.currentLabel!=nil) {
        if (need) {
            //change label style
            self.currentLabel.layer.borderWidth=1.0f;
            self.currentLabel.layer.borderColor=[[UIColor redColor]CGColor];
            self.currentLabel.layer.cornerRadius=5.0f;
        }else{
            self.currentLabel.layer.borderColor=[[UIColor clearColor]CGColor];
        }
    }
    
}
//show widget
-(void)showWidget{
    //facotry testing
//    UIPopoverController* popover;
    
    
    if (self.currentLabel!=nil) {
        switch (currentControlTag) {
            case 0://order date label
                self.thePopover=[self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate];
                break;
            case 1://delivery date label
                self.thePopover=[self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceDeliveryDate];

                break;
            case 2://wholesaler label
                self.thePopover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderWholesaler];

                break;
            case 3://status label
                self.thePopover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus];
                
                break;
            case 4://type label
                self.thePopover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderType];
                
                break;
            case 5: {
                NSMutableArray* contactList = [NSMutableArray array];
                if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
                    contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];                    
                }
                [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
                NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
                [miscDataDict setObject:@"Contact" forKey:@"Title"];
                if ([GlobalSharedClass shared].currentSelectedLocationIUR != nil) {
                    [miscDataDict setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
                } else {
                    [miscDataDict setObject:[NSNumber numberWithInt:0] forKey:@"LocationIUR"];
                }                
                [miscDataDict setObject:[[OrderSharedClass sharedOrderSharedClass]currentCustomerName] forKey:@"Name"];
                self.thePopover=[self.widgetFactory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
            }
//                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceContact];
                break;
            case 6://call type label
                self.thePopover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
                break;
            case 7: {//account no.
                NSNumber* wholesalerIUR = [[self.orderHeader objectForKey:@"wholesaler"] objectForKey:@"LocationIUR"];
                NSNumber* locationIUR = self.checkoutDataManager.getCurrentLocationIUR;
                NSMutableArray* accountNoList = [self.checkoutDataManager getAccountNoList:locationIUR fromLocationIUR:wholesalerIUR];
                NSMutableDictionary* miscDataDict = [self.checkoutDataManager getAcctNoMiscDataDict:locationIUR fromLocationIUR:wholesalerIUR];
                self.thePopover=[self.widgetFactory CreateTargetGenericCategoryWidgetWithUncheckedPickerValue:accountNoList miscDataDict:miscDataDict];
            }
                break;
            default:
                break;
        }
        //do show the popover if there is no data
//        thePopover=popover;
        if (self.thePopover!=nil) {
            self.thePopover.delegate=self;
            [self.thePopover presentPopoverFromRect:self.currentLabel.bounds inView:self.currentLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    
}
//taps action
-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    UILabel* aLabel=(UILabel*)reconizer.view;
    self.currentLabel=aLabel;
    currentControlTag=self.currentLabel.tag;
    if (self.Memo.userInteractionEnabled) {        
//        NSLog(@"label %d tap",aLabel.tag);
        if (self.currentLabel != nil && currentControlTag == 7 && [self.orderHeader objectForKey:@"wholesaler"] == nil) {
            [ArcosUtils showMsg:@"Please select a wholesaler" title:@"Warning" delegate:nil];
            return;
        }
        [self showWidget];
        if (self.thePopover!=nil) {
            [self needHighlightCurrentLabel:YES];
        }else{
            self.currentLabel.text=@"NONE";
        }

    }else{
        // open an alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"Please select a customer!" delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];	
        [alert release];
    }
    
    //check current Geo location
    [self stampLocation];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    if (section == 0) {
        return headerView;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return footerView;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.orderLines count];
    }
    if (section == 1) {
        return [self.checkoutDataManager.topxList count];
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"OrderProductTableCell";
    
    OrderProductTableCell *cell=(OrderProductTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[OrderProductTableCell class]] && [[(OrderProductTableCell *)nibItem reuseIdentifier] isEqualToString: @"OrderProductTableCell"]) {
                cell= (OrderProductTableCell *) nibItem;
                //add taps
                UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCellSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                [singleTap release];
                break;
//
//                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
//                doubleTap.numberOfTapsRequired = 2;
//                [cell.contentView  addGestureRecognizer:doubleTap];
//                [singleTap requireGestureRecognizerToFail:doubleTap];
//                
//                [doubleTap release];
                
            }    
            
        }
        
	}
    // Configure the cell...
    //fill data for cell
    [cell needEditButton:self.isCellEditable];
    NSMutableDictionary* cellData = nil;
    if (indexPath.section == 0) {
        NSString* name = [self.sortedOrderKeys objectAtIndex:indexPath.row];
        cellData = [self.orderLines objectForKey:name];
    }
    if (indexPath.section == 1) {
        cellData = [self.checkoutDataManager.topxList objectAtIndex:indexPath.row];
    }
    
    cell.cellDelegate = self;
    [cell configCellWithData:cellData];
    
    cell.description.text=[cellData objectForKey:@"Details"];
    if (indexPath.section == 1) {
        cell.description.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:64.0/255.0 alpha:1.0];
    } else {
        cell.description.textColor = [UIColor blackColor];
    }
    cell.price.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"UnitPrice"]floatValue]];
    cell.orderPadDetails.text = [cellData objectForKey:@"OrderPadDetails"];
    cell.productSize.text = [cellData objectForKey:@"ProductSize"];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
    } else {
        cell.productCode.text = @"";
    }
//    if ([cell.orderPadDetails.text isEqualToString:@""]) {
//        cell.productCode.text = @"";
//        cell.productSize.text = @"";
//    } else {
//        cell.productCode.text = [cellData objectForKey:@"ProductCode"];
//        cell.productSize.text = [cellData objectForKey:@"ProductSize"];
//    }
    
    //qty and bonus must not be zero
//    NSNumber* qty=[cellData objectForKey:@"Qty"];
//    NSNumber* bonus=[cellData objectForKey:@"Bonus"];
    NSNumber* inStock = [cellData objectForKey:@"InStock"];
    NSNumber* FOC = [cellData objectForKey:@"FOC"];
    if (![ProductFormRowConverter isSelectedWithFormRowDict:cellData]) {
        
//    }
//    if (([qty intValue]<=0 ||qty==nil)&&([bonus intValue]<=0 || bonus==nil)) {
        cell.qty.text=@"";
        cell.value.text=@"";
        cell.discount.text=@"";
        cell.bonus.text=@"";
        cell.InStock.text=@"";
        cell.FOC.text=@"";
    }else{
        cell.qty.text=[ArcosUtils convertZeroToBlank:[[cellData objectForKey:@"Qty"]stringValue]];
        cell.value.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"LineValue"]floatValue]];
        
        if ([[cellData objectForKey:@"DiscountPercent"]floatValue]!=0) {
            cell.discount.text=[NSString stringWithFormat:@"%1.2f%%",[[cellData objectForKey:@"DiscountPercent"]floatValue]];
        }else{
            cell.discount.text=@"";
        }
        if ([[cellData objectForKey:@"Bonus"]intValue]!=0) {
            cell.bonus.text=[[cellData objectForKey:@"Bonus"]stringValue];
        }else{
            cell.bonus.text=@"";
        }
        cell.InStock.text = [ArcosUtils convertZeroToBlank:[inStock stringValue]];
        cell.FOC.text = [ArcosUtils convertZeroToBlank:[FOC stringValue]];
    }
    //[cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    
    cell.theIndexPath=indexPath;
    cell.data=[self convertToOrderProductDict:cellData];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
}

#pragma Save the order
-(void)saveOrder{
    NSLog(@"save button pressed!");
    [self.view endEditing:YES];
    //save the order
    if ([[OrderSharedClass sharedOrderSharedClass]anyOrderLine]) {
        //check wholesaler
        if ([self.orderHeader objectForKey:@"wholesaler"]==nil) {
            // open an alert
            [ArcosUtils showDialogBox:@"Please select a wholesaler" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
//        if (self.accountNumber.text != nil && ![self.accountNumber.text isEqualToString:@""]) {
//            if (![ArcosValidator isInteger:self.accountNumber.text]) {
//                [ArcosUtils showMsg:@"Please enter an integer in the Account No." delegate:nil];
//                return;
//            }
//        }
        //save the order
        BOOL isSuccess=[[OrderSharedClass sharedOrderSharedClass]saveCurrentOrder:nil];
        [self checkOrderSaving:isSuccess];
        
        
    }else{
        // open an alert
        [ArcosUtils showDialogBox:@"Order has no lines,please Re-enter or use 'new call!'" title:@"Warning" delegate:self target:self tag:888 handler:^(UIAlertAction *action) {
            [self backPressed:nil];
        }];
        return;
    }

    /*call making block
else{//No order line inputed yet
        //show warning
        // open an alert 
        // open a dialog
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No product ordered! Do you still want to save it?"
//                                                                 delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                        otherButtonTitles:@"Cancel",nil];
//        
//        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//        [actionSheet showInView:self.view];
//        [actionSheet release];
        //check anything in the memo
        if ([self.orderHeader objectForKey:@"memo"]==nil||[self.orderHeader objectForKey:@"memo"]==@""||[[self.orderHeader objectForKey:@"memo"]length]<=0) {
            // open an alert 
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                            message:@"Please input the memo!" delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];	
            [alert release];
            return;
        }
        //           isSuccess=[[OrderSharedClass sharedOrderSharedClass]saveCall];
        //            [self checkOrderSaving:isSuccess];
        
        //save the order
        
        BOOL isSuccess=[[OrderSharedClass sharedOrderSharedClass]saveCurrentOrder];
        [self checkOrderSaving:isSuccess];
    }
     
     end call making block */
}
-(void)checkOrderSaving:(BOOL)isSuccess{
    if (!isSuccess) {//order is not saved with some errors
        // open an alert
        [ArcosUtils showDialogBox:@"Something is wrong with order saving!" title:@"Warning" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }else{//order saved, redirect to the customer and clear all order related session
        //redirct to the customer pad
        [GlobalSharedClass shared].lastOrderFormIUR = [NSNumber numberWithInt:[[OrderSharedClass sharedOrderSharedClass].currentFormIUR intValue]];
        [OrderSharedClass sharedOrderSharedClass].currentFormIUR=nil;
        [GlobalSharedClass shared].currentSelectedOrderLocationIUR = nil;
        [GlobalSharedClass shared].currentSelectedPresenterLocationIUR = nil;
        
//        int itemIndex = 1;
//        if ([self.rootView.customerMasterViewController.subMenuListingTableViewController.requestSourceName isEqualToString:[GlobalSharedClass shared].contactText]) {
//            itemIndex = 2;
//        }
        int itemIndex = [self.rootView.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:self.rootView.customerMasterViewController.subMenuListingTableViewController.requestSourceName];
        
        [self.rootView.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
        if ([GlobalSharedClass shared].currentSelectedCallLocationIUR == nil && [GlobalSharedClass shared].currentSelectedSurveyLocationIUR == nil) {
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
        
        
        [FileCommon removeFileAtPath:[FileCommon orderRestorePlistPath]];
        // open an alert
        [ArcosUtils showDialogBox:[NSString stringWithFormat: @"Order Saved for %@",Name.text] title:@"Message" delegate:self target:self tag:99 handler:^(UIAlertAction *action) {
            [self saveButtonCallBack];
        }];
    }
}
#pragma action sheet delegate
//action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);

    
    BOOL isSuccess=NO;
    switch (buttonIndex) {
        case 1://cancel button do nothing
            break;
        case 0://ok button remove current order use the new form
            //check anything in the memo
            if ([self.orderHeader objectForKey:@"memo"]==nil||[[self.orderHeader objectForKey:@"memo"] isEqualToString:@""]||[[self.orderHeader objectForKey:@"memo"]length]<=0) {
                // open an alert 
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                                message:@"Please input the memo!" delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];	
                [alert release];
                return;
            }
//           isSuccess=[[OrderSharedClass sharedOrderSharedClass]saveCall];
//            [self checkOrderSaving:isSuccess];
            
            //save the order
            
            isSuccess=[[OrderSharedClass sharedOrderSharedClass]saveCurrentOrder:nil];
            [self checkOrderSaving:isSuccess];
            
            break;   
        default:
            break;
    }
}

#pragma mark widget delegate
-(void)operationDone:(id)data{
//    NSLog(@"operation is done from delegate--%@",data);
    if (currentControlTag==888) {//order list tapped
        /*
        if (self.checkoutDataManager.currentIndexPath.section == 0) {
            [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
        }
        if (self.checkoutDataManager.currentIndexPath.section == 1) {
            NSNumber* isSelected = [data objectForKey:@"IsSelected"];
            if ([isSelected boolValue]) {
                [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
                [self.checkoutDataManager removeTopxElementWithDataDict:data];
            }
        }
        self.orderLines=[OrderSharedClass sharedOrderSharedClass].currentOrderCart;
        self.sortedOrderKeys=[[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[self.orderLines allValues]];
        [self.orders reloadData];
        [self selectionTotal];
        */
        [self operationDoneFromOrderLine:data];
    }else{
        [self fillOrderDetailData:data];
    }
    if ([self.thePopover isPopoverVisible]) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
}

- (void)operationDoneFromOrderLine:(id)data {
    if (self.checkoutDataManager.currentIndexPath.section == 0) {
        [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
    }
    if (self.checkoutDataManager.currentIndexPath.section == 1) {
        NSNumber* isSelected = [data objectForKey:@"IsSelected"];
        if ([isSelected boolValue]) {
            [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
            [self.checkoutDataManager removeTopxElementWithDataDict:data];
        }
    }
    self.orderLines=[OrderSharedClass sharedOrderSharedClass].currentOrderCart;
    self.sortedOrderKeys=[[OrderSharedClass sharedOrderSharedClass] getSortedCartKeys:[self.orderLines allValues]];
    [self.orders reloadData];
    [self selectionTotal];
}

-(BOOL)allowToShowAddContactButton {
    return YES;
}
-(BOOL)allowToShowAddAccountNoButton {
    return YES;
}
-(void)fillOrderDetailData:(id)data{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString* dataString=@"";
    if (self.currentLabel!=nil) {
        switch (currentControlTag) {
            case 0://order date label
                [self.orderHeader setObject:data forKey:@"orderDate"];
                dataString=[formatter stringFromDate:(NSDate*)data];
                [self.orderHeader setObject:dataString forKey:@"orderDateText"];
                break;
            case 1://delivery date label
                [self.orderHeader setObject:data forKey:@"deliveryDate"];
                dataString=[formatter stringFromDate:(NSDate*)data];
                [self.orderHeader setObject:dataString forKey:@"deliveryDateText"];
                break;
            case 2://wholesaler label
                [self.orderHeader setObject:data forKey:@"wholesaler"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"wholesalerText"];
                break;
            case 3://status label
                [self.orderHeader setObject:data forKey:@"status"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"statusText"];
                break;
            case 4://type label
                [self.orderHeader setObject:data forKey:@"type"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"orderTypeText"];
                break;
            case 5://contact label
                [self.orderHeader setObject:data forKey:@"contact"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"contactText"];
                break;
            case 6://call type label
                [self.orderHeader setObject:data forKey:@"callType"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"callTypeText"];
                break;
            case 7:{//account no. label
                [self.orderHeader setObject:data forKey:@"acctNo"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                [self.orderHeader setObject:dataString forKey:@"acctNoText"];
            }
                break;
            default:
                break;
        }
        self.currentLabel.text=dataString;
        [self needHighlightCurrentLabel:NO];
        
    }
    [formatter release];
}
#pragma mark popover delegate
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    [self needHighlightCurrentLabel:NO];
}
#pragma mark text view delegate
- (void)shiftViewUp{

    // resize the scrollview
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y==0) {
        viewFrame.origin.y-=200;
    }
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

-(void)shiftViewDown{
    // resize the scrollview
    CGRect viewFrame = self.view.frame;
    if (viewFrame.origin.y<0) {
        viewFrame.origin.y+=200;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"memo start edit!");
//    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        //[self shiftViewUp];
//    }
    
    //check the Geo location
    [self stampLocation];

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"memo end edit!");
//    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        //[self shiftViewDown];
//        
//    }
    [self.orderHeader setObject:textView.text forKey:@"memo"];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return [ArcosValidator textView:textView shouldChangeTextInRange:range replacementText:text target:self];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        [self.orderHeader setObject:textField.text forKey:@"custRef"];
    } else {
        [self.orderHeader setObject:textField.text forKey:@"acctNo"];
    }
    
    
    //check the Geo location
    [self stampLocation];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    
//    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
//    return newLength <= [GlobalSharedClass shared].customerRefMaxLength || returnKey;
    if (textField.tag == 1) {
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        return newLength <= [GlobalSharedClass shared].customerRefMaxLength;
    } else {
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
    }
}

-(NSMutableDictionary*)convertToOrderProductDict:(NSMutableDictionary*)aDict{
    [aDict setObject: [aDict objectForKey:@"Details"]  forKey:@"Description"];
    return aDict;
}

#pragma mark core location delegate
-(void)stampLocation{
//    NSLog(@"location stamping!");
    [self.CLController start];

}
//core location delegate
- (void)locationUpdate:(CLLocation *)location {
	//locLabel.text = [location description];
    Latitude.text=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    Longitude.text=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    NSLog(@"location is coming back %@",[location description]);
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"latitude"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"longitude"];
    [self.CLController stop];

}
- (void)locationError:(NSError *)error {
	//locLabel.text = [error description];
    NSLog(@"location is coming back with error");
    [self.CLController stop];
    
}
#pragma marks alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==88) {//no customer alert
        //root tab bar
        /*
        ArcosAppDelegate_iPad *delegate = [[UIApplication sharedApplication] delegate];
        UITabBarController* tabbar=(UITabBarController*) delegate.mainTabbarController;
        */
        //redirct to the customer pad
//        self.rootView.selectedIndex=1;
        int itemIndex = [self.rootView.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
        self.rootView.customerMasterViewController.currentIndexPath = [NSIndexPath indexPathForRow:itemIndex inSection:0];
        [self.rootView.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:self.rootView.customerMasterViewController.currentIndexPath];
    }
    if (alertView.tag==888) {
        [self backPressed:nil];
    }
    if (alertView.tag == 99) {
        [self saveButtonCallBack];
    }
}

-(void)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
//    [self.delegate dismissUIViewAnimation];
//    [self.checkoutDelegate didDismissModalView];
}

-(void)removeAllRootSubViewsWithTag:(NSInteger)aTag {
    UIViewController* rootView = [ArcosUtils getRootView];
    for (UIView* aSubview in [rootView.view subviews]) {
        if (aSubview.tag == aTag) {
            [aSubview removeFromSuperview];
        }
    }
}

- (void)handleCellSingleTapGesture:(id)sender {
    UITapGestureRecognizer* recognizer = (UITapGestureRecognizer*)sender;
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        currentControlTag=888;
        OrderProductTableCell* aCell;
        NSIndexPath* swipedIndexPath = [ArcosUtils indexPathWithRecognizer:recognizer tableview:self.checkoutList];
        self.checkoutDataManager.currentIndexPath = swipedIndexPath;
        aCell = (OrderProductTableCell*)[self.checkoutList cellForRowAtIndexPath:swipedIndexPath];
        //get order line
        NSMutableDictionary* aDict = nil;
        if (swipedIndexPath.section == 0) {
            NSString* key=[self.sortedOrderKeys objectAtIndex:swipedIndexPath.row];
            aDict=[self.orderLines objectForKey:key];
        }
        if (swipedIndexPath.section == 1) {
            aDict = [self.checkoutDataManager.topxList objectAtIndex:swipedIndexPath.row];
        }
//        NSLog(@"cell %@ is pressed!",[aDict objectForKey:@"Details"]);
        [self showNumberPadPopoverWithData:aDict];
    }
}

#pragma mark OrderProductTableCellDelegate
- (void)displayBigProductImageWithProductCode:(NSString*)aProductCode {
    ProductDetailImageViewController* pdivc = [[ProductDetailImageViewController alloc] initWithNibName:@"ProductDetailImageViewController" bundle:nil];
    pdivc.productCode = [ArcosUtils trim:aProductCode];
    [self.navigationController pushViewController:pdivc animated:YES];
    [pdivc release];
}

- (void)displayProductDetailWithProductIUR:(NSNumber*)aProductIUR indexPath:(NSIndexPath *)anIndexPath{
    ProductDetailViewController* pdvc = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
    pdvc.productIUR = aProductIUR;
    pdvc.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    [self.navigationController pushViewController:pdvc animated:YES];
    [pdvc release];
}

- (void)toggleShelfImageWithData:(NSMutableDictionary*)aCellData {
    NSNumber* myInStockNumber = [aCellData objectForKey:@"InStock"];
    if ([myInStockNumber intValue] == 0) {
        myInStockNumber = [NSNumber numberWithInt:1];
    } else {
        myInStockNumber = [NSNumber numberWithInt:0];
    }
    [aCellData setObject:myInStockNumber forKey:@"InStock"];
    BOOL isSelected = [ProductFormRowConverter isSelectedWithFormRowDict:aCellData];
    [aCellData setObject:[NSNumber numberWithBool:isSelected] forKey:@"IsSelected"];
    [self operationDoneFromOrderLine:aCellData];
}

- (void)receiveBarCodeCheckoutNotification:(NSNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSString* barcode = [userInfo objectForKey:@"BarCode"];
    NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[self.checkoutDataManager.currentFormDetailDict objectForKey:@"Details"]];
    NSMutableArray* productList = [self.checkoutDataManager productWithDescriptionKeyword:barcode orderFormDetails:orderFormDetails];
    if ([self.thePopover isPopoverVisible]) {
        [self.thePopover dismissPopoverAnimated:YES];
    }
    if ([productList count] > 0) {
        currentControlTag = 888;
        [self showNumberPadPopoverWithData:[productList objectAtIndex:0]];
    } else {
//        [ArcosUtils showMsg:@"No data found" delegate:nil];
        [self.myAVAudioPlayer play];
    }
}

-(void)showNumberPadPopoverWithData:(NSMutableDictionary*)aCellDict {
    CGRect aRect = CGRectMake(self.rootView.view.bounds.size.width - 10, self.rootView.view.bounds.size.height - 10, 1, 1);
    BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
    
    //popover the input pad
    self.thePopover = [self.widgetFactory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    OrderInputPadViewController* oipvc = (OrderInputPadViewController*) self.thePopover.contentViewController;
    oipvc.Data = aCellDict;
    oipvc.showSeparator = showSeparator;
    [self.thePopover presentPopoverFromRect:aRect inView:self.rootView.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    NSLog(@"successfully: %d", flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
//    NSLog(@"successfully: %@", error);
}

-(void)saveButtonCallBack {
    @try {
        NSMutableDictionary* subOrderCellDict = [self.rootView.customerMasterViewController.subMenuListingTableViewController.displayList objectAtIndex:0];
        UINavigationController* orderNavigationController = (UINavigationController*)[subOrderCellDict objectForKey:self.rootView.customerMasterViewController.subMenuListingTableViewController.myCustomControllerTitle];
        NewOrderViewController* newOrderViewController = [orderNavigationController.viewControllers objectAtIndex:0];
        newOrderViewController.isNotFirstLoaded = NO;
        [[newOrderViewController.orderBaseTableContentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        NSMutableDictionary* subPresenterCellDict = [self.rootView.customerMasterViewController.subMenuListingTableViewController.displayList objectAtIndex:1];
        UINavigationController* presenterNavigationController = (UINavigationController*)[subPresenterCellDict objectForKey:self.rootView.customerMasterViewController.subMenuListingTableViewController.myCustomControllerTitle];
        int checkoutRequestIndex = [ArcosUtils convertNSUIntegerToUnsignedInt:self.rootView.customerMasterViewController.subMenuListingTableViewController.currentIndexPath.row];
        int presenterCount = [ArcosUtils convertNSUIntegerToUnsignedInt:[presenterNavigationController.viewControllers count]];
        if (checkoutRequestIndex == 0) {
            for (int i = presenterCount - 1; i > 0; i--) {
                [presenterNavigationController popViewControllerAnimated:NO];
            }
            if ([orderNavigationController.viewControllers count] > 1) {
                [orderNavigationController popViewControllerAnimated:NO];
            }
        }
        if (checkoutRequestIndex == 1) {
            if ([orderNavigationController.viewControllers count] > 1) {
                [orderNavigationController popViewControllerAnimated:NO];
            }
            for (int i = presenterCount - 1; i > 0; i--) {
                [presenterNavigationController popViewControllerAnimated:NO];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Reset NewOrderViewController%@", [exception reason]);
    }
}

@end
