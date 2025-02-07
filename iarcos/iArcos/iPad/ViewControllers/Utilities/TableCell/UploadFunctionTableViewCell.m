//
//  UploadFunctionTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UploadFunctionTableViewCell.h"
#import "UIColor+Hex.h"

@implementation UploadFunctionTableViewCell
@synthesize uploadButton = _uploadButton;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    UIColor *borderUIColor = [UIColor backgroundColor];
    _uploadButton.layer.borderColor = borderUIColor.CGColor;
    
    _uploadButton.layer.borderWidth = 1.0f;

    // Optional: Set the corner radius for rounded corners
    _uploadButton.layer.cornerRadius = 5.0f;
    _uploadButton.layer.masksToBounds = YES;
    
    

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
