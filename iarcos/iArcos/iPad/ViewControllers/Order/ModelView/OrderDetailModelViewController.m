//
//  OrderDetailModelViewController.m
//  Arcos
//
//  Created by David Kilmartin on 19/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "OrderDetailModelViewController.h"

@interface OrderDetailModelViewController(Private)
-(void)showWidget;
-(void)needHighlightCurrentLabel:(BOOL)need;
-(void)fillOrderDetailData:(id)data;
-(void)stampLocation;
-(void)saveTheOrderHeader;
-(void)disableUserInteractions;

@end

@implementation OrderDetailModelViewController
@synthesize contentView;
@synthesize  widgetFactory;
@synthesize TheOrderNumber;
@synthesize OrderValue;
@synthesize  Name;
@synthesize  Address;
@synthesize  OrderDate;
@synthesize  DeliveryDate;
@synthesize  Wholesaler;
@synthesize  Status;
@synthesize  Type;
@synthesize CallType;
@synthesize Contact;
@synthesize  CustomerRef;
@synthesize  Memo;
@synthesize  orders;
@synthesize  widgetPopPoint;
@synthesize  orderHeader;
@synthesize CLController;
@synthesize  Latitude;
@synthesize  Longitude;

@synthesize delegate;
@synthesize theData;

@synthesize  orderNumber;
@synthesize isEditable;
//addey by Richard
@synthesize emailButton;
@synthesize wholesalerEmailButton;
@synthesize contactEmailButton;
@synthesize mailController = _mailController;
@synthesize callEmailActionDataManager = _callEmailActionDataManager;
@synthesize orderEmailActionDataManager = _orderEmailActionDataManager;
@synthesize emailActionDelegate = _emailActionDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (void)dealloc
{
//    if (orderEmailProcessCenter != nil) { [orderEmailProcessCenter release]; }
    if (self.mailController != nil) { self.mailController = nil; }       
    if (self.callEmailActionDataManager != nil) { self.callEmailActionDataManager = nil; }
    if (self.orderEmailActionDataManager != nil) { self.orderEmailActionDataManager = nil; }    
    if (self.emailActionDelegate != nil) { self.emailActionDelegate = nil; }    
    
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
    //core location controller
    self.CLController = [[CoreLocationController alloc] init];
    self.CLController.delegate = self;
    [self.CLController start];
    
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
    
    [singleTap1 release];
    [singleTap2 release];
    [singleTap3 release];
    [singleTap4 release];
    [singleTap5 release];
    [singleTap6 release];
    [singleTap7 release];
    
    //textview outline
    self.Memo.layer.borderWidth=1.0f;
    self.Memo.layer.borderColor=[[UIColor greenColor]CGColor];
    
//    self.wholesalerEmailButton.hidden = YES;
//    self.contactEmailButton.hidden = YES;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animate{
    [super viewWillAppear:animate];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(void)fillHeaderInfo{
    //customer name and address
    //[self disableUserInteractions];
    self.Name.text=[self.orderHeader objectForKey:@"CustName"];
    self.Address.text=[self.orderHeader objectForKey:@"CustAddress"];
    
    //reload order header
    //self.orderHeader=[OrderSharedClass sharedOrderSharedClass].currentOrderHeader;
    //NSString* docketIUR = [self.orderHeader objectForKey:@"orderNumberText"];
    NSNumber* docketIUR=[self.orderHeader objectForKey:@"DocketIUR"];
    NSNumber* theOrderNumber=[self.orderHeader objectForKey:@"OrderNumber"];
    
    if ([docketIUR intValue]>0) {
        self.TheOrderNumber.text=[docketIUR stringValue];
    }else {
        self.TheOrderNumber.text=[theOrderNumber stringValue];
    }
    
//    self.TheOrderNumber.text=([docketIUR intValue]<=0) ? [[self.orderHeader objectForKey:@"OrderNumber"] stringValue] : docketIUR;
    
    
    //check any order lines
    if ([[self.orderHeader objectForKey:@"NumberOflines"]intValue]>0) {
        self.OrderValue.text = [self.orderHeader objectForKey:@"totalGoodsText"];
        self.emailActionDelegate = self.orderEmailActionDataManager;        
    }else{
        self.OrderValue.text = @"Call Only";
        self.emailActionDelegate = self.callEmailActionDataManager;        
        self.wholesalerEmailButton.hidden = YES;
    }
    self.OrderDate.text=[self.orderHeader objectForKey:@"orderDateText"];
    self.Status.text=[self.orderHeader objectForKey:@"statusText"];
    self.Type.text=[self.orderHeader objectForKey:@"orderTypeText"];
    self.CallType.text=[self.orderHeader objectForKey:@"callTypeText"];
    self.DeliveryDate.text=[self.orderHeader objectForKey:@"deliveryDateText"];
    self.Wholesaler.text=[self.orderHeader objectForKey:@"wholesalerText"];
    self.Contact.text=[self.orderHeader objectForKey:@"contactText"];
    self.CustomerRef.text=[self.orderHeader objectForKey:@"custRef"];
    self.Memo.text=[self.orderHeader objectForKey:@"memo"];
}
-(void)loadOrderHeader:(NSMutableDictionary*)anOrderHeader{
//    NSLog(@"original order header is %@", anOrderHeader);
    self.theData=anOrderHeader;
    self.isEditable=![[self.theData objectForKey:@"IsCealed"]boolValue];
    //get the header
    self.orderNumber=[self.theData objectForKey:@"OrderNumber"];
    NSLog(@"ordernumber: is %@", self.orderNumber);
//    NSLog(@"the data in the model view is %@",self.theData);
    self.orderHeader=[[ArcosCoreData sharedArcosCoreData]editingOrderHeaderWithOrderNumber:self.orderNumber];
    NSLog(@"order header for edting in model view %@",self.orderHeader);
    self.callEmailActionDataManager = [[[OrderDetailCallEmailActionDataManager alloc] initWithOrderHeader:self.orderHeader] autorelease];
    self.orderEmailActionDataManager = [[[OrderDetailOrderEmailActionDataManager alloc] initWithOrderHeader:self.orderHeader] autorelease];
    //fill the header info
    [self fillHeaderInfo];
    [self disableUserInteractions];
    [self checkOrderStatusForWholesaler];
    
//    orderEmailProcessCenter = [[OrderEmailProcessCenter alloc] initWithOrderHeader:self.orderHeader];
}
//adding a method of checkOrderStatusForWholesaler
-(void)checkOrderStatusForWholesaler {    
    NSNumber* orderHeaderIUR = [self.theData objectForKey:@"OrderHeaderIUR"];
    if ([orderHeaderIUR intValue] != 0) {//The order is sent
        self.wholesalerEmailButton.hidden = YES;
    }    
}
-(void)saveTheOrderHeader{
    [[ArcosCoreData sharedArcosCoreData]saveOrderHeader:self.orderHeader];
}
//actions
-(IBAction)donePressed:(id)sender{
    [self.orderHeader setObject:self.CustomerRef.text forKey:@"custRef"];
    [self.orderHeader setObject:self.Memo.text forKey:@"memo"];
    
    if (isEditable) {
        [self saveTheOrderHeader];
    }
    
    [self.delegate didDismissModalView];
    
}
//added by Richard
//This is for location email button.
-(IBAction)emailButtonPressed:(id)sender {
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    emailAction = 1;
    
    self.mailController = [[[MFMailComposeViewController alloc] init]autorelease]; 
    self.mailController.mailComposeDelegate = self;
//    [self.emailActionDelegate emailButtonPressed:self.mailController];
    /*
    NSNumber *locationIUR = [self.orderHeader objectForKey:@"LocationIUR"];
    
    NSMutableDictionary* locationDict = [[[ArcosCoreData sharedArcosCoreData]locationWithIUR:locationIUR]objectAtIndex:0];
    NSString* locationEmail = [locationDict objectForKey:@"Email"];    
    if (locationEmail != nil) {
        [self.mailController setToRecipients:[NSArray arrayWithObjects:locationEmail, nil]]; 
    }
	
    [self.mailController setSubject:[NSString stringWithFormat:@"%@ Order, given to %@ on %@"
                            , [orderEmailProcessCenter companyName], [orderEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"]]];
       
    [orderEmailProcessCenter buildEmailMessageWithController:self.mailController];
     */
    [self presentViewController:self.mailController animated:YES completion:nil];    
}
-(IBAction)wholesalerEmailButtonPressed:(id)sender {
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    NSLog(@"Wholesaler email button is pressed.");
    emailAction = 2;
    self.mailController = [[[MFMailComposeViewController alloc] init]autorelease]; 
    self.mailController.mailComposeDelegate = self;
//    [self.emailActionDelegate wholesalerEmailButtonPressed:self.mailController];
    /*
    NSMutableDictionary* wholesalerDict = [self.orderHeader objectForKey:@"wholesaler"];

    NSString* wholesaleEmail = [wholesalerDict objectForKey:@"Email"];
    if (wholesaleEmail != nil) {
        [self.mailController setToRecipients:[NSArray arrayWithObjects:wholesaleEmail, nil]]; 
    }
	
    [self.mailController setSubject:[NSString stringWithFormat:@"Please process the following %@ order, from %@", [orderEmailProcessCenter companyName], [orderEmailProcessCenter employeeName]]];
    [orderEmailProcessCenter buildEmailMessageWithController:self.mailController];
    */
    [self presentViewController:self.mailController animated:YES completion:nil];
}
-(IBAction)contactEmailButtonPressed:(id)sender {
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    emailAction = 3;
    self.mailController = [[[MFMailComposeViewController alloc] init]autorelease];                            
    self.mailController.mailComposeDelegate = self;
//    [self.emailActionDelegate contactEmailButtonPressed:self.mailController];
    /*
    if ([self.orderHeader objectForKey:@"contactText"] != @"None") {
        NSMutableDictionary* contactDict = [self.orderHeader objectForKey:@"contact"];
        NSString* contactEmail = [contactDict objectForKey:@"Email"];               
        if (contactEmail != nil) {
            NSArray *toRecipients = [NSArray arrayWithObjects:contactEmail, nil];
            [self.mailController setToRecipients:toRecipients]; 
        }

    }    
    [self.mailController setSubject:[NSString stringWithFormat:@"Copy of Order given to %@ on %@"
                            , [orderEmailProcessCenter employeeName], [self.orderHeader objectForKey:@"orderDateText"]]];
     
    [orderEmailProcessCenter buildEmailMessageWithController:self.mailController];
     */
    [self presentViewController:self.mailController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {    
    NSString *message;
//    UIAlertView *v = nil;
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
            if (emailAction == 2) {//email to wholesaler 
                
            } else {                
//                v = [[UIAlertView alloc] initWithTitle:@"App Email" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [v show];
//                [v release];
            }
        }            
            break;
            
        case MFMailComposeResultFailed: {
            message = @"Failed to Send Email";
//            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//            [v show];
//            [v release];
        }            
            break;
            
        default:
            message = @"Result: not sent";
            break;
    }
    
    // display an error
    NSLog(@"Email sending error message %@ ", message);
	[self becomeFirstResponder];
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        if (emailAction == 2 && [message isEqualToString:@"Sent Email OK"]) {
            NSNumber* orderSendStatus = [SettingManager defaultOrderSentStatus];
            currentLabel = self.Status;
            currentControlTag = [ArcosUtils convertNSIntegerToInt:currentLabel.tag];
            if (self.isEditable) {        
//                NSLog(@"label %d tap",currentLabel.tag);
                //do show the popover if there is no data
                UIPopoverController* popover;
                popover = [self.widgetFactory CreateGenericCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus pickerDefaultValue:orderSendStatus];
                thePopover = popover;
                if (popover!=nil) {
                    popover.delegate=self;
                    [popover presentPopoverFromRect:currentLabel.bounds inView:currentLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                }

                if (thePopover != nil) {
                    [self needHighlightCurrentLabel:YES];
                }else{
                    currentLabel.text = @"NONE";
                }                    
            }                
            //check current Geo location
            [self stampLocation];
            PickerWidgetViewController* pwvc = (PickerWidgetViewController*)thePopover.contentViewController;
            for (int i = 0; i < [pwvc.pickerData count]; i++) {
                NSMutableDictionary* aDict = [pwvc.pickerData objectAtIndex:i];
                if ([[aDict objectForKey:@"DescrDetailIUR"] isEqualToNumber:orderSendStatus]) {
                    [pwvc.picker selectRow:i inComponent:0 animated:YES];
                    break;
                }
            }
        }
    }];
    */
    
}
#pragma tap action
//taps action
-(void)handleSingleTapGesture:(id)sender{
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    UILabel* aLabel=(UILabel*)reconizer.view;
    currentLabel=aLabel;
    currentControlTag=[ArcosUtils convertNSIntegerToInt:currentLabel.tag];
    if (self.isEditable) {        
//        NSLog(@"label %d tap",aLabel.tag);
        [self showWidget];
//        if (thePopover!=nil) {
//            [self needHighlightCurrentLabel:YES];
//        }else{
//            currentLabel.text=@"NONE";
//        }
        
    }
    
    //check current Geo location
    [self stampLocation];
}
//show widget
-(void)showWidget{
    //facotry testing
    /*
    UIPopoverController* popover;
    
    
    if (currentLabel!=nil) {
        switch (currentControlTag) {
            case 0://order date label
                popover=[self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceOrderDate];
                break;
            case 1://delivery date label
                popover=[self.widgetFactory CreateDateWidgetWithDataSource:WidgetDataSourceDeliveryDate];
                
                break;
            case 2://wholesaler label
                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderWholesaler];
                
                break;
            case 3://status label
                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderStatus];
                
                break;
            case 4://type label
                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceOrderType];
                
                break;
            case 5://contact
                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceContact];
                break;
            case 6://call type label
                popover=[self.widgetFactory CreateCategoryWidgetWithDataSource:WidgetDataSourceCallType];
                break;
            default:
                break;
        }
        //do show the popover if there is no data
        thePopover=popover;
        if (popover!=nil) {
            popover.delegate=self;
            [popover presentPopoverFromRect:currentLabel.bounds inView:currentLabel permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }
    }
    */
}
//hightlight current label
-(void)needHighlightCurrentLabel:(BOOL)need{
    if (currentLabel!=nil) {
        if (need) {
            //change label style
            currentLabel.layer.borderWidth=1.0f;
            currentLabel.layer.borderColor=[[UIColor redColor]CGColor];
            currentLabel.layer.cornerRadius=5.0f;
        }else{
            currentLabel.layer.borderColor=[[UIColor clearColor]CGColor];
        }
    }
    
}
#pragma mark widget delegate
-(void)operationDone:(id)data{
    NSLog(@"operation is done from delegate--%@",data);

    [self fillOrderDetailData:data];
//    if ([thePopover isPopoverVisible]) {
//        [thePopover dismissPopoverAnimated:YES];
//    }
}
-(void)fillOrderDetailData:(id)data{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString* dataString=@"";
    if (currentLabel!=nil) {
        switch (currentControlTag) {
            case 0://order date label
                [self.orderHeader setObject:data forKey:@"orderDate"];
                dataString=[formatter stringFromDate:(NSDate*)data];
                break;
            case 1://delivery date label
                [self.orderHeader setObject:data forKey:@"deliveryDate"];
                dataString=[formatter stringFromDate:(NSDate*)data];
                break;
            case 2://wholesaler label
                [self.orderHeader setObject:data forKey:@"wholesaler"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                break;
            case 3://status label
                [self.orderHeader setObject:data forKey:@"status"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                break;
            case 4://type label
                [self.orderHeader setObject:data forKey:@"type"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                break;
            case 5://contact label
                [self.orderHeader setObject:data forKey:@"contact"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                break;
            case 6://call type label
                [self.orderHeader setObject:data forKey:@"callType"];
                dataString=(NSString*) [data objectForKey:@"Title"];
                break;
            default:
                break;
        }
        currentLabel.text=dataString;
        [self needHighlightCurrentLabel:NO];
        
    }
    [formatter release];
}
#pragma mark popover delegate
//-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
//    [self needHighlightCurrentLabel:NO];
//}
#pragma mark shift the view
- (void)shiftViewUp{
    
    // resize the scrollview
    //CGRect viewFrame = self.contentView.frame;
    //if (viewFrame.origin.y==0) {
        //viewFrame.origin.y-=200;
    //}
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.contentView.contentOffset=CGPointMake(0, 200);
    [UIView commitAnimations];
    
}

-(void)shiftViewDown{
    // resize the scrollview
    //CGRect viewFrame = self.contentView.frame;
    //if (viewFrame.origin.y<0) {
        //viewFrame.origin.y+=200;
    //}

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    self.contentView.contentOffset=CGPointMake(0, 0);
    [UIView commitAnimations];
    
}
#pragma mark text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"memo start edit!");
    //UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    //if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self shiftViewUp];
    //}
    
    //check the Geo location
    //[self stampLocation];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"memo end edit!");
    //UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    //if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self shiftViewDown];
        
    //}
    //[self.orderHeader setObject:textView.text forKey:@"memo"];
    
}

#pragma mark core location delegate
-(void)stampLocation{
    NSLog(@"location stamping!");
    [self.CLController start];
    
}
//core location delegate
- (void)locationUpdate:(CLLocation *)location {
    if (!self.isEditable) {
        return;
    }
	//locLabel.text = [location description];
    Latitude.text=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    Longitude.text=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSLog(@"location is coming back %@",[location description]);
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"latitude"];
    [self.orderHeader setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"longitude"];
    [self.CLController stop];
    
}
- (void)locationError:(NSError *)error {
	//locLabel.text = [error description];
    NSLog(@"location is coming back with error");
    [self.CLController stop];
    
}

#pragma mark disable or enable the user interaction
-(void)disableUserInteractions{
    if (self.isEditable) {
        self.Memo.userInteractionEnabled=YES;
        self.CustomerRef.userInteractionEnabled=YES;
    }else{
        self.Memo.userInteractionEnabled=NO;
        self.CustomerRef.userInteractionEnabled=NO;
    }
}

@end
