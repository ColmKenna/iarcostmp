//
//  NewPresenterViewController.m
//  Arcos
//
//  Created by David Kilmartin on 15/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "NewPresenterViewController.h"
#include <QuartzCore/QuartzCore.h> 
#import "PresenterMoviePlayerController.h"
#import "PresenterPDFViewController.h"
#import "PresenterFactViewController.h"
#import "PresenterImageGridViewController.h"
#import "PresenterBookletViewController.h"
#import "ArcosCoreData.h"
#import "GlobalSharedClass.h"
#import "OrderSharedClass.h"
#import "PresenterSlideViewController.h"
#import "ArcosAppDelegate_iPad.h"
#import "PresenterURLViewController.h"
#import "PresenterCombinedSlideViewController.h"
#import "PresenterEbookViewController.h"
#import "ArcosRootViewController.h"
#import "PresenterBridgeGridViewController.h"

@implementation NewPresenterViewController
@synthesize parentPresenterRequestSource = _parentPresenterRequestSource;
//@synthesize navbar;
@synthesize myTableView;
@synthesize currentSelectedCellIndexPath;
@synthesize presenterProducts;
@synthesize typeButton = _typeButton;
@synthesize emailButton = _emailButton;
@synthesize emailRecipientTableViewController = _emailRecipientTableViewController;
@synthesize emailPopover = _emailPopover;
//@synthesize factory = _factory;
//@synthesize thePopover = _thePopover;
@synthesize currentTypeTitle = _currentTypeTitle;
@synthesize currentDescrDetailIUR = _currentDescrDetailIUR;
@synthesize dataList = _dataList;
@synthesize navigationBarTitle = _navigationBarTitle;
@synthesize myNewPresenterDataManager = _myNewPresenterDataManager;
@synthesize isNotFirstLoaded = _isNotFirstLoaded;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.parentPresenterRequestSource = PresenterRequestSourceSubMenu;
    }
    return self;
}

- (void)dealloc
{
    self.myTableView = nil;
//    [testingData release];
    self.currentSelectedCellIndexPath = nil;
    self.presenterProducts = nil;    
    self.typeButton = nil;
    self.emailButton = nil;
//    self.factory = nil;
//    if (self.thePopover != nil) { self.thePopover = nil; }
    self.currentTypeTitle = nil;
    self.currentDescrDetailIUR = nil;
    self.dataList = nil;
    self.navigationBarTitle = nil;
    self.myNewPresenterDataManager = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    
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
    
    //set the navigation bar preproties
    //self.navbar.topItem.title=@"Presenter";
//    self.navbar.tintColor=[UIColor brownColor];
//    [[ArcosAuxiliaryDataProcessor sharedArcosAuxiliaryDataProcessor] runTransaction];
    //set the tableview properties
    self.myNewPresenterDataManager = [[[NewPresenterDataManager alloc] init] autorelease];
    self.currentTypeTitle = @"All";
//    self.currentDescrDetailIUR = [NSNumber numberWithInt:0];
    self.myTableView.backgroundColor=[UIColor colorWithRed:239/256.0f green:235/256.0f blue:229/256.0f alpha:1.0f];
    self.myTableView.sectionHeaderHeight = 5;
    self.myTableView.sectionFooterHeight = 5;
    
    
    //create a presenter folder
    [FileCommon createFolder:@"presenter"];
//    [self cleanInactivePresenterSandbox];
    [self cleanInactiveFilesInPresenterSandbox];
    self.rootView = (ArcosRootViewController*)[ArcosUtils getRootView];
    //testing
    
}

- (void)emailButtonPressed:(id)sender {
    if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
        [self.emailPopover dismissPopoverAnimated:YES];
        self.emailPopover = nil;
        return;
    }
    self.emailRecipientTableViewController = [[[EmailRecipientTableViewController alloc] initWithNibName:@"EmailRecipientTableViewController" bundle:nil] autorelease];
    self.emailRecipientTableViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    self.emailRecipientTableViewController.requestSource = EmailRequestSourcePresenter;
    self.emailRecipientTableViewController.recipientDelegate = self;
    UINavigationController* emailNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.emailRecipientTableViewController] autorelease];
    self.emailPopover = [[[UIPopoverController alloc]initWithContentViewController:emailNavigationController] autorelease];
    self.emailPopover.delegate = self;
    self.emailPopover.popoverContentSize = [[GlobalSharedClass shared] orderPadsSize];
    
    [self.emailPopover presentPopoverFromBarButtonItem:self.emailButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (self.isNotFirstLoaded) return;
//    if ([self.presenterProducts count] == 1) {
//        [self.myTableView.delegate tableView:self.myTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    }
//    self.isNotFirstLoaded = YES;
}

- (void)typeButtonPressed:(id)sender {
    
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.thePopover = nil;
//    self.factory.popoverController = nil;
    self.emailPopover = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:1];
    self.emailButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailButtonPressed:)] autorelease];
    
    [rightButtonList addObject:self.emailButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];
    //fill the presenter products    
    self.presenterProducts=[[ArcosCoreData sharedArcosCoreData]presenterParentProducts:self.currentDescrDetailIUR];
    
    //refresh the table
    [self.myTableView reloadData];
}

- (void)outlookButtonPressed:(id)sender {
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.currentSelectedCellIndexPath!=nil) {
        UIImage* anImage=[UIImage imageNamed:@"presenterTableCell_stretchable.png"];
        PresenterTableViewCell* cell=(PresenterTableViewCell*)[self.myTableView cellForRowAtIndexPath:self.currentSelectedCellIndexPath];
        cell.bgImageView.image=[anImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.navigationController.view setNeedsLayout];
}

#pragma mark table view delegate
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    return  [self.presenterProducts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { 
    return 108;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor whiteColor];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"PresenterTableViewCell";
//    
//    UITableViewCell *cell =(UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
    NSString *CellIdentifier = @"PresenterTableViewCell";
    
    PresenterTableViewCell *cell=(PresenterTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCells" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            //swith between editable and none editable order product cell
            if ([nibItem isKindOfClass:[PresenterTableViewCell class]] && [[(PresenterTableViewCell *)nibItem reuseIdentifier] isEqualToString: @"PresenterTableViewCell"]) {
                cell= (PresenterTableViewCell *) nibItem;
                break;
            }    
            
        }
        
	}
    
    //fill the data for cell
    NSMutableDictionary* aPresentProduct=[self.presenterProducts objectAtIndex:indexPath.row];
    UIImage* bgImage=[UIImage imageNamed:@"presenterTableCell_stretchable.png"];
    cell.bgImageView.image=[bgImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    
    //NSLog(@"presenter title is %@  name is %@",[aPresentProduct objectForKey:@"Title"],[aPresentProduct objectForKey:@"Name"]);
    cell.title.text=[aPresentProduct objectForKey:@"fullTitle"];
    cell.description.textContainerInset = UIEdgeInsetsZero;
    cell.description.text=[aPresentProduct objectForKey:@"memoDetails"];
    cell.extraDesc.text=[aPresentProduct objectForKey:@"Name"];
    
    NSNumber* imageIur=[aPresentProduct objectForKey:@"ImageIUR"];
    UIImage* anImage=nil;
    if ([imageIur intValue]>0) {
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:imageIur];
    }else{
        anImage= [[ArcosCoreData sharedArcosCoreData]thumbWithIUR:[NSNumber numberWithInt:1]];
    }
    if (anImage==nil) {
        anImage=[UIImage imageNamed:@"iArcos_72.png"];
    }
//    cell.mainImage.image=anImage;
    [cell.mainButton setImage:anImage forState:UIControlStateNormal];
    
    NSNumber* onPromotion = [aPresentProduct objectForKey:@"OnPromotion"];
    if ([onPromotion boolValue]) {
        cell.promotionView.image = [UIImage imageNamed:@"label_sale_red.png"];
    } else {
        cell.promotionView.image = nil;
    }
    
    return cell;
}

#pragma mark - Table view delegate
// the type of presenter files, EmployeeIUR in Presenter table is used to hold those type id
//  1 BRCH  Brochure
//  2 PDF  PDF file
//  3 PPT  PPT file
//  4 SOUN  Sound only
//  5 IMG  Still image
//  6 VID  Video
//  7 GRID  5*4 images 
//  8 SLID  Sliding images
//  9 WEB  web link
//  10 FACT  2 sided fact sheet
//  11 TXT  Simple text file
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    NSLog(@"selected cell at index %d",indexPath.row);
    self.currentSelectedCellIndexPath=indexPath;
    //cell select color
    UIImage* anImage=[UIImage imageNamed:@"tableview_strech_highlight.png"];
    PresenterTableViewCell* cell=(PresenterTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.bgImageView.image=[anImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    
    NSMutableDictionary* aPresentProduct=[self.presenterProducts objectAtIndex:indexPath.row];

    NSMutableDictionary* myResultDict = [self retrievePresenterViewControllerResult:aPresentProduct];
    PresenterViewController* PVC = [myResultDict objectForKey:@"MyPresenterViewController"];
    if (PVC==nil) {
        UIImage* anImage=[UIImage imageNamed:@"presenterTableCell_stretchable.png"];
        PresenterTableViewCell* cell=(PresenterTableViewCell*)[self.myTableView cellForRowAtIndexPath:self.currentSelectedCellIndexPath];
        cell.bgImageView.image=[anImage stretchableImageWithLeftCapWidth:30 topCapHeight:0];
        return;
    }else{
//        PVC.files=presenterChildren;
//        PVC.fileType = fileType;
//        PVC.files = [myResultDict objectForKey:@"Data"];
//        PVC.fileType = [myResultDict objectForKey:@"FileType"];
//        PVC.presenterRequestSource = self.parentPresenterRequestSource;
        [self.navigationController pushViewController:PVC animated:YES];
//        [PVC release];
    }
    
}

/*
- (void)cleanInactivePresenterSandbox {    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"parentIUR = 0 and Active = 0"];
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"displaySequence",nil];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil withPredicate:predicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    if ([objectsArray count] > 0) {
        NSMutableArray* parentIurList = [NSMutableArray array];
        NSMutableArray* fileNameList = [NSMutableArray array];
        for (NSDictionary* anObject in objectsArray) {
            [parentIurList addObject:[anObject objectForKey:@"IUR"]];
            NSString* fileName = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[anObject objectForKey:@"Name"]]];
            if (![fileName isEqualToString:@""]) {
                [fileNameList addObject:fileName];
            }
        }
        NSPredicate* innerPredicate = [NSPredicate predicateWithFormat:@"parentIUR in %@", parentIurList];
        NSMutableArray* innerObjectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil withPredicate:innerPredicate withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
        if ([innerObjectsArray count] > 0) {
            for (NSDictionary* anInnerObject in innerObjectsArray) {
                NSString* innerFileName = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[anInnerObject objectForKey:@"Name"]]];
                if (![innerFileName isEqualToString:@""]) {
                    [fileNameList addObject:innerFileName];
                }
            }
        }
        for (int i = 0; i < [fileNameList count]; i++) {
            NSString* tmpFileName = [fileNameList objectAtIndex:i];
            NSString* filePath = [self getFilePathWithFileName:tmpFileName];
            [FileCommon removeFileAtPath:filePath];
        }
    }    
}
*/

- (void)cleanInactiveFilesInPresenterSandbox {
    NSArray* sortDescNames = [NSArray arrayWithObjects:@"displaySequence",nil];
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] fetchRecordsWithEntity:@"Presenter" withPropertiesToFetch:nil withPredicate:nil withSortDescNames:sortDescNames withResulType:NSDictionaryResultType needDistinct:NO ascending:[NSNumber numberWithBool:NO]];
    
    NSString* presenterFilePath = [FileCommon presenterPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    NSArray* fileNameList = [fileManager contentsOfDirectoryAtPath:presenterFilePath error:&error];
    NSMutableDictionary* fileHashTable = [NSMutableDictionary dictionaryWithCapacity:[fileNameList count]];
//    NSLog(@"ax %@", fileNameList);
    NSMutableDictionary* exceptionFileNameHashTable = [NSMutableDictionary dictionary];
    [exceptionFileNameHashTable setObject:[NSNumber numberWithBool:YES] forKey:@".DS_Store"];
    for (int i = 0; i < [fileNameList count]; i++) {
        NSString* auxFileName = [fileNameList objectAtIndex:i];
        if (auxFileName == nil || [[ArcosUtils trim:auxFileName] isEqualToString:@""]) continue;
        [fileHashTable setObject:[NSNumber numberWithBool:NO] forKey:auxFileName];
    }
    for (int i = 0; i < [objectsArray count]; i++) {
        NSDictionary* auxPresenterDict = [objectsArray objectAtIndex:i];
        NSString* auxPresenterName = [auxPresenterDict objectForKey:@"Name"];
        NSNumber* auxActive = [auxPresenterDict objectForKey:@"Active"];
        if (auxPresenterName == nil || [[ArcosUtils trim:auxPresenterName] isEqualToString:@""]) continue;
        if (![auxActive boolValue]) continue;
        [fileHashTable setObject:[NSNumber numberWithBool:YES] forKey:auxPresenterName];
    }
    NSArray* auxKeyList = [fileHashTable allKeys];
    for (int i = 0; i < [auxKeyList count]; i++) {
        NSString* auxKey = [auxKeyList objectAtIndex:i];        
        if ([exceptionFileNameHashTable objectForKey:auxKey] != nil) continue;
        NSNumber* auxActive = [fileHashTable objectForKey:auxKey];
        if (![auxActive boolValue]) {
            NSString* filePath = [self getFilePathWithFileName:auxKey];
            [FileCommon removeFileAtPath:filePath];
//            NSLog(@"%@ removed", auxKey);
        }
    }
}

- (NSString*)getFilePathWithFileName:(NSString*)aFileName {
    return [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],aFileName];
}


- (void)emailPressedFromTablePopoverRow:(NSDictionary*)cellData groupName:(NSString *)aGroupName {    
    self.myNewPresenterDataManager.auxEmailCellData = cellData;
    self.myNewPresenterDataManager.groupName = aGroupName;
    self.myNewPresenterDataManager.rowPointer = 0;
    self.myNewPresenterDataManager.removedFileList = [NSMutableArray array];
    self.myNewPresenterDataManager.resultFileList = [self.myNewPresenterDataManager getGroupPresenterItems:self.presenterProducts];
    [self.myNewPresenterDataManager getOverSizeFileListFromDataList:self.myNewPresenterDataManager.resultFileList];
    if ([self.myNewPresenterDataManager.candidateRemovedFileList count] > 0) {
        [self checkFileSizeWithIndex:self.myNewPresenterDataManager.rowPointer];
    } else {
        [self processSelectEmailRecipientRow:self.myNewPresenterDataManager.auxEmailCellData dataList:self.myNewPresenterDataManager.resultFileList groupName:self.myNewPresenterDataManager.groupName];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString* message = nil;
    switch (result) {
        case MFMailComposeResultSent: {
            message = @"Sent Email OK";
//            [ArcosUtils showMsg:message title:@"App Email" delegate:nil];
        }
            break;
            
        case MFMailComposeResultFailed: {
            message = [error localizedDescription];
            [ArcosUtils showMsg:message title:@"Error !" delegate:nil];
        }
            break;
            
        default:
            break;
    }
    [self.emailPopover.contentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)processSelectEmailRecipientRow:(NSDictionary*)cellData dataList:(NSMutableArray*)resultList groupName:(NSString*)aGroupName {
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag]) {        
        [self smtpMailView:cellData dataList:resultList groupName:aGroupName];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus]) return;
    MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    NSString* emailAddress = [cellData objectForKey:@"Email"];
    if (emailAddress != nil && ![emailAddress isEqualToString:@""]) {
        [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:emailAddress, nil]];
    }
    
    
    
    NSMutableString* msgBodyString = [NSMutableString string];
    for (int i = 0; i < [resultList count]; i++) {
        NSMutableDictionary* tmpPresenterProduct = [resultList objectAtIndex:i];
        NSNumber* employeeIUR = [tmpPresenterProduct objectForKey:@"employeeIUR"];
        int customizedFileType = [PresenterFileTypeConverter retrieveCustomizedFileType:employeeIUR];
        switch (customizedFileType) {
            case 1: {
                [msgBodyString appendString:[tmpPresenterProduct objectForKey:@"URL"]];
                [msgBodyString appendString:@"\n"];
            }
                break;
            case 2: {
                NSString* fileName = [tmpPresenterProduct objectForKey:@"Name"];
                NSData* auxNSData = [self retrieveNSDataWithFileName:fileName];
                if (auxNSData == nil) {
                    continue;
                }
                NSString* mimeTypeString = [self.myNewPresenterDataManager getMimeTypeWithFileName:fileName];
                [mailComposeViewController addAttachmentData:auxNSData mimeType:mimeTypeString fileName:fileName];
            }
                break;
            default:
                break;
        }
    }
    [mailComposeViewController setMessageBody:msgBodyString isHTML:NO];
    [mailComposeViewController setSubject:[NSString stringWithFormat:@"Presenter for %@",aGroupName]];
    [self.emailPopover.contentViewController presentViewController:mailComposeViewController animated:YES completion:nil];
    [mailComposeViewController release];
//    [self dismissPopoverController];
}

- (NSData*)retrieveNSDataWithFileName:(NSString*)aFileName {
    NSData* resultNSData = nil;
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath],aFileName];
    if ([FileCommon fileExistAtPath:filePath]) {
        if ([self.myNewPresenterDataManager isFileInRemovedList:aFileName]) {
            return resultNSData;
        }
        resultNSData = [NSData dataWithContentsOfFile:filePath];        
    }
    return resultNSData;
}

- (void)smtpMailView:(NSDictionary*)cellData dataList:(NSMutableArray*)resultList groupName:(NSString*)aGroupName {
    ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//    amwvc.myDelegate = self;
    amwvc.mailDelegate = self;
    NSString* emailAddress = [cellData objectForKey:@"Email"];
    if (emailAddress != nil && ![emailAddress isEqualToString:@""]) {
        amwvc.toRecipients = [NSMutableArray arrayWithObjects:emailAddress, nil];
    }
    amwvc.subjectText = [NSString stringWithFormat:@"Presenter for %@",aGroupName];
    NSMutableString* msgBodyString = [NSMutableString stringWithString:@""];
    amwvc.attachmentList = [NSMutableArray array];
    if ([resultList count] > 0) {
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
        if (self.emailPopover != nil && [self.emailPopover isPopoverVisible]) {
            [self.emailPopover dismissPopoverAnimated:YES];
            self.emailPopover = nil;
            return;
        }
    }];
}

- (void)checkFileSizeWithIndex:(int)aRowPointer {
    NSMutableDictionary* tmpPresenterProduct = [self.myNewPresenterDataManager.candidateRemovedFileList objectAtIndex:aRowPointer];
    NSString* message = [NSString stringWithFormat:@"Are you sure to attach %@ which is %@?", [tmpPresenterProduct objectForKey:@"Name"], [tmpPresenterProduct objectForKey:@"fileSize"]];
    UIAlertView* v = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    v.tag = 36;
    [v show];
    [v release];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 36) return;
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.myNewPresenterDataManager.removedFileList addObject:[self.myNewPresenterDataManager.candidateRemovedFileList objectAtIndex:self.myNewPresenterDataManager.rowPointer]];
    }
    self.myNewPresenterDataManager.rowPointer++;
    if (self.myNewPresenterDataManager.rowPointer != [self.myNewPresenterDataManager.candidateRemovedFileList count]) {
        [self checkFileSizeWithIndex:self.myNewPresenterDataManager.rowPointer];
    } else {
        [self processSelectEmailRecipientRow:self.myNewPresenterDataManager.auxEmailCellData dataList:self.myNewPresenterDataManager.resultFileList groupName:self.myNewPresenterDataManager.groupName];
    }
}

#pragma mark EmailRecipientDelegate
- (void)didSelectEmailRecipientRow:(NSDictionary *)cellData {
    [self emailPressedFromTablePopoverRow:cellData groupName:[cellData objectForKey:@"Title"]];
}

/*
 * Data FileType MyPresenterViewController
 */
- (NSMutableDictionary*)retrievePresenterViewControllerResult:(NSMutableDictionary*)aPresenterDict {
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:3];
    NSNumber* presenterIUR=[aPresenterDict objectForKey:@"IUR"];
    NSMutableArray* presenterChildren=[[ArcosCoreData sharedArcosCoreData]presenterChildrenWithParentIUR:presenterIUR];
    //    NSLog(@"presenterChildren%@, %@", presenterIUR, presenterChildren);
    NSNumber* fileType=[aPresenterDict objectForKey:@"employeeIUR"];//now employee IUR uses to store the file types
    if ([fileType intValue] != 11 && [fileType intValue] != 13) {
        [presenterChildren insertObject:aPresenterDict atIndex:0];
    }
    [resultDict setObject:presenterChildren forKey:@"Data"];
    [resultDict setObject:fileType forKey:@"FileType"];
    
    //check the type of view we need
    PresenterViewController* PVC = nil;
    switch ([fileType intValue]) {
        case 1:{//brochure
            PVC = [[[PresenterBookletViewController alloc]initWithNibName:@"PresenterBookletViewController" bundle:nil] autorelease];
            
            break;
        }
        case 2:{//pdf file format
            PVC = [[[PresenterPDFViewController alloc]initWithNibName:@"PresenterPDFViewController" bundle:nil] autorelease];
            break;
        }
        case 6:{//video
            PVC = [[[PresenterMoviePlayerController alloc]initWithNibName:@"PresenterMoviePlayerController" bundle:nil] autorelease];
            break;
        }
        case 7:{//5*4 grid
            PVC = [[[PresenterImageGridViewController alloc]initWithNibName:@"PresenterImageGridViewController" bundle:nil] autorelease];
            break;
        }
        case 8:{//slider
            PVC = [[[PresenterSlideViewController alloc]initWithNibName:@"PresenterSlideViewController" bundle:nil] autorelease];
            break;
        }
        case 9:{//url
            PVC = [[[PresenterURLViewController alloc]initWithNibName:@"PresenterURLViewController" bundle:nil] autorelease];
            break;
        }
        case 10:{//fact sheet
            PVC = [[[PresenterFactViewController alloc]initWithNibName:@"PresenterFactViewController" bundle:nil] autorelease];
            break;
        }
        case 11: {//conbined
            PVC = [[[PresenterCombinedSlideViewController alloc] initWithNibName:@"PresenterCombinedSlideViewController" bundle:nil] autorelease];
        }
            break;
        case 12: {
            PVC = [[[PresenterEbookViewController alloc] initWithNibName:@"PresenterEbookViewController" bundle:nil] autorelease];
        }
            break;
        case 13: {
            PVC = [[[PresenterBridgeGridViewController alloc] initWithNibName:@"PresenterBridgeGridViewController" bundle:nil] autorelease];
        }
            break;
        default:
            
            break;
    }
    if (PVC != nil) {
        PVC.files = presenterChildren;
        PVC.fileType = fileType;
        PVC.presenterRequestSource = self.parentPresenterRequestSource;
        [resultDict setObject:PVC forKey:@"MyPresenterViewController"];
    }
    
    return resultDict;
}

@end
