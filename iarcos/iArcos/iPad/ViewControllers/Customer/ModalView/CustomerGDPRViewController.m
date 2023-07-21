//
//  CustomerGDPRViewController.m
//  iArcos
//
//  Created by David Kilmartin on 02/05/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerGDPRViewController.h"

@interface CustomerGDPRViewController ()

@end

@implementation CustomerGDPRViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize refreshDelegate = _refreshDelegate;
@synthesize locationNameLabel = _locationNameLabel;
@synthesize locationAddress = _locationAddress;
@synthesize dateTitleLabel = _dateTitleLabel;
@synthesize dateContentLabel = _dateContentLabel;
@synthesize timeTitleLabel = _timeTitleLabel;
@synthesize timeContentLabel = _timeContentLabel;
@synthesize myWebView = _myWebView;
@synthesize myTableView = _myTableView;
@synthesize drawingAreaView = _drawingAreaView;
@synthesize signatureHintLabel = _signatureHintLabel;
@synthesize tapToSelectContactNameBtn = _tapToSelectContactNameBtn;
@synthesize fileURL = _fileURL;
@synthesize customerGDPRDataManager = _customerGDPRDataManager;
@synthesize saveButton = _saveButton;
@synthesize factory = _factory;
@synthesize thePopover = _thePopover;
@synthesize callGenericServices = _callGenericServices;
@synthesize myEmailAddressLabel = _myEmailAddressLabel;
@synthesize amendContactButton = _amendContactButton;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize rootView = _rootView;
@synthesize mailController = _mailController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.customerGDPRDataManager = [[[CustomerGDPRDataManager alloc] init] autorelease];        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    if ([[GlobalSharedClass shared].currentSelectedContactIUR intValue] != 0) {
        NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:[GlobalSharedClass shared].currentSelectedContactIUR];
        if (tmpContactDict != nil) {
            NSString* fullName = [tmpContactDict objectForKey:@"Title"];
            [self.tapToSelectContactNameBtn setTitle:fullName forState:UIControlStateNormal];
            self.customerGDPRDataManager.contactDict = tmpContactDict;
            self.myEmailAddressLabel.text = [ArcosUtils convertNilToEmpty:[tmpContactDict objectForKey:@"Email"]];
        }
    }
    self.locationNameLabel.text = [NSString stringWithFormat:@"%@", self.customerGDPRDataManager.locationName];
    self.locationAddress.text = self.customerGDPRDataManager.locationAddress;
    self.drawingAreaView.userInteractionEnabled = NO;
    NSDate* currentDate = [NSDate date];
    self.myWebView.delegate = self;
    [self.myWebView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [self.myWebView.layer setBorderWidth:1.0];
    self.dateContentLabel.text = [ArcosUtils stringFromDate:currentDate format:[GlobalSharedClass shared].dateFormat];
    self.timeContentLabel.text = [ArcosUtils stringFromDate:currentDate format:[GlobalSharedClass shared].hourMinuteFormat];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    [backButton release];
    self.saveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)] autorelease];
    [self.navigationItem setRightBarButtonItem:self.saveButton];
    NSString* fileName = @"GDPR.pdf";//GDPR
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon presenterPath], fileName];
    self.fileURL = [NSURL fileURLWithPath:filePath];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:self.fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.isNotRecursion = NO;
    NSMutableArray* consentDescrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:@"LF" descrDetailCode:@"CONSENT"];
    if ([consentDescrDetailDictList count] <= 0) return;
    NSDictionary* consentDescrDetailDict = [consentDescrDetailDictList objectAtIndex:0];
    NSNumber* consentDescrDetailIUR = [consentDescrDetailDict objectForKey:@"DescrDetailIUR"];
    NSString* consentSqlStatement = [NSString stringWithFormat:@"select * from Flag where LocationIUR = %@ and DescrDetailIUR = %@", self.customerGDPRDataManager.locationIUR, consentDescrDetailIUR];
    [self.callGenericServices genericGetData:consentSqlStatement action:@selector(setConsentGetDataResult:) target:self];
}

- (void)setConsentGetDataResult:(ArcosGenericReturnObject*)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES]; 
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.callGenericServices.HUD hide:YES];
        [self radioButtonPressedWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        NSMutableArray* withdrawnDescrDetailDictList = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:@"LF" descrDetailCode:@"WITHDRAWN"];
        if ([withdrawnDescrDetailDictList count] <= 0) return;
        NSDictionary* withdrawnDescrDetailDict = [withdrawnDescrDetailDictList objectAtIndex:0];
        NSNumber* withdrawnDescrDetailIUR = [withdrawnDescrDetailDict objectForKey:@"DescrDetailIUR"];
        NSString* withdrawnSqlStatement = [NSString stringWithFormat:@"select * from Flag where LocationIUR = %@ and DescrDetailIUR = %@", self.customerGDPRDataManager.locationIUR, withdrawnDescrDetailIUR];
        [self.callGenericServices genericGetData:withdrawnSqlStatement action:@selector(setWithdrawnGetDataResult:) target:self];
    }
}

- (void)setWithdrawnGetDataResult:(ArcosGenericReturnObject*)result {
    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self radioButtonPressedWithIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backPressed:(id)sender {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)savePressed:(id)sender {
    self.customerGDPRDataManager.tooltip = @"";
    self.customerGDPRDataManager.orderHeader = [[OrderSharedClass sharedOrderSharedClass] getADefaultOrderHeader];
    self.customerGDPRDataManager.callTranList = [[[ArcosArrayOfCallTran alloc] init] autorelease];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"DescrTypeCode='CT' and DescrDetailCode = 'GDPR'"];
    NSArray* sortArray = [NSArray arrayWithObjects:@"DescrDetailCode",nil];
    NSMutableArray* objectList = [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicate sortByArray:sortArray];
    if ([objectList count] > 0) {
        NSDictionary* descrDetailDict = [objectList objectAtIndex:0];
        [self.customerGDPRDataManager.orderHeader setObject:descrDetailDict forKey:@"callType"];
        [self.customerGDPRDataManager.orderHeader setObject:[descrDetailDict objectForKey:@"Detail"] forKey:@"callTypeText"];        
    } else {
        [ArcosUtils showDialogBox:@"GDPR Call Type not found" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (![self.customerGDPRDataManager tickSelectedCondition]) {
        [ArcosUtils showDialogBox:@"Please Confirm or Withdraw Consent" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    NSPredicate* predicateGDPR = [NSPredicate predicateWithFormat:@"DescrTypeCode='L1' and DescrDetailCode = 'GDPR'"];
    NSMutableArray* objectListGDPR = [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicateGDPR sortByArray:sortArray];
    if ([objectListGDPR count] <= 0) {
        [ArcosUtils showDialogBox:self.customerGDPRDataManager.configErrorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    NSDictionary* descrDetailDictGDPR = [objectListGDPR objectAtIndex:0];
    self.customerGDPRDataManager.detailIUR = [descrDetailDictGDPR objectForKey:@"DescrDetailIUR"];
    NSNumber* selectedIUR = [self.customerGDPRDataManager tickSelectedIUR];
    switch ([selectedIUR intValue]) {
        case 10: {
//            NSPredicate* predicateCONSENT = [NSPredicate predicateWithFormat:@"DescrTypeCode='SC' and DescrDetailCode = 'CONSENT'"];
//            NSMutableArray* objectListCONSENT = [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicateCONSENT sortByArray:sortArray];
            NSMutableArray* objectListCONSENT = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:@"SC" descrDetailCode:@"CONSENT"];
            if ([objectListCONSENT count] <= 0) {
                [ArcosUtils showDialogBox:self.customerGDPRDataManager.configErrorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return;
            }
            NSDictionary* descrDetailDictCONSENT = [objectListCONSENT objectAtIndex:0];
//            NSLog(@"aax %@", descrDetailDictCONSENT);
            self.customerGDPRDataManager.score = [descrDetailDictCONSENT objectForKey:@"DescrDetailIUR"];
            self.customerGDPRDataManager.tooltip = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[descrDetailDictCONSENT objectForKey:@"Tooltip"]]];
        }            
            break;
        case 20: {
//            NSPredicate* predicateWITHDRAWN = [NSPredicate predicateWithFormat:@"DescrTypeCode='SC' and DescrDetailCode = 'WITHDRAWN'"];
//            NSMutableArray* objectListWITHDRAWN = [[ArcosCoreData sharedArcosCoreData] descrDetailWithPredicate:predicateWITHDRAWN sortByArray:sortArray];
            NSMutableArray* objectListWITHDRAWN = [[ArcosCoreData sharedArcosCoreData] descrDetailAllFieldsWithDescrTypeCode:@"SC" descrDetailCode:@"WITHDRAWN"];
            if ([objectListWITHDRAWN count] <= 0) {
                [ArcosUtils showDialogBox:self.customerGDPRDataManager.configErrorMsg title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                    
                }];
                return;
            }
            NSDictionary* descrDetailDictWITHDRAWN = [objectListWITHDRAWN objectAtIndex:0];
            self.customerGDPRDataManager.score = [descrDetailDictWITHDRAWN objectForKey:@"DescrDetailIUR"];
            self.customerGDPRDataManager.tooltip = [ArcosUtils trim:[ArcosUtils convertNilToEmpty:[descrDetailDictWITHDRAWN objectForKey:@"Tooltip"]]];
        }
            break;
        default:
            break;
    }    
        
    if (!([self.drawingAreaView.listOfLines count] > 0)) {
        [ArcosUtils showDialogBox:@"Please enter signature" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    if (![self.customerGDPRDataManager contactSelectedCondition]) {
        void (^yesActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            
        };
        void (^noActionHandler)(UIAlertAction *) = ^(UIAlertAction *action){
            [self gdprSaveProcessor];
        };
        [ArcosUtils showTwoBtnsDialogBox:@"Would you like to assign a Contact" title:@"" delegate:nil target:self tag:0 lBtnText:@"NO" rBtnText:@"YES" lBtnHandler:noActionHandler rBtnHandler:yesActionHandler];
        return;
    }               
    [self gdprSaveProcessor];
}

- (void)gdprSaveProcessor {
    [FileCommon createFolder:@"photos"];
    NSNumber* orderNumber = [[GlobalSharedClass shared] currentTimeStamp];
//    NSString* fileName = [NSString stringWithFormat:@"GDPR_%@.jpg", orderNumber];
    NSString* fileName = [NSString stringWithFormat:@"%@-%d-%d.jpg", [ArcosUtils stringFromDate:[NSDate date] format:@"ddyyMMHHmm"],[self.customerGDPRDataManager.locationIUR intValue], [[self.customerGDPRDataManager.contactDict objectForKey:@"IUR"] intValue]];
    NSString* imageJpgPath = [NSString stringWithFormat:@"%@/%@",[FileCommon photosPath], fileName];
    UIImage* auxImage = [ArcosUtils screenshotFromView:self.view];
    BOOL jpgImageSaved = [UIImageJPEGRepresentation(auxImage, 1.0) writeToFile:imageJpgPath atomically:YES];
    if (!jpgImageSaved) {
        [ArcosUtils showDialogBox:@"Screenshot not saved" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    ArcosCallTran* aCalltran = [[ArcosCallTran alloc] init];
    
    aCalltran.ProductIUR = 0;
    aCalltran.DetailIUR = [self.customerGDPRDataManager.detailIUR intValue];
    aCalltran.Score = [self.customerGDPRDataManager.score intValue];
    aCalltran.DetailLevel = @"DT";
    aCalltran.DTIUR = 0;
    aCalltran.Reference = fileName;    
    
    [self.customerGDPRDataManager.callTranList addObject:aCalltran];
    [aCalltran release];
    
    [[ArcosCoreData sharedArcosCoreData] insertCollectedWithLocationIUR:self.customerGDPRDataManager.locationIUR comments:fileName iUR:[NSNumber numberWithInt:-1] date:[NSDate date]];
    NSMutableDictionary* order = [NSMutableDictionary dictionary];
    [order setObject:self.customerGDPRDataManager.locationIUR forKey:@"LocationIUR"];
    [order setObject:[SettingManager SettingForKeypath:@"PersonalSetting.Personal" atIndex:0]
              forKey:@"EmployeeIUR"];
    
    [self.customerGDPRDataManager.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"NumberOflines"];
    [self.customerGDPRDataManager.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"TotalGoods"];
    [self.customerGDPRDataManager.orderHeader setObject:[NSNumber numberWithInt:0] forKey:@"TotalVat"];
    if (self.customerGDPRDataManager.contactDict == nil) {
        [self.customerGDPRDataManager.orderHeader setObject:[[GlobalSharedClass shared] createUnAssignedContact] forKey:@"contact"];
    } else {
        [self.customerGDPRDataManager.orderHeader setObject:self.customerGDPRDataManager.contactDict forKey:@"contact"];
    }    
    
    [order setObject:self.customerGDPRDataManager.orderHeader forKey:@"OrderHeader"];
    [order setObject:[NSMutableDictionary dictionary] forKey:@"OrderLines"];
    [order setObject:self.customerGDPRDataManager.callTranList forKey:@"CallTrans"];
    [order setObject:@"" forKey:@"CustomerRef"];
    [order setObject:[NSNumber numberWithInt:0] forKey:@"FormIUR"];    
    [order setObject:orderNumber forKey:@"OrderNumber"];
    BOOL isSuccess = [[ArcosCoreData sharedArcosCoreData] saveOrder:order];
    if (isSuccess) {
        @try {
            if (![self.customerGDPRDataManager.tooltip isEqualToString:@""]) {
                if ([self.customerGDPRDataManager.tooltip hasPrefix:@"CSIUR="]) {
                    NSString* csIUR = [self.customerGDPRDataManager.tooltip substringFromIndex:6];
                    if ([ArcosValidator isInteger:csIUR]) {
                        [[ArcosCoreData sharedArcosCoreData] updateLocationWithFieldName:@"CSiur" withActualContent:[ArcosUtils convertStringToNumber:csIUR] withLocationIUR:self.customerGDPRDataManager.locationIUR];
                        [self.refreshDelegate refreshParentContentByEdit];
                    }
                } else if ([self.customerGDPRDataManager.tooltip hasPrefix:@"LSIUR="]) {
                    NSString* lsIUR = [self.customerGDPRDataManager.tooltip substringFromIndex:6];
                    if ([ArcosValidator isInteger:lsIUR]) {
                        [[ArcosCoreData sharedArcosCoreData] updateLocationWithFieldName:@"lsiur" withActualContent:[ArcosUtils convertStringToNumber:lsIUR] withLocationIUR:self.customerGDPRDataManager.locationIUR];
                        [self.refreshDelegate refreshParentContentByEdit];
                    }
                }
            }
        } @catch (NSException *exception) {
            [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
        [ArcosUtils showDialogBox:@"GDPR Status saved" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            [self.animateDelegate dismissSlideAcrossViewAnimation];
        }];
    } else {
        [ArcosUtils showDialogBox:@"GDPR Status not saved" title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
        }];
    }
}

- (void)dealloc {
    self.locationNameLabel = nil;
    self.locationAddress = nil;
    self.dateTitleLabel = nil;
    self.dateContentLabel = nil;
    self.timeTitleLabel = nil;
    self.timeContentLabel = nil;
    self.myWebView = nil;
    self.myTableView = nil;
    self.drawingAreaView = nil;
    self.signatureHintLabel = nil;
    self.tapToSelectContactNameBtn = nil;
    self.fileURL = nil;
    self.customerGDPRDataManager = nil;
    self.saveButton = nil;
    self.factory = nil;
    self.thePopover = nil;
    self.callGenericServices.delegate = nil;
    self.callGenericServices = nil;
    self.myEmailAddressLabel = nil;
    self.amendContactButton = nil;
    self.globalNavigationController = nil;
    self.rootView = nil;
    self.mailController = nil;
    
    [super dealloc];
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        [self.myWebView loadRequest:[NSURLRequest requestWithURL:self.fileURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];        
//    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
//        
//    }];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.    
    return  [self.customerGDPRDataManager.displayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"IdCustomerGDPRTableCell";
    CustomerGDPRTableCell* cell = (CustomerGDPRTableCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"CustomerGDPRTableCell" owner:self options:nil];
        
        for (id nibItem in nibContents) {
            if ([nibItem isKindOfClass:[CustomerGDPRTableCell class]] && [[(CustomerGDPRTableCell *)nibItem reuseIdentifier] isEqualToString: CellIdentifier]) {
                cell = (CustomerGDPRTableCell *) nibItem;                
            }
        }
    }
    cell.actionDelegate = self;
    NSMutableDictionary* cellData = [self.customerGDPRDataManager.displayList objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    [cell configCellWithData:cellData];
    
    return cell;
}

- (void)radioButtonPressedWithIndexPath:(NSIndexPath *)anIndexPath {
    for (int i = 0; i < [self.customerGDPRDataManager.displayList count]; i++) {
        NSMutableDictionary* tmpCellData = [self.customerGDPRDataManager.displayList objectAtIndex:i];
        [tmpCellData setObject:[NSNumber numberWithBool:NO] forKey:@"TickFlag"];
    }
    NSMutableDictionary* cellData = [self.customerGDPRDataManager.displayList objectAtIndex:anIndexPath.row];
    [cellData setObject:[NSNumber numberWithBool:![[cellData objectForKey:@"TickFlag"] boolValue]] forKey:@"TickFlag"];
    [self.myTableView reloadData];
    [self checkDrawingAreaView];
}

- (IBAction)tapToSelectContactNameButtonPressed:(id)sender {    
    if (self.factory == nil) {
        self.factory = [WidgetFactory factory];
        self.factory.delegate = self;
    }
    NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] orderContactsWithLocationIUR:self.customerGDPRDataManager.locationIUR];
    [contactList insertObject:[[GlobalSharedClass shared] createUnAssignedContact] atIndex:0];
    NSMutableDictionary* miscDataDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [miscDataDict setObject:@"Contact" forKey:@"Title"];
    [miscDataDict setObject:self.customerGDPRDataManager.locationIUR forKey:@"LocationIUR"];
    [miscDataDict setObject:self.customerGDPRDataManager.locationName forKey:@"Name"];
    self.thePopover = [self.factory CreateTargetGenericCategoryWidgetWithPickerValue:contactList miscDataDict:miscDataDict];
    if (self.thePopover != nil) {
        self.thePopover.delegate = self;
        [self.thePopover presentPopoverFromRect:self.tapToSelectContactNameBtn.bounds inView:self.tapToSelectContactNameBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)operationDone:(id)data {
    [self.thePopover dismissPopoverAnimated:YES];
    NSString* contactTitle = [data objectForKey:@"Title"];
    [self.tapToSelectContactNameBtn setTitle:contactTitle forState:UIControlStateNormal];
    self.customerGDPRDataManager.contactDict = data;
    self.myEmailAddressLabel.text = [ArcosUtils convertNilToEmpty:[data objectForKey:@"Email"]];
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

- (BOOL)allowToShowAddContactButton {
    return YES;    
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.thePopover = nil;
    self.factory.popoverController = nil;
}

- (void)checkDrawingAreaView {
    if ([self.customerGDPRDataManager enableSignatureAmendment]) {
        self.drawingAreaView.userInteractionEnabled = YES;
    } else {
        self.drawingAreaView.userInteractionEnabled = NO;
    }
}

- (IBAction)amendContactButtonPressed:(id)sender {
    if ([[self.customerGDPRDataManager.contactDict objectForKey:@"IUR"] intValue] == 0) {
        [ArcosUtils showDialogBox:@"Please select a contact" title:@"" delegate:nil target:self tag:0 handler:nil];
        return;
    }
    CustomerContactWrapperModalViewController* ccwmvc = [[CustomerContactWrapperModalViewController alloc] initWithNibName:@"CustomerContactWrapperModalViewController" bundle:nil];
    ccwmvc.tableCellData = self.customerGDPRDataManager.contactDict;
    //    NSLog(@"ccwmvc.tableCellData: %@", ccwmvc.tableCellData);
    ccwmvc.actionType = @"edit";
    ccwmvc.myDelegate = self;
//    ccwmvc.delegate = self;
    ccwmvc.refreshDelegate = self;
    ccwmvc.actionDelegate = self;
    ccwmvc.navgationBarTitle = [NSString stringWithFormat:@"Contact Details for %@", [ccwmvc.tableCellData objectForKey:@"Title"]];
    ccwmvc.locationIUR = self.customerGDPRDataManager.locationIUR;
    ccwmvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
    self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:ccwmvc] autorelease];
    CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.rootView];
    self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
    [self.rootView addChildViewController:self.globalNavigationController];
    [self.rootView.view addSubview:self.globalNavigationController.view];
    [self.globalNavigationController didMoveToParentViewController:self.rootView];
    [ccwmvc release];
    [UIView animateWithDuration:0.3f animations:^{
        self.globalNavigationController.view.frame = parentNavigationRect;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark GenericRefreshParentContentDelegate
- (void)refreshParentContent {
    NSMutableDictionary* tmpContactDict = [[ArcosCoreData sharedArcosCoreData] compositeContactWithIUR:[self.customerGDPRDataManager.contactDict objectForKey:@"IUR"]];
    self.customerGDPRDataManager.contactDict = tmpContactDict;
    self.myEmailAddressLabel.text = [ArcosUtils convertNilToEmpty:[tmpContactDict objectForKey:@"Email"]];
}

#pragma mark CustomisePresentViewControllerDelegate
- (void)didDismissCustomisePresentView {
    [self didDismissViewControllerProcessor];
}

- (void)didDismissViewControllerProcessor {
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

#pragma mark CustomerInfoAccessTimesCalendarTableViewControllerDelegate
- (void)refreshLocationInfoFromAccessTimesCalendar {
    
}
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString* auxScheme = [[[request URL] scheme] lowercaseString];
        if ([auxScheme isEqualToString:@"http"] || [auxScheme isEqualToString:@"https"]) {
            PresenterPdfLinkWebViewController* pplwvc = [[PresenterPdfLinkWebViewController alloc] initWithNibName:@"PresenterPdfLinkWebViewController" bundle:nil];
            pplwvc.linkURL = [request URL];
            [self.navigationController pushViewController:pplwvc animated:YES];
            [pplwvc release];
        } else if ([auxScheme isEqualToString:@"mailto"]) {
            NSString* emailAddress = @"";
            @try {
                emailAddress = [[[request URL] absoluteString] substringFromIndex:7];
            } @catch (NSException *exception) {
                [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:self tag:0 handler:nil];
            }
            NSMutableArray* toRecipients = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@", emailAddress], nil];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
//                    amwvc.myDelegate = self;
                amwvc.mailDelegate = self;
                amwvc.toRecipients = toRecipients;
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
                    
                }];
                return NO;
            }
            if (![ArcosEmailValidator checkCanSendMailStatus:self]) return NO;
            self.mailController = [[[MFMailComposeViewController alloc] init] autorelease];
            self.mailController.mailComposeDelegate = self;
            
            [self.mailController setToRecipients:toRecipients];
            [self.rootView presentViewController:self.mailController animated:YES completion:nil];
        } else {
            [ArcosUtils showDialogBox:[NSString stringWithFormat:@"Invalid scheme found.\n%@", [[request URL] absoluteString]] title:@"" delegate:nil target:self tag:0 handler:nil];
        }
        return NO;
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
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

#pragma mark MFMailComposeViewControllerDelegate
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
        [ArcosUtils showDialogBox:message title:title delegate:self target:controller tag:99 handler:^(UIAlertAction *action) {
            [self alertViewCallBack];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self alertViewCallBack];
}

- (void)alertViewCallBack {
    [self.rootView dismissViewControllerAnimated:YES completion:^ {
        self.mailController = nil;
    }];
}

@end
