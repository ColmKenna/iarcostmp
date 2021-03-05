//
//  OrderDetailInvoiceRefTableCell.h
//  iArcos
//
//  Created by Richard on 03/03/2021.
//  Copyright © 2021 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"

@interface OrderDetailInvoiceRefTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end


