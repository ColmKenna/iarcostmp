//
//  UploadFunctionTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UploadFunctionTableViewCell.h"

@implementation UploadFunctionTableViewCell
@synthesize uploadButton = _uploadButton;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.uploadButton = nil;
    
    [super dealloc];
}

- (IBAction)pressUploadFunctionButton:(id)sender {
    [self.myDelegate uploadFunctionButtonPressedDelegate];
}

@end
