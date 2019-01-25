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
@class ArcosRootViewController;
#import "SlideAcrossViewAnimationDelegate.h"
#import "MeetingAttendeesTableViewController.h"

@interface MeetingMainTemplateViewController : UIViewController {
    id<SlideAcrossViewAnimationDelegate> _animateDelegate;
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
    MeetingDetailsTableViewController* _meetingDetailsTableViewController;
    MeetingMiscTableViewController* _meetingMiscTableViewController;
    MeetingObjectivesTableViewController* _meetingObjectivesTableViewController;
    MeetingAttendeesTableViewController* _meetingAttendeesTableViewController;
    MeetingCostingsViewController* _meetingCostingsViewController;
    NSArray* _layoutKeyList;
    NSArray* _layoutObjectList;
    NSArray* _objectViewControllerList;
    NSDictionary* _layoutDict;
    CallGenericServices* _callGenericServices;
    NSString* _actionType;
    NSString* _createActionType;
    BOOL _meetingRecordCreated;
    NSNumber* _meetingIUR;
    id<MeetingMainTemplateActionDelegate> _meetingMainTemplateActionDelegate;
    ArcosRootViewController* _arcosRootViewController;
}

@property(nonatomic, assign) id<SlideAcrossViewAnimationDelegate> animateDelegate;
@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) MeetingDetailsTableViewController* meetingDetailsTableViewController;
@property(nonatomic, retain) MeetingMiscTableViewController* meetingMiscTableViewController;
@property(nonatomic, retain) MeetingObjectivesTableViewController* meetingObjectivesTableViewController;
@property(nonatomic, retain) MeetingAttendeesTableViewController* meetingAttendeesTableViewController;
@property(nonatomic, retain) MeetingCostingsViewController* meetingCostingsViewController;
@property(nonatomic, retain) NSArray* layoutKeyList;
@property(nonatomic, retain) NSArray* layoutObjectList;
@property(nonatomic, retain) NSArray* objectViewControllerList;
@property(nonatomic, retain) NSDictionary* layoutDict;
@property(nonatomic, retain) CallGenericServices* callGenericServices;
@property(nonatomic, retain) NSString* actionType;
@property(nonatomic, retain) NSString* createActionType;
@property(nonatomic, retain) id<MeetingMainTemplateActionDelegate> meetingMainTemplateActionDelegate;
@property(nonatomic, retain) NSNumber* meetingIUR;
@property(nonatomic, retain) ArcosRootViewController* arcosRootViewController;
@property(nonatomic, assign) BOOL meetingRecordCreated;

- (void)retrieveCreateMeetingMainTemplateData;
- (void)retrieveUpdateMeetingMainTemplateData;
- (void)reloadCustomiseTableView;

@end

