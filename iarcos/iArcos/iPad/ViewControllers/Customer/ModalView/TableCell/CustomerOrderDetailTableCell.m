//
//  CustomerOrderDetailTableCell.m
//  Arcos
//
//  Created by David Kilmartin on 30/11/2011.
//  Copyright 2011 Strata IT Limited. All rights reserved.
//

#import "CustomerOrderDetailTableCell.h"


@implementation CustomerOrderDetailTableCell
@synthesize qty;
@synthesize bon;
@synthesize discount;
@synthesize description;
@synthesize price;
@synthesize value;

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
    if (self.qty != nil) { self.qty = nil; }
    if (self.bon != nil) { self.bon = nil; }
    if (self.discount != nil) { self.discount = nil; }    
    if (self.description != nil) { self.description = nil; }
    if (self.price != nil) { self.price = nil; }
    if (self.value != nil) { self.value = nil; }    
    
    [super dealloc];
}

@end
