//
//  CustomerListingCallTableViewCell.m
//  iArcos
//
//  Created by Richard on 30/10/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerListingCallTableViewCell.h"

@implementation CustomerListingCallTableViewCell

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

- (void)configCallInfoWithCallHeader:(OrderHeader*)anCallHeader {
    self.dateLabel.text = [ArcosUtils stringFromDate:anCallHeader.OrderDate format:[GlobalSharedClass shared].dateFormat];
    self.contactLabel.text = @"";
    if (anCallHeader.ContactIUR > 0) {
        NSMutableArray* contactList = [[ArcosCoreData sharedArcosCoreData] contactWithIUR:anCallHeader.ContactIUR];
        if ([contactList count] > 0) {
            NSString* fullName = @"";
            NSMutableDictionary* tmpContactDict = [contactList objectAtIndex:0];
            NSString* forename = [tmpContactDict objectForKey:@"Forename"];
            NSString* surname = [tmpContactDict objectForKey:@"Surname"];
            if (forename == nil) {
                forename = @"";
            }
            if (surname == nil) {
                surname = @"";
            }
            fullName = [NSString stringWithFormat:@"%@ %@", forename, surname];
            if ([forename isEqualToString:@""] && [surname isEqualToString:@""]) {
                fullName = @"Noname Staff";
            }
            self.contactLabel.text = fullName;
        }
    }
    self.memoTextView.attributedText = [[[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor systemOrangeColor]}] autorelease];
    if (anCallHeader.memo != nil) {
        NSMutableAttributedString* attributedDetailsString = [[NSMutableAttributedString alloc] initWithString:[ArcosUtils convertNilToEmpty:anCallHeader.memo.Details] attributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor systemOrangeColor]}];
        self.memoTextView.attributedText = attributedDetailsString;
        [attributedDetailsString release];
    }
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

@end
