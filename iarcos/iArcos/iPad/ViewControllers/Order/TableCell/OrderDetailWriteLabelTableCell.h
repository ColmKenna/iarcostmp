//
//  OrderDetailWriteLabelTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "WidgetFactory.h"
#import "CheckoutDataManager.h"

@interface OrderDetailWriteLabelTableCell : OrderDetailBaseTableCell<WidgetFactoryDelegate> {
    WidgetFactory* _widgetFactory;
    UIPopoverController* _thePopover;
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
    BOOL _isEventSet;
    CheckoutDataManager* _checkoutDataManager;
}

@property(nonatomic, retain) WidgetFactory* widgetFactory;
@property(nonatomic, retain) UIPopoverController* thePopover;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;
@property(nonatomic, assign) BOOL isEventSet;
@property(nonatomic, retain) CheckoutDataManager* checkoutDataManager;

-(void)handleSingleTapGesture:(id)sender;

@end
