//
//  CustomerGroupWholesalerCodeTableViewCell.h
//  iArcos
//
//  Created by Apple on 05/06/2020.
//  Copyright © 2020 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerGroupBaseTableViewCell.h"


@interface CustomerGroupWholesalerCodeTableViewCell : CustomerGroupBaseTableViewCell <UITextFieldDelegate> {
    UITextField* _contentTextField;
}

@property(nonatomic, retain) IBOutlet UITextField* contentTextField;

@end


