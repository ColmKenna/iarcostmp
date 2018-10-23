//
//  NextCheckoutDeliveryInstructions1TableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 14/11/2017.
//  Copyright © 2017 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NextCheckoutBaseTableViewCell.h"

@interface NextCheckoutDeliveryInstructions1TableViewCell : NextCheckoutBaseTableViewCell <UITextFieldDelegate> {
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end
