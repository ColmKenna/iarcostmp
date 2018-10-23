//
//  OrderDetailTextFieldTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 21/02/2013.
//  Copyright (c) 2013 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailBaseTableCell.h"
#import "ArcosUtils.h"
#import "GlobalSharedClass.h"

@interface OrderDetailTextFieldTableCell : OrderDetailBaseTableCell<UITextFieldDelegate> {
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end
