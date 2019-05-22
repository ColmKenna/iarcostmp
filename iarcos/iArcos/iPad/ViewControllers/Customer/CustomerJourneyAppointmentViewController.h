//
//  CustomerJourneyAppointmentViewController.h
//  iArcos
//
//  Created by David Kilmartin on 21/05/2019.
//  Copyright © 2019 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModalPresentViewControllerDelegate.h"
#import "OrderSharedClass.h"
#import "ArcosUtils.h"
#import "WidgetFactory.h"


@interface CustomerJourneyAppointmentViewController : UIViewController <WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    id<ModalPresentViewControllerDelegate> _modalDelegate;
    UILabel* _callDateTitle;
    UILabel* _callDate;
    UILabel* _callTypeTitle;
    UILabel* _callType;
    UILabel* _contactTitle;
    UILabel* _contact;
    WidgetFactory* _factory;
    UIPopoverController* _thePopover;
    NSInteger _currentLabelIndex;
    
}

@property(nonatomic, assign) id<ModalPresentViewControllerDelegate> modalDelegate;
@property(nonatomic, retain) IBOutlet UILabel* callDateTitle;
@property(nonatomic, retain) IBOutlet UILabel* callDate;
@property(nonatomic, retain) IBOutlet UILabel* callTypeTitle;
@property(nonatomic, retain) IBOutlet UILabel* callType;
@property(nonatomic, retain) IBOutlet UILabel* contactTitle;
@property(nonatomic, retain) IBOutlet UILabel* contact;
@property(nonatomic, retain) WidgetFactory* factory;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, assign) NSInteger currentLabelIndex;

@end


