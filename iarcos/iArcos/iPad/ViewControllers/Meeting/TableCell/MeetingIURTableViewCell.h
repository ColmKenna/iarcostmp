//
//  MeetingIURTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 02/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBaseTableViewCell.h"
#import "WidgetFactory.h"

@interface MeetingIURTableViewCell : MeetingBaseTableViewCell <WidgetFactoryDelegate, UIPopoverPresentationControllerDelegate>{
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic,retain) WidgetViewController* globalWidgetViewController;

- (void)clearPopoverCacheData;

@end

