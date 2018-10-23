//
//  CustomerNotBuyTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 14/12/2011.
//  Copyright (c) 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerNotBuyTableCell.h"

@implementation CustomerNotBuyTableCell

@synthesize productCode;
@synthesize description;
@synthesize lastOrdered;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    if (self.productCode != nil) {
        self.productCode = nil;
    }
    if (self.description != nil) {
        self.description = nil;
    }
    if (self.lastOrdered != nil) {
        self.lastOrdered = nil;
    }
    [super dealloc];
}
@end
