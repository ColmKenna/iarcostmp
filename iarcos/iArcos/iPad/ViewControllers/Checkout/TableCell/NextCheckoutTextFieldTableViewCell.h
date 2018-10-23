//
//  NextCheckoutTextFieldTableViewCell.h
//  iArcos
//
//  Created by David Kilmartin on 25/08/2016.
//  Copyright © 2016 Strata IT Limited. All rights reserved.
//

#import "NextCheckoutBaseTableViewCell.h"

@interface NextCheckoutTextFieldTableViewCell : NextCheckoutBaseTableViewCell <UITextFieldDelegate> {
    UITextField* _fieldValueTextField;
}

@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;

@end
