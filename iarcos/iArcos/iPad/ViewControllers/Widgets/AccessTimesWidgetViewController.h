//
//  AccessTimesWidgetViewController.h
//  iArcos
//
//  Created by David Kilmartin on 14/06/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WidgetFactory.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"
#import "AccessTimesWidgetViewControllerDelegate.h"

@interface AccessTimesWidgetViewController : UIViewController <WidgetFactoryDelegate, UIPopoverControllerDelegate> {
    id<AccessTimesWidgetViewControllerDelegate> _actionDelegate;
    UILabel* _weekDayLabel;
    UILabel* _startTimeTitleLabel;
    UILabel* _startTimeContentLabel;
    UILabel* _endTimeTitleLabel;
    UILabel* _endTimeContentLabel;
    NSMutableArray* _weekDayDictList;
    WidgetFactory* _widgetFactory;
//    UIPopoverController* _thePopover;
    WidgetViewController* _globalWidgetViewController;
    NSString* _myTitle;
    UILabel* _currentSelectedLabel;
    NSMutableDictionary* _weekDayCellDict;
    NSDate* _startTimeCellDate;
    NSDate* _endTimeCellDate;
    NSString* _auxDefaultKey;
}

@property(nonatomic, assign) id<AccessTimesWidgetViewControllerDelegate> actionDelegate;
@property(nonatomic, retain) IBOutlet UILabel* weekDayLabel;
@property(nonatomic, retain) IBOutlet UILabel* startTimeTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* startTimeContentLabel;
@property(nonatomic, retain) IBOutlet UILabel* endTimeTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel* endTimeContentLabel;
@property(nonatomic, retain) NSMutableArray* weekDayDictList;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
//@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) WidgetViewController* globalWidgetViewController;
@property(nonatomic, retain) NSString* myTitle;
@property(nonatomic, retain) UILabel* currentSelectedLabel;
@property(nonatomic, retain) NSMutableDictionary* weekDayCellDict;
@property(nonatomic, retain) NSDate* startTimeCellDate;
@property(nonatomic, retain) NSDate* endTimeCellDate;
@property(nonatomic, retain) NSString* auxDefaultKey;

@end
