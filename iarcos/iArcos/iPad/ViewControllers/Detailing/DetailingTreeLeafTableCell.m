//
//  DetailingTreeLeafTableCell.m
//  iArcos
//
//  Created by Richard on 23/02/2023.
//  Copyright © 2023 Strata IT Limited. All rights reserved.
//

#import "DetailingTreeLeafTableCell.h"

@implementation DetailingTreeLeafTableCell
@synthesize flagBtn = _flagBtn;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.flagBtn = nil;
    
    [super dealloc];
}

@end
