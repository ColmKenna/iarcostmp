//
//  FlagsContactFlagTableViewCell.h
//  iArcos
//
//  Created by Richard on 17/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextInputTableViewCellDelegate.h"

@interface FlagsContactFlagTableViewCell : UITableViewCell <UITextFieldDelegate>{
    id<GenericTextInputTableViewCellDelegate> _delegate;
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<GenericTextInputTableViewCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) NSIndexPath* indexPath;

@end


