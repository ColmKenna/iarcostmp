//
//  OrderDetailFormTypeLabelTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 18/12/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "WidgetFactory.h"

@interface OrderDetailFormTypeLabelTableCell : OrderDetailBaseTableCell <WidgetFactoryDelegate> {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;

@end

