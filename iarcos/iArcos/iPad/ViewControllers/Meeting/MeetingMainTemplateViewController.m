//
//  MeetingMainTemplateViewController.m
//  iArcos
//
//  Created by David Kilmartin on 31/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingMainTemplateViewController.h"

@interface MeetingMainTemplateViewController ()

@end

@implementation MeetingMainTemplateViewController
@synthesize mySegmentedControl = _mySegmentedControl;
@synthesize templateView = _templateView;
@synthesize meetingDetailsTableViewController = _meetingDetailsTableViewController;
@synthesize meetingMiscTableViewController = _meetingMiscTableViewController;
@synthesize meetingObjectivesTableViewController = _meetingObjectivesTableViewController;
@synthesize meetingCostingsViewController = _meetingCostingsViewController;
@synthesize layoutKeyList = _layoutKeyList;
@synthesize layoutObjectList = _layoutObjectList;
@synthesize objectViewControllerList = _objectViewControllerList;
@synthesize layoutDict = _layoutDict;
@synthesize callGenericServices = _callGenericServices;
@synthesize actionType = _actionType;
@synthesize createActionType = _createActionType;
@synthesize meetingMainTemplateActionDelegate = _meetingMainTemplateActionDelegate;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.createActionType = @"create";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Meeting";
    UIColor* myColor = [UIColor colorWithRed:135.0/255.0f green:206.0/255.0f blue:250.0/255.0f alpha:1.0f];
    self.mySegmentedControl.layer.cornerRadius = 0.0;
    self.mySegmentedControl.layer.borderColor = myColor.CGColor;
    self.mySegmentedControl.layer.borderWidth = 2.0f;
    self.mySegmentedControl.layer.masksToBounds = YES;
    [self.mySegmentedControl addTarget:self action:@selector(segmentedAction) forControlEvents:UIControlEventValueChanged];
    
    [self.templateView.layer setBorderWidth:2.0];
    [self.templateView.layer setBorderColor:[myColor CGColor]];
    
    self.meetingDetailsTableViewController = [[[MeetingDetailsTableViewController alloc] initWithNibName:@"MeetingDetailsTableViewController" bundle:nil] autorelease];
    self.meetingMiscTableViewController = [[[MeetingMiscTableViewController alloc] initWithNibName:@"MeetingMiscTableViewController" bundle:nil] autorelease];
    self.meetingObjectivesTableViewController = [[[MeetingObjectivesTableViewController alloc] initWithNibName:@"MeetingObjectivesTableViewController" bundle:nil] autorelease];
    self.meetingCostingsViewController = [[[MeetingCostingsViewController alloc] initWithNibName:@"MeetingCostingsViewController" bundle:nil] autorelease];
    
    self.layoutKeyList = [NSArray arrayWithObjects:@"AuxDetails", @"AuxMisc", @"AuxObjectives", @"AuxCostings", nil];
    self.layoutObjectList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController.view, self.meetingMiscTableViewController.view, self.meetingObjectivesTableViewController.view, self.meetingCostingsViewController.view, nil];
    self.objectViewControllerList = [NSArray arrayWithObjects:self.meetingDetailsTableViewController, self.meetingMiscTableViewController, self.meetingObjectivesTableViewController, self.meetingCostingsViewController, nil];
    
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
        self.meetingMainTemplateActionDelegate = [[[MeetingMainTemplateUpdateAction alloc] initWithTarget:self] autorelease];
    }
    [self.meetingMainTemplateActionDelegate retrieveMeetingMainTemplateData];
}

- (void)saveButtonPressed {
    [self.view endEditing:YES];
    [self.meetingDetailsTableViewController.meetingDetailsDataManager displayListHeadOfficeAdaptor];
    [self.meetingMiscTableViewController.meetingMiscDataManager displayListHeadOfficeAdaptor];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager displayListHeadOfficeAdaptor];
    [self.meetingCostingsViewController.meetingCostingsDataManager displayListHeadOfficeAdaptor];
    ArcosMeetingBO* arcosMeetingBO = [[[ArcosMeetingBO alloc] init] autorelease];
    [self.meetingDetailsTableViewController.meetingDetailsDataManager populateArcosMeetingBO:arcosMeetingBO];
    [self.meetingMiscTableViewController.meetingMiscDataManager populateArcosMeetingBO:arcosMeetingBO];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager populateArcosMeetingBO:arcosMeetingBO];
    [self.meetingCostingsViewController.meetingCostingsDataManager populateArcosMeetingBO:arcosMeetingBO];
    arcosMeetingBO.Attachments = @"";
    NSLog(@"abc %@", arcosMeetingBO);
    [self.callGenericServices genericUpdateMeetingByMeetingBO:arcosMeetingBO action:@selector(resultBackFromUpdateMeeting:) target:self];
//    NSLog(@"abc: %@", self.meetingDetailsTableViewController.meetingDetailsDataManager.headOfficeDataObjectDict);
//    NSLog(@"ac: %@", self.meetingMiscTableViewController.meetingMiscDataManager.headOfficeDataObjectDict);
//    NSLog(@"def: %@", self.meetingObjectivesTableViewController.meetingObjectivesDataManager.headOfficeDataObjectDict);
}

- (void)dealloc {
    self.mySegmentedControl = nil;
    self.templateView = nil;
    self.meetingDetailsTableViewController = nil;
    self.meetingMiscTableViewController = nil;
    self.meetingObjectivesTableViewController = nil;
    self.meetingCostingsViewController = nil;
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
    self.meetingMainTemplateActionDelegate = nil;
    
    [super dealloc];
}

- (void)resultBackFromUpdateMeeting:(id)result {
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    
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
            
        case 5: {
            self.meetingCostingsViewController.view.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)retrieveCreateMeetingMainTemplateData {
    [self.meetingDetailsTableViewController.meetingDetailsDataManager createBasicData];
    [self.meetingMiscTableViewController.meetingMiscDataManager createBasicData];
    [self.meetingObjectivesTableViewController.meetingObjectivesDataManager createBasicData];
    [self.meetingCostingsViewController.meetingCostingsDataManager createBasicData];
}

- (void)retrieveUpdateMeetingMainTemplateData {
    NSLog(@"update abc");
    [self.callGenericServices genericGetMeetingWithIUR:[NSNumber numberWithInt:0] action:@selector(resultBackFromGetMeeting:) target:self];
}

- (void)resultBackFromGetMeeting:(id)result {
    NSLog(@"ax: %@", result);
    result = [self.callGenericServices handleResultErrorProcess:result];
    if (result == nil) {
        return;
    }
    
}

@end
