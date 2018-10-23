//
//  FormRowsDividerHeaderTableViewCell.m
//  iArcos
//
//  Created by David Kilmartin on 20/06/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "FormRowsDividerHeaderTableViewCell.h"

@implementation FormRowsDividerHeaderTableViewCell
@synthesize descLabel = _descLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.descLabel = nil;
    
    [super dealloc];
}

@end
