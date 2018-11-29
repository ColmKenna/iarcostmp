//
//  MeetingEmployeeTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"
#import "ArcosCoreData.h"
#import "WidgetFactory.h"

@interface MeetingEmployeeTableViewCell : MeetingBaseTableViewCell <WidgetFactoryDelegate, UIPopoverControllerDelegate, UITextFieldDelegate> {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    UIButton* _searchButton;
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) IBOutlet UIButton* searchButton;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;

- (IBAction)searchButtonPressed:(id)sender;

@end

