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

@interface MeetingAttendeesEmployeesHeaderViewController : UIViewController <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    id<MeetingAttendeesEmployeesHeaderViewControllerDelegate> _actionDelegate;
    UIButton* _addButton;
    WidgetFactory* _factory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, assign) id<MeetingAttendeesEmployeesHeaderViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UIButton* addButton;
@property(nonatomic, retain) WidgetFactory* factory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

- (IBAction)addButtonPressed:(id)sender;

@end

