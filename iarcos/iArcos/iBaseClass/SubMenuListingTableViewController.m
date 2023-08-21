//
//  SubMenuListingTableViewController.m
//  iArcos
//
//  Created by David Kilmartin on 05/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SubMenuListingTableViewController.h"

@interface SubMenuListingTableViewController ()
- (void)takeOrder;
- (void)takeCall;
- (void)deleteAllObjectsCreated;
- (void)selectCurrentIndexPathRow:(NSIndexPath*)aCurrentIndexPath;
- (void)fillDataByIndexPath:(NSIndexPath*)anIndexPath;
- (void)fillDataByTitle:(NSString*)aTitle;
- (void)addPhoto;
- (void)addJourneyAppointment;
- (NSIndexPath*)retrieveIndexPathWithTitle:(NSString*)aTitle;
@end

@implementation SubMenuListingTableViewController
//@synthesize locationViewControllers = _locationViewControllers;
@synthesize myNewOrderViewController = _myNewOrderViewController;
@synthesize myNewOrderNavigationController = _myNewOrderNavigationController;
@synthesize detailingTableViewController = _detailingTableViewController;
@synthesize detailingTableNavigationController = _detailingTableNavigationController;
//@synthesize myNewPresenterViewController = _myNewPresenterViewController;
//@synthesize myNewPresenterNavigationController = _myNewPresenterNavigationController;
@synthesize mainPresenterTableViewController = _mainPresenterTableViewController;
@synthesize mainPresenterNavigationController = _mainPresenterNavigationController;
@synthesize customerSurveyViewController = _customerSurveyViewController;
@synthesize customerSurveyNavigationController = _customerSurveyNavigationController;
@synthesize orderTitle = _orderTitle;
@synthesize presenterTitle = _presenterTitle;
@synthesize callTitle = _callTitle;
@synthesize surveyTitle = _surveyTitle;
@synthesize myCustomControllerTitle = _myCustomControllerTitle;
@synthesize mapTitle = _mapTitle;
@synthesize photosTitle = _photosTitle;
@synthesize ruleoutTitleDict = _ruleoutTitleDict;
@synthesize CLController = _CLController;
@synthesize subMenuListingDataManager = _subMenuListingDataManager;
@synthesize locationCoordinateCaptured = _locationCoordinateCaptured;
@synthesize appointmentTitle = _appointmentTitle;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.subMenuListingDataManager = [[[SubMenuListingDataManager alloc] init] autorelease];
        self.orderTitle = @"Order";
        self.presenterTitle = @"Presenter";
        self.callTitle = @"Call";
        self.surveyTitle = @"Survey";
        self.myCustomControllerTitle = @"MyCustomController";
        self.mapTitle = @"Map";
        self.photosTitle = @"Photos";
        self.appointmentTitle = @"Diary";
        self.ruleoutTitleDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [self.ruleoutTitleDict setObject:self.orderTitle forKey:self.orderTitle];
        [self.ruleoutTitleDict setObject:self.presenterTitle forKey:self.presenterTitle];
        [self.ruleoutTitleDict setObject:self.mapTitle forKey:self.mapTitle];
        [self.ruleoutTitleDict setObject:self.photosTitle forKey:self.photosTitle];
        [self.ruleoutTitleDict setObject:self.appointmentTitle forKey:self.appointmentTitle];
        NSMutableDictionary* orderCellData = [self createItemCellData:self.orderTitle imageFile:@"CheckoutIcon.png"];
        NSMutableDictionary* presenterCellData = [self createItemCellData:self.presenterTitle imageFile:@"PresenterIcon.png"];
        NSMutableDictionary* callCellData = [self createItemCellData:self.callTitle imageFile:@"CallIcon.png"];
        NSMutableDictionary* surveyCellData = [self createItemCellData:self.surveyTitle imageFile:@"OrderIcon.png"];
        NSMutableDictionary* mapCellData = [self createItemCellData:self.mapTitle imageFile:@"MapIcon.png"];
        NSMutableDictionary* photosCellData = [self createItemCellData:self.photosTitle imageFile:@"Camera.png"];
//        NSMutableDictionary* appointmentCellData = [self createItemCellData:self.appointmentTitle imageFile:@"appointment.png"]; , appointmentCellData
        
        self.displayList = [NSMutableArray arrayWithObjects:orderCellData, presenterCellData, callCellData, surveyCellData, mapCellData, photosCellData, nil];
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableCallOnlyFlag]) {
            self.displayList = [NSMutableArray arrayWithObjects:presenterCellData, callCellData, surveyCellData, mapCellData, photosCellData, nil];
        }
        self.CLController = [[[CoreLocationController alloc] init] autorelease];
        self.CLController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.displayDict = [NSMutableDictionary dictionaryWithCapacity:[self.displayList count]];
}

- (void)dealloc {
    self.orderTitle = nil;
    self.presenterTitle = nil;
    self.callTitle = nil;
    self.surveyTitle = nil;
    self.myCustomControllerTitle = nil;
    self.mapTitle = nil;
    self.photosTitle = nil;
    self.appointmentTitle = nil;
    self.ruleoutTitleDict = nil;
    [self deleteAllObjectsCreated];
    self.CLController = nil;
    self.subMenuListingDataManager = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self selectCurrentIndexPathRow:self.currentIndexPath];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"IdCustomerMasterBottomTabBarItemTableCell";
    CustomerMasterBottomTabBarItemTableCell *cell=(CustomerMasterBottomTabBarItemTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerMasterTabBarItemTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerMasterBottomTabBarItemTableCell class]] && [[(CustomerMasterBottomTabBarItemTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell= (CustomerMasterBottomTabBarItemTableCell *) nibItem;
                cell.subMenuDelegate = self;
            }
        }
    }
    cell.indexPath = indexPath;
    NSMutableDictionary* cellData = [self.displayList objectAtIndex:indexPath.row];
    [cell configCellWithData:cellData currentIndexPath:self.currentIndexPath];
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)takeOrder {
    
}

- (void)takeCall {

}

- (void)selectCurrentIndexPathRow:(NSIndexPath*)aCurrentIndexPath {
    for (int i = 0; i < [self.displayList count]; i++) {
        NSIndexPath* tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CustomerMasterTabBarItemTableCell* itemTableCell = (CustomerMasterTabBarItemTableCell*)[[self.subMenuDelegate retrieveMasterBottomTableView] cellForRowAtIndexPath:tmpIndexPath];
        if ([aCurrentIndexPath isEqual:tmpIndexPath]) {
            [itemTableCell selectedImageProcessor];
        } else {
            [itemTableCell unSelectedImageProcessor];
        }
    }
}

#pragma mark SubMenuTableViewControllerDelegate 
- (void)didSelectSubMenuListingRow:(NSIndexPath *)anIndexPath viewController:(UIViewController *)aViewController{
    if ([self.subMenuListingDataManager.lsCodeType intValue] == 2) return;
    NSMutableDictionary* cellDict = [self.displayList objectAtIndex:anIndexPath.row];
    NSString* myTitle = [cellDict objectForKey:@"Title"];
    if ([myTitle isEqualToString:self.orderTitle]) {
        if (![self.subMenuListingDataManager checkLocationCode]) return;
        if (![self.subMenuListingDataManager checkCreditStatus]) return;
        if (![self.subMenuListingDataManager checkDialUpNumber]) return;
    }
    self.currentIndexPath = anIndexPath;
    [self selectCurrentIndexPathRow:anIndexPath];
    if ([myTitle isEqualToString:self.mapTitle]) {
        NSMutableArray* locationList = [[ArcosCoreData sharedArcosCoreData] locationWithIURWithoutCheck:[GlobalSharedClass shared].currentSelectedLocationIUR];
        if (locationList == nil) return;
        NSDictionary* locationDict = [locationList objectAtIndex:0];
        NSNumber* latitudeNumber = [locationDict objectForKey:@"Latitude"];
        NSNumber* longitudeNumber = [locationDict objectForKey:@"Longitude"];
        if ([latitudeNumber intValue] == 0 && [longitudeNumber intValue] == 0) {
            [self.CLController start];
        } else {
            void (^removeActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                [self removeCoordinateProcessor];
            };
            void (^resetActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                [self resetCoordinateProcessor];
            };
            void (^leaveActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
                [self leaveCoordinateProcessor];
            };
            [ArcosUtils showThreeBtnsDialogBox:[NSString stringWithFormat:@"Co-ordinates already set for %@. Please choose from following", [ArcosUtils convertNilToEmpty:[locationDict objectForKey:@"Name"]]] title:@"" delegate:nil target:[self.subMenuDelegate retrieveMasterViewController] tag:0 lBtnText:@"Remove" rBtnText:@"Reset" thirdBtnText:@"Leave" lBtnHandler:removeActionHandler rBtnHandler:resetActionHandler thirdBtnHandler:leaveActionHandler];
        }        
        return;
    }
    if ([myTitle isEqualToString:self.photosTitle]) {
        [self addPhoto];
        return;
    }
    if ([myTitle isEqualToString:self.appointmentTitle]) {
        [self addJourneyAppointment];
        return;
    }
    UIViewController* myViewController = [cellDict objectForKey:self.myCustomControllerTitle];
    if (myViewController == nil) {
        myViewController = [self pickCustomViewController:myTitle];
        [cellDict setObject:myViewController forKey:self.myCustomControllerTitle];
        [self fillDataByTitle:myTitle];
    }
    if ([myTitle isEqualToString:self.callTitle] && self.detailingTableViewController.detailingDataManager.isCallSaved) {
        myViewController = [self pickCustomViewController:myTitle];
        [cellDict setObject:myViewController forKey:self.myCustomControllerTitle];
        [self fillDataByTitle:myTitle];
    }
    if ([myTitle isEqualToString:self.surveyTitle] && self.customerSurveyViewController.customerSurveyDataManager.isSurveySaved) {
        myViewController = [self pickCustomViewController:myTitle];
        [cellDict setObject:myViewController forKey:self.myCustomControllerTitle];
        [self fillDataByTitle:myTitle];
    }
    
    [self.subMenuDelegate didSelectSubMenuListingRow:anIndexPath viewController:myViewController];
}

- (void)removeCoordinateProcessor {
    [[ArcosCoreData sharedArcosCoreData]saveGeoLocationWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR withLat:[NSNumber numberWithInteger:0] withLon:[NSNumber numberWithInteger:0]];
    [ArcosUtils showDialogBox:@"Co-ordinates removed." title:@"" delegate:self target:[self.subMenuDelegate retrieveMasterViewController] tag:99 handler:^(UIAlertAction *action) {
        
    }];
}

- (void)resetCoordinateProcessor {
    [self.CLController start];
}

- (void)leaveCoordinateProcessor {
    
}

- (void)fillDataByTitle:(NSString *)aTitle {
    NSString* currentSelectedLocationName = [[OrderSharedClass sharedOrderSharedClass] currentCustomerName];
    if ([aTitle isEqualToString:self.orderTitle]) {
        [GlobalSharedClass shared].currentSelectedOrderLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    } else if ([aTitle isEqualToString:self.presenterTitle]) {
        [GlobalSharedClass shared].currentSelectedPresenterLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
    } else if ([aTitle isEqualToString:self.callTitle]) {
        [GlobalSharedClass shared].currentSelectedCallLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
//                    NSMutableDictionary* cellDict = [self.subMenuDelegate retrieveSelectedCustomerBaseCellData];
//                    NSLog(@"cellDict LocationIUR: %@ %@", [cellDict objectForKey:@"LocationIUR"], cellDict);
        NSMutableDictionary* orderHeader = [[OrderSharedClass sharedOrderSharedClass]getADefaultOrderHeader];
        [orderHeader setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
        self.detailingTableViewController.orderHeader = orderHeader;
        self.detailingTableViewController.isEditable = YES;
        self.detailingTableViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        self.detailingTableViewController.locationName = currentSelectedLocationName;
        self.detailingTableViewController.title = currentSelectedLocationName;
        self.detailingTableViewController.locationDefaultContactIUR = [GlobalSharedClass shared].currentSelectedContactIUR;
    } else if ([aTitle isEqualToString:self.surveyTitle]) {
        [GlobalSharedClass shared].currentSelectedSurveyLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
//        NSMutableDictionary* cellDict = [self.subMenuDelegate retrieveSelectedCustomerBaseCellData];
        self.customerSurveyViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        self.customerSurveyViewController.locationName = currentSelectedLocationName;
        self.customerSurveyViewController.title = currentSelectedLocationName;
    } else {
        
    }
}
- (void)fillDataByIndexPath:(NSIndexPath*)anIndexPath {
    NSString* currentSelectedLocationName = [[OrderSharedClass sharedOrderSharedClass] currentCustomerName];
    switch (anIndexPath.row) {
        case 0: {
            [GlobalSharedClass shared].currentSelectedOrderLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        }
            break;
        case 1: {
            [GlobalSharedClass shared].currentSelectedPresenterLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
        }
            break;
        case 2: {
            [GlobalSharedClass shared].currentSelectedCallLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
//            NSMutableDictionary* cellDict = [self.subMenuDelegate retrieveSelectedCustomerBaseCellData];
            //            NSLog(@"cellDict LocationIUR: %@ %@", [cellDict objectForKey:@"LocationIUR"], cellDict);
            NSMutableDictionary* orderHeader = [[OrderSharedClass sharedOrderSharedClass]getADefaultOrderHeader];
            [orderHeader setObject:[GlobalSharedClass shared].currentSelectedLocationIUR forKey:@"LocationIUR"];
            self.detailingTableViewController.orderHeader = orderHeader;
            self.detailingTableViewController.isEditable = YES;
            self.detailingTableViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
            self.detailingTableViewController.locationName = currentSelectedLocationName;
            self.detailingTableViewController.title = currentSelectedLocationName;
            self.detailingTableViewController.locationDefaultContactIUR = [GlobalSharedClass shared].currentSelectedContactIUR;
        }
            break;
        case 3: {
            [GlobalSharedClass shared].currentSelectedSurveyLocationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
//            NSMutableDictionary* cellDict = [self.subMenuDelegate retrieveSelectedCustomerBaseCellData];
            self.customerSurveyViewController.locationIUR = [GlobalSharedClass shared].currentSelectedLocationIUR;
            self.customerSurveyViewController.locationName = currentSelectedLocationName;
            self.customerSurveyViewController.title = currentSelectedLocationName;
        }
            break;
        default:
            break;
    }
}

- (UIViewController*)pickCustomViewController:(NSString*)aTitle {
    if ([aTitle isEqualToString:@"Order"]) {
        self.myNewOrderViewController = [[[NewOrderViewController alloc] initWithNibName:@"NewOrderViewController" bundle:nil] autorelease];
        self.myNewOrderNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.myNewOrderViewController] autorelease];
        return self.myNewOrderNavigationController;
    } else if ([aTitle isEqualToString:self.callTitle]) {
        self.detailingTableViewController = [[[DetailingTableViewController alloc] initWithNibName:@"DetailingTableViewController" bundle:nil] autorelease];
        self.detailingTableViewController.requestSource = DetailingRequestSourceCall;
        self.detailingTableViewController.detailingDataManager.actionType = @"create";
        self.detailingTableNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.detailingTableViewController] autorelease];
        return self.detailingTableNavigationController;
    } else if ([aTitle isEqualToString:@"Presenter"]) {
//        self.myNewPresenterViewController = [[[NewPresenterViewController alloc] initWithNibName:@"NewPresenterViewController" bundle:nil] autorelease];
//        self.myNewPresenterNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.myNewPresenterViewController] autorelease];
//        return self.myNewPresenterNavigationController;
        self.mainPresenterTableViewController = [[[MainPresenterTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        [self.mainPresenterTableViewController.mainPresenterDataManager retrieveMainPresenterDataList];
        UIViewController* resultViewController = nil;
        if ([self.mainPresenterTableViewController.mainPresenterDataManager.displayList count] == 1) {
            NSMutableArray* subsetDisplayList = [self.mainPresenterTableViewController.mainPresenterDataManager.displayList objectAtIndex:0];
            if ([subsetDisplayList count] == 1) {
                NSDictionary* mainPresenterCellDict = [subsetDisplayList objectAtIndex:0];
                resultViewController = [self.mainPresenterTableViewController retrieveNewPresenterViewControllerResult:mainPresenterCellDict];
            }
        }
        if (resultViewController == nil) {
            resultViewController = self.mainPresenterTableViewController;
        }
        self.mainPresenterNavigationController = [[[UINavigationController alloc] initWithRootViewController:resultViewController] autorelease];
        return self.mainPresenterNavigationController;
    } else if ([aTitle isEqualToString:self.surveyTitle]) {
        self.customerSurveyViewController = [[[CustomerSurveyViewController alloc] initWithNibName:@"CustomerSurveyViewController" bundle:nil] autorelease];
        self.customerSurveyNavigationController = [[[UINavigationController alloc] initWithRootViewController:self.customerSurveyViewController] autorelease];
        return self.customerSurveyNavigationController;
    }
    return nil;
}

- (void)removeAllInstances {
    self.currentIndexPath = nil;
    [GlobalSharedClass shared].currentSelectedOrderLocationIUR = nil;
    [GlobalSharedClass shared].currentSelectedPresenterLocationIUR = nil;
    [GlobalSharedClass shared].currentSelectedCallLocationIUR = nil;
    [GlobalSharedClass shared].currentSelectedSurveyLocationIUR = nil;
    [self deleteAllObjectsCreated];
}

- (void)deleteAllObjectsCreated {
    self.myNewOrderViewController = nil;
    self.myNewOrderNavigationController = nil;
    self.detailingTableViewController = nil;
    self.detailingTableNavigationController = nil;
//    self.myNewPresenterViewController = nil;
//    self.myNewPresenterNavigationController = nil;
    self.mainPresenterTableViewController = nil;
    self.mainPresenterNavigationController = nil;
    self.customerSurveyViewController = nil;
    self.customerSurveyNavigationController = nil;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* cellDict = [self.displayList objectAtIndex:i];
        [cellDict removeObjectForKey:self.myCustomControllerTitle];
    }
}
#pragma mark CoreLocationControllerDelegate
- (void)locationUpdate:(CLLocation *)location {
    NSNumber* latitude=[NSNumber numberWithFloat:location.coordinate.latitude];
    NSNumber* longitude=[NSNumber numberWithFloat:location.coordinate.longitude];
    
    if([GlobalSharedClass shared].currentSelectedLocationIUR != nil){
        if (self.locationCoordinateCaptured) {
            [self.CLController stop];
            return;
        }
        self.locationCoordinateCaptured = YES;
        [[ArcosCoreData sharedArcosCoreData]saveGeoLocationWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR withLat:latitude withLon:longitude];
        [ArcosUtils showDialogBox:@"Co-ordinates saved." title:@"" delegate:self target:[self.subMenuDelegate retrieveMasterViewController] tag:99 handler:^(UIAlertAction *action) {
            self.locationCoordinateCaptured = NO;
        }];
    }
    [self.CLController stop];
}

- (void)locationError:(NSError *)error {
    [self.CLController stop];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99) {
        self.locationCoordinateCaptured = NO;
    }
}

-(void)addPhoto{
    [FileCommon createFolder:@"photos"];
    //check is camera avaliable
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[GlobalSharedClass shared].errorTitle
                                                        message:@"No camera available"
                                                       delegate:nil cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
        
    }
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Allow editing of image ?
    imagePicker.allowsEditing = NO;
    
    // Show image picker
    [[self.subMenuDelegate retrieveMasterViewController] presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
    
}

- (void)addJourneyAppointment {
    CustomerJourneyAppointmentViewController* cjavc = [[CustomerJourneyAppointmentViewController alloc] initWithNibName:@"CustomerJourneyAppointmentViewController" bundle:nil];
    cjavc.modalDelegate = self;
    UINavigationController* auxNavigationController = [[UINavigationController alloc] initWithRootViewController:cjavc];
    auxNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    auxNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[self.subMenuDelegate retrieveMasterViewController] presentViewController:auxNavigationController animated:YES completion:nil];
    [auxNavigationController release];
    [cjavc release];
}

#pragma mark ModalPresentViewControllerDelegate
- (void)didDismissModalPresentViewController {
    [[self.subMenuDelegate retrieveMasterViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark image piker delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIAlertController* tmpDialogBox = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter Tag for Photo\n" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self.subMenuDelegate retrieveMasterViewController].view endEditing:YES];
        UITextField* myTextField = [tmpDialogBox.textFields objectAtIndex:0];
        [self processTextFieldFileName:myTextField.text didFinishPickingMediaWithInfo:info];
        [[self.subMenuDelegate retrieveMasterViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [[self.subMenuDelegate retrieveMasterViewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [tmpDialogBox addAction:cancelAction];
    [tmpDialogBox addAction:okAction];
    [tmpDialogBox addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Allows HQ to Filter Photos";
        textField.delegate = self;
    }];
    [picker presentViewController:tmpDialogBox animated:YES completion:nil];
    // Access the uncropped image from info dictionary
    
    
}

- (void)processTextFieldFileName:(NSString*)aTextFieldFileName didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    @try {
        NSNumber* fileSequenceNumber = [GlobalSharedClass shared].currentTimeStamp;
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", fileSequenceNumber];
        if (![aTextFieldFileName isEqualToString:@""]) {
            fileName = [NSString stringWithFormat:@"%@_%@.jpg", aTextFieldFileName, fileSequenceNumber];
        }
        NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon photosPath],fileName];
        BOOL jpgImageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imageJpgPath atomically:YES];
        if (jpgImageSaved) {
            //            NSNumber* locationIUR = [self.aCustDict objectForKey:@"LocationIUR"];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            [[ArcosCoreData sharedArcosCoreData] insertCollectedWithLocationIUR:[GlobalSharedClass shared].currentSelectedLocationIUR comments:fileName iUR:[NSNumber numberWithInt:0] date:[NSDate date]];
        } else {
            [ArcosUtils showMsg:-1 message:@"The photo has not been saved." delegate:nil];
        }
    }
    @catch (NSException *exception) {
        [ArcosUtils showMsg:[exception reason] delegate:nil];
    }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
//    NSCharacterSet* nonLetterSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSCharacterSet* nonalphanumericSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([string stringByTrimmingCharactersInSet:nonalphanumericSet].length > 0 || [string isEqualToString:@""]) && newLength <= [GlobalSharedClass shared].customerRefMaxLength;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:nil cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [[self.subMenuDelegate retrieveMasterViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectBottomRecordByTitle:(NSString*)aTitle {
    NSIndexPath* auxIndexPath = [self retrieveIndexPathWithTitle:aTitle];
    if (auxIndexPath != nil) {
        [self didSelectSubMenuListingRow:auxIndexPath viewController:nil];
    }
}

- (NSIndexPath*)retrieveIndexPathWithTitle:(NSString*)aTitle {
    NSIndexPath* myIndexPath = nil;
    for (int i = 0; i < [self.displayList count]; i++) {
        NSMutableDictionary* myCellDict = [self.displayList objectAtIndex:i];
        if ([[myCellDict objectForKey:@"Title"] isEqualToString:aTitle]) {
            myIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    return myIndexPath;
}

@end
