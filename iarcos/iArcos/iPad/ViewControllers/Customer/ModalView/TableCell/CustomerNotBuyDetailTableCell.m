//
//  CustomerNotBuyDetailTableCell.m
//  iArcos
//
//  Created by David Kilmartin on 29/03/2018.
//  Copyright © 2018 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyDetailTableCell.h"

@implementation CustomerNotBuyDetailTableCell
@synthesize myDescription = _myDescription;
@synthesize lastOrdered = _lastOrdered;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.myDescription = nil;
    self.lastOrdered = nil;
    
    [super dealloc];
}

@end
