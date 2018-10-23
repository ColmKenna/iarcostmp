//
//  QueryOrderTaskControlMemoTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 25/09/2014.
//  Copyright (c) 2014 Strata IT Limited. All rights reserved.
//

#import "QueryOrderTaskControlMemoTableCell.h"

@implementation QueryOrderTaskControlMemoTableCell
@synthesize myControlLabel = _myControlLabel;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myControlLabel = nil;
    
    [super dealloc];
}

@end
