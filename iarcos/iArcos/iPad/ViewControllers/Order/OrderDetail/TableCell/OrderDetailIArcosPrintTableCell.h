//
//  OrderDetailIArcosPrintTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 24/08/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailIArcosPrintTableCell : OrderDetailBaseTableCell {
    UIButton* _printButton;
    UILabel* _fieldNameLabel;
    BOOL _isEventSet;
}

@property(nonatomic, retain) IBOutlet UIButton* printButton;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, assign) BOOL isEventSet;

@end
