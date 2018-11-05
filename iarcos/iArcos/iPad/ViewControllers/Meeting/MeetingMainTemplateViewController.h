//
//  MeetingMainTemplateViewController.h
//  iArcos
//
//  Created by David Kilmartin on 31/10/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingDetailsTableViewController.h"

@interface MeetingMainTemplateViewController : UIViewController {
    UISegmentedControl* _mySegmentedControl;
    UIView* _templateView;
    MeetingDetailsTableViewController* _meetingDetailsTableViewController;
    NSDictionary* _layoutDict;
}

@property(nonatomic, retain) IBOutlet UISegmentedControl* mySegmentedControl;
@property(nonatomic, retain) IBOutlet UIView* templateView;
@property(nonatomic, retain) MeetingDetailsTableViewController* meetingDetailsTableViewController;
@property(nonatomic, retain) NSDictionary* layoutDict;

@end

