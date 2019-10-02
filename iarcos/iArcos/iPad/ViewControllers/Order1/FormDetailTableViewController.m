//
//  FormDetailTableViewController.m
//  Arcos
//
//  Created by David Kilmartin on 05/11/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "FormDetailTableViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "MATFormRowsTableViewController.h"
#import "StandardOrderPadMatTableViewController.h"
@interface FormDetailTableViewController ()
- (NSString*)retrieveLocationCode;
- (NSString*)retrieveEmailAddress;
- (NSString*)convertFieldValue:(NSString*)aFieldValue;
- (void)alertViewCallBack;
@end

@implementation FormDetailTableViewController
@synthesize formDetailDataManager = _formDetailDataManager;
@synthesize delegate = _delegate;
@synthesize dividerDelegate = _dividerDelegate;
@synthesize theActionSheet = _theActionSheet;
@synthesize currentIndexPath = _currentIndexPath;
@synthesize formDetailTableView = _formDetailTableView;
@synthesize frdtvc = _frdtvc;
@synthesize theAlertView = _theAlertView;
@synthesize emailButton = _emailButton;
@synthesize standardOrderFormEmailButton = _standardOrderFormEmailButton;
@synthesize isBusy = _isBusy;
@synthesize filePath = _filePath;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize fieldDelimiter = _fieldDelimiter;
@synthesize rowDelimiter = _rowDelimiter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.formDetailDataManager = [[[FormDetailDataManager alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    if (self.formDetailDataManager != nil) { self.formDetailDataManager = nil; }
//    if (self.delegate != nil) { self.delegate = nil; }
//    if (self.dividerDelegate != nil) { self.dividerDelegate = nil; }
    if (self.theActionSheet != nil) { self.theActionSheet = nil; }
    if (self.currentIndexPath != nil) { self.currentIndexPath = nil; }
    if (self.formDetailTableView != nil) { self.formDetailTableView = nil; }
    if (self.frdtvc != nil) { self.frdtvc = nil; }
    self.theAlertView = nil;
    self.emailButton = nil;
    self.standardOrderFormEmailButton = nil;
    self.filePath = nil;
    self.globalNavigationController = nil;
    self.fieldDelimiter = nil;
    self.rowDelimiter = nil;
    
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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"Order Pads";
    self.fieldDelimiter = @",";
    self.rowDelimiter = @"\r\n";
    if (![ArcosUtils systemVersionGreaterThanSeven]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    self.standardOrderFormEmailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(standardOrderFormEmailButtonPressed:)] autorelease];
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
    [self.formDetailDataManager createBasicData];
    self.preferredContentSize = [[GlobalSharedClass shared] orderPadsSize];
//    NSLog(@"formdetail:%@", NSStringFromSelector(_cmd));    
    [self.formDetailTableView reloadData];
    NSDictionary* formDetailDict = [[ArcosCoreData sharedArcosCoreData] formDetailWithFormIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
    NSString* formType = [formDetailDict objectForKey:@"FormType"];
    NSString* details = [formDetailDict objectForKey:@"Details"];
    NSRange aMATRange = [details rangeOfString:@"[MAT]"];
    if ([formType isEqualToString:@"101"]) {
        [self.navigationItem setRightBarButtonItem:self.emailButton];
    } else if (aMATRange.location != NSNotFound) {
        [self.navigationItem setRightBarButtonItem:self.standardOrderFormEmailButton];
    } else {
        [self.navigationItem setRightBarButtonItem:nil];
    }
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
    if (self.formDetailDataManager.displayList != nil) {
        return [self.formDetailDataManager.displayList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    */
    NSString *CellIdentifier = @"IdFormDetailTableCell";
    
    FormDetailTableCell *cell=(FormDetailTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"FormDetailTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[FormDetailTableCell class]] && [[(FormDetailTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (FormDetailTableCell *) nibItem;                
            }
        }
	}
    
    // Configure the cell...
    
    NSDictionary* cellData = [self.formDetailDataManager.displayList objectAtIndex:indexPath.row];
    NSString* details = [cellData objectForKey:@"Details"];
    cell.myTextLabel.text = details;
    NSNumber* imageIur = [cellData objectForKey:@"ImageIUR"];
    UIImage* anImage = nil;
    if ([imageIur intValue] > 0) {
        anImage = [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];        
    }
    if (anImage == nil) {
        anImage = [UIImage imageNamed:[GlobalSharedClass shared].defaultCellImageName];
    }
    cell.myImageView.image = anImage;
    [cell configImageView];
    NSString* formType = [cellData objectForKey:@"FormType"];
    int formTypeNumber = [[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:formType]]] intValue];
    
    /*
    if ([self isKeywordExistedInFormName:details keyword:@"Dynamic"] || [self isKeywordExistedInFormName:details keyword:@"Image"] || [self isKeywordExistedInFormName:details keyword:@"Search"] || [self isKeywordExistedInFormName:details keyword:@"L3Search"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    */
    if (formTypeNumber == 0) {
        NSNumber* formRowRecordQty = [self formRowDividerRecordQty:cellData];
        if ([formRowRecordQty intValue] > 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ([[OrderSharedClass sharedOrderSharedClass].currentFormIUR isEqualToNumber:[cellData objectForKey:@"IUR"]]) {
        cell.myTextLabel.textColor=[UIColor redColor];
    }else{
        cell.myTextLabel.textColor=[UIColor blackColor];
    }
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
    self.currentIndexPath = indexPath;
    NSDictionary* cellData = [self.formDetailDataManager.displayList objectAtIndex:indexPath.row];
    if (![self isFormDetailRowAllowToSelect:cellData]) return;
    [self selectFormDetailRowAction:cellData];
}

- (BOOL)isKeywordExistedInFormName:(NSString*)aFormName keyword:(NSString*)aKeyword {
//    NSString* keyValue = [self.formDetailDataManager.formNameDict objectForKey:aFormName];
//    if (keyValue != nil) {
//        return YES;
//    }
//    return NO;
    return [aFormName hasPrefix:aKeyword];
//    NSRange range = [aFormName rangeOfString:aKeyword];
//    if (range.length > 0) {
//        return YES;
//    }
//    return NO;
}

- (void)didSelectFormRowDividerRow:(NSDictionary*)cellData formIUR:(NSNumber *)aFormIUR {
    [self.dividerDelegate didSelectFormRowDividerRow:cellData formIUR:aFormIUR];
}

- (NSNumber*)formRowDividerRecordQty:(NSDictionary*)aCellData {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"FormIUR=%@ and ProductIUR=0 and SequenceNumber=0", [aCellData objectForKey:@"IUR"]];
    return [[ArcosCoreData sharedArcosCoreData] recordQtyWithEntityName:@"FormRow" predicate:predicate];
}

/*
 actionsheet tag:999 order pad restricted validation 
 */
- (BOOL)isFormDetailRowAllowToSelect:(NSDictionary*)aCellData {
    //If there is an order line, then it must exist a form iur.
    if ([[OrderSharedClass sharedOrderSharedClass]anyOrderLine]) {
        NSNumber* aFormDetailIUR = [aCellData objectForKey:@"IUR"];
        //select the same order pad
        if ([aFormDetailIUR isEqualToNumber:[OrderSharedClass sharedOrderSharedClass].currentFormIUR]) {
            return YES;
        }
        NSDictionary* currentFormDetailRecordDict = [self.formDetailDataManager formDetailRecordDictWithIUR:[OrderSharedClass sharedOrderSharedClass].currentFormIUR];
        NSString* currentPrintDeliveryDocket = [currentFormDetailRecordDict objectForKey:@"PrintDeliveryDocket"];
        if ([currentPrintDeliveryDocket isEqualToString:@"1"]) {
            /*
            self.theActionSheet = [[UIActionSheet alloc] initWithTitle:@"The current order pad is restricted!\n Do you want to delete the current order?"
                                                              delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                     otherButtonTitles:@"Cancel",nil];
            self.theActionSheet.tag = 999;
            self.theActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [self.theActionSheet showInView:[ArcosUtils getRootView].view];
            */
            self.theAlertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"The current order pad is restricted!\n Do you want to delete the current order?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
            self.theAlertView.tag = 999;
            [self.theAlertView show];
            return NO;
        }
        NSString* aPrintDeliveryDocket = [aCellData objectForKey:@"PrintDeliveryDocket"];
        if ([aPrintDeliveryDocket isEqualToString:@"1"]) {
            /*
            self.theActionSheet = [[UIActionSheet alloc] initWithTitle:@"The order pad which you want to select is restricted!\n Do you want to delete the current order?"
                                                              delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"OK"
                                                     otherButtonTitles:@"Cancel",nil];
            self.theActionSheet.tag = 999;
            self.theActionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
            [self.theActionSheet showInView:[ArcosUtils getRootView].view];
            */
            self.theAlertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"The order pad which you want to select is restricted!\n Do you want to delete the current order?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
            self.theAlertView.tag = 999;
            [self.theAlertView show];
            return NO;
        }
    }
    return YES;
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 77) {
        [self alertViewCallBack];
    }
    if (alertView.tag == 999) {
        switch (buttonIndex) {
            case 0: {//Cancel button
                
            }
                break;
            case 1: {//Ok button
                
                [[OrderSharedClass sharedOrderSharedClass] clearCurrentOrder];
                [FileCommon removeFileAtPath:[FileCommon orderRestorePlistPath]];
                [self.delegate removeSubviewInOrderPadTemplate];
                //reinitiate presenter with restricted form
                @try {
//                    UITabBarController* tabbar=(UITabBarController*) [ArcosUtils getRootView];
//                    UINavigationController* presenterNavigationController = (UINavigationController*)[tabbar.viewControllers objectAtIndex:2];
//                    
//                    if ([presenterNavigationController.viewControllers count] > 2) {
//                        [presenterNavigationController popToRootViewControllerAnimated:NO];
//                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"abc %@", [exception reason]);
                }
                
                NSDictionary* cellData = [self.formDetailDataManager.displayList objectAtIndex:self.currentIndexPath.row];
                [self selectFormDetailRowAction:cellData];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)selectFormDetailRowAction:(NSDictionary*)aCellData {
//    NSNumber* formDetailIUR = [aCellData objectForKey:@"IUR"];
//    NSString* printDeliveryDocket = [aCellData objectForKey:@"PrintDeliveryDocket"];
//    NSLog(@"RowAtIndexPath:%@ %@", formDetailIUR, printDeliveryDocket);
    
    NSString* formType = [aCellData objectForKey:@"FormType"];
    int formTypeNumber = [[ArcosUtils convertStringToNumber:[ArcosUtils convertBlankToZero:[ArcosUtils convertNilToEmpty:formType]]] intValue];

    if (formTypeNumber == 0) {
//        if (![formDetailIUR isEqualToNumber:[[OrderSharedClass sharedOrderSharedClass] currentFormIUR]]) {
//            [OrderSharedClass sharedOrderSharedClass].currentSelectionIUR = nil;
//        }        
        NSNumber* formRowRecordQty = [self formRowDividerRecordQty:aCellData];
        if ([formRowRecordQty intValue] > 0) {
            self.frdtvc = [[[FormRowDividerTableViewController alloc] initWithNibName:@"FormRowDividerTableViewController" bundle:nil] autorelease];
            self.frdtvc.delegate = self;
            self.frdtvc.formIUR = [aCellData objectForKey:@"IUR"];
            self.frdtvc.formName = [aCellData objectForKey:@"Details"];
            [self.navigationController pushViewController:self.frdtvc animated:YES];
        } else {
            [self.delegate didSelectFormDetailRow:aCellData];
        }
    } else {
//        [OrderSharedClass sharedOrderSharedClass].currentFormIUR = [aCellData objectForKey:@"IUR"];
        [self.delegate didSelectFormDetailRow:aCellData];
    }
}

- (void)processFirstHalfMatContent:(NSMutableString*)aMatContent {
    NSString* locationCode = [self retrieveLocationCode];
    NSString* emailAddress = [self retrieveEmailAddress];
    [aMatContent appendString:[NSString stringWithFormat:@"Account Code %@,,,", locationCode]];
    [aMatContent appendString:[NSString stringWithFormat:@"Email: %@,,,,,,,,,,,,,,,,", emailAddress]];
    [aMatContent appendString:self.rowDelimiter];
    [aMatContent appendString:@"ProductCode,OrderPadDetails,Description,ProductSize,"];
}

- (void)emailButtonPressed:(id)sender {    
    if (self.isBusy) return;
    self.isBusy = YES;
    MATFormRowsTableViewController* matfrtvc = (MATFormRowsTableViewController*)[self.delegate retrieveCurrentViewController];
    if (![matfrtvc isKindOfClass:[MATFormRowsTableViewController class]] || matfrtvc.matFormRowsDataManager.fieldNames == nil) {
        self.isBusy = NO;
        return;
    }
    NSMutableString* matContent = [NSMutableString string];
//    NSString* fieldDelimiter = @",";
//    NSString* rowDelimiter = @"\r\n";
    [self processFirstHalfMatContent:matContent];
//    NSString* locationCode = [self retrieveLocationCode];
//    NSString* emailAddress = [self retrieveEmailAddress];
//    [matContent appendString:[NSString stringWithFormat:@"Account Code %@,,,", locationCode]];
//    [matContent appendString:[NSString stringWithFormat:@"Email: %@,,,,,,,,,,,,,,,,", emailAddress]];
//    [matContent appendString:rowDelimiter];
//    [matContent appendString:@"ProductCode,OrderPadDetails,Description,ProductSize,"];
    @try {
        for (int i = 3; i<= 15; i++) {
            NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
            SEL selector = NSSelectorFromString(fieldMethodName);
            NSString* fieldName = [matfrtvc.matFormRowsDataManager.fieldNames performSelector:selector];
            [matContent appendString:[fieldName substringToIndex:3]];
            [matContent appendString:self.fieldDelimiter];
        }
    }
    @catch (NSException *exception) {
        
    }
    [matContent appendString:@"Total,order1,order2"];
    [matContent appendString:self.rowDelimiter];
    for (int i = 0; i < [matfrtvc.matFormRowsDataManager.displayList count]; i++) {
        ArcosGenericClass* cellData = [matfrtvc.matFormRowsDataManager.displayList objectAtIndex:i];
        NSString* orderPadDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData Field20]]];
        NSString* productCode = @"";
        NSString* productSize = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
        NSString* labelDetails = [ArcosUtils convertNilToEmpty:[cellData Field2]];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
            productCode = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
        }
//        if (![orderPadDetails isEqualToString:@""]) {
//            productCode = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field19]]];
//            productSize = [ArcosUtils convertNilToEmpty:[ArcosUtils trim:[cellData Field21]]];
//        }
        [matContent appendString:productCode];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:orderPadDetails];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:labelDetails];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:productSize];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field3]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field4]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field5]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field6]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field7]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field8]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field9]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field10]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field11]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field12]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field13]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field14]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field15]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:[self convertFieldValue:[cellData Field16]]];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:self.rowDelimiter];
    }
    
    [self processSecondHalfMatContent:matContent];
    /*
    NSString* fileName = @"Stocksheet.csv";
    self.filePath = [NSString stringWithFormat:@"%@/%@",[FileCommon documentsPath], fileName];
    [matContent writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.subjectText = fileName;
        if ([FileCommon fileExistAtPath:self.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];
            if (data != nil) {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
            }                        
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        [self presentViewController:self.globalNavigationController animated:YES completion:^{
            self.isBusy = NO;
        }];
        [amwvc release];        
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    MFMailComposeViewController* mfMailComposeViewController =[[MFMailComposeViewController alloc] init];
    mfMailComposeViewController.mailComposeDelegate = self;
    @try {
        if ([FileCommon fileExistAtPath:self.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];
            if (data != nil) {
                [mfMailComposeViewController addAttachmentData:data mimeType:@"application/csv" fileName:fileName];
            }            
        } else {
            [ArcosUtils showMsg:[NSString stringWithFormat:@"%@ does not exist.",fileName] delegate:nil];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    [mfMailComposeViewController setSubject:fileName];
    [self presentViewController:mfMailComposeViewController animated:YES completion:nil];
    [mfMailComposeViewController release];
    self.isBusy = NO;
    */
}

- (void)processSecondHalfMatContent:(NSMutableString*)aMatContent {
    NSString* fileName = @"Stocksheet.csv";
    self.filePath = [NSString stringWithFormat:@"%@/%@",[FileCommon documentsPath], fileName];
    [aMatContent writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        amwvc.mailDelegate = self;
        amwvc.subjectText = fileName;
        if ([FileCommon fileExistAtPath:self.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];
            if (data != nil) {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:data filename:fileName]];
            }                        
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        self.globalNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.globalNavigationController animated:YES completion:^{
            self.isBusy = NO;
        }];
        [amwvc release];        
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    MFMailComposeViewController* mfMailComposeViewController =[[MFMailComposeViewController alloc] init];
    mfMailComposeViewController.mailComposeDelegate = self;
    @try {
        if ([FileCommon fileExistAtPath:self.filePath]) {
            NSData* data = [NSData dataWithContentsOfFile:self.filePath];
            if (data != nil) {
                [mfMailComposeViewController addAttachmentData:data mimeType:@"application/csv" fileName:fileName];
            }            
        } else {
            [ArcosUtils showMsg:[NSString stringWithFormat:@"%@ does not exist.",fileName] delegate:nil];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
    [mfMailComposeViewController setSubject:fileName];
    [self presentViewController:mfMailComposeViewController animated:YES completion:nil];
    [mfMailComposeViewController release];
    self.isBusy = NO;
}

- (void)standardOrderFormEmailButtonPressed:(id)sender {
//    NSLog(@"standardOrderFormEmailButtonPressed");
    if (self.isBusy) return;
    self.isBusy = YES;
    StandardOrderPadMatTableViewController* sopmattvc = (StandardOrderPadMatTableViewController*)[self.delegate retrieveCurrentViewController];
//    NSLog(@"sopmattvc %@", sopmattvc);
    if (![sopmattvc isKindOfClass:[StandardOrderPadMatTableViewController class]] || [sopmattvc.formRowsTableViewController.unsortedFormrows count] <= 0) {
        self.isBusy = NO;
        return;
    }
    NSMutableString* matContent = [NSMutableString string];
    [self processFirstHalfMatContent:matContent];
    @try {
        if (sopmattvc.mATFormRowsTableViewController.matFormRowsDataManager.fieldNames != nil) {
            for (int i = 3; i<= 15; i++) {
                NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
                SEL selector = NSSelectorFromString(fieldMethodName);
                NSString* fieldName = [sopmattvc.mATFormRowsTableViewController.matFormRowsDataManager.fieldNames performSelector:selector];
                [matContent appendString:[fieldName substringToIndex:3]];
                [matContent appendString:self.fieldDelimiter];
            }
            
        } else {
            for (int i = 3; i<= 15; i++) {                
                [matContent appendString:@""];
                [matContent appendString:self.fieldDelimiter];
            }
        }
        [matContent appendString:@"Total,order1,order2"];
        [matContent appendString:self.rowDelimiter];
    }
    @catch (NSException *exception) {
        
    }
    for (int i = 0; i < [sopmattvc.formRowsTableViewController.unsortedFormrows count]; i++) {
        NSMutableDictionary* cellData = [sopmattvc.formRowsTableViewController.unsortedFormrows objectAtIndex:i];        
        NSString* orderPadDetails = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[cellData objectForKey:@"OrderPadDetails"]]];
        NSString* productCode = @"";
        NSString* productSize = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"ProductSize"]];
        NSString* labelDetails = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"Details"]];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] showProductCodeFlag]) {
            productCode = [ArcosUtils convertNilToEmpty:[cellData objectForKey:@"ProductCode"]];
        }
        [matContent appendString:productCode];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:orderPadDetails];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:labelDetails];
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:productSize];
        [matContent appendString:self.fieldDelimiter];
        ArcosGenericClass* arcosGenericClass = [sopmattvc.standardOrderPadMatDataManager.matDictHashtable objectForKey:[cellData objectForKey:@"ProductIUR"]];
        for (int i = 3; i <= 16; i++) {
            NSString* fieldMethodName = [NSString stringWithFormat:@"Field%d", i];
            SEL selector = NSSelectorFromString(fieldMethodName);
            NSString* fieldValue = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:(NSString*)[arcosGenericClass performSelector:selector]]];
            [matContent appendString:[self convertFieldValue:fieldValue]];
            [matContent appendString:self.fieldDelimiter];            
        }
        [matContent appendString:self.fieldDelimiter];
        [matContent appendString:self.rowDelimiter];
    }
    
    [self processSecondHalfMatContent:matContent];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
    [self dismissViewControllerAnimated:YES completion:^{
        self.globalNavigationController = nil;
        [FileCommon removeFileAtPath:self.filePath];
    }];
}

- (NSString*)convertFieldValue:(NSString*)aFieldValue {
    NSString* finalFieldValue = @"";
    if (![@"" isEqualToString:aFieldValue]) {
        NSNumber* tmpFieldValueNumber = [ArcosUtils convertStringToFloatNumber:aFieldValue];
        finalFieldValue = [ArcosUtils convertZeroToBlank:[NSString stringWithFormat:@"%d", (int)roundf([tmpFieldValueNumber floatValue])]];
    }
    return finalFieldValue;
}

#pragma mark - MFMailComposeViewControllerDelegate
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
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:77 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertViewCallBack {
    [self dismissViewControllerAnimated:YES completion:^ {
        [FileCommon removeFileAtPath:self.filePath];
    }];
}

- (NSString*)retrieveLocationCode {
    NSString* locationCode = @"";
    NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[GlobalSharedClass shared].currentSelectedLocationIUR];
    if (locationList != nil && [locationList count] > 0) {
        NSDictionary* locationDict = [locationList objectAtIndex:0];
        locationCode = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"LocationCode"]]];
    }
    return locationCode;
}

- (NSString*)retrieveEmailAddress {
    NSString* emailAddress = @"";
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithDescrTypeCode:@"SD" descrDetailCode:@"MAIL"];
    if ([objectList count] > 0) {
        NSDictionary* descrDetailDict = [objectList objectAtIndex:0];
        emailAddress = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[descrDetailDict objectForKey:@"Detail"]]];
    }

    return emailAddress;
}

@end
