//
//  PresenterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 18/01/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "PresenterViewController.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "ArcosCoreData.h"
#import "ArcosRootViewController.h"

@interface PresenterViewController (Private)
-(void)saveOrderToTheCart:(NSMutableDictionary*)data;
-(void)createPresenterTransactionToolInstance;
@end

@implementation PresenterViewController
@synthesize presenterRequestSource = _presenterRequestSource;
@synthesize files;
@synthesize fileType = _fileType;
@synthesize currentFile;
//@synthesize inputPopover = _inputPopover;
@synthesize globalWidgetViewController = _globalWidgetViewController;
@synthesize factory = _factory;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
//@synthesize emailPopover = _emailPopover;
@synthesize emailNavigationController = _emailNavigationController;
@synthesize emailButton = _emailButton;
@synthesize rowPointer = _rowPointer;
@synthesize candidateRemovedFileList = _candidateRemovedFileList;
@synthesize removedFileList = _removedFileList;
@synthesize auxEmailCellData = _auxEmailCellData;
//@synthesize documentInteractionController;
@synthesize recordBeginDate = _recordBeginDate;
@synthesize recordEndDate = _recordEndDate;
@synthesize presenterBaseDataManager = _presenterBaseDataManager;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize frwvc = _frwvc;
@synthesize formRowsNavigationController = _formRowsNavigationController;
@synthesize emailButtonAddressSelectDelegate = _emailButtonAddressSelectDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fileDownloadCenter=[[FileDownloadCenter alloc]init];
        self.files=[NSMutableArray array];
        self.currentFile=nil;
        self.presenterRequestSource = PresenterRequestSourceSubMenu;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createPresenterTransactionToolInstance];
    UIBarButtonItem *typeButton = [[UIBarButtonItem alloc] 
                                   initWithTitle: @"Order"
                                   style:UIBarButtonItemStylePlain
                                   target: self
                                   action:@selector(orderProduct:)];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    NSMutableArray* buttonList = [NSMutableArray arrayWithCapacity:2];
    if (self.presenterRequestSource == PresenterRequestSourceSubMenu) {
        [buttonList addObject:typeButton];
    }
    [buttonList addObject:self.emailButton];
//    self.navigationItem.rightBarButtonItem = typeButton;
    self.navigationItem.rightBarButtonItems = buttonList;
    [typeButton release];
    
    //input popover
    self.factory=[WidgetFactory factory];
    self.factory.delegate=self;
//    self.inputPopover=[self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
//    self.inputPopover.delegate = self;
    [ArcosUtils configEdgesForExtendedLayout:self];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] || self.presenterRequestSource == PresenterRequestSourceMainMenu) return;
    [self.presenterBaseDataManager recordLocationCoordinate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] || self.presenterRequestSource == PresenterRequestSourceMainMenu) return;
    if ([self.fileType intValue] == 12) return;
    self.recordBeginDate = [NSDate date];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if ([self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//    }
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showPackageFlag]) {
        if (self.frwvc != nil) {
            [self didDismissCustomisePartialPresentView];
        }        
    }
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] || self.presenterRequestSource == PresenterRequestSourceMainMenu) return;
    if (self.recordBeginDate == nil) return;
    
    if ([self.fileType intValue] == 11) {
        [self processPtranRecord:self.currentFile];
    } else {
        if ([self.files count] > 0) {
            [self processPtranRecord:[self.files objectAtIndex:0]];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.navigationController.view setNeedsLayout];
}

- (void)createEmailPopoverProcessor {
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    self.emailRecipientTableViewController.requestSource = EmailRequestSourcePresenter;
    self.emailRecipientTableViewController.recipientDelegate = self;
    self.emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailNavigationController.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
//    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:emailNavigationController] autorelease];
    
//    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
}

- (BOOL)emailButtonPressed:(id)sender {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return;
//    }
//    if (![self validateHiddenPopovers]) return NO;
    [self createEmailPopoverProcessor];    
//    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.emailNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    self.emailNavigationController.popoverPresentationController.barButtonItem = self.emailButton;
    self.emailNavigationController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self presentViewController:self.emailNavigationController animated:YES completion:nil];
    return YES;
}

#pragma mark order product
//order product
-(void)orderProduct:(id)sender{
//    NSString* scheme = @"itms-books://itunes.apple.com/de/book/marchen/id436945766";
    
//    NSString* scheme = @"http://www.google.ie";
//    NSString* filepath=[NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],@"Manual.pdf"];
//    NSString* fullFilePath = [NSString stringWithFormat:@"%@%@",scheme, @""];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullFilePath]];
//    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
//    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
//    self.documentInteractionController.delegate = self;
//    [self.documentInteractionController presentOpenInMenuFromBarButtonItem:self.emailButton animated:YES];
//    return;
//    NSLog(@"current file is %@",self.currentFile);
    
    UIBarButtonItem* button=(UIBarButtonItem*)sender;
    
    //check any customer 
    if ([GlobalSharedClass shared].currentSelectedLocationIUR ==nil){     
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No Customer selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                        otherButtonTitles:nil];
//        actionSheet.tag=0;
//        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//        [actionSheet showInView:self.parentViewController.view];
//        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//        [actionSheet release];
        [ArcosUtils showDialogBox:@"No Customer selected!" title:@"" delegate:nil target:self tag:0 handler:nil];
        return;
    }
    //no form
    if (![[OrderSharedClass sharedOrderSharedClass]anyForm]) {
        NSNumber* defaultFormIUR = [SettingManager SettingForKeypath:@"CompanySetting.Default Types" atIndex:7];
        if ([defaultFormIUR intValue] != 0) {
            [OrderSharedClass sharedOrderSharedClass].currentFormIUR = defaultFormIUR;
            [[OrderSharedClass sharedOrderSharedClass] insertFormIUR:defaultFormIUR];
        } else {
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No Form selected!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                            otherButtonTitles:nil];
//            actionSheet.tag=0;
//            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//            [actionSheet showInView:self.parentViewController.view];
//            [actionSheet release];
            [ArcosUtils showDialogBox:@"No Form selected!" title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
    }
    
    
    //order the product
//    NSLog(@"order pressed! with data %@",self.currentFile);
    if(self.currentFile != nil){
        NSNumber* orderLevel = [self.currentFile objectForKey:@"OrderLevel"];
        NSString* lxcodeKey = nil;
        switch ([orderLevel intValue]) {
            case 0:
            case 5:    
                lxcodeKey = @"L5code";
                break;
            case 1:
                lxcodeKey = @"L1code";
                break;
            case 2:
                lxcodeKey = @"L2code";
                break;
            case 3:
                lxcodeKey = @"L3code";
                break;
            case 4:
                lxcodeKey = @"L4code";
                break;
                
            default:
                lxcodeKey = @"L5code";
                break;
        }
        NSString* Lxcode=[self.currentFile objectForKey:lxcodeKey];        
        NSNumber* ProductIUR=[self.currentFile objectForKey:@"ProductIUR"];    
        NSDictionary* currentFormDetailRecordDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
        NSString* orderFormDetails = [ArcosUtils convertNilToEmpty:[currentFormDetailRecordDict objectForKey:@"Details"]];
        NSString* currentPrintDeliveryDocket = [currentFormDetailRecordDict objectForKey:@"PrintDeliveryDocket"];
        if ([currentPrintDeliveryDocket isEqualToString:@"1"]) {
            [self oneOrderFormBranch:Lxcode orderLevel:orderLevel productIUR:ProductIUR button:button orderFormDetails:orderFormDetails];
        } else {
            [self multipleOrderFormBranch:Lxcode orderLevel:orderLevel productIUR:ProductIUR button:button orderFormDetails:orderFormDetails];
        }
    }    
}
//input popover delegate
-(void)operationDone:(id)data{
//    NSLog(@"presenter input is done! with value %@",data);
    
//    [self.inputPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:data];
    [self saveOrderToTheCart:data];
    
}

-(void)saveOrderToTheCart:(NSMutableDictionary*)data{
    
    [[OrderSharedClass sharedOrderSharedClass] saveOrderLine:data];
}
//set the bar title
-(void)resetBarTitle:(NSString*)title{
    self.title=title;
}

//find out the index for the given file name
-(int)indexForFile:(NSString*)fileName{
    for (int i=0; i<[self.files count];i++ ) {
        NSMutableDictionary* dict=[self.files objectAtIndex:i];
        NSString* name=[dict objectForKey:@"Name"];
        if ([name isEqualToString:fileName]) {
            return i;
        }
    }
    return 0;
}
#pragma file download delegate
-(void)fileDownload:(FileCommon *)FC withError:(BOOL)error{
    
}
-(void)allFilesDownload{
    
}
-(void)didFailWithError:(NSError *)anError {
//    [ArcosUtils showMsg:-1 message:[anError localizedDescription] delegate:nil];
}
-(void)updateProgressBar:(float)aValue {

}

-(void)dealloc{
    [fileDownloadCenter release];
    self.files = nil;
    self.fileType = nil;
    self.currentFile = nil;
//    self.inputPopover = nil;
    self.globalWidgetViewController = nil;
    self.factory = nil;
    if (self.emailRecipientTableViewController != nil) { self.emailRecipientTableViewController = nil; }
//    if (self.emailPopover != nil) { self.emailPopover = nil; }
    self.emailNavigationController = nil;
    if (self.emailButton != nil) { self.emailButton = nil; }
    self.candidateRemovedFileList = nil;
    self.removedFileList = nil;
    self.auxEmailCellData = nil;
//    self.documentInteractionController = nil;
    self.recordBeginDate = nil;
    self.recordEndDate = nil;
    self.presenterBaseDataManager = nil;    
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.frwvc = nil;
    [self.formRowsNavigationController.view removeFromSuperview];
    self.formRowsNavigationController = nil;
    self.emailButtonAddressSelectDelegate = nil;
    
    [super dealloc];
}

-(void)oneOrderFormBranch:(NSString*)Lxcode orderLevel:(NSNumber*)anOrderLevel productIUR:(NSNumber*)ProductIUR button:(UIBarButtonItem*)button orderFormDetails:(NSString*)anOrderFormDetails {
    //single product
    if ([ProductIUR intValue]>0 && ([anOrderLevel intValue] == 0 || [anOrderLevel intValue] == 6)) {
        NSMutableDictionary* formRow=[NSMutableDictionary dictionary];
        
//        BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
        BOOL isProductInCurrentForm = [self isProductInFormRowWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR productIUR:ProductIUR];
        
        //check is product already in the current selected form
        if (!isProductInCurrentForm) {
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Product is not in the current selected form!" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                            otherButtonTitles:nil];
//            actionSheet.tag=0;
//            actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//            [actionSheet showInView:self.parentViewController.view];
////            [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
//            [actionSheet release];
            [ArcosUtils showDialogBox:@"Product is not in the current selected form!" title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
        
        NSLog(@"get only one product!");
        formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourcePresenterSubMenu] orderFormDetails:anOrderFormDetails];
        if (formRow == nil) {
            [ArcosUtils showDialogBox:@"Product not found" title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
//        NSLog(@"form row for the product is %@",formRow);
        
        //sync the row with current cart
        formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        //[[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:formRow];
//        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
                self.globalWidgetViewController = [self.factory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            } else {
                self.globalWidgetViewController = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            }
            
//            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
//            self.globalWidgetViewController.Data = formRow;
            OrderEntryInputViewController* oeivc = (OrderEntryInputViewController*)self.globalWidgetViewController;
            oeivc.Data = formRow;
            oeivc.orderEntryInputDataManager.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        } else {
            self.globalWidgetViewController=[self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            OrderInputPadViewController* oipvc = (OrderInputPadViewController*)self.globalWidgetViewController;
//            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data=formRow;
//            oipvc.showSeparator = showSeparator;
            oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
//        self.inputPopover.delegate = self;
               
//        [self.inputPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.barButtonItem = button;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
        
    } else {//product group
//        ![Lxcode isEqualToString:@""]&&
        NSMutableArray* unsortFormRows = [NSMutableArray array];
        if ([anOrderLevel intValue] == 7 || [anOrderLevel intValue] == 8) {
            NSNumber* auxSequenceDivider = [NSNumber numberWithInt:-1];
            if ([anOrderLevel intValue] == 8) {
                auxSequenceDivider = [ArcosUtils convertStringToNumber:[self.currentFile objectForKey:@"L1code"]];
            }
            NSMutableArray* auxFormRowList = [self retrieveFormRowList:auxSequenceDivider];
            for (int i = 0; i < [auxFormRowList count]; i++) {
                NSMutableDictionary* auxFormRow = [auxFormRowList objectAtIndex:i];
                NSNumber* auxProductIUR = [auxFormRow objectForKey:@"ProductIUR"];
                if ([auxProductIUR intValue] == 0 || [auxProductIUR intValue] == -1) {
                    [unsortFormRows addObject:auxFormRow];
                    continue;
                }
                BOOL isProductInCurrentForm = [self isProductInFormRowWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR productIUR:auxProductIUR];
                if (isProductInCurrentForm) {
                    [unsortFormRows addObject:auxFormRow];
                }
            }
        } else {
            NSMutableArray* products=[[ArcosCoreData sharedArcosCoreData]activeProductWithLxCode:Lxcode orderLevel:anOrderLevel];
            
            if (products!=nil&&[products count]>0) {//any product for the given L5 code
                for (NSMutableDictionary* aProduct in products) {//loop products
                    NSNumber* ProductIUR=[aProduct objectForKey:@"ProductIUR"];
                    //is the product int the current form
                    //                BOOL isProductInCurrentForm=[[OrderSharedClass sharedOrderSharedClass]isProductInCurrentFormWithIUR:ProductIUR];
                    BOOL isProductInCurrentForm = [self isProductInFormRowWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR productIUR:ProductIUR];
                    
                    if (isProductInCurrentForm) {//create a form row and add to the form rows array
                        NSMutableDictionary* formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourcePresenterSubMenu] orderFormDetails:anOrderFormDetails];
                        //sync the row with current cart
                        formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
                        [unsortFormRows addObject:formRow];
                    }
                }
                if ([products count] == 0) {
//                    [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
                    [ArcosUtils showDialogBox:@"Please Check for Active Product Group Assignments." title:@"" delegate:nil target:self tag:0 handler:nil];
                    return;
                }            
            }
        }                
        [self formRowProcessorWithDataList:unsortFormRows];
    }
}

-(void)multipleOrderFormBranch:(NSString*)Lxcode orderLevel:(NSNumber*)anOrderLevel productIUR:(NSNumber*)ProductIUR button:(UIBarButtonItem*)button orderFormDetails:(NSString*)anOrderFormDetails {
    //single product
    if ([ProductIUR intValue]>0  && ([anOrderLevel intValue] == 0 || [anOrderLevel intValue] == 6)) {
        NSMutableDictionary* formRow=[NSMutableDictionary dictionary];        
//        NSLog(@"get only one product!");
        formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourcePresenterSubMenu] orderFormDetails:anOrderFormDetails];
        if (formRow == nil) {
            [ArcosUtils showDialogBox:@"Product not found" title:@"" delegate:nil target:self tag:0 handler:nil];
            return;
        }
//        NSLog(@"form row for the product is %@",formRow);
        
        //sync the row with current cart
        formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        //[[OrderSharedClass sharedOrderSharedClass]syncAllSelectionsWithRowData:formRow];
//        BOOL showSeparator = [ProductFormRowConverter showSeparatorWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableAlternateOrderEntryPopoverFlag]) {
            if ([[SettingManager databaseName] isEqualToString:[GlobalSharedClass shared].pxDbName]) {
                self.globalWidgetViewController = [self.factory CreateOrderEntryInputRightHandSideWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            } else {
                self.globalWidgetViewController = [self.factory CreateOrderEntryInputWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            }
            
//            WidgetViewController* wvc = (WidgetViewController*)self.inputPopover.contentViewController;
//            self.globalWidgetViewController.Data = formRow;
            OrderEntryInputViewController* oeivc = (OrderEntryInputViewController*)self.globalWidgetViewController;
            oeivc.Data = formRow;
            oeivc.orderEntryInputDataManager.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
        } else {
            self.globalWidgetViewController=[self.factory CreateOrderInputPadWidgetWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
            OrderInputPadViewController* oipvc = (OrderInputPadViewController*)self.globalWidgetViewController;
//            OrderInputPadViewController* oipvc=(OrderInputPadViewController*) self.inputPopover.contentViewController;
            oipvc.Data=formRow;
//            oipvc.showSeparator = showSeparator;
            oipvc.relatedFormDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]];
            ArcosErrorResult* arcosErrorResult = [oipvc productCheckProcedure];
            if (!arcosErrorResult.successFlag) {
                [ArcosUtils showDialogBox:arcosErrorResult.errorDesc title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }
//        self.inputPopover.delegate = self;
//        [self.inputPopover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.globalWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
        self.globalWidgetViewController.popoverPresentationController.barButtonItem = button;
        self.globalWidgetViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        self.globalWidgetViewController.popoverPresentationController.delegate = self;
        [self presentViewController:self.globalWidgetViewController animated:YES completion:nil];
        
    } else {//product group
        //![Lxcode isEqualToString:@""]&&
        NSMutableArray* unsortFormRows=[NSMutableArray array];
        if ([anOrderLevel intValue] == 7 || [anOrderLevel intValue] == 8) {//order form type
            NSNumber* auxSequenceDivider = [NSNumber numberWithInt:-1];
            if ([anOrderLevel intValue] == 8) {
                auxSequenceDivider = [ArcosUtils convertStringToNumber:[self.currentFile objectForKey:@"L1code"]];
            }
            unsortFormRows = [self retrieveFormRowList:auxSequenceDivider];
        } else {
            NSMutableArray* products = [[ArcosCoreData sharedArcosCoreData]activeProductWithLxCode:Lxcode orderLevel:anOrderLevel];
            if (products!=nil&&[products count]>0) {//any product for the given L5 code
                for (NSMutableDictionary* aProduct in products) {//loop products
                    NSNumber* ProductIUR=[aProduct objectForKey:@"ProductIUR"];                
                    NSMutableDictionary* formRow=[[ArcosCoreData sharedArcosCoreData]createFormRowWithProductIUR:ProductIUR locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourcePresenterSubMenu] orderFormDetails:anOrderFormDetails];
                    formRow=[[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
                    [unsortFormRows addObject:formRow];
                }                        
            }
            if ([products count] == 0) {
//                [ArcosUtils showMsg:@"Please Check for Active Product Group Assignments." delegate:nil];
                [ArcosUtils showDialogBox:@"Please Check for Active Product Group Assignments." title:@"" delegate:nil target:self tag:0 handler:nil];
                return;
            }
        }        
        [self formRowProcessorWithDataList:unsortFormRows];        
    }
}

- (NSMutableArray*)retrieveFormRowList:(NSNumber*)aSequenceDivider {//[NSNumber numberWithInt:-1]
//    NSMutableArray* auxUnsortFormRows = [[ArcosCoreData sharedArcosCoreData] formRowWithDividerIURSortByNatureOrder:aSequenceDivider withFormIUR:[self.currentFile objectForKey:@"FormIUR"] locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR];
    NSMutableArray* auxUnsortFormRows = [[ArcosCoreData sharedArcosCoreData] dividerFormRowsWithDividerIUR:aSequenceDivider formIUR:[self.currentFile objectForKey:@"FormIUR"] locationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR packageIUR:[[GlobalSharedClass shared] retrieveCurrentSelectedPackageIURWithRequestSource:ProductRequestSourcePresenterSubMenu]];
    for (int i = 0; i < [auxUnsortFormRows count]; i++) {
        NSMutableDictionary* formRow = [auxUnsortFormRows objectAtIndex:i];
        formRow = [[OrderSharedClass sharedOrderSharedClass]syncRowWithCurrentCart:formRow];
        [auxUnsortFormRows replaceObjectAtIndex:i withObject:formRow];
    }
    return auxUnsortFormRows;
}

- (void)formRowProcessorWithDataList:(NSMutableArray*)aFormRowList {
    if ([aFormRowList count]>0) {
//        FormRowsTableViewController *formRowsView= [[FormRowsTableViewController alloc] initWithNibName:@"FormRowsTableViewController" bundle:nil];
//        formRowsView.dividerIUR=[NSNumber numberWithInt:-2];//dirty fit the form row
//        formRowsView.unsortedFormrows=aFormRowList;                
//        formRowsView.isRequestSourceFromPresenter = YES;
//        formRowsView.isShowingSearchBar = YES;
//        [formRowsView syncUnsortedFormRowsWithOriginal];
//        [self.navigationController pushViewController:formRowsView animated:YES];
//        [formRowsView release];
        if (self.frwvc != nil) return;
        NSString* formRowsNibName = @"FormRowsWrapperViewController";
        if ([aFormRowList count] > 7) {
            formRowsNibName = @"FormRowsWrapperPercentageViewController";
        }
        self.frwvc = [[[FormRowsWrapperViewController alloc] initWithNibName:formRowsNibName bundle:nil] autorelease];
        self.frwvc.actionDelegate = self;
        self.frwvc.formRowsTableViewController.dividerIUR = [NSNumber numberWithInt:-2];
        self.frwvc.formRowsTableViewController.unsortedFormrows = aFormRowList;
        self.frwvc.formRowsTableViewController.isRequestSourceFromPresenter = YES;
        self.frwvc.formRowsTableViewController.isShowingSearchBar = YES;
        [self.frwvc.formRowsTableViewController syncUnsortedFormRowsWithOriginal];
        self.frwvc.myDelegate = self;
        self.frwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.formRowsNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.frwvc] autorelease];
        self.formRowsNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        [self addChildViewController:self.formRowsNavigationController];
        [self.view addSubview:self.formRowsNavigationController.view];
        
        [self.formRowsNavigationController didMoveToParentViewController:self];
        [UIView animateWithDuration:0.3f animations:^{
            self.formRowsNavigationController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        } completion:^(BOOL finished){
            
        }];
    }else{
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"No data found" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
//                                                        otherButtonTitles:nil];
//        actionSheet.tag=0;
//        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
//        [actionSheet showInView:self.parentViewController.view];
//        [actionSheet release];
        [ArcosUtils showDialogBox:@"No data found" title:@"" delegate:nil target:self tag:0 handler:nil];
        
    }
}
#pragma mark FormRowsTableViewControllerDelegate
- (void)didPressCheckoutButton {
    NextCheckoutViewController* ncvc = [[NextCheckoutViewController alloc] initWithNibName:@"NextCheckoutViewController" bundle:nil];
//    ncvc.title = @"Checkout";
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ncvc] autorelease];
    [self.navigationController pushViewController:ncvc animated:YES];
    [ncvc release];
}

#pragma mark CustomisePartialPresentViewControllerDelegate
- (void)didDismissCustomisePartialPresentView {
    [UIView animateWithDuration:0.3f animations:^{
        self.formRowsNavigationController.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished){
        [self.formRowsNavigationController willMoveToParentViewController:nil];
        [self.formRowsNavigationController.view removeFromSuperview];
        [self.formRowsNavigationController removeFromParentViewController];
        self.frwvc = nil;
        self.formRowsNavigationController = nil;
    }];
}

-(BOOL)isProductInFormRowWithFormIUR:(NSNumber*)aFormIUR productIUR:(NSNumber*)aProductIUR {
    BOOL isProductInFormRow = NO;
    NSDictionary* productFormRowDict = [[ArcosCoreData sharedArcosCoreData] formRowWithFormIUR:aFormIUR productIUR:aProductIUR];
    if (productFormRowDict != nil) {
        isProductInFormRow = YES;
    }
    return isProductInFormRow;
}

- (void)checkFileSizeWithIndex:(int)aRowPointer {
    NSMutableDictionary* tmpPresenterProduct = [self.candidateRemovedFileList objectAtIndex:aRowPointer];
    NSString* message = [NSString stringWithFormat:@"Are you sure to attach %@ which is %@?", [tmpPresenterProduct objectForKey:@"Name"], [tmpPresenterProduct objectForKey:@"fileSize"]];
//    UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
//    v.tag = 36;
//    [v show];
//    [v release];
    void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self checkFileSizeProcessor];
    };
    void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
        [self.removedFileList addObject:[self.candidateRemovedFileList objectAtIndex:self.rowPointer]];
        [self checkFileSizeProcessor];
    };
    [ArcosUtils showTwoBtnsDialogBox:message title:@"" target:self lBtnText:@"NO" rBtnText:@"YES" lBtnHandler:noActionHandler rBtnHandler:yesActionHandler];
}
- (void)checkFileSizeProcessor {
    self.rowPointer++;
    if (self.rowPointer != [self.candidateRemovedFileList count]) {
        [self checkFileSizeWithIndex:self.rowPointer];
    } else {
        [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:self.files];
    }
}
#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag != 36) return;
//    if (buttonIndex == [alertView cancelButtonIndex]) {
//        [self.removedFileList addObject:[self.candidateRemovedFileList objectAtIndex:self.rowPointer]];
//    }
//    self.rowPointer++;
//    if (self.rowPointer != [self.candidateRemovedFileList count]) {
//        [self checkFileSizeWithIndex:self.rowPointer];
//    } else {
//        [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:self.files];
//    }
//}

#pragma mark - EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary*)cellData {    
//    [self.emailPopover dismissPopoverAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^ {
        self.auxEmailCellData = cellData;
        self.rowPointer = 0;
        self.removedFileList = [NSMutableArray array];
        [self getOverSizeFileListFromDataList:self.files];
        if ([self.candidateRemovedFileList count] > 0) {
            [self checkFileSizeWithIndex:self.rowPointer];
        } else {
            [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:self.files];
        }
    }];
//    self.auxEmailCellData = cellData;
//    self.rowPointer = 0;
//    self.removedFileList = [NSMutableArray array];
//    [self getOverSizeFileListFromDataList:self.files];
//    if ([self.candidateRemovedFileList count] > 0) {
//        [self checkFileSizeWithIndex:self.rowPointer];
//    } else {
//        [self processSelectEmailRecipientRow:self.auxEmailCellData dataList:self.files];
//    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    NSString* title = nil;
//    UIAlertView* v = nil;
    BOOL alertShowedFlag = NO;
    switch (result) {
        case MFMailComposeResultSent: {            
            message = @"Sent Email OK";
            title = @"App Email";
            
//            v = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [v show];
//            [v release];
            
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = [error localizedDescription];
//            v = [[UIAlertView alloc] initWithTitle: @"Error !" message: message delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil, nil];
//            [v show];
//            [v release];
            alertShowedFlag = YES;
            [ArcosUtils showDialogBox:message title:@"Error !" delegate:nil target:controller tag:0 handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }            
            break;
            
        default:
            break;
    }
    if (!alertShowedFlag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString*)getMimeTypeWithFileName:(NSString*)aFileName {
    NSString* mimeTypeString = @"application/octet-stream";
    @try {
        NSArray* fileComponents = [aFileName componentsSeparatedByString:@"."];
        // Use the filename (index 0) and the extension (index 1) to get path
        NSString* fileExtension = [fileComponents objectAtIndex:1];
        if ([@"png" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/png";
        } else if ([@"jpg" isEqualToString:fileExtension] || [@"jpeg" isEqualToString:fileExtension]) {
            mimeTypeString = @"image/jpeg";
        } else if ([@"pdf" isEqualToString:fileExtension]) {
            mimeTypeString = @"application/pdf";
        } else if ([@"mov" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/quicktime";
        } else if ([@"mp4" isEqualToString:fileExtension]) {
            mimeTypeString = @"video/mp4";
        } else if ([@"ibooks" isEqualToString:fileExtension]) {
            mimeTypeString = @"application/x-ibooks+zip";
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception reason]);
    }
    return mimeTypeString;
}

- (void)getOverSizeFileListFromDataList:(NSMutableArray*)aDataList {
    self.candidateRemovedFileList = [NSMutableArray array];
    int sizeLimit = 1024*1024*10;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    for (int i = 0; i < [aDataList count]; i++) {
        NSDictionary* tmpPresenterProduct = [aDataList objectAtIndex:i];
        NSString* fileName = [tmpPresenterProduct objectForKey:@"Name"];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],fileName];
        if ([FileCommon fileExistAtPath:filePath]) {
            NSDictionary* fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
            NSNumber* fileSize = [fileAttributes objectForKey:@"NSFileSize"];
            if ([fileSize unsignedLongLongValue] > sizeLimit) {
                NSMutableDictionary* newTmpPresenterProduct = [NSMutableDictionary dictionaryWithDictionary:tmpPresenterProduct];
                [newTmpPresenterProduct setObject:[HumanReadableDataSizeHelper humanReadableSizeFromBytes:fileSize useSiPrefixes:YES useSiMultiplier:NO] forKey:@"fileSize"];
                [self.candidateRemovedFileList addObject:newTmpPresenterProduct];
            }
        }
    }
}

- (void)processSelectEmailRecipientRow:(NSDictionary*)cellData dataList:(NSMutableArray*)aDataList{
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {        
        [self smtpMailView:cellData dataList:aDataList];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    NSString* emailAddress = [cellData objectForKey:@"Email"];
    if (emailAddress != nil && ![emailAddress isEqualToString:@""]) {
        [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:emailAddress, nil]];
    }
    if ([aDataList count] > 0) {
        NSMutableDictionary* presenterProduct = [aDataList objectAtIndex:0];
        [mailComposeViewController setSubject:[presenterProduct objectForKey:@"fullTitle"]]
        ;
        NSNumber* employeeIUR = [presenterProduct objectForKey:@"employeeIUR"];
        int customizedFileType = [PresenterFileTypeConverter retrieveCustomizedFileType:employeeIUR];
        switch (customizedFileType) {
            case 1: {
                [mailComposeViewController setMessageBody:[presenterProduct objectForKey:@"URL"] isHTML:NO];
            }
                break;
            case 2: {
                for (int i = 0; i < [aDataList count]; i++) {
                    NSMutableDictionary* tmpPresenterProduct = [aDataList objectAtIndex:i];
                    NSString* fileName = [tmpPresenterProduct objectForKey:@"Name"];
                    NSData* auxNSData = [self retrieveNSDataWithFileName:fileName];
                    if (auxNSData == nil) {
                        continue;
                    }
                    NSString* mimeTypeString = [self getMimeTypeWithFileName:fileName];
                    [mailComposeViewController addAttachmentData:auxNSData mimeType:mimeTypeString fileName:fileName];
                }
            }
                break;
            default:
                break;
        }
    }
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
    [mailComposeViewController release];
}

- (NSData*)retrieveNSDataWithFileName:(NSString*)aFileName {
    NSData* resultNSData = nil;
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],aFileName];
    if ([FileCommon fileExistAtPath:filePath]) {
        if ([self isFileInRemovedList:aFileName]) {
            return resultNSData;
        }
        resultNSData = [NSData dataWithContentsOfFile:filePath];        
    }
    return resultNSData;
}

- (void)smtpMailView:(NSDictionary*)cellData dataList:(NSMutableArray*)resultList {
    ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//    amwvc.myDelegate = self;
    amwvc.mailDelegate = self;
    NSString* emailAddress = [cellData objectForKey:@"Email"];
    if (emailAddress != nil && ![emailAddress isEqualToString:@""]) {
        amwvc.toRecipients = [NSMutableArray arrayWithObjects:emailAddress, nil];
    }
    NSMutableString* msgBodyString = [NSMutableString stringWithString:@""];
    if ([resultList count] > 0) {
        NSMutableDictionary* presenterProduct = [resultList objectAtIndex:0];
        amwvc.subjectText = [presenterProduct objectForKey:@"fullTitle"];
        msgBodyString = [NSMutableString stringWithString:@"Please find attached:\n"];
        for (int i = 0; i < [resultList count]; i++) {
            NSMutableDictionary* tmpPresenterProduct = [resultList objectAtIndex:i];
            NSNumber* employeeIUR = [tmpPresenterProduct objectForKey:@"employeeIUR"];
            int customizedFileType = [PresenterFileTypeConverter retrieveCustomizedFileType:employeeIUR];
            switch (customizedFileType) {
                case 1: {
                    [msgBodyString appendString:@"\n"];
                    [msgBodyString appendString:[tmpPresenterProduct objectForKey:@"URL"]];                    
                }
                    break;
                case 2: {
                    NSString* fileName = [tmpPresenterProduct objectForKey:@"Name"];
                    NSData* auxNSData = [self retrieveNSDataWithFileName:fileName];
                    if (auxNSData == nil) {
                        continue;
                    }
                    [msgBodyString appendString:@"\n"];
                    [msgBodyString appendString:fileName];
                    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                        [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:auxNSData fileName:fileName]];
                    } else {
                        [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:auxNSData filename:fileName]];
                    }                  
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
    amwvc.bodyText = msgBodyString;
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
//        if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//            [self.emailPopover dismissPopoverAnimated:YES];
//            self.emailPopover = nil;
//            return;
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
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

- (BOOL)isFileInRemovedList:(NSString*)fileName {
    BOOL resultFlag = NO;
    for (int i = 0; i < [self.removedFileList count]; i++) {
        NSMutableDictionary* tmpPresenterProduct = [self.removedFileList objectAtIndex:i];
        NSString* tmpFileName = [tmpPresenterProduct objectForKey:@"Name"];
        if ([tmpFileName isEqualToString:fileName]) {
            resultFlag = YES;
            break;
        }
    }
    return resultFlag;
}

- (void)processPtranRecord:(NSDictionary*)cellData {
    self.recordEndDate = [NSDate date];
    NSTimeInterval duration = [self.recordEndDate timeIntervalSinceDate:self.recordBeginDate];
    NSDictionary* presenterDict = nil;
    if ([self.fileType intValue] == 11) {
        presenterDict = self.currentFile;
    } else {
        if ([self.files count] > 0) {
            presenterDict = [self.files objectAtIndex:0];
        }
    }
    if ((int)duration < [[presenterDict objectForKey:@"minimumSeconds"] intValue]) return;
    NSMutableDictionary* tmpPresenterDict = [self.presenterBaseDataManager createPtranDictWithPresenterIUR:[cellData objectForKey:@"IUR"] duration:[NSNumber numberWithDouble:duration]];
    [self.presenterBaseDataManager loadPtranWithDict:tmpPresenterDict];
    self.recordBeginDate = nil;
}

-(void)createPresenterTransactionToolInstance {
    if (![[ArcosConfigDataManager sharedArcosConfigDataManager] recordPresenterTransactionFlag] || self.presenterRequestSource == PresenterRequestSourceMainMenu) return;
    self.presenterBaseDataManager = [[[PresenterBaseDataManager alloc] init] autorelease];
}

- (int)retrieveStatusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height < [UIApplication sharedApplication].statusBarFrame.size.width ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width;
}

#pragma mark UIPopoverControllerDelegate
/*
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if ([popoverController.contentViewController isKindOfClass:[OrderInputPadViewController class]]) {
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*) popoverController.contentViewController;
        if ([[oipvc.Data objectForKey:@"RRIUR"] intValue] == -1) {
            return NO;
        }
        if (![[ArcosUtils convertNilToEmpty:[oipvc.Data objectForKey:@"BonusDeal"]] isEqualToString:@""]) {
            return NO;
        }
    }    
    return YES;
}*/
#pragma mark UIPopoverPresentationControllerDelegate
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    if ([popoverPresentationController.presentedViewController isKindOfClass:[OrderInputPadViewController class]]) {
        OrderInputPadViewController* oipvc = (OrderInputPadViewController*)popoverPresentationController.presentedViewController;
        if ([[oipvc.Data objectForKey:@"RRIUR"] intValue] == -1) {
            return NO;
        }
        if (![[ArcosUtils convertNilToEmpty:[oipvc.Data objectForKey:@"BonusDeal"]] isEqualToString:@""]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateHiddenPopovers {
//    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
//        [self.emailPopover dismissPopoverAnimated:YES];
//        return NO;
//    }
    return YES;
}

@end
