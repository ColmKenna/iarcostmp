//
//  OrderDetailNumberTextFieldTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 20/06/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "ArcosUtils.h"

@interface OrderDetailNumberTextFieldTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end
