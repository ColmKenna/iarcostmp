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

- (void)configCallInfoWithCallHeader:(OrderHeader*)aCallHeader {
    self.dateLabel.text = [ArcosUtils stringFromDate:aCallHeader.OrderDate format:[GlobalSharedClass shared].dateFormat];
    
    self.memoTextView.attributedText = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor systemOrangeColor]}] autorelease];
    if (aCallHeader.memo != nil) {
        NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:aCallHeader.memo.Details] attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor systemOrangeColor]}];
        self.memoTextView.attributedText = attributedDetailsString;
        [attributedDetailsString release];
    }
}

@end
