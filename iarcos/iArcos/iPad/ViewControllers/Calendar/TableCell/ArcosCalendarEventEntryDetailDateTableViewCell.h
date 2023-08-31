//
//  ArcosCalendarEventEntryDetailDateTableViewCell.h
//  iArcos
//
//  Created by Richard on 13/05/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "ArcosCalendarEventEntryDetailBaseTableViewCell.h"
#import "WidgetFactory.h"


@interface ArcosCalendarEventEntryDetailDateTableViewCell : ArcosCalendarEventEntryDetailBaseTableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    UILabel* _fieldDescLabel;
    UILabel* _fieldValueLabel;
    UILabel* _fieldTimeValueLabel;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    UILabel* _currentSelectedLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldDescLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldTimeValueLabel;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) UILabel* currentSelectedLabel;

@end


