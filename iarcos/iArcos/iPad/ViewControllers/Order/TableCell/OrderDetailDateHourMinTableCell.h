//
//  OrderDetailDateHourMinTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 03/07/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "WidgetFactory.h"

@interface OrderDetailDateHourMinTableCell : OrderDetailBaseTableCell <WidgetFactoryDelegate> {
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    BOOL _isEventSet;
}

@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, assign) BOOL isEventSet;

@end
