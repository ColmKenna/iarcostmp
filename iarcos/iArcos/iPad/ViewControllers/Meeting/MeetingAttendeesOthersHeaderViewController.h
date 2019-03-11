//
//  MeetingAttendeesOthersHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 07/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttendeesOthersItemTableViewController.h"
#import "MeetingAttendeesOthersHeaderViewControllerDelegate.h"

@interface MeetingAttendeesOthersHeaderViewController : UIViewController <MeetingAttendeesOthersItemTableViewControllerDelegate>{
    id<MeetingAttendeesOthersHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
    
}

@property(nonatomic, assign) id<MeetingAttendeesOthersHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;

- (IBAction)addButtonPressed:(id)sender;

@end

