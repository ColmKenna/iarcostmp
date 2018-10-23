//
//  AccountNumberTableCell.h
//  Arcos
//
//  Created by David Kilmartin on 15/08/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GenericTextViewInputTableCellDelegate.h"
#import "GenericRefreshParentContentDelegate.h"

@interface AccountNumberTableCell : UITableViewCell<UITextFieldDelegate> {
    id<GenericTextViewInputTableCellDelegate> _delegate;
    UILabel* _fieldNameLabel;
    UITextField* _fieldValueTextField;
    NSIndexPath* _indexPath;
}

@property(nonatomic, assign) id<GenericTextViewInputTableCellDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel* fieldNameLabel;
@property(nonatomic, retain) IBOutlet UITextField* fieldValueTextField;
@property(nonatomic, retain) NSIndexPath* indexPath;

@end
