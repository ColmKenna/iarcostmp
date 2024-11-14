//
//  CustomerInfoBaseTableViewCell.m
//  iArcos
//
//  Created by Richard on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoBaseTableViewCell.h"

@implementation CustomerInfoBaseTableViewCell
@synthesize infoTitle = _infoTitle;
@synthesize infoValue = _infoValue;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
