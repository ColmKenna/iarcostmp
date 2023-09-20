//
//  CustomerInfoViewController.m
//  Arcos
//
//  Created by David Kilmartin on 21/06/2011.
//  Copyright 2011  Strata IT. All rights reserved.
//

#import "CustomerInfoViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "OrderSharedClass.h"
#import "OrderFormTableViewController.h"
#import "SavedOrderTableCell.h"

@interface CustomerInfoViewController (Private)
-(void)showSelectedDetail:(NSMutableDictionary*)theData;

@end

@implementation CustomerInfoViewController
@synthesize  Name;
@synthesize  Email;
@synthesize  Fax;
@synthesize  PhoneNumber;
@synthesize  Address1;
@synthesize  Address2;
@synthesize  Address3;
@synthesize  Address4;
@synthesize  Address5;
@synthesize  CreditStatus;
@synthesize  LocationStatus;
@synthesize  LocationType;
@synthesize  LocationCode;
@synthesize  MemberOf;
@synthesize  LocationSet;
@synthesize  Latitude;
@synthesize  Longitude;
@synthesize  LocationStamp;
@synthesize  shopImage;
@synthesize  aCustDict;
@synthesize  aCustLoc;

@synthesize CLController;
@synthesize label1;
@synthesize orderListView;
@synthesize orderList;
@synthesize tableHeader;
@synthesize currentSelectOrderHeader;
@synthesize orderHeader;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CLController = [[CoreLocationController alloc] init];
        CLController.delegate = self;
        //[CLController.locMgr startUpdatingLocation];
    }
    return self;
}

- (void)dealloc
{
    [myCustomerPopoverMenuViewController release];
//    [popoverController release];
    [optionButtom release];
    
    [Name release];
    [Email release];
    [Fax release];
    [PhoneNumber release];
    [Address1 release];
    [Address2 release];
    [Address3 release];
    [Address4 release];
    [Address5 release];
    [CreditStatus release];
    [LocationStatus release];
    [LocationType release];
    [LocationCode release];
    [MemberOf release];
    [LocationSet release];
    [Latitude release];
    [Longitude release];
    [LocationStamp release];
    [shopImage release];
    
    [aCustLoc release];
    [aCustDict release];
    
    [CLController release];
    
    if (self.globalNavigationController != nil) { self.globalNavigationController = nil; }
    if (self.rootView != nil) { self.rootView = nil; }  
    [arcosCustomiseAnimation release];
        
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

        //create a option buttom
    optionButtom = [[UIBarButtonItem alloc] initWithTitle:@"Options" 
                                                                    style:UIBarButtonItemStyleDone target:self action:@selector(optionSelected:)];
    
    self.navigationItem.rightBarButtonItem=optionButtom;
    
    
    myCustomerPopoverMenuViewController=[[CustomerPopoverMenuViewController alloc]init];
    myCustomerPopoverMenuViewController.delegate=self;
//    popoverController=[[UIPopoverController alloc]initWithContentViewController:myCustomerPopoverMenuViewController];
//    popoverController.popoverContentSize = myCustomerPopoverMenuViewController.view.bounds.size;
    optionButtom.enabled=YES;
        
        //[self.view addSubview:toolBar];
    //disable the selection
    self.orderListView.allowsSelection=NO;
    
    //get a default order header
    self.orderHeader=[[OrderSharedClass sharedOrderSharedClass]getADefaultOrderHeader];
    self.rootView = [[[self parentViewController]parentViewController]parentViewController];
    arcosCustomiseAnimation = [[ArcosCustomiseAnimation alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewWillDisappear:(BOOL)animated{
//    if ([popoverController isPopoverVisible]) {
//
//        [popoverController dismissPopoverAnimated:YES];
//
//    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (aCustDict!=nil) {
        LocationSet.text=@"Check Location";
        LocationSet.textColor=[UIColor redColor];
        Name.text=[aCustDict objectForKey:@"Name"];
        Email.text=[aCustDict objectForKey:@"Email"];
        Fax.text=[aCustDict objectForKey:@"FaxNumber"];
        PhoneNumber.text=[aCustDict objectForKey:@"PhoneNumber"];
        Address1.text=[aCustDict objectForKey:@"Address1"];
        Address2.text=[aCustDict objectForKey:@"Address2"];
        Address3.text=[aCustDict objectForKey:@"Address3"];
        Address4.text=[aCustDict objectForKey:@"Address4"];
        Latitude.text=[[aCustDict objectForKey:@"Latitude"]stringValue];
        Longitude.text=[[aCustDict objectForKey:@"Longitude"]stringValue];
        
        NSLog(@"latitude is %f  longitude is %f for %@ ",[[aCustDict objectForKey:@"Latitude"]floatValue],[[aCustDict objectForKey:@"Longitude"]floatValue],Name.text);
        
        //change location button style;
        if ([[aCustDict objectForKey:@"Longitude"]floatValue]==0||[[aCustDict objectForKey:@"Latitude"]floatValue]==0) {
            [LocationStamp setImage:[UIImage imageNamed:@"pinGray.png"] forState:UIControlStateNormal];
        }else{
            [LocationStamp setImage:[UIImage imageNamed:@"pinGreen.png"] forState:UIControlStateNormal];
        }
        
        //get description dictionary
        //NSDictionary* aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"CSIUR"]];
        //NSNumber* aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
       // NSDictionary* aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"CSiur"]];
        NSDictionary* aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"LP01"]];

        if ([aCustDict objectForKey:@"CSiur"]!=nil) {
            CreditStatus.text=[aDict objectForKey:@"Detail"];
        }else{
            CreditStatus.text=@"Unknown";
        }
        
        //aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
        aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"LTiur"]];
        
        if ([aCustDict objectForKey:@"LTiur"]!=nil) {
            LocationType.text=[aDict objectForKey:@"Detail"];
        }else{
            LocationType.text=@"Unknown";
        }
        
        //aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
        aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"lsiur"]];
        
        if ([aCustDict objectForKey:@"lsiur"]!=nil) {
            LocationStatus.text=[aDict objectForKey:@"Detail"];
        }else{
            LocationStatus.text=@"Unknown";
        }
        
        aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:[aCustDict objectForKey:@"lsiur"]];
        
        if ([aCustDict objectForKey:@"lsiur"]!=nil) {
            LocationStatus.text=[aDict objectForKey:@"Detail"];
        }else{
            LocationStatus.text=@"Unknown";
        }
        
        //bad fit for the staus label
        aDict=[[ArcosCoreData sharedArcosCoreData]descrTypeWithTypeCode:@"21"];
        if ([aCustDict objectForKey:@"LP01"]!=nil) {
            label1.text=[NSString stringWithFormat:@"%@:",[aDict objectForKey:@"Details"]];
        }else{
            label1.text=@"Unknown:";
        }
        
        LocationCode.text=[aCustDict objectForKey:@"LocationCode"];
        //MemberOf;
        NSString* groupName=[[ArcosCoreData sharedArcosCoreData]locationNameWithIUR:[aCustDict objectForKey:@"MasterLocationIUR"]];
        MemberOf.text=groupName;
        //LocationSet;
        //shopImage;
        
//        NSLog(@"cust dict %@",aCustDict);
    }
    if(aCustLoc!=nil){
        Name.text=aCustLoc.Name;
        Email.text=aCustLoc.Email;
        //Fax.text=aObject.FaxNumber;
        PhoneNumber.text=aCustLoc.PhoneNumber;
        Address1.text=aCustLoc.Address1;
        Address2.text=aCustLoc.Address2;
        Address3.text=aCustLoc.Address3;
        Address4.text=aCustLoc.Address4;
        Latitude.text=[aCustLoc.Latitude stringValue];
        Longitude.text=[aCustLoc.Longitude stringValue];
        //Address5;
        //get description dictionary
        NSNumber* aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
        NSDictionary* aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:aRamdomIUR];
        
        if (aRamdomIUR!=nil) {
            CreditStatus.text=[aDict objectForKey:@"Detail"];
        }else{
            CreditStatus.text=@"Unknown";
        }
        
        aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
        aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:aRamdomIUR];
        
        if (aRamdomIUR!=nil) {
            LocationStatus.text=[aDict objectForKey:@"Detail"];
        }else{
            LocationStatus.text=@"Unknown";
        }
        
        aRamdomIUR=[[GlobalSharedClass shared]randomIntBetween:322 and:344];
        aDict=[[ArcosCoreData sharedArcosCoreData]descriptionWithIUR:aRamdomIUR];
        
        if (aRamdomIUR!=nil) {
            LocationType.text=[aDict objectForKey:@"Detail"];
        }else{
            LocationType.text=@"Unknown";
        }

        LocationCode.text=aCustLoc.LocationCode;
        //MemberOf;
        NSString* groupName=[[ArcosCoreData sharedArcosCoreData]locationNameWithIUR:aCustLoc.MasterLocationIUR];
        MemberOf.text=groupName;
        //LocationSet;
        //shopImage;; 
    }
    
    //reload the order list
    NSNumber* locationIur=[aCustDict objectForKey:@"LocationIUR"];
    self.orderList=[[ArcosCoreData sharedArcosCoreData]allOrdersWithSortKey:@"EnteredDate" withLocationIUR:locationIur];
    if (self.orderList==nil) {
        self.orderList=[NSMutableArray array];
    }
    [self.orderListView reloadData];
//    NSLog(@"%d orders found for locaiton %@",[self.orderList count],locationIur);
    
    //set iur for order header
    [self.orderHeader setObject:locationIur forKey:@"LocationIUR"];
    
    
    //enable the group selection
    UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
    UITableViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
    groupViewController.tableView.allowsSelection=YES;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}
-(IBAction)optionSelected:(id)sender{
    NSLog(@"option is selected!");
//    if ([popoverController isPopoverVisible]) {
//
//        [popoverController dismissPopoverAnimated:YES];
//
//    } else {
//
//        [popoverController presentPopoverFromBarButtonItem:optionButtom permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//
//    }
}
-(IBAction)takeOrder:(id)sender{
    //root tab bar
    /*
    ArcosAppDelegate_iPad *delegate = [[UIApplication sharedApplication] delegate];
    */
    UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
    UITabBarItem* orderItem=(UITabBarItem *)[tabbar.tabBar.items objectAtIndex:3];
    orderItem.badgeValue=@"NEW";
    //set the current customer
    if ([GlobalSharedClass shared].currentSelectedLocationIUR !=nil) {
        if ([[GlobalSharedClass shared].currentSelectedLocationIUR intValue]==[[self.aCustDict objectForKey:@"LocationIUR"]intValue]) {//same customer
            //redirct to the order pad
            tabbar.selectedIndex=3;
        }else{
            // open a dialog
//            NSString* currentCustomerName=[[OrderSharedClass sharedOrderSharedClass]currentCustomerName];
            
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Your have an order in progress for %@!",currentCustomerName] delegate:self cancelButtonTitle:nil destructiveButtonTitle:[NSString stringWithFormat: @"Switch to %@",[aCustDict objectForKey:@"Name"]] otherButtonTitles:[NSString stringWithFormat:@"Finish for %@",currentCustomerName ],nil];
//
//            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//            [actionSheet showInView:self.view];
//            [actionSheet release];
        }
    }else{
        //clear all orders
        [[OrderSharedClass sharedOrderSharedClass]clearCurrentOrder];
        
        [GlobalSharedClass shared].currentSelectedLocationIUR=[self.aCustDict objectForKey:@"LocationIUR"];
        
        //redirct to the order pad
        //select the current form
        OrderFormTableViewController* oftvc=(OrderFormTableViewController*)[GlobalSharedClass shared].orderFormViewController;
        
        tabbar.selectedIndex=3;
        
        if (oftvc!=nil) {
            [oftvc selectCurrentForm];
        }
        //reset the wholesaller of shared order class
        [[OrderSharedClass sharedOrderSharedClass]resetTheWholesellerWithLocation:[self.aCustDict objectForKey:@"LocationIUR"]];
        [[OrderSharedClass sharedOrderSharedClass]refreshCurrentOrderDate];

    }
    
}
//action sheet delegate
/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet click in index %d",buttonIndex);
    
    UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
    
    switch (buttonIndex) {
        case 1://cancel button do nothing
            tabbar.selectedIndex=3;
            break;
        case 0://ok button remove current order use the new form
            //remove global form
            [[OrderSharedClass sharedOrderSharedClass]clearCurrentOrder];
            
            //reset current location IUE
            [GlobalSharedClass shared].currentSelectedLocationIUR=[self.aCustDict objectForKey:@"LocationIUR"];
            
            //redirct to the order pad
            //select the current form
            OrderFormTableViewController* oftvc=(OrderFormTableViewController*)[GlobalSharedClass shared].orderFormViewController;
            if (oftvc!=nil) {
                [oftvc selectCurrentForm];
            }
            
            UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
            tabbar.selectedIndex=3; 
            
            //reset the wholesaller of shared order class
            [[OrderSharedClass sharedOrderSharedClass]resetTheWholesellerWithLocation:[self.aCustDict objectForKey:@"LocationIUR"]];
            break;   
        default:
            break;
    }
    

}*/
//delegate
-(void)buttonSelectedIndex:(NSInteger)index{
//    [popoverController dismissPopoverAnimated:YES];
    NSLog(@"button selected in delegate");
//    CustomerInfoViewController* testView=[[CustomerInfoViewController alloc]init];
//    [self.navigationController pushViewController:testView
//                                         animated:YES];    
    switch (index) {
        case 1: {            
            CustomerOrderModalViewController* comvc=[[CustomerOrderModalViewController alloc]initWithNibName:@"CustomerOrderModalViewController" bundle:nil];
//            comvc.animateDelegate = self;
            comvc.title = [NSString stringWithFormat:@"Orders for %@", [aCustDict objectForKey:@"Name"]];
            comvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
//            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:comvc];    
//            [self.rootView presentModalViewController:navigationController animated:YES];
//            [comvc release];
//            [navigationController release];
            comvc.rootView = self.rootView;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:comvc] autorelease];
            [comvc release];
//            self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            self.modalPresentationStyle = UIModalPresentationPageSheet;
//            [self presentModalViewController:self.globalNavigationController animated:YES];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }
            break;
        case 2: {
            CustomerCallModalViewController* ccmvc=[[CustomerCallModalViewController alloc]initWithNibName:@"CustomerCallModalViewController" bundle:nil];
//            ccmvc.delegate=self;
            ccmvc.title = [NSString stringWithFormat:@"Calls for %@", [aCustDict objectForKey:@"Name"]];
            ccmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];            
            ccmvc.rootView = self.rootView;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccmvc] autorelease];
            [ccmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }            
            break;
        case 3: {
            CustomerInvoiceModalViewController* cimvc =[[CustomerInvoiceModalViewController alloc]initWithNibName:@"CustomerInvoiceModalViewController" bundle:nil];
//            cimvc.delegate=self;
            cimvc.title = [NSString stringWithFormat:@"Invoices for %@", [aCustDict objectForKey:@"Name"]];
            cimvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            cimvc.rootView = self.rootView;
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cimvc] autorelease];
            [cimvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
         }   
            break;
        case 4: {                    
            CustomerMemoModalViewController* cmmvc =[[CustomerMemoModalViewController alloc]initWithNibName:@"CustomerMemoModalViewController" bundle:nil];
//            cmmvc.delegate=self;
            cmmvc.title = [NSString stringWithFormat:@"Memos for %@", [aCustDict objectForKey:@"Name"]];
            cmmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cmmvc] autorelease];
            [cmmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }    
            break;
        case 5: {
            CustomerAnalyzeModalViewController* camvc =[[CustomerAnalyzeModalViewController alloc]initWithNibName:@"CustomerAnalyzeModalViewController" bundle:nil];            
//            camvc.delegate=self;
            camvc.title = [NSString stringWithFormat:@"Analysis for %@", [aCustDict objectForKey:@"Name"]];
            camvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:camvc] autorelease];
            [camvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }
            break;
        case 6: {
            CustomerNotBuyModalViewController* cnbmvc =[[CustomerNotBuyModalViewController alloc]initWithNibName:@"CustomerNotBuyModalViewController" bundle:nil];
//            cnbmvc.delegate=self;
            cnbmvc.title = [NSString stringWithFormat:@"Not Buy for %@", [aCustDict objectForKey:@"Name"]];
            cnbmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cnbmvc] autorelease];
            [cnbmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }            
            break;
            
        case 7: {
            CustomerTyvLyModalViewController* ctlmvc =[[CustomerTyvLyModalViewController alloc]initWithNibName:@"CustomerTyvLyModalViewController" bundle:nil];
//            ctlmvc.anim = self;
            ctlmvc.title = [NSString stringWithFormat:@"This Year vs Last Year for %@", [aCustDict objectForKey:@"Name"]];
            ctlmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ctlmvc] autorelease];
            [ctlmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
        }            
            break;
            
        case 8: {
/**            
            CustomerDetailsModalViewController* cdmvc =[[CustomerDetailsModalViewController alloc]initWithNibName:@"CustomerDetailsModalViewController" bundle:nil];
            cdmvc.delegate = self;
            cdmvc.title = [NSString stringWithFormat:@"Details for %@", [aCustDict objectForKey:@"Name"]];            
            cdmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdmvc] autorelease];
            [cdmvc release];
            [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
 */
            CustomerDetailsWrapperModalViewController* cdwmvc = [[CustomerDetailsWrapperModalViewController alloc] initWithNibName:@"CustomerDetailsWrapperModalViewController" bundle:nil];
            cdwmvc.delegate = self;
            cdwmvc.navgationBarTitle = [NSString stringWithFormat:@"Details for %@", [aCustDict objectForKey:@"Name"]];
            cdwmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            cdwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cdwmvc] autorelease];
            [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
//            [self.rootView presentModalViewController:self.globalNavigationController animated:YES];
            [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
            [cdwmvc release];
        }            
            break;
        
        case 9: {
/**            
            CustomerCreateContactModalViewController* cccmvc = [[CustomerCreateContactModalViewController alloc] initWithNibName:@"CustomerCreateContactModalViewController" bundle:nil];
            cccmvc.delegate = self;
            cccmvc.recoredNavigationItemTitle = [NSString stringWithFormat:@"Create Contact for %@", [aCustDict objectForKey:@"Name"]];
            cccmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            cccmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.7f];            
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cccmvc] autorelease];
            
            [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
            [self.rootView presentModalViewController:self.globalNavigationController animated:YES];
            [cccmvc release];
*/            
            CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerDetailsWrapperModalViewController" bundle:nil];
            ccwmvc.delegate = self;
            ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Create Contact for %@", [aCustDict objectForKey:@"Name"]];
            ccwmvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
            self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
            [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
//            [self.rootView presentModalViewController:self.globalNavigationController animated:YES];
            [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
            [ccwmvc release];
        }            
        default:
            break;
    }
//    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
    
}
-(IBAction)stampLocation:(id)sender{
    NSLog(@"location stamping!");
    LocationSet.text=@"Check Location";
    [LocationSet setTextColor:[UIColor redColor]];
    [self.CLController start];
}
//core location delegate
- (void)locationUpdate:(CLLocation *)location {
	//locLabel.text = [location description];
    NSLog(@"location is coming back %@",[location description]);
    Latitude.text=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
    Longitude.text=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
    LocationSet.text=@"Location setted";
    [LocationSet setTextColor:[UIColor greenColor]];
    
    //reset the geo locaiton for the customer
    NSNumber* latitude=[NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber* longitude=[NSNumber numberWithFloat:location.coordinate.longitude];
    if(self.aCustLoc!=nil){
        [[ArcosCoreData sharedArcosCoreData]saveGeoLocationWithLocationIUR:self.aCustLoc.LocationIUR withLat:latitude withLon:longitude];
        self.aCustLoc.Latitude=latitude;
        self.aCustLoc.Longitude=longitude;
    }
    if(self.aCustDict!=nil){
        [[ArcosCoreData sharedArcosCoreData]saveGeoLocationWithLocationIUR:[aCustDict objectForKey:@"LocationIUR"] withLat:latitude withLon:longitude];
        [self.aCustDict setObject:latitude forKey:@"Latitude"];
        [self.aCustDict setObject:longitude forKey:@"Longitude"];
    }
    [LocationStamp setImage:[UIImage imageNamed:@"pinGreen.png"] forState:UIControlStateNormal];
    [self.CLController stop];
}

- (void)locationError:(NSError *)error {
	//locLabel.text = [error description];
    NSLog(@"location is coming back with error");
    [LocationStamp setImage:[UIImage imageNamed:@"pinGrey.png"] forState:UIControlStateNormal];
    [self.CLController stop];

}

//reset the content of the view
-(void)resetContentWithDict:(NSMutableDictionary*)aDict{
    
    self.aCustDict=aDict;

}
-(void)resetContentWithObject:(LocationUM*)aObject{
    self.aCustLoc=aObject;
    
    //set the current customer
    [GlobalSharedClass shared].currentSelectedLocationIUR=aObject.LocationIUR;
}

-(IBAction)recordCall:(id)sender{
    DetailingTableViewController* dtvc=[[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil];
    dtvc.orderHeader=self.orderHeader;
    dtvc.title=self.title;
    dtvc.isEditable=YES;

    [self.navigationController pushViewController:dtvc animated:YES];
    [dtvc release];

    
    //reset the selected customer
    //NSLog(@"a customer  info %@",aCustDict);
    [GlobalSharedClass shared].currentSelectedLocationIUR=[aCustDict objectForKey:@"LocationIUR"];
    
    //disable the group selection
    //UISplitViewController* customerSplitView=self.parentViewController.parentViewController.parentViewController;
    UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
    UITableViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
    groupViewController.tableView.allowsSelection=NO;
    NSLog(@"view controller of customer info view is %@",groupViewController);
}

-(IBAction)doSurvey {
    CustomerSurveyViewController* customerSurveyViewController = [[CustomerSurveyViewController alloc] initWithNibName:@"CustomerSurveyViewController" bundle:nil];
    customerSurveyViewController.title = self.title;
    customerSurveyViewController.locationIUR = [aCustDict objectForKey:@"LocationIUR"];
    [self.navigationController pushViewController:customerSurveyViewController animated:true];
    [customerSurveyViewController release];
    
    [GlobalSharedClass shared].currentSelectedLocationIUR=[aCustDict objectForKey:@"LocationIUR"];
    UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
    UITableViewController* groupViewController=[navigation.viewControllers objectAtIndex:0];
    groupViewController.tableView.allowsSelection=NO;
}

-(UITableViewController*)leftMasterViewController {
    UISplitViewController* splitViewController = (UISplitViewController*) self.parentViewController.parentViewController;
    return [splitViewController.viewControllers objectAtIndex:0];
}

#pragma mark order listing region
#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{   
    // custom view for header. will be adjusted to default or specified header height
    return tableHeader;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.orderList!=nil) {
        return [self.orderList count];
    }else{
        return 0;
    }
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"CustomerSavedOrderTableCell";
    
    SavedOrderTableCell *cell=(SavedOrderTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[SavedOrderTableCell class]] && [[(SavedOrderTableCell *)nibItem reuseIdentifier] isEqualToString: @"CustomerSavedOrderTableCell"]) {
                cell= (SavedOrderTableCell *) nibItem;
                
                //cell.delegate=self;
                //add taps
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
                [cell.contentView addGestureRecognizer:singleTap];
                
                UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
                doubleTap.numberOfTapsRequired = 2;
                [cell.contentView  addGestureRecognizer:doubleTap];
                [singleTap requireGestureRecognizerToFail:doubleTap];
                
                singleTap.delegate=self;
                doubleTap.delegate=self;
                [singleTap release];
                [doubleTap release];
                 
                
            }
        }
	}
    
    // Configure the cell...
    //fill data for cell
    NSMutableDictionary* cellData=[self.orderList objectAtIndex:indexPath.row];
    BOOL isCealed=[[cellData objectForKey:@"IsCealed"]boolValue];
    [cell needEditable:!isCealed];
    //cell.number.text=[[cellData objectForKey:@"OrderNumber"]stringValue];
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.date.text=[formatter stringFromDate:[cellData objectForKey:@"OrderDate"]];
    cell.deliveryDate.text=[formatter stringFromDate:[cellData objectForKey:@"DeliveryDate"]];
    [formatter release];
    //cell.point.text=[[cellData objectForKey:@"Points"]stringValue];
    //check if the order has only memon and call
    NSNumber* numberOfLines=[cellData objectForKey:@"NumberOflines"];
    
    if ([numberOfLines intValue]>0) {
        cell.value.text=[NSString stringWithFormat:@"%1.2f",[[cellData objectForKey:@"TotalGoods"]floatValue]];
        [cell.name setTextColor:[UIColor blueColor]];
        
    }else{//call with no order lines
        cell.value.text=@"CMNO";
        [cell.name setTextColor:[UIColor purpleColor]];
    }
    
    cell.name.text=[cellData objectForKey:@"WholesalerName"];
    cell.address.text=[cellData objectForKey:@"WholesalerAddress"];
    //[cell setSelectStatus:[[cellData objectForKey:@"IsSelected"]boolValue]];
    cell.data=cellData;
    
    NSLog(@"EnteredDate for cell ---%@",[cellData objectForKey:@"EnteredDate"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    SavedOrderTableCell* cell=(SavedOrderTableCell*)[self.orderListView cellForRowAtIndexPath:indexPath];
    NSNumber* isCellCealed=[(NSMutableDictionary*)cell.data objectForKey:@"IsCealed"];
    
    NSNumber* orderNumber=[[self.orderList objectAtIndex:indexPath.row]objectForKey:@"OrderNumber"];
//    NSMutableArray* orderLines=[[ArcosCoreData sharedArcosCoreData]allOrderLinesWithOrderNumber:orderNumber withSortKey:@"LineValue" locationIUR:[self.orderHeader objectForKey:@"LocationIUR"]];
    NSMutableArray* orderLines=[NSMutableArray array];
    
//    NSLog(@"row %d is taped!",indexPath.row);
    OrderProductViewController<SubstitutableDetailViewController>* orderProducts=[[[OrderProductViewController alloc]initWithNibName:@"OrderProductViewController" bundle:nil]autorelease];
    //orderProducts.delegate=self;
    orderProducts.isCellEditable=![isCellCealed boolValue];
    [orderProducts reloadTableDataWithData:orderLines];
    
    //check if any order lines
    if ([orderLines count]>0) {//some order lines 
        [self.navigationController pushViewController:orderProducts animated:YES];
    }else{//no order lines
        OrderHeader* OH=[[ArcosCoreData sharedArcosCoreData]orderHeaderWithOrderNumber:orderNumber];
        if (OH.calltrans !=nil && [OH.calltrans count]>0) {
            DetailingTableViewController* dtvc=[[[DetailingTableViewController alloc]initWithNibName:@"DetailingTableViewController" bundle:nil]autorelease];
            
            dtvc.title=cell.name.text;
            dtvc.orderNumber=orderNumber;
            dtvc.isEditable=![isCellCealed boolValue];
            [self.navigationController pushViewController:dtvc animated:YES];
            
            //disable the date group selection
            UISplitViewController* viewcontroller=(UISplitViewController*) self.parentViewController.parentViewController;
            UINavigationController* navigation=[viewcontroller.viewControllers objectAtIndex:0];
            UITableViewController* dateViewController=[navigation.viewControllers objectAtIndex:0];
            dateViewController.tableView.allowsSelection=NO;
        }
    }
    
    self.currentSelectOrderHeader=(NSMutableDictionary*) cell.data;
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
#pragma marks taps
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
-(void)handleSingleTapGesture:(id)sender{
    NSLog(@"single tap");
    
    UITapGestureRecognizer* reconizer=(UITapGestureRecognizer*)sender;
    SelectedableTableCell* aCell;
    if ([reconizer.view.superview isKindOfClass:[UITableViewCell class]]) {
        //select the cell
        //        aCell=(SelectedableTableCell*)reconizer.view.superview;
        //        [aCell flipSelectStatus];
        aCell=(SelectedableTableCell*)reconizer.view.superview;
        [self showSelectedDetail:(NSMutableDictionary*) aCell.data];
    }
    
}
-(void)showSelectedDetail:(NSMutableDictionary*)theData{
    NSLog(@"show total selection pressed!with data %@",theData);
    
    OrderDetailModelViewController* odmvc=[[OrderDetailModelViewController alloc]initWithNibName:@"OrderDetailModelViewController" bundle:nil];
    odmvc.delegate=self;
    odmvc.view.backgroundColor=[UIColor colorWithWhite:0.0f alpha:.7f];
    [odmvc loadOrderHeader:theData];
    
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
    //[self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [parentView setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [parentView presentModalViewController:odmvc animated:YES];
    [parentView presentViewController:odmvc animated:YES completion:nil];
    //[[self parentViewController].view addSubview:ohvc.view];
    [odmvc release];
    
}
#pragma mark view delegate
- (void)didDismissModalView{
    UIViewController* parentView=[[[self parentViewController]parentViewController]parentViewController];
//    [parentView dismissModalViewControllerAnimated:YES];
    [parentView dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark SlideAcrossViewAnimationDelegate
-(void)dismissSlideAcrossViewAnimation {
    [arcosCustomiseAnimation dismissPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

-(IBAction)doTest {
    CustomerWeeklyMainWrapperModalViewController* cwmwmvc = [[CustomerWeeklyMainWrapperModalViewController alloc] initWithNibName:@"CustomerWeeklyMainWrapperModalViewController" bundle:nil];
    cwmwmvc.delegate = self;
    cwmwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cwmwmvc] autorelease];
    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [self.rootView presentModalViewController:self.globalNavigationController animated:YES];
    [self.rootView presentViewController:self.globalNavigationController animated:YES completion:nil];
    [cwmwmvc release];
}

-(IBAction)doPresenter {
    CustomerPresenterFilesViewController* cpfvc =[[CustomerPresenterFilesViewController alloc]initWithNibName:@"CustomerPresenterFilesViewController" bundle:nil];
    cpfvc.animateDelegate=self;
//    cimvc.title = [NSString stringWithFormat:@"Invoices for %@", [aCustDict objectForKey:@"Name"]];            
//    cimvc.locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
//    cimvc.rootView = self.rootView;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:cpfvc] autorelease];
    [cpfvc release];
    [arcosCustomiseAnimation addPushViewAnimation:self.rootView withController:self.globalNavigationController];
}

@end
