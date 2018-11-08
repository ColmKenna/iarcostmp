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

@interface MeetingMainTemplateViewController : UIViewController {
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
    MeetingDetailsTableViewController* _meetingDetailsTableViewController;
    MeetingMiscTableViewController* _meetingMiscTableViewController;
    NSArray* _layoutKeyList;
    NSArray* _layoutObjectList;
    NSArray* _objectViewControllerList;
    NSDictionary* _layoutDict;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) MeetingDetailsTableViewController* meetingDetailsTableViewController;
@property(nonatomic, retain) MeetingMiscTableViewController* meetingMiscTableViewController;
@property(nonatomic, retain) NSArray* layoutKeyList;
@property(nonatomic, retain) NSArray* layoutObjectList;
@property(nonatomic, retain) NSArray* objectViewControllerList;
@property(nonatomic, retain) NSDictionary* layoutDict;

@end

