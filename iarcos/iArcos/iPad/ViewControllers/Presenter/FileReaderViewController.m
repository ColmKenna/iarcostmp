//
//  FileReaderViewController.m
//  Arcos
//
//  Created by David Kilmartin on 08/07/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "FileReaderViewController.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "FormRowsTableViewController.h"
@interface FileReaderViewController(Private)
-(void)saveOrderToTheCart:(NSMutableDictionary*)data;
@end

@implementation FileReaderViewController
@synthesize  fileContentView;
@synthesize fileURL;
@synthesize theData;
@synthesize factory;
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
    //add order button to the navigation bar
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Order"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(orderProduct:)];
    
    self.navigationItem.rightBarButtonItem = typeButton;
    [typeButton release];
    
    //input popover
    factory=[WidgetFactory factory];
    factory.delegate=self;
//    inputPopover=[factory CreateOrderInputPadWidgetWithLocationIUR:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillDisappear:(BOOL)animated{
//    [inputPopover dismissPopoverAnimated:NO];
    [fileContentView loadHTMLString:@"" baseURL:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Addtional function
-(void)loadFile:(NSURL*)aURL{
    self.fileURL=aURL;
    fileContentView.scalesPageToFit = YES;
    [fileContentView loadRequest:[NSURLRequest requestWithURL:self.fileURL]];
    NSLog(@"request url %@",[aURL absoluteString]);
}

#pragma mark order product
//order product
-(void)orderProduct:(id)sender{
    UIBarButtonItem* button=(UIBarButtonItem*)sender;
    
    //check any customer 
    if ([GlobalSharedClass shared].currentSelectedLocationIUR ==nil){     
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No customer selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        actionSheet.tag=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.parentViewController.view];
        [actionSheet release];
        return;
    }
    //no form
    if (![[OrderSharedClass sharedOrderSharedClass]anyForm]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No Form selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        actionSheet.tag=0;
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.parentViewController.view];
        [actionSheet release];
        return;
    }
    
    //order the product
    NSLog(@"order pressed! with data %@",self.theData);
    if(self.theData != nil){
        NSString* L5code=[self.theData objectForKey:@"L5code"];
        NSNumber* ProductIUR=[self.theData objectForKey:@"ProductIUR"];
        
        //single product
        if ([ProductIUR intValue]>0&&[L5code intValue]>0) {
            NSMutableDictionary* formRow=[NSMutableDictionary dictionary];
            
            BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
            
            //check is product already in the current selected form
            if (!isProductInCurrentForm) {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Product is not in current selected form!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                actionSheet.tag=0;
                actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                [actionSheet showInView:self.parentViewController.view];
                [actionSheet release];
                return;
            }
            
            NSLog(@"get only one product!");
//            formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            NSLog(@"form row for the product is %@",formRow);
            
            //sync the row with current cart
            formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
            
//            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) inputPopover.contentViewController;
//            oipvc.Data=formRow;
//
//            [inputPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            
        }else if(![L5code isEqualToString:@""]&&[ProductIUR intValue]<=0){//product group
            NSMutableDictionary* formRows=[NSMutableDictionary dictionary];
            
            NSMutableArray* products=[[ArcosCoreData sharedArcosCoreData]productWithL5Code:L5code];
//            NSLog(@"get %d products from whole group!",[products count]);
            
            if (products!=nil&&[products count]>0) {//any product for the given L5 code
                for (NSMutableDictionary* aProduct in products) {//loop products
                    NSNumber* ProductIUR=[aProduct objectForKey:@"ProductIUR"];
                    //is the product int the current form
                    BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
                    
                    if (isProductInCurrentForm) {//create a form row and add to the form rows array
//                        NSMutableDictionary* formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
                        NSMutableDictionary* formRow = [NSMutableDictionary dictionary];
                        //sync the row with current cart
                        formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
                        
                        [formRows setObject:formRow forKey:[formRow objectForKey:@"CombinationKey"]];
                    }
                }
//                NSLog(@"%d form rows created from L5 code %@",[formRows count],L5code);
                
                //push the form row view if there are some rows
                if ([formRows count]>0) {
                    FormRowsTableViewController *formRowsView= [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
                    [formRowsView resetDataWithFormRows:formRows];
                    [self.navigationController pushViewController:formRowsView animated:YES];
                    [formRowsView release];
                }else{
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"None product is not in current selected form!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                                    otherButtonTitles:nil];
                    actionSheet.tag=0;
                    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
                    [actionSheet showInView:self.parentViewController.view];
                    [actionSheet release];
                    return;
                }
                
                
            }
        }
        
    }
    
    
    //[inputPopover presentPopoverFromRect:button.bound inView:self. permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
//input popover delegate
-(void)operationDone:(id)data{
    NSLog(@"input is done! with value %@",data);
    
//    [inputPopover dismissPopoverAnimated:YES];
    [[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:data];
    [self saveOrderToTheCart:data];
    
}

-(void)saveOrderToTheCart:(NSMutableDictionary*)data{
    
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
}

//web view delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"content load with error %@",[error description]);

    if([error code]==102 ||[error code]==202 ||[error code]==-1100) {
        [fileContentView loadHTMLString:@"<h1>Fail to load the file</h>" baseURL:nil];
    }
}
@end
