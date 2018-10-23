//
//  OrderDetailIArcosDrillDownTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 06/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailIArcosDrillDownTableCell : OrderDetailBaseTableCell {
    UIButton* _drillDownButton;
    UILabel* _drillDownLabel;
    BOOL _isEventSet;
}

@property(nonatomic, retain) IBOutlet UIButton* drillDownButton;
@property(nonatomic, retain) IBOutlet UILabel* drillDownLabel;
@property(nonatomic, assign) BOOL isEventSet;

@end
