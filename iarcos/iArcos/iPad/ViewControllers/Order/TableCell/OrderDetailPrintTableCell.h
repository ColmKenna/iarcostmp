//
//  OrderDetailPrintTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 09/05/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import "OrderDetailBaseTableCell.h"

@interface OrderDetailPrintTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    BOOL _isEventSet;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, assign) BOOL isEventSet;

@end
