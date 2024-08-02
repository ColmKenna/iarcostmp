//
//  FormRowsKeyboardTableViewCell.h
//  iArcos
//
//  Created by Richard on 02/07/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcosUtils.h"
#import "FormRowsKeyboardTableViewCellDelegate.h"
#import "ArcosValidator.h"

@interface FormRowsKeyboardTableViewCell : UITableViewCell {
    id<FormRowsKeyboardTableViewCellDelegate> _myDelegate;
    UILabel* _detailsLabel;
    UITextField* _qtyTextField;
    UITextField* _bonusTextField;
    UITextField* _discountTextField;    
    NSMutableArray* _textFieldList;
//    int _currentTextFieldIndex;
    NSIndexPath* _myIndexPath;
//    BOOL _currentTextFieldHighlightedFlag;
}

@property(nonatomic, assign) id<FormRowsKeyboardTableViewCellDelegate> myDelegate;
@property(nonatomic, retain) IBOutlet UILabel* detailsLabel;
@property(nonatomic, retain) IBOutlet UITextField* qtyTextField;
@property(nonatomic, retain) IBOutlet UITextField* bonusTextField;
@property(nonatomic, retain) IBOutlet UITextField* discountTextField;
@property(nonatomic, retain) NSMutableArray* textFieldList;
//@property(nonatomic, assign) int currentTextFieldIndex;
@property(nonatomic, retain) NSIndexPath* myIndexPath;
//@property(nonatomic, assign) BOOL currentTextFieldHighlightedFlag;

- (void)configCellWithData:(NSMutableDictionary*)aData;

//- (IBAction)textFieldEditDidBegin:(id)sender;

@end


