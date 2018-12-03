//
//  MeetingMainTemplateViewController.h
//  iArcos
//
//  Created by David Kilmartin on 31/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingDetailsTableViewController.h"
#import "MeetingMiscTableViewController.h"
#import "MeetingObjectivesTableViewController.h"
#import "MeetingCostingsViewController.h"
#import "CallGenericServices.h"
#import "ArcosMeetingBO.h"
#import "MeetingMainTemplateCreateAction.h"
#import "MeetingMainTemplateUpdateAction.h"

@interface MeetingMainTemplateViewController : UIViewController {
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
    MeetingDetailsTableViewController* _meetingDetailsTableViewController;
    MeetingMiscTableViewController* _meetingMiscTableViewController;
    MeetingObjectivesTableViewController* _meetingObjectivesTableViewController;
    MeetingCostingsViewController* _meetingCostingsViewController;
    NSArray* _layoutKeyList;
    NSArray* _layoutObjectList;
    NSArray* _objectViewControllerList;
    NSDictionary* _layoutDict;
    CallGenericServices* _callGenericServices;
    NSString* _actionType;
    NSString* _createActionType;
    id<MeetingMainTemplateActionDelegate> _meetingMainTemplateActionDelegate;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) MeetingDetailsTableViewController* meetingDetailsTableViewController;
@property(nonatomic, retain) MeetingMiscTableViewController* meetingMiscTableViewController;
@property(nonatomic, retain) MeetingObjectivesTableViewController* meetingObjectivesTableViewController;
@property(nonatomic, retain) MeetingCostingsViewController* meetingCostingsViewController;
@property(nonatomic, retain) NSArray* layoutKeyList;
@property(nonatomic, retain) NSArray* layoutObjectList;
@property(nonatomic, retain) NSArray* objectViewControllerList;
@property(nonatomic, retain) NSDictionary* layoutDict;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSString* actionType;
@property(nonatomic, retain) NSString* createActionType;
@property(nonatomic, retain) id<MeetingMainTemplateActionDelegate> meetingMainTemplateActionDelegate;

- (void)retrieveCreateMeetingMainTemplateData;
- (void)retrieveUpdateMeetingMainTemplateData;

@end

