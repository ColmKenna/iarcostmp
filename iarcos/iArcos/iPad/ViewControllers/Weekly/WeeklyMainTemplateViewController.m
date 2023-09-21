//
//  WeeklyMainTemplateViewController.m
//  iArcos
//
//  Created by David Kilmartin on 21/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "WeeklyMainTemplateViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ArcosRootViewController.h"

@interface WeeklyMainTemplateViewController ()

- (void)navigationTitleWrapper:(NSString*)aDateString;
- (BOOL)validatePresentationPopover;
- (void)alertViewCallBack;
- (void)saveButtonCallBack;

@end

@implementation WeeklyMainTemplateViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
//@synthesize childTemplateView = _childTemplateView;
@synthesize cwmmvc = _cwmmvc;
@synthesize weeklyDayPartsViewController = _weeklyDayPartsViewController;
@synthesize layoutDict = _layoutDict;
@synthesize weeklyMainTemplateDataManager = _weeklyMainTemplateDataManager;
@synthesize employeeButton = _employeeButton;
@synthesize cameraRollButton = _cameraRollButton;
@synthesize employeeTableWidgetViewController = _employeeTableWidgetViewController;
@synthesize cameraRollImagePickerController = _cameraRollImagePickerController;
@synthesize callGenericServices = _callGenericServices;
@synthesize globalNavigationController = _globalNavigationController;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize weeklyMainEmailProcessCenter = _weeklyMainEmailProcessCenter;
@synthesize mailComposeViewController = _mailComposeViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) {
        self.weeklyMainTemplateDataManager = [[[WeeklyMainTemplateDataManager alloc] init] autorelease];
        self.cwmmvc = [[[CustomerWeeklyMainModalViewController alloc] initWithNibName:@"CustomerWeeklyMainModalViewController" bundle:nil] autorelease];
        self.cwmmvc.weeklyMainTemplateDataManager = self.weeklyMainTemplateDataManager;
        self.weeklyDayPartsViewController = [[[WeeklyDayPartsViewController alloc] initWithNibName:@"WeeklyDayPartsViewController" bundle:nil] autorelease];
        self.weeklyDayPartsViewController.weeklyMainTemplateDataManager = self.weeklyMainTemplateDataManager;
        self.layoutDict = @{@"AuxWeeklyNotes" : self.cwmmvc.view, @"AuxWeeklyDayParts" : self.weeklyDayPartsViewController.view};
        self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
        self.weeklyMainEmailProcessCenter = [[[WeeklyMainEmailProcessCenter alloc] init] autorelease];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ArcosUtils configEdgesForExtendedLayout:self];
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
        
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
    
    [self addChildViewController:self.weeklyDayPartsViewController];
    [self.templateView addSubview:self.weeklyDayPartsViewController.view];
    [self.weeklyDayPartsViewController didMoveToParentViewController:self];
    [self.weeklyDayPartsViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxWeeklyDayParts]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxWeeklyDayParts]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
        
    [self addChildViewController:self.cwmmvc];
    [self.templateView addSubview:self.cwmmvc.view];
    [self.cwmmvc didMoveToParentViewController:self];
    [self.cwmmvc.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[AuxWeeklyNotes]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[AuxWeeklyNotes]-(0)-|" options:0 metrics:0 views:self.layoutDict]];
    
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    self.weeklyMainTemplateDataManager.dayOfWeekend = [self.weeklyMainTemplateDataManager getDayOfWeekend];
    self.weeklyMainTemplateDataManager.rowPointer = 0;
    self.weeklyMainTemplateDataManager.employeeIUR = [SettingManager employeeIUR];
    self.weeklyMainTemplateDataManager.employeeDict = [[ArcosCoreData sharedArcosCoreData] employeeWithIUR:self.weeklyMainTemplateDataManager.employeeIUR];
    self.weeklyMainTemplateDataManager.employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[self.weeklyMainTemplateDataManager.employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[self.weeklyMainTemplateDataManager.employeeDict objectForKey:@"Surname"]]];
    UIBarButtonItem* prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStylePlain target:self action:@selector(prevPressed:)];
    NSMutableArray* leftButtonList = [NSMutableArray arrayWithCapacity:2];
    [leftButtonList addObject:prevButton];
    
    NSNumber* securityLevel = [self.weeklyMainTemplateDataManager.employeeDict objectForKey:@"SecurityLevel"];
    self.employeeButton = [[[UIBarButtonItem alloc] initWithTitle:@"Employee" style:UIBarButtonItemStylePlain target:self action:@selector(employeePressed:)] autorelease];
    if ([securityLevel intValue] > 95) {
        [leftButtonList addObject:self.employeeButton];
        self.weeklyMainTemplateDataManager.employeeDetailList = [[ArcosCoreData sharedArcosCoreData] allEmployee];
    }
    
    [self.navigationItem setLeftBarButtonItems:leftButtonList];
    [prevButton release];
    
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextPressed:)];
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
    
    UIBarButtonItem* emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailPressed:)];
    self.cameraRollButton = [[[UIBarButtonItem alloc] initWithTitle:@"Camera Roll" style:UIBarButtonItemStylePlain target:self action:@selector(cameraRollPressed:)] autorelease];
    
    NSMutableArray* rightButtonList = [NSMutableArray arrayWithCapacity:4];  
    
    [rightButtonList addObject:saveButton];
    [rightButtonList addObject:nextButton];
    [rightButtonList addObject:emailButton];
    [rightButtonList addObject:self.cameraRollButton];
    [self.navigationItem setRightBarButtonItems:rightButtonList];    
    [saveButton release];
    [nextButton release];
    [emailButton release];
    
    self.weeklyMainTemplateDataManager.currentWeekendDate = [self.weeklyMainTemplateDataManager weekendOfWeek:[NSDate date] config:[self.weeklyMainTemplateDataManager.dayOfWeekend integerValue]];
    self.weeklyMainTemplateDataManager.highestAllowedWeekendDate = [self.weeklyMainTemplateDataManager weekendOfWeek:[NSDate date] config:[self.weeklyMainTemplateDataManager.dayOfWeekend integerValue]];
    [self navigationTitleWrapper:[ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    
//    self.weeklyMainTemplateDataManager.sectionTitleDictList = [self.weeklyMainTemplateDataManager retrieveSectionTitleDictList];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    self.callGenericServices.delegate = self;
}

- (void)dealloc {
    [self.cwmmvc willMoveToParentViewController:nil];
    [self.cwmmvc.view removeFromSuperview];
    [self.cwmmvc removeFromParentViewController];
    [self.weeklyDayPartsViewController willMoveToParentViewController:nil];
    [self.weeklyDayPartsViewController.view removeFromSuperview];
    [self.weeklyDayPartsViewController removeFromParentViewController];     
    self.layoutDict = nil;
    self.cwmmvc = nil;
    self.weeklyDayPartsViewController = nil;
    self.mySegmentedControl = nil;
//    self.childTemplateView = nil;
    self.templateView = nil;
    self.employeeButton = nil;
    self.cameraRollButton = nil;
    self.employeeTableWidgetViewController = nil;
    self.cameraRollImagePickerController = nil;
    self.callGenericServices = nil;
    self.globalNavigationController = nil;
    self.arcosRootViewController = nil;
    self.weeklyMainEmailProcessCenter = nil;
    self.mailComposeViewController = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.callGenericServices refreshHUDViewFrame:self.navigationController.view];
    [self queryWeeklyRecord:self.weeklyMainTemplateDataManager.currentWeekendDate];
}

- (void)queryWeeklyRecord:(NSDate*)aCurrentWeekendDate {
    NSString* sqlStatement = [NSString stringWithFormat:@"select IUR,EmployeeIUR,WeekEndDate,Narrative1,Narrative2,Narrative3,Narrative4,Day1AM,Day1PM,Day2AM,Day2PM,Day3AM,Day3PM,Day4AM,Day4PM,Day5AM,Day5PM,Day6AM,Day6PM,Day7AM,Day7PM from Weekly where EmployeeIUR = %d and WeekEndDate = convert(datetime, '%@', 103)", [self.weeklyMainTemplateDataManager.employeeIUR intValue], [ArcosUtils stringFromDate:aCurrentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    //    NSLog(@"%@", sqlStatement);
    self.callGenericServices.isNotRecursion = YES;
    [self.callGenericServices getData: sqlStatement];
}

#pragma mark - GetDataGenericDelegate
-(void)setGetDataResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        return;
    }
    if (result.ErrorModel.Code > 0) {
        [self.weeklyMainTemplateDataManager processRawData:result.ArrayOfData];
        [self.cwmmvc.tableView reloadData];
        [self.weeklyDayPartsViewController reloadDayPartsData];
    } else if(result.ErrorModel.Code <= 0) {
        if (result.ErrorModel.Code < 0) {
//            [ArcosUtils showMsg:result.ErrorModel.Code message:result.ErrorModel.Message delegate:nil];
            [ArcosUtils showDialogBox:result.ErrorModel.Message title:[ArcosUtils retrieveTitleWithCode:result.ErrorModel.Code] target:self handler:nil];
        }
        [self.weeklyMainTemplateDataManager createBasicData];
        [self.weeklyMainTemplateDataManager assignDefaultDayPartsAfterBasicData];
        [self.cwmmvc.tableView reloadData];
        [self.weeklyDayPartsViewController reloadDayPartsData];
    }
}

- (void)segmentedAction {
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.weeklyDayPartsViewController.view.hidden = YES;            
            self.cwmmvc.view.hidden = NO;
        }            
            break;
            
        case 1: {                        
            self.cwmmvc.view.hidden = YES;
            self.weeklyDayPartsViewController.view.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)navigationTitleWrapper:(NSString*)aDateString {
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@: %@", self.weeklyMainTemplateDataManager.employeeName, aDateString]];
}

-(void)prevPressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    [self.view endEditing:YES];
    [self.weeklyMainTemplateDataManager reinitiateAttachmentAuxiObject];
    self.weeklyMainTemplateDataManager.currentWeekendDate = [ArcosUtils prevSunday:self.weeklyMainTemplateDataManager.currentWeekendDate];
    [self navigationTitleWrapper:[ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    [self queryWeeklyRecord:self.weeklyMainTemplateDataManager.currentWeekendDate];
}

- (void)employeePressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    self.employeeTableWidgetViewController = [[[TableWidgetViewController alloc] initWithDataList:self.weeklyMainTemplateDataManager.employeeDetailList withTitle:@"Employee" withParentContentString:self.weeklyMainTemplateDataManager.employeeName] autorelease];
    self.employeeTableWidgetViewController.delegate = self;
    self.employeeTableWidgetViewController.modalPresentationStyle = UIModalPresentationPopover;
    self.employeeTableWidgetViewController.popoverPresentationController.barButtonItem = self.employeeButton;
    self.employeeTableWidgetViewController.popoverPresentationController.delegate = self;
    [self presentViewController:self.employeeTableWidgetViewController animated:YES completion:^{
        
    }];
}

- (void)nextPressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    [self.view endEditing:YES];
    self.weeklyMainTemplateDataManager.currentWeekendDate = [ArcosUtils nextSunday:self.weeklyMainTemplateDataManager.currentWeekendDate];
//    NSComparisonResult dateCompareResult = [self.weeklyMainTemplateDataManager.currentWeekendDate compare:self.weeklyMainTemplateDataManager.highestAllowedWeekendDate];
//    if (dateCompareResult == NSOrderedDescending) {
//        self.weeklyMainTemplateDataManager.currentWeekendDate = [ArcosUtils prevSunday:self.weeklyMainTemplateDataManager.currentWeekendDate];
//        [ArcosUtils showMsg:-1 message:@"It is not allowed to fill out the weekly report on the date that is bigger than the day of weekend of the current week." delegate:nil];
//        return;
//    }
    [self.weeklyMainTemplateDataManager reinitiateAttachmentAuxiObject];
    [self navigationTitleWrapper:[ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    [self queryWeeklyRecord:self.weeklyMainTemplateDataManager.currentWeekendDate];
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"dismiss triggered");
    self.employeeTableWidgetViewController = nil;
    self.cameraRollImagePickerController = nil;
}

#pragma mark WidgetViewControllerDelegate
- (void)operationDone:(id)data {
    NSNumber* selectedEmployeeIUR = [data objectForKey:@"IUR"];
    if ([selectedEmployeeIUR compare:self.weeklyMainTemplateDataManager.employeeIUR] == NSOrderedSame) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.employeeTableWidgetViewController = nil;
        }];
        return;
    }
    [self.weeklyMainTemplateDataManager reinitiateAttachmentAuxiObject];
    self.weeklyMainTemplateDataManager.employeeIUR = [data objectForKey:@"IUR"];
    self.weeklyMainTemplateDataManager.employeeDict = data;
    self.weeklyMainTemplateDataManager.employeeName = [NSString stringWithFormat:@"%@ %@", [ArcosUtils convertNilToEmpty:[self.weeklyMainTemplateDataManager.employeeDict objectForKey:@"ForeName"]], [ArcosUtils convertNilToEmpty:[self.weeklyMainTemplateDataManager.employeeDict objectForKey:@"Surname"]]];
    [self navigationTitleWrapper:[ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    [self queryWeeklyRecord:self.weeklyMainTemplateDataManager.currentWeekendDate];
    [self dismissViewControllerAnimated:YES completion:^{
        self.employeeTableWidgetViewController = nil;
    }];
}

- (void)dismissPopoverController {
    [self dismissViewControllerAnimated:YES completion:^{
        self.employeeTableWidgetViewController = nil;
    }];
}

- (void)cameraRollPressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    self.cameraRollImagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    self.cameraRollImagePickerController.delegate = self;
    self.cameraRollImagePickerController.modalPresentationStyle = UIModalPresentationPopover;
    self.cameraRollImagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.cameraRollImagePickerController.mediaTypes = @[(NSString*)kUTTypeImage];
    self.cameraRollImagePickerController.popoverPresentationController.barButtonItem = self.cameraRollButton;
    self.cameraRollImagePickerController.popoverPresentationController.delegate = self;
    [self presentViewController:self.cameraRollImagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    @try {
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg",[GlobalSharedClass shared].currentTimeStamp];
        [self.weeklyMainTemplateDataManager.attachmentFileNameList addObject:fileName];
        [self.weeklyMainTemplateDataManager.attachmentFileContentList addObject:UIImageJPEGRepresentation(image, 1.0)];
        [ArcosUtils showDialogBox:@"The photo has been attached." title:@"" delegate:nil target:picker tag:0 handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.cameraRollImagePickerController = nil;
            }];
        }];
    }
    @catch (NSException *exception) {
        [ArcosUtils showDialogBox:[exception reason] title:@"" delegate:nil target:picker tag:0 handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.cameraRollImagePickerController = nil;
            }];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        self.cameraRollImagePickerController = nil;
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (BOOL)validatePresentationPopover {
    if (self.employeeTableWidgetViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.employeeTableWidgetViewController = nil;
        }];
        return NO;
    }
    if (self.cameraRollImagePickerController != nil) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.cameraRollImagePickerController = nil;
        }];
        return NO;
    }
    return YES;
}

-(void)emailPressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    NSString* subject = [NSString stringWithFormat:@"Weekly Report from %@ for Week Ending %@", self.weeklyMainTemplateDataManager.employeeName, [ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    NSString* body = [self.weeklyMainEmailProcessCenter buildEmailMessageWithDataManager:self.weeklyMainTemplateDataManager];    
    if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useMailLibFlag] || [[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
        ArcosMailWrapperViewController* amwvc = [[ArcosMailWrapperViewController alloc] initWithNibName:@"ArcosMailWrapperViewController" bundle:nil];
        //        amwvc.myDelegate = self;
        amwvc.mailDelegate = self;
        amwvc.subjectText = subject;
        amwvc.bodyText = body;
        amwvc.isHTML = YES;
        for (int i = 0; i < [self.weeklyMainTemplateDataManager.attachmentFileNameList count]; i++) {
            NSData* tmpFileData = [self.weeklyMainTemplateDataManager.attachmentFileContentList objectAtIndex:i];
            NSString* tmpFileName = [self.weeklyMainTemplateDataManager.attachmentFileNameList objectAtIndex:i];
            if ([[ArcosConfigDataManager sharedArcosConfigDataManager] useOutlookFlag]) {
                [amwvc.attachmentList addObject:[ArcosAttachmentContainer attachmentWithData:tmpFileData fileName:tmpFileName]];
            } else {
                [amwvc.attachmentList addObject:[MCOAttachment attachmentWithData:tmpFileData filename:tmpFileName]];
            }
            
        }
        amwvc.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:.5f];
        self.globalNavigationController = [[[UINavigationController alloc] initWithRootViewController:amwvc] autorelease];
        CGRect parentNavigationRect = [ArcosUtils getCorrelativeRootViewRect:self.arcosRootViewController];
        self.globalNavigationController.view.frame = CGRectMake(0, parentNavigationRect.size.height, parentNavigationRect.size.width, parentNavigationRect.size.height);
        [self.arcosRootViewController addChildViewController:self.globalNavigationController];
        [self.arcosRootViewController.view addSubview:self.globalNavigationController.view];
        [self.globalNavigationController didMoveToParentViewController:self.arcosRootViewController];
        [amwvc release];
        [UIView animateWithDuration:0.3f animations:^{
            self.globalNavigationController.view.frame = parentNavigationRect;
        } completion:^(BOOL finished){
            
        }];
        return;
    }
    if (![ArcosEmailValidator checkCanSendMailStatus:self]) return;
    self.mailComposeViewController = [[[MFMailComposeViewController alloc] init] autorelease];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:subject];
    [self.mailComposeViewController setMessageBody:body isHTML:YES];
    for (int i = 0; i < [self.weeklyMainTemplateDataManager.attachmentFileNameList count]; i++) {
        NSData* tmpFileData = [self.weeklyMainTemplateDataManager.attachmentFileContentList objectAtIndex:i];
        NSString* tmpFileName = [self.weeklyMainTemplateDataManager.attachmentFileNameList objectAtIndex:i];
        [self.mailComposeViewController addAttachmentData:tmpFileData mimeType:@"image/jpg" fileName:tmpFileName];
    }
    //    [self.rootView setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self.arcosRootViewController presentViewController:self.mailComposeViewController animated:YES completion:nil];
    
}

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

- (void)alertViewCallBack {
    [self.arcosRootViewController dismissViewControllerAnimated:YES completion:^ {
        self.mailComposeViewController = nil;
    }];
}

#pragma mark ArcosMailTableViewControllerDelegate
- (void)arcosMailDidFinishWithResult:(ArcosMailComposeResult)aResult error:(NSError *)anError {
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

-(void)savePressed:(id)sender {
    if (![self validatePresentationPopover]) return;
    [self.view endEditing:YES];
//    if (![self.weeklyMainTemplateDataManager checkValidation]) {
//        [ArcosUtils showDialogBox:@"Please fill out at least one of these fields." title:[GlobalSharedClass shared].errorTitle delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
//
//        }];
//        return;
//    }
    if ([self.weeklyMainTemplateDataManager isNewRecord]) {
        [self createWeeklyRecord];
    } else {        
        [self.weeklyMainTemplateDataManager getChangedDataList];
        //        NSLog(@"updatedFieldNameList %@", customerWeeklyMainDataManager.updatedFieldNameList);
        //        NSLog(@"updatedFieldValueList %@", customerWeeklyMainDataManager.updatedFieldValueList);
        if ([self.weeklyMainTemplateDataManager.updatedFieldNameList count] == 0) {
            [ArcosUtils showDialogBox:@"There is no change." title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
                
            }];
            return;
        }
        self.weeklyMainTemplateDataManager.rowPointer = 0;
        self.callGenericServices.isNotRecursion = NO;
        [self updateWeeklyRecord];         
    }
}

-(void)createWeeklyRecord {
    [self.weeklyMainTemplateDataManager prepareForCreateWeeklyRecord];
    [self.weeklyMainTemplateDataManager.fieldNameList addObject:@"EmployeeIUR"];
    [self.weeklyMainTemplateDataManager.fieldValueList addObject:[self.weeklyMainTemplateDataManager.employeeIUR stringValue]];
    [self.weeklyMainTemplateDataManager.fieldNameList addObject:@"WeekEndDate"];
    [self.weeklyMainTemplateDataManager.fieldValueList addObject:[ArcosUtils stringFromDate:self.weeklyMainTemplateDataManager.currentWeekendDate format:[GlobalSharedClass shared].dateFormat]];
    self.weeklyMainTemplateDataManager.arcosCreateRecordObject.FieldNames = self.weeklyMainTemplateDataManager.fieldNameList;
    self.weeklyMainTemplateDataManager.arcosCreateRecordObject.FieldValues = self.weeklyMainTemplateDataManager.fieldValueList;
    self.callGenericServices.isNotRecursion = YES;
    [self.callGenericServices createRecord:@"Weekly" fields:self.weeklyMainTemplateDataManager.arcosCreateRecordObject];
}

-(void)setCreateRecordResult:(ArcosGenericClass*) result {
    if (result == nil) {
        return;
    }
    if ([result.Field1 isEqualToString:@"0"]) {
        [ArcosUtils showDialogBox:result.Field2 title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
        return;
    }
    [ArcosUtils showDialogBox:@"Completed" title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
        [self saveButtonCallBack];
    }];
}

- (void)saveButtonCallBack {
    self.weeklyMainTemplateDataManager.rowPointer = 0;
    int itemIndex = [self.arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    [self.arcosRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
}

#pragma mark UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 99) {
//        [self alertViewCallBack];
//    }
//    if (alertView.tag == 77) {
//        [self saveButtonCallBack];
//    }
//}

-(void)updateWeeklyRecord {
    if (self.weeklyMainTemplateDataManager.rowPointer == [self.weeklyMainTemplateDataManager.updatedFieldNameList count]) return;
    [self.callGenericServices updateRecord:@"Weekly" iur:[self.weeklyMainTemplateDataManager.iur intValue] fieldName:[self.weeklyMainTemplateDataManager.updatedFieldNameList objectAtIndex:self.weeklyMainTemplateDataManager.rowPointer] newContent:[self.weeklyMainTemplateDataManager.updatedFieldValueList objectAtIndex:self.weeklyMainTemplateDataManager.rowPointer]];    
}

-(void)setUpdateRecordResult:(ArcosGenericReturnObject*) result {
    if (result == nil) {
        [self.callGenericServices.HUD hide:YES];
        return;
    }
    if (result.ErrorModel.Code > 0) {        
        self.weeklyMainTemplateDataManager.rowPointer++;        
        if (self.weeklyMainTemplateDataManager.rowPointer == [self.weeklyMainTemplateDataManager.updatedFieldNameList count]) {
            self.callGenericServices.isNotRecursion = YES;
            [self.callGenericServices.HUD hide:YES];
            [ArcosUtils showDialogBox:@"Completed." title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
                [self saveButtonCallBack];
            }];
        }
        [self updateWeeklyRecord];
    } else if(result.ErrorModel.Code <= 0) {
        [self.callGenericServices.HUD hide:YES];
        NSString* titleMsg = (result.ErrorModel.Code == 0) ? @"" : [GlobalSharedClass shared].errorTitle;
        [ArcosUtils showDialogBox:result.ErrorModel.Message title:titleMsg delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

@end
