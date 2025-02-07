//
//  DownloadFunctionTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "DownloadFunctionTableViewCell.h"
#import "UIColor+Hex.h"


@implementation DownloadFunctionTableViewCell
@synthesize myDelegate = _myDelegate;
@synthesize downloadButton = _downloadButton;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    // Set the border color
    UIColor *borderUIColor = [UIColor backgroundColor];
    _downloadButton.layer.borderColor = borderUIColor.CGColor;

    // Set the border width
    _downloadButton.layer.borderWidth = 1.0f;

    // Optional: Set the corner radius for rounded corners
    _downloadButton.layer.cornerRadius = 5.0f;
    _downloadButton.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.downloadButton = nil;
    
    [super dealloc];
}

- (IBAction)pressDownloadFunctionButton:(id)sender {
    [self.myDelegate downloadFunctionButtonPressedDelegate];
}

@end
