//
//  CustomerInfoNextCallTableViewCell.m
//  iArcos
//
//  Created by Richard on 14/11/2024.
//  Copyright © 2024 Strata IT Limited. All rights reserved.
//

#import "CustomerInfoNextCallTableViewCell.h"

@implementation CustomerInfoNextCallTableViewCell
@synthesize actionBtn = _actionBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.actionBtn = nil;
    
    [super dealloc];
}

@end
