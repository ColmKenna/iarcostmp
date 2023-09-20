//
//  MeetingAttachmentsHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 15/03/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingAttachmentsHeaderViewControllerDelegate.h"
#import "ArcosCoreData.h"

@interface MeetingAttachmentsHeaderViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate> {
    id<MeetingAttachmentsHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
    UIImagePickerController* _imagePicker;
}

@property(nonatomic, assign) id<MeetingAttachmentsHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;
@property(nonatomic, retain) UIImagePickerController* imagePicker;

- (IBAction)addButtonPressed:(id)sender;

@end

