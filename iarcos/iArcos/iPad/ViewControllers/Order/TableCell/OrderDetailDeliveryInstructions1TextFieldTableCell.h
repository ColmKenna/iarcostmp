//
//  OrderDetailDeliveryInstructions1TextFieldTableCell.h
//  iArcos
//
//  Created by David Kilmartin on 15/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface OrderDetailDeliveryInstructions1TextFieldTableCell : OrderDetailBaseTableCell {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;    
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end
