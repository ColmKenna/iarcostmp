//
//  UtilitiesMemoryTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 20/03/2015.
//  Copyright (c) 2015 Strata IT Limited. All rights reserved.
//

#import "UtilitiesMemoryTableCell.h"

@implementation UtilitiesMemoryTableCell
@synthesize memoryType = _memoryType;
@synthesize memorySize = _memorySize;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.memoryType = nil;
    self.memorySize = nil;
    [super dealloc];
}

@end
