//
//  OrderDetailOrderNumberTableCell.h
//  iArcos
//
//  Created by Richard on 04/03/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailOrderNumberTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end

