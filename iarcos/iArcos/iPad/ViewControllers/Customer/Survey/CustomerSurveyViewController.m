//
//  CustomerSurveyViewController.m
//  Arcos
//
//  Created by David Kilmartin on 10/02/2012.
//  Copyright (c) 2012 Strata IT Limited. All rights reserved.
//

#import "CustomerSurveyViewController.h"
#import "ArcosRootViewController.h"
@interface CustomerSurveyViewController ()
- (void)alertViewCallBack;
- (void)savePressedProcessor;
@end

@implementation CustomerSurveyViewController
@synthesize customerSurveyDataManager = _customerSurveyDataManager;
@synthesize cellFactory;
@synthesize surveyListView;
@synthesize locationIUR;
@synthesize csstv;
@synthesize locationName = _locationName;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize isFirstLoadedFlag = _isFirstLoadedFlag;
@synthesize custNameHeaderLabel = _custNameHeaderLabel;
@synthesize custAddrHeaderLabel = _custAddrHeaderLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        [FileCommon createFolder:@"survey"];
        [FileCommon createFolder:@"photos"];
        [FileCommon removeAllFileUnderFolder:@"survey"];
        self.isFirstLoadedFlag = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    if (self.customerSurveyDataManager != nil) { self.customerSurveyDataManager = nil; }
    if (self.cellFactory != nil) { self.cellFactory = nil; }
    if (self.surveyListView != nil) { self.surveyListView = nil; }
    if (self.csstv != nil) { self.csstv = nil; }
    if (self.locationIUR != nil) { self.locationIUR = nil;}     
    if (self.locationName != nil) { self.locationName = nil;}
    self.arcosRootViewController = nil;
    self.globalNavigationController = nil;
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
    self.custNameHeaderLabel = nil;
    self.custAddrHeaderLabel = nil;
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    surveyListView.allowsSelection = NO;
    self.customerSurveyDataManager = [[[CustomerSurveyDataManager alloc] init] autorelease];
    self.customerSurveyDataManager.locationIUR = self.locationIUR;
    self.cellFactory = [CustomerSurveyTableCellFactory factory];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    [saveButton release];
    self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.surveyListView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.custNameHeaderLabel == nil) {
        self.custNameHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 1, 550.0, 26.0)] autorelease];
        self.custNameHeaderLabel.textColor = [UIColor whiteColor];
        self.custNameHeaderLabel.font = [UIFont boldSystemFontOfSize:17.0];
    }
    self.custNameHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
    [self.navigationController.navigationBar addSubview:self.custNameHeaderLabel];
    if (self.custAddrHeaderLabel == nil) {
        self.custAddrHeaderLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2.0, 28, 550.0, 14.0)] autorelease];
        self.custAddrHeaderLabel.font = [UIFont systemFontOfSize:12.0];
        self.custAddrHeaderLabel.textColor = [UIColor whiteColor];
    }
    self.custAddrHeaderLabel.text = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerAddress]];
    [self.navigationController.navigationBar addSubview:self.custAddrHeaderLabel];
    if ([self.navigationItem.leftBarButtonItems count] == 0) {
        [self configTitleToBlue];
        [self hideHeaderLabelWithFlag:NO];
    } else {
        [self configTitleToWhite];
        [self hideHeaderLabelWithFlag:YES];
    }
    self.navigationItem.title = [ArcosUtils trim:[[OrderSharedClass sharedOrderSharedClass] currentCustomerName]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.customerSurveyDataManager.isImagePickerDisplayed) {
        self.customerSurveyDataManager.isImagePickerDisplayed = NO;
        return;
    }
    if (!self.isFirstLoadedFlag) return;
    self.isFirstLoadedFlag = NO;
    NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] allSurvey];
    CustomerSurveyListTableCell* customerSurveyListTableCell = (CustomerSurveyListTableCell*)[self.surveyListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([objectsArray count] > 0) {
        customerSurveyListTableCell.surveyTitle.text = [[objectsArray objectAtIndex:0] objectForKey:@"Title"];
        [self inputFinishedWithData:[objectsArray objectAtIndex:0] forIndexpath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        customerSurveyListTableCell.surveyTitle.text = @"No Active Surveys";
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData]orderContactsWithLocationIUR:self.locationIUR];
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    for (int i = 0; i < [contactList count]; i++) {
        NSMutableDictionary* auxContactDict = [contactList objectAtIndex:i];
        if ([[auxContactDict objectForKey:@"IUR"] intValue] == [[GlobalSharedClass shared].currentSelectedContactIUR intValue]) {
            [self inputFinishedWithData:auxContactDict forIndexpath:[NSIndexPath indexPathForRow:1 inSection:0]];
            break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.custNameHeaderLabel removeFromSuperview];
    [self.custAddrHeaderLabel removeFromSuperview];
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
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary* cellData = [self.customerSurveyDataManager cellDataWithIndexPath:indexPath];
    int questionType = [[cellData objectForKey:@"QuestionType"] intValue];
    if (questionType == 1) {
        NSMutableAttributedString* attributedNarrativeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[cellData objectForKey:@"Narrative"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        CGRect rect = [attributedNarrativeString boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 25 - 206, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedNarrativeString release];
        if (rect.size.height < 21.0) {
            rect.size.height = 21.0;
        }

        return rect.size.height + 23.0;
    }
    if (questionType == 3) {
        NSMutableAttributedString* attributedNarrativeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[cellData objectForKey:@"Narrative"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}];
        CGRect rect = [attributedNarrativeString boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 25, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        [attributedNarrativeString release];
        if (rect.size.height < 21.0) {
            rect.size.height = 21.0;
        }

        return rect.size.height + 39.0;
    }
    if (questionType == 5 || questionType == 6 || questionType == 11) {
        return 60;
    }
    if (questionType == 14) {
        return 70;
    }
    if (questionType == 17) {
        return 140;
    }
    if (questionType == 18) {
        return 140;
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    
    CustomerSurveySectionHeader* auxCustomerSurveySectionHeader = nil;
    NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerSurveyTypesTableCell" owner:self options:nil];
    for (id nibItem in nibContents) {
        if ([nibItem isKindOfClass:[CustomerSurveySectionHeader class]]) {
            auxCustomerSurveySectionHeader = (CustomerSurveySectionHeader*)nibItem;
            break;
        }
    }
    auxCustomerSurveySectionHeader.narrative.text = [self.customerSurveyDataManager.sectionTitleList objectAtIndex:section];
    return auxCustomerSurveySectionHeader;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (self.customerSurveyDataManager.sectionTitleList != nil) {
//        return [self.customerSurveyDataManager.sectionTitleList objectAtIndex:section];
//    } else {
//        return @"";
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.customerSurveyDataManager.sectionNoList != nil) {
        return [self.customerSurveyDataManager.sectionNoList count];
    } else {
        return 1;
    }    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSNumber* sectionNo = [self.customerSurveyDataManager.sectionNoList objectAtIndex:section];
    NSMutableArray* auxSectionDisplayList = [self.customerSurveyDataManager.groupedDataDict objectForKey:sectionNo];
    return [auxSectionDisplayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* cellData = [self.customerSurveyDataManager cellDataWithIndexPath:indexPath];
    CustomerSurveyBaseTableCell* cell = (CustomerSurveyBaseTableCell*)[tableView dequeueReusableCellWithIdentifier:[self.cellFactory identifierWithData:cellData]];
    if (cell == nil) {
        cell = (CustomerSurveyBaseTableCell*)[self.cellFactory createCustomerSurveyBaseTableCellWithData:cellData];
        cell.delegate = self;
    }
    
    // Configure the cell...
    
    cell.indexPath = indexPath;
    cell.locationIUR = self.locationIUR;
    cell.locationName = self.locationName;
    [cell configCellWithData:cellData];
    
    return cell;
}


#pragma mark CustomerSurveyTypesTableCellDelegate
-(void)inputFinishedWithData:(id)data forIndexpath:(NSIndexPath*)theIndexpath {
    if (theIndexpath.section == 0 && theIndexpath.row == 0) {//survey
        [self.view endEditing:YES];
        self.customerSurveyDataManager.rankingHashMap = [NSMutableDictionary dictionary];
        self.customerSurveyDataManager.surveyDict = data;
        NSMutableArray* objectsArray = [[ArcosCoreData sharedArcosCoreData] questionWithSurveyIUR:[data objectForKey:@"IUR"]];
        [self.customerSurveyDataManager processRawData:objectsArray];
        [self.tableView reloadData];
        [self.customerSurveyDataManager updateChangedData:[data objectForKey:@"IUR"] withIndexPath:theIndexpath];
//        NSLog(@"%@", objectsArray);
    } else if (theIndexpath.section == 0 && theIndexpath.row == 1) {//contact
        [self.view endEditing:YES];
        self.customerSurveyDataManager.rankingHashMap = [NSMutableDictionary dictionary];
        self.customerSurveyDataManager.contactDict = data;
        [self.customerSurveyDataManager updateChangedData:[data objectForKey:@"IUR"] withIndexPath:theIndexpath];
        if ([self.customerSurveyDataManager processRawDataFromContact]) {
            [self.tableView reloadData];
        }
    } else {
        [self.customerSurveyDataManager updateChangedData:[ArcosUtils convertToString:data] withIndexPath:theIndexpath];
    }    
}
//-(void)popoverShows:(UIPopoverController*)aPopover {
//    tablecellPopover = aPopover;
//}
-(void)showSurveyDetail {
    if (self.customerSurveyDataManager.surveyDict != nil) {
        NSString* message = [NSString stringWithFormat:@"%@ from %@ to %@", [self.customerSurveyDataManager.surveyDict objectForKey:@"Narrative"], [ArcosUtils stringFromDate:[self.customerSurveyDataManager.surveyDict objectForKey:@"StartDate"] format:@"dd/MM/yyyy"], [ArcosUtils stringFromDate:[self.customerSurveyDataManager.surveyDict objectForKey:@"EndDate"] format:@"dd/MM/yyyy"]];
//        [ArcosUtils showMsg:message delegate:nil];
        [ArcosUtils showDialogBox:message title:@"" target:self handler:nil];
    }
    
}
- (void)pressPhotoButtonDelegateWithIndexPath:(NSIndexPath *)anIndexpath {
    //check is camera avaliable
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [ArcosUtils showDialogBox:@"No camera available" title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    self.customerSurveyDataManager.currentIndexPath = anIndexpath;
    // Create image picker controller
    self.customerSurveyDataManager.isImagePickerDisplayed = YES;
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

- (UITableView*)retrieveSurveyTableView {
    return self.tableView;
}

-(UIViewController*)retrieveParentViewController {
    return self;
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Access the uncropped image from info dictionary
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    BOOL alertShowedFlag = NO;
    // Save image
    @try {
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg",[GlobalSharedClass shared].currentTimeStamp];
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon surveyPath],fileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
            [self inputFinishedWithData:fileName forIndexpath:self.customerSurveyDataManager.currentIndexPath];
            [self.tableView reloadData];
        }
    }
    @catch (NSException *exception) {
//        [ArcosUtils showMsg:[exception reason] delegate:nil];
        alertShowedFlag = YES;
        [ArcosUtils showDialogBox:[exception reason] title:@"" target:picker handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (!alertShowedFlag) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pressPreviewButtonDelegateWithIndexPath:(NSIndexPath *)anIndexpath {
    NSMutableDictionary* cellData = [self.customerSurveyDataManager cellDataWithIndexPath:anIndexpath];
    CustomerSurveyPreviewPhotoViewController* csppvc = [[CustomerSurveyPreviewPhotoViewController alloc] initWithNibName:@"CustomerSurveyPreviewPhotoViewController" bundle:nil];
    csppvc.myFileNamesStr = [cellData objectForKey:@"Answer"];
    csppvc.myIndexPath = anIndexpath;
    csppvc.myDelegate = self;
    csppvc.actionDelegate = self;
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:csppvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.arcosRootViewController addChildViewController:self.globalNavigationController];
    [self.arcosRootViewController.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.arcosRootViewController];
    [csppvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark CustomerSurveyPreviewPhotoDelegate
- (void)retakePhotoWithIndexPath:(NSIndexPath *)anIndexPath currentFileName:(NSString *)aCurrentFileName previousFileName:(NSString *)aPreviousFileName {
    [self.customerSurveyDataManager removePhotoWithFileName:aPreviousFileName];
    [self inputFinishedWithData:aCurrentFileName forIndexpath:anIndexPath];
    [self.tableView reloadData];
}

- (NSMutableDictionary*)retrieveRankingHashMap {
    return self.customerSurveyDataManager.rankingHashMap;
}

- (void)refreshSurveyList {
    [self.tableView reloadData];
}

- (void)deletePhotoWithIndexPath:(NSIndexPath *)anIndexPath currentFileName:(NSString *)aCurrentFileName {
//    [self.customerSurveyDataManager removePhotoWithFileName:aCurrentFileName];
    [self inputFinishedWithData:aCurrentFileName forIndexpath:anIndexPath];
    [self.tableView reloadData];
}

- (void)takePhotoWithIndexPath:(NSIndexPath *)anIndexPath currentFileName:(NSString *)aCurrentFileName {
    [self inputFinishedWithData:aCurrentFileName forIndexpath:anIndexPath];
    [self.tableView reloadData];
}

- (void)configImagePickerDisplayFlag:(BOOL)aFlag {
    self.customerSurveyDataManager.isImagePickerDisplayed = aFlag;
}


-(BOOL)validateResponses {
    BOOL errorFound = NO;    
    for (int i = 1; i < [self.customerSurveyDataManager.sectionNoList count]; i++) {
        NSMutableArray* tmpSectionDisplayList = [self.customerSurveyDataManager.groupedDataDict objectForKey:[self.customerSurveyDataManager.sectionNoList objectAtIndex:i]];
        for (int j = 0; j < [tmpSectionDisplayList count]; j++) {
            //set the default value if it is not selected
            NSDictionary* aQuestionDict = [tmpSectionDisplayList objectAtIndex:j];
            NSNumber* questionType = [aQuestionDict objectForKey:@"QuestionType"];
            NSString* anAnswer = [aQuestionDict objectForKey:@"Answer"];
//            NSNumber* anResponseIUR = [aQuestionDict objectForKey:@"ResponseIUR"];
//            if (anResponseIUR != nil && ![anResponseIUR isEqualToNumber:[NSNumber numberWithInt:0]]) {
//                [ArcosUtils showMsg:-1 message:@"It is not allowed to amend the response if it has already been sent out." delegate:nil];
//                errorFound = YES;
//                break;
//            }
            switch ([questionType intValue]) {
                case 9: {                    
                    if (![anAnswer isEqualToString:@""] && ![anAnswer isEqualToString:[GlobalSharedClass shared].unknownText] && ![ArcosValidator isDecimalWithTwoPlaces:anAnswer]) {
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@" %@ is only allowed to input a decimal with a maximum of two places.",[aQuestionDict objectForKey:@"Narrative"]] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                            
                        }];
                        errorFound = YES;
                    }                    
                }                    
                    break;
                case 10: {
                    if (![anAnswer isEqualToString:@""] && ![anAnswer isEqualToString:[GlobalSharedClass shared].unknownText] && ![ArcosValidator isInteger:anAnswer]) {
                        [ArcosUtils showDialogBox:[NSString stringWithFormat:@" %@ is only allowed to input an integer.",[aQuestionDict objectForKey:@"Narrative"]] title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                            
                        }];
                        errorFound = YES;
                    }                    
                }                    
                    break;    
                default:
                    break;
            }
            if (errorFound) { break;}
        }
        if (errorFound) { break;}
    }
    if (errorFound) { return NO;}            
    return YES;
}
-(BOOL)validateActiveQuestions {
    BOOL mustAnswerQuestionFound = [self.customerSurveyDataManager turnOnHighlightFlagAndFindMustAnswerQuestion];
    if (mustAnswerQuestionFound) {
        void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self savePressedProcessor];
        };
        void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            
        };
        [ArcosUtils showTwoBtnsDialogBox:@"Not all questions have been answered. Are you sure you want to exit survey" title:@"Warning" delegate:nil target:self tag:0 lBtnText:@"YES" rBtnText:@"NO" lBtnHandler:yesActionHandler rBtnHandler:noActionHandler];
    }
    return !mustAnswerQuestionFound;
}
-(void)savePressed:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.customerSurveyDataManager.sectionNoList count] <= 1) {
        return;
    }
    if (![self validateResponses]){
        return;
    }
    if (![self validateActiveQuestions]) {
        [self.tableView reloadData];
        return;
    }
    
    [self savePressedProcessor];
}

- (void)savePressedProcessor {
    [self.customerSurveyDataManager getChangedDataList];
    if ([self.customerSurveyDataManager.changedDataList count] == 0) {
        [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    NSNumber* aContactIUR;
    if(self.customerSurveyDataManager.contactDict != nil && [self.customerSurveyDataManager.contactDict objectForKey:@"IUR"] != nil) {
        aContactIUR = [self.customerSurveyDataManager.contactDict objectForKey:@"IUR"];
    } else {
        aContactIUR = [NSNumber numberWithInt:0];
    }
    for (int i = 0; i < [self.customerSurveyDataManager.changedDataList count]; i++) {
        [self.customerSurveyDataManager.innerBaseDataManager manipulateResponseWithDataList:[self.customerSurveyDataManager.changedDataList objectAtIndex:i] originalDataDict:[self.customerSurveyDataManager.originalChangedDataList objectAtIndex:i] contactIUR:aContactIUR locationIUR:self.locationIUR];
    }
    [ArcosUtils showDialogBox:@"Completed." title:@"" delegate:self target:self tag:0 handler:^(UIAlertAction *action) {
        [self alertViewCallBack];
    }];
}

#pragma mark CustomerSurveySlideDelegate
-(void)slidePageFinishEditing:(id)data WithIndexPath:(NSIndexPath *)theIndexPath {
    CustomerSurveySlideTableCell* currentCell = (CustomerSurveySlideTableCell*)[self.surveyListView cellForRowAtIndexPath:theIndexPath];
    currentCell.responseLimits.text = data;
    [self.customerSurveyDataManager updateChangedData:data withIndexPath:theIndexPath];
}

#pragma mark UIAlertViewDelegate
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if(buttonIndex == 0){  
//        //Code that will run after you press ok button 
////        [self.navigationController popViewControllerAnimated:YES];
//        [self alertViewCallBack];
//    }
//}

- (void)alertViewCallBack {
    self.isFirstLoadedFlag = YES;
    [GlobalSharedClass shared].currentSelectedSurveyLocationIUR = nil;
    self.customerSurveyDataManager.isSurveySaved = YES;
//    int itemIndex = 1;
//    if ([self.arcosRootViewController.customerMasterViewController.subMenuListingTableViewController.requestSourceName isEqualToString:[GlobalSharedClass shared].contactText]) {
//        itemIndex = 2;
//    }
    int itemIndex = [self.arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:self.arcosRootViewController.customerMasterViewController.subMenuListingTableViewController.requestSourceName];
    [self.arcosRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
    if ([GlobalSharedClass shared].currentSelectedOrderLocationIUR == nil && [GlobalSharedClass shared].currentSelectedPresenterLocationIUR == nil && [GlobalSharedClass shared].currentSelectedCallLocationIUR == nil) {
        NSMutableDictionary* topTabBarCellDict = [self.arcosRootViewController.customerMasterViewController.customerMasterDataManager.displayList objectAtIndex:itemIndex];
        ArcosStackedViewController* myArcosStackedViewController = [topTabBarCellDict objectForKey:@"MyCustomController"];
        NSArray* tmpControllerList = myArcosStackedViewController.rcsViewControllers;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] hideCustomerDetailsAfterUpdateFlag] && [tmpControllerList count] >= 2) {
            UINavigationController* customerInfoNavigationController = (UINavigationController*)[tmpControllerList objectAtIndex:1];
            CustomerInfoTableViewController* citvc = [customerInfoNavigationController.viewControllers objectAtIndex:0];
            [citvc addCoverHomePageImageView];
            myArcosStackedViewController.topVisibleNavigationController = customerInfoNavigationController;
        }
    }
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    } completion:^(BOOL finished){
        [self.globalNavigationController willMoveToParentViewController:nil];
        [self.globalNavigationController.view removeFromSuperview];
        [self.globalNavigationController removeFromParentViewController];
        self.globalNavigationController = nil;
    }];
}

- (void)hideHeaderLabelWithFlag:(BOOL)aFlag {
    self.custNameHeaderLabel.hidden = aFlag;
    self.custAddrHeaderLabel.hidden = aFlag;
}

- (void)configTitleToWhite {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
}

- (void)configTitleToBlue {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance* customNavigationBarAppearance = [[UINavigationBarAppearance alloc] init];
        [customNavigationBarAppearance configureWithOpaqueBackground];
        [customNavigationBarAppearance setBackgroundColor:[GlobalSharedClass shared].myAppBlueColor];
        [customNavigationBarAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor clearColor], NSForegroundColorAttributeName, nil]];
        self.navigationController.navigationBar.standardAppearance = customNavigationBarAppearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = customNavigationBarAppearance;
        [customNavigationBarAppearance release];
    } else {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}];
    }
}


@end
