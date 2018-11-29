//
//  MeetingBudgetDecimalTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 27/11/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "MeetingBudgetDecimalTableViewCell.h"

@implementation MeetingBudgetDecimalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.actionDelegate meetingBaseInputFinishedWithData:textField.text atIndexPath:self.myIndexPath];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* assembledString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return ([ArcosValidator isInputDecimalWithTwoPlaces:assembledString] || [assembledString isEqualToString:@""]);
}

@end
