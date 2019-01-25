//
//  MeetingAttendeesEmployeesHeaderViewController.h
//  iArcos
//
//  Created by David Kilmartin on 22/01/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "MeetingAttendeesEmployeesHeaderViewControllerDelegate.h"

@interface MeetingAttendeesEmployeesHeaderViewController : UIViewController <WidgetFactoryDelegate, UIPopoverControllerDelegate>{
    id<MeetingAttendeesEmployeesHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, assign) id<MeetingAttendeesEmployeesHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;

- (IBAction)addButtonPressed:(id)sender;

@end

