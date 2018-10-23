//
//  SavedIarcosOrderDetailControlTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 06/11/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "SavedIarcosOrderDetailControlTableViewCell.h"

@implementation SavedIarcosOrderDetailControlTableViewCell
@synthesize controlButton = _controlButton;
@synthesize controlLabel = _controlLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.controlButton = nil;
    self.controlLabel = nil;
    
    [super dealloc];
}

@end
