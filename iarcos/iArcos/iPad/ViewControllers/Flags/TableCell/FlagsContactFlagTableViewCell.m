//
//  FlagsContactFlagTableViewCell.m
//  iArcos
//
//  Created by Richard on 17/10/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "FlagsContactFlagTableViewCell.h"

@implementation FlagsContactFlagTableViewCell
@synthesize delegate = _delegate;
@synthesize fieldNameLabel = _fieldNameLabel;
@synthesize fieldValueTextField = _fieldValueTextField;
@synthesize indexPath = _indexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.fieldNameLabel = nil;
    self.fieldValueTextField = nil;
    self.indexPath = nil;
    
    [super dealloc];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.delegate inputFinishedWithData:textField.text forIndexPath:self.indexPath];
}

@end
