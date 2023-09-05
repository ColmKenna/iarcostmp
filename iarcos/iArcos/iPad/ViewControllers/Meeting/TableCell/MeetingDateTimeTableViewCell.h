//
//  MeetingDateTimeTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "WidgetFactory.h"

@interface MeetingDateTimeTableViewCell : MeetingBaseTableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate>{
    UILabel* _dateFieldNameLabel;
    UILabel* _dateFieldValueLabel;
    UILabel* _timeFieldNameLabel;
    UILabel* _timeFieldValueLabel;
    UILabel* _durationFieldNameLabel;
    UITextField* _durationFieldValueTextField;
    UILabel* _currentSelectedLabel;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, retain) IBOutlet UILabel* dateFieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* dateFieldValueLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeFieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* timeFieldValueLabel;
@property(nonatomic, retain) IBOutlet UILabel* durationFieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* durationFieldValueTextField;
@property(nonatomic, retain) UILabel* currentSelectedLabel;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

@end

