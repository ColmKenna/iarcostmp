//
//  CustomerContactDetailCallTableCell.m
//  iArcos
//
//  Created by Richard on 31/01/2025.
//  Copyright © 2025 Strata IT Limited. All rights reserved.
//

#import "CustomerContactDetailCallTableCell.h"

@implementation CustomerContactDetailCallTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.memoTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.memoTextView.layer setBorderWidth:0.5];
    [self.memoTextView.layer setCornerRadius:5.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
