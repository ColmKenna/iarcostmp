//
//  DownloadFunctionTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "DownloadFunctionTableViewCell.h"

@implementation DownloadFunctionTableViewCell
@synthesize myDelegate = _myDelegate;
@synthesize downloadButton = _downloadButton;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
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
