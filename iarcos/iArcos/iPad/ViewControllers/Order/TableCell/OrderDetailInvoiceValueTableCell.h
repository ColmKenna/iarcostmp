//
//  OrderDetailInvoiceValueTableCell.h
//  iArcos
//
//  Created by Richard on 14/12/2022.
//  Copyright © 2022 Strata IT Limited. All rights reserved.
//

#import "OrderDetailBaseTableCell.h"
#import "ArcosUtils.h"

@interface OrderDetailInvoiceValueTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UILabel* _fieldValueLabel;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UILabel* fieldValueLabel;

@end


