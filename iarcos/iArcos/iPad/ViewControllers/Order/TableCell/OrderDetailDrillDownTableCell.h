//
//  OrderDetailDrillDownTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 04/03/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailDrillDownTableCell : OrderDetailBaseTableCell {
    UILabel* _drillDownLabel;
    BOOL _isEventSet;
}

@property(nonatomic, retain) IBOutlet UILabel* drillDownLabel;
@property(nonatomic, assign) BOOL isEventSet;

@end
