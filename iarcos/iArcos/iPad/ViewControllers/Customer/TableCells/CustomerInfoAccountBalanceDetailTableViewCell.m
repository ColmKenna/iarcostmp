//
//  CustomerInfoAccountBalanceDetailTableViewCell.m
//  Arcos
//
//  Created by David Kilmartin on 12/01/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoAccountBalanceDetailTableViewCell.h"

@implementation CustomerInfoAccountBalanceDetailTableViewCell
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.infoTitle = nil;
    self.infoValue = nil;
    
    [super dealloc];
}

@end
