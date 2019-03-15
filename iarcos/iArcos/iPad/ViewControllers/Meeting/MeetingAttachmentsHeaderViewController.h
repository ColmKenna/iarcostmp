//
//  MeetingAttachmentsHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttachmentsHeaderViewControllerDelegate.h"

@interface MeetingAttachmentsHeaderViewController : UIViewController {
    id<MeetingAttachmentsHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
}

@property(nonatomic, assign) id<MeetingAttachmentsHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;

- (IBAction)addButtonPressed:(id)sender;

@end

