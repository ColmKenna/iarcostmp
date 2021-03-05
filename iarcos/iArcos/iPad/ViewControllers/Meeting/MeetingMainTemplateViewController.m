//
//  MeetingMainTemplateViewController.m
//  iArcos
//
//  Created by David Kilmartin on 31/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateViewController.h"
#import "ArcosRootViewController.h"

@interface MeetingMainTemplateViewController ()

@end

@implementation MeetingMainTemplateViewController
@synthesize animateDelegate = _animateDelegate;
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
@synthesize meetingDetailsTableViewController = _meetingDetailsTableViewController;
@synthesize meetingMiscTableViewController = _meetingMiscTableViewController;
@synthesize meetingObjectivesTableViewController = _meetingObjectivesTableViewController;
@synthesize meetingAttendeesTableViewController = _meetingAttendeesTableViewController;
@synthesize meetingCostingsViewController = _meetingCostingsViewController;
@synthesize meetingPresentersTableViewController = _meetingPresentersTableViewController;
@synthesize meetingAttachmentsTableViewController = _meetingAttachmentsTableViewController;
@synthesize layoutKeyList = _layoutKeyList;
@synthesize layoutObjectList = _layoutObjectList;
@synthesize objectViewControllerList = _objectViewControllerList;
@synthesize layoutDict = _layoutDict;
@synthesize callGenericServices = _callGenericServices;
@synthesize actionType = _actionType;
@synthesize createActionType = _createActionType;
@synthesize meetingMainTemplateActionDelegate = _meetingMainTemplateActionDelegate;
@synthesize meetingIUR = _meetingIUR;
@synthesize meetingLocationIUR = _meetingLocationIUR;
@synthesize arcosRootViewController = _arcosRootViewController;
@synthesize meetingRecordCreated = _meetingRecordCreated;
@synthesize isPhotoUploadingFinished = _isPhotoUploadingFinished;
@synthesize meetingPhotoUploadProcessMachine = _meetingPhotoUploadProcessMachine;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.createActionType = @"create";
        self.arcosRootViewController = (ArcosRootViewController*)[ArcosUtils getRootView];
        self.meetingRecordCreated = NO;
        self.meetingIUR = [NSNumber numberWithInt:0];
        self.meetingLocationIUR = [NSNumber numberWithInt:0];
        self.isPhotoUploadingFinished = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Meeting";
    [FileCommon createFolder:@"meeting"];
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
    
    self.meetingDetailsTableViewController = [[[MeetingDetailsTableViewController alloc] initWithNibName:@"MeetingDetailsTableViewController" bundle:nil] autorelease];
    self.meetingDetailsTableViewController.actionDelegate = self;
    self.meetingMiscTableViewController = [[[MeetingMiscTableViewController alloc] initWithNibName:@"MeetingMiscTableViewController" bundle:nil] autorelease];
    self.meetingObjectivesTableViewController = [[[MeetingObjectivesTableViewController alloc] initWithNibName:@"MeetingObjectivesTableViewController" bundle:nil] autorelease];
    self.meetingAttendeesTableViewController = [[[MeetingAttendeesTableViewController alloc] initWithNibName:@"MeetingAttendeesTableViewController" bundle:nil] autorelease];
    self.meetingCostingsViewController = [[[MeetingCostingsViewController alloc] initWithNibName:@"MeetingCostingsViewController" bundle:nil] autorelease];
    self.meetingPresentersTableViewController = [[[MeetingPresentersTableViewController alloc] initWithNibName:@"MeetingPresentersTableViewController" bundle:nil] autorelease];
    self.meetingAttachmentsTableViewController = [[[MeetingAttachmentsTableViewController alloc] initWithNibName:@"MeetingAttachmentsTableViewController" bundle:nil] autorelease];
    self.meetingAttachmentsTableViewController.actionDelegate = self;
    
    self.layoutKeyList = [NSArray arrayWithObjects:@"AuxDetails", @"AuxMisc", @"AuxObjectives", @"AuxAttendees", @"AuxCostings", @"AuxPresenters", @"AuxAttachments", nil];
    self.layoutObjectList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController.view, self.meetingMiscTableViewController.view, self.meetingObjectivesTableViewController.view, self.meetingAttendeesTableViewController.view, self.meetingCostingsViewController.view, self.meetingPresentersTableViewController.view, self.meetingAttachmentsTableViewController.view, nil];
    self.objectViewControllerList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController, self.meetingMiscTableViewController, self.meetingObjectivesTableViewController, self.meetingAttendeesTableViewController, self.meetingCostingsViewController, self.meetingPresentersTableViewController, self.meetingAttachmentsTableViewController, nil];
    
    self.layoutDict = [NSDictionary dictionaryWithObjects:self.layoutObjectList forKeys:self.layoutKeyList];
    for (int i = 0; i < [self.layoutKeyList count]; i++) {
        NSString* tmpLayoutKey = [self.layoutKeyList objectAtIndex:i];
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        [self addChildViewController:tmpObjectViewController];
        [self.templateView addSubview:tmpObjectViewController.view];
        [tmpObjectViewController didMoveToParentViewController:self];
        [tmpObjectViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
        [self.templateView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(0)-[%@]-(0)-|", tmpLayoutKey] options:0 metrics:0 views:self.layoutDict]];
    }

    [self segmentedAction];
    UIBarButtonItem* saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed)];
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    [saveBarButtonItem release];
    self.callGenericServices = [[[CallGenericServices alloc] initWithView:self.navigationController.view] autorelease];
    if ([self.actionType isEqualToString:self.createActionType]) {
        self.meetingMainTemplateActionDelegate = [[[MeetingMainTemplateCreateAction alloc] initWithTarget:self] autorelease];
    } else {
        UIBarButtonItem* cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
        [cancelBarButtonItem release];
        self.meetingMainTemplateActionDelegate = [[[MeetingMainTemplateUpdateAction alloc] initWithTarget:self] autorelease];
    }
    [self.meetingMainTemplateActionDelegate retrieveMeetingMainTemplateData];
}

- (void)cancelButtonPressed {
    [self.animateDelegate dismissSlideAcrossViewAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.actionType isEqualToString:self.createActionType] && self.meetingRecordCreated) {
        self.meetingRecordCreated = NO;
        [self.meetingMainTemplateActionDelegate retrieveMeetingMainTemplateData];
        [self reloadCustomiseTableView];
    }
}

- (void)saveButtonPressed {
    [self.view endEditing:YES];
    self.callGenericServices.isNotRecursion = NO;
//    NSMutableArray* brandNewAttachmentList = [self.meetingAttachmentsTableViewController.meetingAttachmentsDataManager retrieveBrandNewAttachmentList];
//    if ([brandNewAttachmentList count] == 0) {
//        [self saveButtonMeetingProcessor];
//        return;
//    }
//    self.meetingPhotoUploadProcessMachine = [[[MeetingPhotoUploadProcessMachine alloc] initWithTarget:self action:@selector(uploadPhotoWithData:) loadingAction:@selector(photoUploadingActionFlag) dataDictList:brandNewAttachmentList] autorelease];
//    self.meetingPhotoUploadProcessMachine.uploadDelegate = self;
//    [self.meetingPhotoUploadProcessMachine runTask];
    [self saveButtonMeetingProcessor];
}

#pragma mark MeetingPhotoUploadProcessMachineDelegate
- (void)photoUploadStartedWithText:(NSString*)aText {
    
}

- (void)photoUploadCompleted {
//    [self saveButtonMeetingProcessor];
    [self.callGenericServices.HUD hide:YES];
    [ArcosUtils showDialogBox:@"Completed" title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
        if ([self.actionType isEqualToString:self.createActionType]) {
            [self saveButtonCallBack];
        } else {
            [self.animateDelegate dismissSlideAcrossViewAnimation];
        }
    }];
}

- (void)saveButtonMeetingProcessor {
    [self.meetingDetailsTableViewController.meetingDetailsDataManager displayListHeadOfficeAdaptor];
    [self.meetingMiscTableViewController.meetingMiscDataManager displayListHeadOfficeAdaptor];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager displayListHeadOfficeAdaptor];
    [self.meetingCostingsViewController.meetingCostingsDataManager displayListHeadOfficeAdaptor];
    //    ArcosMeetingBO* arcosMeetingBO = [[[ArcosMeetingBO alloc] init] autorelease];
    //    ArcosMeetingWithDetails* arcosMeetingWithDetails = [[[ArcosMeetingWithDetails alloc] init] autorelease];
//    ArcosMeetingWithDetailsUpload* arcosMeetingWithDetailsUpload = [[[ArcosMeetingWithDetailsUpload alloc] init] autorelease];
    ArcosMeetingWithDetailsDownload* arcosMeetingWithDetailsDownload = [[[ArcosMeetingWithDetailsDownload alloc] init] autorelease];
    [self.meetingDetailsTableViewController.meetingDetailsDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingMiscTableViewController.meetingMiscDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingAttendeesTableViewController.meetingAttendeesDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingCostingsViewController.meetingCostingsDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingCostingsViewController.meetingExpenseTableViewController populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    [self.meetingPresentersTableViewController.meetingPresentersDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    
    
    //    arcosMeetingBO.Attachments = @"";
    //    NSLog(@"abc %@", arcosMeetingBO);
    if ([self.actionType isEqualToString:self.createActionType]) {
        
    } else {
        [self.meetingAttachmentsTableViewController.meetingAttachmentsDataManager populateArcosMeetingWithDetails:arcosMeetingWithDetailsDownload];
    }
    //    arcosMeetingBO.IUR = [self.meetingIUR intValue];
    arcosMeetingWithDetailsDownload.IUR = [self.meetingIUR intValue];
    arcosMeetingWithDetailsDownload.LocationIUR = [self.meetingLocationIUR intValue];
    [self.callGenericServices genericUpdateMeetingByMeetingBO:arcosMeetingWithDetailsDownload action:@selector(resultBackFromUpdateMeeting:) target:self];
    //    NSLog(@"abc: %@", self.meetingDetailsTableViewController.meetingDetailsDataManager.headOfficeDataObjectDict);
    //    NSLog(@"ac: %@", self.meetingMiscTableViewController.meetingMiscDataManager.headOfficeDataObjectDict);
    //    NSLog(@"def: %@", self.meetingObjectivesTableViewController.meetingObjectivesDataManager.headOfficeDataObjectDict);
}

- (void)dealloc {
    self.mySegmentedControl = nil;    
    self.meetingDetailsTableViewController = nil;
    self.meetingMiscTableViewController = nil;
    self.meetingObjectivesTableViewController = nil;
    self.meetingAttendeesTableViewController = nil;
    self.meetingCostingsViewController = nil;
    self.meetingAttachmentsTableViewController = nil;
    for (int i = 0; i < [self.objectViewControllerList count]; i++) {
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        [tmpObjectViewController willMoveToParentViewController:nil];
        [tmpObjectViewController.view removeFromSuperview];
        [tmpObjectViewController removeFromParentViewController];
    }
    self.layoutDict = nil;
    self.layoutKeyList = nil;
    self.layoutObjectList = nil;
    self.objectViewControllerList = nil;
    self.callGenericServices = nil;
    self.actionType = nil;
    self.createActionType = nil;
    self.meetingIUR = nil;
    self.meetingMainTemplateActionDelegate = nil;
    self.arcosRootViewController = nil;
    self.meetingPresentersTableViewController = nil;
    self.meetingPhotoUploadProcessMachine = nil;
    self.templateView = nil;
    
    [super dealloc];
}

- (void)resultBackFromUpdateMeeting:(id)result {
//    [self.callGenericServices.HUD hide:YES];
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    ArcosGenericReturnObject* arcosGenericReturnObject = (ArcosGenericReturnObject*)result;
    if (arcosGenericReturnObject.ErrorModel.Code >= 1) {
        self.meetingIUR = [NSNumber numberWithInt:arcosGenericReturnObject.ErrorModel.Code];
        NSMutableArray* brandNewAttachmentList = [self.meetingAttachmentsTableViewController.meetingAttachmentsDataManager retrieveBrandNewAttachmentList];
        if ([brandNewAttachmentList count] == 0) {
//            [self saveButtonMeetingProcessor];
            [ArcosUtils showDialogBox:@"Completed" title:@"" delegate:self target:self tag:77 handler:^(UIAlertAction *action) {
                if ([self.actionType isEqualToString:self.createActionType]) {
                    [self saveButtonCallBack];
                } else {
                    [self.animateDelegate dismissSlideAcrossViewAnimation];
                }
            }];
            [self.callGenericServices.HUD hide:YES];
            return;
        }
        self.meetingPhotoUploadProcessMachine = [[[MeetingPhotoUploadProcessMachine alloc] initWithTarget:self action:@selector(uploadPhotoWithData:) loadingAction:@selector(photoUploadingActionFlag) dataDictList:brandNewAttachmentList] autorelease];
        self.meetingPhotoUploadProcessMachine.uploadDelegate = self;
        [self.meetingPhotoUploadProcessMachine runTask];
    } else {
        [self.callGenericServices.HUD hide:YES];
        [ArcosUtils showDialogBox:arcosGenericReturnObject.ErrorModel.Message title:@"" delegate:nil target:self tag:0 handler:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)saveButtonCallBack {
    self.meetingRecordCreated = YES;
    int itemIndex = [self.arcosRootViewController.customerMasterViewController.customerMasterDataManager retrieveIndexByTitle:[GlobalSharedClass shared].customerText];
    [self.arcosRootViewController.customerMasterViewController selectCustomerMasterTopViewWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:0]];
}


- (void)segmentedAction {
    for (int i = 0; i < [self.objectViewControllerList count]; i++) {
        UIViewController* tmpObjectViewController = [self.objectViewControllerList objectAtIndex:i];
        tmpObjectViewController.view.hidden = YES;
    }
    switch (self.mySegmentedControl.selectedSegmentIndex) {
        case 0: {
            self.meetingDetailsTableViewController.view.hidden = NO;
        }
            break;
            
        case 1: {
            self.meetingMiscTableViewController.view.hidden = NO;
        }
            break;
            
        case 2: {
            self.meetingObjectivesTableViewController.view.hidden = NO;
        }
            break;
            
        case 3: {
            self.meetingAttendeesTableViewController.view.hidden = NO;
        }
            break;
            
            
        case 4: {
            self.meetingCostingsViewController.view.hidden = NO;
        }
            break;
            
        case 5: {
            self.meetingPresentersTableViewController.view.hidden = NO;
        }
            break;
        
        case 6: {
            self.meetingAttachmentsTableViewController.view.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)retrieveCreateMeetingMainTemplateData {
    [self.meetingDetailsTableViewController.meetingDetailsDataManager createBasicDataWithReturnObject:nil];
    [self.meetingMiscTableViewController.meetingMiscDataManager createBasicDataWithReturnObject:nil];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager createBasicDataWithReturnObject:nil];
    [self.meetingAttendeesTableViewController.meetingAttendeesDataManager createBasicDataWithReturnObject:nil];
    [self.meetingCostingsViewController.meetingCostingsDataManager createBasicDataWithReturnObject:nil];
    [self.meetingCostingsViewController.meetingExpenseTableViewController createBasicDataWithReturnObject:nil];
    self.callGenericServices.isNotRecursion = YES;
    [self.callGenericServices genericGetMeetingWithIUR:self.meetingIUR action:@selector(resultBackFromCreateGetMeeting:) target:self];
}

- (void)resultBackFromCreateGetMeeting:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    [self.meetingPresentersTableViewController.meetingPresentersDataManager createBasicDataWithReturnObject:result];
    [self.meetingAttachmentsTableViewController.meetingAttachmentsDataManager createBasicDataWithReturnObject:result];
    [self reloadCustomiseTableView];
}

- (void)reloadCustomiseTableView {
    [self.meetingDetailsTableViewController reloadCustomiseTableView];
    [self.meetingMiscTableViewController reloadCustomiseTableView];
    [self.meetingObjectivesTableViewController reloadCustomiseTableView];
    [self.meetingAttendeesTableViewController reloadCustomiseTableView];
    [self.meetingCostingsViewController reloadCustomiseTableView];
    [self.meetingPresentersTableViewController reloadCustomiseTableView];
    [self.meetingAttachmentsTableViewController reloadCustomiseTableView];
}

- (void)retrieveUpdateMeetingMainTemplateData {
    NSLog(@"update abc");
    self.callGenericServices.isNotRecursion = YES;
    [self.callGenericServices genericGetMeetingWithIUR:self.meetingIUR action:@selector(resultBackFromGetMeeting:) target:self];
}

- (void)resultBackFromGetMeeting:(id)result {
//    NSLog(@"ax: %@", result);
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    ArcosMeetingWithDetailsDownload* arcosMeetingWithDetailsDownload = (ArcosMeetingWithDetailsDownload*)result;
    if (arcosMeetingWithDetailsDownload.DateTime == nil) {
        [ArcosUtils showDialogBox:@"Invalid date format found" title:@"" delegate:nil target:self tag:0 handler:nil];
    }
    self.meetingLocationIUR = [NSNumber numberWithInt:arcosMeetingWithDetailsDownload.LocationIUR];
    [self.meetingDetailsTableViewController.meetingDetailsDataManager createBasicDataWithReturnObject:result];
    [self.meetingMiscTableViewController.meetingMiscDataManager createBasicDataWithReturnObject:result];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager createBasicDataWithReturnObject:result];
    [self.meetingAttendeesTableViewController.meetingAttendeesDataManager createBasicDataWithReturnObject:result];
    [self.meetingCostingsViewController.meetingCostingsDataManager createBasicDataWithReturnObject:result];
    [self.meetingCostingsViewController.meetingExpenseTableViewController createBasicDataWithReturnObject:result];
    [self.meetingPresentersTableViewController.meetingPresentersDataManager createBasicDataWithReturnObject:result];
    [self.meetingAttachmentsTableViewController.meetingAttachmentsDataManager createBasicDataWithReturnObject:result];
    [self reloadCustomiseTableView];
}

#pragma mark MeetingAttachmentsTableViewControllerDelegate
- (NSNumber*)retrieveMeetingAttachmentsTableLocationIUR {
    if ([self.actionType isEqualToString:self.createActionType]) {
        return [NSNumber numberWithInt:0];
    } else {
        return self.meetingLocationIUR;
    }
}

- (NSNumber*)retrieveMeetingAttachmentsMeetingIUR {
    return self.meetingIUR;
}

- (BOOL)photoUploadingActionFlag {
    return self.isPhotoUploadingFinished;
}

- (void)uploadPhotoWithData:(ArcosAttachmentSummary*)anArcosAttachmentSummary {
    if (self.isPhotoUploadingFinished) {
        self.isPhotoUploadingFinished = NO;
        NSString* fileName = anArcosAttachmentSummary.FileName;
        NSString* filePath = [NSString stringWithFormat:@"%@/%@", [FileCommon meetingPath], fileName];
        NSData* myData = nil;
        if ([[ArcosConfigDataManager sharedArcosConfigDataManager] enableSendOriginalPhotoFlag]) {
            myData = [NSData dataWithContentsOfFile:filePath];
        } else {
            UIImage* myImage = [UIImage imageWithContentsOfFile:filePath];
            CGSize newSize = CGSizeMake(1280.0f, 960.0f);
            UIGraphicsBeginImageContext(newSize);
            [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
            UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            myData = UIImageJPEGRepresentation(compressedImage, 0.85);
        }
        
        [self.callGenericServices genericUploadFileNewWithContents:myData fileName:fileName description:anArcosAttachmentSummary.Description tableIUR:[ArcosUtils convertNumberToIntString:[NSNumber numberWithInt:[self.meetingIUR intValue]]] tableName:@"Meeting" employeeiur:anArcosAttachmentSummary.EmployeeIUR locationiur:anArcosAttachmentSummary.LocationIUR dateAttached:anArcosAttachmentSummary.DateAttached action:@selector(backFromUploadPhotoWithData:) target:self];
    }
}

- (void)backFromUploadPhotoWithData:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        [self.meetingPhotoUploadProcessMachine stopTask];
    }
    self.isPhotoUploadingFinished = YES;
}

#pragma mark MeetingDetailsTableViewControllerDelegate
- (void)updateMeetingMainTemplateLocationIUR:(NSNumber *)aLocationIUR {
    self.meetingLocationIUR = aLocationIUR;
}



@end
