//
//  UpdateStatusFunctionTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 13/04/2016.
//  Copyright (c) 2016 Strata IT Limited. All rights reserved.
//

#import "UpdateStatusFunctionTableViewCell.h"

@implementation UpdateStatusFunctionTableViewCell
@synthesize indicator = _indicator;
@synthesize branchProgressBar = _branchProgressBar;
@synthesize progressBar = _progressBar;
@synthesize updateStatus = _updateStatus;
@synthesize statusTitleLabel = _statusTitleLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.indicator = nil;
    self.branchProgressBar = nil;
    self.progressBar = nil;
    self.updateStatus = nil;
    self.statusTitleLabel = nil;
    
    [super dealloc];
}

@end
